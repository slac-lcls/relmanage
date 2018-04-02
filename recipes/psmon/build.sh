# flags are a workaround for conda being unhappy with the
# install_requires field in setup.py.  this tells setup.py
# to ignore the install_requires.
python setup.py install --single-version-externally-managed --record=/tmp/record.txt
