.. role:: raw-html-m2r(raw)
   :format: html


Visualization
-------------


.. image:: https://drive.google.com/uc?export=view&id=1rstqMPJXFJd9iD46z1A5Rus-W0Ww6O8i
   :target: https://drive.google.com/uc?export=view&id=1rstqMPJXFJd9iD46z1A5Rus-W0Ww6O8i
   :alt: logo


Introduction & Scope
^^^^^^^^^^^^^^^^^^^^

Broad requirements for human-viewable display of a single Flatland Environment.

Context
~~~~~~~

Shows this software component in relation to some of the other components.  We name the component the "Renderer".  Multiple agents interact with a single Environment.  A renderer interacts with the environment, and displays on screen, and/or into movie or image files.

:raw-html-m2r:`<p id="gdcalert2" ><span style="color: red; font-weight: bold">>>>>>  gd2md-html alert: inline drawings not supported directly from Docs. You may want to copy the inline drawing to a standalone drawing and export by reference. See <a href="https://github.com/evbacher/gd2md-html/wiki/Google-Drawings-by-reference">Google Drawings by reference</a> for details. The img URL below is a placeholder. </span><br>(<a href="#">Back to top</a>)(<a href="#gdcalert3">Next alert</a>)<br><span style="color: red; font-weight: bold">>>>>> </span></p>`


.. image:: https://docs.google.com/a/google.com/drawings/d/12345/export/png
   :target: https://docs.google.com/a/google.com/drawings/d/12345/export/png
   :alt: drawing


Requirements
^^^^^^^^^^^^

Primary Requirements
~~~~~~~~~~~~~~~~~~~~


#. Visualize or Render the state of the environment

   #. Read an Environment + Agent Snapshot provided by the Environment component
   #. Display onto a local screen in real-time (or near real-time)
   #. Include all the agents
   #. Illustrate the agent observations (typically subsets of the grid / world)
   #. 2d-rendering only

#. Output visualisation into movie / image files for use in later animation
#. Should not impose control-flow constraints on Environment

   #. Should not force env to respond to events
   #. Should not drive the "main loop" of Inference or training 

Secondary / Optional Requirements
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#. During training (possibly across multiple processes or machines / OS instances), display a single training environment,

   #. without holding up the other environments in the training.
   #. Some training environments may be remote to the display machine (eg using GCP / AWS)
   #. Attach to / detach from running environment / training cluster without restarting training.

#. Provide a switch to make use of graphics / artwork provided by graphic artist

   #. Fast / compact mode for general use
   #. Beauty mode for publicity / demonstrations

#. Provide a switch between smooth / continuous animation of an agent (slower) vs jumping from cell to cell (faster)

   #. Smooth / continuous translation between cells
   #. Smooth / continuous rotation 

#. Speed - ideally capable of 60fps (see performance metrics)
#. Window view - only render part of the environment, or a single agent and agents nearby.

   #. May not be feasible to render very large environments
   #. Possibly more than one window, ie one for each selected agent
   #. Window(s) can be tied to agents, ie they move around with the agent, and optionally rotate with the agent.

#. Interactive scaling

   #. eg wide view, narrow / enlarged view
   #. eg with mouse scrolling & zooming

#. Minimize necessary skill-set for participants

   #. Python API to gui toolkit, no need for C/C++

#. View on various media:

   #. Linux & Windows local display
   #. Browser

Performance Metrics
~~~~~~~~~~~~~~~~~~~

Here are some performance metrics which the Renderer should meet.


.. raw:: html

   <table>
     <tr>
      <td>
      </td>
      <td><p style="text-align: right">
   ### Per second</p>

      </td>
      <td><p style="text-align: right">
   Target Time (ms)</p>

      </td>
      <td><p style="text-align: right">
   Prototype time (ms)</p>

      </td>
     </tr>
     <tr>
      <td>Write an agent update (ie env as client providing an agent update)
      </td>
      <td>
      </td>
      <td><p style="text-align: right">
   0.1</p>

      </td>
      <td>
      </td>
     </tr>
     <tr>
      <td>Draw an environment window 20x20
      </td>
      <td><p style="text-align: right">
   60</p>

      </td>
      <td><p style="text-align: right">
   16</p>

      </td>
      <td>
      </td>
     </tr>
     <tr>
      <td>Draw an environment window 50 x 50
      </td>
      <td><p style="text-align: right">
   10</p>

      </td>
      <td>
      </td>
      <td>
      </td>
     </tr>
     <tr>
      <td>Draw an agent update on an existing environment window.  5 agents visible.
      </td>
      <td>
      </td>
      <td><p style="text-align: right">
   1</p>

      </td>
      <td>
      </td>
     </tr>
   </table>


