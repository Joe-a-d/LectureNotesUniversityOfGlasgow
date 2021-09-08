# Week 1 - Processing Text

<div id="content">

# Processing Text - Normalization

A common task within text data analysis is to characterise a piece of text, i.e to figure out what the text is about.

In order to perform this task it is important to convert the text into a working state by removing for example markup and filler words which are not relevant to its meaning. This process of cleaning/processing the text can be represented as a *pipeline*, i.e a bunch of programs or processes which act on the original text the interim artefacts.

![](@attachment/Clipboard_2021-01-12-11-32-34.png)

Text
: string or streams of characters

Corpus
: computer-readable selection of text or speech 

Aboutness
: The semantics of a piece of text

Word
: context-dependent atomic parts of the text. 

> REM Words are context-dependent because when performing certain tasks one might decide to include or exclude certain parts of the text. For example, fillers such as `um` are probably unnecessary if the aim is to transcribe speech, however if one wants to estimate the mental state of the speaker then these become relevant, since they may signal hesitation, nervousness, insecurity etc.

### Morphology

Morphology
: the study of the way words are built up from smaller *meaning-bearing* units called morphemes

Morpheme
: a small meaningful unit that makes up words

Stems
: the core *meaning-bearing* units

Affixes
: the bits added to the root word 

> EXAMPLE  ` UN - FRIEND - LY` ; UN - Affix (prefix) ; FRIEND - Stem ; LY Affix (suffix)

## Tokenization

Tokenization is run before any language processing, hence it needs to be very fast. An example of a commonly used standard is the *Penn Treebank* standard which separates clitics, keeps hyphenated words together and separates out all punctuation. In order to apply these standards, deterministic algorithms based on regular expressions compiled into very efficient finite state automata are used 

Tokenization
: the act of segmenting running text into words


Clitic
: a part of a word that *can not* stand on its own , e.g. `'re` in `we are`


N-gram
: treating groups of $N$ elements as a single element

> EXAMPLE `The cat sat on the mat`
    Bigrams : `["The cat", "cat sat" ...]`
  
> REM n-grams can also be  performed within words


### Byte-Pair Enconding

Another option to tokenize text is to use BPE which estimates the appropriate size of tokens according to the data itself. 

The BPE algorithm allows for the existence of *subwords* as tokens, which aids when dealing with previously unseen words. So, whilst the majority of tokens will still be words, some frequent morphemes and other morphemes are also included so that unseen words can be represented by combining parts.

> REM the algorithm is an adapted version of its original intended purpose , compression of text.

**ALGORITHM**
- INPUT : A dictionary of words and their counts
- OUTPUT : A vocabulary of size $k$

**STEPS**
1. Add and *end-of-word* symbol to the vocabulary (e.g `_`)
2. Count the pairs
3. Replace the most frequent pair `(X,Y)` with the new symbol `XY`
4. Repeat `k` times where `k` is a parameter of the algorithm

> REM the algorthm is run inside words only, there is no merging across word boundaries

**TWO ITERATIONS**

![](@attachment/Clipboard_2021-01-12-13-50-22.png)

![](@attachment/Clipboard_2021-01-12-13-50-30.png)

In the first image we have the pre-tokenized words, their counts, and the vocabulary (in this case the set of characters which appear at least once). We then look at each word and count the frequency of each pairing , e.g `ow` , `ne` etc. In this case `r_` is the most common pair since it appears 9 times in total, 6 in `newer` and 3 in `wider`, so we *merge* the two symbols add it to the vocabulary and repeat the process

![](@attachment/Clipboard_2021-01-12-13-58-04.png)
![](@attachment/Clipboard_2021-01-12-13-58-13.png)

Now, say that after a few more iterations, we get the following vocabulary

