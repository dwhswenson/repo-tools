#!/bin/bash

# Perform a developer install (`pip install -e`) of a Python package,
# optionally changing to a desired branch.

REPO=$1

if [ $# -gt 1 ]
then
    BRANCH=$2
fi

REPO_DIR=`echo $REPO | sed 's/.*\\\(.*\).git$/\1/'`

pushd ~
git clone $REPO
pushd $REPO_DIR
pip install -e .

if [ -z "$BRANCH" ]
then
    git checkout -b $BRANCH origin/$BRANCH
fi

git branch  # checking that we're correctly set up
popd
popd
