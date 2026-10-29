Installing Flatland
===

Since `flatland 5.0.0`, Flatland requires Python 3.11 to 3.14; `flatland 4.x` was the last release series supporting Python 3.10. On an older Python, pip
silently installs the last compatible release instead.

Install the latest stable release of Flatland from PyPI, preferably into a virtual environment:

```console
$ python -m venv .venv
$ source .venv/bin/activate
$ python -m pip install flatland-rl
```

Check that the installation works:

```console
$ flatland-demo --help
```

To watch a short episode with random actions (needs a display), run:

```console
$ flatland-demo
```

See the [flatland-rl README](https://github.com/flatland-association/flatland-rl#-setup) for the full setup
instructions, including supported Python versions, virtual environments and the optional Cython-accelerated build.

Troubleshooting:

- Flatland is published as a source distribution only, so pip builds it on your machine. A few modules are compiled with Cython if a C compiler is
  available; without one, the build falls back to plain Python (run `python -m pip install -v flatland-rl` to see the warnings). Installation fails in
  environments that do not build from source, e.g. with `pip install --only-binary=:all:`.
- On Apple Silicon with an x86_64 Python (e.g. x86_64 conda under Rosetta 2), importing Flatland can fail with an `incompatible architecture` error, see
  the [known issue in the flatland-rl README](https://github.com/flatland-association/flatland-rl#known-issue-architecture-mismatched-cython-extensions-on-apple-silicon).
To install from source and run the tests, follow the
[flatland-rl contribution guide](https://github.com/flatland-association/flatland-rl/blob/main/CONTRIBUTING.md).
