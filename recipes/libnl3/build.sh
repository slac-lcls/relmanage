autoreconf -vif
./configure --disable-static --prefix=${PREFIX}
${BUILD_PREFIX}/bin/make -j ${CPU_COUNT}
${BUILD_PREFIX}/bin/make install
