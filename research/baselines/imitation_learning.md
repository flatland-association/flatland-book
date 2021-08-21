# Imitation Learning Training

```{admonition} TL;DR
We consider 2 broad Imitation Learning approaches as per below
* Pure Imitation Learning
  * This step involves training in a purely offline process via stored experiences
  * This is implemented using the RLLib supported [MARWIL](http://papers.nips.cc/paper/7866-exponentially-weighted-imitation-learning-for-batched-historical-data) algorithm which is an on-policy algorithm.
* Hybrid or Mixed Learning
  * This step involves training in both an offline process via stored experiences and actual environment simulation experience. This is implemented using the off-policy [APE-X DQN](https://arxiv.org/abs/1803.00933) algorithm in RLLib with the stored experiences sampled from the replay buffer based on a user configurable ratio of simulation to expert data.
```

### 💡 The idea

The Flatland environment presents challenges to learning algorithms with respect to regard the organization the agent's behavior when faced with the presence of other agents as well as with sparse and delayed rewards. Operation Research (OR) based solutions which follow rule-based  and planning approaches have shown to work well in this environment. We propose a hybrid approach using these succesful OR solutions to bootstrap the reinforcement learning process and possibly further improve them. This trained reinforcement learning based solution can be used in larger environments where scalability is required.

### 🗂️ Files and usage

#### 🎛️ Parameters
The parameters for MARWIL can be configured with the following parameters:

* `beta`: This ranges from `0-1` with a value of `0` represents a vanilla imitation learning.

The parameters for APEX based Imitation Learning can be configured with the following parameters:

* `"/tmp/flatland-out"`: This ranges from `0-1` with a value of `0` represents no imitation learning.This represents the porportion of imitation samples.
* `sampler`: This ranges from `0-1` with a value of `0` represents `100%` Imitation Learning. This represents the porportion of simulation samples.
* `loss`: Possible values are dqfd,ce,kl which represents the loss based on [DQfD](https://arxiv.org/abs/1704.03732) , cross entropy and kl divergence respectively
* `lambda1`: Weight applied for the APE-X DQN loss in calculating the total loss
* `lambda1`: Weight applied for the Imitation loss in calculating the total loss

#### 🚂 Training

#### MARWIL

Example configuration: [`neurips2020-flatland-baselines/baselines/imitation_learning_tree_obs/marwil_tree_obs_all_beta.yaml`](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines/blob/master/baselines/imitation_learning_tree_obs/marwil_tree_obs_all_beta.yaml).

Run it with:

```console
$ python ./train.py -f baselines/imitation_learning_tree_obs/marwil_tree_obs_all_beta.yaml
```

#### APE-X Imitation Learning (IL)

Example configuration: [`neurips2020-flatland-baselines/baselines/imitation_learning_tree_obs/apex_il_tree_obs_all.yaml`](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines/blob/master/baselines/imitation_learning_tree_obs/apex_il_tree_obs_all.yaml).

Run it with:

```console
$ python ./train.py -f baselines/imitation_learning_tree_obs/apex_il_tree_obs_all.yaml
```

#### 🧠 Model

We use a standard fully connected neural network model for both the MARWIL and APE-X IL.

The model with the custom loss used in APE-X IL is implemented in [`neurips2020-flatland-baselines/models/custom_loss_model.py`](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines/blob/master/models/custom_loss_model.py).

### 📦 Implementation Details

#### Generating Expert Demonstrations

We have provided a set of expert demonstration in this [location](https://www.aicrowd.com/challenges/neurips-2020-flatland-challenge/dataset_files). Some of the results presented below were based on the  file `expert-demonstrations.tgz`. This expert demonstrations file has the saved version of the environment and the corresponding expert actions.

Next we convert them to a rllib compatible format. More details can be found [here](https://docs.ray.io/en/releases-0.8.5/rllib-offline.html)

We follow the below steps to generate our list of expert demonstration

* Download and extract the expert demonstrations file in the location `neurips2020-flatland-baselines/imitation_learning/convert_demonstration`
* Now run the `saving_experiences.py` to generate the expert demonstrations in rllib format (`*.json`)
* Copy the generated experiences to the location `\tmp\flatland-out`

#### Run Model with Expert Demonstrations

The **custom_loss_model** model file contains the code basis for all concepts needed for Imitation Loss implementation.

For the training process refer to the [training](#training) section.

### 📈 Results

Results for MARWIL and APEX based Imitation Learning

#### MARWIL Results

[Full metrics of the training runs can be found in the *Weights & Biases* report](https://app.wandb.ai/masterscrat/flatland/reports/MARWIL-Tree-Observation-Runs--VmlldzoxNjM1MzY)

#### APE-X IL Results

[Full metrics of the training runs can be found in the *Weights & Biases* report](https://app.wandb.ai/masterscrat/flatland/reports/APE-X-IL--VmlldzoxNjM2MTg)

The results show that a pure Imitation Learning can help push the mean completion to more than `50%` on the sparse, small flatand environment comparable results. Combining both the expert demonstrations along with environment training using the fast `APE-X` achieves a mean completion rate comparable to the corresponding pure Reinforcement Learning(RL) runs. A notable observation is that Imitation Learning algorithms show a better minimum completion rate.

### 🔗 Links

* [DQfD](https://arxiv.org/abs/1704.03732)
* [Ape-X DQfD](https://arxiv.org/pdf/1805.11593.pdf)
* [MARWIL](http://papers.nips.cc/paper/7866-exponentially-weighted-imitation-learning-for-batched-historical-data.pdf)
* [Ape-X Paper – Distributed Prioritized Experience Replay (Horgan et al.)](https://arxiv.org/abs/1803.00933)

### 🌟 Credits

- [Nilabha Bhattacharya](nilabha.ext@aicrowd.com)
- [Jeremy Watson](jeremy@aicrowd.com)
- [Florian Laurent](florian@aicrowd.com)
