# Lecture 7 - Optimisation (Gradient Descent)

![](@attachment/Clipboard_2021-05-28-01-42-15.png)

# First-Order Algorithms

- Problem : some optimisation problems have many parameters ; heuristic search doesn't scale

- Solution : use *first-order* algorithms

### Intuition

- think of the OF as a smooth surface
  - rolling ball represents a particular value
  - eventually it will settle in a well

## Gradient Vector

Jacobian matrix
: all derivatives of a function whose input and output are both vectors . It tells us how much each component of the output changes as we change any component of the input

$$
f^{\prime}(\mathbf{x})=\mathbf{J}=\left[\begin{array}{cccc}\frac{\partial y_{0}}{\partial x_{0}} & \frac{\partial y_{0}}{\partial x_{1}} & \cdots & \frac{\partial y_{0}}{\partial x_{n}} \\ \frac{\partial y_{1}}{\partial x_{0}} & \frac{\partial y_{1}}{\partial x_{1}} & \cdots & \frac{\partial y_{1}}{\partial x_{n}} \\ \cdots & & & \\ \frac{\partial y_{m}}{\partial x_{0}} & \frac{\partial y_{m}}{\partial x_{1}} & \cdots & \frac{\partial y_{m}}{\partial x_{n}}\end{array}\right]
$$

- Jacobian matrices help us characterise the variation of a vector function at a point $x$
  - If $y \in R$ we are mapping from an $n$ dimensional input to a one dimensional output, i.e we input a parameter vector and get a single scalar back, we end up with a single row Jacobian - the **gradient vector**
    - this is what happens in the case of $L(\theta)$ , the loss function, when we get the scalar telling us how good our model is

Gradient Vector ($\nabla f(\mathbf{x})$)
: the equivalent of a first order derivative for vector functions, which tells us how much the output would vary if we made very small changes to each dimension *independently*

$$
\nabla L(\theta)=\left[\frac{\partial L(\theta)}{\partial \theta_{1}}, \frac{\partial L(\theta)}{\partial \theta_{2}}, \ldots, \frac{\partial L(\theta)}{\partial \theta_{n}},\right]
$$

- we have one partial derivative per component of $\mathbf{x}$
- the GV of $L(\theta)$ function is a vector which points in the direction of the steepest change in $L(\theta)$

![](@attachment/Clipboard_2021-05-28-02-16-53.png)

### Hessian ($\nabla^{2} f(\mathbf{x})$)

- second derivative
  - tells us about the curvature at that point
  - maps from $\mathbb{R}^{n} \rightarrow \mathbb{R}^{n \times n}$
    - the second derivative scales quadratically with the dimension of its input

- every pair of directions gets an entry in the matrix, which tells us how much those two directions vary together


$$
H(L)=\nabla \nabla L(\theta)=\nabla^{2} L(\theta)=\left[\begin{array}{ccccc}\frac{\partial^{2} L(\theta)}{\partial \theta_{1}^{2}} & \frac{\partial^{2} L(\theta)}{\partial \theta_{1} \partial \theta_{2}} & \frac{\partial^{2} L(\theta)}{\partial \theta_{1} \partial \theta_{3}} & \cdots & \frac{\partial^{2} L(\theta)}{\partial \theta_{1} \partial \theta_{n}} \\ \frac{\partial^{2} L(\theta)}{\partial \theta_{2} \partial \theta_{1}} & \frac{\partial^{2} L(\theta)}{\partial \theta_{2}^{2}} & \frac{\partial^{2} L(\theta)}{\partial \theta_{2} \partial \theta_{3}} & \ldots & \frac{\partial^{\rho} L(\theta)}{\partial \theta_{2} \partial \theta_{n}} \\ \ldots & & & & \\ \frac{\partial^{2} L(\theta)}{\partial \theta_{n} \partial \theta_{1}} & \frac{\partial^{2} L(\theta)}{\partial \theta_{n} \partial \theta_{2}} & \frac{\partial^{2} L(\theta)}{\partial \theta_{n} \partial \theta_{3}} & \ldots & \frac{\partial^{2} L(\theta)}{\partial \theta_{n}^{2}}\end{array}\right]
$$

### Differentiable Objective Functions

- some OF functions' derivatives are easy to calculate, which allows us to know what constitutes a good move, but that's not always the case. Multidimensional OFs where $theta$ has more than one component and so we have a gradient vector instead of a simple scalar derivative require more intensive computations, even though the same principles apply
  - we classify iterative algorithms for solving them according to the order of the derivative they require

![](@attachment/Clipboard_2021-05-28-02-28-37.png)

## Derivatives and Optimisation

- main boost here is that by knowing the slope of the OF at any given point we essentially know what a good move at that point means. We know the *direction* of fastest increase and the *steepness* of that slope. We don't just guess like with heuristic algorithms


### Differentiability

- the function needs to be differentiable
  - it is smooth *up to* some order

$C^n$ continuous
: a function whose $n^{th}$ derivative is continuous

- it follows that for first order optimisation, which requires first order derivatives of the OF with respect to the parameters, the OF must be
  - at least $C^1$ , no sudden jumps in the function or its derivative (there must be a concept of neighbourhood)
  - differentiable , gradient defined everywhere

### Lipschitz Continuity

- the gradient must be bounded and the function cannot change more quickly than some constant
  - $\frac{\partial L(\theta)}{d i} \leq K \text { for all } i \text { and some fixed } K$
  - in the image below the lines of the cones represent the maximum slope of the function, which never intersect with the function anywhere when we move along it
  - note that the wider the cone is the smoother the function is and vice-versa
  - this value of smoothness $K$ , is given by $K=\sup \left[\frac{|f(x)-f(y)|}{|x-y|}\right]$ , where $\sup$ is the supremum; the smallest value that is larger than every value of this function

