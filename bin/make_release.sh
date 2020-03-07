#!/bin/bash
# Build lcls2 packages and create a new conda release version

set -e

if [ $# -eq 0 ]; then
    echo "Usage: ./make_release.sh version"
    echo "To auto build and upload lcls2 packages and create new conda environment with the specified version number."
    exit 0
fi 

pkgs=("xtcdata" "psalg" "psana" "psdaq" "ami")
pyver="3.7"
reldir="/reg/g/psdm/sw/conda2/manage/recipes/"
channel="lcls-ii"
version=${1}

echo "Build lcls2 packages and upload to $channel"

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
