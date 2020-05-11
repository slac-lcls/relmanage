mkdir build
cd build
${BUILD_PREFIX}/bin/cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_PREFIX_PATH=${PREFIX} ..
${BUILD_PREFIX}/bin/make
${BUILD_PREFIX}/bin/make install