![](@attachment/Clipboard_2021-05-28-02-43-49.png)

## Gradient Descent

$$
\theta^{(\mathbf{i}+\mathbf{1})}=\theta^{(\mathbf{i})}-\delta \nabla L\left(\theta^{(\mathbf{i})}\right)
$$

- The basic first-order algorithm
  - start at some $\theta^{(0)}$
  - calculate the derivative in order to find the steepness of the neighbourhood locations $v=\nabla L\left(\theta^{(\mathrm{i})}\right)$
  - move some $\delta$ - *step size* - in the steepest direction $v$ to find $\theta^{(i+1)}$
  - repeat


#### CAVEATS

- local method -> getting stuck local minimum
- not necessarily optimal

![](@attachment/Clipboard_2021-06-03-07-32-27.png)

- **Step size**
  - too large may lead to divergent or inefficient
  - too small , inefficient 


> REM : there is a direct relation between the Lipschitz constant $K$ and the step size $\delta$

![](@attachment/Clipboard_2021-06-03-07-43-25.png)

### Automatic Differentiation

**Why not numerical differentiation method?**

- very prone to floating point errors
  - **magnitude error** : the interval $h$ is potentially much smaller than the value from which it is subtracted from $x$
  - **cancelation error** : $f(x + h)$ , $f(x - h)$
  - **division magnification** : division by a very small number $2h$
- curse of dimensionality : evaluating the gradient at point $x$, would require computing the numerical differences in each dimension

  $$
\frac{f(x+h)-f(x-h)}{2 h}
$$

> "Automatic differentiation gives exact answers in constant time"[^1]

- usually first class citizens in some PL
- form the basis of modern ML frameworks (e.g. TensorFlow, PyTorch)
  - This is what machine learning libraries do. They just make it easy to write vectorised, differentiable code that runs on GPU/TPU hardware


#### Limits of AD

- **the function has to be differentiable**
  - *Stochastic Relaxation* can help with this. It involves integrating over many different random conditions, such that the steep gradient of a function can become approximately Lipschitz continuous

![](@attachment/Clipboard_2021-06-03-08-10-12.png)

### Stochastic Gradient Descent

- optimisation on GD by formulating the problem such that we break the OF into small parts and the optimiser can do GD on *randomly* selected parts *independently* which speeds things up since we are not evaluating the OF at all possible points at each step
  - OF must be able to be written as a sum $L(\theta)=\sum_{i} L_{i}(\theta)$
  - this often occurs in approximation problems, such as ML applications
    - many training examples $x_i$ with matching known outputs $y_i$ , and we want to find the parameter vector $\theta$ such that we minimise $L(\theta)=\sum_{i}\left\|f\left(\mathbf{x}_{\mathbf{i}} ; \theta\right)-y_{i}\right\|$
  - this is possible because differentiation is a linear operator. Hence, the gradient of the sum is equal to the sum of the gradients
    - we can move according to the computed gradient of a subset ; the idea being that *over time* the random subset selection will average out
    - we call each subset **minibatch** and one run through the whole dataset an **epoch**

- given the heuristic nature of this process, there's no guarantee it will improve things, but in practice it often does

> REM : also note how perhaps unintuitively, adding noise by randomly partitioning the OF leads to a smoother end result

> REM : by far the most common algo in ML

### Random Restart

- for complicated functions where SGD is not an option
  - tries and overcome the common pitfall of local search methods - getting trapped in minima

1. Run GD until it gets stuck
1. Restart from a random starting point
1. Repeat until one of the optimisation paths ends up in the global minimum

### Momentum

- Aims to reduce the likelihood of getting stuck when using SGD by interfering with the sensitivity of the "next best" gradient choice, i.e. it sort of remembers the current optimal path, it only changes paths if the next optimal is steeper/better than the current *plus some threshold* $\alpha$
  - introduce a velocity $v$ which guides the optimiser direction
  - adjust $v$ to align with the derivative, using a parameter $0.0 < \alpha 0.0$

$$
\begin{array}{c}v=\alpha v+\delta \nabla L(\theta) \\ \theta^{(i+1)}=\theta^{(i)}-v\end{array}
$$


[^1]: https://marksaroufim.medium.com/automatic-differentiation-step-by-step-24240f97a6e6
[^2]: https://alexey.radul.name/ideas/2013/introduction-to-automatic-differentiation/
[^3]: http://videolectures.net/deeplearning2017_johnson_automatic_differentiation/
[^4]: https://ruder.io/optimizing-gradient-descent/


## Second Order Optimisation

- We use the Hessian matrix to jump to the bottom of each local quadratic approximation *in a single step*
  - can skip over flat plains and escape from saddle points, which slow down GD

- it doesn't however scale in high dimensions, since evaluating the Hessian matrix requires $d^2$ computations and $d^2$ storage

### Classifying Critical Points - Hessian Matrix

- different critical points will have different configuration of the eigenvalues of the Hessian
- the second order derivative represents the curvature of a function
  - for every parameter $\theta_i$ the Hessian stores how the steepness of every other $\theta_j$ changes

### Geometric Analogy

![](@attachment/Clipboard_2021-06-03-08-48-29.png)

![](@attachment/Clipboard_2021-06-03-08-49-24.png)

### Eigenvalues' Semantics

- **positive definite** : strictly positive eigenvalues ; the point is a minimum
- **negative definite** : strictly negative eigenvalues ; the point is a maximum
- mixed signs ; saddle point
- **semidefinite** : same sign and zero ; plateau/ridge

