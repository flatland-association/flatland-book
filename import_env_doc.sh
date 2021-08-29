#!/usr/bin/env bash

DIR="env_doc/"

if [ -d "$DIR" ]; then
  # Take action if $DIR exists. #
  echo "Removing old files in ${DIR}..."
  rm -rf env_doc
fi

mkdir env_doc
cd env_doc

git clone --single-branch --branch sphinxdocs git@gitlab.aicrowd.com:flatland/flatland.git

cd flatland

python make_docs.py
