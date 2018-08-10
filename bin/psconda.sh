rhel_version=$(less /etc/redhat-release | grep -o -E '[0-9]+' | head -1)
# redirect errors to /dev/null to avoid errors on nodes without devtoolset
source scl_source enable devtoolset-$rhel_version >& /dev/null
unset LD_LIBRARY_PATH
unset PYTHONPATH
source /reg/g/psdm/sw/conda2/inst/etc/profile.d/conda.sh
conda activate ps-0.1.1
export MANPATH=$CONDA_PREFIX/share/man
