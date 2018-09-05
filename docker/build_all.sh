#!/bin/bash

function build_image {
    os_name=$1
    os_version=$2
    py_version=$3

    if [[ $py_version == 2.7 ]]; then
        env_file=env_create_py2.yaml
    elif [[ $py_version == 3.* ]]; then
        env_file=env_create.yaml
    fi

    tag=slaclcls/travis:$os_name$os_version-py$py_version
    docker build --build-arg CONDA_ENV_FILE=$env_file -t $tag -f docker/Dockerfile.ubuntu . && docker push $tag

}

for py_version in 2.7 3.6; do
    build_image ubuntu 16.04 $py_version
    build_image centos 6 $py_version
done
