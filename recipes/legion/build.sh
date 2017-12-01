export LG_RT_DIR=$PWD/runtime

git clone https://github.com/StanfordLegion/psana-legion.git
cd psana-legion/psana_legion
make -j 12

mkdir -p $PREFIX/include
mkdir -p $PREFIX/include/legion
mkdir -p $PREFIX/include/realm
mkdir -p $PREFIX/include/mappers
cp -v $LG_RT_DIR/*.h           $PREFIX/include
cp -v $LG_RT_DIR/legion/*.h    $PREFIX/include/legion
cp -v $LG_RT_DIR/legion/*.inl  $PREFIX/include/legion
cp -v $LG_RT_DIR/realm/*.h     $PREFIX/include/realm
cp -v $LG_RT_DIR/realm/*.inl   $PREFIX/include/realm
cp -v $LG_RT_DIR/mappers/*.h   $PREFIX/include/mappers
cp -v $LG_RT_DIR/mappers/*.inl $PREFIX/include/mappers

mkdir -p $SP_DIR
cp -v $LG_RT_DIR/../bindings/python/legion.py $SP_DIR

mkdir -p $PREFIX/lib
cp -v $PWD/*.so $PREFIX/lib

mkdir -p $PREFIX/bin
cp -v $PWD/psana_legion $PREFIX/bin
