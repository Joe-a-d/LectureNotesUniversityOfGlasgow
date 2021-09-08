# Week 3 - Modeling Noise

***
**Lectures** 4,5
***

- errors in model
  - the value between true value and the prediction
- can looking at the errors help us understand the model?
  - it allow us to infer how confident we can be about our prediction 

  ![](@attachment/Clipboard_2021-05-24-01-10-45.png)

- add noise/error to our model
- random variables recaps
- introduce likelihood as a replacement for loss
  - frame the parameter estimation as a problem of *maximising the likelihood* instead of minimising the loss
- compute the confidence in our predictions by leveraging the concepts of likelihood and random variables

## Additive Errors

- We assume that the noise is just an additive term ($\epsilon_n$) in the model

  $$t_{n}=\mathbf{w}^{\top} \mathbf{x_n}+\epsilon_{n}$$

- **ASSUMPTIONS** on $\epsilon_n$
  - different for each $n$
  - can be both positive and negative
  - no clear relationship between different errors and different predictions
  - very hard to model exactly 

## Errors as a random variable

- in other words, errors are unpredictable, i.e. given $n$ and $\epsilon_n$ you can't tell me $epsilon_{n+1}$
  - we can't find $e_n = f(x_n)$
- Hence, we model it as a **random variable**
  - we do not know in advance what value the variable will take, but we know the range of possible values it can take
  - allow us to assign numerical values to possible events

### RVs - recap

> REM : see stats notes if you need a more extensive refresher

- **Discrete** : random events involving countable values (e.g. coin toss)

$$P(X = x)$$

- probability that the random variable $X$ takes the value $x$

- EXAMPLE
  - fair coin 
  $$P(X=1)=0.5, P(X=0)=0.5$$

- **CONSTRAINTS**

$$0 \leq P(Y=y) \leq 1, \quad \sum_{y} P(Y=y)=1$$

- **Continuous** : random events involving uncountable values (e.g. winning time, noise in model)
  - by definition uncountable, hence can't define probabilities of particular outcomes, instead we define a *probability density function* $p(x)$

- pdf tells us how likely different values are, but its output *does not* represent probabilities
  - probabilities of ranges can be computed by taking the area under the curve
    - e.g., the probability that the random variable X lies within 6,8 is given by $P(6 \leq X \leq 8)=\int_{x=6}^{x=8} p(x) d x$

- **CONSTRAINTS**
$$p(x) \geq 0, \quad \int_{-\infty}^{\infty} p(x) d x=1$$

#### Joint Probabilities and Densities

- when there are 2+ RVs

- For two discrete RVs, $X, Y$  (e.g. rolling a coin and a dice), we want to find out $P(X=x, Y=y)$

![](@attachment/Clipboard_2021-05-24-01-44-00.png)

- **Independent RVs** : the outcome of $X$ does not depend on $Y$
  - $P(X=x, Y=y)=P(X=x) P(Y=y)$

- When two random variables *are* dependent, we use the concept of *conditional probabilities*, e.g.what is the probability that $X$ occurs *given that* $Y$ occurs
  - $P(X=1 \mid Y=1)$
  - we can decompose the joint probability, such that
    - e.g., $P(X=x, Y=y)=P(X=x \mid Y=y) P(Y=y)$

#### Conditional - Continuous

- Take the RV $t_n$ and the conditions of our model $x_n, w$ , we can condition the density of $t_n$ on a particular value of $x$ and our model parameters $w$
  - $p\left(t_{n} \mid x_{n}, \mathbf{w}\right)$

### Fundamental Rules w.r.t Probabilities in ML

- any other rules in probabilistic ML can be derived from the rules below

#### Sum Rule

$$
\sum_{y} P(Y=y)=1
$$

- the lower case $y$ is used, by convention, to represent values that the random variable $Y$ can take

#### Product Rule

- **Independent**

$$
P(Y=y, X=x)=P(Y=y) \times P(X=x)
$$

or more generally, and adopting the functional form $p(y,x)$

$$
P\left(y_{1}, y_{2}, \ldots, y_{J}\right)=P\left(y_{1}\right) \times p\left(y_{2}\right) \times \cdots \times P\left(y_{J}\right)=\prod_{j=1}^{J} P\left(y_{j}\right)
$$

- **Dependent**
  - we decompose the joint probability using conditional probabilities

$$
\begin{array}{l}P(Y=y, X=x)=P(Y=y \mid X=x) \times P(X=x) \\ \text{or} \\ \begin{array}{l}P(Y=y, X=x)=P(X=x \mid Y=y) \times P(Y=y)\end{array}\end{array}
$$


## Modelling Noise

- Recall our model

$$t_{n}=\mathbf{w}^{\top} \mathbf{x_n}+\epsilon_{n}$$

- we aim to define $p(\epsilon)$ for continuous $\epsilon$

### Gaussian

$$p\left(\epsilon \mid \mu, \sigma^{2}\right)=\frac{1}{\sigma \sqrt{2 \pi}} \exp \left\{-\frac{1}{2 \sigma^{2}}(\epsilon-\mu)^{2}\right\}$$

- We have two parameters , the mean $\mu$ variance $\sigma^2$ ($\sigma$ being just the standard deviation)

