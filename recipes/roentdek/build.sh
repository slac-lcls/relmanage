#!/bin/bash -x

echo "######## env ############"
env
echo "#########################"

cd x86_64-centos7-gcc731

mkdir -p $PREFIX/lib
mkdir -p $PREFIX/include/roentdek

cp libResort64c_x64.a $PREFIX/lib/
cp resort64c.h $PREFIX/include/roentdek

