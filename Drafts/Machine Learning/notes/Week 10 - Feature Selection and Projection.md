# Week 10 - Feature Selection and Projection

***
**Lecture 12**
***

# Intro

![](@attachment/Clipboard_2021-07-25-22-49-16.png)

- In general, the number of parameters will increase with the number of features
  - fitting lots of parameters is hard
  - it's useful to reduce the number of features
    - use a **subset** of the originals
      - can use some scoring function on each feature for some values from objects in both classes (see slides)
        - $s=\frac{\left|\mu_{1}-\mu_{0}\right|}{\sigma_{0}^{2}+\sigma_{1}^{2}}$
        - select $S$ features with highest scores using CV
    - make synthetic ones by **combining** existing ones
      - cluster the features (revert the clustering problem)
        - e.g. if using K-means, the new features will be the $K$ mean vectors
      - project/combine
        - reduce the number of features by projecting into a lower dimensional space; making linear combinations of the original ones

- the process of transforming a $M$-dimensional representation of an object $\mathbf{y}_n$ into a $D$-dimensional representation $\mathbf{x_n}$ is known as **projection**
  - we aim to retain as much of the "interesting" structure in our data as possible
  - but what's interesting? in the "hand example" below we can see that `a` is a much better projection of the object "hand", however in this case we know what a hand should look like, while in general we will not be aware of the structure in the original representation and so cannot use this to optimise our projection

![](@attachment/Clipboard_2021-07-25-22-53-40.png)

![](@attachment/Clipboard_2021-07-25-23-14-54.png)

### Variance as a proxy for interest

- Each line gives a different one-dimensional representation of the two-dimensional data

![](@attachment/Clipboard_2021-07-25-22-59-13.png)

- We can compute the variance of the data in each one-dimensional space as 
  - as we can see it is higher for projection A than for B

$$
\sigma^{2}=\frac{1}{N} \sum_{n=1}^{N}\left(x_{n}-\mu_{x}\right)^{2}
$$

> In general, given no other information, if we must project into one-dimension we should choose the one with the higher variance

- cluster structure is an interesting property to preserve
  - the higher variance of the data projection in (b) A (2x more) arises to the cluster structure, all points are a large distance from the mean
  - choosing the projection with higher variance is likely to preserve this structure

> Variance is seen as a good quantity to maximise when deciding on projection directions

- A popular projection technique, Principal Component Analysis (PCA), aims to maximise the variance

# PCA

- PCA is a method for choosing $\mathbf{W}$
  - very popular in ML for visualisation and feature selection
  - each of the projected dimensions is a linear combination of the original dimensions

- If we are projecting from $M$ to $D$ dimensions
  - define $D$ vectors $\mathbf{w}_d$ each $M$-dimensional
  - the $d$th element of the projection $x_{nd}$ is computed as $x_{n d}=\mathbf{w}_{d}^{\top} \mathbf{y}_{n}$
    - where $\mathbf{x}_{n}=\left[x_{n 1}, \ldots, x_{n D}\right]^{\top}$

- **the learning task** is to choose how many dimensions we want to project into $D$ and then pick a projection vector $\mathbf{w}_d$ for each
  - the **metric** PCA uses to compare the possible choices is **variance** in the projected space
    - i.e. $\mathbf{w}_1$ will correspond to the projection that makes the variance in the $x_{n1}$ as high as possible
  - each subsequent dimension must be orthogonal to the others
    - $\mathbf{w}_{i}^{\top} \mathbf{w}_{j}=0, \forall j \neq i$

> REM : if we set $D = M$ performing PCA amounts to rotating a rotation of the original data, without any loss of information

- let $\mathbf{z}_m = \mathbf{Xw}_m$ represent one of the new dimensions
  - i.e. one of the columns of our $Z$ projected space - the $M$-dimensional representation of our $N$ objects
  - then as mentioned above, our aim with PCA is to maximise the variance

  $$
\frac{1}{N} \sum_{n=1}^{N}\left(z_{m n}-\mu_{m}\right)^{2}, \quad \mu_{m}=\frac{1}{N} \sum_{n=1}^{N} z_{m n}
$$

- **N.B** , the analytic solution to finding the **w**s is beyond the scope

### Visualisation 

![](@attachment/Clipboard_2021-07-25-23-27-45.png)

![](@attachment/Clipboard_2021-07-25-23-27-57.png)

![](@attachment/Clipboard_2021-07-25-23-28-06.png)

### Limitations

- it assumes that the data are real valued
- it assumes that there are no missing values in the data

## Summary

![](@attachment/Clipboard_2021-07-25-23-29-13.png)

- Why might PCA do worse than the scoring method?
  - it works for gaussian shaped distributions, but otherwise the linear projections will not capture the variance in the data well

# ICA - Cocktail Party Problem

- very little emphasis in lecture; not covered in textbook; see video during revision