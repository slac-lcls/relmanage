import datetime
import os
import pathlib
import shutil
import subprocess
from typing import Any, cast, Dict, List, Union

import jinja2
import requests
import rich

try:
    GITHUB_ACCESS_TOKEN: str = os.environ["GITHUB_ACCESS_TOKEN"]
except KeyError:
    raise RuntimeError("GITHUB ACCESS TOKEN environment variable not defined")
GITHUB_OWNER: str = "slac-lcls"


def compute_checksum_of_source_url(full_url: str) -> str:
    curl_proc = subprocess.Popen(  # TODO: Type
        f"curl -L {full_url} | sha256sum",
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=True,
    )
    curl_proc.wait()
    out: bytes
    err: bytes
    (out, err) = curl_proc.communicate()
    if curl_proc.returncode != 0:
        raise RuntimeError(
            f"Error: Checksum of {str(full_url)} source file failed! \n {str(err)}"
        )
    else:
        return out.split()[0].decode("utf-8")


class GitHubRestAPI:
    #    def __init__(self, owner: str, token: str, repository: str):
    def __init__(self, owner: str, repository: str):
        self._url = f"https://api.github.com/repos/{owner}/{repository}"
        self._headers: Dict[str, str] = {
            "Accept": "application/vnd.github.v3+json",
            "Authorization": f"token {GITHUB_ACCESS_TOKEN}",
        }

    def get(self, api: str) -> Dict[str, Any]:
        return cast(
            Dict[str, Any],
            requests.get(headers=self._headers, url=f"{self._url}/{api}").json(),
        )


class RunInfo:
    def __init__(self, json_data: Dict[str, Any]) -> None:
        self._json: Dict[str, Any] = json_data

    def get_creation_time(self) -> datetime.datetime:
        return datetime.datetime.strptime(
            self._json["created_at"], "%Y-%m-%dT%H:%M:%SZ"
        )

    def get_run_id(self) -> int:
        return cast(int, self._json["id"])

    def get_status(self) -> str:
        return cast(str, self._json["status"])

    def get_conclusion(self) -> str:
        return cast(str, self._json["conclusion"])


class Recipe:
    def __init__(self, local_repository_path: pathlib.Path) -> None:
        with open(local_repository_path / "recipe/meta.yaml") as open_file:
            self._lines: List[str] = open_file.readlines()
            self._repository_path: pathlib.Path = local_repository_path

    def get_source_url(self) -> str:
        for line in self._lines:
            if line.startswith("  url: "):
                return line.split("  url: ")[1]
        return ""

    def get_current_version(self) -> str:
        for line in self._lines:
            if line.startswith("{% set version = "):
                return line.split("{% set version = ")[1].split("%}")[0].strip()[1:-1]
        return "0.0.0"

    def set_version(self, new_version: str) -> None:
        for line_index, line in enumerate(self._lines):
            if line.startswith("{% set version = "):
                self._lines[line_index] = f'{{% set version = "{new_version}" %}}\n'

    def get_current_build_number(self) -> int:
        for line in self._lines:
            if line.startswith("  number: "):
                build_number = int(line.split("number:")[1])
                return build_number
        return 0

    def set_build_number(self, new_build_number: int) -> None:
        for line_index, line in enumerate(self._lines):
            if line.startswith("  number: "):
                self._lines[line_index] = f"  number: {new_build_number}\n"

    def set_source_checksum(self, checksum: str) -> None:
        for line_index, line in enumerate(self._lines):
            if line.startswith("  sha256: "):
                self._lines[line_index] = f"  sha256: {checksum}\n"

    def save_recipe(self) -> None:
        with open(
            pathlib.Path(self._repository_path) / "recipe/meta.yaml", "w"
        ) as open_file:
            open_file.writelines(self._lines)


