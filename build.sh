set -e
set -x
# avoid executing all notebooks
# TODO https://github.com/flatland-association/flatland-rl/issues/132 make all notebooks executable unattended
# TODO use notebooks from flatland-rl directly instead of duplicating in flatland-notebook repo?

FLATLAND_MODULE_PATH=$(python -c 'import os; import importlib; print(os.path.dirname(importlib.import_module("flatland").__file__))')
FLATLAND_MODULE_VERSION=$(python -c "import flatland; print(flatland.__version__)")

# TODO copy from flatland-rl - which ones to run and which ones to cache?
cp assets/images/graph_to_digraph.drawio.png environment/environment/images/graph_to_digraph.drawio.png
cp ${FLATLAND_MODULE_PATH}/../notebooks/graph_demo.ipynb environment/environment

#cp ${FLATLAND_MODULE_PATH}/../notebooks/Agent-Close-Following.ipynb environment/environment
# TODO waiting for 4.0.7 pr and copy from there
#cp -R ${FLATLAND_MODULE_PATH}/../notebooks/images/ environment/environment/images/

sphinx-apidoc --force -a -e -o apidocs ${FLATLAND_MODULE_PATH}  -H "Flatland ${FLATLAND_MODULE_VERSION} API Reference" --tocfile 'index'

# tweak mermaid directives for sphinx, see https://sphinxcontrib-mermaid-demo.readthedocs.io/en/latest/index.html
if [ "$(uname)" == "Darwin" ]; then
  # sed works differently under macOS...
  find . -name "*.md" -print0 | xargs -0  sed -i '' 's/```mermaid/```{mermaid}/g'
  find . -name "*.ipynb" -print0 | xargs -0  sed -i '' 's/```mermaid/```{mermaid}/g'
else
  find . -name "*.md" -print0 | xargs -0  sed -i 's/```mermaid/```{mermaid}/g'
  find . -name "*.ipynb" -print0 | xargs -0  sed -i 's/```mermaid/```{mermaid}/g'
fi
jupyter-book clean .
jupyter-book build .

# revert tweak mermaid directives for sphinx
if [ "$(uname)" == "Darwin" ]; then
  # sed works differently under macOS...
  find . -name "*.md" -print0 | xargs -0  sed -i '' 's/```{mermaid}/```mermaid/g'
  find . -name "*.ipynb" -print0 | xargs -0  sed -i '' 's/```{mermaid}/```mermaid/g'
else
  find . -name "*.md" -print0 | xargs -0  sed -i 's/```{mermaid}/```mermaid/g'
  find . -name "*.ipynb" -print0 | xargs -0  sed -i 's/```{mermaid}/```mermaid/g'
fi

find _build -name "*.ipynb" -print0 | xargs -0  --no-run-if-empty grep -E "ImportError|KeyboardInterrupt|AttributeError|ModuleNotFoundError" || true
NUM=$(find _build -name "*.ipynb" -print0 | xargs -0  --no-run-if-empty grep -E "ImportError|KeyboardInterrupt|AttributeError|ModuleNotFoundError" | wc -l)
exit ${NUM}
