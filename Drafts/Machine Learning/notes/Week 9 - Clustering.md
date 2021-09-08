# Week 9 - Clustering

***
**Lecture 11** 
***

![](@attachment/Clipboard_2021-07-25-16-09-07.png)

![](@attachment/Clipboard_2021-07-25-16-18-14.png)

# Unsupervised Learning - Clustering

- we've only seen problems where we are given the training data $x_n$ and their associated labels $t_n$
- unsupervised learning is required when we do not have access to labels

- **Clustering** is a ML technique whose aim is to create grouping of objects such that objects within a group are much more similar than those outside the group
  - several different metrics of similarity

# K-means

- in K-means a cluster is defined as a representative point, just like one of the data points
  - this point is defined as **the mean of the objects** that are assigned to the cluster

- Let
  - $\mu_k$ define the mean point of the $k$th cluster
  - $z_{nk}$ define the binary indicator variable , i.e. 1 if object $n$ is assigned to cluster $k$ and 0 otherwise

- Then

$$
\mu_{k}=\frac{\sum_{n} z_{n k} \mathbf{x}_{n}}{\sum_{n} z_{n k}}
$$

![](@attachment/Clipboard_2021-07-25-16-30-35.png)

- the distance metric used is usually Euclidean

$$
d_{n k}=\left(\mathbf{x}_{n}-\mu_{k}\right)^{\top}\left(\mathbf{x}_{n}-\mu_{k}\right)
$$

- Note that we defined the cluster point in terms of the data points, and we have also defined our decision boundary for the data points in terms of their distance to the cluster point, i.e we have a circular definition
  - we cannot compute the assignments without the clusters, but we cannot compute the clusters without the assignments

- In order to overcome this problem , the algorithm relies on an initial random state
### Algo

