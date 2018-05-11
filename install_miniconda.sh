#!/bin/bash

# Usage:
#   source install_miniconda.sh
# 
# Note that this must be sourced, not executed. This is because it changes
# environment variables.
#
# There are two environment variables that you can set to change behavior: 
#  * $CONDA_PY will affect which Python version is default in miniconda, and
#    will also be used by conda to select the Python version. If unset,
#    default is "36".
#  * $CONDA_VERSION will select which version of miniconda is installed.
#    If unset, default is "latest".

if [ -z "$CONDA_VERSION" ]
then
    CONDA_VERSION="latest"
fi

if [ -z "$CONDA_PY" ]
then
    CONDA_PY=36
fi

pyV=${CONDA_PY:0:1}

MINICONDA=Miniconda${pyV}-${CONDA_VERSION}-Linux-x86_64.sh
MINICONDA_MD5=$(curl -s https://repo.continuum.io/miniconda/ | grep -A3 $MINICONDA | sed -n '4p' | sed -n 's/ *<td>\(.*\)<\/td> */\1/p')
wget https://repo.continuum.io/miniconda/$MINICONDA

# check the MD5 hash; error is mismatch
if [[ $MINICONDA_MD5 != $(md5sum $MINICONDA | cut -d ' ' -f 1) ]]; then
    echo "Miniconda MD5 mismatch"
    echo "Expected: $MINICONDA_MD5"
    echo "Found: $(md5sum $MINICONDA | cut -d ' ' -f 1)"
    exit 1
fi

# install miniconda and update PATH
bash $MINICONDA -b
export PATH=$HOME/miniconda${pyV}/bin:$PATH
