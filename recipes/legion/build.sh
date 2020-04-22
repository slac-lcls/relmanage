CMAKE_FLAGS=()
if [[ ${USE_CUDA} -eq 1 ]]; then
    CMAKE_FLAGS+=(
	-DLegion_USE_CUDA=ON
    )
fi

if [[ ${USE_GASNET} -eq 1 ]]; then
    export CONDUIT=${CONDUIT:-mpi}
    git clone https://github.com/StanfordLegion/gasnet.git
    ${BUILD_PREFIX}/bin/make -C gasnet CONDUIT=${CONDUIT}

    CMAKE_FLAGS+=(
	-DLegion_USE_GASNet=ON
	-DGASNet_ROOT_DIR="${PWD}/gasnet/release"
	-DGASNet_CONDUITS=${CONDUIT}
    )
fi

mkdir build
cd build
${BUILD_PREFIX}/bin/cmake \
  -DBUILD_SHARED_LIBS=ON \
  -DLegion_BUILD_BINDINGS=ON \
  -DLegion_ENABLE_TLS=ON \
  -DLegion_USE_Python=ON \
  -DPYTHON_EXECUTABLE="${PYTHON}" \
  -DCMAKE_INSTALL_PREFIX="${PREFIX}" \
  -DCMAKE_INSTALL_LIBDIR="${PREFIX}/lib" \
  "${CMAKE_FLAGS[@]}" \
  ..
${BUILD_PREFIX}/bin/make -j${CPU_COUNT}
${BUILD_PREFIX}/bin/make install
