mkdir build
cd build
cmake \
  -DBUILD_SHARED_LIBS=ON \
  -DLegion_BUILD_BINDINGS=ON \
  -DLegion_ENABLE_TLS=ON \
  -DLegion_USE_Python=ON \
  -DPYTHON_EXECUTABLE="$PYTHON" \
  -DCMAKE_INSTALL_PREFIX="$PREFIX" \
  -DCMAKE_INSTALL_LIBDIR="$PREFIX/lib" \
  ..
make -j12
make install
