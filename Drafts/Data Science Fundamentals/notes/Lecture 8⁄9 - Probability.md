# Lecture 8/9 - Probability

---
**SEE 2R NOTES**
---

![](@attachment/Clipboard_2021-06-03-09-33-15.png)

## Essential Definitions

![](@attachment/Clipboard_2021-06-03-09-47-35.png)

- the concept of a *generative process*

## Axioms

$$
\begin{array}{l}\text { (1) } P(A) \geq 0 \text { for all } A \subset S \\ \text { (2) } P(S)=1 \\ \text { (3) If } A \cap B=\emptyset \\ \text { then } P(A \cup B)=P(A)+P(B)\end{array}
$$

## RVs

- we do not know its value but we have some knowledge about the possible states the variable could take and their corresponding probabilities
  - Discrete : countable sample space 
  - Continuous : uncountable sample space

## Distributions

- describes how likely different states of a RV are
  - function mapping between every possible outcome $x$ to a probability
  - $P(X = x)$
- Discrete : described by *pmf* , where $P(X=x)=f_{X}(x)$ and its sum is equal to 1
- Continuous : described by *pdf*, where $P(X=x)=0$ but the are under the curve must still be 1. We think of ranges of possible outcomes, but since individual values are infinite, it is not possible to assign probabilities to them.
  - It is better to think of *possibility* as *probability density* not probability
  - [Why P(X=x)=0 for PDF](https://www.youtube.com/watch?v=ZA4JkHKZM50)

## Expectation

- it represents the expected value of a random variable, the "average"/weighted sum of all the possible outcomes of an experiment

$$
\mathbb{E}[X]=\int_{x} x f_{X}(x) d x
$$

- this folds into summation for pmf

- we can define the mean of RV $X$ as just $E[X]$ , a measure of *central tendency*
- the variance of RV can also be defined in terms of expectation, $E[(X - E[X])^2], a measure of *spread*

### Expectations of functions

- We can apply functions to RVs, and we can calculate the expectation of that function

$$
\mathbb{E}[g(X)]=\int_{x} f_{X}(x) g(x) d x
$$

Note that the "scoring" function has no effect on the original pmf/pdf , it is simply a "weight" applied to it. The expectation is still doing the same process of finding the measure of central tendency, but now for the transformed/weighted values of the pdf/pmf when the scoring function acts on them

- This is a fundamental idea in decision theory and rational decision making, where the goal is to score certain actions by combining utility/scoring functions with uncertainty

## Sampling

Sample
: observed outcomes of an experiment , a.k.a observation

- *Sampling* from a distribution means simulating outcomes according to the probability distribution of those variables

### Empirical

- For discrete data, we can estimate the generating process (PMF) by simply counting each outcome and divide by the total number of trials - **empirical distribution**
  - this is a approximation of the *true, unknown* distribution whose accuracy rises with the number of samples

$$
P(X=x)=\frac{n_{x}}{N} \quad \text{, where } n_{x} \text{ is the number of times outcome } x \text{ was observed}
$$

## Random Sampling

- The reciprocal of the above. Given a certain pmf how can we generate syntethic observations according to a distribution

### Uniform

- any value within a range $[a,b]$ has equal probability of occurring
  - $X \sim U(a, b)$

> REM : In practice, not uniform across the reals since they'll have to be valid floating point values, but the different isn't important in most cases

#### Discrete Sampling

- we sample outcome according to any arbitrary PMF by partitioning the unit interval

1. choose any arbitrary ordering for the outcomes ($x_1, x_2$, ...)
1. assign each outcome a "bin" which is a portion of the interval [0,1] equal to its probability, so that the interval is divided into consecutive non-overlapping regions $\left[P\left(x_{1}\right) \rightarrow P\left(x_{1}\right)+P\left(x_{2}\right), P\left(x_{1}\right)+P\left(x_{2}\right) \rightarrow P\left(x_{1}\right)+P\left(x_{2}\right)+P\left(x_{3}\right), \ldots\right]$
1. draw a uniform sample in the range [0,1]
1. whichever "outcome bin" it lands in is the sample to draw

## Interacting Distributions 

### Joint Probability

- $P(X,Y) = P(X=x) \wedge P(Y=y)$
- for independent RVs the joint distribution is just the product of the individual distributions
  - $P(X,Y) = P(X)P(Y)$

### Marginal Probability

- $P(X)$ derived from the joint probability by integrating over all possible outcomes of $Y$
  - it allow us to compute a distribution over one random variable from a joint distribution by summing over all the possible outcomes of the other variable
- **Marginalisation** involves integrating over one or more variables from a joint distribution such that those are removed

$$
P(X)=\int_{y} P(X, Y) d y
$$

### Conditional Probability

- $P(X|Y)$
  - *"The probability of $X = x$ given that $Y = y$"*
- it should be obvious that for independent events the conditional probability folds into the probability of the event itself

$$
P(X \mid Y)=\frac{P(X, Y)}{P(Y)}
$$

## Human Friendly Manipulations

### Odds , log odds

- mostly used for readability, display of results

- **odds** of a an event with probability $p$
  - more useful unit when discussing unlikely scenarios , e.g odds of 999:1 vs $p = 0.001$
  - $\text{odds} = \frac{1-p}{p}$

- **log-odds**/logit particularly useful for *very* unlikely scenarios
  - logit scales proportionally to the number of zeros in the numerator of the odds
  - $\text{logit}(p) = \log{\frac{p}{1-p}}$

  ![](@attachment/Clipboard_2021-06-12-18-33-06.png)

### Log probabilities

- handy manipulation for computations which essentially converts products into summations
  - useful when working with for example likelihoods, and more relevant here when multiplying multiple floating point value (e.g. prob of independent vars) which can lead to underflow
  - if $P\left(X_{1}=x_{i}, \ldots, X_{n}=x_{n}\right)=\prod_{i=1}^{n} P\left(X_{i}=x_{i}\right)$, then its log counterpart is given by $\log P\left(x_{1}, \ldots, x_{n}\right)=\sum_{i=1}^{n} \log P\left(x_{i}\right)$

#### Likelihood 

- not a probability (which aims to quantify a future *prediction*) but a function of a pmf/pdf, we evaluate them at a particular point of that data and we try to ascertain how *trustworthy* the model who generated those probabilities, i.e. the distribution underlying our pmf/pdf is
  - again we use log-likelihood due to the same reasons as before , $\log \mathcal{L}\left(c_{1}, c_{2}, \ldots c_{n}\right)=\sum_{i} \log P\left(c_{i}\right)$

- likelihoods on their own and generated from the same model have no inherent meaning
  - the goal is to maximise the likelihood , the goodness of fit, hence higher value means better model

## Bayes

- useful when we want $P(A|B)$ but can only compute $P(B|A)$, i.e
  - we know how the event generator behaves $P(B|A)$ - the **posterior**
  - we know what data we saw $P(B)$ - the **likelihood**
  - we know how likely the event $A$ is regardless of evidence - the **prior**
  - we know (or can compute) $P(B)$ - the **evidence** or **marginal likelihood**

- Bayes' rule gives a consistent rule to take some prior belief and combine it with observed data to estimate a distribution *which combines them*. We always transform
from one probability distribution (prior) to a new belief (posterior) using some observed evidence. This is usually frame in terms of some **hypothesis** $H$ which we want to verify given some observed **data** $D$

$$
P(H \mid D)=\frac{P(D \mid H) P(H)}{P(D)}
$$


TODO:
- how to compute the denominator
- explain the intuitive results of the classic test accuracy example (natural frequency?)

## Entropy

- a property of a distribution which measures the level of "surprise" an observer would have when observing draws from that distribution
  - e.g. for a uniform distribution it is very hard to predict which value will come up since they all have similar probabilities, on the other hand a peaked distribution (say Gaussian) it will be much less surprising since one expects most values to come from its peak
- the entropy is a *precise quantification* usually encoded using bits, where 1 bit of information tells us what the answer to exactly one yes or no question (recall Shannon, IT). It tells us *exactly* how many bits are needed to communicate a value from a distribution to an observer *who already knows the distribution*
- entropy is just the expectation of log-probability, for a DRV
$$
H(X)=\sum_{x}-P(X=x) \log _{2}(P(X=x))
$$

#### EXAMPLE

- Consider a coin toss: this is sampling from a discrete random variable that can take on two states, heads (0) and tails (1).
  - Let $P(X=0)=q \text { and } P(X=1)=(1-q)$

  (see slides)

![](@attachment/Clipboard_2021-06-12-21-17-31.png)

## Continuous RVs

- a number of complexities arise when dealing with PMFs
  - $P(X = x) = 0$ , for all $x$ whilst everywhere in the PDF is non-zero
  - we cannot just directly sample from a PDF
  - we cannot estimate the true PDF from simple observations
  - Bayes' is difficult to compute
  - there is no concept of dimension, but we can have continuous values in vector spaces representing the probability of a RV taking on a vector value 

**Notation**

- variable ~ distribution(parameters)

- e.g.
$$
X \sim \mathcal{N}\left(\mu, \sigma^{2}\right)
$$

- "Random variable $\mathrm{X}$ is distributed as Normal with mean $\mu$ and variance $\sigma^{2}$"$

### PDF

- The PDF $f_{X}(x)$ of a RV $X$ maps a value $x$ (which can be a real number, vector or any other continuous value) to a single number, the *density* at that point.
  - assuming a distribution over real vectors , $\int_{x} f_{X}(x)=1$
- THe value of the PDF at any point **is not** a probability, because $P(X = x) = 0 , \forall\ x$. Instead we have to think of the probability of a continuous RV $X$ lying in a *range* $(a,b)$

$$
P(X \in(a, b))=(a<X<b)=\int_{a}^{b} f_{X}(x)
$$

- because a PDF maps some value in the distribution to its *density* and not a probability, its maximum value is not constrained such that it has to be less than 1. Instead, only its integral is

#### Support

- the domain it maps from where the density is no-zero , $\operatorname{supp}(x)=x \text { such that } f_{X}(x)>0$

- **Compact** : density over a fixed interval, and zero density everywhere else (e.g. uniform). Sampling from a RV with this type of PDF will always give us values in the range of this support

- **Infinite** : non-zero over an infinite domain (e.g normal). Sampling will take on *any* real value at all, but it's much more likely to be close to the peak

![](@attachment/Clipboard_2021-06-18-02-06-18.png)

### CDF

- always maps $x$ to the codomain $[0,1]$
- it tells us how much *probability mass* there is that is less than or equal to $x$
- it allows us to sample, and answer questions regarding probabilities

### Normal Distribution

- most common
  - $f_{X}(x)=\frac{1}{Z} e^{-\frac{(x-\mu)^{2}}{2 \sigma^{2}}}$ (not examinable)
- it is essentially $e^{-x^2}$ with some scaling factors to normalise it
  - it tells us that it is a faction which decays as it goes away from a centre point $\mu$ and the amount/speed it decays is represented by $\sigma$

#### Location and Scale

- parameters of importance
- **location** : where the density is
- **scale** : how spread out the density is around that point

**Normal**
- location : $\mu$
- spread : variance $\sigma^{2}$


## Central Limit Theorem

- When multiple RVs are added together their PDF behaves as if it follows a normal distribution, regardless of their individual distributions

## Multivariate Distributions

- the probability distributions of pairs of random variables,triplets of random variables, and so fort

- continuous distributions generalise PMFs (discrete) to continuous spaces over $\mathbb{R}$ via PDFs . Similarly, we can generalise densities to higher dimensional vector spaces in $R^{n}$. PDFs are then able to assign probability across an entire vector space, *under the constraint* $\int_{\mathbf{x} \in \mathbb{R}^{n}} f_{X}(\mathbf{x})=1$ , which is just equivalent to saying that if we integrate each of the dimensions independently and combine them then we must get 1

- they are similar to univariate continuous distributions, but require more parameters to specify their form, since they can vary over more dimensions


### Uniform

- characterised by assigning equal density to some box in a vector space $\mathbf{R}^{n}$, and 0 elsewhere
  - we sample *independently* from a 1D uniform distribution in the range $[0,1]$ to get each element of the vector sample which represents a draw from an n-dimensional uniform distribution *in the unit box*

$$
\int_{\mathbf{x}} f_{X}(\mathbf{x})=1, \mathbf{x} \in \mathrm{a} \mathrm{box}
$$


![](@attachment/Clipboard_2021-06-21-10-20-06.png)

#### Transformed

- recall the discussion on earlier lectures (4) about how matrices represent transformations. We can use this knowledge and apply a matrix $A$, and shift the resulting box by some offset vector $\mathbf{b}$ to recenter it so that we are no longer constrained by a axes-aligned box

![](@attachment/Clipboard_2021-06-21-10-24-15.png)

![](@attachment/Clipboard_2021-06-21-10-24-28.png)

### Normal

- generalisation of the above. Recall from above that a normal distribution is characterised by the mean and spread. In a multidimensional context we talk instead of the *mean vector* and *covariance matrix*

> REM : recall from lecture 5 how these objects captured the shape of a dataset in terms of an ellipse

- you can think of sampling from a multivariate normal distribution, simple as sampling from a normal distribution in each dimension independentely and then combine the results into a vector which is a linear combination of the random variables and hence it is itself normally distributed
  - **geometric intutition** : sampling from a unit ball with an independent normal distribution in each dimension. These samples are then transformed linearly by the cov matrix and the mean vector 

#### Joint and Marginal PDFS

- similarly to univariate gaussian, we can look at the PDF for different cov matrices and mean vectors

![](@attachment/Clipboard_2021-06-21-10-43-29.png)

- e.g. above, 2nd image varies the cov matrix pulling density closer to the center (0,0)  whilst the 3rd uses the ID matrix as its cov matrix, but shifts the center of its weight (mean vector)

!! TODO : go back to @20 for an explanation on meaning of marginal , correlation, collapsing variables !!

# Statisticcal Inference


population
: the unknown set of outcomes

sample
: subset of population which has been observed

- the parameters of a population distribution govern the generation of the samples that are observed

- our models assume that there is some unknown entity which generates data according to certain general "types" of rules *codified by a distribution* and *parameters* representing the specifics of the rules applied.

- what we want to do is to learn about things which are unknown from partial observations. In particular when performing *statistical inference* we determine these parameters by looking at the aftermath of the actions of the generative processes (samples or observations) and working backwards to their source.

> REM : we usually assume the generative process follows some specific distribution, and aim to find the parameters which we fine-tune it to our particular observations

- We can break down the "mysterious entity" generating our observations. Think of putting the entity into some box whose input is the likelihood, i.e. how likely a certain observation is to occur given a set of parameters ; which can be fine-tuned using a set of parameters ; and which can synthesise new samples given a certain input and a set of parameters. This can be done in 3 separate ways

![](@attachment/Clipboard_2021-06-21-10-57-06.png)

## Bayesian vs Frequentist

- Bayesian : params are RVs that we want to refine a distribution over ; know observed data are fixed ; we talk about *belief* in particular param settings
- Frequentist : we consider params to be fixed, but data to be random ; we talk about how we approach an accurate estimate of the true params as our sample size increases

### Estimator (Direct estimation)

- Look at observations
- Algorithmically adjust the parameters
- Adjust process to match **directly** , i.e. we calculate our statistic (e.g. $\hat{\mu}$) directly from the mean of our observations (e.g. $\mu$)

- very efficient
- we need to know the specific formulas to calculate the statistic directly, which is not always possible

### Maximum Likelihood

- compute likelihood of each observation
- tweak params to maximise likelihood
- **optimise** (usually log-likelihood)
- iterative (possibly slow) process, but widely applicable to any model where the distribution has *know likelihood function* , i.e. where we know how to compute how likely observations were to have been generated by that model

### Bayesian Inference

- completely different rationale
- we start with some belief about how the params can be set
- we treat these params as RVs in themselves
- we update our prior param beliefs by application of bayes' rule, which gives us a distribution over possible params
- we always get a distribution over possible paramaters instead of a single param setting
- harder to represent and compute, but more coherent
- require **both** priors over parameters and a likelihood function
- valid for any sample size, even though more data is still useful for updating priors

## Linear Regression

- the fitting of a line to observed data
- **assumption** : the misteryous entity generates data where one of the observed variables is a scaled and shifted version of another observed variable, *corrupted by some noise* - linear relationship
- simplest useful model of data with relationships, which can be generalised to more powerful representations

$$
y=m x+c+\epsilon
$$

- with $\epsilon$ representing the noise
- we must assume the underlying distribution generating the noise in order to construct some model. A common assumption is to choose a normal distribution, such that 

$$
y=m x+c+\mathcal{N}\left(0, \sigma^{2}\right) \equiv y \sim \mathcal{N}\left(m x+c, \sigma^{2}\right)
$$

- Our problem is: given just the inputs  $x$ and return values $y$ , what are the values of the other argument $\theta$

> see ML lectures for a more in depth discussion

## Recommended

http://nbviewer.jupyter.org/url/norvig.com/ipython/Probability.ipynb


