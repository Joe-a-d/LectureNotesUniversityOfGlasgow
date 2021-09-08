# Week 6 - Classification - KNN, Bayes

***
**Lecture 8**
***

# Today 

In this chapter we will deal with classification. The eld of Machine learning can boast of many classification algorithms and this set grows on a daily basis. We have chosen to introduce just four algorithms here. The four comprise a broad foundation to classification techniques in general and knowledge of these will enable the reader to solve a wide range of classification problems and explore the rest of the literature. The four algorithms that we cover can be split into two types - those that produce probabilistic outputs and those that produce non-probabilistic outputs. Both types have their advantages and the choice will always be dataset dependent

- Non-probabilistic
  - KNN
- Probabilistic
  - Bayes
- Assessing Performance
  - 0/1 Loss
  - ROC
  - Confusion Matrix

![](@attachment/Clipboard_2021-07-20-11-52-47.png)

![](@attachment/Clipboard_2021-07-20-11-52-27.png)

![](@attachment/Clipboard_2021-07-20-11-52-55.png)

# Where we're at

we have introduced many of the main concepts that underpin
machine learning methods. We have seen how, for a particular model, we
can choose parameters and make predictions based on observed data. This has been
done in three ways { nding the parameters that minimise a loss function, nding
those that maximise a likelihood function and by treating the parameters as random
variables

# General Problem

- A set of $N$ training objects with $x_n$ attributes
- For each object we have a label $t_n$ which describes which class an object belongs to
- **GOAL**
  - given an unseen object , predict its label **t**
  - similar to regression but in most cases our target value is not an output of the function we're target to model, instead are interested in creating a *decision boundary* which allow us to categorise the targets
- the classifier is trained on **x_1,...,x_n** and **t_1,...t_n** and then used to classify **x_new**

## Probabilistic Vs Non-Probabilistic

- **Probabilistic**
  - produce a probability of a class membership
  - $P\left(t_{\text {new }}=k \mid \mathbf{x}_{\text {new }}, \mathbf{X}, \mathbf{t}\right)$
  - e.g. in binary classification , $0 \leq k \leq 1$
  - allow us to quantify the uncertainty of our model
    - particularly important where cost of misclassification is high and imbalanced (e.g. medical diagnosis)
    - **but** this extra information comes at a cost ; computationally expensive. Hence, for large datasets NP might be prefered

- **NP**
  - produce a **hard** assignment
  - e.g. 1 , 0 **or** some other class


# NP - K-Nearest Neighbours

- Suitable for binary or multi-class
- No "training" phase

1. Choose $K$
  - the number of neighbours the algo will look at
1. For a test object $\mathbf{x_{\text{new}}}$
  1. Find the $K$ closest points from the training set
    - usually euclidean distance
  1. Find the *majority class* of these $K$ neighbours
    - assign randomly in case of a tie

![](https://miro.medium.com/max/1080/0*49s1xDlDKDsn55xa.gif)

### Example 

- each test point in the boundary is at the same distance from two competing labels

- Too complex
  - note the islands

![](@attachment/Clipboard_2021-07-20-16-36-52.png)

- The ridges form when there are a lot of ties

![](@attachment/Clipboard_2021-07-20-16-37-04.png)

- Much smoother
  - decreased the random guessing

![](@attachment/Clipboard_2021-07-20-16-37-26.png)

- Very smooth

![](@attachment/Clipboard_2021-07-20-16-37-42.png)

### Example 2 - Binary Data

- harder because boundary is more circular, not linear
- too complex
  - risk of overfitting ; note the blue circle amongst the red (most likely an outlier) being singled out

![](@attachment/Clipboard_2021-07-20-16-39-00.png)

- random effects

![](@attachment/Clipboard_2021-07-20-16-39-07.png)

- smoother

![](@attachment/Clipboard_2021-07-20-16-39-13.png)

![](@attachment/Clipboard_2021-07-20-16-39-23.png)

## Limitations

### Class Imbalance

- As $K$ increases, small classes will disappear
- Imagine we had 5 objects of C1 and 100 of C2
  - For $K \geq 11$ C2 will always win
  - Max(C1) = 5 , hence every time you pick 11 test points you'll always get at least 6 C2

- How to choose $K$ will depend on the data, and will require **cross-validation**

## Cross-Validation

- split the data up like explained before
- measure of goodness
  - number of misclassifications
  - average over the C folds

### Example

![](@attachment/Clipboard_2021-07-20-16-55-13.png)

![](@attachment/Clipboard_2021-07-20-16-55-22.png)

![](@attachment/Clipboard_2021-07-20-16-55-43.png)

# Bayes Classifier

$$
P\left(T_{\text {new }}=c \mid \mathbf{x}_{\text {new }}, \mathbf{X}, \mathbf{t}\right)=\frac{p\left(\mathbf{x}_{\text {new }} \mid T_{\text {new }}=c, \mathbf{X}, \mathbf{t}\right) P\left(T_{\text {new }}=c \mid \mathbf{X}, \mathbf{t}\right)}{p\left(\mathbf{x}_{\text {new }} \mid \mathbf{X}, \mathbf{t}\right)}
$$

by expanding the marginal likelihood to a sum over the C possible cases

$$
P\left(T_{\text {new }}=c \mid \mathbf{x}_{\text {new }}, \mathbf{X}, \mathbf{t}\right)=\frac{p\left(\mathbf{x}_{\text {new }} \mid T_{\text {new }}=c, \mathbf{X}, \mathbf{t}\right) P\left(T_{\text {new }}=c \mid \mathbf{X}, \mathbf{t}\right)}{\sum_{c^{\prime}=1}^{C} p\left(\mathbf{x}_{\text {new }} \mid T_{\text {new }}=c^{\prime}, \mathbf{X}, \mathbf{t}\right) P\left(T_{\text {new }}=c^{\prime} \mid \mathbf{X}, \mathbf{t}\right)}
$$

- we need to define
  - the likelihood of the unobserved object belonging to the $c$th class
  - the prior probability of the $c$th class

## Likelihood

$$
p\left(\mathbf{x}_{\text {new }} \mid t_{\text {new }}=k, \mathbf{X}, \mathbf{t}\right)
$$

- The likelihood is not necessarily a probability, it could be a pdf
- How likely is **x_new** if it is in class $k$?
  - Though dependent on the data, we are free to define this *class-conditional* distribution as we like
  - e.g. 
    - D-dimensional vectors of real values - Gaussian
    - coin tosses - Binomial
- Regardless, the training data with $t = k$ is used to determine the parameters of the likelihood for the class $k$
  - e.g. Gaussian mean and covariance

## Prior

$$
P\left(T_{\text {new }}=c \mid \mathbf{X}, \mathbf{t}\right)
$$

- the probability that the object belongs to class $c$ conditioned on just the training data, **X, t**. 
- It enables us to specify any prior beliefs in the class of **x_new** before we see it
  - we can for e.g. adjust (in advance) the bias against a certain class which is extremely rare, so that e.g. we only classify it as that class if the likelihood is very high

- The only restrictions in the choice of our prior is that they are positive and sum to 1. Popular choices include
  - Uniform : $P\left(T_{\text {new }}=c \mid \mathbf{X}, \mathbf{t}\right)=\frac{1}{C}$
  - Class size : $P\left(T_{\text {new }}=c \mid \mathbf{X}, \mathbf{t}\right)=\frac{N_{c}}{N}$
    - $N$ - training set objects
    - $N_c$ - training set objects belonging to class $c$

> Note that, although we have written the prior as being conditioned on **X** and **t**, it is not necessarily dependent on them. Neither example above uses **X** in the prior definition and only the second example uses **t** (through **Nc**).

#### Example

- **see pages 170-72**

### Naive Bayes

- assumes that the D-dimensional class-conditional distributions can be factorised into a product of D univariate distributions.    
  - i.e. **conditioned on a particular class, the dimensions (e.g. x1 and x2) are independent**

$$
p\left(\mathbf{x}_{n} \mid t_{n}=k, \mathbf{X}, \mathbf{t}\right)=\prod_{d=1}^{2} p\left(x_{n d} \mid t_{n}=k, \mathbf{X}, \mathbf{t}\right)
$$

#### Example - Gaussian

![](@attachment/Clipboard_2021-07-20-18-28-31.png)

- for each class we compute the mean and variance for the points belonging to that class to get the parameters for the likelihood

![](@attachment/Clipboard_2021-07-20-18-28-42.png)

![](@attachment/Clipboard_2021-07-20-18-28-48.png)

![](@attachment/Clipboard_2021-07-20-18-29-39.png)

- once you fix **x_new** we can just evaluate the probaility of it being in a class using the bayes rule

![](@attachment/Clipboard_2021-07-20-18-29-46.png)

- the contours can be drawn by "inverting" our question, i.e. we fix the probability and ask where the **x_new**s that satisfy that probability would be
  - as expected, we see that as we move away from the center of mass of the class the probability diminishes

![](@attachment/Clipboard_2021-07-20-18-29-53.png)

![](@attachment/Clipboard_2021-07-20-18-30-04.png)

![](@attachment/Clipboard_2021-07-20-18-30-15.png)

#### Example - Binomial

![](@attachment/Clipboard_2021-07-20-18-30-36.png)

- note that we average over a class, hence the $N_k$ constant, since the classes may be of different size

![](@attachment/Clipboard_2021-07-20-18-30-46.png)

- we can draw the contours by evaluating at all possible values of $x$ [0,20]
- recall that we are not trying to measure the fairness of the coin, we are trying to see if given a new output of another round of tosses we can identify the coin being tossed
  - as you can see the coins are both biased, one towards heads and one towards tails

![](@attachment/Clipboard_2021-07-20-18-47-17.png)

# Performance Evaluation

- Below we are interested in assessing the performance based on the predictions for some set of $N$ independent test examples, **x1,...,xn** with known labels **t1\*,...,tn\*** and labels predicted by the classifier **t1,...,tn**
  - the known labels could be from data held out in CV or from an independent dataset

## 0/1 Loss

- proportions of times the classifier is wrong
- **advantages**
  - binary or multiclass
  - simple to compute
  - single value
- **disavantage**
  - doesn't take into account class imbalance
  - e.g. assume only C1 only 1%
    - model always predict C2
    - accuracy 99%
    - model is not good
- Mean loss
  - $\delta(a)$ is 1 if a is true and 0 otherwise
 $$
\frac{1}{N} \sum_{n=1}^{N} \delta\left(t_{n} \neq t_{n}^{*}\right)
$$


## Sensitivity and Specificity

- Case Study, detecting a disease
  - $t=0$ : healthy
  - $t=1$ : diseased
- We define the following four summary values from our classification results

$$
\begin{array}{l}\text { True positives (TP) - the number of objects with } t_{n}^{*}=1 \text { that are classified as } \\ t_{n}=1 \text { (diseased people diagnosed as diseased). } \\ \text { True negatives (TN) - the number of objects with } t_{n}^{*}=0 \text { that are classified } \\ \text { as } t_{n}=0 \text { (healthy people diagnosed as healthy). } \\ \text { False positives (FP) - the number of objects with } t_{n}^{*}=0 \text { that are classified as } \\ t_{n}=1 \text { (healthy people diagnosed as diseased). } \\ \text { False negatives (FN) - the number of objects with } t_{n}^{*}=1 \text { that are claspified } \\ \text { as } t_{n}=0 \text { (diseased people diagnosed as healthy). }\end{array}
$$

- **Sensitivity**
  - the proportion of the diseased people (TP +FN) that we correctly classify as being diseased (TP)
  - the higher the better
$$
S_{e}=\frac{T P}{T P+F N}
$$
- **Specificity**
  - the proportion of all of the healthy people (TN + FP) that we correctly classify as being healthy (TN)
  - the higher the better

$$
S_{p}=\frac{T N}{T N+F P}
$$

- these two quantities tell us how good we are at detecting
diseased and healthy people, respectively
- In our example, we have high specificity but very low (0) sensitivity
  - the right pair of metrics is application dependent, and usually involves trade offs
    - e.g. in our example we are probably ok with a higher rate of false positives (lower specificity) given that we do not misdiagnose diseased people (higher sensitivity)

- We can combine these two metrics by evaluating the area under the **receiver operating characteristic curve**

## ROC - AUC


- many classifications involve setting a threshold, the ROC curve shows how $S_e$ and $1 - S_p$ vary as the threshold changes
  - with the **disavantage** that it does not generalise to the multiclass setting, unless we analyse the results of the classification as several binary problems

![](@attachment/Clipboard_2021-07-20-21-16-54.png)

- better, since it is as close to the top left corner, i.e. both values are very close to 1

![](@attachment/Clipboard_2021-07-20-21-17-19.png)

- the higher the area under the curve, the closer to the top left corner it is, hence the better our classifier's performance is

- the AUC is just the probability that a randomly selected positive example will have a higher probability than a randomly selected negative one, hence we can compute it directly without drawing the ROC curve

$$
\begin{array}{l}N_{p}: \text { number of positive instances } \\ N_{n}: \text { number of negative instances } \\ y_{1}, \ldots y_{N_{p}}: \text { score for the positive instances } \\ x_{1}, \ldots x_{N_{n}}: \text { score for the negative instances } \\ \qquad A U C=\frac{1}{N_{p} N_{n}} \sum_{i=1}^{N_{p}} \sum_{j=1}^{N_{n}} \delta\left(y_{i}>x_{j}\right)\end{array}
$$

## Confusion Matrices

- The four summary values introduced above are often visualised in a table
  - predicted **t** Vs True **t\***
  - this is essentially what a confusion matrix is for a binary classifier

![](@attachment/Clipboard_2021-07-20-21-33-25.png)

- Confusion matrices are far more useful for multiclass problems
  - the diagonal elements represent the number of points for which the predicted label is equal to the true label
  - the off-diagonal elements are those that are mislabelled by the classifier
  - the higher the diagonal values of the confusion matrix the better, indicating many correct predictions
  - note that this not only quantifies performance but it also provide suggestions for how to improve performance, since we can see where the mistakes are being made
    - e.g. maybe confused classes could be joined , maybe need more data

![](@attachment/Clipboard_2021-07-20-21-54-57.png)

- Below we have the same matrix normalised by class support size (number of elements in each class)
  - this can be useful in case of class imbalance since we can better see which class is being misclassified

![](@attachment/Clipboard_2021-07-20-21-57-21.png)