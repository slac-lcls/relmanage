cp /reg/g/psdm/sw/conda2/manage/recipes/cpsw/CMakeLists_top.txt ./CMakeLists.txt
cp /reg/g/psdm/sw/conda2/manage/recipes/cpsw/CMakeLists.txt src
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX ..
make -j 4 all install VERBOSE=1

