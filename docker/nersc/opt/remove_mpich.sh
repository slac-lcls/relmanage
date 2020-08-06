#!/usr/bin/env bash


set -e


# load conda stuff
source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/env/env.sh
source activate $CONDA_ENV


conda uninstall -y --force mpich
