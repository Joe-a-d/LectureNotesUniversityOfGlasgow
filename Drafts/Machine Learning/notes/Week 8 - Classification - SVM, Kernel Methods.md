# Week 8 - Classification - SVM, Kernel Methods

***
**Lecture 10** 
***
![](@attachment/Clipboard_2021-07-25-16-08-16.png)

- binary classifier
  - particularly useful in applications where the number of attributes is much larger than the number of training objects
  - in SVM the number of params is related to the number of training objects not attributes

- linear decision boundary
  - $\mathbf{w}^{\top} \mathbf{x}_{\text {new }}+b$
  - class labels range is [-1,1]

- decision function for unseen data point **x_new**

$$
t_{\text {new }}=\operatorname{sign}\left(\mathbf{w}^{\top} \mathbf{x}_{\text {new }}+b\right)
$$

- the **goal** is to choose the values of **w** and **b** based on the training data by maximising the *margin*
  - by maximising the margin the margin of error of the classifier should be lower since ties will be less likely
  - note how the same point on the same training set will be harder to classify in the image below

  ![](@attachment/Clipboard_2021-07-25-14-35-30.png)

# The Margin

- the perpendicular distance from the decision boundary to the closest point on either side

- it is easiest to compute the margin using the closest point from each class which are closest to each other
- $2\lambda$ is equal to the component of the vector joining $x_1 , x_2$ in the perpendicular
- the direction perpendicular to the decision boundary is given by $\mathbf{w} /\|\mathbf{w}\|$ 
- the **inner product** between these two quantities gives us our $2\gamma$

$$2 \gamma=\frac{1}{\|\mathbf{w}\|} \mathbf{w}^{\top}\left(\mathbf{x}_{1}-\mathbf{x}_{2}\right)$$

- but, since our decision function is invariant to scaling by a positive constant, we can multiply it by a positive constant $\gamma$ and the output of the sign will be unchanged.
  - Hence, we can fix the scaling of **w**, $b$ such that $\mathbf{w}^{\top} \mathbf{x} + b = \pm 1$ for the closest points on either side
  - which in turn allows us to simplify the above expression to a function of $$w$$

  $$
\begin{aligned} 2 \gamma &=\frac{1}{\|\mathbf{w}\|} \mathbf{w}^{\top}\left(\mathbf{x}_{1}-\mathbf{x}_{2}\right) \\ &=\frac{1}{\|\mathbf{w}\|}\left(\mathbf{w}^{\top} \mathbf{x}_{1}-\mathbf{w}^{\top} \mathbf{x}_{2}\right) \\ &=\frac{1}{\|\mathbf{w}\|}\left(\mathbf{w}^{\top} \mathbf{x}_{1}+b-\mathbf{w}^{\top} \mathbf{x}_{2}-b\right) \\ &=\frac{1}{\|\mathbf{w}\|}(1+1) \\ \gamma &=\frac{1}{\|\mathbf{w}\|} \end{aligned}
$$

  ![](@attachment/Clipboard_2021-07-25-14-40-43.png)

## Maximising

- **constraints**
  - we need the closest point in C1 to have decision boundary equal to 1, hence we need to find a **w** that satisfies $\mathbf{w}^{\top} \mathbf{x}_{n}+b \geq 1$
  - opposite is true for C-1
  - By defining the labels as $\pm1$ we can represent these two sets of constraints as 
  - $t_{n}\left(\mathbf{w}^{\top} \mathbf{x}_{n}+b\right) \geq 1$

- Hence, the learning task will consist of finding the largest values of $\gamma$ that satisfies these $N$ constraints (one for each of the $N$ training data points)
  - **but** this is harder to do than **minimising** its equivalent, the square of the L2 norm, so we'll do this instead

  $$
\begin{array}{cl}\underset{\mathbf{w}}{\operatorname{argmin}} & \frac{1}{2}\|\mathbf{w}\|^{2} = \frac{1}{2}\mathbf{w}^2\mathbf{w}\\ \text { subject to } & t_{n}\left(\mathbf{w}^{\top} \mathbf{x}_{n}+b\right) \geq 1, \text { for all } n\end{array}
$$

- in order to minimise our objective function while abiding our constraints we'll use Lagrange multipliers*, which allow us to incorporate the constraints into the objective function
  - for each constraint we'll add a new term such that the optimum of this new joint function is the same as that of the original function

  $$
