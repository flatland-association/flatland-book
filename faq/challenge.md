NeurIPS Competition
===

These are the most common questions regarding the [NeurIPS 2020 Flatland Challenge](https://www.aicrowd.com/challenges/neurips-2020-flatland-challenge/). If your questions are not answered please visit the [discussion forum](https://discourse.aicrowd.com/c/neurips-2020-flatland-challenge) and post your question there.

How does this challenge differ from the previous one?
---

The [NeurIPS 2020 challenge](https://www.aicrowd.com/challenges/neurips-2020-flatland-challenge) is similar to the [2019 edition](https://www.aicrowd.com/challenges/flatland-challenge).

The main difference is that we want to actively encourage reinforcement learning solutions during this NeurIPS 2020 edition, while the 2019 challenge mostly received solutions from the operations research domain.

Indeed, we know that operations research methods do not scale to the large railway network that are being deployed in the real-world, and our goal is to come up with solutions which can handle arbitrarily large such networks. 

What are the time limits for my submission?
---

- The agent has an initial planning time of **5 minutes** for each environment. 
- After it performed the first step, each subsequent step needs to be provided within **5 seconds**, or the submission will fail.
- If the submissions in total takes longer than 8 hours a time-out will occur.

What are the evaluation parameters?
---

The environments vary in size and number of agents as well as malfunction parameters. 

For Round 1 of the NeurIPS 2020 challenge, the upper limit of these variables for submissions are:
- `(x_dim, y_dim) <= (150, 150)`
- `n_agents <= 400`
- `malfunction_interval >= 50`

These parameters are subject to change during the challenge.

How do I submit to the Flatland challenge?
---

To submit your solution, you will push your code to a private repository at [https://gitlab.aicrowd.com](https://gitlab.aicrowd.com), then push a git tag corresponding to the version you'd like to submit. [Follow this this guide for more details.](../getting-started/first-submission)

What are the prizes in this challenge?
---

Four travel grants to the NeurIPS 2020 conference will be awarded to the top participants. [Read more about the prizes here](../getting-started/prize-and-metrics).

What are the deadlines for the Flatland challenge?
---

To be announced!

<!--
- The beta round starts on the 1st of July 2019 and ends on the 30th of July 2019
- Round 1 closed on Sunday, 13th of October 2019, 12 PM. UTC +1
- Round 2 closes on Sunday, 5th of January 2020, 12 PM. UTC +1
-->

How is the score of a submission computed?
---

[Read about the evaluation metrics here](../getting-started/prize-and-metrics).

The scores of your submission are computed as follows:

Can my agent access environment variables?
---

Yes you can. You can access all environment variables as you please. We recommend you use a custom observation builder to do so as explained [here](../getting-started/env/custom_observations).


