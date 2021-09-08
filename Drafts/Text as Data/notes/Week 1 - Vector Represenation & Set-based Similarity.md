# Week 1 - Vector Represenation &  Set-based Similarity 

<div id="content">


Embeddings
: vectors for representing words


## *"One-Hot Encoding"*

- we can represent a piece of text as a vector which has a $1$ if a term occurs in the document and a $0$ if it does not

- the dimensions of the vector are equal to the number of words in the vocabulary

- note that one can build an embedding matrix composed of the words and their vectors, if we encode the word by putting down a $1$ in the position at which the word occurs in the piece of text and $0$ elsewhere. This guarantees that all words are uniquely represented, but it also guarantees uniformity, i.e since all word vectors have weight $1$ none is seen as more important than the others
 
- if we find a new term while processing a new document which is not in our dictionary we can either add it to it, or if already blocked then we mark the new words as *OOV* or *UNK* meaning *out-of-vocavulary* and *unkown* respectively

- dictionaries can become very large, hence often we do not care about rare words, and truncate it. Alternatively we can use a hashing function to directly map vector indices


EXAMPLE:

Text : [The lighthouse sells blankets and scarves as well along with Rennie MacKintosh menswear.]

![](@attachment/Clipboard_2021-01-23-09-47-16.png)


## Set-Based Similarity

- based on sets instead of counts

### Matching Coefficients

- Consider two documents X,Y represented as a one-hot encoding
- X~Y if they contain the same tokens

Matching Coefficient
: the number of terms (dimensions) that are ≠0 , $\vert X \cap Y \vert$

Overlap Coefficient
: quotient of intersection and the size of the smallest set , $\frac{\vert X \cap Y \vert}{\min(\vert X \vert,\vert Y \vert)}$

- Think of the overlap coefficient as normalization, accounting for scaling effects, e.g $|X| = 10 \ , |Y| = 1000 \ , X \cap Y =  10$ and $|X| = 10 , \ |Y| = 20 \ , X \cap Y = 9$ clearly the second case bigger similarity even though matching coefficient is higher in the first

### Dice Coefficient

- Another normalization coefficient. It makes sure that the measure is bounded $[0,1]$ 

MATHPIX

### Jaccard

- similar to Dice

MATHPIX


EXAMPLE:

MATHPIX


### Tversky

- Generalizes Jaccard and Dice
- Uses parameters $\alpha ,\ beta \ >0$ to represent the preference of selection of $X$ or $Y$
- asymmetric measure not a metric


MATHPIX




</div>