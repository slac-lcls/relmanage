#!/bin/bash

EPICS_BASE=${PREFIX}/epics

EPICS_HOST_ARCH=$(startup/EpicsHostArch)
export EPICS_HOST_ARCH

# setup the compiler environment variables needed by EPICS
source $RECIPE_DIR/find_compiler.sh

${BUILD_PREFIX}/bin/make -j ${CPU_COUNT} INSTALL_LOCATION=${EPICS_BASE}

# Symlink libraries into ${PREFIX}/lib
cd ${PREFIX}/lib
find ../epics/lib/${EPICS_HOST_ARCH}/ -name \*.so\* -exec ln -vs "{}" . ';' || : # linux
find ../epics/lib/${EPICS_HOST_ARCH}/ -name \*.dylib\* -exec ln -vs "{}" . ';' || : # osx
cd -

# Setup symlinks for utilities
BINS="caget caput camonitor softIoc caRepeater cainfo p2p pvget pvinfo pvlist pvput pvcall softIocPVA"
cd ${PREFIX}/bin
for file in ${BINS} ; do
    ln -vs ../epics/bin/${EPICS_HOST_ARCH}/$file .
done
cd -

mkdir -p ${PREFIX}/etc/conda/activate.d
mkdir -p ${PREFIX}/etc/conda/deactivate.d
ACTIVATE=${PREFIX}/etc/conda/activate.d/epics_base.sh
DEACTIVATE=${PREFIX}/etc/conda/deactivate.d/epics_base.sh
echo "export EPICS_BASE="${EPICS_BASE} >> ${ACTIVATE}
echo "export EPICS_HOST_ARCH="${EPICS_HOST_ARCH} >> ${ACTIVATE}
echo "unset EPICS_BASE" >> ${DEACTIVATE}
echo "unset EPICS_HOST_ARCH" >> ${DEACTIVATE}
unset ACTIVATE
unset DEACTIVATE
