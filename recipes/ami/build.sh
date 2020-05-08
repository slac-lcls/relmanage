#!/bin/bash
# checkout the tag matching the package version
git checkout "$PKG_VERSION"
# call setup.py passing the package version to it
$PYTHON setup.py install --single-version-externally-managed --record=record.txt --version=$PKG_VERSION
