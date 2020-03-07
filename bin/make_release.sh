#!/bin/bash
# Build lcls2 packages and create a new conda release version

set -e

helps="Usage: cmd [-h] [-t pkg,pkg] version" 

if [ $# -eq 0 ]; then
    echo $helps
    exit 0
fi 

target="xtcdata,psalg,psana,psdaq,ami" # default packages

while getopts "ht:" opt; do
    case ${opt} in
        h ) echo $helps
            exit 0
            ;;
        t ) 
            target=$OPTARG
            ;;
        \? ) echo $helps
            exit 0
            ;;
    esac
done
shift $((OPTIND -1))

version=${1}

if [ -z "$version" ]; then echo $helps; exit; fi

IFS=',' read -ra pkgs <<< "$target"
pyver="3.7"
reldir="/reg/g/psdm/sw/conda2/manage/recipes/"
channel="lcls-ii"

echo "Build $target and upload to $channel for release: $version"

for pkg in "${pkgs[@]}"
do
    echo "Start building $pkg"
    conda build ${reldir}/$pkg --python $pyver > .make_release_log$pkg
    pkg_path=`grep "anaconda upload" .make_release_log$pkg | awk '{ print $3 }'`
    echo "Uploading $pkg_path to $channel channel"
    anaconda upload -u $channel $pkg_path
done

echo "Create new default environment $version"
conda create -c $channel --name $version python=$pyver psdaq ami

echo "Removing make release log files"
rm .make_release_log*

echo "Done"
