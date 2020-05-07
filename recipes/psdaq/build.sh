cd psdaq
mkdir build
cd build
${BUILD_PREFIX}/bin/cmake -DCMAKE_INSTALL_PREFIX=${PREFIX} -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=${PREFIX} ..
${BUILD_PREFIX}/bin/make -j ${CPU_COUNT}
${BUILD_PREFIX}/bin/make install
cd ..
$PYTHON setup.py install --single-version-externally-managed --record=record.txt
