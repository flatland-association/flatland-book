set -e
set -x
# avoid executing all notebooks
# TODO https://github.com/flatland-association/flatland-rl/issues/132 make all notebooks executable unattended
# TODO use notebooks from flatland-rl directly instead of duplicating in flatland-notebook repo?
find venv -name "*.ipynb" -print0 | xargs -0 rm

FLATLAND_MODULE_PATH=$(python -c 'import os; import importlib; print(os.path.dirname(importlib.import_module("flatland").__file__))')
FLATLAND_MODULE_VERSION=$(python -c "import flatland; print(flatland.__version__)")
sphinx-apidoc --force -a -e -o apidocs ${FLATLAND_MODULE_PATH}  -H "Flatland ${FLATLAND_MODULE_VERSION} API Reference" --tocfile 'index'

# tweak mermaid directives for sphinx, see https://sphinxcontrib-mermaid-demo.readthedocs.io/en/latest/index.html
# on macOS: use find . -name "*.md" -print0 | xargs -0  sed -i '' 's/```mermaid/```{mermaid}/g'
find . -name "*.md" -print0 | xargs -0  sed -i 's/```mermaid/```{mermaid}/g'
jupyter-book clean .
jupyter book build .
find _build -name "*.ipynb" -print0 | xargs -0 fgrep ImportError
NUM=$(find _build -name "*.ipynb" -print0 | xargs -0 fgrep ImportError | wc -l)
exit ${NUM}