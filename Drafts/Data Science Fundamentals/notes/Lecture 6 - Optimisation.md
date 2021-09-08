# Lecture 6 - Optimisation

![](@attachment/Clipboard_2021-05-26-01-37-33.png)

- improving performance via an algorithm
  - key to ML, manufacturing, logistics companies
  - we aim to use a class of algorithms to solve all kinds of optimisation problems
  - requires specifying the problem in a formal way

Parameters
: the variables we can adjust

Parameter Space $(\Theta)$
: the set of all possible configurations of parameters 

Constraints
: the limitations on the params. The *feasible region* of the parameter space

Objective Function $L(\theta)$
: maps the params onto a single numerical measure of how good a specific configuration of those is. a.k.a, *loss, cost, fitness, utility function*

- the aim of an optimisation algorithm is to find the parameters which minimise the objective function

$$
\theta^{*}=\underset{\theta \in \Theta}{\arg \min } L(\theta)
$$

- often problems are expressed in a form where the objective function is a distance between an output and some reference point
  - i.e., we have some function $y^{\prime}=f(\mathbf{x} ; \theta)$ , with $x$ representing some *fixed* input and $theta$ the set of params and we measure the difference between the output and some reference $y$

  $$
L(\theta)=\left\|y^{\prime}-y\right\|=\|f(\mathbf{x} ; \theta)-y\|
$$

### Evaluating the objective function

- it may be expensive to evaluate the objective function (e.g. expensive training data , computing time)
  - good optimisation algorithm will find the optimal configuration of parameters with as few runs/evaluations of the objective function as possible
  - requires the existence of mathematical structure to guide the search, and not just guess

### Discrete Vs Continuous 

- defined by whether the params lie in a discrete or continuous space
  - continuous is the focus of this course and usually easier, because the concepts of smoothness and continuity play nicely with approximation algorithms
  - focus on iterative, approximate optimisation


## Constrained Optimisation

![](@attachment/Clipboard_2021-05-26-03-29-23.png)

- equality 
  - constrains the parameters to a surface, to represent a tradeoff
  - might be used when the total value must remain unchanged
- inequality
  - constrains the parameters to a volume, to represent bounds on the values

> REM : unconstrained optimisation is often not useful for real life problems 

#### Common Constraints

- $\theta$ must lie within a box inside $R^n$
  - e.g. $0 < \theta < 1$ 
- convex constraints are a superset of box
  - collection of inequalities

![](@attachment/Clipboard_2021-05-26-03-32-08.png)

### Relaxation and Soft Constraints

- algorithms that support hard constraints inherently can be inflexible ; soft constraints are an alternative which allow use of more general algorithms but apply penalties to the objective function to discourage solutions that violate the constraints
  - the objective function can be composed by a original objective function plus some penalty function
  - less efficient search in constrained regions of space

$$
L\left(\theta^{\prime}\right)=L(\theta)+\lambda(\theta)
$$

- we can *relax* the objective function by transforming constrained and discrete problems into similar continuous/unconstrained ones
- penalisation augments the objective function to minimise some other property of the solution
  - widely used to find solutions that generalise well

## Properties of the Objective Function

- local minima, if present represents a point where the OF increases in every direction
- convex , if it has a *single , global minimum*
  - implies that finding a minimum is equivalent to finding the optimal solution

### Convex Optimisation

- efficient methods 
  - linear programming , if OF and constraints are linear
  - quadratic programming, if OF is quadratic and constrains are linear

- non-convex problems require iterative methods

### Continuity

- continuous , if for very small adjustment to $\theta$ there is an *arbitrarily small* change in $L(\theta)$ 
  - for discontinuous functions , local search methods are not guaranteed to converge (the local behaviour/shape is not regular)

## Algorithms

### Direct Convex Optimisation - Least Squares

- linear least squares solutions can be computed in one step for OFs of the form below
  - it finds the $x$ which is closest to the solution $Ax=y$ by minimising the squared $L_2$ norm
  - note that we know that there exists a single global minimum because it's quadratic

$$
\underset{x}{\arg \min } L(\mathbf{x})=\|A \mathbf{x}-\mathbf{y}\|_{2}^{2}
$$

#### Linear Regression (line fitting)

- one of the simplest process which makes use of this is *linear regression, which finds the gradient and the y-intercept for $y = mx + c$ such that the squared distance to a set of observed points is minimised , i.e. we want to minimise the error between our line (predictions) doing the approximation and the data (true values)
  - OF : $L(\theta)=\sum_{i}\left(y-m x_{i}+c\right)^{2}$
    - hence we have $\theta = [m, c]$
  - can be solved directly using the pseudo-inverse via SVD

> REM : see ML notes for a *preeeetier* explanation

### Iterative - Grid Search

- update some parameter vector at each iteration

1. choose a starting point #x_0$
1. while OF is changing
  1. adjust parameters
  1. evaluate OF
  1. if better solution, record it
1. return best parameter vector

