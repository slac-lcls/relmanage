#!/bin/bash

echo "EPICS BASE IS $EPICS_BASE"
cat <<EOF > configure/RELEASE.local
EPICS_BASE=$EPICS_BASE
EOF

# setup the compiler environment variables needed by EPICS
source $RECIPE_DIR/find_compiler.sh

make -j $CPU_COUNT INSTALL_LOCATION=$PREFIX/pcas

# Symlink libraries into $PREFIX/lib
cd $PREFIX/lib
find ../epics/lib/$EPICS_HOST_ARCH/ -name \*.so\* -exec ln -vs "{}" . ';' || : # linux
find ../epics/lib/$EPICS_HOST_ARCH/ -name \*.dylib\* -exec ln -vs "{}" . ';' || : # osx
cd -

# Setup symlinks for utilities
BINS="aitGen caDirServ excas genApps"
cd $PREFIX/bin
for file in $BINS ; do
    ln -vs ../pcas/bin/$EPICS_HOST_ARCH/$file .
done
cd -
