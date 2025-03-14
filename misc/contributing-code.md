Writing code
============

Ready to contribute? Here's how to set up Flatland for local development.

2. Clone Flatland locally:

    ```console
    $ git clone git@git@github.com:flatland-association/flatland-rl.git
    ```

3. Install the software dependencies via Anaconda-3 or Miniconda-3. (This assumes you have Anaconda installed by following [these instructions](https://www.anaconda.com/distribution))
    
    ```console
    $ conda install -c conda-forge tox-conda
    $ conda install tox
    $ tox -v --recreate
    ```

    This will create a virtual env you can then use.

    These steps are performed if you run

    ```console
    $ getting_started/getting_started.bat/.sh
    ```

    from Anaconda prompt.


4. Create a branch for local development::

    ```console
    $ git checkout -b name-of-your-bugfix-or-feature
    ```

   Now you can make your changes locally.

5. When you're done making changes, check that your changes pass flake8 and the
   tests, including testing other Python versions with tox::

    ```console
    $ flake8 flatland tests examples benchmarks
    $ python setup.py test or py.test
    $ tox
    ```

   To get flake8 and tox, just pip install them into your virtualenv.

6. Commit your changes and push your branch to Gitlab::

    ```console
    $ git add .
    $ git commit -m "Addresses #<issue-number> Your detailed description of your changes."
    $ git push origin name-of-your-bugfix-or-feature
    ```

7. Submit a merge request through the Gitlab repository website.

Merge Request Guidelines
-------------------------

Before you submit a merge request, check that it meets these guidelines:

1. The merge request should include tests.
2. The code must be formatted (PyCharm)
3. If the merge request adds functionality, the docs should be updated. Put
   your new functionality into a function with a docstring, and add the
   feature to the list in README.rst.
4. The merge request should work for Python 3.6, 3.7 and for PyPy. Check
   https://gitlab.aicrowd.com/flatland/flatland/pipelines
   and make sure that the tests pass for all supported Python versions.
   We force pipelines to be run successfully for merge requests to be merged.
5. Although we cannot enforce it technically, we ask for merge requests to be reviewed by at least one core member
   in order to ensure that the Technical Guidelines below are respected and that the code is well tested:

5.1.  The remarks from the review should be resolved/implemented and communicated using the 'discussions resolved':

.. image:: images/DiscussionsResolved.png

![](../assets/images/DiscussionsResolved.png)

5.2.  When a merge request is merged, source branches should be deleted and commits squashed:

![](../assets/images/SourceBranchSquash.png)

Tips
----

To run a subset of tests:

```console
$ py.test tests.test_flatland
```

Deploying
---------

A reminder for the maintainers on how to deploy.

Make sure all your changes are committed.

Then run:

```console
$ bumpversion patch # possible: major / minor / patch
$ git push
$ git push --tags
```

Technical Guidelines
--------------------

### Clean Code

Please adhere to the general `Clean Code <https://www.planetgeek.ch/wp-content/uploads/2014/11/Clean-Code-V2.4.pdf>`_ principles, for instance we write short and concise functions and use appropriate naming to ensure readability.

### Naming Conventions

We use the pylint naming conventions:

`module_name`, `package_name`, `ClassName`, `method_name`, `ExceptionName`, `function_name`, `GLOBAL_CONSTANT_NAME`, `global_var_name`, `instance_var_name`, `function_parameter_name`, `local_var_name`.


### numpydoc

Docstrings should be formatted using [numpydoc](https://numpydoc.readthedocs.io/en/latest/format.html).

### Accessing resources

We use `importlib-resources <https://importlib-resources.readthedocs.io/en/latest/>`_ to read from local files.
    Sample usages:

```python
from importlib_resources import path

with path(package, resource) as file_in:
    new_grid = np.load(file_in)
```

And:

```python
from importlib_resources import read_binary

load_data = read_binary(package, resource)
self.set_full_state_msg(load_data)
```

Renders the scene into a image (screenshot)

```python
renderer.gl.save_image("filename.bmp")
```

### Type Hints

We use Type Hints ([PEP 484](https://www.python.org/dev/peps/pep-0484/)) for better readability and better IDE support.

```python
# This is how you declare the type of a variable type in Python 3.6
age: int = 1

# In Python 3.5 and earlier you can use a type comment instead
# (equivalent to the previous definition)
age = 1  # type: int

# You don't need to initialize a variable to annotate it
a: int  # Ok (no value at runtime until assigned)

# The latter is useful in conditional branches
child: bool
if age < 18:
    child = True
else:
    child = False
```

Have a look at the [Type Hints Cheat Sheet](https://mypy.readthedocs.io/en/latest/cheat_sheet_py3.html) to get started with Type Hints.

Caveat: We discourage the usage of Type Aliases for structured data since its members remain unnamed (see [Issue #284](https://gitlab.aicrowd.com/flatland/flatland/issues/284/)).

# Discouraged: Type Alias with unnamed members
```python
Tuple[int, int]
```

# Better: use NamedTuple
```python
from typing import NamedTuple

Position = NamedTuple('Position',
    [
        ('r', int),
        ('c', int)
    ]
```



### NamedTuple

For structured data containers for which we do not write additional methods, we use
`NamedTuple` instead of plain `Dict` to ensure better readability by

```python
from typing import NamedTuple

RailEnvNextAction = NamedTuple('RailEnvNextAction',
    [
        ('action', RailEnvActions),
        ('next_position', RailEnvGridPos),
        ('next_direction', Grid4TransitionsEnum)
    ])
```

Members of NamedTuple can then be accessed through `.<member>` instead of `['<key>']`.

If we have to ensure some (class) invariant over multiple members
(for instance, `o.A` always changes at the same time as `o.B`),
then we should uses classes instead, see the next section.

### Class Attributes

We use classes for data structures if we need to write methods that ensure (class) invariants over multiple members,
for instance, `o.A` always changes at the same time as `o.B`.
We use the [attrs class decorator](https://github.com/python-attrs/attrs) and a way to declaratively define the attributes on that class:

```python
@attrs
class Replay(object):
    position = attrib(type=Tuple[int, int])
```

### Abstract Base Classes

We use the [abc class decorator](https://pymotw.com/3/abc/) and a way to declaratively define the attributes on that class:

```python
import abc

class PluginBase(metaclass=abc.ABCMeta):

    @abc.abstractmethod
    def load(self, input):
        """Retrieve data from the input source
        and return an object.
        """
    
    @abc.abstractmethod
    def save(self, output, data):
        """Save the data object to the output."""
```

And then

```python
# abc_subclass.py

import abc
from abc_base import PluginBase

class SubclassImplementation(PluginBase):

    def load(self, input):
        return input.read()

    def save(self, output, data):
        return output.write(data)


if __name__ == '__main__':
    print('Subclass:', issubclass(SubclassImplementation,
                                  PluginBase))
    print('Instance:', isinstance(SubclassImplementation(),
                                  PluginBase))
```

### Currying

We discourage currying to encapsulate state since we often want the stateful object to have multiple methods
(but the curried function has only its signature and abusing params to switch behaviour is not very readable).

Thus, we should refactor our generators and use classes instead (see [Issue #283](https://gitlab.aicrowd.com/flatland/flatland/issues/283)).

```python
# Type Alias
RailGeneratorProduct = Tuple[GridTransitionMap, Optional[Dict]]
RailGenerator = Callable[[int, int, int, int], RailGeneratorProduct]

# Currying: a function that returns a confectioned function with internal state
def complex_rail_generator(nr_start_goal=1,
                           nr_extra=100,
                           min_dist=20,
                           max_dist=99999,
                           seed=1) -> RailGenerator:
```