- grid search is an algorithm which uses this approach 
  - divide the parameter space into a grid
  - evaluate the OF at each $\theta$ on the grid (choosing the best params in each grid/at each iteration)
  - simple but inefficient for multidimensional problems
    - even for small parameter spaces the number of combinations of points in each subdivision grows exponentially with the number of dimensions
    - number of OF evaluations required is unfeasible
  - choosing an appropriate grid requires knowing in advance how smooth the function is, or the minimum might be lost
    - bias towards the corners and edges of the space ; it depends very much on the starting point

![](@attachment/Clipboard_2021-05-26-04-34-05.png)

- **hyperparameters** are properties which affect the way in which the optimiser finds a solution 
  - e.g. Grid search : range and density of the grid
  - they do not affect the objective function, just how the search works

> REM : ideally , a sufficiently general algorithm's solution should not depend on *how* it was found, so in theory hyperparameters would not exist. In practice however, useful optimisers rely on them, and fine tuning these is a common step

### Simple Stochastic - Random Search

1. guess $\theta$
1. Check $L(\theta)$
1. If $L(\theta) < L(\theta_{\text{best}}), \quad \theta_{\text{best}} = \theta$

![](@attachment/Clipboard_2021-05-26-04-43-52.png)

#### Metaheuristics

- used to improve random search
  - we make weak assumptions about the objective function

- **Locality** which takes advantage of the fact the objective function is likely to have similar values for similar
parameter configurations. This assumes continuity of the objective function.
- **Temperature** which can change the rate of movement in the parameter space over the course of an
optimisation. This assumes the existence of local optima.
- **Population** which can track multiple simultaneous parameter configurations and select/mix among them.
- **Memory** which can record good or bad steps in the past and avoid/revisit them.


### Locality - Hill Climbing

- local search algos make incremental changes to a solution
  - subject to becoming trapped in local minima
  - implies that the output of the optimisation depends on the initial conditions , e.g. might start at a point which combined with a certain *"jump"* value might lead to bouncing around in a valley around a local minimum

![](@attachment/Clipboard_2021-05-26-04-52-31.png)

- **Hill Climbing** modifies random search which assumes some topology of the parameter space so that there is a meaningful concept of a *neighbourhood* of the parameter vector which we can change *incrementally*
  - at each iteration it samples randomly *but only* from the space near the current best param vector
  - it transitions between neighbouring states only if it sees an improvement
  - two versions:
    - simple , adjusts one parameter at a time
    - stochastic , makes a random adjustment to the whole parameter
  - **metaheuristics**
    - size of the neighbourhood
    - number of runs for random initial guesses

![](@attachment/Clipboard_2021-05-26-04-58-01.png)


### Temperature

- **simulated annealing** allows hill-climbing to randomly go uphill instead of always going downhill
  - more uphill steps allowed at the start, fewer later on
  - allowing random seemingly non-optimal jumps might reduce the possibility of jumping around a local minimum

### Population

- use the ideas of evolution in nature and have different parameters compete with each other. Several variants of *genetic algorithms*
  - **mutation** , introduces random variation
  - **natural selection** , solution selection
  - **breeding**, mix solutions

**Genotype**
: the parameter set of a solution

- simple approaches use small random perturbations and a simple culling rule. Copying the surviving solutions from the previous iteration

- **crossover** are more advanced algorithms which introduce some combination of fittest solutions as the next iteration, instead of simply copying the parents
  -e.g. [link](https://www.damninteresting.com/on-the-origin-of-circuits/)

![](@attachment/Clipboard_2021-05-26-05-59-26.png)

### Memory

- optimiser remembers where "good" and "bad" bits of the paramaters space are (discovered in previous iterations), using this memory to make better decisions and not repeat bad ones . The aim is remembering good *paths in the solution space*

#### Ant Colony Optimisation (Memory + Population)


Stigmergy
: A mechanism of spontaneous, indirect coordination between agents or actions, where the trace left in the environment by an action stimulates the performance of a subsequent action

- It uses the *stigmergy* to optimise problems 

![](@attachment/Clipboard_2021-05-26-06-04-03.png)

![](@attachment/Clipboard_2021-05-26-06-04-40.png)

## Evaluating

- convex : good -> global minimum found
- convex : good -> local minimum from which the algo cannot escape
- converges quickly
  - most heuristic algos are not guaranteed to converge even if a solution exists
  - for iterative solutions a plot of the objective function against iteration is a helpful debugging tool, to catch possible convergence problems (ideally a very steep loss should be observed at the start)

![](@attachment/Clipboard_2021-05-26-06-09-52.png)

## Tuning 

- as mentioned above we want the number of hyperparameters to be as small as possible since finding the right ones is in itself an optimisation problem

- When thinking about the right way to search, the key step is always think about the right type of algorithm

![](@attachment/Clipboard_2021-05-26-06-12-05.png)

### Problems to lookout for

- Slow progress
  - common in local search for each a too small step was chosen
- Noisy and Divergent 
  - too large steps , *"bouncing around"*
- Getting stuck
  - usually at critical points of the objective function

  ![](@attachment/Clipboard_2021-05-26-06-14-57.png)

  ![](@attachment/Clipboard_2021-05-26-06-14-45.png)

