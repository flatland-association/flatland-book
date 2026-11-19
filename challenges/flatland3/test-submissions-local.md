Testing Submissions Locally
===================

```{admonition} TL;DR
This document explains how to test your submission locally before making a submission to AIcrowd.
Though this is optional, it can be helpful to debug your code without having to submit and wait for the results. 
```

📦 Setup
---
The instructions for the local evaluator assume that you have the `flatland-rl` pip package installed locally and your agent follows the specified format. Read the `README` and `random_agent.py` on the [starter kit](https://gitlab.aicrowd.com/flatland/flatland-starter-kit) to go through the folder structure and other information in detail.

Here is the same process explained in brief just for getting the local evaluator running.

### Register 

Sign up on AIcrowd and Click on `Participate` on the [challenge page](https://www.aicrowd.com/challenges/flatland-3).

### Starter Kit

Start by cloning the [starter kit](https://gitlab.aicrowd.com/flatland/flatland-starter-kit): 

```bash
$ git clone https://gitlab.aicrowd.com/flatland/flatland-starter-kit.git/
$ cd flatland-starter-kit
```

The starter kit consists of a full template you can directly submit to the competition!

### Create the conda environment

The start kit uses the conda package manager. [Install conda or miniconda](https://www.anaconda.com/products/individual) if it is not setup on your machine.

After that, you can now run the following:

```bash
$ conda env create -f environment.yml # creates the flatland-rl environment
$ conda activate flatland-rl # activates it
$ pip install -U flatland-rl
```

```{note}
Flatland is tested with Python 3.6 and 3.7 on modern versions of macOS and Linux. We are unable to support Windows completely at this time. WSL is known to work but you may encounter problems with graphical rendering. Your [contribution is welcome](../../contributing.md) if you can help with this!
```

✅ Test your local setup
---

We will now run the agent locally to check that it works as expected.

Let's download the debug environments. Head to the [challenge resources](https://www.aicrowd.com/challenges/flatland-3/dataset_files) and download the provided `debug-environments.zip`. 

After unzipping it, your directory structure should be as follows:

```
./debug-environments
    ├── metadata.csv
    ├── Test_0
    │   ├── Level_0.pkl
    │   └── Level_1.pkl
    └── Test_1
        ├── Level_0.pkl
        ├── Level_1.pkl
        └── Level_2.pkl

``` 

We will now replicate the setup used on AIcrowd on your local machine to ensure that your submission will be evaluated without problem when you submit it. 
This involves three components: your **agent**, the **evaluator service**, and a **Redis server** to let them communicate. 

#### Redis

The communication between your agent and the evaluator is done through a Redis server. You should ensure that a redis server is running on localhost. Follow [these instructions](https://redis.io/topics/quickstart) to set it up.

You can check that things are ready by running:

```console
$ redis-cli ping
PONG
```

#### Evaluator service

Let's start the evaluator service. The `flatland-evaluator` cli command should be available globally when you're on the flatland environment. You should use <u>different terminals for the evaluator and the agent</u> as they will need to run at the same time.

```bash
$ flatland-evaluator --tests ./debug-environments/ --shuffle False
```
You should see the evaluator starting up and listening for an agent.
```console
$ flatland-evaluator --tests ./debug-environments/ --shuffle False
====================
Max pre-planning time: 600      
Max step time: 10
Max overall time: 7200
Max submission startup time: 300
Max consecutive timeouts: 10    
====================
['Test_0/Level_0.pkl', 'Test_0/Level_1.pkl', 'Test_1/Level_0.pkl', 'Test_1/Level_1.pkl', 'Test_1/Level_2.pkl']
['Test_0/Level_0.pkl', 'Test_0/Level_1.pkl', 'Test_1/Level_0.pkl', 'Test_1/Level_1.pkl', 'Test_1/Level_2.pkl']
Listening at :  flatland-rl::FLATLAND_RL_SERVICE_ID::commands
```

#### The agent

You can now start the agent in a new terminal:

```bash
$ conda activate flatland-rl # environment needs to be activated in each new tab
$ export AICROWD_TESTS_FOLDER=./debug-environments/
$ python run.py
```

The agent should now start interacting with the evaluator, and you should see the results coming in on the terminal running the service:

```console
$ flatland-evaluator --tests ./debug-environments/ --shuffle False
====================
Max pre-planning time: 600
Max step time: 10
Max overall time: 7200
Max submission startup time: 300
Max consecutive timeouts: 10
====================
['Test_0/Level_0.pkl', 'Test_0/Level_1.pkl', 'Test_1/Level_0.pkl', 'Test_1/Level_1.pkl', 'Test_1/Level_2.pkl']
['Test_0/Level_0.pkl', 'Test_0/Level_1.pkl', 'Test_1/Level_0.pkl', 'Test_1/Level_1.pkl', 'Test_1/Level_2.pkl']
Listening at :  flatland-rl::FLATLAND_RL_SERVICE_ID::commands
 -- [DEBUG] [env_create] EVAL DONE:  False
 -- [DEBUG] [env_create] SIM COUNT:  1 5
===============
Evaluating Test_0/Level_0.pkl (1/5)
Percentage for test 0, level 0: 0.0
Evaluation finished in 49 timesteps, 0.392 seconds. Percentage agents done: 0.000. Normalized reward: 0.429. Number of malfunctions: 0.
Total normalized reward so far: 0.429
 -- [DEBUG] [env_create] EVAL DONE:  False
 -- [DEBUG] [env_create] SIM COUNT:  2 5
===============
Evaluating Test_0/Level_1.pkl (2/5)
Percentage for test 0, level 1: 0.0
Evaluation finished in 40 timesteps, 0.167 seconds. Percentage agents done: 0.000. Normalized reward: -0.050. Number of malfunctions: 0.
Total normalized reward so far: 0.379
 -- [DEBUG] [env_create] EVAL DONE:  False
 -- [DEBUG] [env_create] SIM COUNT:  3 5
===============
The mean percentage of done agents during the last Test (2 environments) was too low: 0.000 < 0.25 Evaluation will stop.
 -- [DEBUG] [env_create] return obs = False (END)
Overall Message Queue Latency :  0.001744272861074894
====================================================================================================
====================================================================================================
## Server Performance Stats
====================================================================================================
         - message_queue_latency         => min: 0.001425027847290039 || mean: 0.0017366003482899768 || max: 0.004090070724487305
         - current_episode_controller_inference_time     => min: 3.457069396972656e-05 || mean: 3.9261378599016865e-05 || max: 0.00010800361633300781
         - controller_inference_time     => min: 3.457069396972656e-05 || mean: 3.9261378599016865e-05 || max: 0.00010800361633300781
         - internal_env_step_time        => min: 0.0008053779602050781 || mean: 0.001969774117630519 || max: 0.08164787292480469
====================================================================================================
####################################################################################################
EVALUATION COMPLETE !!
####################################################################################################
# Mean Reward : -175.0
# Sum Normalized Reward : 0.37857142857142856 (primary score)
# Mean Percentage Complete : 0.0 (secondary score)
# Mean Normalized Reward : 0.18929
####################################################################################################
####################################################################################################
```

After modifying the template agent, this process will allow you to check that your solution is fully working.


🐛 Troubleshooting
---

### "`env_client.step() called before env_client.env_create() call`"

This occurs if a previous local evaluation was interrupted. The client communicates with the evaluator service through Redis, and sometimes data in Redis can be left in an intermediate state that prevents a new evaluation from starting.

```{warning}
The commands that follow will delete all the data in your Redis database. Don't run them if you use this Redis database for other purposes!
```

To solve this problem, run the following commands:

```console
$ redis-cli 
127.0.0.1:6379> FLUSHALL
```

If you often interrupt submissions, you can systematically cleanup the Redis database before starting the evaluator:

```console
redis-cli -c "flushall"; flatland-evaluator --tests ./debug-environments/ --shuffle False
```

### "`unknown locale: UTF-8`"

This happens on macOS. Append this to your `~/.bash_profile`:

```console
$ export LC_ALL=en_US.UTF-8
$ export LANG=en_US.UTF-8
```

And then run:

```console
$ source ~/.bash_profile
```

[More details](https://stackoverflow.com/a/38917471/318557)

### "`activate is not a conda command`"

This error can have various causes. Most commonly, this means that your conda installation is either too old, or misconfigured in some way. The easiest fix is to update conda to the latest version and re-install it if it keeps failing.
