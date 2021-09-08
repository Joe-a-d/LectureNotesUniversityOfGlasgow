# Week 3 - Language Modelling

<div id="content">

lecture goal : introducing models that assign a probability to each possible next word, or entire sentence.

## Motivation

Systems such as speech recognition, spelling/grammatical correction or machine translation work in noisy environments. Probabilities are essential here, since the inputs would be ambiguous, so the models help bridge the gap between the input and the intended meaning

## N-Grams

Language Models
: models that assign probabilities to sequences of words

The simplest LM is the *n-gram*, where the *n* stands for the number of words in a sequence, e.g. * the cat sits on the mat"* would be a 6-gram.

One of the tasks we might want to do is computing the probability of a word $w$ appears follows some history $h$, i.e calculating $P(w \mid h)$. One way to estimate this probability is from relative frequency counts, we choose a large enough corpus and essentially find the proportion of times the word follows the history

$$P(\text{the} \mid \text{its water is so transparent that}) = \frac{C(\text { its water is so transparent that the })}{C(\text { its water is so transparent that })}$$

Though this may work in a lot of cases, even the web is not a large enough corpus to give good estimates in most cases. Even simple extensions to common sentences break, furthermore if one was to try and calculate the joint probability of an entire sequence, even for relatively small $n$ the counts of all possible sequences would make it unmanageable.

### Probabilities and Distributions Primer

Bayes Theorem
: $$P(A \mid B) = P(B \mid A) \ \frac{P(A)}{P(B)}$$

Chain Rule
: $$P(w_{1:n}) = \prod_{k=1}^{n}P(w_k \mid w_{1:k-1})$$

where $w_{1:n}$ represents a sequence of $n$ words

Random Variable
: a function $X: S \to R$ which associates a unique numerical value $X(s)$ with every outcome $s$ in the sample space [^1]

Probability Distribution
: a function which associates all possible values of a random variable with their probability within a given range


The intuition behind the n-gram model is that instead of computing the probability of a word given its entire history, we can approximate the history by just the last few words. The bigram model, for example, approximates $P\left(w_{n} \mid w_{1: n-1}\right)$ by using *only* the conditional probability of the preceding word $P(w_n \mid w_{n-1})$

Markov Assumption
: the assumption that the probability of a word depends only on the previous word

If we now make use of this assumption, we can generalise the n-gram model approximation which looks $n-1$ words into the past

$$
P\left(w_{n} \mid w_{1: n-1}\right) \approx P\left(w_{n} \mid w_{n-N+1: n-1}\right)
$$

and given this approximation for the probability of an individual word, we can compute the probability of a complete word sequence

$$
P\left(w_{1: n}\right) \approx \prod_{k=1}^{n} P\left(w_{k} \mid w_{k-1}\right)
$$

Context Window
: determines how many words are included in the history, e.g. the context window for the bigram model would be 1

Order
: the size of the context window over the n-gram length


> EXAMPLE Given the sequence [the dog barks], calculate $P(\text{barks} \mid \text{the, dog})$
• “the dog barks” occurs 56 times in a text collection
• “the dog” occurs 1190 times in a text collection
• What is the ‘order’ of this model?


### MLE

We can estimate these bigrams probabilities via MLE, which can be done by getting the counts from a corpus and *normalising* them so that they lie between 0 and 1.

$$
P\left(w_{n} \mid w_{n-1}\right)=\frac{C\left(w_{n-1} w_{n}\right)}{\sum_{w} C\left(w_{n-1} w\right)}
$$

Here we calculate the the count of the bigram $C(w_{n-1}w_n)$ and normalise by the sum of all bigrams *that share the same first word* $w_{n-1}$

We can simplify this equation further, since the sum of all bigram counts that start with a given word $w_{n-1}$ must be equal to the unigram count for that word

$$
P\left(w_{n} \mid w_{n-1}\right)=\frac{C\left(w_{n-1} w_{n}\right)}{C\left(w_{n-1}\right)}
$$

### Study Case

Take the following corpus

> I am Sam
> Sam I am
> I do not like green eggs and ham

We start by augmenting each sentence with start and end tokens

> \<s> I am Sam \</s>
> \<s> Sam I am \</s>
> \<s> I do not like green eggs and ham \</s>

