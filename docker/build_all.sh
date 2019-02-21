#!/bin/bash

function build_image {
    os_name=$1
    os_version=$2
    py_version=$3

    env_file=temp.yaml
    sed s/PYTHONVER/$py_version/ env_create.yaml > $env_file

    tag=slaclcls/travis:$os_name$os_version-py$py_version
    docker build --build-arg CONDA_ENV_FILE=$env_file -t $tag -f docker/Dockerfile.$os_name . && docker push $tag

}

for py_version in 2.7 3.6; do
    build_image ubuntu 16.04 $py_version
    build_image centos 7 $py_version
done
