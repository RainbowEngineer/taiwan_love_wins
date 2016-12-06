#!/bin/bash

# uncomment this for debug.
# set -o xtrace

# This is a file use to sign. Please input exist file as parameter.
# Usage: ./sign.sh signatures/signed_by_${USERNAME}.md

USE_TEMPLATE=0

if [ "${1}" == "-t" ] ; then
  USE_TEMPLATE=1
elif [ -z "${1}" ] || [ "${1}" == "-h" ] || [ "${1}" == "--help" ] || [ ! -f "${1}" ] ; then
  echo "This is a file use to sign and support LGBT+."
  echo "Usage:"
  echo "Use file as the parameter, and it will add file, commit and send pull request."
  echo "./sign.sh signatures/signed_by_\${USERNAME}.md"
  echo "If you want to auto sign and send pull request with your github username and use the template, use -t."
  echo "./sign.sh -t"
  echo "Use -h for this help."
  echo "./sign.sh -h"
  exit 0
fi

pushd $(dirname $0)

GITHUB_USERNAME=$(git config --get remote.origin.url | awk -F@\|:\|/ '{if($3 == "") print $5; else print $3}')
REPO=$(cat .git/config | grep "git@github.com" | cut -f 2 -d ':' | sed s/\.git//)
REMOTE=$(git remote -v | grep "upstream" | grep "https://github.com/RainbowEngineer/taiwan_love_wins.git")

if [ "${GITHUB_USERNAME}" == "RainbowEngineer" ] ; then
	echo "請 fork 這個 repo 後再 clone，並重新執行 sign.sh"
	exit 1
fi

git pull
if [ -z "${REMOTE}" ] ; then
  git remote add upstream https://github.com/RainbowEngineer/taiwan_love_wins.git
fi
git fetch upstream
git merge upstream/master
if [ "${USE_TEMPLATE}" -eq 1 ];then
  if [ ! -f signatures/signed_by_${GITHUB_USERNAME}.md ] ; then
    cp template.md signatures/signed_by_${GITHUB_USERNAME}.md
  fi
  git add signatures/signed_by_${GITHUB_USERNAME}.md
else
  git add "$1"
fi
git commit
git push

if [ -f $(which hub) ] ; then
  echo '自動送 pull-request……'
  hub pull-request -b RainbowEngineer/taiwan_love_wins:master
else
  echo '系統沒有安裝 hub，請前往以下網址以送出 pull request：'
  echo "https://github.com/${GITHUB_USERNAME}/taiwan_love_wins/pull/new/master"
fi

popd