\begin{array}{ll}\underset{\mathbf{w}, \alpha}{\operatorname{argmin}} & \frac{1}{2} \mathbf{w}^{\top} \mathbf{w}-\sum_{n=1}^{N} \alpha_{n}\left(t_{n}\left(\mathbf{w}^{\top} \mathbf{x}_{n}+b\right)-1\right) \\ \text { subject to } & \alpha_{n} \geq 0, \text { for all } n\end{array}
$$

- by looking at the optimum points and constraints we can derive an expression known as the dual optimisation problem and its constraints
  - **full derivation pages 188,189**

$$
\begin{aligned} \underset{\alpha}{\operatorname{argmax}} \sum_{n=1}^{N} \alpha_{n}-\frac{1}{2} \sum_{n , m=1}^{N} \alpha_{n} \alpha_{m} t_{n} t_{m} \mathbf{x}_{n}^{\top} \mathbf{x}_{m} \\ \text { subject to } \sum_{n=1}^{N} \alpha_{n} t_{n}=0, \quad \alpha_{n} \geq 0 \end{aligned}
$$

- has a single global solution, and since it is a standard quadratic, can be solved by *quadratic programming* algos

# Prediction

- our decision function is a function of **w**, b , so we need to write it w.r.t $\alpha_n$

$$
t_{\mathrm{new}}=\operatorname{sign}\left(\sum_{n=1}^{N} \alpha_{n} t_{n} \mathbf{x}_{n}^{\top} \mathbf{x}_{\text {new }}+b\right)
$$

- to find b
  - $x_n$ is any of the closes points

$$
b=t_{n}-\sum_{m=1}^{N} \alpha_{m} t_{m} \mathbf{x}_{m}^{T} \mathbf{x}_{n}
$$

## Support Vectors

Support Vectors
: the set of points closest to the max margin decision boundary

- predictions only depend on these data points
  - as expected, since our margin function only takes into account the closes points, i.e only where $\alpha > 0$
  - computationally efficient, but not always good
    - moving a single data point can have a very large effect on the position of the decision boundary - **over-fitting** risk, i.e. the data has too much influence


![](@attachment/Clipboard_2021-07-25-15-20-45.png)

![](@attachment/Clipboard_2021-07-25-15-20-50.png)


- we can relax this constraints to better generalise performance, using *soft margin* SVM

## Soft Margins

- instead of requiring our constraint to be $\leq \pm1$ , we add a buffer value to relax it
  - if $0 \leq \xi_{n} \leq 1$ , the point lies on the correct side but withing the boundary of the margin
  - if $\xi_n > 1$, the point lies on the wrong side of the boundary

$$
t_{n}\left(\mathbf{w}^{\top} \mathbf{x}_{n}+b\right) \geq 1-\xi_{n}
$$

- our optimisation problem now 
  - this new parameter $C$ controls to what extent we are willing to allow points to sit within the margin band or on the wrong side of the decision boundary

$$
\begin{array}{cc}\underset{\mathbf{w}}{\operatorname{argmin}} & \frac{1}{2} \mathbf{w}^{\top} \mathbf{w}+C \sum_{n=1}^{N} \xi_{n} \\ \text { subject to } \xi_{n} \geq 0 & \text { and } & t_{n}\left(\mathbf{w}^{\top} \mathbf{x}_{n}+b\right) \geq 1-\xi_{n} \text { for all } n\end{array}
$$

- adding the Lagrange multipliers
  - the only difference is an upper bound $C$ on $\alpha_n$

$$
\begin{array}{cl}\underset{\alpha}{\operatorname{argmax}} & \sum_{n=1}^{N} \alpha_{n}-\frac{1}{2} \sum_{n, m=1}^{N} \alpha_{n} \alpha_{m} t_{n} t_{m} \mathbf{x}_{n}^{\top} \mathbf{x}_{m} \\ \text { subject to } & \sum_{n=1}^{N} \alpha_{n} t_{n}=0 \text { and } 0 \leq \alpha_{n} \leq C, \text { for all } n .\end{array}
$$


![](@attachment/Clipboard_2021-07-25-15-20-59.png)

### Choosing the right $C$

- the choice of $C$ is very important
  - too high and we over-fit the noise
  - too low and we underfit and lose any sparsity

![](@attachment/Clipboard_2021-07-25-15-34-37.png)

![](@attachment/Clipboard_2021-07-25-15-34-44.png)

- We can use cross-validation to choose the right value

![](@attachment/Clipboard_2021-07-25-15-36-12.png)

## Kernels

- so far we've only seen linear decision boundaries, which will not work for more complex data

![](@attachment/Clipboard_2021-07-25-15-40-28.png)

- the fact that our data points only appears in the form of inner products allow us to leverage the idea of kernels
  - a kernel function is a function that correspond to inner products in some space

