

### Pre
- [ ] AIMA 16

### Post

### Outline

#### [[uofg-AI-4]] essentials review

00:01:30 - review of Bayes
00:02:56 - review marginalisation
00:03:55 - markov process to model observations of things
	- starting with full joint
	- we use the conditional derived from the joint to find a probability
00:06:20 - markov assumption
	- allows us to write the full joint for all timesteps
00:07:49 - transition model given by the conditional distribution
00:09:27 - full joint as a bayesian network
00:09:39 - summary of the process

#### Utility Theory

00:00:31 -  notation, lottery defn
00:02:43 - axioms of preference
	- constraints that must be obeyed for preferences of a rational agent
	- not examinable; we assume in utility (next section) that these hold
00:06:20 - utility theorem
00:07:40 - expected utility
	- think about assigning preferences to every outcome
	- there is an utility function
	- we can compute the expected utility just like the expectation , as the weighted sum of the lottery, i.e. sum of the product of each probability and state
00:11:43 - because coming up with ut functions is difficult, experiments using lotteries are useful for calibration
00:12:44 - utility scales , e.g. micromorts, QALYs
00:13:23 - utility of money example
00:15:54 - MEU principle
	- which action should you take from a certain state
	- compute the utility using the (transitional model) probability of the next possible state conditioned on the current state and some action ; it's like extended markov 
00:38:07 (-10 from here on) - worked question of choosing best action by calculation their expected utility **EXAM QUESTION**
00:39:50 - decision networks for visualisaing the decision process 
00:40:56 - problems with MEU
 	- average may not always be the best (e.g. Russel argues that this is not the best framework)

#### Value of Information

00:00:00 -  assigning value to new information, motivating example
00:03:38 - general VOI
	- compute the expected utility
	- suppose we know the potential new evidence do condition EU
	- Value of perfect information 00:06:00 **EXAM QUESTION**
		- properties not particularly important for the course
00:07:33 - high-level motivating example 
11:15 == 00:00
00:00:25 - numerical example **EXAM QUESTION**
	- conditional distribution key : modify M -> action , R-> regulation
	- several conditional distributions provided, as well as the prior distribution of the regulation being in place
	- utility functions provided
	- key question? What is the value of knowing that the regulation is going to be implemented
	- 00:08:06 - need to use the equations see general VOI.
		- 1. compute the expected utility of the best action without the  information
		- 2. compute with the expected utility conditioned also on the information
		- 3. we can then compute the VPI by taking the difference between the 2 and 3
	00:13:49 - MEU in a nutshell
	

### Summary

### Key Insights (questions form)

### Relevant Exam Questions