![](@attachment/Clipboard_2021-05-24-02-37-29.png)

![](@attachment/Clipboard_2021-05-24-02-37-49.png)

- the mean shifts horizontally
- the variance affects the bell shape

### Relating the PDF to the error - Generating Data

- rather than finding a model from data, we use the capability of describing the distribution of the random variable to generate data from our model
  - key aspect of ML is believing that there is a true data generating underlying process and the goal is to find the correct parameters which allow us to reconstruct that process

- assume that we have a $w$ we use to minimise loss 

$$
\mathbf{w}=\left[\begin{array}{c}36.416 \\ -0.0133\end{array}\right]
$$

- We can then start generating data by simply sampling from the pdf $p\left(\epsilon_{n} \mid \mu, \sigma^{2}\right)$ 

![](@attachment/Clipboard_2021-05-24-02-49-47.png)

![](@attachment/Clipboard_2021-05-24-02-50-07.png)
- above error spread similar to real data

![](@attachment/Clipboard_2021-05-24-02-50-45.png)
- generated much closer to prediction, does not model noise similar to real data

![](@attachment/Clipboard_2021-05-24-02-51-10.png)
- much far off. We can see that $\mu = 0$ seems like a good approximation, but it is much harder to set $\sigma^2$, so we can consider it as a parameter similar to $w$

**Process Summary**

1. For a particular sample $x_n$, compute the prediction $w^Tx_n$
1. Sample the error $\epsilon_n$ from the Gaussian distribution $\mathcal{N}\left(0, \sigma^{2}\right)$
1. Compute the simulated target value by adding the error to a particular prediction , giving us a synthetic data point $t_{n}=\mathbf{w}^{\top} \mathbf{x}+\epsilon_{n}$

**Alternative**
- sample $t_n$ directly from a Gaussian distribution
  - sampling from distribution with $\mu$ and then adding a constant is equivalent to sampling from distribution with $\mu + C$


$$
\begin{array}{l}\text { Gaussian } \\ \text { If } p\left(\epsilon \mid \mu, \sigma^{2}\right) \text { is Gaussian we can write } p\left(\epsilon \mid \mu, \sigma^{2}\right)=\mathcal{N}\left(\mu, \sigma^{2}\right) \text { . }\end{array}
$$


> REM : Gaussian a.k.a Normal

**Process Visualisation**

- x-axis , our input
- t-axis, our target variable t
- point in the space represents a prediction
  - becomes the mean of the normal distribution with the spread determined by some $\sigma^2$
- we can plot the shape of the distribution , as an approximation, using an histogram

![](@attachment/Clipboard_2021-05-24-03-10-25.png)


- In the end the complete regression model can be written as follows
  - the target value is equal to the model prediction plus the noise, which follows a normal distribution with 0 mean and some parameterised variance $\sigma^2$
  - or , as a normal distribution with the model distribution as the mean and the same variance
$$
\begin{aligned} t_{n} &=\mathbf{w}^{\top} \mathbf{x}_{n}+\epsilon_{n}, p\left(\epsilon_{n} \mid \mu, \sigma^{2}\right)=\mathcal{N}\left(0, \sigma^{2}\right) \\ p\left(t \mid \mathbf{x}_{n}, \mathbf{w}, \sigma^{2}\right) &=\mathcal{N}\left(\mathbf{w}^{\top} \mathbf{x}_{n}, \sigma^{2}\right) \end{aligned}
$$

## Likelihood

- **GOAL** how by formulating $t$ as a random variable we can develop the concept of likelihood function, which can then be used to find the optimal parameters

$$
p\left(t \mid \mathbf{x}_{n}, \mathbf{w}, \sigma^{2}\right)=\mathcal{N}\left(\mathbf{w}^{\top} \mathbf{x}_{n}, \sigma^{2}\right)
$$

- Note the conditioning on the left hand side the density of $t_n$ depends on particular values of $x_n$ and $w$ (they determine the mean) and $\sigma^2$ (the variance)

- we have a pdf for $t$, but note that $t_n$ is fixed, they are given
  - $x_n$ is also given

- Unknowns
  - parameters $w$ and $\sigma^2$

- we define the *likelihood* as the value $t = t_n$
  - not a probability, but a particular value of the pdf which tells us how likely it is that a given parameter hypothesis generates a given target value $t_n$
  - the higher the value, the more likely the model is to be capable of generating $t_n$ , hence the better the model is

> We cannot change $t_n = 10.25$ (this is our data) but we can change $w$ and $\sigma^2$ to try and move the density so as to make it as high as possible at $t = 10.25$. The idea of finding parameters that maximise the likelihood in this way is a key concept in Machine Learning

- the example below shows how varying the mean affects the likelihood
  - the red line closer to the right is a much better approximation, since its mean its closer to the target of 10.25, giving us a likelihood of 0.9
![](@attachment/Clipboard_2021-05-24-03-49-46.png)

- by varying the variance, we get the model below which improves upon the previous model
  - as we can see from the y axis, the likelihood becomes much larger - 4.8

![](@attachment/Clipboard_2021-05-24-03-52-41.png)

- as $t_n$ is fixed, we can find the values of $w, \sigma^2$ that maximise the likelihood


![](@attachment/Clipboard_2021-05-24-03-55-26.png)
