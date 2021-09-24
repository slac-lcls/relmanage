import pathlib
from typing import Dict

import click
import feedstock_utils
import yaml


repository_data: Dict[str, str] = {
    "cameralink-gateway": ("git@github.com:slaclab/cameralink-gateway"),
    "epix": "git@github.com:slaclab/epix",
    "lcls2-pgp-pcie-apps": ("git@github.com:slaclab/lcls2-pgp-pcie-apps"),
    "lcls2_timetool": "git@github.com:slaclab/lcls2-timetool",
    "epix-hr-single-10k": "git@github.com:slaclab/epix-hr-single-10k",
    "lcls2-epix-hr-pcie": ("git@github.com:slaclab/lcls2-epix-hr-pcie"),
}


@click.command()
@click.option(
    "--package-version-file",
    "-v",
    type=click.Path(exists=True),
    required=True,
    help="Path to a YAML file with the version of the packages for which the source"
    "package should be generated",
)
def prepare_source(package_version_file: str) -> None:

    with open(pathlib.Path(package_version_file)) as open_file:
        version_dict: Dict[str, str] = yaml.load(open_file, Loader=yaml.SafeLoader)

    for package in repository_data:

        if package not in version_dict:
            raise RuntimeError(f"Package {package} not found in version file")

        if pathlib.Path(
            f"/reg/g/psdm/web/swdoc/tutorials/{package}-"
            f"{version_dict[package]}.tar.gz"
        ).is_file():
            print(
                f"File {package}-{version_dict[package]}.tar.gz already"
                f"exists in /reg/g/psdm/web/swdoc/tutorials/. Skipping..."
            )
            continue
        
        repository: feedstock_utils.Repository = feedstock_utils.Repository(
            repository=repository_data[package], debug=False
        )
        repository.git_check_out_version(f"v{version_dict[package]}")
        repository.initialize_submodules()
        repository.update_submodules()
        repository.create_compressed_archive(
            f"{package}-{version_dict[package]}.tar.gz",
            include_dot_git=False,
            destination_directory=pathlib.Path("/reg/g/psdm/web/swdoc/tutorials/"),
        )


if __name__ == "__main__":
    prepare_source()
