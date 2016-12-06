#!/bin/bash

# uncomment this for debug.
# set -o xtrace

# This is a file use to sign.
# Usage: ./sign.sh

pushd $(dirname $0)
username=$(git config --get remote.origin.url | awk -F@\|:\|/ '{if($3 == "") print $5; else print $3}')

if [ $username = "RainbowEngineer" ]; then
	echo "請 fork 這個 repo 後再 clone 重新執行 sign.sh"
	exit 1;
fi

git pull
git remote add upstream https://github.com/RainbowEngineer/taiwan_love_wins.git 2> /dev/null
git fetch upstream
git merge upstream/master
git push
cp template.md signatures/signed_by_$username.md
git add signatures/signed_by_$username.md
git commit
git push

if [ -f $(which hub) ]; then
  echo '自動送 pull-request...'
  hub pull-request -m "Please add my sign!!" -b RainbowEngineer/taiwan_love_wins:master
else
  echo '系統沒有安裝hub，請前往以下網址送出pull request：'
  echo "https://github.com/${username}/taiwan_love_wins/pull/new/master"
fi

popd
