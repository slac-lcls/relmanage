#!/bin/bash
conda build /reg/g/psdm/sw/conda2/manage/recipes/xtcdata/
conda build /reg/g/psdm/sw/conda2/manage/recipes/psalg/ --python 3.7
conda build /reg/g/psdm/sw/conda2/manage/recipes/psana/ --python 3.7
conda build /reg/g/psdm/sw/conda2/manage/recipes/psdaq/ --python 3.7
conda build /reg/g/psdm/sw/conda2/manage/recipes/ami/ --python 3.7
# now upload the packages to the lcls-ii channel (haven't yet
# figured out how to do that automatically)
# then create the release with:
# conda create --name ps-2.0.10 python=3.7 ami psdaq
