git clone https://github.com/slaclab/amc-carrier-core.git
cd amc-carrier-core
git checkout v2.6.4
cd python
cat > setup.py <<EOF
from setuptools import setup, find_packages

setup(
    name = 'AmcCarrierCore',
    license = 'LCLS II',
    description = 'LCLS II firmware package',
    packages = find_packages(),
)
EOF
$PYTHON setup.py install --single-version-externally-managed --record=record.txt
