#!/bin/bash

# This is a file use to sign. Please input file as parameter.
# Usage: ./sign.sh signed_by_${USERNAME}.txt

pushd $(dirname $0)

git pull
git add $1
git commit
git push
REPO=$(cat .git/config | grep "git@github.com" | cut -f 2 -d ':' | sed s/\.git//)

if [ -f $(which hub) ]; then
  echo '自動送 pull-request...'
  hub pull-request -m "Please add my sign!!" -b RainbowEngineer/taiwan_love_wins -h master
else
  
  echo '系統沒有安裝hub，請前往以下網址送出pull request：'
  echo "https://github.com/${REPO}/pull/new/master"
fi

popd
