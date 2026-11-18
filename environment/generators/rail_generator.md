Generation of Railway Networks
============

Flatland provides the [`sparse_rail_generator`](https://github.com/flatland-association/flatland-rl/blob/v4.3.0/flatland/envs/rail_generators.py#L125), which generates realistic-looking railway networks. 

Networks are generally generated using the following steps:
<ol>
  <li>Cities (square areas of fixed "radius") are placed randomly on the map</li>
  <li>Cities are vested with inner and outer connection points towards and away from its closest neighbor</li>
  <li>Rails are placed on (shortest) paths connecting outer connection points of closest cities </li>
  <li>Rails are placed connecting inner connection points with parallel rails </li>
  <li>Train stations (resp. tracks) are placed on inner city rails </li>
  <li>Rail transitions are fixed (as the placement does not preserves transition validity)  </li>
</ol> 
Find more details and illustrations for  to the different steps below.  

From a graph theoretical perspective we have tightly connected node clusters (cities) which are then connected to their nearest neighbors from opposing ends of the clusters. Due to the limited spacial resolution of the grid, the overlapping of paths then dynamically merges edges and generates additional nodes between the cities. 


City Placement
-------------------------


Inner and Outer Connection Points
-------------------------


Pathfinding between Cities 
-------------------------


Inner Cities 
-------------------------


Train Stations 
-------------------------


Fixing Transitions 
-------------------------
