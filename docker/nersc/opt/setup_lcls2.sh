#!/usr/bin/env bash


# load conda stuff
source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/env/env.sh

# create a new env so that all the dependencies are not tied to 
# the base environment.
conda create --name $CONDA_ENV psana-conda

# remove mpi (mpich or openmpi) with --force to leave mpi4py inplace
# this makes sure that mpi4py is compatible with mpich
source activate $CONDA_ENV
conda uninstall -y --force openmpi

