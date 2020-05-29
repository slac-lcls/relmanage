#!/usr/bin/env bash


# load conda stuff
source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/env/env.sh


# install psana and force choice of mpich
conda install -y mpich=3.3.2 psana


# remove mpich --force to leave mpi4py inplace
# this makes sure that mpi4py is compatible with mpich
conda uninstall -y --force mpich

