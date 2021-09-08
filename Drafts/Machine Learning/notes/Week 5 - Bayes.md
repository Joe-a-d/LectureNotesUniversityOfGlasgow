# Week 5 - Bayes

***
**Lecture** 7
***

![](@attachment/Clipboard_2021-07-19-17-42-11.png)

![](@attachment/Clipboard_2021-07-19-17-42-19.png)

# Where we're at

- We've discussed two techniques to find the best parameter values
  - minimising the loss
  - maximising the likelihood
- We've also seen that when the noise is Gaussian the resulting estimator is exactly the same

![](@attachment/Clipboard_2021-07-19-12-25-51.png)

## Point Estimate Limitations

- as we've seen, even if when we found that our estimator was unbiased, there was always some uncertainty when estimating the parameter. This is mainly due to the fact that we always have a finite number of observations to work with.
  - recall how this varied with different order polynomials
  - how there were several parameters which produced (approx) equally good results
  - this different models may give different predictions

### Possible Solution - Averaging

- we can make the prediction to be some function of $\mathbf{w}$
- choose different values for $\mathbf{w}$
- compute the average prediction for each $\mathbf{w}$

![](@attachment/Clipboard_2021-07-19-13-03-49.png)

- **How to choose the $\mathbf{w}$s**?
  - we can see $\mathbf{w}$ as a RV with pdf conditioned on some "stuff"
  - we can then generate values for $\mathbf{w}$ , take an average of the predictions from each possible $\mathbf{w}$ weighted by how likely that $\mathbf{w}$ value is

  ![](@attachment/Clipboard_2021-07-19-13-07-10.png)

