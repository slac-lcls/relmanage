mkdir -p include/rdma/hfi
cp hfi1_user.h include/rdma/hfi
export CFLAGS="-fno-strict-aliasing -Wno-int-in-bool-context -Wno-format-truncation -Wno-sizeof-array-argument"
${BUILD_PREFIX}/bin/make CCARCH=gcc -j ${CPU_COUNT}
DESTDIR=${PREFIX} LIBDIR=/lib ${BUILD_PREFIX}/bin/make install
