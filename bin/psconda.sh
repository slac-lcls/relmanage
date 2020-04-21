rhel_version=$(less /etc/redhat-release | grep -o -E '[0-9]+' | head -1)

# redirect errors to /dev/null to avoid errors on nodes without devtoolset
# this created build errors in jenkins for not-understood reasons
#source scl_source enable devtoolset-$rhel_version >& /dev/null

export PATH=/opt/rh/devtoolset-$rhel_version/root/usr/bin:$PATH

unset LD_LIBRARY_PATH
unset PYTHONPATH
source /reg/g/psdm/sw/conda2/inst/etc/profile.d/conda.sh

# user can pick up python2 by adding "-py2" option to setup_env.sh
conda activate ps-2.1.2$@

if [ ! -d /usr/share/X11/xkb ]; then
    export QT_XKB_CONFIG_ROOT=${CONDA_PREFIX}/lib
fi

export MANPATH=$CONDA_PREFIX/share/man${MANPATH:+:${MANPATH}}
