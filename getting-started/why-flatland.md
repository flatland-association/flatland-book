Background
===

The Flatland environment was created to solve a real world problem:

> **How to efficiently manage dense traffic on complex railway networks?**

🚂 Context
---

The Swiss Federal Railways (SBB) operate the densest mixed railway traffic in the world. SBB maintain and operate the biggest railway infrastructure in Switzerland. Today, there are more than 10,000 trains running each day, being routed over 13,000 switches and controlled by more than 32,000 signals. Each day 1.2 million passengers and almost half of Switzerland’s volume of transported goods are transported on this railway network. Due to the growing demand for mobility, SBB needs to increase the transportation capacity of the network by approximately 30% in the future.

The increase in transport capacity can be achieved through different measures, such as [denser train schedules, investments in new infrastructure, and/or investments in new rolling stock](https://smartrail40.ch/index.asp?inc=&lang=en). However, SBB currently lack suitable technologies and tools to quantitatively assess these different measures.

A promising solution to this dilemma is a complete railway simulation that efficiently evaluates the consequences of infrastructure changes or schedule adaptations for network stability and traffic flow. A complete railway simulation consists of a full dynamical physics simulation as well as an automated traffic management system.

<img src="" width="250" />

 ![Flatland](https://s3.eu-central-1.amazonaws.com/aicrowd-static/SBB/images/Flatland_Preview.svg)
 
*This image illustrates an early draft of the environment visualization. The core task of this challenge is to manage and maintain railway traffic on complex scenarios in complex networks.*

🔀 The Vehicle Re-scheduling Problem
---

At the core of this challenge lies the general vehicle re-scheduling problem (VRSP) proposed by Li, Mirchandani and Borenstein in 2007:

> The vehicle rescheduling problem (VRSP) arises when a previously assigned trip is disrupted. A traffic accident, a medical emergency, or a breakdown of a vehicle are examples of possible disruptions that demand the rescheduling of vehicle trips. The VRSP can be approached as a dynamic version of the classical vehicle scheduling problem (VSP) where assignments are generated dynamically.

The Flatland Challenge aims to address the vehicle rescheduling problem by providing a simplistic grid world environment and allowing for diverse solution approaches. The problems are formulated as a 2D grid environment with restricted transitions between neighboring cells to represent railway networks. On the 2D grid, multiple agents with different objectives must collaborate to maximize global reward.