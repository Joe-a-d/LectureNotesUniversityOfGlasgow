# Lecture 5 - Eigenproblems

![](@attachment/Clipboard_2021-05-25-03-02-37.png)

## Exponentiation

rem: we assume that the matrices below are squared

- Useful to apply the same operation to the same object, e.g rotate a matrix

```python

def pow(A,n):
	B = np.eye(A.shape[0]) # ID matrix
	for i in range(n):
		B = A @ B # matrix multiplication
	return B
```

## Stable Point & Eigenvectors

- After repeated application of a matrix to a vector takes us back to a stable state. The resulting vector represents the *eigenvector* , i.e where you end up on average.
	- These eigenvectors are not rotated when a matrix is applied to them, but simply scaled.
	- The scaling factors are called *eigenvalues*

$$Ax = \lambda x \text{ , where $\lambda$ is the eigenvalue}$$

We can find $\lambda$ by dividing the vector $Ax$ element-wise by $x$

```python
ratio = (A @ power) / power # power is just the eigenvector returned by power_iterate below
eigenvalue = ratio[0][0] # all els of ratio are the same
```
### Finding the leading eigenvector

If we compute $X_n$ which represents applying $A^n$ to some column vector $x_0$ then this will generally either explode in value or collapse to 0. We can fix this problem by *normalizing* the resulting vector after each application of the matrix

$$x_n = \frac{Ax_{n-1}}{\|Ax_{n-1}\|}$$

rem: this algorithm is called *power iteration*

```python
def power_iterate(A, x, n):
	for i in range(n):
		x = a @ x 
		x = x / np.linalg.norm(x, np.inf) # normalize x using the L inf
	return x / np.linalg.norm(x, 2) # finally, divide by the L2  
```

#### Using Numpy

```python
evals, evecs = np.linalg.eig(A)
```

rem : Unlike the method before, for an $n \times n$ matrix we'll get $n$ eigenvalues and eigenvectors, instead of just the leading one

### Eigendecomposition

- decomposition of a matrix into matrices composed of its eigenvectors and eigenvalues

- numerical unstable due to rounding errors, which means that the smallest eigenvectors are not completely orthogonal
	- `np.linalg.eig` is often sufficient, but for a more stable algorithm use `np.linalg.eigh`

**Eigenspectrum**

- the set of absolute eigenvalues ordered by magnitude

- it ranks the eigenvalues and vectors in order of importance, which is useful for finding simplified versions of matrices


#### Principal Component Analysis & Dimensionality Reduction


rem : one of the primary uses of eigendecompistion in data science

recall that the cov matrix, which represents the spread of data, can be represented as an ellipse which covers some portion of data

-  the eigenvectors of the cov matrix, scaled by their eigenvalues, form the **principal components** of the ellipse, i.e the tell us the direction in which the data varies most.
  - principal component 1 - longest one, where data varies the most
  - principal component 2 - orthogonal to 1

- for any dataset we can reduce it down to some representation in terms of this primary representations, and when we have data which has correlation we can use it to find an optimal rotation from which we can view it
  - by rotating it using the PC1 as the direction we have as much data points as possible in a single view, i.e we get the lines that capture most information of the data

motivation : Taking a high dimensional data, running the two most important directions of variation and then projecting down onto that to get a simplified representation that you can for example, see with your eyes is one of the most elementary techniques in dimensional reduction

#### Matrix Properties from Eigendecomposition

- Trace
- Determinant
- positive Definite Matrix : $\lambda_i > 0$
- positive Semi-Definite Matrix : $\lambda_i < 0$

## INSERT SUMMARY

--- 
RESOURCES

https://betterexplained.com/articles/matrix-multiplication/
http://nicolas-hug.com/blog/matrix_facto_1
https://blog.statsbot.co/singular-value-decomposition-tutorial-52c695315254

