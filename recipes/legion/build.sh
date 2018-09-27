CMAKE_FLAGS=()
if [[ $USE_CUDA -eq 1 ]]; then
    CMAKE_FLAGS+=(
	-DLegion_USE_CUDA=ON
    )
fi

if [[ $USE_GASNET -eq 1 ]]; then
    git clone https://github.com/StanfordLegion/gasnet.git
    pushd gasnet
    make CONDUIT=mpi
    popd

    CMAKE_FLAGS+=(
	-DLegion_USE_GASNet=ON
	-DGASNet_ROOT_DIR="$PWD/../gasnet/release"
	-DGASNet_CONDUIT=mpi
    )
fi

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
  "${CMAKE_FLAGS[@]}" \
  ..
make -j12
make install