- **BUT**
  - what is this "stuff" condition(s) ?
  - how do we compute $p(\mathbf{w}|\text{stuff}$ ?

# Bayes' Rule

- This "stuff" should include data
  - $\mathbf{X, t} : p(\mathbf{w}|\mathbf{X,t})$ , i.e. what we know about $\mathbf{w}$ after observing some data
  - **note** how this is very similar to the expression for likelihood $p\left(\mathbf{t} \mid \mathbf{w}, \mathbf{X}, \sigma^{2}\right)$
    - we'll ignore $\sigma^2$ ; we'll assume that we know it, and fix it to some value

- We can compute our new density for $\mathbf{w}$ using the likelihood via the Bayes' Rule, which comes directly from the decomposition of the joint probability in terms of the conditional
  - Recall, that

  $$
\begin{array}{l}P(Y=y, X=x)=P(Y=y \mid X=x) \times P(X=x) \\ P(Y=y, X=x)=P(X=x \mid Y=y) \times P(Y=y)\end{array}
$$

  - Hence, by equating the RHS of the above equations and rearranging, we get 

  $$
P(X=x \mid Y=y)=\frac{P(Y=y \mid X=x) P(X=x)}{P(Y=y)}
$$

- Getting back to our model

$$
p(\mathbf{w} \mid \mathbf{X}, \mathbf{t})=\frac{p(\mathbf{t} \mid \mathbf{X}, \mathbf{w}) p(\mathbf{w})}{p(\mathbf{t} \mid \mathbf{X})}
$$

- LHS the **posterior density**
  - this is our end goal
- $p\left(\mathbf{t} \mid \mathbf{w}, \mathbf{X}\right)$ is the familiar **likelihood**
- $p(\mathbf{w})$ is the **prior density**
  - expresses a belief about the value of **w** prior to seeing any data
- lastly, the denominator is the **marginal likelihood**
  - note that this is not a function of $\mathbf{w}$ , it is just a normalisation constant which ensures that $\int p(\mathbf{w} \mid \mathbf{X}, \mathbf{t}) d \mathbf{w}=1$
  

- The key idea behind the above is that we can update our beliefs either by running the model again with different data **or** by simply updating our prior with the previously calculated posterior and run the experiment again with the same data
- Recall that our goals are
  1. Find good parameter estimates
  1. Quantify the uncertainty of the "good" estimates found
  - the best way to define this is to use a pdf w.r.t **w**, but instead of picking one at random we use one that is defined after we've seen the training data and which is also tied in to our linear regression model

### Study Case - Email

**See slides**


## Computing the Posterior

- difficult, because the marginal likelihood $p(\mathbf{t}\mid \mathbf{X})$ is hard to compute
  - $p(\mathbf{t} \mid \mathbf{X})=\int p(\mathbf{t} \mid \mathbf{w}, \mathbf{X}) p(\mathbf{w}) d \mathbf{w}$
- it cannot be always done, e.g. the integral might not have a closed form

### Requirements 

Conjugacy
: a prior $p(\mathbf{w})$ is said to be conjugate to a likelihood they result in a posterior which is of the same form as the prior

- [Examples](https://en.wikipedia.org/wiki/Conjugate_prior#Table_of_conjugate_distributions)

- Conjugacy enable us to compute the posterior density analytically without having to worry about computing the denominator , i.e. the marginal likelihood
  - because we know the form of the posterior and therefore also know the form of the normalising constant (denominator)
  - the posterior will be proportional to the likelihood up to some normalising constant, and since it is not a function of **w** we can algebraically make the numerator look like the correct density, ignoring all terms without **w**

#### Example

![](@attachment/Clipboard_2021-07-19-14-24-25.png)

- note that there is no correlation between $w_0,w_1$

![](@attachment/Clipboard_2021-07-19-14-34-14.png)

> REM shitty derivation in supplementary slides

![](@attachment/Clipboard_2021-07-19-14-37-11.png)

- the Gaussian posterior is show in black
- in the background we can see part of the contour of the prior distribution

![](@attachment/Clipboard_2021-07-19-14-37-17.png)

### Likelihood, Posterior, Data

- Run 0

> REM scale does not match Olympic data example

![](@attachment/Clipboard_2021-07-19-14-39-56.png)

- After observing one data point

![](@attachment/Clipboard_2021-07-19-14-40-39.png)

- After several more data points the posterior distribution shrinks significantly

![](@attachment/Clipboard_2021-07-19-14-41-50.png)

### Maximum A Posteriori , Regularised Least Squares

- It's a point estimate framework
- You can think of MAP as the Bayesian equivalent of MLE
  - from a bayesian perspective this can be seen as a *regularised* version of MLE
    - the regularisation terms encode the priors on **w**

- in the figure below in the axes we represent the parameters 
  - the blue contour represents the likelihood function 
  - the filled circle represents the prior distribution
- the argmax occur at the centre of their respective circles
- the argmax of the posterior lies in the intersection 

![](@attachment/Clipboard_2021-07-19-15-42-47.png)

> REM Should be argmin not argmax , TYPO 

- a.k.a , *regularised ridge regression* model

![](@attachment/Clipboard_2021-07-19-15-47-37.png)

- Regularised Linear Regression - **Lasso**
  - the difference here is that the regularisation term uses the `L1` penalty function, i.e. the sum of the absolute values of **w** (instead of the inner product of **w** like in ridge/L2)

## Predictions

- Recall that our motivation for going Bayesian was to be able to average predictions at $\mathbf{x_{\text{new}}}$ over all $\mathbf{w}$ , in order to get away from point estimates
  - we assume that $f(\mathbf{w})$ is just another Gaussian $\mathcal{N}\left(\mathbf{w}^{\top} \mathbf{x}_{\text {new }}, \sigma^{2}\right)$
  - like before , we can compute this as the expectation of a function of **w** w.r.t posterior distribution

$$
\mathbf{E}_{p\left(\mathbf{w} \mid \mathbf{X}, \mathbf{t}, \sigma^{2}\right.}\{f(\mathbf{w})\}=\int f(\mathbf{w}) p\left(\mathbf{w} \mid \mathbf{t}, \mathbf{X}, \sigma^{2}\right) d \mathbf{w}
$$

- We can compute this expectation **exactly**, to give the predictive density
  - i.e. the pdf of $t_{\text{new}}$ conditioned on our training data **X** and **t** and our new position for $x$ and the noise variance
  - in this case

$$
p\left(t_{\mathrm{new}} \mid \mathbf{X}, \mathbf{t}, \mathbf{x}_{\mathrm{new}}, \sigma^{2}\right)=\mathcal{N}\left(\mathbf{x}_{\mathrm{new}}^{\top} \boldsymbol{\mu}, \sigma^{2}+\mathbf{x}_{\mathrm{new}}^{\top} \boldsymbol{\Sigma} \mathbf{x}_{\mathrm{new}}\right)
$$ 

- **resulting predictive density function**

![](@attachment/Clipboard_2021-07-19-17-02-35.png)

- evolution of changes in terms of pdf
  - the green line represents the true model generated the synthetic data (blue)
  - red line represents the mean of our model prediction
  - the pink regions +- std

- note how the uncertainty around the observed data points start to shrink

![](@attachment/Clipboard_2021-07-19-17-03-15.png)

### Computing Posterior - Algorithm

![](@attachment/Clipboard_2021-07-19-17-06-12.png)

## Marginal Likelihood

- So far, we've ignored the normalising constant (denominator) and we just said that it was equal to the integral with respect to w of the numerator
- This marginal likelihood function is generally very good at comparing different model complexities
  - because for any given model, we fix the likelihood function and then we are essentially evaluating it at every possible value of the parameter **w**, giving us an average of all values of **w**

$$
\begin{array}{l}\text { When prior is } \mathcal{N}\left(\boldsymbol{\mu}_{0}, \boldsymbol{\Sigma}_{0}\right) \text { and likelihood is } \mathcal{N}\left(\mathbf{X} \mathbf{w}, \sigma^{2} \mathbf{I}\right) \text { , } \\ \text { marginal likelihood is: } \\ \qquad p\left(\mathbf{t} \mid \mathbf{X}, \mathbf{t}, \sigma^{2}, \boldsymbol{\mu}_{0}, \boldsymbol{\Sigma}_{0}\right)=\mathcal{N}\left(\mathbf{X} \mu_{0}, \sigma^{2} \mathbf{I}+\mathbf{X} \boldsymbol{\Sigma}_{0} \mathbf{X}^{\top}\right)\end{array}
$$

- i.e. and N-dimensional Gaussian evaluated at **t**

- 

### Example

![](@attachment/Clipboard_2021-07-19-17-34-11.png)

## Choosing a Prior

- the importance of the prior is inversely proportional to the amount of data seen/available, and is influenced by the following factors (not exhaustive):
  - data type (real, string, continuous etc.)
  - expert knowledge (e.g. "the coin is fair")
  - computational considerations
- if we know nothing then we can use a broad prior, e.g. uniform density




# Resources

- Good [explanation](https://www.cs.cornell.edu/courses/cs4780/2018fa/lectures/lecturenote08.html) on deriving MLE and MAP ; from @18
- https://alliance.seas.upenn.edu/~cis520/wiki/index.php?n=Lectures.Logistic