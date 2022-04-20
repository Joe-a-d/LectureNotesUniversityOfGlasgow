# Sequential Decision-Making in Stochastic Environments

### Pre

### Post

### Outline

start recording : 13:07:16

- 00:01:52 : motivation
	- if end up in undesired state due to uncertainty need to know what to do
- 00:05:25 : motivation for non-deterministic ; why this is difficult ; why need special algos
	- decision might not lead to intended state ; hence, must consider all possible states with some probability
	- number of possible paths will grow exponentially if following a deterministic approach
- markov assumption (see [[uofg-AI-5]]) simplifies this process by encapsulating possible actions in the transition model
- [[Markov Reward Process]] : we now want to assume that we get an external reward for being in a particular state
		- we wish to compute the *long term, discounted sum* of future rewards
- 00:19:08 : bunch of (non-examinable) equations which help with this
	- Bellman (expectation) equations for  MRP
	- 00:22:35 : how it can be simplified if we see it as a recursion ?!?!
	- 00:24:36 : important equation to know about
- 00:25:15 : BREAK
- 00:33:06 : START
- 00:33:22 : [[Markov Decision Process]]
 - 00:34:38 : the transition model is now dependent on some action ; (we assume that it is known today)
 - 00:35:49 : key point : you have control about what you do
 - 00:36:49 : **KEY EXAMPLE** Maze setup ; lab is **VERY IMPORTANT**
	 - 00:38:17: step by step explanation of the transition model
 - 00:40:07: policies
 - 00:42:49 : Bellman expectation for MDPs
	 - we are still measuring the expectation : the sum of the future discounted rewards but now we assume we have a policy
	 - 00:45:51 : **key equation**
 - 00:47:35 : walk through example with different policies
 - 00:51:11 : in an infinite horizon, the optimal policy is independent of the starting state ; i.e. given enough time you'll always reach the terminal state by following that policy regardless of where you start
- 00:53:11 : how do we find the policy without assuming we know the utilities? Use the [[Maximum Expected Utility]] ( [[uofg-AI-5]])
	- 00:54:04 : **HUGELY IMPORTANT** *Bellman optimality equation*  ; we assume the agent chooses the optimal action each time
	- 00:56:37 : we no longer assume we know the utilities
	- 00:56:53 : back to the example ; for every single state we have the Bellman optimality equation , linking it to its neighbour states
-  00:58:33 : **RECAP**
-  (see  bit at the start missed where he recapped something else)
- 01:12:32 : Solving equations using numerical methods 
	- 01:19:31 : **Value Iteration** how rewards are propagated to neighbors via sum of discounted rewards animation
	- 01:20:44 : **Policy Iteration** 
		- compute utilities
		- compute new MEU policy given computed utilities
-  01:22:16 : limitations of [[Markov Decision Process]]
-  01:23:36 : summary

### Summary

### Key Insights (questions form)

- the terminal states are easily identified in the bellman equation , because their value is just the same as the reward, it doesn't change with iterations ; see the equation is just $R(s)$
- what is an MDP
- describe the steps of the value iteration algorithm
- for what kind of environment are MDPs used
	- fully-observable and stochastic
- state the Markov assumption

### Relevant Exam Questions