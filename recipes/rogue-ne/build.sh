#!/bin/bash

mkdir build
cd build
# cpo hack: for some reason rogue's conda build finds a 3.6 libpython, so
# we get this at runtime:
# ImportError: libpython3.6m.so.1.0: cannot open shared object file: No such file or directory
sed -i 's/3.6/3.7/' ../CMakeLists.txt
# cpo added -DNO_EPICS=1 to standard conda recipe from
# anaconda.org/tidair-tag
${BUILD_PREFIX}/bin/cmake .. -DROGUE_INSTALL=conda -DROGUE_DIR=${PREFIX} -DNO_EPICS=1
${BUILD_PREFIX}/bin/make -j ${CPU_COUNT} install
