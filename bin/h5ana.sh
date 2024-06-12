unset LD_LIBRARY_PATH
unset PYTHONPATH

if [ -d "/sdf/group/lcls/" ]
then
    # for s3df
    source /sdf/group/lcls/ds/ana/sw/conda2/inst/etc/profile.d/conda.sh
    export CONDA_ENVS_DIRS=/sdf/group/lcls/ds/ana/sw/conda2/inst/envs
else
    # for old psana system
    echo "old psana system not supported for h5 conda env"
    exit 1
fi

conda activate h5-1.0.2
