# Learning from rewards and observations - function approximations in [[RL]]

### Pre

- [ ] AIMA 19.1,2,4,6
- [ ] AIMA 22.1,3,4,5
- [ ] AIMA 23 (focus on 23.4)

### Post

### Outline

- today's lectures addresses the problems with tabular Q-learning with the aim of making the models more general and reduce the amount of exploration of environment needed to learn
- **function approximation**
- 00:15:00 - we want to represent the utility as a function of the states
- 00:16:30 - relation with supervised learning ; regression
- 00:24:00 - optimisation methods : gradient descent
	- 00:30:00 - stochastic version is more commonly used in RL
- 00:32:30 - tying it back to RL ; the motivation is to be able to use functions to predict the utility and Q values for unseen states
	- 33:00 - for U we can just fit to a function of s (the states) parameterised on w
	- 00:34:00 - for Q , the simplest option is to fit a separate function for each action parameterised; so that we come up with a set of parameters which are unique to each action
- 00:35:40 - what is the equivalent to the training examples and labels used in regression in the context of RL? -> we can run simulations and sample directly **but** slow **hence** we want to exploit the the bellman equations ; the connection between utilities of neighbouring states discussed in [[uofg-AI-7]]
- 00:37:00 - passive RL SGG/Delta rule/Windrow-Hoff
	- start by running a simulation keeping track of the total reward obtained until termination
	- for each state visited during the simulation we calculate their utility using the discounted reward method. we use this as the data for our fitting step -> (s,U_j(s)) pairs are our training examples
	- we can then calculate the loss using the current utility suggested by the model U_w and the utility found in the previous step
	- using this loss function, we can perform the optimisation, i.e. update the weights using Widrow-Hoff
- 00:43:30 - active RL SGG/Delta rule/Windrow-Hoff
	- 00:44:30 - algorithm
	- 00:46:00 - how do we update the U_w ; we can still do the target-current like we did for the tabular Q learning , **but** our function is parameterised by w, hence we need a method which can update w based on the change in in the U_w(s) -> we use gradient descent
		- 00:50:30 - getting the update rule (recall, based only on one transition) via gradient descent by using a loss function based on the target value and the current value ; we can then apply gradient descent to the loss function
		- 00:54:00 - the same for Q functions 
		- **REM** derivations not required knowledge
	- 00:55:00 - the update rule summary formula WTF IS THIS????
- **which functions to choose**
- 00:02:53 - overview of the issues involved in choosing one
- 00:03:05 - moving from linear to more complex functions : **radial basis functions**
- 00:08:01 - how we can vary the hyperparameters/free parameters, i.e. those that affect the shape and width of the chosen RBF to get different shapes to fit to the model
- 10:00:00 - using sklearn to create bump functions (RBF) and find out the best weights
- 00:16:00 - summary : we implemented the RBF equation shown at the top of the RBF section 
- **neural networks**
- for this course you should think of a NN as just a function formed of small blocks; adding more blocks increases the complexity of the function
- 00:03:00 - artificial neuron overview
- 00:07:30 - what kind of functions can a single neuron represent?
	- 13:30 - how a perceptron (single neuron) is not able to represent `xor`
- 00:16:00 - feed-forward NN
	- 17 - example ; a5 is the output of neuron 5
	- 20 - a (min) 2-layer NN can fit any continuous function, *universal function approximator* ; 
	- 22 - backpropagation
- **NN w.r.t RL**
	- 00:27:30 - *Deep Q-learning* : key to understand the implementation of the update rule
		- see [[uofg-AI-9]] for further details
	- 00:32:00 - summary

### Summary

### Key Insights (questions form)
- what are the steps of the DQL algo
- why are RBF still linear model ? why NN non-linear?
### Relevant Exam Questions