class Repository:
    def __init__(self, repository: str, debug: bool = False) -> None:
        self._local_repository_path: pathlib.Path = pathlib.Path(
            repository.split("/")[-1]
        )
        self._repository_name = repository.split("/")[-1]
        if debug is True:
            rich.print(f"[bold]Resetting repository {repository}[/bold]")
            return_code: int = subprocess.call(
                " git reset --hard origin/master",
                shell=True,
                cwd=self._local_repository_path,
            )
            if return_code != 0:
                raise RuntimeError(f"Error resetting {repository} repository")
        else:
            rich.print(
                f"[bold]Deleting old version of {repository} repository....[/bold]"
            )
            shutil.rmtree(self._local_repository_path, ignore_errors=True)
            rich.print(f"[bold]Cloning {repository} repository....[/bold]")
            return_code = subprocess.call(f"git clone {repository}", shell=True)
            if return_code != 0:
                raise RuntimeError(f"Error cloning {repository} repository")
        self._github_rest_api: GitHubRestAPI = GitHubRestAPI(
            owner=GITHUB_OWNER,
            repository=self._repository_name,
        )

    def set_version_and_build_number(
        self, package: str, version_dict: Dict[str, str]
    ) -> None:
        recipe: Recipe = self.get_recipe()
        current_version: Union[str, None] = recipe.get_current_version()
        if current_version is None:
            raise RuntimeError(f"Error extracting current version of package {package}")
        current_build_number: Union[int, None] = recipe.get_current_build_number()
        if current_build_number is None:
            raise RuntimeError(
                f"Error extracting current build number for package {package}"
            )
        requested_version: str = str(version_dict[package])
        rich.print(f"[bold]Package: {package}[/bold]")
        rich.print(f"[bold]  Current version of package is {current_version}[/bold]")
        rich.print(
            f"[bold]  Current build number of package is {current_build_number}[/bold]"
        )
        rich.print(
            f"[bold]  Requested version of package is {requested_version}[/bold]"
        )
        if requested_version == current_version:
            new_build_number: int = current_build_number + 1
            rich.print("[bold]  No version update![/bold]")
            recipe.set_build_number(new_build_number)
            rich.print(
                f"[bold]  New build number of package is {new_build_number}[/bold]"
            )
            recipe.save_recipe()
            self.git_add_and_commit("[bold]Bumped build number[/bold]")
        else:
            rich.print("[bold]  Update to new version[/bold]")
            recipe.set_version(requested_version)
            recipe.set_build_number(0)
            rich.print(
                "[bold]  New version number of the package is "
                f"{requested_version}[/bold]"
            )
            rich.print("[bold]  New build number of package is 0[/bold]")
            url_template: jinja2.Template = jinja2.Template(recipe.get_source_url())
            full_url: str = str(
                url_template.render(name=package, version=requested_version)
            )
            sha256: str = compute_checksum_of_source_url(full_url)
            recipe.set_source_checksum(sha256)
            recipe.save_recipe()
            self.git_add_and_commit(f"Bumped version to {requested_version}")

    def get_recipe(self) -> Recipe:
        return Recipe(self._local_repository_path)

    def git_add_and_commit(self, commit_message: str) -> None:
        rich.print(
            f"[bold]Adding modified files in repository {self._local_repository_path} "
            "to staging space...[/bold]"
        )
        return_code = subprocess.call(
            "git add -u", shell=True, cwd=self._local_repository_path
        )
        if return_code != 0:
            raise RuntimeError(
                f"Error adding file to {self._repository_name} repository"
            )
        rich.print(
            f"[bold]Committing files in {self._local_repository_path} with the "
            f"message {commit_message}[/bold]"
        )
        return_code = subprocess.call(
            f'git commit -m "{commit_message}"',
            shell=True,
            cwd=self._local_repository_path,
        )
        if return_code != 0:
            raise RuntimeError(
                f"Error committimg changes to {self._repository_name} repository"
            )

    def initialize_submodules(self) -> None:
        rich.print(
            f"[bold]Initializing submodules in repository {self._repository_name}"
            "[/bold]"
        )
        return_code = subprocess.call(
            "git submodule init",
            shell=True,
            cwd=self._local_repository_path,
        )
        if return_code != 0:
            raise RuntimeError(
                "[bold]Error initializing submodules in repository "
                f"{self._repository_name}[/bold]"
            )

    def update_submodules(self) -> None:
        rich.print(
            f"[bold]Updating submodules in repository {self._repository_name}[/bold]"
        )
        return_code = subprocess.call(
            "git submodule update",
            shell=True,
            cwd=self._local_repository_path,
        )
        if return_code != 0:
            raise RuntimeError(
                f"Error initializing submodules in repository {self._repository_name} "
            )

    def git_check_out_version(self, version: str) -> None:
        rich.print(
            f"[bold]Checking out version {version} from "
            "{self._repository_name}[/bold]"
        )
        return_code = subprocess.call(
            f"git checkout {version}",
            shell=True,
            cwd=self._local_repository_path,
        )
        if return_code != 0:
            raise RuntimeError(
                f"Error checkout out version {version} in {self._repository_name} "
                "repository"
            )

    def git_push(self) -> None:
        rich.print(f"[bold]Pusing commits to {self._repository_name}" "[/bold]")
        return_code = subprocess.call(
            "git push",
            shell=True,
            cwd=self._local_repository_path,
        )
        if return_code != 0:
            raise RuntimeError(
                f"Error pushing commits to {self._repository_name} repository"
            )

    def create_compressed_archive(
        self,
        archive_name: str,
        destination_directory: pathlib.Path = pathlib.Path().cwd(),
        include_dot_git: bool = True,
    ) -> None:
        if include_dot_git:
            tar_exclude: str = ""
        else:
            tar_exclude = "--exclude=.git"
        return_code = subprocess.call(
            f"tar cfz {archive_name} {tar_exclude}  {self._local_repository_path}",
            shell=True,
            cwd=self._local_repository_path.parent,
        )
        if return_code != 0:
            raise RuntimeError(f"Error creating {archive_name} compressed archive")
        source_file: pathlib.Path = (
            self._local_repository_path.parent / f"{archive_name}"
        )
        dest_file: pathlib.Path = destination_directory / f"{archive_name}"
        rich.print(f"[bold]Moving {archive_name} archive to {destination_directory}")
        try:
            shutil.copy(source_file, dest_file)
        except shutil.SameFileError:
            pass

    def run_conda_smithy(self) -> None:
        rich.print(
            f"[bold]Running conda smithy in repository {self._local_repository_path}"
            "[/bold]"
        )
        return_code = subprocess.call(
            "conda smithy rerender -c auto", shell=True, cwd=self._local_repository_path
        )
        if return_code != 0:
            raise RuntimeError(
                f"Error pushing commits to {self._repository_name} repository"
            )

    def get_latest_workflow_run_info(self) -> RunInfo:
        return RunInfo(self._github_rest_api.get("actions/runs")["workflow_runs"][0])

    def update_workflow_run_info(self, run_number: int) -> RunInfo:
        return RunInfo(self._github_rest_api.get(f"actions/runs/{run_number}"))
