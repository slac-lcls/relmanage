#!/usr/bin/env bash


# load conda stuff
source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/env/env.sh

# create a new env so that all the dependencies are not tied to 
# the base environment. We also need to install mpich here (just
# to force remove it later). The correct mpich gets picked up
# from LD_LIBRARY_PATH=/opt/udiImage/modules/mpich/lib64 when
# shifter images are pulled at Nersc.
conda create --name $CONDA_ENV mpich=3.3.2 psana-conda

# remove mpi (mpich or openmpi) with --force to leave mpi5py inplace
# this makes sure that mpi4py is compatible with mpich
source activate $CONDA_ENV
conda uninstall -y --force mpich

