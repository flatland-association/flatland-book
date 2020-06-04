
Submit in 5 Minutes
===

All aboard! 🚂
---

In the next five minutes, you will submit your first agent to the [NeurIPS 2020 Flatland Challenge](https://www.aicrowd.com/challenges/neurips-2020-flatland-challenge/) and will see your name on the leaderboard.

![leaderboard](assets/images/you.png)


Setup
---

Start by cloning the starter kit: 

```bash
git clone https://gitlab.aicrowd.com/flatland/neurips2020-flatland-starter-kit.git/
cd flatland-challenge-starter-kit
```

The starter kit comes with a sample agent which performs random actions. We will see how it works in more details in the last section.

Create a conda environment for Flatland, [install conda](https://www.anaconda.com/products/individual) first if needed. This is straightforward is you are using Linux or macOS. If you use Windows, follow the steps from the next section instead.

```bash
conda env create -f environment.yml # creates the flatland-rl environment
conda activate flatland-rl # activates it
```

Setup on Windows (optional)
---

These steps are for Windows users only!

### Installing WSL

1. Enable [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10) on Windows.
2. Get [Ubuntu](https://www.microsoft.com/en-us/p/ubuntu/9nblggh4msv6?SilentAuth=1&wa=wsignin1.0&activetab=pivot:overviewtab) for Windows.
3. Run your **Ubuntu** system on your computer
4. Now let us install the **Dependencies**. From within the **Ubuntu-Shell** run:

### Dependencies

First download **Anaconda**  by running this in the **Ubuntu Shell** if you are on a 64bit machine, otherwise update link.( **ATTENTION:** You need the **Linux** version and not Windows version!!!)

```
wget https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh 
```

Install **Anaconda** for Ubuntu:

```
chmod +x Anaconda3-2019.07-Linux-x86_64.sh 
 ./Anaconda3-2019.07-Linux-x86_64.sh 
```

For all changes to take affect usually you will have to restart Ubuntu, just close the terminal and run Ubuntu again.


Test your local setup
---

We will now run the agent locally to check that everything works as expected.

Let's download a few test environments. Head to the [challenge resources](https://www.aicrowd.com/challenges/neurips-2020-flatland-challenge/dataset_files) and download the provided test set. Untar them in `./scratch/test-envs`. 

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

We will now replicate the setup used on AIcrowd locally to ensure that your submission will be evaluated without problem. This involves three components: your agent, the evaluator service, and a Redis server to let them communicate. 

#### Redis

The communication between your agent and the evaluator is done through a Redis server. You should ensure that a redis server is running unprotected on localhost. Follow [these instructions](https://redis.io/topics/quickstart) to set it up.

You can check that things are fine by running:

```bash
redis-cli ping
> PONG
```

#### Evaluator service

Let's start the evaluator service. You should use different terminals for the evaluator and the agent as they will need to run at the same time.

```bash
flatland-evaluator --tests ./scratch/test-envs/
```

#### The agent

You can now start the agent:

```bash
# on Linux
export AICROWD_TESTS_FOLDER=<path_to_your_tests_directory>

# or on Windows :
#  SET AICROWD_TESTS_FOLDER=<path_to_your_tests_directory>

python run.py
```

That's it! the agent should now start interacting with the evaluator, and you should see the results coming in.

```{admonition} Why so complicated?
This client/server architecture is used to fully isolate your solution from the evaluation infrastructure.
```


Submitting!
---

Let's first consider the big picture. To submit to the challenge you'll need to ensure you've set up an appropriate repository structure, create a private git repository at [gitlab.aicrowd.com](https://gitlab.aicrowd.com/) with the contents of your submission, and push a git tag corresponding to the version of your repository you'd like to submit. You are allowed to submit up to 5 submissions per day.

#### Create your repository

Head to [gitlab.aicrowd.com/](https://gitlab.aicrowd.com) to create your private repository. You can use any name you want for it.

Add your SSH Keys to your GitLab account by following [these instructions](https://docs.gitlab.com/ee/gitlab-basics/create-your-ssh-keys.html). If you do not have SSH Keys, you will first need to [generate one](https://docs.gitlab.com/ee/ssh/README.html#generating-a-new-ssh-key-pair).

#### Push a tag

You can then create a submission by making a **tag push** to your repository on [gitlab.aicrowd.com](https://gitlab.aicrowd.com/).

First add a git remote pointing to your repository on [gitlab.aicrowd.com](https://gitlab.aicrowd.com/):

```bash
# change the line below to use your AIcrowd username and repository name:
git remote add aicrowd git@gitlab.aicrowd.com:<YOUR_AICROWD_USER_NAME>/<YOUR_REPO_NAME>.git
git push aicrowd master
```

Finally submit your solution by creating a tag for your submission and pushing it:

```bash
git tag submission-v0.1 # needs a new name tag for each submission!
git push aicrowd master
git push aicrowd submission-v0.1
```

```{admonition} Submission tags
Any tag push where the tag name begins with "submission-" to your private repository is considered as a submission!
```

Note that if the contents of your repository (latest commit hash) does not change, then pushing a new tag will **not** trigger a new evaluation.

You now should be able to see the details of your submission at:

https://gitlab.aicrowd.com/<YOUR_AICROWD_USER_NAME>/<YOUR_REPO_NAME>/issues

At the address above above, you should start seeing something like this take shape. The whole evaluation can take a bit of time, you will have to be patient! 🕙

![submission issue](assets/images/submission-issue.png)


Code structure
---

Follow the structure documented in the included [run.py](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-starter-kit/blob/master/run.py) to adapt your already existing code to the required structure for this round.

### Repository Structure

- `aicrowd.json`
  Each repository should have a `aicrowd.json` with the following content :

```json
{
  "challenge_id": "aicrowd_flatland_challenge_2019",
  "grader_id": "aicrowd_flatland_challenge_2019",
  "authors": ["your-aicrowd-username"],
  "description": "sample description about your awesome agent",
  "license": "MIT",
  "debug": false
}
```

This is used to map your submission to the said challenge, so please remember to use the correct `challenge_id` and `grader_id` as specified above.

If you set `debug` to `true`, then the evaluation will run on a separate set of 20 environments, and the logs from your submitted code (if it fails), will be made available to you to help you debug.
**NOTE** : **IMPORTANT** : By default we have set `debug:false`, so when you have done the basic integration testing of your code, and are ready to make a final submission, please do make sure to set `debug` to `true` in `aicrowd.json`.

### Code Entrypoint

The evaluator will use `/home/aicrowd/run.sh` as the entrypoint, so please remember to have a `run.sh` at the root, which can instantitate any necessary environment variables, and also start executing your actual code. This repository includes a sample `run.sh` file.
If you are using a Dockerfile to specify your software environment, please remember to create a `aicrowd` user, and place the entrypoint code at `run.sh`.
If you are unsure what this is all about, you can let `run.sh` be as is, and instead focus on the `run.py` which is being called from within `run.sh`.


Next steps
---

Take a look at the [agent provided in the starter kit](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-starter-kit/blob/master/run.py#L21). It simply takes random actions at every timestep.

You can now start improving the agent! head over to the [reinforcement learning in Flatland introduction](flatland-rl) to get started with simple RL methods such as DQN. If you want to go further, you can explore the [research baselines](baselines) which use RLlib to train using advanced algorithms such as Ape-X, PPO or imitation learning methods such as MARWIL!