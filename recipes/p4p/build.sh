cat <<EOF > configure/RELEASE.local
EPICS_BASE=$EPICS_BASE
EOF
GNU_DIR=$(dirname $(dirname $(which gcc)))
if [ "$GNU_DIR" != "/usr" ]; then
    echo "GNU_DIR="$GNU_DIR >> configure/CONFIG_SITE
    # echo "CMPLR_PREFIX=x86_64-conda_cos6-linux-gnu-" >> configure/CONFIG_SITE
fi
make
INSTDIR=$PREFIX/lib/python$PY_VER/site-packages
mkdir -p $INSTDIR
cp -r python${PY_VER}m/$EPICS_HOST_ARCH/p4p $INSTDIR
