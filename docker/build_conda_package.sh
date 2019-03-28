#!/bin/bash

function build_image {
    os_name=$1
    os_version=$2
    py_version=$3

    docker build --build-arg SETUP_SCRIPT=docker/conda_build.sh --build-arg PYVER=$py_version --build-arg PACKAGE=$PACKAGE -f docker/Dockerfile.$os_name .
}

for py_version in ${PYVER:-2.7 3.6}; do
    build_image centos 7 $py_version
done
