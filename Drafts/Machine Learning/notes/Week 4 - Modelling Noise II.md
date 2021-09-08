# Week 4 - Modelling Noise II

***
**Lecture** 6
***

  # DERIVATIONS OF A LOT OF THESE ARE EXAMINABLE ; SEE SUPPLEMENTARY MATERIAL AND COME BACK

![](@attachment/Clipboard_2021-07-14-13-40-24.png)

- focus on 3 benefits of using a probabilistic model
  - we can use the idea of a likelihood function to estimate the parameter $w$
  - we can quantify the confidence level of our estimation
  - we can quantify the confidence in our model predictions

## Likelihood optimisation

Last time we looked at the likelihood of a single data point, but in genereal we are interested in the likelihood of all of the data. So, if we have $N$ data points, we are interested in the *joint conditional density*

$$
p\left(t_{1}, \ldots, t_{N} \mid \mathbf{x}_{1}, \ldots, \mathbf{x}_{N}, \mathbf{w}, \sigma^{2}\right)
$$

- for simplicity we can also write the above as $p\left(\mathbf{t} \mid \mathbf{X}, \mathbf{w}, \sigma^{2}\right)$
- if we assume that the noise *at each datapoint* is independent, i.e $\left(p\left(\epsilon_{1}, \ldots, \epsilon_{N}\right)=\prod_{n} p\left(\epsilon_{n}\right)\right)$ we can factorise the expression into $N$ separate terms, once for each data object

$$
L=p\left(\mathbf{t} \mid \mathbf{X}, \mathbf{w}, \sigma^{2}\right)=\prod_{n=1}^{N} p\left(t_{n} \mid \mathbf{x}_{n}, \mathbf{w}, \sigma^{2}\right)=\prod_{n=1}^{N} \mathcal{N}\left(\mathbf{w}^{\top} \mathbf{x}_{n}, \sigma^{2}\right)
$$

- Note that the $t_n$ values are not completely independent, instead we say that they are *conditionally independent*, conditioned on a particular value of $w$ (the deterministic part of the model) that is 

- this equation gives us a single value that tells us how likely our dataset is, given the current model (our choice of $w$ and $\sigma^2$), our goal now is to vary the model in order to find the one which maximises the likelihood

$$
\underset{\mathbf{w}, \sigma^{2}}{\operatorname{argmax}} \prod_{n=1}^{N} p\left(t_{n} \mid \mathbf{w}, \mathbf{x}_{n}, \sigma^{2}\right)
$$

- to make it easy to compute we'll however use the natural log likelihood, since it allow us to 
  - convert the product into a sum and given that the logarithm function is a monotonic function, the resulting maximum will be the same as the original function
  - to get rid of the exponential function

$$
\underset{\mathbf{w}, \sigma^{2}}{\operatorname{argmax}} \log \prod_{n=1}^{N} p\left(t_{n} \mid \mathbf{w}, \mathbf{x}_{n}, \sigma^{2}\right)
$$

#### Derivation

$$
\begin{aligned} p\left(t_{n} \mid \mathbf{w}, \mathbf{x}_{n}, \sigma^{2}\right) &=\frac{1}{\sigma \sqrt{2 \pi}} \exp \left\{-\frac{1}{2 \sigma^{2}}\left(t_{n}-\mathbf{w}^{\top} \mathbf{x}_{n}\right)^{2}\right\} \\ \log L &=\log \prod_{n=1}^{N} p\left(t_{n} \mid \mathbf{w}, \mathbf{x}_{n}, \sigma^{2}\right) \\ &=\sum_{n=1}^{N} \log p\left(t_{n} \mid \mathbf{w}, \mathbf{x}_{n}, \sigma^{2}\right) \\ &=\sum_{n=1}^{N} \log \left(\frac{1}{\sigma \sqrt{2 \pi}}\right)-\sum_{n=1}^{N} \frac{1}{2 \sigma^{2}}\left(t_{n}-\mathbf{w}^{\top} \mathbf{x}_{n}\right)^{2} \\ &=-N \log (\sigma \sqrt{2 \pi})-\frac{1}{2 \sigma^{2}} \sum_{n=1}^{N}\left(t_{n}-\mathbf{w}^{\top} \mathbf{x}_{n}\right)^{2} \end{aligned}
$$

### Optimum Parameters

#### $\hat{w}$

