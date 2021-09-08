# Week 7 - Classification - Logistic Regression

***
**Lecture 9**
***

![](@attachment/Clipboard_2021-07-22-03-14-01.png)

![](@attachment/Clipboard_2021-07-22-03-21-20.png)

# Motivation

- In the Bayes' classifier we built a model of each class and then used the Bayes' rule
- **Alternatively** we can directly model our prediction as a function with some parameters **w**
  - $P\left(T_{\text {new }}=k \mid \mathrm{x}_{\text {new }}, \mathbf{X}, \mathbf{t}\right)=f\left(\mathbf{x}_{\text {new }} ; \mathbf{w}\right)$
  - **problem** our previous linear regression model $\mathbf{w}^T\mathbf{x}_{\text{new}}$ is unbounded so it can't be a probability
  - we can overcome this problem by normalising our function using another function $h()$ so that it gets squashed to lie between 0 and 1

### Sigmoid

- For logistic regression (binary) we use the *sigmoid function*

$$
P\left(T_{\text {new }}=1 \mid \mathbf{x}_{\text {new }}, \mathbf{w}\right)=h\left(\mathbf{w}^{\top} \mathbf{x}_{\text {new }}\right)=\frac{1}{1+\exp \left(-\mathbf{w}^{\top} \mathbf{x}_{\text {new }}\right)}
$$

![](@attachment/Clipboard_2021-07-21-13-17-59.png)

# Bayesian Logistic Regression

## Prior

- Choose a (Gaussian) prior

$$
p(\mathbf{w})=\prod_{d=1}^{D} \mathcal{N}\left(0, \sigma^{2}\right) .=\prod_{d=1}^{D} P\left(\omega_{d}\right)
$$

# Likelihood

- Define a likelihood
  - assuming independence

$$
p(\mathbf{t} \mid \mathbf{X}, \mathbf{w})=\prod_{n=1}^{N} p\left(t_{n} \mid \mathbf{x}_{n}, \mathbf{w}\right)
$$

- note that we have already define this, it's just our squashing function. In the case where $t_n$ is a binary variable indicating the class of the $n$th object
  - $t_n=1$ : $P\left(t_{n}=1 \mid \mathbf{x}_{n}, \mathbf{w}\right)=\frac{1}{1+\exp \left(-\mathbf{w}^{\top} \mathbf{x}_{n}\right)}=\lambda_{n}$
    - this expression gives us the probability that our RV $T_n=1$
  - $t_n=0$ : $P\left(t_{n}=0 \mid \mathbf{x}_{n}, \mathbf{w}\right)=1-P\left(t_{n}=1 \mid \mathbf{x}, \mathbf{w}\right)=1-\lambda_{\boldsymbol{n}}$
    - in order to compute the probability of the actual observations which can be 0, i.e "not 1"

- we are trying to perform a binary classification
- if we combine the two equations above, the expression below gives us the likelihood for all $n$ training points, which essentially switches the relevant term on and the other off
  - depending on the corresponding label $x_ n, t_n$ we are choosing between $\lambda_n$ and $1-\lambda_n$
  - if our parameter **w** is a good choice, i.e. if our predicted label 
    - $t_n=1$ , $\lambda_n$ should be close to 1
    - $t_n=0$, $1 - \lambda_n$ should be close to 1
    - This likelihood function will be high if the model assigns high probabilities for class 1 when we observe class 1 and high probabilities for class 0 when we observe class 0

$$
\begin{aligned} p(\mathbf{t} \mid \mathbf{X}, \mathbf{w}) 
&=\prod_{n=1}^{N} {\lambda_n}^t_n (1-\lambda_n)^{1-t_n} \\ &=\prod_{n=1}^{N} P\left(T_{n}=1 \mid \mathbf{x}_{n} \mathbf{w}\right)^{t_{n}} P\left(T_{n}=0 \mid \mathbf{x}_{n}, \mathbf{w}\right)^{1-t_{n}} \\ &=\prod_{n=1}^{N}\left(\frac{1}{1+\exp \left(-\mathbf{w}^{\top} \mathbf{x}_{n}\right)}\right)^{t_{n}}\left(\frac{\exp \left(-\mathbf{w}^{\top} \mathbf{x}_{n}\right)}{1+\exp \left(-\mathbf{w}^{\top} \mathbf{x}_{n}\right)}\right)^{1-t_{n}} \end{aligned}
$$

- 

# Posterior

- we can't compute it analytically given our restraints , i.e. the prior is not conjugate to the likelihood - **no prior is**
  - hence, we don't know the form of our normalising constant (denominator) **and** we can't compute the marginal likelihood

### Computing the Joint Probability

- we can compute our numerator, i.e. the unnormalised posterior
- we define
  -$g\left(\mathbf{w} ; \mathbf{X}, \mathbf{t}, \sigma^{2}\right)=p(\mathbf{t} \mid \mathbf{X}, \mathbf{w}) p\left(\mathbf{w} \mid \sigma^{2}\right)$
