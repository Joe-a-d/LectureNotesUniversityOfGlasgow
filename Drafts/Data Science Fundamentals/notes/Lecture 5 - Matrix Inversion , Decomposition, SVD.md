# Lecture 5 - Matrix Inversion , Decomposition, SVD

## Matrix Inversion

- defined for squared matrices white det ≠ 0

- `np.linalg.inv`

- because inverting involves a lot of floating point operations it is not always possible to calculate an inverse directly. But there are a few special cases where this can easily be done

### INSERT SPECIAL CASES

rem : avoid inversing sparse matrices, because they will almost always not be sparse

### Applications

- approximate solutions for linear systems
	- iterative methods
	- algo finds $x$ that minimise $\|A \mathbf{x}-\mathbf{y}\|_{2}^{2}$

rem : no need to create an inversion, constraint the problem from all possible $y$ to the specific $y$ seen in the problem


## Singular Value Decomposition

- general approach to decomposing **any** matrix into 3 separate components

$$A=U \Sigma V^{T} \\

\begin{array}{l}A \text { is any } m \times n \text { mactix, } \\ U \text { is } a \text { square unitary } m \times m \text { matrix, whose columns contain the left singular vectors. } \\ V \text { is an square unitary } n \times n \text { matrix, whose columns contain the right singular vectors. } \\ \Sigma \text { is a diagonal } m \times n \text { matrix, whose diagonal contains the singular values. }\end{array}$$

- $U, V$ are orthogonal and represent pure rotations
- $\Sigma$ is diagonal and represents a pure scalling

- `np.linalg.svd`

### Relation to Eigendecomposition

SVD is the same as:

- taking the eigenvectors of $A^TA$ to get $U$
- taking the $\sqrt{\left|\lambda_i\right|}$ of $A^TA$ to get $\Sigma_{i}=\sqrt{\left|\lambda_i\right|}$
- taking the eigenvector of $AA^T$ to get $V^T$

rem : svd is more stable then using eigendecomposition

### Ops using SVD

- ignore $U,V$ and apply the function to the singular values elementwise

#### Fractional Powers

$$A^n = V\Sigma^nU^T$$

```python
def powm(A,n):
	u, sigma, vt = np.linalg.svd(A)
	sigma_n = np.diag(sigma**n)
	return u @ sigma_n @ vt
```

#### Inversion

$$A^{-1} = V\Sigma^{-1}U^T$$

#### Pseudo-Inverse

- approximation of a non-squared matrix inverse
- equivalent to the process above
   - make sure that $\Sigma$ has the right shape (zero pad it)  
- `np.align.pinv` (automatic padding)

#### Fitting planes using the PSI

- Fit a line/plane to a collection if data points, even when we have many more points than the number of dimensions required to specify the line/plane.
	- this is called an *overdetermined* system, where we have more inputs than outputs

- Here if for a dataset consisting of $x,y$ values we want to predict any given $y$ we can use the formula $Y = AX$ where the equation of the fitting line/plane is represented by $A$ and $X,Y$ represent vectors of the datapoints

![](https://cdn.mathpix.com/snip/images/MgnbtcJhKGQfR9bgrDsMnJxwdouWxUXq9cpIsa79XEY.original.fullsize.png)

### Rank

- full rank : non-singular, the number of non-zero singular values == size(A)
- deficient rank : singular 
- low rank : the number of non-zero singular values <<< size(A)

### Condition Number

ratio of the largest singular value to the smallest

- only defined for full rank
- measures how sensitive inversion of a matrix is to small changes
	- well-conditioned : small cond number, unlikely to cause numerical issues
	- ill-conditioned 

#### Relation to Singularity

Rank and cond numbers extend the concept of singularity

- we can think of rank as measuring how many dimensions are lost in the transform
- cond number measures how close a non-singular matrix is to being singular

![](@attachment/Clipboard_2020-10-27-21-24-09.png)

### Applying decompositions - Whitening

- whitening removes all linear correlations within a dataset, it is used as a *normalizing step* used to *standardize* data before analysis

$$\begin{array}{l}\qquad X^{\mathrm{w}}=(X-\mu) \Sigma^{-1 / 2} \\ \text { where } \mu \text { is the mean vector, i.e. a row vector containing the mean of each column in } X, \text { and } \Sigma \\ \text { is the covariance matrix (not the matrix of singular values). }\end{array}$$

![](@attachment/Clipboard_2020-10-27-21-34-13.png)