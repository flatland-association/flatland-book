Research Ideas
===

Q-Learning in enormous action spaces via amortized approximate maximization
---

https://arxiv.org/abs/2001.08116 (from Florian)

Action space could be forward/left/right/pause x nb agents

Deep Q-learning from Demonstrations (DQfd)
---

https://arxiv.org/pdf/1704.03732.pdf (from Nilabha)

- The idea is sort of imitation learning (Refer section Related Work) but is able to provide better results than the expert or demonstration experience unlike DAGGER etc..

- The existing DDQN implementation that we have in Baselines could be extended with help from some online implementations already available for this paper Deep Q-learning from Demonstrations.

- As this implementation shows https://github.com/go2sea/DQfD - the expert demonstrations (or OR solutions in our case) can help jump start the training process

Comparison of path planning methods for a multi-robot team
---

https://core.ac.uk/download/pdf/84833259.pdf (from Jeremy)

> This master thesis discusses the topic of
  multi-agent pathplanning. For this reason several algorithms were picked and
  described in the first part of this thesis.
  All algorithms were implemented in C++
  and from experience from working with
  these algorithms several modifications and
  improvements were proposed and implemented. The second part of the thesis
  elaborates on the results of experiments
  performed on the basic versions of the algorithms as well as the improvements and
  discusses their effect. This part discusses
  the potential applications the algorithms
  as well. All algorithms were tested on the
  map of robotic warehouse as well as grid
  maps from pc games.

Comparison of path planning methods for a multi-robot team Bc. Jakub Hvězda (Masters Thesis, 2017). Very similar to flatland environment, apart from the junction constraints, same speed, no failures...? (AFAICT). The algorithm assumes that the resource graph is constructed such that resources are of two types: intersection resources with capacity 1 and lane resources with capacity 1 or greater. Another assumption is also that if multiple agents are present on the same resource then they are all traveling in the same direction and their order does not change, meaning they cannot overtake each other. The idea is that the lanes are not wide enough for two agents to drive in parallel but long enough so that agents can drive behind each other.


Neural Combinatorial Optimization with Reinforcement Learning
---

https://arxiv.org/abs/1611.09940 (from Jeremy)

> This paper presents a framework to tackle combinatorial optimization problems using neural networks and reinforcement learning. We focus on the traveling salesman problem (TSP) and train a recurrent network that, given a set of city coordinates, predicts a distribution over different city permutations. Using negative tour length as the reward signal, we optimize the parameters of the recurrent network using a policy gradient method. We compare learning the network parameters on a set of training graphs against learning them on individual test graphs. Despite the computational expense, without much engineering and heuristic designing, Neural Combinatorial Optimization achieves close to optimal results on 2D Euclidean graphs with up to 100 nodes. Applied to the KnapSack, another NP-hard problem, the same method obtains optimal solutions for instances with up to 200 items.

Couple of implementations (2-3 years old):
- https://github.com/MichelDeudon/neural-combinatorial-optimization-rl-tensorflow  (I just ran training; but I think it needs an old version of Google OR Tools for testing, or a bit of updating itself)
- https://github.com/pemami4911/neural-combinatorial-rl-pytorch  Not tried this yet. (Florian: this guy generally does good work)
- https://github.com/MichelDeudon/neural-combinatorial-optimization-rl-tensorflow


Attention, Learn to Solve Routing Problems!
---
https://arxiv.org/pdf/1803.08475v3.pdf (from Nilabha)

> The recently presented idea to learn heuristics for combinatorial optimization
  problems is promising as it can save costly development. However, to push this
  idea towards practical implementation, we need better models and better ways
  of training. We contribute in both directions: we propose a model based on attention layers with benefits over the Pointer Network and we show how to train
  this model using REINFORCE with a simple baseline based on a deterministic
  greedy rollout, which we find is more efficient than using a value function. We
  significantly improve over recent learned heuristics for the Travelling Salesman
  Problem (TSP), getting close to optimal results for problems up to 100 nodes.
  With the same hyperparameters, we learn strong heuristics for two variants of the
  Vehicle Routing Problem (VRP), the Orienteering Problem (OP) and (a stochastic variant of) the Prize Collecting TSP (PCTSP), outperforming a wide range of
  baselines and getting results close to highly optimized and specialized algorithms.


Conflict-free route planning in dynamic environments
---
https://www.researchgate.net/publication/221063712_Conflict-free_route_planning_in_dynamic_environments (form Jeremy)

> Motion  planning  for  multiple  robots  is  tractable in  case  we  can  assume  a  roadmap  on  which  all  the  robotstravel, which is often the case in many automated guided vehicledomains,  such  as  factory  floors  or  container  terminals.  Wepresent  anO(nvlog(nv) +n2v)(nthe  number  of  nodes,vthe  number  of  vehicles)  route  planning  algorithm  for  a  singlerobot,  which  can  find  the  minimum-time  route  given  a  set  ofexisting  route  plans  that  it  may  not  interfere  with.In  addition,  we  present  an  algorithm  that  can  propagatedelay  through  the  plans  of  the  robots  in  case  one  or  morerobots are delayed. This delay-propagation algorithm allows usto implement a Pareto-optimal plan repair scheme, in which onerobot can improve its route plan without adversely affecting theother robots. We compare this approach to several plan repairschemes  from  the  literature,  which  are  based  on  the  idea  ofgiving  a  higher  priority  to  non-delayed  agents


Chip Placement with Deep Reinforcement Learning
---
https://arxiv.org/pdf/2004.10746.pdf (from Florian)

Used by Instadeep active in same domain!

> In this work, we present a learning-based approach to chip placement, one of the most complex and time-consuming stages of the chip design process. Unlike prior methods, our approach
  has the ability to learn from past experience and
  improve over time. In particular, as we train
  over a greater number of chip blocks, our method
  becomes better at rapidly generating optimized
  placements for previously unseen chip blocks.
  To achieve these results, we pose placement as a
  Reinforcement Learning (RL) problem and train
  an agent to place the nodes of a chip netlist onto
  a chip canvas. To enable our RL policy to generalize to unseen blocks, we ground representation learning in the supervised task of predicting
  placement quality. By designing a neural architecture that can accurately predict reward across
  a wide variety of netlists and their placements,
  we are able to generate rich feature embeddings
  of the input netlists. We then use this architecture as the encoder of our policy and value networks to enable transfer learning. Our objective is to minimize PPA (power, performance,
  and area), and we show that, in under 6 hours,
  our method can generate placements that are superhuman or comparable on modern accelerator
  netlists, whereas existing baselines require human experts in the loop and take several weeks.
  
Baselines and Observation Ideas for Flatland
---

Summary document used for the proposal baselines

https://docs.google.com/document/d/1Lwc-0CuAULrBATNjHr91Gh_SGben6bLD90IiJjhjqsE/edit