- which give us 3 possible paths for evaluating the expression
  1. Find the most likely value of $\mathbf{w} -$ a point estimate
      - not very Bayesian, since we predict on a single value of **w** and not a density
      - easy
  1. Approximate the posterior with something easier
      - easier to use , since we can choose any density we like
      - not reliable if the density chosen is very different from the posterior
  1. Sample from the posterior
      - can get good results but dificult to implement

- examples below
  - note that these aren't the only ways of approximating/sampling and they are general techniques not unique to LR

## MAP Estimate

- our aim is to find the value of **w** , $\hat{w}$ that maximises the posterior $p\left(\mathbf{w} \mid \mathbf{X}, \mathbf{t}, \sigma^{2}\right)$
  - since our function $g$ is proportional to the posterior, they have the same shape, hence the same maximum

- Once we have the MAP solution $\hat{w}$ we can just replace the parameter **w** by it in our model in order to make predictions

- Unlike linear regression, we can't solve this optimisation problem singe $g$ does not have a closed solution. Hence we must resort to numerical methods
  1. Guess $\hat{w}$
  1. Make slight changes to it in a way that increases $g$
  1. Repeat until stable

- Different numerical optimisation algos exist which differ w.r.t step 2

![](@attachment/Clipboard_2021-07-22-01-10-29.png)

- like covered in previous lectures, we can plot decision boundary by fixing the probability and evaluating our expression so that every point on that line has that probability of belonging to that class

![](@attachment/Clipboard_2021-07-22-01-10-52.png)

- room for improvement
- overconfidence

![](@attachment/Clipboard_2021-07-22-01-13-42.png)

## Laplace Approximation

- a.k.a saddle-point approximation
- can be used to approximate any density (over real-valued random variables) for which we can 
  - find the mode and
  - compute the second derivative
- the idea is to approximate the density of interest with a Gaussian
  - defined by mean and covariance
  - hence a good Gaussian approximation will involve choosing suitable values for these

- in Laplace approximation we approximate the posterior with a Gaussian that has 
  - its **mean** at the **posterior mode** $\hat{w}$
    - $\mu = \hat{\mathbf{w}}$
  - and has **variance** inversely proportional to the curvature of the posterior (its second derivative) at its mode
    - $\boldsymbol{\Sigma}^{-1}=-\left.\frac{\partial \log g\left(\mathbf{w} ; \mathbf{X}, \mathbf{t}, \sigma^{2}\right)}{\partial \mathbf{w} \partial \mathbf{w}^{\top}}\right|_{\widehat{w}}$

  > REM deduction of approximation beyond the scope but covered in 147

#### Evaluating Approximation Quality

- as expected it gets worse as we move away from the mode

![](@attachment/Clipboard_2021-07-22-01-30-57.png)

### Predictions

- Need to evaluate by taking the expectation

$$
\begin{aligned} P\left(T_{\text {new }}=1 \mid \mathbf{x}_{\text {new }}, \mathbf{X}, \mathbf{t}\right) &=\mathbf{E}_{\mathcal{N}(\mu, \Sigma)}\left\{P\left(T_{\text {new }}=|1| \mathbf{x}_{\text {new }}, \mathbf{w}\right)\right\} \\ &=\int \mathcal{N}(\mu, \mathbf{\Sigma}) \frac{1}{1+\exp \left(-\mathbf{w}^{\top} \mathbf{x}_{\text {new }}\right)} d \mathbf{w} \end{aligned}
$$

- Again, no closed solution, so no go, **but** we can sample from the Gaussian easily
  - Hence, we can approximate an expectation using the samples

  $$
P\left(T_{\text {new }}=1 \mid \mathbf{x}_{\text {new }}, \mathbf{X}, \mathbf{t}, \sigma^{2}\right)=\frac{1}{N_{s}} \sum_{s=1}^{N_{s}} \frac{1}{1+\exp \left(-\mathbf{w}_{s}^{\top} \mathbf{x}_{\text {new }}\right)}
$$

#### Evaluating Again

- the decision boundaries have improved from the point prediction
  - since Laplace uses a distribution over **w**, and therefore over decision boundaries, it has less certainty

![](@attachment/Clipboard_2021-07-22-01-36-04.png)

![](@attachment/Clipboard_2021-07-22-01-38-00.png)

## MCM Sampling

- enables us to cut out the approximation step of the Laplace method and sample directly from the posterior
- similarly to above, we can then replace this approximation directly into our model to compute our prediction
- various algorithms exist, we'll use *Metropolis-Hastings*

### Sampling Intuition

- We are trying to draw samples from an unknown distribution. How?

- Say we want to know the probability that we hit the dartboard to score 20 when we aim for the 20 treble
  - there's an underlying distribution for this process $p(\mathbf{x}\mid \text{stuff})$
- We define the function $f(\mathbf{x}) = 1$ if **x** in treble 20 and 0 otherwise
  - Hence, the probability that I hit treble twenty is given by $\int f(\mathbf{x}) p(\mathbf{x} \mid \text { stuff }) d \mathbf{x}$
  - no idea how to write our distribution, **but** can start generating data, i.e. throwing the darts
