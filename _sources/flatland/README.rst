.. role:: raw-html-m2r(raw)
   :format: html


🚂 Flatland
===========


.. image:: https://i.imgur.com/0rnbSLY.gif
   :target: https://i.imgur.com/0rnbSLY.gif
   :alt: Flatland



.. raw:: html

   <p style="text-align:center">
   <img alt="repository" src="https://gitlab.aicrowd.com/flatland/flatland/badges/master/pipeline.svg">
   <img alt="discord" src="https://gitlab.aicrowd.com/flatland/flatland/badges/master/coverage.svg">
   </p>


Flatland is a open-source toolkit for developing and comparing Multi Agent Reinforcement Learning algorithms in little (or ridiculously large!) gridworlds.

`The official documentation <http://flatland.aicrowd.com/>`_ contains full details about the environment and problem statement

Flatland is tested with Python 3.6 and 3.7 on modern versions of macOS, Linux and Windows. You may encounter problems with graphical rendering if you use WSL. Your `contribution is welcome <https://flatland.aicrowd.com/misc/contributing.html>`_ if you can help with this!  

🏆 Challenges
-------------

This library was developed specifically for the AIcrowd `Flatland challenges <http://flatland.aicrowd.com/research/top-challenge-solutions.html>`_ in which we strongly encourage you to take part in!


* `NeurIPS 2020 Challenge <https://www.aicrowd.com/challenges/neurips-2020-flatland-challenge/>`_
* `2019 Challenge <https://www.aicrowd.com/challenges/flatland-challenge>`_

📦 Setup
--------

Prerequisites (optional)
^^^^^^^^^^^^^^^^^^^^^^^^

Install `Anaconda <https://www.anaconda.com/distribution/>`_ and create a new conda environment:

.. code-block:: console

   $ conda create python=3.6 --name flatland-rl
   $ conda activate flatland-rl

Stable release
^^^^^^^^^^^^^^

Install Flatland from pip:

.. code-block:: console

   $ pip install flatland-rl

This is the preferred method to install Flatland, as it will always install the most recent stable release.

From sources
^^^^^^^^^^^^

The Flatland code source is available from `AIcrowd gitlab <https://gitlab.aicrowd.com/flatland/flatland>`_.

Clone the public repository:

.. code-block:: console

   $ git clone git@gitlab.aicrowd.com:flatland/flatland.git

Once you have a copy of the source, install it with:

.. code-block:: console

   $ python setup.py install

Test installation
^^^^^^^^^^^^^^^^^

Test that the installation works:

.. code-block:: console

   $ flatland-demo

You can also run the full test suite:

.. code-block:: console

   python setup.py test

👥 Credits
----------

This library was developed by `SBB <https://www.sbb.ch/en/>`_\ , `Deutsche Bahn <https://www.deutschebahn.com/>`_\ , `AIcrowd <https://www.aicrowd.com/>`_ and `numerous contributors <http://flatland.aicrowd.com/misc/credits.html>`_ and AIcrowd research fellows from the AIcrowd community. 

➕ Contributions
----------------

Please follow the `Contribution Guidelines <https://flatland.aicrowd.com/misc/contributing.html>`_ for more details on how you can successfully contribute to the project. We enthusiastically look forward to your contributions!

💬 Communication
----------------


* `Discord Channel <https://discord.com/invite/hCR3CZG>`_
* `Discussion Forum <https://discourse.aicrowd.com/c/neurips-2020-flatland-challenge>`_
* `Issue Tracker <https://gitlab.aicrowd.com/flatland/flatland/issues/>`_

🔗 Partners
-----------

:raw-html-m2r:`<a href="https://sbb.ch" target="_blank" style="margin-right:25px"><img src="https://i.imgur.com/OSCXtde.png" alt="SBB" width="200"/></a>` 
:raw-html-m2r:`<a href="https://www.deutschebahn.com/" target="_blank" style="margin-right:25px"><img src="https://i.imgur.com/pjTki15.png" alt="DB"  width="200"/></a>`
:raw-html-m2r:`<a href="https://www.aicrowd.com" target="_blank"><img src="https://avatars1.githubusercontent.com/u/44522764?s=200&v=4" alt="AICROWD"  width="200"/></a>`
