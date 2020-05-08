#!/bin/bash
# checkout the tag matching the package version
git checkout "$PKG_VERSION"
# call setup.py
$PYTHON setup.py install  --single-version-externally-managed --record=record.txt
