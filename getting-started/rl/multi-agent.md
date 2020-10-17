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

Hyperparameter Sweeps
---

Evaluating the performance of reinforcement learning approaches is [famously difficult](https://arxiv.org/abs/1709.06560), due to the variance in the results and hyperpamater sensibility.

A good approach to test how robust a method is and to optimize its hyperparameter is to run "hyperparameter sweeps", ie to run many training sessions with slightly different parameters to get a better idea of how well it performs.

For this purpose, we will use the [Weight & Biases Sweep](https://docs.wandb.com/sweeps) tools. We include a [sweep.yml](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-starter-kit/blob/master/sweep.yaml) file which describes a possible search space for the hyperparameters:

```yaml
program: reinforcement_learning/multi_agent_training.py
method: bayes
metric:
    name: evaluation/smoothed_score
    goal: maximize
parameters:
    n_episodes:
        values: [2000]
    hidden_size:
        values: [128, 256, 512]
    buffer_size:
        values: [50000, 100000, 500000, 1000000]
    batch_size:
        values: [16, 32, 64, 128]
    training_env_config:
        values: [0, 1, 2]
```

You can use this file to initialize a sweep:

```console
$ wandb sweep sweep.yaml
wandb: Creating sweep from: sweep.yaml
wandb: Created sweep with ID: tli6g4vw
wandb: View sweep at: https://app.wandb.ai/masterscrat/neurips2020-flatland-starter-kit-reinforcement_learning/sweeps/tli6g4vw
wandb: Run sweep agent with: wandb agent masterscrat/neurips2020-flatland-starter-kit-reinforcement_learning/tli6g4vw
```

You can now run one or multiple instances of the suggested command to start training sessions. The DQN baseline provided in the starter kit runs on a single core, so you can scale up the hyperparameter search by starting as many training sessions as you have cores on your machine.

The results will start pouring in. A nice way to visualize them is to clone [one of the provided W&B report](https://wandb.ai/masterscrat/flatland-examples-reinforcement_learning/reports/Flatland-Starter-Kit-Training-in-environments-of-various-sizes--VmlldzoxNjgxMTk), and to add a new run set containing the metrics from your runs. This makes it easy to compare performance with existing results. 

```{admonition}
More to come...
```