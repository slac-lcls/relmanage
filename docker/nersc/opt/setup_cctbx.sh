#!/usr/bin/env bash


set -e


# load conda stuff
source $(readlink -f $(dirname ${BASH_SOURCE[0]}))/env/env.sh
source activate $CONDA_ENV


# install extras for cctbx
pip install procrunner
conda install -y wxpython


# get the directory of this pipeline
my_dir=$(dirname ${BASH_SOURCE[0]})
pipeline_dir=$(readlink -f $my_dir)


#
# Build CCTBX
#

export CCTBX_PREFIX=$pipeline_dir/cctbx
mkdir -p $CCTBX_PREFIX
pushd $CCTBX_PREFIX
wget https://raw.githubusercontent.com/cctbx/cctbx_project/master/libtbx/auto_build/bootstrap.py
# TODO: use Billy's new compiler wrappers, etc
python bootstrap.py hot update build --builder=dials --use-conda $CONDA_PREFIX --nproc=4 --config-flags="--enable_openmp_if_possible=True"
popd
