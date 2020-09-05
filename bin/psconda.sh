unset LD_LIBRARY_PATH
unset PYTHONPATH
source /reg/g/psdm/sw/conda2/inst/etc/profile.d/conda.sh
conda activate ps-3.0.14

if [ ! -d /usr/share/X11/xkb ]; then
    export QT_XKB_CONFIG_ROOT=${CONDA_PREFIX}/lib
fi
