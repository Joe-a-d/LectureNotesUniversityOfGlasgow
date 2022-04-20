# Intro to [[RL|Reinforcement Learning]] and [[Q-learning]]

### Pre

- [ ] Review MDPs and Bellman equations 
- [ ] Review Lab 
- [ ] [[AIMA]] 
	- [ ] 16 - 16.2
	- [ ] 23-23.4

### Post

### Outline
+ 1.15
 
00:00:06 - recap of what we covered probability,utility and decision theory, sequential decision making under uncertainty
	- 00:03:35 - what being coupled means w.r.t bellman equations. One equation for each state which depends on the utility of other states, hence coupled
00:05:29 - differences with the 4th edition of AIMA which takes a more general view w.r.t to the *reward function*.  In the course we'll just use the assumption that the reward function is just based on the state , i.e $R(S)$
00:09:34 - we don't generally know the transition model and reward function. BELOW we'll look at how we can learn them from rewards and observations
00:12:25 - examples of RL applications
00:14:26 - the transition model recap
00:16:01 - given a policy and taking into account the transition model, we can think about each observation when we run the experiment as a datapoint , i.e. the state where you come from, the action took, and the state where you *actually* ended up (recall that there might be some probability that the action doesn't match the result)
00:18:28 - assumptions and overview
	- passive vs active
	- model vs model-free
	- tabular vs function approximation
00:21:03 - PASSIVE 
	- monte-carlo/direct utility estimation (doesn't scale)
	- 00:25:14 computing the utility by sampling , example of repeated observation
00:27:02 - ADAPTIVE DYNAMIC PROGRAMMING
	- take advantage of the connection between the states by learning a transition model that connects the states and solve the corresponding Markov decision process to determine the utilities
00:30:38 - TEMPORAL DIFFERENCE
	- the dynamic programming is computationally expensive : *motivation*
	- use the immediate transitions to adjust the utilities of the state so that they actually agree with the bellman equations, assuming that the transition happens all the time
	- 00:34:03 : algorithm 
		- 00:35:44 : estimating using the bellman equation ; different formulation since the probability bit will be 1
		- 00:37:17 : properties
- **Active RL**
- 00:00:57 - problems with passive RL / motivation
	- assumes that we already know the policy
- how can we learn both the policy, the transition model and the rewards?
- 00:02:16 - Active ADP greedy
	- start with transition, based on that want to update the TM and the reward
	- solve bellman without fixed policy solution by getting the current estima of utility of the state with the updated model
	- select one-step action to maximise the expected utility given U
	- take action and observe resulting state and reward
	- REPEAT
	- 00:04:47 - problem! greedy agent very seldom converges to the optimal policy;
	- 00:05:50 - we need to explore the environment so that the agent doesn't only select agents based on the current transition model ; i.e. we need to introduce randomness to the actions
		- **Relevant to coursework** epsilon greedy
- 00:08:24 - model-free **Q-learning**
	- instead of learning the utility directly we'll learn an action-utility representation, we aim to map states directly to actions without the model
	- **key property** if we take the optimal action, the utility corresponds to that, i.e. the utility of a state is a maximum entry of the Q table w.r.t that action ; there's a link between Q and U
	- Q represents the long term value of taking an action a in state s
	- 00:11:31 - we can reformulate the bellman equations in light of this
- 00:12:43 - **active Q**
	- below : breakdown of the model equation ; equivalent to the utility version, but now we use the Q table
	- observer transitions from one state to the other, assuming that they are the norm, happen all the time : *current state*
	- we can say that the transition leads to a particular state-action par should have a particular Q value : *target*
	- subtract the current value depending on how confident we are that the action happens all the time (between 0,1) : *current state*
	- **argument** for how to derive the target
- 00:15:00 - algorithm summary 
- 00:17:00 - revisiting the grid example
- **Evaluating RL agents** : things to think about when comparing the different algorithms
- 00:02:22 - though the algorithms can be shown to be correct by using asymptotic proofs, in the real world we must use numerical methods and conduct empirical evaluations
- 00:03:14 - the main problem is the time complexity ; time to learn ; policy estimation , e.g solving the bellman equations each time, expensive
- 00:05:19 - **evaluation setting**
	- real world -> complex goals but often easy to generalise and repeated tasks ; strong priors
	- simulated worlds -> requires many trials to learn and a strong empirical evaluation ; Q learning in particular requires a large number of data points from exploration
	- these two can be combined , e.g. train a automated car in a simulator before deploying to real world
- 00:08:43 - performance metrics
- 00:12:00 - **tip** focus on the intuitions such that you can derive the algorithms from the bellman equations alone
- 00:13:00 - Q learning drawbacks; need for extension
	- for large state spaces, table representation is not feasible
	- need to visit all states to learn the environment ;  a better approach is to use a function parameterised which allows us to interpolate the state values without having to visit them all -> better generalisation (see [[uofg-AI-8]]) 
	


### Summary

### Prompts

- **what is reinforcement learning**
- **how do RL and solving MDPs differ**
	- in both we want to maximise the expected sum of rewards, but in RL the agent is not trying to solve an MDP because *it is not given* one, instead the agent is *in* the MDP. It may not know the transition model, or reward function and so has to act in order to learn them
- **model-based vs model-free RL**
	- uses the transition model which may be initially unknown vs no model; instead the agent learns a more direct representation of the world (Q-Learning, Policy search, TD)
	- for model-based explicitly represent $P(s'|s,a)$ and $R(s)$, e.g. using an MDP 
- **what is meant by passive reinforcement learning** ^476a9c
	- the agent's policy is fixed and the task is to learn the utilities of states (or (s,a) pairs), which might also involve learning a model of the environment
	- we need to estimate $P(s' | s,a)$ and $R(s)$
- **what's active RL** ^fd4abf
	- the agent must also explore as much as possible of its environment in order to learn how to behave in it
	- unknown policy ; we need to estimate $P(s' | s,a)$ and $R(s)$ **while determining the policy**
- **what is a policy**
	- ![[uofg-AI-glossary#^ccb0a5]]
- **what is the difference between tabular and function approximation versions of the algorithms**
	- tabular represents the utilities and probabilities in tables, which is not tractable for large state spaces
	- func approx represent knowledge about utilities and actions as a function **mapping directly from states to utility**. This generalises better, we can now predict the utility (hence the policy) for states even if unvisited


### Relevant Exam Questions