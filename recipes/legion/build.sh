PYTHON_BIN="$(which python)"
PYTHON_VER=$("$PYTHON_BIN" -c 'import sys; print("%s.%s" % (sys.version_info.major, sys.version_info.minor))')
PYTHON_INC="$(dirname "$(dirname $PYTHON_BIN)")"/include
PYTHON_LIB="$(dirname "$(dirname $PYTHON_BIN)")"/lib/libpython"$PYTHON_VER"m.so

mkdir build
cd build
cmake -DBUILD_SHARED_LIBS=ON -DLegion_BUILD_BINDINGS=ON -DLegion_USE_Python=ON -DPYTHON_EXECUTABLE="$PYTHON_BIN" -DPYTHON_LIBRARY="$PYTHON_LIB" -DPYTHON_INCLUDE_DIR="$PYTHON_INC" -DPYTHONLIBS_VERSION_STRING="$PYTHON_VER" -DCMAKE_INSTALL_PREFIX="$PREFIX" ..
make -j12
make install
