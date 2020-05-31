
Five Minutes Guide to Submission
===

All aboard! 🚂
---

In five minutes, you will have submitted your first agent to this challenge and will see your name on the leaderboard. 

![](assets/images/you.png)

Setup
---

Let's start by cloning the starter kit: 

```bash
git clone git@github.com:AIcrowd/flatland-challenge-starter-kit.git
cd flatland-challenge-starter-kit
```

The starter kit comes with a sample agent which performs random actions. We will see how it works in more details in the next section.

Let's create a conda environment for Flatland. [Install conda](https://www.anaconda.com/products/individual) first if it is not setup on your machine.

```bash
conda env create -f environment.yml # creates the flatland-rl environment
conda activate flatland-rl # activates it
```


Test your local setup
---

We will now run the agent locally to check that everything works as expected.

Let's download a few test environments to test the agent. Head to the [challenge resources](https://www.aicrowd.com/challenges/neurips-2020-flatland-challenge/dataset_files) and download the provided test set.

Untar them in `./scratch/test-envs`. Your directory structure should be as follow:

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
    ├── Test_4
    │   ├── Level_0.pkl
    │   └── Level_1.pkl
    ├── Test_5
    │   ├── Level_0.pkl
    │   └── Level_1.pkl
    ├── Test_6
    │   ├── Level_0.pkl
    │   └── Level_1.pkl
    ├── Test_7
    │   ├── Level_0.pkl
    │   └── Level_1.pkl
    ├── Test_8
    │   ├── Level_0.pkl
    │   └── Level_1.pkl
    └── Test_9
        ├── Level_0.pkl
        └── Level_1.pkl
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

Let's first consider the big picture. When taking part in this challenge, you will first train an agent on your local machine, then submit it for evaluation. 

The submission process uses git. The code for your agent will be hosted on [https://gitlab.aicrowd.com/](gitlab.aicrowd.com). When you want your agent to be evaluated, you will **push a tag** to this repository, which will trigger an evaluation. You are allowed to submit up to 5 submissions per day.

#### Create your repository

Head to [https://gitlab.aicrowd.com/](gitlab.aicrowd.com) to create your private repository. You can use any name you want for it.

Add your SSH Keys to your GitLab account by following [these instructions](https://docs.gitlab.com/ee/gitlab-basics/create-your-ssh-keys.html).

If you do not have SSH Keys, you will first need to [generate one](https://docs.gitlab.com/ee/ssh/README.html#generating-a-new-ssh-key-pair).

#### Push a tag

You can then create a submission by making a **tag push** to your repository on [https://gitlab.aicrowd.com/](gitlab.aicrowd.com).

**Any tag push (where the tag name begins with "submission-") to your private repository is considered as a submission**  

First add the a git remote pointing to your repository on [https://gitlab.aicrowd.com/](gitlab.aicrowd.com)

```
cd flatland-challenge-starter-kit
# Add AIcrowd git remote endpoint
git remote add aicrowd git@gitlab.aicrowd.com:<YOUR_AICROWD_USER_NAME>/flatland-challenge-starter-kit.git
git push aicrowd master
```

Finally submit by doing:

```bash
# Create a tag for your submission and push
git tag -am "submission-v0.1" submission-v0.1
git push aicrowd master
git push aicrowd submission-v0.1
```

Note that if the contents of your repository (latest commit hash) does not change, then pushing a new tag will **not** trigger a new evaluation.

You now should be able to see the details of your submission at:

[https://gitlab.aicrowd.com/<YOUR_AICROWD_USER_NAME>/flatland-challenge-starter-kit/issues](https://gitlab.aicrowd.com//<YOUR_AICROWD_USER_NAME>/flatland-challenge-starter-kit/issues)

Remember to update your username in the link above! 😉 

In the link above, you should start seeing something like this take shape. The whole evaluation can take a bit of time, you will have to be patient! 🕙

![](https://i.imgur.com/4HWf1jU.png)


Next steps
---

