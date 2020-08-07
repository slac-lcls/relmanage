#!/bin/bash

mkdir build
cd build
cmake .. -DNO_EPICS=1 -DROGUE_INSTALL=conda -DROGUE_DIR=${PREFIX} -DCMAKE_BUILD_TYPE=RelWithDebInfo
make -j ${CPU_COUNT} install
