#!/bin/bash

set -e

wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p $CONDA_PREFIX
conda update -y conda
conda install -y conda-build
ls -l
ls -l recipes
conda build recipes/$PACKAGE/ --python $PYVER
rm Miniconda3-latest-Linux-x86_64.sh
