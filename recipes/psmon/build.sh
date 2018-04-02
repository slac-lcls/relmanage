# flags are a workaround for conda being unhappy with the
# install_requires field in setup.py:  it treats all of those
# as build dependencies, which can result in pinned versions.
# We really want them to only be run dependencies. 
# the flags tell setup.py to ignore the install_requires, since
# conda will manage those with the (superior) meta.yaml dependencies.
python setup.py install --single-version-externally-managed --record=/tmp/record.txt
