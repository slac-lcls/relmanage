lcls2conda="/reg/g/psdm/sw/conda2/inst"
# the official way to pick up the modern compilers, but starts a shell :-(
#scl enable devtoolset-7 "bash --rcfile ~psrel/.bashrc_lcls2"
rhel_version=$(less /etc/redhat-release | grep -o -E '[0-9]+' | head -1)
export PATH=$lcls2conda/bin:/opt/rh/devtoolset-$rhel_version/root/usr/bin:$PATH
unset LD_LIBRARY_PATH
unset PYTHONPATH
source activate ps-0.0.5
