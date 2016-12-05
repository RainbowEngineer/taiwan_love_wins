#!/bin/bash

# This is a file use to sign. Please input file as parameter.
# Usage: ./sign.sh signed_by_${USERNAME}.txt

pushd $(dirname $0)

git pull
git add $1
git commit
git push

popd
