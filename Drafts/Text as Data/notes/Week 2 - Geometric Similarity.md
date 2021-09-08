# Week 2 -  Geometric Similarity

<div id="content">


## Motivation


**Distributional Hypothesis** - words that occur in similar contexts tend to have similar meanings

Our goal is to use *vector semantics* to instantiate the dist hypothesis, encoding word meanings as vectors in space *embeddings* from their distribution in text


## Word Similarity

Here we look at relations between words instead of their senses. E.g 'cat' ≠ 'dog' but 'cats' similar to 'dogs', plural. 

This perspective is useful for language understanding tasks such as *question answering, paraphrasing and summarization*

## Word Relatedness/Association

**Semantic Field** - a set of words which cover a particular semantic domain and bear structure relations with each other (e.g hospitals : surgeon, doctor, nurse)

Here we look at other relations between meaning of words other than similarity, for example `coffee` and `cup` are very disparate objects, but they often occur together. It is easy to associate them in our minds with the activity of `drinking coffee`. In order to find these associations we can see if they belong to the same *semantic field*. Alternatively `topic models` such as LDA can use unsupervised learning methods to induce sets of associated words from large *corpus*

## Semantic Frames & Roles

**Semantic Frame** - similar to SF it denotes the *perspectives* or *participants* in a event. E.g "A buys C from E" , here the frame could be `transaction`. Within the frame words can take *semantic roles* and by recognizing these roles we can build question answering systems or shift perspective when using machine translation, e.g in order to understand "What did E buy?" there needs to be an understanding of E as the `buyer` and `C` as the object being bought. We can go a step further and even derive answers to "What was sold?" even though the verb `sell` never appears in the sentence, if we shift the perspective from `buyer - seller` -> `buy/purchase - sell`


## Connotation

**Connotation** - the aspects of a word's meaning that are related to a writer or reader's emotions (happy, sad)

**Sentiment** - positive or negative evaluations (great, love)

*Osgood 1957* found that the affective meaning of words varies across 3 dimensions : 

- valence : the pleasantness of the stimulus (happy vs unhappy)
- arousal : the intensity of emotion provoked by the stimulus (excited vs calm)
- dominance : the degree of control exerted by the stimulus (important vs influenced)

The key insight here is that by assigning numbers to these dimensions we can represent a word as a point in a 3D space

# Vector Semantics

Vector semantics combine two intuitions: *the distributionalist intuition* where we define a word by counting what other words occur in its environment, and the vector intuition which says that we can represent a word by a vector in a $N$-dimensional space where $N$ represents the attributes of the words we think are relevant.

Vector models of meaning are now the standard way to represent the meaning of words, one model often used as the baseline is the `tf-idf` in which the meaning of the word is just defined by a vector composed of counts of nearby words. This has the problem of creating too sparse vectors however. Hence, often the `word2vec` model is used which constructs much more dense vectors.

In order to compute similarity from vectors we use `cosine similarity` which will be discussed below.

## Words & Vectors

**Co-occurrence Matrix** - a matrix which represents how often its rows (e.g words) occur within the same column (e.g book)

**Vector Space Model** - representing a document as a count vector

*Salton 1971* introduced the idea of a *vector space model* , we can build  a co-occurrence matrix for a collection of documents by representing each word as entries of the matrix and each document as a columns **term-document matrix**. The assumption behind this representation is that documents with similar words will be similar, hence their vectors will be similar.

In general for a vocabulary $V$ and $D$ documents one has $M_{|V| \times D}$

![](@attachment/IMG_304D13DC335D-1.jpeg)

![](@attachment/IMG_139EF549C93D-1.jpeg)

### Words as Vectors

Similarly to the document vector space model, we can represent the meaning of words as vectors. Following from the same shakespeare plays example, we can represent each word as a row vector and have the plays as the columns of the matrix. Each entry would then be filled with the number of times a word appears in a given play - *term-document* matrix. Then, following from the similarity-occurence assumption we say that two words are similar if they appear roughly in the same proportion in the same documents.

Term-Term matrix
: matrix representation of word counts in documents


An alternative (and more common way) of representing words however is via a *term-term* matrix a.k.a *word-word matrix* where the columns are labeled by words rather than documents. Here we record the number of times a word co-occurs in the same context in some training corpus. Context could be the whole document or same predefined window , e.g word +- 4

![](@attachment/Clipboard_2021-01-23-10-00-36.png)
![](@attachment/Clipboard_2021-01-23-10-00-48.png)


Note that $\vert V \vert$ is generally the size of the vocabulary, so it suffers from the curse of dimensionality. Hence we often don't keep words after about the most frequent 50k. Also often efficient algorithms which can store can compute sparse matrices are used since most of the entries will be 0

# Measuring Similarity

## Cosine Similarity

**Cosine Similarity** - a measure of similarity between two non-zero vectors of an inner product space

- most common
- based on the dot product
  - because it tends to be high just when the two vectors have large values in the same dimensions
  - while orthogonal vectors (zeros in different dimensions) will have a dot product of zero

- dot product favours long vectors, hence we use its normalised version which turns out to be the same as the cosine of the angle between the two vectors 

MATHPIX

Hence, the cosine similarity between two vectors is computed by taking the quotient of their product with the product of their norms


REM : sometimes we'll first normalize the vectors by transforming them into unit vectors

EXAMPLE

![](@attachment/Clipboard_2021-01-23-10-27-09.png)

![](@attachment/Clipboard_2021-01-23-10-27-25.png)


## Raw Term Frequency Problems 

Relying solely on a document's term-frequency brings about some problems:

1. aboutness does not increase linearly with term frequency, i.e. a document where a word occurs 10x times than in other documents is not 10x more relevant

2. all terms are considered equally important, but for example if we are looking at a corpus regarding the "car industry" then words such as "car, auto, vehicle" do not help distinguish between documents. So we need a way to *attenuate* the effect of terms that occur too often

## Sublinear TF scaling

We can address problem 1 by scaling the frequency weights, and the most common technique is to use *log frequency*

MATHPIX

## TF-IDF - Weighing terms 


The tf-idf algorithm tackles problem 2. Because stop words such as *the* and other words which appear too often in a certain context can bias our results, and are not helpful, we put extra weight on words which appear only on certain documents

Document Frequency (df)
: the number of documents a term appears on

Note however that df is in innverse measure of the informativeness of $t$, i.e. a low df implies higher weight. So instead we use the *inverse document frequency* statistic, and we often scale it so dampen its effect

Inverse Document Frequency
: MATHPIX

Finally, we can combine tf with idf to generate a new weighted value **tf-idf**

td-idf
: Let $w_{t,d}$ represent the weighted value for word $t$ in document $d$, then $$w_{t,d} = tf_{t,d} \times idf_t$$


![](@attachment/Clipboard_2021-02-02-13-25-16.png)


This is the best know weighting scheme for text similarity, and it is often used instead of counts when calculating cosine similarity 

### Variants

![](@attachment/Clipboard_2021-02-02-13-46-26.png)


EXAMPLE
: Consider a document containing 100 words wherein the word *cat* appears 3 times. Now, assume we have 10M documents and the word *cat* appears in 1K. State:
: 1. `tf(cat)`
: 2. `idf(cat)`
: 3. `tf-idf(cat)`
: &nbsp;
: 1. 3
: 2. $\log(10^6/10^3)$ = 4
: 4. $tf * idf = (1+\log_2(3)) \times 4 = 10.34$




</div>