![](@attachment/Clipboard_2021-01-12-14-04-37.png)

 If while tokenizing a new set of words we came across the previously unseen word `lower` then we would tokenize it as `[low, er]` whilst the previously seen word `newer` would be tokenize as a full word.

 > REM Note that even in this small example there are other previously seen words , such as `wider`, which would be split up. This wouldn't happen in practice, since the algorithm would be run many thousands of times over a very large dictionary, which would mean that most words will be represented in the final vocabulary 

 \mymarginpar{see Jurasky 20 for the full implementation}

### Wordpiece Algorithm

Another possible algorithm is the *wordpiece* algorithm, which differes from BPE in that :

1. the special word boundary token appears at the start of words instead of at the 

2. it merges the pairs that minimise the language model likelihood of the training data, 

Expanding on (2), the goal here is to check the impact that merging a given pair will have on the final model. But how? With the help of *language models*. 

At each iteration, we choose the character pair which will result in the largest increase in likelihood once merged. 

$$MAX(\ P(x_iy_i) - (P(x_i) + P(y_i))\ )$$

This is the difference between the probability of the new merged pair occurring minus the probability of both individual tokens occurring individually. For example, if `“de”` is more likely to occur than the probability of `“d” + “e”`

Language Model
: a probability distribution over sequences of words. Given such a sequence, say of length $m$, it assigns a probability $P(w_{1},\ldots ,w_{m})$ to the whole sequence.





> REM this algorithm is used in [BERT](https://arxiv.org/abs/1810.04805v2), a popular language representation model used to pre-train ML models



## Lemmatization

One process of text normalisation is that of lematization. For example, take the words `better` and `thinking` they are derived from `good` and `think`, so when analysing the text we can group them together under their root (much like in a dictionary).

> EXAMPLE
    - INPUT : She went to the shop and bought oranges
    - OUTPUT : She *go* to the shop and *buy* *orange*


- uses context to be more precise (e.g. identifying if the word is a verb or a noun), hence it is a slower processing method


Lemmatization
: the task of determining that two words have the same root

Lemma
: a **set** of lexical forms having the same *stem*, the same major part-of-speech and the same *word sense*

Word Sense
: a specific meaning of a *polysemous* lemma. e.g mouse (animal vs I/O device)

Propositional Meaning
: when replacing a word by another does not change the truth value of a proposition

Principle of Contrast
: synonyms , which are different in form, still represent a difference in meaning. This is useful because it allow us to draw context, e.g 'H20' is appropriate within a scientific context, water is casual.

Wordform
: the full inflected or derived form of the word

Another way we can talk about words in a corpus is by differentiating between *word types* and *word tokens*

Word Type
: the number of *distinct* words in a corpus

Word Tokens
: the total number of running words

So, for a set of words in a vocabulary $V$ the number of types is $\vert V \vert$ and the number of tokens is given by the total number of words $W$ 

An useful result which relates these two concepts, describing the number of types as a function of the document's tokens, is *Herdan's Law*

Herdan's Law
: For large corpus the vocabulary size grows much faster than the squared root of its length. For $k, \Beta > 0 \text{ and } 0 < \Beta < 1$ $$\vert V \vert = kN^\Beta$$

## Stemming

Given the complexity of lemmatization algorithms often simpler methods are chosen in their favour, one of the simplest being *stemming*

Stemming
: reducing inflected words to their stem

> REM given its simplicity it may be the case that the output may not be a word (e.g `stranger - er = strang)`

### Porter Stemmer

The most common stemming algorithms is the *Porter Stemmer* which applies simple substitution rules in cascade.

> EXAMPLE A sample of the rules 

- plurals and `-ed` or `-ing`
  - caresses  ->  caress
  - ponies    ->  poni

- map double suffices to single ones.
  - `-ization` ( = `-ize plus -ation` ) maps to `-ize`


## Tokenization Complications

- easy but hard to do well :
  - contractions
  - numbers
  - multiword expressions (*rock 'n' roll*)
  - useful punctuation (*Ph.D*)
  - URLs
  - Runaway tokens (hashtags)




# References

https://huggingface.co/transformers/tokenizer_summary.html#byte-pair-encoding

https://blog.floydhub.com/tokenization-nlp/#wordpiece


</div>