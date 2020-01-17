# this recipe must be run from an account that has read access
# to the various submodule repos.  
git clone --recursive https://github.com/slaclab/lcls2-pcie-apps.git
cd lcls2-pcie-apps/software/TimeTool/python
$PYTHON setup.py install --single-version-externally-managed --record=record.txt
