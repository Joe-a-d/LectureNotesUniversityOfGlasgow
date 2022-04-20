### Pre

- Read [[AIMA]]
	- [x] 3
	- [ ] 4-4.2.2
- [x]   have a crack at the lab

### Post
- [Quiz](https://moodle.gla.ac.uk/mod/quiz/view.php?id=2566157)

### Summary

### Outline
- [[modeling problems in AI by abstracting unecessary details; components of the model]]
- [[agent function]]
- agent formulation and problem solving by posing the agent function as optimization problem via a suitable cost function (discrete vs continuous problems
	- algorithms for solving them and complexity analysis
		
#### Uninformed search in discrete state spaces.
- [[uofg-AI-3#^3966e8|Assumptions]]
- tree/graph search
	- [[BFS]]
	- [[Uniform-cost search]]
	- [[DFS]]
		- [[DFS#^85b9c9|limited]]
		- [[DFS#^8ee3c5|iterative]]
#### Informed search in discrete state spaces.

- **Assumptions/conditions:**   ^3966e8
	-   **Problem:** Finding the optimal solution to the goal with the lowest path cost will maximise the performance measure
	-   **State-space:** _Discrete_, _fully observable_, _known_ , i.e., we have a "map" of the world, it might be infinite.  
    -   **Transition model:** Known, i.e. all states and actions are know.  
    -   **Initial state**: Known  
    -   **Optimal state**: Known  
    -   **Cost function:** Path cost to goal  
    -   **Solution:** Under these conditions we know the solution is a fixed set of actions leading to the optimal state (which can be computed without carrying out the actions), i.e. can be solved offline.

- [[Greedy Best-first]]
- [[A*]]
	- optimal if triangle inequality met 14:21:49

#### Search/optimisation in continuous state spaces 
- **note** slightly different type of goal
- **Assumptions/conditions:**  
	-   **Problem:** Finding the optimal state will maximise the performance measure  
	-   **State-space:** Continuous OR discrete, and fully observable (state-space), i.e., we have a "map" of the world or can evaluate everywhere without actually being in the state  
	-   **Transition model:** Known  
	-   **Initial state**: Known  
	-   **Goal/optimal state**: The goal is to find state where gradient is zero and the curvature is non-zero.  
	-   **Cost function:** Continuous and known (it directly defines the performance measure).  
	-   **Solution type:** Under these conditions we know the solution is a fixed set of actions which can be found without carrying out the actions, i.e. can be solved offline (although typically done in an online manner)

- [[hill climbing]]
- [[gradient descent]]
