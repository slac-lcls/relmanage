export PATH=/reg/common/package/openmpi/4.0.0-rhel6/bin:$PATH
which mpicc
$PYTHON setup.py install  --single-version-externally-managed --record=record.txt


mkdir -p $PREFIX/etc/conda/activate.d
mkdir -p $PREFIX/etc/conda/deactivate.d

ACTIVATE=$PREFIX/etc/conda/activate.d/openmpi.sh

echo 'rhel_version=$(less /etc/redhat-release | grep -o -E '[0-9]+' | head -1)' >> $ACTIVATE
echo 'export PATH=/reg/common/package/openmpi/4.0.0-rhel$rhel_version/bin:$PATH' >> $ACTIVATE
echo 'export LD_LIBRARY_PATH=/reg/common/package/openmpi/4.0.0-rhel$rhel_version/lib' >> $ACTIVATE

