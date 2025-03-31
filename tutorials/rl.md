Reinforcement Learning
======================

Both RLlib and PettingZoo environment wrappers are [Gymnasium](https://gymnasium.farama.org/)-compatible.
Gymnasium is a maintained fork of OpenAI’s Gym library. The Gymnasium interface is simple, pythonic, and capable of representing general RL problems, and has
a [compatibility wrapper](https://gymnasium.farama.org/introduction/gym_compatibility/) for old Gym environments.

RLlib
-----
We provide a Flatland wrapper for ray RLlib multi-agent environment (https://docs.ray.io/en/latest/rllib/multi-agent-envs.html).

RLlib is an open source library for reinforcement learning (RL), offering support for production-level, highly scalable, and fault-tolerant RL workloads, while
maintaining simple and unified APIs for a large variety of industry applications

🔬See [Flatland RLlib Demo](rl/rllib_demo).

📖See also: RLlib: Abstractions for Distributed Reinforcement Learning, https://arxiv.org/abs/1712.09381

PettingZoo
----------
We Provider a Flatland wrapper for PettingZoo parallel API (https://pettingzoo.farama.org/api/parallel/) for environments where all agents have simultaneous
actions and observations.
This API is based around the paradigm of Partially Observable Stochastic Games (POSGs) and the details are similar to RLlib’s MultiAgent environment
specification,
except it allows for different observation and action spaces between the agents.

🔬See [Flatland PettingZoo Demo](rl/pettingzoo_demo).

📖See also PettingZoo: A Standard API for Multi-Agent Reinforcement Learning, https://arxiv.org/pdf/2009.14471


