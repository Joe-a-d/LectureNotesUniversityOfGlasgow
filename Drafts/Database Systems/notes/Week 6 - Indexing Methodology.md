# Week 6 - Indexing Methodology

- Index data structures (trade-off between search speed and overhead in storage and maintenance)
  - primary index
  - clustering index
  - secondary index

- Multi-level index strucutes
  - ISAM search Tree
  - B Tree & B+ Tree

- **Challenge** : expedite search by splitting the space into more than two subspaces

- **GOAL** : contrasting with physical design where our goal was to find a *primary access path* based on a *specific* searching fieldwhen given a *specific file type* , our goal here is to find a *secondary access path* given *any* file type and using *any* search field
  - this will mean that we'll require additional meta-data to be stored and mantain
  - **upside** being that we can avoid linear scan and significantly speed up search
   

![](@attachment/Clipboard_2021-06-30-18-00-38.png)

## Principles

1. Create 1 index over 1 field - **index field**
1. An index exists in a separate file
1. All index entries are **unique** and **sorted** w.r.t. the index field - **index-entry** (index value, block pointer)
1. We first search within the index to find the pointer and only then we can access the data block

## Index Types

- **Primary Index** : index field is the ordering, key field of a sequential file
  - e.g. GUID
- **Clustering Index** : index field is the ordering , non-key field of a sequential file
  - e.g. DNO
- **Secondary Index** using a non-ordering attribute
  - key , e.g. unique passport number over an ordered or a non-ordered file
  - non-key, e.g. salary over and ordered or non-ordered file

### Primary

- An *ordered* file over an *ordering key* $k$ of a sequential data file
  - index entries , $(k_i, p_i)$
    - $k_i$ is the unique value of the index field
    - $p_i$ is the pointer to the data block whose *key* element (its first element) is $k_i$
    - we call the first data record in each block with value $k_i$ the **anchor**

  ![](@attachment/Clipboard_2021-06-30-18-12-50.png)

  - Care should be taken when choosing the ordering key since updating/deleting an anchor key is computationally expensive. Not only might we have to rearrange the data block anchors but those changes will need to be reflected in the index as well

#### Example - Performance

- Context
  - File : `EMPLOYEE`
  - #Records $r$ : 300,000
  - Record szie $R$ : 100b
  - Block size $b$ : 4096b
  - SSN size $k$ : 9b
  - Pointer size $p$ : 6b

- Task : Calculate the expected cost of the following query
  - `SELECT * FROM EMPLOYEE WHERE SSN = k`

- We calculate the 
  - blocking factor $bfr = \lfloor\frac{B}{R}\rfloor = 40$ records per block
  - file size $b = \lceil\frac{r}{bfr}\rceil = 7500$ blocks
  - *index* blocking factor = $ibfr = \lfloor\frac{B}{k+p}\rfloor = 273$ entries per block
  - *index* size = $ib = \lceil\frac{b}{ibfr}\rceil = 28$
    - we use $b$ because we require one entry for each data block, i.e the total size/#blocks of the file

- Hence, we have a storage **overhead** of 28 blocks required to store the index. How do our search gains look like?
  - If we use the *primary access path* without using an index we can search
    - **linearly** , such that the number of block accesses is given by $\frac{b}{2} = 37500$
    - using **binary search** , such that the number of block accesses is given by $\lceil\log_2 b \rceil = 13$
  - Using **binary search on the index** the number of block accesses is given by $\lceil\log_2 ib \rceil = 5$ , but we need an extra block access to load the data pointed by the index giving us a **total of 6 block accesses**

- Summary
  - Cost : 0.37% storage
  - Gain : 
    - $1 - \frac{6}{13} = 0.538 = 53.8\%$ (binary) 
    - $1 - \frac{6}{3750} = 0.998 = 99.8\%$ (linear)

### Clustering

- Indexing a sequential file on an *ordering, non-key* field
  - we break the file into clusters determined by this non-key field
- Index entries, $(non-key value, pointer)$
  - require as man entries as there are cluster values
  - a cluster with multiple blocks can be represented via a linked list such that subsequent blocks are stored contiguosly and accessed via chain pointers

  ![](@attachment/Clipboard_2021-06-30-19-21-29.png)

#### Example - Performance

![](@attachment/Clipboard_2021-06-30-19-22-27.png)

- if the distribution of departments was unbalanced we could explore this fact by taking into account the probability of a record/employee belonging to a certain cluster/DNO
- Note the reduction in memory overhead and speed comparing with the previous method brought by the fact that we can travel within a cluster using chain pointers, hence we only need 1 index entry for each cluster value which we access once
- Another advantage is that we can explore the *exiting feature* when using linear search, i.e. we know that we can stop searching if (for example in this case) we hit some DNO greater than the one we are looking for since the clusters are sorted by DNO.
  - The total block access cost, taking into account the probability of each DNO is then given by

  ![](@attachment/Clipboard_2021-06-30-19-32-13.png)

  ![](@attachment/Clipboard_2021-06-30-19-39-41.png)


