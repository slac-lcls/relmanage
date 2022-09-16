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

conda activate ps-4.4.10

# cpo: seems that in more recent versions blas is creating many threads
export OPENBLAS_NUM_THREADS=1
# cpo: getting intermittent file-locking issue on ffb, so try this
export HDF5_USE_FILE_LOCKING=FALSE
# Mikhail: root of psdm directories
export DIR_PSDM=/cds/group/psdm

if [ ! -d /usr/share/X11/xkb ]; then
    export QT_XKB_CONFIG_ROOT=${CONDA_PREFIX}/lib
fi