- Compute optimum $\widehat{\mathbf{w}}=\left(\mathbf{X}^{\top} \mathbf{X}\right)^{-1} \mathbf{X}^{\top} \mathbf{t}$
  - we take the partial derivative of our likelihood function w.r.t. $w$ and set it to zero
  - note that $\mathbf{w}^{\top} \mathbf{x}_{n}=\mathbf{x}_{n}^{\top} \mathbf{w}$

  $$
\begin{aligned} \frac{\partial \log L}{\partial \mathbf{w}} &=\frac{1}{\sigma^{2}} \sum_{n=1}^{N} \mathbf{x}_{n}\left(t_{n}-\mathbf{x}_{n}^{\top} \mathbf{w}\right) \\ &=\frac{1}{\sigma^{2}} \sum_{n=1}^{N} \mathbf{x}_{n} t_{n}-\mathbf{x}_{n} \mathbf{x}_{n}^{\top} \mathbf{w}=\mathbf{0} \end{aligned}
$$

- We can write the derivative in vector/matrix form, if we use shorthand to put the $x_i^T$ in matrix form and $t_i$ in vector form, i.e

$$
\mathbf{X}=\left[\begin{array}{c}\mathbf{x}_{1}^{\top} \\ \mathbf{x}_{2}^{\top} \\ \vdots \\ \mathbf{x}_{N}^{\top}\end{array}\right]=\left[\begin{array}{cc}1 & x_{1} \\ 1 & x_{2} \\ \vdots & \vdots \\ 1 & x_{N}\end{array}\right], \quad \mathbf{t}=\left[\begin{array}{c}t_{1} \\ t_{2} \\ \vdots \\ t_{N}\end{array}\right]
$$

$$\frac{\partial \log L}{\partial \mathbf{w}}=\frac{1}{\sigma^{2}}\left(\mathbf{X}^{\top} \mathbf{t}-\mathbf{X}^{\top} \mathbf{X} \mathbf{w}\right)=0$$

- Finally, equating it to $\mathbf{0}$ and solving it gives us the expression for the optimal value

$$
\begin{aligned} \frac{1}{\sigma^{2}}\left(\mathbf{X}^{\top} \mathbf{t}-\mathbf{X}^{\top} \mathbf{X} \mathbf{w}\right) &=0 \\ \mathbf{X}^{\top} \mathbf{t}-\mathbf{X}^{\top} \mathbf{X} \mathbf{w} &=0 \\ \mathbf{X}^{\top} \mathbf{X} \mathbf{w} &=\mathbf{X}^{\top} \mathbf{t} \\ \mathbf{w} &=\left(\mathbf{X}^{\top} \mathbf{X}\right)^{-1} \mathbf{X}^{\top} \mathbf{t} \end{aligned}
$$

> this solution is exactly that which we have already derived for the least squares case since minimising the squared loss is equivalent to the maximum likelihood solution if the noise is assumed to be Gaussian

#### $\hat{\sigma^2}$

- **see page 72 of textbook and zoom lecture @47:50**

- Use a similar procedure to the above (assuming $w = \widehat{w}$) to compute $\widehat{\sigma^{2}}=\frac{1}{N} \sum_{n=1}^{N}\left(t_{n}-\mathbf{x}^{\top} \widehat{\mathbf{w}}\right)^{2}$
  

$$
\widehat{\sigma^{2}}=\frac{1}{N}(\mathbf{t}-\mathbf{X} \widehat{\mathbf{w}})^{\top}(\mathbf{t}-\mathbf{X} \widehat{\mathbf{w}}) = L(\hat{w})
$$

- where $L$ is just the average squared loss

# Confidence in Parameter Estimates

- How much can we change the straight line and still have a good model? (how confident are we of our parameter estimates)
  - If there is a lot of noise - high $\sigma^2$ we probably can change $\hat{w}$ quite a bit
  - If the opposite is true, then our fit will quickly worsen

- We'll explore this in analytically in more detail below, but we can develop some intuition as to why this is by looking at the image below. As we can see in the top row the data is much more noisy leading to the likelihood in terms of both parameters ($w_0, w_1$) to have *low curvature* (this property is discusee below) as evidenced by the contour lines being further apart which in turn indicates more "degrees of freedom" in terms of other possible parameters. Looking at the image on the left we can see this, we have more room to move the line's intercept ($w_0$) and its gradient ($w_1$) and still capture a fair bit of the data. 
  - On the other hand, the "tighter" dataset below is far less noisier, hence the opposite is true

![](@attachment/Clipboard_2021-07-18-16-11-09.png)