1. Choose initial random values for $\mu_1,\cdots,\mu_k$
1. For each $x_n$ , find the closest cluster mean, i.e. the $k$ that minimises $\left(\mathbf{x}_{n}-\boldsymbol{\mu}_{k}\right)^{\top}\left(\mathbf{x}_{n}-\boldsymbol{\mu}_{k}\right)$ , and set $z_{nk}=1 \ ,\   z_{nj}=0 \ \forall \ j \neq k$ 
1. Update each $\mu_k$ using the equation defined above
1. Repeat from `2` until the algorithm converges (the assignments don't change)

![](@attachment/Clipboard_2021-07-25-16-39-15.png)

- the algo is guaranteed to converge to a local minimum, but there's no guarantee that a global solution is found
  - dependent on the initial guesses of the cluster means
  - this can be **partially overcome** by running the algorithm from several random starting points and use the solution that gives the lowest value of the ***total** distance between the objects and their respective cluster centres*
  $$D=\sum_{n=1}^{N} \sum_{k=1}^{K} z_{n k}\left(\mathbf{x}_{n}-\boldsymbol{\mu}_{k}\right)^{\top}\left(\mathbf{x}_{n}-\boldsymbol{\mu}_{k}\right)$$

## Choosing $K$

- in much the same way that likelihood turned out to be a poor model selection criterion (recall that it monotonically increases as models become more complex) D is no good either.
  - note below how $D$ decreases as $K$ is increased
  - as $K$ increases large clusters will be broken down
  - the smaller each cluster, the closer each point will get to its cluster mean, reducing its contribution to D

![](@attachment/Clipboard_2021-07-25-16-46-42.png)

- no straightforward solution, but in order to overcome it we can look at the semantics of the data, at our final end goal
  - e.g. if our goal is to cluster customers in a recommender system, then we can choose the number of clusters which gives the best recommendation on some validation data

## Limitations

- K-means fails when the data has a clear clusture structure, which our model cannot capture using the similarity metric of distance
  - in the example on the left the means of both circles are in the same place
  - on the right, the stretching of the clusters means that objects at the top of the right hand cluster are closer to the mean of the left hand one

![](@attachment/Clipboard_2021-07-25-16-56-07.png)

- we can overcome this problem by *kernelising* the algo

# Kernelised K-means

- recall that as long as our data objects $\mathbf{x_n}$ only appear as inner products $\mathbf{x_i}^T\mathbf{x_j}$ , the algorithm can be kernelised without any significant additional cost
  - we'll kernelise the distance function

- Let $N_{k}=\sum_{n=1}^{N} z_{n k}$ , let's plugin our expression for the cluster mean into our expression for computing the distance

$$
d_{n k}=\left(\mathbf{x}_{n}-\frac{1}{N_{k}} \sum_{m=1}^{N} z_{m k} \mathbf{x}_{m}\right)^{\top}\left(\mathbf{x}_{n}-\frac{1}{N_{k}} \sum_{r=1}^{N} z_{r k} \mathbf{x}_{r}\right)
$$

- If we multiply out the above expression and kernelise it (replace the inner products by a kernel function) we get our new kernelised distance function
  - which is now **purely a function of the data and the current assignments**
  - the cluster means do not appear

$$
d_{n k}=K\left(\mathbf{x}_{n}, \mathbf{x}_{n}\right)-\frac{2}{N_{k}} \sum_{m=1}^{N} z_{m k} K\left(\mathbf{x}_{n}, \mathbf{x}_{m}\right)+\frac{1}{N_{k}^{2}} \sum_{m=1}^{N} \sum_{r=1}^{N} z_{m k} z_{r k} K\left(\mathbf{x}_{m}, \mathbf{x}_{r}\right)
$$

- similar to what we've seen in kernelised SVM, where we couldn't get back the **w**, we cannot compute the cluster mean in the transformed space since data objects in our new expression for the mean appear on their own and not as inner products 

$$
\boldsymbol{\mu}_{k}=\frac{\sum_{n=1}^{N} z_{n k} \phi\left(\mathbf{x}_{n}\right)}{\sum_{n=1}^{N} z_{n k}}
$$

> In general, for most kernel functions, we cannot compute the transformation $\mathbf{x}_{n} \underset{\tau}{\rightarrow} \phi\left(\mathbf{x}_{n}\right)$ , we can only compute inner products in the transformed space $\phi\left(\mathbf{x}_{n}\right)^{\top} \phi\left(\mathbf{x}_{m}\right)$

### Algo

- Hence, our new algorithm will now compute the distance 

1. For each $n$, randomly initialise $z_{nk}$ 
1. Compute $d_{n1},\cdots,d_{nK}$ for each object using our kernelised distance equation
1. Assign each object to the cluster with lowest $d_{nk}$
1. Repeat from `2` until no assignments change

- Note that since we do not have access to the mean clusters, our init step relies on object-cluster assignments $z_{nk}$. We could do this
  - completely randomly - for each $n$ set one $z_{nk}$ to 1 and all of the others ($z_{nl}, l \neq k$) to 0 
    - given that we know K-means to be sensitive to initial conditions, it might be better to be more careful.
  - run standard K-means and use the values of $z_{nk}$ at convergence.
    - it has the **advantage** that we can be sure that objects within the same cluster will be reasonably close to one another (something that we cannot guarantee if we set them randomly) 
  - assign $N - K + 1$ objects to cluster 1 and the remaining $K - 1$ objects to their own individual clusters. 
  
- The performance of each iteration scheme will depend on the particular characteristics of the data being clustered.

#### Summary

- more flexible
- aditional parameters need to be set because fo the kernel
- very sensitive to initial conditions - lots of local optima

#### Example

- initialised by assigning all but one object to the "circle" cluster and the rest to the "square"
- Gaussian kernel with $\gamma=1$

![](@attachment/Clipboard_2021-07-25-17-26-54.png)

- as the algo progresses the smaller cluster grows to take up the central circle
- at convergence we see that the structure of the data is captured

## Summary

- Objective function
  - average distance of the data point and its assigned clusters
  - or the average of the total distance

$$
\sum_{n} \sum_{k} z_{n k}\left(\mathrm{x}_{n}-\mu_{k}\right)^{\top}\left(\mathrm{x}_{n}-\mu_{k}\right)
$$


![](@attachment/Clipboard_2021-07-25-17-34-16.png)

- Note that the OF is not a unimodal function of the unknown parameter $\mu_k$, therefore we might have multiple minimums for the loss function
  - this is also **why it is very sensitive to where you start**
  - there could be different combinations of the positions of $\mu$s , which would have the same final loss
  - the image below compares the loss function in the linear regression case with a possible loss function for K-means

![](@attachment/Clipboard_2021-07-25-17-40-54.png)

# Mixture Models

- In the "Limitations" section above we've seen a dataset where the K-means failed due to the data being stretched in such a way that our definition of cluster was too crude to capture its complexity
  - in particular, the problem was that the characteristics of the stretched clusters could not be represented by a single point and the squared distance, we also needed to **incorporate the notion of shape**

- Statistical mixtures allow us to do this by representing each cluster as a probability density

## Generative

- As we've discussed in our lectures about adding noise to our linear model to make it more real realistic, we saw that we can combine our simpler models with a random variable in order to generate syntethic data which was qualitatively similar to that of the process originating the real data.
  - our aim here is similar, we want to come up with some pdf(s) which are able to generate data similar to the real data
  - the key difference here being that we'll usually be sampling from more than one pdf, given the complexity of the structure of the data

- take the below example
  - it looks like there are 3 distinct regions
  - no single pdf can produce that complex strucure
  - **but** it is fairly simple to come up with 3 different pdfs which are able to generate data for each of their own separate regions

![](@attachment/Clipboard_2021-07-25-20-07-31.png)

- We'll assume that each $\mathbf{x}_n$ comes from one of $K$ different distributions
- To generate $\mathbf{X}$ , for each $n$
  1. Pick one of the $K$ components
  1. Sample $\mathbf{x_n}$ from this distribution

- Once we have $X$
  - we'll define the parameters of all those distributions as $\Delta$
  - in order to learn those parameters we'll need to do some reverse-engineering, i.e. we are going to learn them from the observed $\mathbf{X}$ matrix
  - we'll do this via maximum likelihood estimation

### Likelihood

- PDF
  - $\Delta_k$ denotes the parameters of the $k$th density
  - $\Delta = \{\Delta_1,\cdots,\Delta_k\}$ denotes the collection of the parameters of all of the mixture components 

$$
p\left(\mathbf{x}_{n} \mid z_{n k}=1, \Delta_{k}\right)
$$

- We want the likelihood that links the observed data with the unobserved parameter $\Delta$
  - we want $p(\mathbf{X} \mid \Delta)$
  - we'll start by factorising
  
$$
p(\mathbf{X} \mid \Delta)=\prod_{i=1}^{N} p\left(\mathbf{x}_{n} \mid \Delta\right)
$$

- Then we marginalise the assignment variable $z_{nk}$ out by integrating (summing) over all possible $z$s
  - we can also factorise the joint probability further by multiplying by the probability that the $n$th data point belongs to our $k$th distribution , i.e $p\left(z_{n k}=1 \mid \Delta\right)$ conditioned on the parameters

$$
\begin{aligned} p(\mathbf{X} \mid \Delta) &=\prod_{i=1}^{N} \sum_{k=1}^{K} p\left(\mathbf{x}_{n}, z_{n k}=1 \mid \Delta\right) \\ &=\prod_{i=1}^{N} \sum_{k=1}^{K} p\left(\mathbf{x}_{n} \mid z_{n k}=1, \Delta_{k}\right) p\left(z_{n k}=1 \mid \Delta\right) \end{aligned}
$$

### Finding the parameters - $\Delta$

- We want to use the iterative maximum algo, *Expectation-Maximisation (EM)* algorithm in order to find the parameters
  - Let $p(z_{nk}=1) = \pi$

$$
L=\log p(\mathbf{X} \mid \Delta, \pi)=\sum_{n=1}^{N} \log \sum_{k=1}^{K} \pi_{k} p\left(\mathbf{x}_{n} \mid \mu_{k}, \mathbf{\Sigma}_{k}\right)
$$

- The summation inside makes finding the optimal parameter values $\mu_k, \Sigma_k, \pi$ difficult
  - the EM algo overcomes this by deriving a *lower bound* on the likelihood (a function of $\mathbf{X}, \Delta, \pi$) that is *always* lower than or equal to $L$
  - instead of maximising $L$ directly, we maximise the lower bound


#### Jensen's Inequality

- Jensen's inequality relates logs of expectations and expectations of logs

$$
\log \mathbf{E}_{p(z)}\{f(z)\} \geq \mathbf{E}_{p(z)}\{\log f(z)\}
$$

- We can use this fact in order to lower bound our likelihood, as long as we can make the RHS of the likelihood equation look like the log of an expectation
  - we multiply and divide the expression inside the summation over $k$ by a new variable $q_{nk}$

  $$
L=\sum_{n=1}^{N} \log \sum_{k=1}^{K} \pi_{k} p\left(\mathbf{x}_{n} \mid \boldsymbol{\mu}_{k}, \mathbf{\Sigma}_{k}\right) \frac{q_{n k}}{q_{n k}}
$$

- We then restrict $q_{nk}$, so that it represents some probability distribution over teh $K$ components of the $n$th object
  - $q_{nk} > 0$
  - $\sum_{k=1}^{K} q_{n k}=1$

- Doing this allow us to rewrite the expression above as an expectation w.r.t $q_{nk}$

$$
\begin{aligned} L &=\sum_{n=1}^{N} \log \sum_{k=1}^{K} q_{n k} \frac{\pi_{k} p\left(\mathbf{x}_{n} \mid \boldsymbol{\mu}_{k}, \mathbf{\Sigma}_{k}\right)}{q_{n k}} \\ &=\sum_{n=1}^{N} \log \mathbf{E}_{q_{n k}}\left\{\frac{\pi_{k} p\left(\mathbf{x}_{n} \mid \boldsymbol{\mu}_{k}, \mathbf{\Sigma}_{k}\right)}{q_{n k}}\right\} \end{aligned}
$$

- We can now apply Jensen's inequality

$$
L=\sum_{n=1}^{N} \log \mathbf{E}_{q_{n k}}\left\{\frac{\pi_{k} p\left(\mathbf{x}_{n} \mid \mu_{k}, \mathbf{\Sigma}_{k}\right)}{q_{n k}}\right\} \geq \sum_{n=1}^{N} \mathbf{E}_{q_{n k}}\left\{\log \frac{\pi_{k} p\left(\mathbf{x}_{n} \mid \boldsymbol{\mu}_{k}, \mathbf{\Sigma}_{k}\right)}{q_{n k}}\right\}
$$

- We'll now denote the RHS of the above expression , the bound, by $B$ and we'll expand it to make it easier to work with

$$
\begin{aligned} \mathcal{B} &=\sum_{n=1}^{N} \mathbf{E}_{q_{n k}}\left\{\log \frac{\pi_{k} p\left(\mathbf{x}_{n} \mid \mu_{k}, \mathbf{\Sigma}_{k}\right)}{q_{n k}}\right\} \\ &=\sum_{n=1}^{N} \sum_{k=1}^{K} q_{n k} \log \left(\frac{\pi_{k} p\left(\mathbf{x}_{n} \mid \boldsymbol{\mu}_{k}, \boldsymbol{\Sigma}_{k}\right)}{q_{n k}}\right) \\ &=\sum_{n=1}^{N} \sum_{k=1}^{K} q_{n k} \log \pi_{k}+\sum_{n=1}^{N} \sum_{k=1}^{K} q_{n k} \log p\left(\mathbf{x}_{n} \mid \mu_{k}, \mathbf{\Sigma}_{k}\right)-\sum_{n=1}^{N} \sum_{k=1}^{K} q_{n k} \log q_{n k} \end{aligned}
$$

### Maximising 

- as we've noted before, maximising the bound in order to find the values of $q_{n k}, \pi, \mu_{k}, \Sigma_{k}$ will also mean that we've found the local maxima of the log-likelihood $L$
- the EM algorithm produced an iterative procedure which involves updating each of the quantities in the model until convergence
  - in order to obtain each update we'll follow the general MLE procedure of taking the partial derivative (of $B$ in this case) w.r.t the relevant parameter, set it to zero and solve

> derivations from 218

- The four update equations are 

$$
\begin{aligned} \pi_{k} &=\frac{1}{N} \sum_{n=1}^{N} q_{n k} \\ \mu_{k} &=\frac{\sum_{n=1}^{N} q_{n k} \mathbf{x}_{n}}{\sum_{n=1}^{N} q_{n k}} \\ \Sigma_{k} &=\frac{\sum_{n=1}^{N} q_{n k}\left(\mathbf{x}_{n}-\mu_{k}\right)\left(\mathbf{x}_{n}-\mu_{k}\right)^{\top}}{\sum_{n=1}^{N} q_{n k}} \\ q_{n k} &=\frac{\pi_{k} p\left(\mathbf{x}_{n} \mid \mu_{k}, \Sigma_{k}\right)}{\sum_{j=1}^{K} \pi_{j} p\left(\mathbf{x}_{n} \mid \mu_{j}, \Sigma_{j}\right)} \end{aligned}
$$

- Note that $\pi_k, \mu_k, \Sigma_k$ rely heavily on $q_{nk}$
  - $\pi_k$ is the mean value of $q_{nk}$ for a particular $k$
  - $\mu_k$ is the average of the data points weighted by $q_{nk}$
  - $\Sigma_k$ is a weighted covariance

#### What's $q_{nk}$

- Note how similar to the Bayes' rule , the equation for updating $q_{nk}$ looks like
  - we have a prior $\pi_k$
  - likelihood $p\left(\mathbf{x}_{n} \mid \boldsymbol{\mu}_{k}, \mathbf{\Sigma}_{k}\right)$
  - normalising constant
- We can interpret it as computing a posterior probability of object $n$ belonging to class $k$
  - it looks very similar to the Bayesian classification version of Bayes' rule
  - for particular values of the model parameters it tells us the posterior probability of object $n$ belonging to component $k$

  $$
p\left(z_{n k}=1 \mid \mathbf{x}_{n}, \pi, \Delta\right)=\frac{p\left(z_{n k}=1 \mid \pi_{k}\right) p\left(\mathbf{x}_{n} \mid \mu_{k}, \mathbf{\Sigma}_{k}\right)}{\sum_{j=1}^{K} p\left(z_{n j}=1 \mid \pi_{j}\right) p\left(\mathbf{x}_{n} \mid \mu_{j}, \Sigma_{j}\right)}=q_{n k}
$$

- Reframing the equations for the other updates in Bayesian terms
  - $\pi_k$ is the average of all posterior probabilities belonging to class $k$, i.e. the expected proprotion of the data belonging to $k$
  - $\mu_k$ and $\Sigma_k$ are the mean and variance of objects where each object is weighted by the posterior probability of belonging to component $k$
    - such that objects that have a high probability of belonging to component $k$ have a strong influence on the mean and variance of component $k$.

### Tying it back to the updates

- we can split the four updates into two sets
- the **first three** make up the **M**aximisiation phase of the EM algo
  - consist of updating our current estimates of the model components $\pi, \mu_{k}, \Sigma_{k}$ with $q_{n k}$ , the assignment probabilities, **fixed**
  - the bound is maximised conditioned on the values of $q_{nk}$
- the **update of $q_{nk}$** represents the second step of the algo - **E**xpectation step
  - reflects the new values of the model parameters
  - it actually involves computing the expected value of the unknown assignments

- this procedure is very similar to K-means
  - updating $q_{nk}$ is similar to updating $z_{nk}$
  - updating the other params is similar to updating $\mu_k$
- key differences
  - we are computing posterior probabilities of cluster memberships rather than making hard assignments
  - we are inferring the component covariances

## Example - Gaussian Mixture Model

- Assume that the component distributions are Gaussians with diagonal covariance

$$
p\left(\mathbf{x}_{n} \mid z_{n k}=1, \mu_{k}, \sigma_{k}^{2}\right)=\mathcal{N}\left(\mu, \sigma^{2} \mathbf{I}\right)
$$

### Update for $\pi_k$

$$
\sum_{n, k} q_{n k} \pi_{k}
$$

- We have a constraint , so we add a Lagrangian
  - constraint : $\sum_{k} \pi_{k}=1$

$$
\sum_{n, k} q_{n k} \log \pi_{k}-\lambda\left(\sum_{k} \pi_{k}-1\right)
$$

- We re-arrange, sum both sides over $k$ to find $\lambda$ and then substitute and re-arrange

$$
\pi_{k}=\frac{\sum_{n} q_{n k}}{\sum_{n, j} q_{n j}}=\frac{1}{N} \sum_{k} q_{n k}
$$

### Update for $q_{nk}$

![](@attachment/Clipboard_2021-07-25-22-35-35.png)

### Updates for $\mu_k$ and $\sigma^2_k$

![](@attachment/Clipboard_2021-07-25-22-35-55.png)

## Mixture model optimisation - algorithm

![](@attachment/Clipboard_2021-07-25-22-36-16.png)

![](@attachment/Clipboard_2021-07-25-22-37-04.png)

## Mixture Model - Clustering

- Often we are not interested in the Gaussians themselves but the assignments of objects to components - the clustering
  - provided by the values of $q_{nk}$ - the posterior probability of objects belonging to components
- We can stick with probabilities or assign each $\mathbf{x_n}$ to it's most likely component
  - hard assignments are not always sensible since we throw away useful information about the relationship object $n$ has with the other components
  - e.g. , say that you have $q_{n 1}=0.53, \quad q_{n 2}=0.45, \quad q_{n 3}=0.02$
    - a hard assignment would assign it to component 1, but is component 2 really irrelevant?

## Mixture Model - Issues

- see slides and page 226 onwards

- essentially
  - likelihood always increases with $K$
  - $\sigma^2_k$ decreases
  - use cross-validation