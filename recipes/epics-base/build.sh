EPICS_BASE=$PREFIX/epics
make -j 8 INSTALL_LOCATION=$EPICS_BASE
EPICS_HOST_ARCH=$(startup/EpicsHostArch)
mkdir -p $PREFIX/etc/conda/activate.d
mkdir -p $PREFIX/etc/conda/deactivate.d
ACTIVATE=$PREFIX/etc/conda/activate.d/epics_base.sh
DEACTIVATE=$PREFIX/etc/conda/deactivate.d/epics_base.sh
echo "export EPICS_BASE="$EPICS_BASE >> $ACTIVATE
echo "export EPICS_HOST_ARCH="$EPICS_HOST_ARCH >> $ACTIVATE
echo "unset EPICS_BASE" >> $DEACTIVATE
echo "unset EPICS_HOST_ARCH" >> $DEACTIVATE
unset ACTIVATE
unset DEACTIVATE
