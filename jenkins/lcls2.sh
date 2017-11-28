#!/bin/bash
source /reg/g/psdm/sw/conda2/manage/bin/psconda.sh
cd $WORKSPACE
rm -rf build
mkdir build
cd build
cmake ..
make
make test
