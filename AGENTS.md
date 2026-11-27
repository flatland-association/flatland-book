# AGENTS.md

Guidance for Claude Code and other AI coding agents working in this repository.

## Notebooks

- Commit notebooks (`*.ipynb`) without outputs: clear the outputs and execution counts of all code cells. The book build
  executes them (`execute_notebooks: auto` in `_config.yml`) against the flatland-rl that `requirements.txt` installs,
  so the rendered pages always show the outputs of that version. Stored outputs would hide a notebook that no longer
  runs, and go stale.
- Exception: the notebooks in `execute.exclude_patterns` in `_config.yml` are not executed by the build. They keep their
  outputs, run by hand with the version named in their comment there.
- To check a notebook locally, execute it (e.g. `jupyter nbconvert --to notebook --execute`) into a copy, or clear the
  outputs again before committing.
