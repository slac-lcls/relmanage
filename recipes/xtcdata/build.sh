cd xtcdata
mkdir build
cd build
${BUILD_PREFIX}/bin/cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_PREFIX_PATH=${PREFIX} -DCMAKE_BUILD_TYPE=Release ..
${BUILD_PREFIX}/bin/make -j ${CPU_COUNT}
${BUILD_PREFIX}/bin/make install
