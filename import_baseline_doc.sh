#!/usr/bin/env bash

mkdir baseline_doc

git clone https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines
cd neurips2020-flatland-baselines/baselines

find . -type f -name "README.md" -exec bash -c 'echo cp "$1" "../../research/baselines/$(dirname "$1").md"' -- {} \;