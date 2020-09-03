#!/bin/bash -x

echo "######## env ############"
env
echo "#########################"

mkdir -p $PREFIX/lib
mkdir -p $PREFIX/include

# copy libraries and headers
cp lib64/libusdusb4.so.1.0.0 $PREFIX/lib/
cp include/libusdusb4.h $PREFIX/include/
# create symlinks
cd $PREFIX/lib/
ln -s libusdusb4.so.1.0.0 libusdusb4.so.1
ln -s libusdusb4.so.1 libusdusb4.so
