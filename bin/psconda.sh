unset LD_LIBRARY_PATH
unset PYTHONPATH

v2=0
for arg in "$@"
do
  if [ "$arg" == "-v2" ]
  then
    v2=1
  fi
done
if [ $v2 -eq 1 ]
then
   source /cds/sw/ds/ana/conda2-v2/inst/etc/profile.d/conda.sh
   export CONDA_ENVS_DIRS=/cds/sw/ds/ana/conda2/inst/envs/ 
else
   source /cds/sw/ds/ana/conda2/inst/etc/profile.d/conda.sh
fi

# kludge: somehow conda activate is executing rogue stuff before
# LD_LIBRARY_PATH is set to pick up the ugly location of epics
#export LD_LIBRARY_PATH=/cds/sw/ds/ana/conda2/inst/envs/ps-4.4.1/epics/lib/linux-x86_64:/cds/sw/ds/ana/conda2/inst/envs/ps-4.4.1/pcas/lib/linux-x86_64
conda activate ps-4.4.8

# cpo: seems that in more recent versions blas is creating many threads
export OPENBLAS_NUM_THREADS=1

if [ ! -d /usr/share/X11/xkb ]; then
    export QT_XKB_CONFIG_ROOT=${CONDA_PREFIX}/lib
fi
