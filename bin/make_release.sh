# Build lcls2 packages and create a new conda release version
# NOTE: Run this under the same shell ("source ...") to avoid misplacing
# the new environment created in this script.  We don't understand why
# running it in a different shell with "#!/bin/bash" doesn't work
# (perhaps because we don't have psconda.sh in psrel's .bashrc?)
# - mona and cpo

set -e

helps="Usage: cmd [-h] [-t pkg,pkg] version" 

if [ $# -eq 0 ]; then
    echo $helps
    return 0
fi 

target="xtcdata,psalg,psana,psdaq,ami" # default packages
channel="lcls-ii" # default channel

# to pick up conda_build_config.yaml
cd /cds/sw/ds/ana/conda2/manage/recipes

while getopts "ht:c:" opt; do
    case ${opt} in
        h ) echo $helps
            return 0
            ;;
        t ) 
            target=$OPTARG
            ;;
        c ) 
            channel=$OPTARG
            ;;
        \? ) echo $helps
            return 0
            ;;
    esac
done
shift $((OPTIND -1))

version=${1}

if [ -z "$version" ]; then echo $helps; return; fi

IFS=',' read -ra pkgs <<< "$target"
pyver="3.7"
reldir="/cds/sw/ds/ana/conda2/manage/recipes"

echo "Build $target and upload to $channel for release: $version"

for pkg in "${pkgs[@]}"
do
    echo "Start building $pkg"
    conda build ${reldir}/$pkg --python $pyver > .make_release_log$pkg
    pkg_path=`grep "anaconda upload" .make_release_log$pkg | awk '{ print $3 }'`
    echo "Uploading $pkg_path to $channel channel"
    anaconda upload --force -u $channel $pkg_path
done

echo "Create new default environment $version"
#conda create -y --name $version python=$pyver psdaq ami
conda env create --name $version --file /cds/sw/ds/ana/conda2/manage/prod_create.yaml

echo "Removing make release log files"
rm .make_release_log*

echo "Done"
