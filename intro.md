Welcome to Flatland
===


```{admonition} Ongoing Challenge
Take part in the **[AMLD 2021 Flatland Challenge](https://www.aicrowd.com/challenges/flatland)** on AIcrowd!
```

![Flatland](https://i.imgur.com/9cNtWjs.gif)

Flatland tackles a major problem in the transportation world: 

> **How to efficiently manage dense traffic on complex railway networks?**

This is a hard question! Driving a single train from point A to point B is easy. But how to ensure trains won't block each others at intersections? How to handle trains that randomly break down? 

Flatland is an open-source toolkit to develop and compare solutions for this problem.

<center><p>
<!--<a class="reference external" href="https://gitlab.aicrowd.com/flatland/flatland"><img alt="arxiv" src="http://img.shields.io/badge/cs.LG-arXiv%3A1809.00510-B31B1B.svg"></a>-->
<a class="reference external" href="https://gitlab.aicrowd.com/flatland/flatland"><img alt="repository" src="https://img.shields.io/static/v1?label=aicrowd.gitlab.com&amp;message=flatland/flatland&amp;color=%3CCOLOR%3E&amp;logo=gitlab"></a>
<a class="reference external" href="https://discord.com/invite/hCR3CZG"><img alt="discord" src="https://img.shields.io/static/v1?label=discord&message=neurips2020-flatland-challenge&color=%3CCOLOR%3E&logo=discord"></a>
</p></center>


⚡ Quick start
---

Flatland is easy to use whether you’re a human or an AI:

```console
$ pip install flatland-rl
$ flatland-demo # show demonstration
$ python <<EOF # random agent
import numpy as np
from flatland.envs.rail_env import RailEnv
env = RailEnv(width=16, height=16)
obs = env.reset()
while True:
    obs, rew, done, info = env.step({0: np.random.randint(0, 5)})
    if done:
        break
EOF
```

Want to dive straight in? **[Make your first submission to the NeurIPS 2020 challenge in 10 minutes!](getting-started/first-submission)**


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

At the core of this challenge lies the general vehicle re-scheduling problem (VRSP) proposed by [Li, Mirchandani and Borenstein](https://onlinelibrary.wiley.com/doi/abs/10.1002/net.20199) in 2007:

> The vehicle rescheduling problem (VRSP) arises when a previously assigned trip is disrupted. A traffic accident, a medical emergency, or a breakdown of a vehicle are examples of possible disruptions that demand the rescheduling of vehicle trips. The VRSP can be approached as a dynamic version of the classical vehicle scheduling problem (VSP) where assignments are generated dynamically.

The Flatland environment aims to address the vehicle rescheduling problem by providing a simplistic grid world environment and allowing for diverse solution approaches. The problems are formulated as a 2D grid environment with restricted transitions between neighboring cells to represent railway networks. On the 2D grid, multiple agents with different objectives must collaborate to maximize global reward.

🔖 Design principles
---

### Real-word, high impact problem

The Swiss Federal Railways (SBB) operate the densest mixed railway traffic in the world. SBB maintain and operate the biggest railway infrastructure in Switzerland. Today, there are more than 10,000 trains running each day, being routed over 13,000 switches and controlled by more than 32,000 signals. The Flatland challenge aims to address the vehicle rescheduling problem by providing a simplistic grid world environment and allowing for diverse solution approaches. The challenge is open to any methodological approach, e.g. from the domain of reinforcement learning or of operations research.


### Tunable difficulty 

All environments support well-calibrated difficulty settings. While we report results using the hard difficulty setting, we make the easy difficulty setting available for those with limited access to compute power. Easy environments require approximately an eighth of the resources to train.

### Environment diversity 

In several environments, it has been observed that agents can overfit to remarkably large training sets. This evidence raises the possibility that overfitting pervades classic benchmarks like the Arcade Learning Environment, which has long served as a gold standard in reinforcement learning (RL). While the diversity between different games in an ALE is one of the benchmark’s greatest strengths, the low emphasis on generalization presents a significant drawback. In each game the question must be asked: are agents robustly learning a relevant skill, or are they approximately memorizing specific trajectories? <!-- To enable one to answer this question we provide configurable [world generators](env/level_generation). -->

🚉 Next stops
---

- [Step by step introduction to Flatland](getting-started/env)
- [Take part in the NeurIPS challenge](getting-started/first-submission)
- [Use Flatland for your research](research/philosophy)
- [Contribute to Flatland](misc/contributing)
- [Sponsor a Challenge](mailto:hello@aicrowd.com)

📱 Communication
---

Join the Discord channel to exchange with other participants:

- [Discord Channel](https://discord.com/invite/hCR3CZG)

Use these channels if you have a problem or a question for the organizers:

- [Discussion Forum](https://discourse.aicrowd.com/c/neurips-2020-flatland-challenge)
- [Issue Tracker](https://gitlab.aicrowd.com/flatland/flatland/issues/)


🤝 Partners
---

<a href="https://sbb.ch" target="_blank" style="margin-right:30px"><img src="https://i.imgur.com/OSCXtde.png" alt="SBB" width="250"/></a> 
<a href="https://www.deutschebahn.com/" target="_blank" style="margin-right:30px"><img src="https://i.imgur.com/pjTki15.png" alt="DB"  width="150"/></a>
<a href="https://www.aicrowd.com" target="_blank"><img src="https://i.imgur.com/kBZQGI9.png" alt="AIcrowd"  width="150"/></a>



