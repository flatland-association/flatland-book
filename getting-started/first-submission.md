
Submit in 5 Minutes
===

```{admonition} TL;DR
This document will show you how to submit a test submission in 5 minutes.
```

🚂 All aboard!
---

In the next five minutes, you will submit your first agent to the [NeurIPS 2020 Flatland Challenge](https://www.aicrowd.com/challenges/neurips-2020-flatland-challenge/) and will see your name on the leaderboard.

![leaderboard](../assets/images/you.png)

If you have any problem along the way, take a look at the [troubleshooting tips](#troubleshooting) at the end of this page. If things still don't go your way, don't hesitate to [ask about it in the forum](https://discourse.aicrowd.com/c/neurips-2020-flatland-challenge).

📦 Setup
---

### Starter Kit

Start by cloning the starter kit: 

```console
$ git clone https://gitlab.aicrowd.com/flatland/neurips2020-flatland-starter-kit.git/
$ cd flatland-challenge-starter-kit
```

The starter kit comes with a sample agent which performs random actions. We will see how it works in more details in the last section.
For now we'll just submit it as is to see how the process works.

<!--
### Extra steps on Windows

This is for Windows users only!

1. Enable [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) on Windows.
2. Get [Ubuntu](https://www.microsoft.com/en-us/p/ubuntu/9nblggh4msv6?SilentAuth=1&wa=wsignin1.0&activetab=pivot:overviewtab) for Windows.
3. Run your **Ubuntu** system on your computer
4. Now let us install the **Dependencies**. From within the **Ubuntu-Shell** run:

First download **Anaconda**  by running this in the **Ubuntu Shell**:

```{warning}
You need the **Linux** version and not Windows version!
```

```console
$ wget https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh 
```

Install **Anaconda** for Ubuntu:

```console
$ chmod +x Anaconda3-2019.07-Linux-x86_64.sh 
$ ./Anaconda3-2019.07-Linux-x86_64.sh 
```

You may have to restart Ubuntu for all changes to take effect.
-->

### Create the conda environment

Flatland uses the conda package manager. [Install it](https://www.anaconda.com/products/individual) if it is not setup on your machine.

You can now run the following:

```console
$ conda env create -f environment.yml # creates the flatland-rl environment
$ conda activate flatland-rl # activates it
```


✅ Test your local setup
---

We will now run the agent locally to check that it works as expected.

Let's download the test environments. Head to the [challenge resources](https://www.aicrowd.com/challenges/neurips-2020-flatland-challenge/dataset_files) and download the provided test set. Untar them in `./scratch/test-envs`. 

Your directory structure should be as follow:

```
./scratch
└── test-envs
    ├── Test_0
    │   ├── Level_0.pkl
    │   └── Level_1.pkl
    ├── Test_1
    │   ├── Level_0.pkl
    │   └── Level_1.pkl
    ├── Test_2
    │   ├── Level_0.pkl
    │   └── Level_1.pkl
    ├── Test_3
    │   ├── Level_0.pkl
    │   └── Level_1.pkl
    ├── ...
``` 

We will now replicate the setup used on AIcrowd locally to ensure that your submission will be evaluated without problem when you submit it. 
This involves three components: your agent, the evaluator service, and a Redis server to let them communicate. 

#### Redis

The communication between your agent and the evaluator is done through a Redis server. You should ensure that a redis server is running on localhost. Follow [these instructions](https://redis.io/topics/quickstart) to set it up.

You can check that things are ready by running:

```console
$ redis-cli ping
PONG
```

#### Evaluator service

Let's start the evaluator service. You should use different terminals for the evaluator and the agent as they will need to run at the same time.

```bash
$ flatland-evaluator --tests ./scratch/test-envs/
```

#### The agent

You can now start the agent:

```bash
$ # on Linux
$ export AICROWD_TESTS_FOLDER=./scratch/test-envs/
$ # or on Windows :
$ #  SET AICROWD_TESTS_FOLDER=./scratch/test-envs/
$ python run.py
```

That's it! the agent should now start interacting with the evaluator, and you should see the results coming in.

```console
$ flatland-evaluator --tests ./scratch/test-envs/
['Test_12/Level_0.pkl', 'Test_1/Level_1.pkl', 'Test_10/Level_1.pkl', 'Test_11/Level_0.pkl', 'Test_8/Level_0.pkl', 'Test_4/Level_1.pkl', 'Test_2/Level_1.pkl', 'Test_5/Level_0.pkl', 'Test_7/Level_0.pkl', 'Test_6/Level_1.pkl', 'Test_3/Level_1.pkl', 'Test_7/Level_1.pkl', 'Test_9/Level_1.pkl', 'Test_10/Level_0.pkl', 'Test_6/Level_0.pkl', 'Test_2/Level_0.pkl', 'Test_11/Level_1.pkl', 'Test_0/Level_1.pkl', 'Test_0/Level_0.pkl', 'Test_9/Level_0.pkl', 'Test_4/Level_0.pkl', 'Test_13/Level_0.pkl', 'Test_12/Level_1.pkl', 'Test_8/Level_1.pkl', 'Test_3/Level_0.pkl', 'Test_5/Level_1.pkl', 'Test_13/Level_1.pkl', 'Test_1/Level_0.pkl']
Listening at :  flatland-rl::FLATLAND_RL_SERVICE_ID::commands
Evaluating : Test_12/Level_0.pkl
Evaluating : Test_1/Level_1.pkl
Evaluating : Test_10/Level_1.pkl
Evaluating : Test_11/Level_0.pkl
Evaluating : Test_8/Level_0.pkl
Evaluating : Test_4/Level_1.pkl
...
```

You don't need to let the evaluation run until the end, since right now it is just using a random agent. The goal is simply to check that everything works as expected. 

When you will start implementing your own agents, this will allow you to check that your solutions are fully working.

🗂️ Code structure
---

There are two files that need to be present in your repository for the evaluation to work as intended: `aicrowd.json` to indicate which challenge you are taking part in, and `run.sh` which serves as the entrypoint of your solution.

### aicrowd.json

Each repository must have an `aicrowd.json` file with the following content:

```json
{
  "challenge_id": "neurips-2020-flatland-challenge",
  "grader_id": "neurips-2020-flatland-challenge",
  "debug": true
}
```

This is used to map your submission to the proper challenge. The starter kit repository includes a sample `aicrowd.json` with the correct values.

If you set `debug` to `true`, then the evaluation will run on a smaller set of 28 environments, and the logs from your submitted code (if it fails) will be made available to you to help you debug. These test submissions won't count against your daily limit and won't appear on the leaderboard.

```{warning}
By default we have set `debug` to `true`, so when you are ready to make a competitive submission, make sure to set `debug` to `false`!
```

### run.sh

The starter kit repository includes a sample `run.sh` file so by default you don't need to change it. The default `run.sh` file call the `run.py` file, which is where you would usually implement your solution. 

📤 Submitting!
---

To submit to the challenge, you will use [git tags](https://git-scm.com/book/en/v2/Git-Basics-Tagging). You are allowed to submit up to 5 submissions per day.

#### Create your repository

Head to [gitlab.aicrowd.com/projects/new](https://gitlab.aicrowd.com/projects/new) to create your private repository. You can use any name you want for it.

![](../assets/images/create-repo.png)

#### Push a tag

You first need to add an SSH key to your GitLab account by following [these instructions](https://docs.gitlab.com/ee/ssh/README.html#adding-an-ssh-key-to-your-gitlab-account). If you do not have SSH Keys, you will first need to [generate a pair](https://docs.gitlab.com/ee/ssh/README.html#generating-a-new-ssh-key-pair).

You can then create a submission by **pushing a tag** to your repository.

First add a git remote pointing to your newly created repository:

```console
$ # change the line below to use your AIcrowd username and repository name:
$ git remote add aicrowd git@gitlab.aicrowd.com:<YOUR_AICROWD_USER_NAME>/<YOUR_REPO_NAME>.git
$ git push aicrowd master
```

Finally submit your solution by creating a tag for your submission and pushing it:

```console
$ git tag submission-v0.1 # needs a new tag name for each submission!
$ git push aicrowd master
$ git push aicrowd submission-v0.1
```

```{admonition} Submission tags
Any tag push where the tag name begins with "submission-" to your private repository is considered as a submission!
You are allowed up to 5 submissions per day.
```

Note that if the content of your repository does not change, then pushing a new tag will **not** trigger a new evaluation.

You should now be able to see the details of your submission at:

[https://gitlab.aicrowd.com/<YOUR_AICROWD_USER_NAME>/<YOUR_REPO_NAME>/issues](#)

You should start seeing something like this take shape at the address above: 

![submission issue](../assets/images/submission-issue.png)

Be patient, the evaluation will take some time! 🕙

🚉 Next stops
---

Take a look at the [agent provided in the starter kit](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-starter-kit/blob/master/run.py#L21). It simply takes random actions for each agent at every timestep: 

```python
def my_controller(obs, number_of_agents):
    _action = {}
    for _idx in range(number_of_agents):
        _action[_idx] = np.random.randint(0, 5)
    return _action
```

Surely you can do better! 💪

Head over to the [reinforcement learning in Flatland introduction](rl) to get started with simple RL methods such as Double DQN. 

To go further, explore the [research baselines](../research/baselines) which use RLlib to train using advanced algorithms such as Ape-X, PPO or imitation learning methods such as MARWIL.

🐛 Troubleshooting
---

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