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


docker build                                \
    -t slaclcls/lcls-py3:latest                  \
    -f $project_root/docker/Dockerfile.base \
    --no-cache  \
    $project_root 
