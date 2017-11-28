mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DBUILD_SHARED_LIBS=ON \
      -DYAML_CPP_BUILD_TESTS=OFF \
      -DYAML_CPP_BUILD_TESTS=OFF \
      ..
make -j 4 
make install
