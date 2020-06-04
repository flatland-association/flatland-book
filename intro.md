Welcome to Flatland
===

```{admonition} Ongoing Challenge
Take part in the **[NeurIPS 2020 Flatland Challenge](https://www.aicrowd.com/challenges/neurips-2020-flatland-challenge/)** on AIcrowd!
```

Flatland is an open-source toolkit for developing and comparing Multi Agent Reinforcement Learning algorithms in little (or ridiculously large) gridworlds.

![Flatland](https://i.imgur.com/9cNtWjs.gif)

<center><p>
<!--<a class="reference external" href="https://gitlab.aicrowd.com/flatland/flatland"><img alt="arxiv" src="http://img.shields.io/badge/cs.LG-arXiv%3A1809.00510-B31B1B.svg"></a>-->
<a class="reference external" href="https://gitlab.aicrowd.com/flatland/flatland"><img alt="repository" src="https://img.shields.io/static/v1?label=aicrowd.gitlab.com&amp;message=flatland/flatland&amp;color=%3CCOLOR%3E&amp;logo=gitlab"></a>
<!--<a class="reference external" href="https://gitter.im/AIcrowd-HQ/flatland-rl"><img alt="gitter" src="https://img.shields.io/gitter/room/badges/shields.svg"></a>-->
</p></center


Getting started
---

Using the environment is easy for both humans and AIs:

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

**[Make your first Challenge Submission in 5 minutes!](getting-started/first-submission)**

To learn more about Flatland, you can read how to [interact with this environment](getting-started/env), how to get started with [reinforcement learning methods](getting-started/rl) or with [operations research methods](getting-started/or).

To go further, check out the research ongoing around this environment: [multiple baselines](research/baselines) are available, as well as a list of [unexplored research ideas](research/research-ideas). The [best solutions from previous Flatland challenges](research/previous-challenges) are also openly available.

Design principles
---

### Real-word, high impact problem

The Swiss Federal Railways (SBB) operate the densest mixed railway traffic in the world. SBB maintain and operate the biggest railway infrastructure in Switzerland. Today, there are more than 10,000 trains running each day, being routed over 13,000 switches and controlled by more than 32,000 signals. The “Flatland” Competition aims to address the vehicle rescheduling problem by providing a simplistic grid world environment and allowing for diverse solution approaches. The challenge is open to any methodological approach, e.g. from the domain of reinforcement learning or of operations research.


### Tunable difficulty 

All environments support well-calibrated difficulty settings. While we report results using the hard difficulty setting, we make the easy difficulty setting available for those with limited access to compute power. Easy environments require approximately an eighth of the resources to train.

### Environment diversity 

In several environments, it has been observed that agents can overfit to remarkably large training sets. This evidence raises the possibility that overfitting pervades classic benchmarks like the Arcade Learning Environment, which has long served as a gold standard in reinforcement learning (RL). While the diversity between different games in the ALE is one of the benchmark’s greatest strengths, the low emphasis on generalization presents a significant drawback. In each game the question must be asked: are agents robustly learning a relevant skill, or are they approximately memorizing specific trajectories?

Next steps
---

- [Use Flatland for your research](research/baselines)

- [Take part in the NeurIPS challenge](getting-started/first-submission)

- [Contribute to Flatland](misc/contributing)

- [Sponsor the Challenge](mailto:hello@aicrowd.com)


Communication
---

* [Discord Channel](https://discord.com/invite/hCR3CZG)
* [Discussion Forum](https://discourse.aicrowd.com/c/neurips-2020-flatland-challenge)
* [Issue Tracker](https://gitlab.aicrowd.com/flatland/flatland/issues/)


Partners
---

<a href="https://sbb.ch" target="_blank" style="margin-right:25px"><img src="https://i.imgur.com/OSCXtde.png" alt="SBB" width="200"/></a> 
<a href="https://www.deutschebahn.com/" target="_blank" style="margin-right:25px"><img src="https://i.imgur.com/pjTki15.png" alt="DB"  width="200"/></a>
<a href="https://www.aicrowd.com" target="_blank"><img src="https://avatars1.githubusercontent.com/u/44522764?s=200&v=4" alt="AICROWD"  width="200"/></a>



