${BUILD_PREFIX}/bin/make PSM_USE_SYS_UUID=1 -j ${CPU_COUNT}
DESTDIR=${PREFIX} libdir=/lib ${BUILD_PREFIX}/bin/make install
mv ${PREFIX}/usr/include ${PREFIX}
rmdir ${PREFIX}/usr

