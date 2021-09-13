# Centralized Critic PPO

```{admonition} TL;DR
A PPO agent using a Centralized Critic. The implementation uses a multi-agent variation of Centralized Critic with a Set Transformer for preprocessing the critic's input.
```

### 💡 The idea

The Flatland environment presents challenges to learning algorithms with respect to the agent's behavior when faced with the presence of other agents, as well as with sparse and delayed rewards. Centralized critic methods are a way to deal with such problematic multi-agent training situations. 

The base architecture implemented here is a a fully connected network with PPO trainer. At execution time the agents will step through the environment in the usual way. During training, however, a different network, is used that provides the gradients on which to train the agent's network. This "central critic" is provided with a more holistic view of the simulation state in order to better approximate an adequate reward for the agent's actions in the current situation.
  
Different variations of centralized critics exist. The method contained in the baselines does not use global observations as many other implementations, but combines the observations of the to-be-trained-agent with the observations of the other agents. The approach was chosen in order to create a solution that would be feasible in large environments. This might not be the solution with the best performance and participants should therefore not be deterred from developing more specialized variations.

The model also contains a Set Transformer. This transformer sits between the observations of the agents and the centralized critic in order to, providing the critic with an embedding of the observations. This is useful for dealing with the sparsity of the observations, with the temporal nature of the data, as well as with possible permutation invariance in the case of a changing subset of agents included in the observation.

### 🗂️ Files and usage

The general structure of the code allows substitution of the separate parts, which will be discussed in the next section.

#### 🚂 Training

An example configuration file can be found in [`neurips2020-flatland-baselines/experiments/flatland_sparse/small_v0/tree_obs_fc_net/ccppo.yaml`](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines/blob/centralized-critic/experiments/flatland_sparse/small_v0/tree_obs_fc_net/ccppo.yaml).
 
Run it with:

```console
$ python ./train.py -f experiments/flatland_sparse/small_v0/tree_obs_fc_net/ccppo.yaml  
```

#### 🧠 Model

The model is implemented in [`neurips2020-flatland-baselines/models/cc_transformer.py`](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines/blob/centralized-critic/models/cc_transformer.py)


### 📦 Implementation Details

The [`cc_transformer`](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines/blob/centralized-critic/models/cc_transformer.py) model file contains the code for all concepts needed for central-critic and transformer implementation. The three components Transformer, Agent-Model and Critic-Model are constructed and put together in the [`CentralizedCriticModel`](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines/blob/centralized-critic/models/cc_transformer.py#L20) class.

#### Transformer

The transformer is built with self-attention layers which can be found in the [`MultiHeadAttentionLayer`](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines/blob/centralized-critic/models/cc_transformer.py#L183) class. The layers will calculate the embedding with trained linear projections. The dimensions of these outputs can be decided on, as they are the product of the number of parallel heads (`num_head`) and the output dimension (`d_model`).

#### Central Critic

The central critic is constructed with the [`build_fullyConnected`](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines/blob/centralized-critic/models/cc_transformer.py#L155) function to build a fully connected network of the given input, output and hidden layer sizes. 

#### Agent Model

The agents are built with fully connected layers in the [`build_fullyConnected`](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines/blob/centralized-critic/models/cc_transformer.py#L155) to build a fully connected network of the given input, output and hidden layer sizes.

#### Trainer

For training the fully connected layers we use the standard PPO trainer implementation provided by RLlib with necessary updates to the post-processing. In [`centralized_critic_postprocessing`](https://gitlab.aicrowd.com/flatland/neurips2020-flatland-baselines/blob/centralized-critic/models/cc_transformer.py#L442) we ensure that `training_batches` contain all the necessary observations of neighboring agents, as well as performing the advantage estimation.

The trainer registration is done outside of classes or functions at the end of the file. Here, the CCPPO Policy is defined, based on the standard `PPOTrainer` and subsequently used to register the model to be used in ray.


### 📈 Results

The described approach was developed and evaluated in a project of [Deutsche Bahn](https://digitale-schiene-deutschland.de/en) in cooperation with [InstaDeep](http://www.instadeep.com/). In the context of the project CCPPO was validated and directly compared to standard PPO on a previous version of Flatland. This original implementation that used a custom version of a sparse reward and a custom observation similar to Flatland's tree observation outperformed standard PPO. For the current baselines the CCPPO model was run using the new Flatland version together with its standard observation and reward. The graph below shows the results for these runs with and without the transformer. For comparison, a run of the current best method in the baseline (Ape-X) with comparable sizes and parameters is shown. The full configuration can be found in the corresponding CCPPO config files. The results show that CCPPO is able to learn in this setup, but with a lower performance than Ape-X. We provide an example setup for experiments with CCPPO and encourage participants to further refine and develop this approach.

[![w&b report](images/ccppo_example.png)](https://app.wandb.ai/masterscrat/flatland/reports/Flatland-small_v0-CCPPO--VmlldzoxNTIwMzM)

### 🔗 Links

* [Single agent approach from InstaDeep](https://github.com/instadeepai/gtc-course-2020)
* [Transformer Paper - Stabilizing Transformers for Reinforcement Learning (Parisotto et al.)](https://arxiv.org/abs/1910.06764)
* [Actor-Attention-Critic for Multi-Agent Reinforcement Learning (Iqbal et al.)](https://arxiv.org/pdf/1810.02912.pdf)


### 🌟 Credits

[![DB](images/db-logo.png)](https://digitale-schiene-deutschland.de/en) 

[![InstaDeep](images/instadeep-logo.png)](http://www.instadeep.com/)
