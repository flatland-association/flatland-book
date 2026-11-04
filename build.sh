set -e
set -x

FLATLAND_MODULE_PATH=$(python -c 'import os; import importlib; print(os.path.dirname(importlib.import_module("flatland").__file__))')
FLATLAND_MODULE_VERSION=$(python -c "import flatland; print(flatland.__version__)")

cp ${FLATLAND_MODULE_PATH}/../notebooks/graph_demo.ipynb environment/environment
if [ "$(uname)" == "Darwin" ]; then
  # sed works differently under macOS...
  sed -i '' 's|./images/|../../assets/images/|g'  environment/environment/graph_demo.ipynb
else
  sed -i 's|./images/|../../assets/images/|g'  environment/environment/graph_demo.ipynb
fi

cp ${FLATLAND_MODULE_PATH}/../notebooks/Agent-Close-Following.ipynb environment/environment


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

# plain html imgs seem not copied
cp assets/images/* _build/html/_images

# fail on any notebook execution error: jupyter-book writes a report per failed notebook (any exception, incl. SyntaxError),
# and notebooks executed with allow_errors keep the error as an output.
FAILED=$( (find _build/html/reports -name "*.err.log" 2>/dev/null; grep -rl --include="*.ipynb" '"output_type": "error"' _build/jupyter_execute 2>/dev/null) | sort -u)
if [ -n "${FAILED}" ]; then
  echo "Notebook execution failed:"
  echo "${FAILED}"
  for f in $(echo "${FAILED}" | grep "\.err\.log$"); do
    tail -n 20 "${f}"
  done
  exit 1
fi
