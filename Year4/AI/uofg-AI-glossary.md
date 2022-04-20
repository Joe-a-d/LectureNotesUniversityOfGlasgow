# Transition Model

^95d42f

Describes the outcome of each action in each state. Defined as a function mapping a current state and action to its successor state. 
- **deterministic** case $T(s,a) = s'$ 
- **stochastic** case we must use probabilities $P(s' | s,a)$ , since by definition it is not guaranteed that we'll end up in $s'$


# Markov Decision Process (MDP)

MDP is a sequential decision problem for a *fully observable, stochastic* environments with a Markovian [[#^95d42f|transition model]] and additive rewards. It requires:
- a set of states, $S$
- a set of actions in each state, $A(s)$
- a transition model, $P(s' | s, a)$
- a reward function, $R(s, a, s')$

Examples :
- [lab6 : action-graph and dictionary representation](http://localhost:8888/notebooks/lab_week06_mdpbellman_v20212022a/solutions/lab_week06_mdpbellman_solutions_v20192020a.ipynb#Q6.1.2-A-Simple-MDP)
	- ![[Pasted image 20211126183417.png]]
	- States: A,B,C (note: the notation is not ideal here usign capital letters to denote the outcome of a random variable S but you will see this from time to time)

	- Actions: 
		- $Actions(S=A)=\{X,Y\}$
		- $Actions(S=B)=\{X,Y\}$
		- $Actions(S=End)=$Ø (it is a terminal state)

	- Rewards:
		- $R(S=A)$ = 5
		- $R(S=B)$ = -10
		- $R(S=C)$ = 100

	- Transition model 

		- $P(S_{t+1}=A|S_t=A, Action=X)=0.3$

		- $P(S_{t+1}=B|S_t=A, Action=X)=0.7$

		- $P(S_{t+1}=A|S_t=A, Action=Y)=1.0$

		- $P(S_{t+1}=B|S_t=A, Action=Y)=0.0$

		- $P(S_{t+1}=B | S_t=B, Action=X)=0.2$

		- $P(S_{t+1}=End  |S_t=B, Action=X)=0.8$

		- $P(S_{t+1}=A | S_t=B, Action=Y)=1.0$
- [AIMA python implementations](~/dev/AI_uofg/aima-python-uofg_v20212022a/mdp.py)
  - lab 7 instantiates the grid example from [AIMA]
# Policy

^58134d

Defines what the agent should do for all possible states that the agent might reach. This is needed in stochastic environments since no fixed action sequence can solve the problem, by definition the action requested might not be taken.  ^ccb0a5
- We represent a policy as $\pi$ and the action recommended by the policy at a given state $s$ by $\pi(s)$

By definition an **optimal policy** $\pi^*$ is the one that generates the sequence of actions yielding the highest expected utility.

![[#^3af4d4]]

Combining this concept with the principle of maximum expected utility an agent is able to select actions by choosing the one that maximises the reward for the next step plus the expected utility of the subsequent state

$$
\pi^{*}(s)=\underset{a \in A(s)}{\operatorname{argmax}} \sum_{s^{\prime}} P\left(s^{\prime} \mid s, a\right)\left[R\left(s, a, s^{\prime}\right)+\gamma U\left(s^{\prime}\right)\right]
$$

## Off-Policy Vs On-Policy Algorithms

# Utility

A function , $U(s)$, which assigns a number to express the desirability of a state. We can calculate the **expected utility** of an action given the evidence $EU(a)$ , by averaging the utility value of the outcomes weighted by the probability of the action occurring. 

The **principle of maximum expected utility** states that a rational agent should choose the action that maximises the agent's expected utility

$$
E U(a)=\sum P\left(\operatorname{RESULT}(a)=s^{\prime}\right) U\left(s^{\prime}\right)
$$

$$
\text { action }=\underset{a}{\operatorname{argmax}} E U(a)
$$


### Utility of State Sequences

Usually for state sequences the utility function is just the **sum of discounted rewards**, where $\gamma$ is the **discount factor** representing the agent's preference for current over future rewards

$$ U_h(s_0,a_0,s_1,a_1,s_2,a_2,s_3, \cdots) = R(s_0,a_o,s_1) + \gamma R(s_1,a_1,s_2) + \gamma^2 R(s_2,a_2,s_3) \cdots $$

### Utility of a State

The true utility of a state $U(s)$, is the expected sum of discounted rewards if the agent executes an optimal policy. 

Let $S_t$ (a random variable) be the state that the agent reaches at time $t$ when executing a policy $\pi$, then the expected utility for a policy starting at $s$ is given by

$$ U^{\pi}(s) = E \Bigg[ \sum_{t=0}^{\inf} \gamma^{t} R(S_t, \pi(S_t), S_{t+1})\Bigg] $$ ^d646fe

It follows from the definition of optimal policy that 

$$ \pi^{*}_{s} = \text{argmax}_{\pi}U^\pi(s) $$ ^3af4d4

### Bellman Equations

^1720dc

Gives a direct relationship between the utility of a state and the utility of its neighbours. *The utility of a state is the expected reward for the next transition plus the discounted utility of the next state, assuming that the agent chooses the optimal action.*.

$$
U(s)=\max _{a \in A(s)} \sum_{s^{\prime}} P\left(s^{\prime} \mid s, a\right)\left[R\left(s, a, s^{\prime}\right)+\gamma U\left(s^{\prime}\right)\right]
$$

^5bb462

The [[#^d646fe|utilities of the states]] are the unique solutions to the set of Bellman equations. So it is from them that we can find and optimal policy

There is a Bellman equation for each state, e.g. for the grid world state $(1,1)$

$$
\begin{aligned} \max \{&[0.8(-0.04+\gamma U(1,2))+0.1(-0.04+\gamma U(2,1))+0.1(-0.04+\gamma U(1,1))] \\ &[0.9(-0.04+\gamma U(1,1))+0.1(-0.04+\gamma U(1,2))] \\ &[0.9(-0.04+\gamma U(1,1))+0.1(-0.04+\gamma U(2,1))] \\ &[0.8(-0.04+\gamma U(2,1))+0.1(-0.04+\gamma U(1,2))+0.1(-0.04+\gamma U(1,1))]\} \end{aligned}
$$


# Q-Function

^970708

The expected utility of taking a given action in a given state, $Q(s,a)$. 

By definition, it follows that $U(s) = \max_{a}Q(s,a)$, i.e. by the MEU principle the utility of a state is just the maximum value of the function

In a similar manner, we can reformulate the [[#^1720dc]] by replacing the utility function with the Q-function

$$\begin{aligned} Q(s, a) &=\sum_{s^{\prime}} P\left(s^{\prime} \mid s, a\right)\left[R\left(s, a, s^{\prime}\right)+\gamma U\left(s^{\prime}\right)\right] \\ &=\sum_{s^{\prime}} P\left(s^{\prime} \mid s, a\right)\left[R\left(s, a, s^{\prime}\right)+\gamma \max _{a^{\prime}} Q\left(s^{\prime}, a^{\prime}\right)\right] \end{aligned}$$

**function definition**

$$\begin{array}{l}\text { function Q-VALUE }(m d p, s, a, U) \text { returns a utility value } \\ \quad \text { return } \sum_{s^{\prime}} P\left(s^{\prime} \mid s, a\right)\left[R\left(s, a, s^{\prime}\right)+\gamma U\left[s^{\prime}\right]\right]\end{array}$$

# Value-Iteration

An algorithm for solving MDPs

# Experience Replay

^fa17f5

# Catastrophic Inference

^13b6b1

a.k.a catastrophic forgetting