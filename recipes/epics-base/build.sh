EPICS_BASE=$PREFIX/epics

EPICS_HOST_ARCH=$(startup/EpicsHostArch)
export EPICS_HOST_ARCH

GNU_DIR=$(dirname $(dirname $(which x86_64-conda_cos6-linux-gnu-gcc)))
if [ "$GNU_DIR" != "/usr" ]; then
    echo "GNU_DIR="$GNU_DIR >> configure/CONFIG_COMMON
    echo "CMPLR_PREFIX=x86_64-conda_cos6-linux-gnu-" >> configure/CONFIG_COMMON
    sed -i  "s|USR_CXXFLAGS =|USR_CXXFLAGS = -std=c++11|" configure/CONFIG_COMMON
    # sed -i  "s|USR_INCLUDES =|USR_INCLUDES = -I$CONDA_PREFIX/include|" configure/CONFIG_COMMON
    # sed -i  "s|USR_LDFLAGS =|USR_LDFLAGS = -L$CONDA_PREFIX/lib -Wl,-rpath,$CONDA_PREFIX/lib|" configure/CONFIG_COMMON
fi

make -j $CPU_COUNT INSTALL_LOCATION=$EPICS_BASE

mkdir -p $PREFIX/etc/conda/activate.d
mkdir -p $PREFIX/etc/conda/deactivate.d
ACTIVATE=$PREFIX/etc/conda/activate.d/epics_base.sh
DEACTIVATE=$PREFIX/etc/conda/deactivate.d/epics_base.sh
echo "export EPICS_BASE="$EPICS_BASE >> $ACTIVATE
echo "export EPICS_HOST_ARCH="$EPICS_HOST_ARCH >> $ACTIVATE
echo "unset EPICS_BASE" >> $DEACTIVATE
echo "unset EPICS_HOST_ARCH" >> $DEACTIVATE
unset ACTIVATE
unset DEACTIVATE
