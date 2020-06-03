#!/usr/bin/env bash


set -e


# Cori has a dedicated `git-lfs module`
if [[ $NERSC_HOST = "cori" ]]; then
    module load git-lfs
fi

git lfs install
git lfs pull
git submodule update --init


# use absolute paths:
project_root=$(readlink -f $(dirname ${BASH_SOURCE[0]}))

PSANA_PKG_NAME="psana-conda"
PSANA_VERSION=2.0.6

docker build                                    \
    -t slaclcls/lcls-py2:latest                    \
    -t slaclcls/lcls-py2:ana-$PSANA_VERSION         \
    -f $project_root/docker/Dockerfile.base     \
    --no-cache                                  \
    --build-arg PYVER=2.7                       \
    --build-arg PSANA_PKG_NAME=$PSANA_PKG_NAME  \
    --build-arg PSANA_VERSION=$PSANA_VERSION    \
    $project_root 
