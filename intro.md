Welcome to Flatland
===

![Flatland](https://i.imgur.com/9cNtWjs.gif)

Flatland tackles a major problem in the transportation world:

> **How to efficiently manage dense traffic on complex railway networks?**

This is a hard question! Driving a single train from point A to point B is easy. But how to ensure trains won't block each other at intersections? How to
handle trains that randomly break down?

Flatland is an open-source toolkit to develop and compare solutions for this problem.

[![Main](https://github.com/flatland-association/flatland-rl/actions/workflows/main.yml/badge.svg)](https://github.com/flatland-association/flatland-rl/actions/workflows/main.yml)


⚡ Quick start
---

Flatland is easy to use whether you’re a human or an AI:

```console
$ pip install flatland-rl
$ flatland-demo # show demonstration
$ python <<EOF # random agent
import numpy as np
from flatland.envs.rail_env import RailEnv
env = RailEnv(width=30, height=30)
obs = env.reset()
while True:
    obs, rew, done, info = env.step({
            0: np.random.randint(0, 5),
            1: np.random.randint(0, 5)
        })
    if done:
        break
EOF
```

Features
---------
The Flatland environment provides simplistic representation of a rail network on a grid world to address the vehicle rescheduling problem (VRSP):

 
* 🔬Flatland is used to develop reinforcement learning (RL) solutions to the VRSP
* 🕹️️Trains are agents with a limited action space (⏸️⬅️⬆️➡️⏹️)
* ⏰ Agents have schedules for their origin, destination and intermediate stops 
* 🛤️Railway network includes switches, slips, crossings and over-/underpasses
* 👀  what can each agent "see"?
* 🌟Rewards: what is the metric used to evaluate the agents?
* 🗺Translation from grid representation of the network to a graph representation is implemented
* 🚨Agents have variable speed profiles
* 🔥Agents can be disrupted (in malfunction)

📑 Flatland Paper
---

You can find the Flatland competition paper on arXiv: [https://arxiv.org/abs/2012.05893](https://arxiv.org/abs/2012.05893)

```
@misc{mohanty2020flatlandrl,
      title={Flatland-RL : Multi-Agent Reinforcement Learning on Trains}, 
      author={Sharada Mohanty and Erik Nygren and Florian Laurent and Manuel Schneider and Christian Scheller and Nilabha Bhattacharya and Jeremy Watson and Adrian Egli and Christian Eichenberger and Christian Baumberger and Gereon Vienken and Irene Sturm and Guillaume Sartoretti and Giacomo Spigler},
      year={2020},
      eprint={2012.05893},
      archivePrefix={arXiv},
      primaryClass={cs.AI}
}
```

🔀 The Vehicle Re-scheduling Problem
---

At the core of this challenge lies the general vehicle re-scheduling problem (VRSP) proposed
by [Li, Mirchandani and Borenstein](https://onlinelibrary.wiley.com/doi/abs/10.1002/net.20199) in 2007:

> The vehicle rescheduling problem (VRSP) arises when a previously assigned trip is disrupted. A traffic accident, a medical emergency, or a breakdown of a
> vehicle are examples of possible disruptions that demand the rescheduling of vehicle trips. The VRSP can be approached as a dynamic version of the classical
> vehicle scheduling problem (VSP) where assignments are generated dynamically.

The Flatland environment aims to address the vehicle rescheduling problem by providing a simplistic grid world environment and allowing for diverse solution
approaches. The problems are formulated as a 2D grid environment with restricted transitions between neighboring cells to represent railway networks. On the 2D
grid, multiple agents with different objectives must collaborate to maximize global reward.

🔖 Design principles
---

### Real-word, high impact problem

The Swiss Federal Railways (SBB) operate the densest mixed railway traffic in the world. SBB maintain and operate the biggest railway infrastructure in
Switzerland. Today, there are more than 10,000 trains running each day, being routed over 13,000 switches and controlled by more than 32,000 signals. The
Flatland challenge aims to address the vehicle rescheduling problem by providing a simplistic grid world environment and allowing for diverse solution
approaches. The challenge is open to any methodological approach, e.g. from the domain of reinforcement learning or of operations research.

### Tunable difficulty

All environments support well-calibrated difficulty settings. While we report results using the hard difficulty setting, we make the easy difficulty setting
available for those with limited access to compute power. Easy environments require approximately an eighth of the resources to train.

### Environment diversity

In several environments, it has been observed that agents can overfit to remarkably large training sets. This evidence raises the possibility that overfitting
pervades classic benchmarks like the Arcade Learning Environment, which has long served as a gold standard in reinforcement learning (RL). While the diversity
between different games in an ALE is one of the benchmark’s greatest strengths, the low emphasis on generalization presents a significant drawback. In each game
the question must be asked: are agents robustly learning a relevant skill, or are they approximately memorizing specific
trajectories? <!-- To enable one to answer this question we provide configurable [world generators](env/level_generation). -->

🚉 Next stops
---

- [Step by step introduction to Flatland](key-concepts/env.md)
- [Take part in the Flatland Benchmarks](challenges/flatland-benchmarks)
- [Contribute to Flatland](misc/contributing)
- [Sponsor a Challenge](mailto:contact@flatland-association.org)

📱 Communication
---

Use these channels if you have a problem or a question:

- [Discussion Forum](https://github.com/flatland-association/flatland-rl/discussions)
- [Issue Tracker](https://github.com/flatland-association/flatland-rl/issues/)

🤝 Partners
---

<a href="https://sbb.ch" target="_blank" style="margin-right:30px"><img src="https://upload.wikimedia.org/wikipedia/commons/thumb/7/70/SBB_CFF_FFS_logo.svg/2560px-SBB_CFF_FFS_logo.svg.png" alt="SBB" width="280"/></a>
<a href="https://www.deutschebahn.com/" target="_blank" style="margin-right:30px"><img src="https://i.imgur.com/pjTki15.png" alt="DB"  width="140"/></a>
<a href="https://www.sncf.com/en" target="_blank" style="margin-right:30px"><img src="https://iconape.com/wp-content/png_logo_vector/logo-sncf.png" alt="SNCF"  width="140"/></a>
<a href="https://www.aicrowd.com" target="_blank"><img src="https://i.imgur.com/kBZQGI9.png" alt="AIcrowd"  width="140"/></a>



