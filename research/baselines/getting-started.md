# Getting started

## Setup

The setup uses conda, [install it](https://www.anaconda.com/products/individual) if necessary.

```
# with GPU support:
conda env create -f environment-gpu.yml
conda activate flatland-baseline-gpu-env

# or, without GPU support:
conda env create -f environment-cpu.yml
conda activate flatland-baseline-cpu-env
```

## Training

Let's train a policy on a 25x25 environment with 5 agents using Ape-X:  

```console
$ python ./train.py -f baselines/apex_tree_obs/apex.yaml
```

This training will start, and provide status updates from time to time:

```console
Resources requested: 4/8 CPUs, 0/0 GPUs, 0.0/4.49 GiB heap, 0.0/1.56 GiB objects
Result logdir: /Users/flaurent/ray_results/flatland-sparse-small-tree-fc-apex
Number of trials: 1 (1 RUNNING)
+----------------------------+----------+-------+
| Trial name                 | status   | loc   |
|----------------------------+----------+-------|
| APEX_flatland_sparse_00000 | RUNNING  |       |
+----------------------------+----------+-------+
...
+----------------------------+----------+--------------------+--------+------------------+-------+----------+
| Trial name                 | status   | loc                |   iter |   total time (s) |    ts |   reward |
|----------------------------+----------+--------------------+--------+------------------+-------+----------|
| APEX_flatland_sparse_00000 | RUNNING  | 192.168.1.22:76819 |      2 |          400.018 | 62878 |  -1937.4 |
+----------------------------+----------+--------------------+--------+------------------+-------+----------+
...
```

Let's have a look at `baselines/apex_tree_obs/apex.yaml`, the experiment configuration file we have used:

```yaml
flatland-sparse-small-tree-fc-apex:
    run: APEX
    env: flatland_sparse
    stop:
        timesteps_total: 5000000 # 5e6
    checkpoint_freq: 10
    checkpoint_at_end: True
    keep_checkpoints_num: 5
    checkpoint_score_attr: episode_reward_mean
    config:
        num_workers: 3
        num_envs_per_worker: 5
        num_gpus: 0

        env_config:
            observation: tree
            observation_config:
                max_depth: 2
                shortest_path_max_depth: 30

            generator: sparse_rail_generator
            generator_config: small_v0

            wandb:
                project: <w&b project name>
                entity: <w&b username>
                tags: ["small_v0", "tree_obs", "apex"]

        model:
            fcnet_activation: relu
            fcnet_hiddens: [256, 256]
            vf_share_layers: True
```

- We train for a `timesteps_total` of 5 millions steps using the `APEX` method.
- We use 3 workers (`num_workers`), which means 3 cores will be used. We don't use a GPU (`num_gpus: 0`).
- We use the `flatland_sparse` environment, which is the standard one that uses the [`sparse_rail_generator` and `sparse_scedule_generator`](../getting-started/env/level_generation). 
- We use a [tree observation](../getting-started/env/observations) with a `max_depth` of 2 and a `shortest_path_max_depth` of 30.
- The model is a simple fully connected 2-layer neural with a relu non-linearity.
- Optionally, you can export the training metrics to [Weights & Biases](https://www.wandb.com/), in which case you need to specify your username and a project name.

Let's look more closely at the environment that we use: we use the `generator_config` called `small_v0`. The various generator configs are located in [`envs/flatland/generator_configs`](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines/tree/master/envs/flatland/generator_configs). This specific generator config looks as follow:

```yaml
width: 25
height: 25
number_of_agents: 5
max_num_cities: 4
grid_mode: False
max_rails_between_cities: 2
max_rails_in_city: 3
seed: 0
regenerate_rail_on_reset: True
regenerate_schedule_on_reset: True
```

This is the configuration used for all the baseline benchmarks. As stated before, it consists of a 25x25 environments with 5 agents. By storing the environment generator configurations in such files, we make it easier to compare various methods on the same task.

## Troubleshooting

### "ray.tune.error.TuneError: Insufficient cluster resources to launch trial"

This error means that you don't have the hardware resources required to run the training. Adjust the value of `num_workers` and `num_gpus` to match your hardware. Not that you will need one core per worker, and an extra core for the learning process. 