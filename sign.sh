#!/bin/bash

# uncomment this for debug.
# set -o xtrace

# This is a file use to sign. Please input exist file as parameter.
# Usage: ./sign.sh signatures/signed_by_${USERNAME}.md


if [ -z "${1}" ] || [ "${1}" == "-h" ] || [ "${1}" == "--help" ] || [ ! -f "${1}" ] ; then
  echo "This is a file use to sign. Please input exist file as parameter."
  echo "Usage: ./sign.sh signatures/signed_by_\${USERNAME}.md"
  exit
fi

pushd $(dirname $0)
REPO=$(cat .git/config | grep "git@github.com" | cut -f 2 -d ':' | sed s/\.git//)
REMOTE=$(git remote -v | grep "upstream" | grep "https://github.com/RainbowEngineer/taiwan_love_wins.git")

git pull
if [ -z "${REMOTE}" ]; then
  git remote add upstream https://github.com/RainbowEngineer/taiwan_love_wins.git
fi
git fetch upstream
git merge upstream/master
git push
git add $1
git commit
git push

if [ -f $(which hub) ]; then
  echo '自動送 pull-request...'
  hub pull-request -m "Please add my sign!!" -b RainbowEngineer/taiwan_love_wins:master
else
  echo '系統沒有安裝hub，請前往以下網址送出pull request：'
  echo "https://github.com/${REPO}/pull/new/master"
fi

popd
