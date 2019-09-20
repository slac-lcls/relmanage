git clone https://github.com/slaclab/lcls2-pcie-apps.git
cd lcls2-pcie-apps
git checkout system_dsp_integration_testing
#sed -i 's/git@github.com:/https:\/\/github.com\//' .gitmodules
git submodule update --init --recursive
$PYTHON setup.py install --single-version-externally-managed --record=record.txt
