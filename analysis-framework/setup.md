# Setup Instructions

## Prerequisites

This repository requires python v3.6 or v3.7 as the `flatland-rl` module depends on it.

## Install from PyPi

```{note}
Not released on PyPi yet, this section will be updated after the release.
```

## Install from Source

The Analysis Framework code source is available on [gitlab](https://gitlab.aicrowd.com/flatland/flatland-analysis).

Clone the public repository:

```console
$ git clone git@gitlab.aicrowd.com:flatland/flatland-analysis.git
$ cd flatland-analysis/
```

Once you have a copy of the source, install it with:

```console
$ pip install -e ./
```

## Test Installation

Once its done installing, test it by running the following code in a python interpreter:

```console
$ python
Python 3.7.10 (default, Feb 26 2021, 13:06:18) [MSC v.1916 64 bit (AMD64)] :: Anaconda, Inc. on win32
Type "help", "copyright", "credits" or "license" for more information.
>>>
>>> from flatland_analysis.metrics import DummyMetric
>>> metric = DummyMetric()
>>> metric()
1.0
```
