# Multi-Agent Pettingzoo Usage

## Installation

Install the additional libraries required for petting zoo and various RL trainings as follows

```bash
pip install -r flatland/contrib/requirements_training.txt
```

## Usage

We can use the PettingZoo interface by proving the rail env to the petting zoo wrapper as shown below in the example.

```python
    env = flatland_env.env(environment=rail_env, use_renderer=True)
    seed = 11
    env.reset(random_seed=seed)
    step = 0
    ep_no = 0
    frame_list = []
    while ep_no < total_episodes:
        for agent in env.agent_iter():
            obs, reward, done, info = env.last()
            # act = env_generators.get_shortest_path_action(env.environment, get_agent_handle(agent))
            act = 2
            all_actions_pettingzoo_env.append(act)
            env.step(act)
            frame_list.append(PIL.Image.fromarray(env.render(mode='rgb_array')))
            step += 1
```



## Multi-Agent Interface Stable Baseline 3 Training

We can use the PettingZoo interface to train a PPO using [Stable Baselines 3](https://stable-baselines.readthedocs.io/)  as shown below in the example.

```python

env = flatland_env.parallel_env(environment=rail_env, use_renderer=False)

env_steps = 1000  # 2 * env.width * env.height  # Code uses 1.5 to calculate max_steps
rollout_fragment_length = 50
env = ss.pettingzoo_env_to_vec_env_v0(env)
env = ss.concat_vec_envs_v0(env, 1, num_cpus=1, base_class='stable_baselines3')

model = PPO(MlpPolicy, env, tensorboard_log=f"/tmp/{experiment_name}", verbose=3, gamma=0.95, 
    n_steps=rollout_fragment_length, ent_coef=0.01, 
    learning_rate=5e-5, vf_coef=1, max_grad_norm=0.9, gae_lambda=1.0, n_epochs=30, clip_range=0.3,
    batch_size=150, seed=seed)
train_timesteps = 100000
model.learn(total_timesteps=train_timesteps)
model.save(f"policy_flatland_{train_timesteps}")

```


## Multi-Agent Interface RLlib Training

We can use the PettingZoo interface to train a PPO using [RLlib](https://docs.ray.io/en/latest/rllib.html)  as shown below in the example.

```python


def env_creator(args):
    env = flatland_env.parallel_env(environment=rail_env, use_renderer=False)
    return env


if __name__ == "__main__":
    env_name = "flatland_pettyzoo"

    register_env(env_name, lambda config: ParallelPettingZooEnv(env_creator(config)))

    test_env = ParallelPettingZooEnv(env_creator({}))
    obs_space = test_env.observation_space
    act_space = test_env.action_space

    def gen_policy(i):
        config = {
            "gamma": 0.99,
        }
        return (None, obs_space, act_space, config)

    policies = {"policy_0": gen_policy(0)}

    policy_ids = list(policies.keys())

    tune.run(
        "PPO",
        name="PPO",
        stop={"timesteps_total": 5000000},
        checkpoint_freq=10,
        local_dir="~/ray_results/"+env_name,
        config={
            # Environment specific
            "env": env_name,
            # https://github.com/ray-project/ray/issues/10761
            "no_done_at_end": True,
            # "soft_horizon" : True,
            "num_gpus": 0,
            "num_workers": 2,
            "num_envs_per_worker": 1,
            "compress_observations": False,
            "batch_mode": 'truncate_episodes',
            "clip_rewards": False,
            "vf_clip_param": 500.0,
            "entropy_coeff": 0.01,
            # effective batch_size: train_batch_size * num_agents_in_each_environment [5, 10]
            # see https://github.com/ray-project/ray/issues/4628
            "train_batch_size": 1000,  # 5000
            "rollout_fragment_length": 50,  # 100
            "sgd_minibatch_size": 100,  # 500
            "vf_share_layers": False
            },
    )

```
