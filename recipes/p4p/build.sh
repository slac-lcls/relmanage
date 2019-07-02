#!/bin/bash

cat <<EOF > configure/RELEASE.local
EPICS_BASE=$EPICS_BASE
EOF

# setup the compiler environment variables needed by EPICS
source $RECIPE_DIR/find_compiler.sh

make
INSTDIR=$PREFIX/lib/python$PY_VER/site-packages
mkdir -p $INSTDIR
cp -r python${PY_VER}m/$EPICS_HOST_ARCH/p4p $INSTDIR