#### Appropriateness

- Taking into account the cost formulas above, we can use the below theorems to decide whether a clustering index is a good approach

$$
\begin{array}{l}\text { Theorem 1: A Clustering Index of } m<b \text { blocks is created over an ordering } \\ \text { non-key field iff: } \\ \qquad m<2^{\frac{b(n-1)}{2 n}} \\ \text { Theorem 2: If } n \rightarrow \infty, \text { i.e., infinite number of distinct values, then the } \\ \text { linear search over an ordering non-key field with exiting feature is bounded } \\ \text { by b/2, i.e., half of the naive linear search: } \\ \qquad \lim _{n \rightarrow \infty} \frac{b(n+1)}{2 n}=\frac{b}{2}<b\end{array}
$$



### Secondary - Key

- Indexing a (not necessarily ordered) file on a *non-ordering field*
- We require one index entry per data record (dense index) since the file is not ordered according to the indexing field which prevent us from using anchor records
  - index entry , (idx-value, pointer)


![](@attachment/Clipboard_2021-06-30-19-46-10.png)

#### Example - Performance

![](@attachment/Clipboard_2021-06-30-19-46-28.png)
![](@attachment/Clipboard_2021-06-30-19-46-38.png)


### Secondary - non-Key

- Indexing a (not necessarily ordered) file on a *non-ordering , non-key field*

- Uses a 2-level index
  - Index file is composed of the ordered non-key field and a pointer `(ordered idx/cluster value , pointer to pointers)` to a block containing pointers to all the values belonging to that cluster `(pointer, data block)`

![](@attachment/Clipboard_2021-07-01-15-49-02.png)

- Note how in the previous method we did not require a block of pointers since the cluster index was guaranteed to be unique, hence once we knew the block containing the value we would fetch it and the search could stop. In this case, the value *is not unique*, hence we must keep track of all the blocks containing the cluster value, otherwise we would need to access every block, defeating the purpose of indexing

- Note also how we only require one entry per cluster in the index file since we can make use of chain pointers in the blocks of pointers

### Multilevel

- Regardless of index type, the following is always true
  - they are ordered on the indexing field
  - the indexing field has unique values
  - each index entry is of fixed length

- Multilevel indexes allow us to build a *primary index* over **any** index file, since it is an ordered file w.r.t. a key field , i.e. an index of an index
  - each nth index abides by the index principles itself

- The goal is to find the best nesting level which speeds up search without incurring too much overhead
  - we should stop at the *minimum* level $t$ such that the top-level index has only 1 block
  - e.g. in the example below there is unnecessary overhead  both levels 2,3 have 1 block

![](@attachment/Clipboard_2021-07-01-16-09-26.png)

#### Justification

- Thinking about he logarithm as the inverse of exponentiation, we can see it as counting the number of equal divisions of some factor. If we think about our original index as being represented by some number $b$ then $\log_{m}b$ will allow us to split the number $b$ into $m$ equal subspaces, we can then iterate this process until $m = 2$ such that we are left with a single block

> REM $m$ is know as fan-out

$$
\begin{array}{l}\text { Theorem 3: Given a Level-1 Index with blocking factor } m \text { entries } / \text { block, the multi- } \\ \text { level index is of maximum level } t=\log _{m}(b) \text { . }\end{array}
$$

#### Example - Performance

![](@attachment/Clipboard_2021-07-01-18-25-42.png)
![](@attachment/Clipboard_2021-07-01-18-29-48.png)
![](@attachment/Clipboard_2021-07-01-18-30-01.png)
![](@attachment/Clipboard_2021-07-01-18-30-11.png)

#### Discussion Exam Style Question

See slides + scanned working out

- (Upper Bound) Worst case scenario : linear scan will require acessing $b$ blocks, since there is a 50% chance that any given block will contain an employee with DNO = 10 , but we don't know which ones. Hence, we must retrieve them all

- (Lower Bound) Ideal : we retrieve only the $\frac{b}{2}$, which would be all the ones containing the values we want

- true cost $\frac{b}{2} \leq c < b$

- Since its a secondary index we know that we'll need an index containing pointers to blocks of pointers
  - This index must have as many entries as there are unique DNOs
  - This index will have $m < b$ blocks
- Each block of pointers can store at most $f$ pointers, which can in turn be chained if more space is needed

![](@attachment/Clipboard_2021-07-01-19-13-23.png)

- When **searching**
  - we start by the index file , which would take $\log_{2}m$ using binary search
  - once we find the block of pointers corresponding to DNO=10 we'll need to access its internal blocks of pointers. Each can store $f$ pointers and we stores $\frac{b}{2}$ pointers in total, hence we'll need to access all $\frac{b}{2f}$ of those inner blocks containing the pointers to the actual data
  - finally we'll need to retrieve each one of the $\frac{b}{2}$ data blocks
- This gives us a total access cost of $C=\log _{2}(m)+b /(2 f)+b / 2$
  - note that $f \ge 1$ , hence the true cost is strictly greater than our lower bound 