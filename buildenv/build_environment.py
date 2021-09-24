import dataclasses
import datetime
import pathlib
import subprocess
import time
from typing import Dict, List

import click
import feedstock_utils
import rich
import yaml


@dataclasses.dataclass
class BuildStatus:
    status: str
    last_run_id: int


def build_wave(
    packages_to_build: Dict[str, feedstock_utils.Repository],
    package_build_status: Dict[str, BuildStatus],
    start_time: datetime.datetime,
) -> bool:

    wave_done: bool = False
    while not wave_done:
        current_time_str: str = datetime.datetime.strftime(
            datetime.datetime.now(), "%H:%M:%S on %Y-%m-%d"
        )
        rich.print(f"[bold]\nSummary: at {current_time_str}[/bold]")
        for package in packages_to_build:
            if package_build_status[package].status == "Not Started Yet":
                last_run: feedstock_utils.RunInfo = packages_to_build[
                    package
                ].get_latest_workflow_run_info()
                if last_run.get_creation_time() > start_time:
                    package_build_status[package].status = "Running"
                    package_build_status[package].last_run_id = last_run.get_run_id()
            elif package_build_status[package].status == "Running":
                run_info: feedstock_utils.RunInfo = packages_to_build[
                    package
                ].update_workflow_run_info(package_build_status[package].last_run_id)
                if run_info.get_status() == "completed":
                    if run_info.get_conclusion() == "success":
                        package_build_status[package].status = "Success"
                    else:
                        package_build_status[package].status = "Failed"
            rich.print(
                f"[bold] {package}:[/bold] {package_build_status[package].status}"
            )
        wave_done = True
        for package in packages_to_build:
            if (
                package_build_status[package].status != "Success"
                and package_build_status[package].status != "Failed"
            ):
                wave_done = False
        time.sleep(30)
    rich.print("[bold]\nDone building wave. Package status summary:[/bold]")
    all_succeeded: bool = True
    for package in packages_to_build:
        rich.print(f"[bold] {package}: {package_build_status[package].status}[/bold]")
        if package_build_status[package].status != "Success":
            all_succeeded = False
    if not all_succeeded:
        print(
            "[bold]One or more of the packages in the wave did not build "
            "correctly[/bold]"
        )
        return False
    else:
        return True


repository_data: List[Dict[str, str]] = [
    {
        "ami": "git@github.com:slac-lcls/ami-feedstock",
        "amityping": "git@github.com:slac-lcls/amityping-feedstock",
        "cameralink-gateway": (
            "git@github.com:slac-lcls/cameralink-gateway-feedstock"
        ),
        "epix": "git@github.com:slac-lcls/epix-feedstock",
        "lcls2-pgp-pcie-apps": (
            "git@github.com:slac-lcls/lcls2-pgp-pcie-apps-feedstock"
        ),
        "lcls2_timetool": "git@github.com:slac-lcls/lcls2_timetool-feedstock",
        "epix-hr-single-10k": "git@github.com:slac-lcls/epix-hr-single-10k-feedstock",
        "lcls2-epix-hr-pcie": (
            "git@github.com:slac-lcls/lcls2-epix-hr-pcie-feedstock"
        ),
        "libnl": "git@github.com:slac-lcls/libnl-feedstock",
        "libnl3": "git@github.com:slac-lcls/libnl3-feedstock",
        "networkfox": "git@github.com:slac-lcls/networkfox-feedstock",
        "prometheus-cpp": "git@github.com:slac-lcls/prometheus-cpp-feedstock",
        "psmon": "git@github.com:slac-lcls/psmon-feedstock",
        "roentdek": "git@github.com:slac-lcls/roentdek-feedstock",
        "xtcdata": "git@github.com:slac-lcls/xtcdata-feedstock",
    },
    {
        "rdma-core": "git@github.com:slac-lcls/rdma-core-feedstock",
        "psalg": "git@github.com:slac-lcls/psalg-feedstock",
    },
    {
        "libfabric": "git@github.com:slac-lcls/libfabric-feedstock",
        "psana": "git@github.com:slac-lcls/psana-feedstock",
    },
    {
        "psdaq": "git@github.com:slac-lcls/psdaq-feedstock",
    },
]


