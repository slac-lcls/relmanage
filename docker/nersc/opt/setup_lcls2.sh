#!/usr/bin/env bash


# load conda stuff
source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/env/env.sh


# create a new env so that all the dependencies are not tied to 
# the base environment. We also need to install mpich here (just
# to force remove it later). The correct mpich gets picked up
# from LD_LIBRARY_PATH=/opt/udiImage/modules/mpich/lib64 when
# shifter images are pulled at Nersc.
conda create --name $CONDA_ENV python=$PYVER mpich=3.3.2 $PSANA_PKG_NAME=$PSANA_VERSION


source activate $CONDA_ENV


# install experiment db (to support psana1)
conda install psana-expdb -c lcls-rhel7


# remove mpi (mpich or openmpi) with --force to leave mpi4py inplace
# this makes sure that mpi4py is compatible with mpich
conda uninstall -y --force mpich