Some of the bigram probabilities 
$$
\begin{array}{lll}P(I \mid<\mathrm{S}>)=\frac{2}{3}=.67 & P(\operatorname{Sam} \mid<\mathrm{S}>)=\frac{1}{3}=.33 & P(\mathrm{am} \mid \mathrm{I})=\frac{2}{3}=.67 \\ P(</ \mathrm{S}>\mid \mathrm{Sam})=\frac{1}{2}=0.5 & P(\mathrm{Sam} \mid \mathrm{am})=\frac{1}{2}=.5 & P(\mathrm{do} \mid \mathrm{I})=\frac{1}{3}=.33\end{array}
$$


> REM to avoid underflow of very small numbers, and because adding is faster than multiplying we do probability computations using $\log$
</div>


## Unseen Words - Smoothing

OOV
: out of vocabulary word

OOV rate
: the percentage of OOV words that appear in the test set

Smoothing
: a technique for estimating probabilities for unseen words

If the model has not encountered the word before, then $P(new_word) = 0$ . If the words exist in our vocabulary but appear in our test set in an unseen context, e.g. after a word they never appeared after in training then we can prevent the model for assigning zero probability to this event by apllying *smoothing* or *discounting*.

Smoothing works by shaving off some of the probability mass from some more frequent events and give it to never before seen events

### Laplace & Add-K

Laplace smoothing is the simplest way to do smoothing. It works by adding one to all the bigram counts, before they're normalised into probabilities. In this way, all the counts that would've been zero will have now count 1.

Though Laplace doesn't really perform well in modern n-gram models it is useful to introduce some of the fundamental concepts of smoothing.

Unigram probability of the word $w_i$

$$P(w_i) = \frac{c_i}{N}$$

Instead of changing both the numerator and denominator we can describe how a smoothing algorithm affects the numerator defining an *adjusted count* $c^*$. This makes it easier to compare directly with the MLE counts, and can be turned into a probability by normalising by $N$

We can define this count by multiplying by a normalisation factor $\frac{N}{N+V}$

$$c_i^* = (c_i+1)\frac{N}{N+V} \qquad  P_i^*(w_i) = \frac{c_i^*(w_i)}{N}$$

Let's take our original bigram probability 

$$
P\left(w_{n} \mid w_{n-1}\right)=\frac{C\left(w_{n-1} w_{n}\right)}{C\left(w_{n-1}\right)}
$$

For add-one smoothed bigram counts, we augment the unigram count by the number of word types in the vocabulary V

$$
P_{\text {Laplace }}^{*}\left(w_{n} \mid w_{n-1}\right)=\frac{C\left(w_{n-1} w_{n}\right)+1}{\sum_{w}\left(C\left(w_{n-1} w\right)+1\right)}=\frac{C\left(w_{n-1} w_{n}\right)+1}{C\left(w_{n-1}\right)+V}
$$

Add-K smoothing is similar, but instead of increase the frequency by 1 we increase it by some $k$

### Backoff & Interpolation

For interpolated smoothing we draw on probability of lower order models, e.g. if one wants to calculate a probability of a trigram, but we do not have any example trigrams, we can use the probability of a bigram to estimate it.

If when trying to estimate an n-gram we can *backoff* has many orders as necessary until we have enough evidence.

When using interpolation one mixes the probability estimates from all the n0gram estimators, weighing and combining the counts of the trigram, bigram , etc. 

> EXAMPLE trigram probability with back-odd to bigram and unigram
$$
\begin{aligned} \hat{P}\left(w_{n} \mid w_{n-2} w_{n-1}\right)=& \ \lambda_{1} P\left(w_{n} \mid w_{n-2} w_{n-1}\right) \\ &+\lambda_{2} P\left(w_{n} \mid w_{n-1}\right) \\ &+\lambda_{3} P\left(w_{n}\right) \end{aligned}
$$
$$
\sum_{i} \lambda_{i}=1
$$

The parameter $\lambda$ are learned from a *held-out* corpus. One chooses the $\lambda$ which maximise the likelihood of that corpus

## Evaluating Models

Extrinsic Evaluation
: embed the model in an application and measure how much the application improves (end-to-end)

Intrinsic Evaluation
: measures the quality of a model independent of any application


Ideally one would aim to preform extrinsic evaluations, however these are are expensive, so occasionally one must resort to intrinsic analysis. For an intrinsic evaluation a *test set* is required so that we can apply our model to previously unseen data and measure its performance against the training set


## Entropy



## Modelling Documents


## Document Similarity


[^1]: Alexey Lindo, Statistics 2R *Probability* lecture notes, 2019