- From the data generated we can *sample* and compute the average

$$
\frac{1}{S} \sum_{s=1}^{S} f\left(\mathbf{x}_{s}\right)
$$

### Metropolis-Hasting

![](@attachment/Clipboard_2021-07-22-02-41-33.png)

- 2 steps
  - proposal
  - acceptance

1. *propose* a new sample - a candidate $\mathbf{\widetilde{w_s}}$ for **w_s** by performing a movement from a previous sample **w_{s-1}**
1. test the proposed sample to see if it should be *accepted*
    1. ACCEPT : `w_s := w_sp`
    1. REJET : `w_s := w_s-1`

- as long as we sample for long enough it doesn't matter where we start, since the sampler is (in theory) guaranteed to converge

#### Proposal

- we can define the density $p\left(\widetilde{\mathbf{w}_{s}} \mid \mathbf{w}_{s-1}\right)$
  - the choice is up to us, but it will affect convergence time
  - common choice : $p\left(\widetilde{\mathbf{w}_{s}} \mid \mathbf{w}_{s-1}, \mathbf{\Sigma}\right)=\mathcal{N}\left(\mathbf{w}_{s-1}, \mathbf{\Sigma}\right)$
    - easy
    - symmetric -  moving from the candidate to the previous sample is just as likely (important for the acceptance step), i.e. $p\left(\widetilde{\mathbf{w}_{s}} \mid \mathbf{w}_{s-1}, \Sigma\right)=p\left(\mathbf{w}_{s-1} \mid \widetilde{\mathbf{w}_{s}}, \Sigma\right)$

- sampling like this is know as a **random walk**

![](@attachment/Clipboard_2021-07-22-02-54-13.png)

#### Acceptance 

- acceptance test - the ratio of the posterior density at the proposed sample to that at the old sample multiplied by the ratio of the proposal densities
  - the symmetry of the Gaussian allows us to ignore the last term, since it is always 1
  - the first term is the ratio of the posterior densities evaluated at the two different parameter values

$$
r=\frac{p\left(\widetilde{\mathbf{w}_{s}} \mid \mathbf{X}, \mathbf{t}, \sigma^{2}\right)}{p\left(\mathbf{w}_{s-1} \mid \mathbf{X}, \mathbf{t}, \sigma^{2}\right)} \frac{p\left(\mathbf{w}_{s-1} \mid \widetilde{\mathbf{w}_{s}}, \Sigma\right)}{p\left(\widetilde{\mathbf{w}_{s}} \mid \mathbf{w}_{s-1}, \Sigma\right)}
$$

- since the normalisation constants cancel out, simplify the expression above to something we can compute

![](@attachment/Clipboard_2021-07-22-03-01-56.png)

$$
r=\frac{g\left(\widetilde{\mathbf{w}_{s}} ; \mathbf{X}, \mathbf{t}, \sigma^{2}\right)}{g\left(\mathbf{w}_{s-1} ; \mathbf{X}, \mathbf{t}, \sigma^{2}\right)} \frac{p\left(\mathbf{w}_{s-1} \mid \widetilde{\mathbf{w}_{s}}, \mathbf{\Sigma}_{p}\right)}{p\left(\widetilde{\mathbf{w}_{s}} \mid \mathbf{w}_{s-1}, \mathbf{\Sigma}_{p}\right)}
$$

- **test**
  - $r \geq 1$ , accept with $\mathbf{w_s} = \mathbf{\widetilde{w_s}}$
  - REJET if $r < 1$, accept with probability $r$

- In other words, if we propose a set of parameters that corresponds to 
 - a higher value of the posterior density than $\mathbf{w_{s-1}}$, we always accept it 
 - a lower value of posterior density, we accept it sometimes

![](@attachment/Clipboard_2021-07-22-02-53-30.png)

![](@attachment/Clipboard_2021-07-22-03-08-51.png)

![](@attachment/Clipboard_2021-07-22-03-08-58.png)

![](@attachment/Clipboard_2021-07-22-03-09-10.png)

#### Predictions

- we use the generated samples in place of **w** in our model

$$
\begin{aligned} P\left(t_{\text {new }}=1 \mid \mathbf{x}_{\text {new }}, \mathbf{X}, \mathbf{t}, \sigma^{2}\right) &=\mathbf{E}_{p\left(\mathbf{w} \mid \mathbf{X}, \mathbf{t}, \sigma^{2}\right)}\left\{P\left(t_{\text {new }} \mid \mathbf{x}_{\text {new }}, \mathbf{w}\right)\right\} \\ & \approx \frac{1}{S} \sum_{s=1}^{S} \frac{1}{1+\exp \left(-\mathbf{w}_{s}^{\top} \mathbf{x}_{\text {new }}\right)} \end{aligned}
$$

![](@attachment/Clipboard_2021-07-22-03-12-48.png)

- approximating the posterior allows some parameters values that are very unlikely in the true posterior

![](@attachment/Clipboard_2021-07-22-03-13-06.png)