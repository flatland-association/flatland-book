#!/usr/bin/env bash

DIR="_sources/"

if [ -d "$DIR" ]; then
  # Take action if $DIR exists. #
  echo "Removing old files in ${DIR}..."
  rm -rf ${DIR}
fi

mkdir ${DIR}
cd ${DIR}

git clone --single-branch --branch flatland3-pettingzoo git@gitlab.aicrowd.com:flatland/flatland.git

echo "Removing flatland git files in ${DIR}..."
rm -rf flatland/.git

cd flatland

python make_docs.py
