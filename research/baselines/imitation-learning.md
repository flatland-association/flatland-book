# Imitation Learning Training

We do Imitation Learning in 2 Phases
* Pure Imitation Learning (Phase 1)
  * This step involves training in a purely offline process via stored experiences
* Hybrid or Mixed Learning (Phase 2)
  * This step involves training in both an offline process via stored experiences and actual env simulation experience
  * If Phase 1 is skipped this would be a new experiment, else we would restore from a checkpoint point saved from Phase 1

## Generate and save Experiences from expert actions
This can be done by running the `ImitationLearning/saving_experiences.py` file. 

A saved version of the experiences can also be found in the `ImitationLearning/SaveExperiences` folder. You can copy them to the default input location with:

`mkdir /tmp/flatland-out; cp ImitationLearning/SaveExperiences/*.json /tmp/flatland-out/`

In the config file set the input location as follows

`input: /tmp/flatland-out` 

The experiences are copied in the folder `/tmp/flatland-out` folder. It does a glob to find all experiences saved in json format.
## On Policy ([MARWIL](http://papers.nips.cc/paper/7866-exponentially-weighted-imitation-learning-for-batched-historical-data.pdf))

### Phase 1

This is for Pure Imitation Learning with Input Evaluation using IS,WIS and Simulation.
We use the trainImitate.py file which is very similar to the train.py file.  
TODO:
Make the train.py flexible enough to also use for Imitation Learning

Config file: `MARWIL.yaml`
```bash
python trainImitate.py -f experiments/flatland_sparse/small_v0/tree_obs_fc_net/ImitationLearning/MARWIL.yaml
```

Importance sampling (IS) and weighted importance sampling (WIS) gain estimates (>1.0 means there is an estimated improvement over the original policy)
Beta = 0 in the tune grid search leads to pure imitation learning
### Phase 2
Config file: `MARWIL.yaml`
Set Beta = 0.25 and 1 to compare against the pure imitation MARWIL approach

## Off Policy (DQN)
### DQN (TODO: Ape-X not working)
#### Phase 1
This is for Pure Imitation Learning with Input Evaluation using IS,WIS and Simulation
Config file: `dqn_IL.yaml`

```bash
python trainImitate.py -f experiments/flatland_sparse/small_v0/tree_obs_fc_net/ImitationLearning/dqn_IL.yaml
```

#### Phase 2
Replace Config file to `dqn_mixed_IL.yaml`

Note that we no longer use Simulation for Input-evalaution as we have a sampler which runs the environment as per the proportion specified.

###  [Ape-X DQfD](https://arxiv.org/pdf/1805.11593.pdf)
Involves mixed training in the ratio 25% (Expert) and 75% (Simulation). This is a deviation from the earlier [DQfD](https://arxiv.org/pdf/1704.03732.pdf) paper where there was a pure imitation step

A nice explanation and summary can be found [here](https://danieltakeshi.github.io/2019/05/11/dqfd-followups/) and [here](https://danieltakeshi.github.io/2019/04/30/il-and-rl/)

Config file: `dqn_DQfD.yaml` 
(Currently the Ape-X version is not working with custom loss model. Use the config dqn_DQfD.yaml. DQN is similar to Ape-X but is slower)

```bash
python trainImitate.py -f experiments/flatland_sparse/small_v0/tree_obs_fc_net/ImitationLearning/dqn_DQfD.yaml
```

TODO: 
* Priortised Experience Replay (PER) of samples individually done for expert and simulation. Currently [Distributed PER](https://arxiv.org/abs/1803.00933) is used, but have to check if it will be applied seperately for the expert and simulation data or on the mixed samples.
* Custom Loss with Imitation Loss applied only to the best expert trajectory. L2 loss can be ignored as of now as we do not want to regularise at this stage and regularisation in reinforcement learning is debatable

Distributed PER seems to be an important part of the good results achieved by Ape-X DQfD. This could be implemented by running simulation and outputing the experiences. Then the expert and simulation experiences could be priortised seperately in a seperate process and updated at reasonable intervals
Alternatively modify implemention of PER in RLLib