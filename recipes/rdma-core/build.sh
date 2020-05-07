cp ib_user_cm.h buildlib/fixup-include/rdma-ib_user_cm.h
cp ib_user_sa.h buildlib/fixup-include/rdma-ib_user_sa.h
cp ib_user_verbs.h buildlib/fixup-include/rdma-ib_user_verbs.h
cp rdma_user_cm.h buildlib/fixup-include/rdma-rdma_user_cm.h
mkdir build
cd build
${BUILD_PREFIX}/bin/cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_INSTALL_LIBDIR=${PREFIX}/lib -DCMAKE_PREFIX_PATH=${PREFIX} -DCMAKE_BUILD_TYPE=Release ..
${BUILD_PREFIX}/bin/make -j ${CPU_COUNT}
${BUILD_PREFIX}/bin/make install