- Since the value of $\hat{w}$ is strongly influenced by the particular noise values in the data it is useful to know how much uncertainty there was in $\hat{w}$ in the first place, i.e. we want to know if our parameters estimate $\hat{w}$ is unique or if there are others which could do just as well

- In order to tell what the value of $\hat{w}$ will be *on average* we'll compute its expectation with respect to the generating distribution

## Expectation

- Imagine we have a random variable $X$ with density $p(x)$
  - our goal is to work out the average value of $X$ , $\tilde{x}$
- We can generate $S$ samples , $x_1,\cdots,x_s$
  - and then take their average
  - with the approximation getting better as we add more sample

$$
\tilde{x} \approx \frac{1}{S} \sum_{s=1}^{S} x_{s}
$$

- Alternatively, we can *compute it directly* using the concept of expectation

### Generalisation

- For a continuous random variable, we can describe how $f(x)$ will behave using the following general formulation of expectation
  - the RV $x$ is distributed according to $p(x)$

$$
\mathbf{E}_{p(x)}\{f(x)\}=\int f(x) p(x) d x
$$

#### Fundamental properties

$$
\begin{array}{l}\mathbf{E}_{p(x)}\{f(X\} \neq f\left(\mathbf{E}_{p(x)}\{X\}\right) \\ \mathbf{E}_{p(x)}\{k f(X)\}=k \mathbf{E}_{p(x)}\{f(X)\} \\ \text { Mean, } \mu=\mathbf{E}_{p(x)}\{X\} \\ \text { Variance: } \\ \sigma^{2}=\mathbf{E}_{p(x)}\left\{(X-\mu)^{2}\right\}=\mathbf{E}_{p(x)}\left\{X^{2}\right\}- \mathbf{E}_{p(x)}\{X\}^{2}\end{array}
$$

#### Variance Derivation

$$
\begin{array}{l}\operatorname{var}\{X\}=\mathbf{E}_{P(x)}\left\{\left(X-\mathbf{E}_{P(x)}\{X\}\right)^{2}\right\} \\ =\mathbf{E}_{P(x)}\left\{X^{2}-2 X \mathbf{E}_{P(x)}\{X\}+\mathbf{E}_{P(x)}\{X\}^{2}\right\} \\ =\mathbf{E}_{P(x)}\left\{X^{2}\right\}-2 \mathbf{E}_{P(x)}\{X\} \mathbf{E}_{P(x)}\{X\}+\mathbf{E}_{P(x)}\{X\}^{2}  \\ = \mathbf{E}_{P(x)}\left\{X^{2}\right\}-\mathbf{E}_{P(x)}\{X\}^{2} 

\\ \\  \text { To get from the second to third lines, we have used the fact that } \\ \qquad \mathbf{E}_{P(x)}\left\{\mathbf{E}_{P(x)}\{f(X)\}\right\}=\mathbf{E}_{P(x)}\{f(X)\} \\
\end{array}
$$

- also on zoom lecture @1:09

#### Vectorised Form


**COVARIANCE MATRIX**

- when dealing with vectors the concept of variance is generalised to a **covariance matrix**
  - $\operatorname{cov}\{\mathbf{x}\}=\mathbf{E}_{P(\mathbf{x})}\left\{\left(\mathbf{x}-\mathbf{E}_{P(\mathbf{x})}\{\mathbf{x}\}\right)\left(\mathbf{x}-\mathbf{E}_{P(\mathbf{x})}\{\mathbf{x}\}\right)^{\top}\right\}$
  - the diagonal elements correspond to the variance of the individual elements
    - in our example this would translate to how much we can change $w_o$ and $w_1$ and still have a good model
  - the off-diagonal elements how the elements vary with respect to each other (think of it as unscaled correlation)

![](@attachment/Clipboard_2021-07-18-19-19-58.png)


$$
\begin{array}{l}\mathbf{E}_{p(\mathbf{x})}\{f(\mathbf{x})\}=\int f(\mathbf{x}) p(\mathbf{x}) d x \\ \text { Mean: } \boldsymbol{\mu}=\mathbf{E}_{p(\mathbf{x})}\{\mathbf{x}\} \\ \text { Covariance: } \\ \qquad \begin{aligned} \operatorname{cov}\{x\} &=\mathbf{E}_{p(\mathbf{x})}\left\{(\mathbf{x}-\boldsymbol{\mu})(\mathbf{x}-\boldsymbol{\mu})^{\top}\right\} \\ &=\mathbf{E}_{p(\mathbf{x})}\left\{\mathbf{x x}^{\top}\right\}-\mathbf{E}_{p(\mathbf{x})}\{\mathbf{x}\} \mathbf{E}_{p(\mathbf{x})}\left\{\mathbf{x}^{\top}\right\} \end{aligned}\end{array}
$$

- TODO : LINK BACK TO w HAT explanation and meaning from page 79,80

### Gaussians

![](@attachment/Clipboard_2021-05-27-04-55-53.png)

## Parameter Estimates

- Going back to our model

$$
\begin{aligned} \widehat{\mathbf{w}} &=\left(\mathbf{X}^{\top} \mathbf{X}\right)^{-1} \mathbf{X}^{\top} \mathbf{t} \\ \widehat{\sigma^{2}} &=\frac{1}{N}(\mathbf{t}-\mathbf{X} \mathbf{w})^{\top}(\mathbf{t}-\mathbf{X} \mathbf{w}) \end{aligned}
$$

$$
\begin{array}{l}\hat{\omega}=f(\underline{t} ; \underline{x}) \\ \hat{\sigma}^{2}=g(\underline{t} ; \underline{x}, \underline{w})\end{array}
$$

- Goal : Find the expectation, the average value of the least squares estimator $\hat{w}$ and the uncertainty of its parameters
  - need to know the source of the RV
  - both estimators $\hat{w}$ , $\sigma^2$ are functions of $t$ and attributes $X$ matrix
  - only random variable is $t$ (the noise) which we assume follows a normal/Gaussian distribution

- We assume that for both parameters there are underlying true values $\mathbf{w}, \sigma^2$


- Our model :
  - the source of randomness is given by this density function  
$$
p\left(\mathbf{t} \mid \mathbf{X}, \mathbf{w}, \sigma^{2}\right)=\mathcal{N}\left(\mathbf{X} \mathbf{w}, \sigma^{2} \mathbf{I}\right)
$$

- We want to find 

$$
\mathbf{E}_{p\left(\mathbf{t} \mid \mathbf{X}, \mathbf{w}, \sigma^{2}\right)}\{\widehat{\mathbf{w}}\}
$$


- the w in the conditional pdf represents the true values, which we use to evaluate the performance of our estimator
  - we are calculating the overall average error between the true values and our estimator $\hat{w}$


$$
\begin{array}{l}\qquad \mathbf{E}_{p\left(\mathbf{t} \mid \mathbf{X}, \mathbf{w}, \sigma^{2}\right)}\{\widehat{\mathbf{w}}\}=\int \widehat{\mathbf{w}} p\left(\mathbf{t} \mid \mathbf{X}, \mathbf{w}, \sigma^{2}\right) d \mathbf{t} \\ \text { Substituting } \widehat{\mathbf{w}}=\left(\mathbf{X}^{\top} \mathbf{X}\right)^{-1} \mathbf{X}^{\top} \mathbf{t} \text { into this expression allows us to evaluate the inte- } \\ \text { gral: } \\ \qquad \begin{aligned} &=\left(\mathbf{X}^{\top} \mathbf{X}\right)^{-1} \mathbf{X}^{\top} \int \mathbf{t} p\left(\mathbf{t} \mid \mathbf{X}, \mathbf{w}, \sigma^{2}\right) d \mathbf{t} \\=&\left(\mathbf{X}^{\top} \mathbf{X}\right)^{-1} \mathbf{X}^{\top} \mathbf{E}_{p\left(\mathbf{t} \mid \mathbf{X}, \mathbf{w}, \sigma^{2}\right)}\{\mathbf{t}\} \\=&\left(\mathbf{X}^{\top} \mathbf{X}\right)^{-1} \mathbf{X}^{\top} \mathbf{X} \mathbf{w} \\=& \mathbf{w} \end{aligned}\end{array}
$$

- this result tells us that $\widehat{\mathbf{w}}$ is **unbiased**, i.e. the expected value of our approximation $\widehat{\mathbf{w}}$ is the same as true parameter value $\mathbf{w}$
  - this information , i.e. the potential variability in the estimate of the $\widehat{\mathbf{w}}$, is encapsulated in its covariance matrix
    - its diagonal tells us how much variance there is w.r.t the individual parameters, i.e how well they are defined by the data (+var -> - defined)
    - off-diagonal how the parameters co-vary

$$
\operatorname{cov}\{\widehat{\mathbf{w}}\}=\sigma^{2}\left(\mathbf{X}^{\top} \mathbf{X}\right)^{-1}=-\left(\frac{\partial^{2} \log L}{\partial \mathbf{w} \partial \mathbf{w}^{\top}}\right)^{-1}
$$

> REM derivation on page 80 and zoom @25

- This result tells us that the certainty in the parameters (as described by $\operatorname{cov}\{\widehat{\mathbf{w}}\}$ is directly linked to the second derivative of the log-likelihood. The second derivative of the log-likelihood tells us about the curvature of the likelihood function. Therefore, low curvature corresponds to a high level of uncertainty in parameters and high curvature to a low level. In other words, *we have an expression that tells us how much information our data gives us regarding our parameter estimates*
  - In general, if the information content is high, the data can inform a very accurate parameter estimate and the covariance of $\widehat{\mathbf{w}}$ will be low. If the information content is low, the covariance will be high

## Example

- Our data generating model $t_n$ with $w_0=-2, w_1=3$
- Our noise level is $0.5^2$

![](@attachment/Clipboard_2021-07-18-19-23-42.png)

- note that $\hat{\mathbf{w}}$ is fairly close to our true values $-2,3$ as expected

![](@attachment/Clipboard_2021-07-18-19-23-52.png)

- from the covariance matrix we can see how the variance in $w_1$ is much larger than in $w_0$ and that they are negatively correlated

# Confidence in Predictions

- If we observe a set of attributes $x_{\text{new}}$ we want to predict the output of our model $t_{\text{new}}$ and similarly to what we did with the parameters we want to assess the variability associated with this output - $\sigma^2_{\text{new}}$
- Our prediction is given by 

$$
t_{\mathrm{new}}=\widehat{\mathbf{w}}^{\top} \mathbf{x}_{\mathrm{new}}
$$

- $t_{\text{new}}$ is a function of the RV $t$ , so in order to see if this new expression makes sense we can (like before) calculate its expectation and variance


- Above we calculated the expectation of $\widehat{\mathbf{w}}$ to be $\mathbf{w}$, and since $\mathbf{x}_{\text {new }}$ is not a function of $t$ we can juts treat it as a scalar
  - we get what we expected for an unbiased prediction, the expectation is just equal to the true parameter times the new data

$$
\begin{aligned} \mathbf{E}_{p\left(\mathbf{t} \mid \mathbf{X}, \mathbf{w}, \sigma^{2}\right)}\left\{t_{\mathrm{new}}\right\} &=\mathbf{E}_{p\left(\mathbf{t} \mid \mathbf{X}, \mathbf{w}, \sigma^{2}\right)}\{\widehat{\mathbf{w}}\}^{\top} \mathbf{x}_{\text {new }} \\ &=\mathbf{w}^{\top} \mathbf{x}_{\text {new }} \end{aligned}
$$

- **Variance**

$$
\sigma_{\text {new }}^{2}=\sigma^{2} \mathbf{x}_{\text {new }}^{\top}\left(\mathbf{X}^{\top} \mathbf{X}\right)^{-1} \mathbf{x}_{\text {new }}
$$

- alternatively, written in terms of the covariance

$$
\sigma_{\text {new }}^{2}= \mathbf{x^T}_{\text {new }}\operatorname{cov}\widehat{\mathbf{w}} \ \mathbf{x}_{\text {new }}
$$

> REM derivation in pages 85-6

- if the variance in the parameters is high, so is the variance in the predictions


#### Example - Variance in Predictions

![](@attachment/Clipboard_2021-07-18-20-10-54.png)

- we expect the variance to be high in the linear model since it is too simple, hence the minimum average squared loss is high and we significantly over-estimate the noise $\widehat{\sigma^2}$
- the 6th order model is overly complex so it has a lot of freedom , i.e. many sets of parameters lead to a good model. This uncertainty in $\mathbf{\widehat{w}}$ is passed on through the prediction variability
  - this can be shown by computing the covariance matrix for our estimators of the 3rd and 6th orders. What we'll find is that $\sigma^2$ is much lower in the latter, hence the covariance matrix will be high
  - as we can see in the figure below, if we zoom in into the regions where the losses are close to 0, there are is much more variance in the type of "good" 6th order polynomials, and much less for the 3rd


![](@attachment/Clipboard_2021-07-18-20-17-07.png)

## Back to the Olympic Data - Interpretation

![](@attachment/Clipboard_2021-07-18-20-22-19.png)

![](@attachment/Clipboard_2021-07-18-20-22-07.png)

# Summary

![](@attachment/Clipboard_2021-07-18-20-22-44.png)