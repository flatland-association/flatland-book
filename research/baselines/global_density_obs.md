# Global Density Observation

```{admonition} TL;DR
This observation is a global observation, that provides an agent with information on its own and the other agents predicted paths. The paths are predicted from the shortest path of each agent to its respective target. The information is encoded into a density map.
```

### 💡 The idea

The density observation is based on the idea that every agent's path to its target is represented in a discrete map of the environment assigning each location (cell) a value encoding the information if and when the cell will be occupied. For simplicity, we assume that an agent follows the shortest path to its target and don't consider alternative paths. The individual values along the agents' shortest paths are combined into a "density" for each cell. 

For example, if all agents would occupy the same cell at the same time step, the density would be very high. If the agents would use the same cell but at different time steps the density for that cell would be lower. 

The density map therefore potentially allows the agents to learn from the (projected) cell occupancy distribution.

### 🗂️ Files and usage

#### 🎛️ Parameters

The observation can be configured with the following parameters:
* `width` and `height`: have to correspond to the shape of the environment
* `max_t`: max number of time steps the path of each agent is predicted for
* `encoding`: defining how to factor in the time information into the density value (2d options: `exp_decay`, `lin_decay`, `binary`; 3d option: `series`; see next section for more details)

#### 🚂 Training

Example configuration: [`neurips2020-flatland-baselines/baselines/global_density_obs/sparse_small_apex_expdecay_maxt1000.yaml`](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines/blob/master/baselines/global_density_obs/sparse_small_apex_expdecay_maxt1000.yaml).

Run it with:

```console
$ python ./train.py -f baselines/global_density_obs/sparse_small_apex_expdecay_maxt1000.yaml`  
```

#### 👀 Observation

The observation is implemented in [`neurips2020-flatland-baselines/envs/flatland/observations/global_density_obs.py`](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines/blob/master/envs/flatland/observations/global_density_obs.py)

#### 🧠 Model

The model is implemented in [`neurips2020-flatland-baselines/models/global_dens_obs_model.py`](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines/blob/master/models/global_dens_obs_model.py)

### 📦 Implementation Details

The observation for each agent consists of two arrays representing the cells of the environment. The first array contains the density values for the agent itself, and the second one the mean of the other agents' values for each cell. The arrays are either two or three dimensional depending on the encoding.

The idea behind this parameter is to provide a way to compress the space and time information into a 2d representation. However, it is possible to get a 3d observation with a separate, 2d density map for each time step, by using the option `series` (for "time series") for the encoding. In this case, a binary representation for the individual agent occupancies is used.

The other options use a function of the time step `t` and the maximal time step `max_t` to determine the density value:
* exp_decay: $e^(-t / max_t^(1/2))$
* lin_decay: $(max_t - t) / max_t$
* binary: $1$

We created a custom model (`GlobalDensObsModel`) for this observation that uses a convolutional neural network to process the observation. For the experiments, we used the [IMPALA](#links) implementation.


### 📈 Results

We trained the agents with the different encoding options and different values for `max_t` using [Ape-X](#links). However, we didn't search systematically or exhaustively for the best settings.

The best runs achieved around **45% mean completion** on the sparse, small flatand environment (`small_v0`) with `max_t = 1000` and `encoding = exp_decay`. The mean completion rate is considerably lower than the tree observation but shows that learning is possible from global observations and can inform approaches to combine local, tree and global observations.

[Full metrics of the training runs can be found in the *Weights & Biases* report](https://app.wandb.ai/masterscrat/flatland/reports/Density-Obs-|-sparse-small_v0--VmlldzoxMTYxMDE)

[w&b report](https://app.wandb.ai/masterscrat/flatland/reports/Density-Obs-|-sparse-small_v0--VmlldzoxMTYxMDE)


### 🔗 Links

* [IMPALA Paper – IMPALA: Scalable Distributed Deep-RL with Importance Weighted Actor-Learner Architectures (Espeholt et al.)](https://arxiv.org/abs/1802.01561)
* [Ape-X Paper – Distributed Prioritized Experience Replay (Horgan et al.)](https://arxiv.org/abs/1803.00933)

### 🌟 Credits

- [🐦 Manuel Schneider](https://twitter.com/m_c_schneider)