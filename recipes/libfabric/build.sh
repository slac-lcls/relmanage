# cpo tried this officially recommended autogen approach, but configure
# complained on RHEL6, so try getting the .tar.gz file directly instead

#./autogen.sh

# configure.ac:297: error: possibly undefined macro: AC_CONFIG_FILES
#      If this token and others are legitimate, please use m4_pattern_allow.
#      See the Autoconf documentation.
#configure:15917: error: possibly undefined macro: m4_ifnblank

# feels like maybe the above needs a new version of some autoconf tools?

#cp ib_user_verbs.h include/rdma/
#./configure --enable-sockets --enable-verbs --enable-usnic --disable-static --enable-psm --enable-psm2 --prefix=${PREFIX}
./configure --enable-verbs --prefix=${PREFIX}
${BUILD_PREFIX}/bin/make -j ${CPU_COUNT}
${BUILD_PREFIX}/bin/make install
