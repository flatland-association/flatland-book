Multiple Agents
===

```{admonition} Goal
In this tutorial, you will train a multi-agent policy that you can submit to the NeurIPS 2020 Flatland Challenge.
```

We will use the [`multi_agent_training.py`](https://gitlab.aicrowd.com/flatland/baselines/blob/master/torch_training/multi_agent_training.py) file to train multiple agents.

The file in the previous section was kept as simple as possible on purpose. In this section, we want to create a more robust policy that we'll be able to submit in the challenge. We will implement many quality-of-life improvements: command line parameters, utilities to save and restore policies, tools to log metrics about the training process...

We consider that you have already gone through the previous section and won't repeat the details about setting up the environment, creating the policy etc.  

Command line arguments
---

We use the `[argparse](https://pypi.org/project/argparse/)` module to parse command line arguments. These arguments have two purposes: they allow us to tweak the training parameters without having to change the code, and they will also allow us to run simple hyper-parameter sweeps using W&B tools.

We define all the arguments we need with each time their name, a short description, their type, and their default value:

```python
parser = ArgumentParser()
parser.add_argument("-n", "--n_episodes", help="number of episodes to run", default=2500, type=int)
parser.add_argument("-t", "--training_env_config", help="training config id (eg 0 for Test_0)", default=0, type=int)
parser.add_argument("-e", "--evaluation_env_config", help="evaluation config id (eg 0 for Test_0)", default=0, type=int)
parser.add_argument("--n_evaluation_episodes", help="number of evaluation episodes", default=25, type=int)
parser.add_argument("--checkpoint_interval", help="checkpoint interval", default=100, type=int)
parser.add_argument("--eps_start", help="max exploration", default=1.0, type=float)
...
```

`argparse` will do the parsing for us, and can summarize all the arguments by using `--help`:

```console
usage: multi_agent_training.py [-h] [-n N_EPISODES] [-t TRAINING_ENV_CONFIG]
                               [-e EVALUATION_ENV_CONFIG]
                               [--n_evaluation_episodes N_EVALUATION_EPISODES]
                               [--checkpoint_interval CHECKPOINT_INTERVAL]
                               [--eps_start EPS_START] [--eps_end EPS_END]
                               [--eps_decay EPS_DECAY]
                               [--buffer_size BUFFER_SIZE]
                               [--buffer_min_size BUFFER_MIN_SIZE]
                               [--restore_replay_buffer RESTORE_REPLAY_BUFFER]
                               [--save_replay_buffer SAVE_REPLAY_BUFFER]
                               [--batch_size BATCH_SIZE] [--gamma GAMMA]
                               [--tau TAU] [--learning_rate LEARNING_RATE]
                               [--hidden_size HIDDEN_SIZE]
                               [--update_every UPDATE_EVERY]
                               [--use_gpu USE_GPU] [--num_threads NUM_THREADS]
                               [--render RENDER]

optional arguments:
  -h, --help            show this help message and exit
  -n N_EPISODES, --n_episodes N_EPISODES
                        number of episodes to run
  -t TRAINING_ENV_CONFIG, --training_env_config TRAINING_ENV_CONFIG
                        training config id (eg 0 for Test_0)
  -e EVALUATION_ENV_CONFIG, --evaluation_env_config EVALUATION_ENV_CONFIG
                        evaluation config id (eg 0 for Test_0)
  --n_evaluation_episodes N_EVALUATION_EPISODES
                        number of evaluation episodes
  --checkpoint_interval CHECKPOINT_INTERVAL
                        checkpoint interval
  --eps_start EPS_START
                        max exploration
  --eps_end EPS_END     min exploration
  --eps_decay EPS_DECAY
                        exploration decay
  --buffer_size BUFFER_SIZE
                        replay buffer size
  --buffer_min_size BUFFER_MIN_SIZE
                        min buffer size to start training
  --restore_replay_buffer RESTORE_REPLAY_BUFFER
                        replay buffer to restore
  --save_replay_buffer SAVE_REPLAY_BUFFER
                        save replay buffer at each evaluation interval
  --batch_size BATCH_SIZE
                        minibatch size
  --gamma GAMMA         discount factor
  --tau TAU             soft update of target parameters
  --learning_rate LEARNING_RATE
                        learning rate
  --hidden_size HIDDEN_SIZE
                        hidden size (2 fc layers)
  --update_every UPDATE_EVERY
                        how often to update the network
  --use_gpu USE_GPU     use GPU if available
  --num_threads NUM_THREADS
                        number of threads PyTorch can use
  --render RENDER       render 1 episode in 100
```

TODO
---

```{admonition}
More to come...
```