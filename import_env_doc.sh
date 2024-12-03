#!/usr/bin/env bash

set +e
set +x

DIR="_sources/"

if [ -d "$DIR" ]; then
  # Take action if $DIR exists. #
  echo "Removing old files in ${DIR}..."
  rm -rf ${DIR}
fi

mkdir ${DIR}
cd ${DIR}

git clone git@github.com:flatland-association/flatland-rl.git

echo "Removing flatland git files in ${DIR}..."
rm -rf flatland-rl/.git

cd flatland-rl

python scripts/make_docs.py
