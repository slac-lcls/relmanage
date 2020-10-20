unset LD_LIBRARY_PATH
unset PYTHONPATH
source /reg/g/psdm/sw/conda2/inst/etc/profile.d/conda.sh
# kludge: somehow conda activate is executing rogue stuff before
# LD_LIBRARY_PATH is set to pick up the ugly location of epics
export LD_LIBRARY_PATH=/reg/g/psdm/sw/conda2/inst/envs/ps-3.0.22/epics/lib/linux-x86_64:/reg/g/psdm/sw/conda2/inst/envs/ps-3.0.22/pcas/lib/linux-x86_64
conda activate ps-3.0.22

if [ ! -d /usr/share/X11/xkb ]; then
    export QT_XKB_CONFIG_ROOT=${CONDA_PREFIX}/lib
fi