Example Visualization
~~~~~~~~~~~~~~~~~~~~~

Reference Documents
^^^^^^^^^^^^^^^^^^^

Link to this doc: https://docs.google.com/document/d/1Y4Mw0Q6r8PEOvuOZMbxQX-pV2QKDuwbZJBvn18mo9UU/edit#

Core Specification
~~~~~~~~~~~~~~~~~~

This specifies the system containing the environment and agents - this will be able to run independently of the renderer.

`https://docs.google.com/document/d/1RN162b8wSfYTBblrdE6-Wi_zSgQTvVm6ZYghWWKn5t8/edit <https://docs.google.com/document/d/1RN162b8wSfYTBblrdE6-Wi_zSgQTvVm6ZYghWWKn5t8/edit>`_

The data structure which the renderer needs to read initially resides here.

Visualization Specification
~~~~~~~~~~~~~~~~~~~~~~~~~~~

This will specify the software which will meet the requirements documented here.

`https://docs.google.com/document/d/1XYOe_aUIpl1h_RdHnreACvevwNHAZWT0XHDL0HsfzRY/edit# <https://docs.google.com/document/d/1XYOe_aUIpl1h_RdHnreACvevwNHAZWT0XHDL0HsfzRY/edit#>`_

Interface Specification
~~~~~~~~~~~~~~~~~~~~~~~

This will specify the interfaces through which the different components communicate

Non-requirements - to be deleted below here.
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The below has been copied into the spec doc.    Comments may be lost.  I'm only preserving it to save the comments for a few days - they don't cut & paste into the other doc!

Interface with Environment Component
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


* Environment produces the Env Snapshot data structure (TBD)
* Renderer reads the Env Snapshot
* Connection between Env and Renderer, either:

  * Environment "invokes" the renderer in-process
  * Renderer "connects" to the environment

    * Eg Env acts as a server, Renderer as a client

* Either

  * The Env sends a Snapshot to the renderer and waits for rendering

* Or:

  * The Env puts snapshots into a rendering queue
  * The renderer blocks / waits on the queue, waiting for a new snapshot to arrive

    * If several snapshots are waiting, delete and skip them and just render the most recent
    * Delete the snapshot after rendering

* Optionally

  * Render every frame / time step
  * Or, render frames without blocking environment

    * Render frames in separate process / thread

Environment Snapshot
####################

**Data Structure**

A definitions of the data structure is to be defined in Core requirements.

It is a requirement of the Renderer component that it can read this data structure.

**Example only**

Top-level dictionary


* World nd-array

  * Each element represents available transitions in a cell

* List of agents

  * Agent location, orientation, movement (forward / stop / turn?)
  * Observation

    * Rectangular observation

      * Maybe just dimensions - width + height (ie no need for contents)
      * Can be highlighted in display as per minigrid

    * Tree-based observation

      * TBD

Investigation into Existing Tools / Libraries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


#. Pygame

   #. Very easy to use. Like dead simple to add sprites etc. (\ `https://studywolf.wordpress.com/2015/03/06/arm-visualization-with-pygame/ <https://studywolf.wordpress.com/2015/03/06/arm-visualization-with-pygame/>`_\ )
   #. No inbuilt support for threads/processes. Does get faster if using pypy/pysco.

#. PyQt

   #. Somewhat simple, a little more verbose to use the different modules.
   #. Multi-threaded via QThread! Yay! (Doesn't block main thread that does the real work), (\ `https://nikolak.com/pyqt-threading-tutorial/ <https://nikolak.com/pyqt-threading-tutorial/>`_\ )

**How to structure the code**


#. Define draw functions/classes for each primitive

   #. Primitives: Agents (Trains), Railroad, Grass, Houses etc.

#. Background. Initialize the background before starting the episode.

   #. Static objects in the scenes, directly draw those primitives once and cache.

**Proposed Interfaces**

To-be-filled

Technical Graphics Considerations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Overlay dynamic primitives over the background at each time step.
#################################################################

No point trying to figure out changes. Need to explicitly draw every primitive anyways (that's how these renders work).
