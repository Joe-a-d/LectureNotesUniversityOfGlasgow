# Lecture 4 - Vector Spaces and Matrices

![](@attachment/Clipboard_2021-05-24-04-13-19.png)

## Vector Spaces

 - for this course we define vectors as ordered tuples of real numbers
 - we define a vector space $R^n$ as the set of all possible vectors of length $n \in R$
  - we can think of a point in an $n^{th}$ dimension space as being formed by scaling and adding up the orthogonal **basis vectors** representing that dimension
    - e.g. in $R^3$ every point can be described by the vectors `[1,0,0] , [0,1,0], [0,0,1]`
    - the point `[5,7,3]` = `5 * [1,0,0] + 7 * [0,1,0] + 3 * [0,0,1]`
 - ops within a space : *scalar multiplication, addition, inner product, norm*

![](@attachment/Clipboard_2021-05-24-04-26-41.png)

### Use of Vectors

 - vectors are the *lingua franca* of data because they can be:
 - composed (addition)
 - compared (norms/inner product)
 - weighted (scaling)
 - operated on efficiently (vectorised ops)

### Basic Ops

 - *Linear Interpolation* finding a new vector between two existing ones as some distance among the line between them. If the parameter $a$ varies between [0-1] we move from $x$ to $y$ in a smooth straight line

 $$lerp(x,y,a) = (1-a)x + ay , 0 < a < 1$$

 ![](@attachment/Clipboard_2021-05-24-04-33-57.png)

 - l2 norm (Euclidean norm)
  - $\(\|\mathbf{x}\|_{2}=\sqrt{x_{0}^{2}+x_{1}^{2}+x_{2}^{2}+\cdots+x_{n}^{2}}\)$
  - `np.linalg.norm()`
- lp norms , a.k.a Minkowski norms
  - generalise Euclidean distances
  - $\(\|\mathbf{x}\|_{p}=\left(\sum_{i} x_{i}^{p}\right)^{\frac{1}{p}}\)$

  ![](@attachment/Clipboard_2021-05-24-04-36-54.png)

  ![](@attachment/Clipboard_2021-05-24-04-37-19.png)

 - normalisation
  - for euclidean can be done by scalling the vector $x$ by $\frac{1}{\|\mathbf{x}\|_{2}}$
  - get the vector in terms of unit vector, i.e. all with the same direction as the original vector but with norm 1

  ![](@attachment/Clipboard_2021-05-24-04-39-58.png)

 - inner product
  - measures the angle between two real vectors
  - related to the cosine distance $\cos \theta=\frac{\mathbf{x} \bullet \mathbf{y}}{\|\mathbf{x}\|\|\mathbf{y}\|}$
  - for real-valued vectors in $R^N$, the dot product is simply the sum of the elementwise products $\mathbf{x} \bullet \mathbf{y}=\sum_{i} x_{i} y_{i}$
  - a useful operator for comparing vectors that might be of very different magnitudes
  - `np.dot()`

### Basic Vector Stats

 - *mean vector*
  - $\operatorname{mean}\left(\mathbf{x}_{1}, \mathbf{x}_{2}, \ldots, \mathbf{x}_{\mathbf{n}}\right)=\frac{1}{N} \sum_{i} \mathbf{x}_{\mathbf{i}}$
  - represents the *geometric centroid* of a set of vectors, it gives us an idea of the centre of mass of those vectors
  - *center a dataset* moving it so that there is no average offset, so that it is centred on the origin. Take the average of the data points then shift them so that the mean lies on the origin
    - common normalisation steps, to avoid initial bias


![](@attachment/Clipboard_2021-05-24-04-46-24.png)

 ### High-dimensional vector spaces

  - *curse of dimensionality* : algorithms which work well in lower d breakdown in higher d because generalisation gets harder *exponentially*
  - distances don't work well, take distance of random points and their distances will almost always be the same. Note the distribution below, in `150D` all points are between $[8,11]$ from each other and most of them are $10$ away
    - Linf , L1 or the cosine distance are less sensitive to high dimensional spaces
  
  ![](https://cdn.mathpix.com/snip/images/4LO4YYa6GIZGgzVMUJt54fRwYhS0xkN4kJjurr3_kHw.original.fullsize.png)

> REM see slides for more on paradoxes that arise , in particular on how there is essentially nothing on the interior of geometrical spaces, instead the vast majority of the mass lies on the outside/edges


## Matrices and Linear Ops

### Linear Maps

 - matrices represent *linear maps* as `2D` arrays of reals $R^{m \times n}$
  - vectors represent points in space
  - matrices represent ops which operate on those points

 - this operations are applied to vectors by multiplying them by a matrix

 $$Ax = f(x)$$

 - linearity just means that the operations of addition and scalar multiplication are preserved, intuitively you can think of this as straight lines being scaled and/or stretched without shifting the origin 

 - linear map is then a function $f$ from $R^m \to R^n$ 
  - if $m = n$ then we call that a *linear transform*
  - if $f(x) = f(f(x))$ then we call it a *linear projection* (e..g projecting points onto a plane)

$$
\begin{array}{c}f(\mathbf{x}+\mathbf{y})=f(\mathbf{x})+f(\mathbf{y})=A(\mathbf{x}+\mathbf{y})=A \mathbf{x}+A \mathbf{y} \\ f(c \mathbf{x})=c f(\mathbf{x})=A(c \mathbf{x})=c A \mathbf{x}\end{array}
$$

 #### Geometric Intuition

 - transforming a cube into a parallelotope in another space, with the origin staying fixed

 > REM : this is the *only* type of transform a matrix can apply
 
 ![](@attachment/Clipboard_2021-05-24-05-03-50.png)

 > REM : see slides for examples of 2D transforms

 #### Application to vectors

- all it does is form a wighted sum of the elements of the vector
  - linear combination of the components
  - take each element of a vector
  - multiply it by the corresponding column of matrix $A$
  - sum these columns together

- in numpy we use the `@` operator to apply matrix to vec `A @ x`

#### Multiplication

- $AB$ is equivalent to composing the linear functions they represent, outputting a matrix which represents that combined transformation
  - not commutative

$$
\text { If } C=A B \text { then } C_{i j}=\sum_{k} a_{i k} b_{k j}
$$

### Covariance Matrix

- Variance is the sum of squared differences of each element from the mean of the vector
  - gives us an idea of the spread of the data
  - the square root of this gives us the standard deviation, and is more often used because it is in the same units as the data

- Covariance matrix allow us to have a notion of the spread of the data in higher dimensions
  - compute the *covariance* of every dimension with every other dimension
  - average squared difference of each column from the average of every column
  - `np.cov()`


  $$
\begin{array}{c}\Sigma_{i j}=\frac{1}{N-1} \\ \sum_{k=1}^{N}\left(X_{k i}-\mu_{i}\right)\left(X_{k j}\right. \\ \left.-\mu_{j}\right)\end{array}
$$

#### Covariance Ellipses

- the cov matrix captures in particular correlations between dimensions. It can be seen as representing an **ellipse** (the error ellipse) that represents a dataset, and gives a very useful summary of the high-dimensional data
  - the mean vector represents the centre of the ellipse
  - the cov matrix represents the *shape* of the ellipse


