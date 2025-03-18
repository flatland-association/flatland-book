# Contribute to Flatland Book

[Flatland Book](https://flatland-association.github.io/flatland-book/) is an aggregation of all the documentation, exploratory research, baselines, un-explored
ideas, future research directions for
the [Flatland-RL](https://github.com/flatland-association/flatland-rl/) project.

# Installation

```shell
git clone https://github.com/flatland-association/flatland-book.git 

pip install -U -r requirements.txt

FLATLAND_MODULE_PATH=$(python -c 'import os; import importlib; print(os.path.dirname(importlib.import_module("flatland").__file__))')
FLATLAND_MODULE_VERSION=$(python -c "import flatland; print(flatland.__version__)")
sphinx-apidoc --force -a -e -o apidocs ${FLATLAND_MODULE_PATH}  -H "Flatland ${FLATLAND_MODULE_VERSION} API Reference" --tocfile 'index'
find . -name "*.md" -print0 | xargs -0  sed -i 's/```mermaid/```{mermaid}/g'
# on macOS: use find . -name "*.md" -print0 | xargs -0  sed -i '' 's/```mermaid/```{mermaid}/g'
jupyter-book build .
```

Changes to the ToC will require full re-build by running

```shell
jupyter-book clean .
```

# Author(s)

- Sharada Mohanty
- Florian Laurent
- Nimish Santhosh
- Erik Nygren
- Adrian Egli
- Manuel Schneider
- Christian Eichenberger