- in linear regression we added some terms to **x** and extended **w** in order to come up with non-linear decision boundaries, but in SVM the model remains the same for we **transform the data** into some new space
  - the transformed data must still be able to be separated with a straight line
  - e.g. we could represent each data point by their distance from the origin $z_n = {x_n1}^2 + {x_n2}^2$
  - we can then use $z_n$ instead of $x_n$  in the SVM algo

- Let $\phi\left(\mathbf{x}_{n}\right)$ represent a transformation of the $n$th training object

![](@attachment/Clipboard_2021-07-25-15-52-31.png)


- Note that we never actually have to perform the transformations on each of the data points to calculate their inner product in the new space, instead we can show that some function $k\left(\mathbf{x}_{n}, \mathbf{x}_{m}\right)=\phi\left(\mathbf{x}_{n}\right)^{\top} \phi\left(\mathbf{x}_{m}\right)$ for some transformation $\phi(\cdot)$
  - we never actually project the data, we just use the kernel function to compute the inner product in the projection space
  - we are then free to use $k\left(\mathbf{x}_{n}, \mathbf{x}_{m}\right)$ in our expression in place of any inner product in the original space

$$
\begin{array}{cl}\underset{\alpha}{\operatorname{argmax}} & \sum_{n=1}^{N} \alpha_{n}-\frac{1}{2} \sum_{n, m=1}^{N} \alpha_{n} \alpha_{m} t_{n} t_{m} k\left(\mathbf{x}_{n}, \mathbf{x}_{m}\right) \\ \text { subject to } & \sum_{n=1}^{N} \alpha_{n} t_{n}=0 \text { and } 0 \leq \alpha_{n} \leq C, \text { for all } n . \\ t_{\text {new }} & =\operatorname{sign}\left(\sum_{n=1}^{N} \alpha_{n} t_{n} k\left(\mathbf{x}_{n}, \mathbf{x}_{\text {new }}\right)+b\right) .\end{array}
$$


### Kernel Functions

- 3 most popular

$$
\begin{aligned} \text { linear } k\left(\mathbf{x}_{n}, \mathbf{x}_{m}\right) &=\mathbf{x}_{n}^{\top} \mathbf{x}_{m} \\ \text { Gaussian } k\left(\mathbf{x}_{n}, \mathbf{x}_{m}\right) &=\exp \left\{-\gamma\left(\mathbf{x}_{n}-\mathbf{x}_{m}\right)^{\top}\left(\mathbf{x}_{n}-\mathbf{x}_{m}\right)\right\} \\ \text { polynomial } k\left(\mathbf{x}_{n}, \mathbf{x}_{m}\right) &=\left(1+\mathbf{x}_{n}^{\top} \mathbf{x}_{m}\right)^{\gamma} \end{aligned}
$$

- The Gaussian and polynomial kernels are more flexible and both have additional parameters ($\gamma$) that must be set by the user (normally via cross-validation)

- **Note** that we can no longer compute **w**, since it would be given by $\sum_{n} \alpha_{n} t_{n} \phi\left(\mathbf{x}_{n}\right)$ but we don't necessarily know $\phi(\mathbf{x}_n)$ 
  - we only know $k\left(\mathbf{x}_{n}, \mathbf{x}_{m}\right)=\phi\left(\mathbf{x}_{n}\right)^{\top} \phi\left(\mathbf{x}_{m}\right)$
  - **instead** we can evaluate the predictions $\sum_{n} \alpha_{n} t_{n} k\left(\mathrm{x}_{n}, \mathrm{x}_{\mathrm{new}}\right)$ over a grid of $x_\text{new}$ values and then draw a contour using possible test data points in the original space

### Example - Gaussian Kernel

![](@attachment/Clipboard_2021-07-25-16-02-22.png)

- fairly good 

![](@attachment/Clipboard_2021-07-25-16-02-27.png)

- almost all become support vectors
- the actual classification performs worse , underfitting

![](@attachment/Clipboard_2021-07-25-16-02-32.png)

- every single data point is a support vector
- too complex, overfitting

![](@attachment/Clipboard_2021-07-25-16-02-37.png)

![](@attachment/Clipboard_2021-07-25-16-02-57.png)

### Choosing kernel function, parameters and $C$

- data dependent
- easy to overfit
- $C$ and $\beta$ are link
  - $C$ too high, overfitting
  - $C$ too low, underfitting
- Use cross-validation to search over $\beta$ and $C$
  - note that SVM is $N^3$ , hence for large $N$ cross-validation over many $C, \beta$ is infeasible
