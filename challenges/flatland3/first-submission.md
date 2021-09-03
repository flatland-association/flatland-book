# Make your first submission

Flatland tackles a key problem in the transportation world: **How to efficiently manage dense traffic on complex railway networks?**

In this challenge, you will pit your ideas on reinforcement learning and operations research to get the best solution to Flatland 3. Your contribution may shape the way modern traffic management systems are implemented, not only in railway but also in other areas of transportation and logistics!

> ⚠️ Accept the rules [here](https://www.aicrowd.com/challenges/flatland-3/challenge_rules) before you submit. 

In the following instructions, you will be using the [starter kit](https://gitlab.aicrowd.com/flatland/flatland-starter-kit) to make your first submission.

# 💪 Getting started

> We recommend using `python 3.8`. If you are using Miniconda/Anaconda, you can install it using `conda install python=3.8`.

Clone the starter kit repository and install the dependencies.

```bash
git clone https://gitlab.aicrowd.com/flatland/flatland-starter-kit.git
cd flatland-starter-kit

pip install git+http://gitlab.aicrowd.com/flatland/flatland.git

conda env create -f environment.yml
```

# 🛠 Preparing your submission

## Write your agents

Implement an agent that is capable of adding producing actions for every train in the Flatland map. Refer to `baselines/run.py` [here](https://gitlab.aicrowd.com/flatland/flatland-starter-kit/-/blob/master/baselines/run.py) for a reference agent.

**Note:** Please note that the maps are generated on the evaluator and your cannot control the settings for map generation.

# 🚃 Submission

## Repository Structure

**File/Directory** | **Description**
--- | ---
[`baselines`](baselines) | Directory containing an example RL agent as well as training code for the same. Please refer to `baselines/README.md` [here](https://gitlab.aicrowd.com/flatland/flatland-starter-kit/-/blob/master/baselines/README.md) for further details.
[`utils/submit.sh`](utils/submit.sh) | Helper script to submit your repository to [AIcrowd GitLab](https://gitlab.aicrowd.com).
[`Dockerfile`](Dockerfile) | You can add a Dockerfile for specifying your exact environment. Refer to `docs/RUNTIME.md` [here](https://gitlab.aicrowd.com/flatland/flatland-starter-kit/-/blob/master/docs/RUNTIME.md) for further details.
[`environment.yml`](environment.yml) | File containing the list of python packages you want to install for the submission to run. This will instantiate a conda environment.
[`apt.txt`](apt.txt) | File containing the list of packages you want to install for submission to run. Refer [runtime configuration](#runtime-configuration) for more information.
[`run.sh`](evaluator) | **Submission entrypoint** - Use this as the entrypoint to run your code you need to run for your submission.
[`aicrowd.json`](aicrowd.json) | For specifying your submission track, RL or Overall.


## Runtime configuration

You can specify the list of python packages needed for your code to run in your [`environment.yml`](requirements.txt) file. We will install the packages using `conda env create -f environment.yml` command.

You can also specify the OS packages needed using [`apt.txt`](apt.txt) file. We install these packages using `apt-get install` command.

For more information on how you can configure the evaluation runtime, please refer to `docs/RUNTIME.md` [here](https://gitlab.aicrowd.com/flatland/flatland-starter-kit/-/blob/master/docs/RUNTIME.md).

## 🚀 Submitting to AIcrowd

### **Add your SSH key** to AIcrowd GitLab

You can add your SSH Keys to your GitLab account by going to your profile settings [here](https://gitlab.aicrowd.com/profile/keys). If you do not have SSH Keys, you will first need to [generate one](https://docs.gitlab.com/ee/ssh/README.html#generating-a-new-ssh-key-pair).


### `aicrowd.json`

Your repository should have an `aicrowd.json` file with following fields:

```json
{
    "challenge_id" : "flatland-3",
    "grader_id" : "flatland-3",
    "authors" : ["Your Name"],
    "description" : "Brief description for your submission",
    "debug": false,
    "tags": "RL" OR "Overall"
}
```

This file is used to identify your submission as a part of the Flatland 3 challenge. You must use the `challenge_id`, and `grader_id` as specified above.

`debug`: If you set `debug` to `true`, then the evaluation will run for a shorter time, and the logs from your submitted code will be made available to you to help you debug. These test submissions will appear at the bottom of the leaderboard (score of -1.0).

### Configuring the submission repository

```bash
git remote add aicrowd git@gitlab.aicrowd.com:<username>/flatland-starter-kit.git
```

**Note:** This needs to be done only once. This configuration will be saved in your repository for future use.

### Pushing the code to AIcrowd

```bash
./utils/submit.sh "some description"
```

If you want to submit without the helper script, please refer [`SUBMISSION.md`](docs/SUBMISSION.md).


# 📝 Submission checklist

- [x] **Accept the challenge rules**. You can do this by going to the [challenge overview page](https://www.aicrowd.com/challenges/flatland-3) and clicking the "Participate" button. You only need to do this once.
- [x] **Modify run.sh** that is runs your agent's code.
- [x] **Add your model checkpoints** (if any) to the repo. The `utils/submit.sh` will automatically detect large files and add them to git LFS. If you are using the script, please refer to [this post explaining how to add your models](https://discourse.aicrowd.com/t/how-to-upload-large-files-size-to-your-submission/2304).
- [x] **Update runtime configuration** using `environment.yml`, `apt.txt` and/or `Dockerfile` as necessary. Please make sure that you specified the same package versions that you use locally on your machine.

# 📎 Important links

- 💪 Challenge information
   * [Challenge page](https://www.aicrowd.com/challenges/flatland-3)
   * [Leaderboard](https://www.aicrowd.com/challenges/flatland-3/leaderboards)
 - 🗣 Community
    * [Challenge discussion forum](https://www.aicrowd.com/challenges/flatland-3/discussion)


**Best of Luck** 🎉 
