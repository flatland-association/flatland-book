# Combined Observation

```{admonition} TL;DR
This observation allows to combine multiple observation by specifying them in the config file.
```

### 💡 The idea

Provide a simple way to combine multiple observations.

### 🗂️ Files and usage

The observation is defined in [`https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines/blob/master/envs/flatland/observations/combined_obs.py`].

To combine multiple observations, instead of directly putting the observation settings under `observation_config`, use the names of the observations you want to combine as keys to provide the corresponding observation configs (see example).

An example config is located in [`neurips2020-flatland-baselines/baselines/combined_tree_local_conflict_obs/sparse_small_apex_maxdepth2_spmaxdepth30.yaml`](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines/blob/master/baselines/combined_tree_local_conflict_obs/sparse_small_apex_maxdepth2_spmaxdepth30.yaml) and can be run with

Run it with:

```console
$ python ./train.py -f baselines/combined_tree_local_conflict_obs/sparse_small_apex_maxdepth2_spmaxdepth30.yaml  
```

### 📦 Implementation Details

This observation does not generate itself any information for the agent but just naively concatenates the outputs of the specified observations.

### 📈 Results

Since this observations is meant as a helper to easily explore combinations of observations, there is no meaningful baseline. However, we did a run combining tree and local conflict observations as a sanity check:

[![w&b report](images/combined_obs_wb.png)](https://app.wandb.ai/masterscrat/flatland/reports/Tree-and-Conflict-Obs-|-sparse-small_v0--VmlldzoxNTc4MzU)

### 🌟 Credits

- [🐦 Manuel Schneider](https://twitter.com/m_c_schneider)