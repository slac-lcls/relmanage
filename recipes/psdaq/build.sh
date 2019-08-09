cd psdaq
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$PREFIX ..
make -j $CPU_COUNT
make install
cd ..
$PYTHON setup.py install --single-version-externally-managed --record=record.txt