@click.command()
@click.option(
    "--generate-packages",
    "-g",
    type=bool,
    default=False,
    is_flag=True,
    help="Generate packages before building the environment. Default: false",
)
@click.option(
    "--build-environment",
    "-b",
    type=bool,
    default=False,
    is_flag=True,
    help="Create conda environment. Default: false",
)
@click.option(
    "--environment-name",
    "-n",
    type=str,
    help="Name of the environment to generate",
)
@click.option(
    "--environment-file",
    "-f",
    type=click.Path(exists=True),
    help="Path to a YAML file describing the environment to generate",
)
@click.option(
    "--package-version-file",
    "-v",
    type=click.Path(exists=True),
    help="Path to a YAML file with the version of the package to generate",
)
@click.option(
    "--start-from-wave",
    "-w",
    type=int,
    default=0,
    help="Wave to start the pacakge generation from",
)
@click.option(
    "--stop-at-wave",
    "-s",
    type=int,
    default=len(repository_data),
    help="Wave to stop the pacakge generation at",
)
def build_environment(
    generate_packages: bool,
    build_environment: bool,
    environment_name: str,
    environment_file: str,
    package_version_file: str,
    start_from_wave: int,
    stop_at_wave: int,
) -> None:

    if not generate_packages and not build_environment:

        ctx = click.get_current_context()
        click.echo(ctx.get_help())
        ctx.exit()

    if generate_packages:

        rich.print("[bold]Regenerating packages[/bold]")
        rich.print("[bold]-----[/bold]")
        if not package_version_file:
            raise RuntimeError(
                "Please specify the version file to use with the "
                "--package_version_file option"
            )

        with open(pathlib.Path(package_version_file)) as open_file:
            version_dict: Dict[str, str] = yaml.load(open_file, Loader=yaml.SafeLoader)

        wave_index: int
        wave: Dict[str, str]
        for wave_index, wave in enumerate(repository_data):
            if wave_index < start_from_wave:
                continue
            if wave_index > stop_at_wave:
                continue
            rich.print(f"[bold]Building wave {wave_index}...[/bold]")
            rich.print(f"[bold]Packages in the wave: {tuple(wave.keys())}[/bold]")
            start_time: datetime.datetime = datetime.datetime.now()
            packages_to_build: Dict[str, feedstock_utils.Repository] = {}
            package_build_status: Dict[str, BuildStatus] = {}
            package: str
            for package in wave:
                if package not in version_dict:
                    raise RuntimeError(f"Package {package} not found in version file")
            for package in wave:
                repository: feedstock_utils.Repository = feedstock_utils.Repository(
                    repository=wave[package], debug=False
                )
                repository.set_version_and_build_number(package, version_dict)
                repository.run_conda_smithy()
                repository.git_push()
                packages_to_build[package] = repository
                package_build_status[package] = BuildStatus(
                    status="Not Started Yet", last_run_id=0
                )
            wave_successful = build_wave(
                packages_to_build, package_build_status, start_time
            )
            if not wave_successful:
                rich.print(
                    f"[bold]Wave {wave_index} did not build correctly: stopping[/bold]"
                )

    if build_environment:

        rich.print("[bold]\nBuilding environment[/bold]")
        if not environment_name:
            raise RuntimeError(
                "Please specify the environment name with the --environment-name "
                "option"
            )
        if not environment_file:
            raise RuntimeError(
                "Please specify the file describing the environment with the "
                "--environment-file option"
            )

        rich.print(
            f"[bold]Building environment {environment_name} based on file "
            f"{environment_file}[/bold]"
        )

        rich.print(f"conda env create -n {environment_name} --file {environment_file}")
        return_code = subprocess.call(
            f"conda env create -n {environment_name} --file {environment_file}",
            shell=True,
        )
        if return_code != 0:
            raise RuntimeError(f"Error building {environment_name} repository")


if __name__ == "__main__":
    build_environment()
