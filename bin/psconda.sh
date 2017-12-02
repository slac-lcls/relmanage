lcls2conda="/reg/g/psdm/sw/conda2/inst"
# the official way to pick up the modern compilers, but starts a shell :-(
#scl enable devtoolset-7 "bash --rcfile ~psrel/.bashrc_lcls2"
export PATH=$lcls2conda/bin:/opt/rh/devtoolset-7/root/usr/bin:$PATH
unset LD_LIBRARY_PATH
unset PYTHONPATH
source activate ps-0.0.1
