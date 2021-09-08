# Week 8 - Query Processing

- External Sorting : fundamental operator
- Querying strategies
  - `SELECT` : simple, conjunctive, disjunctive
  - `JOIN` : 5 fundamental algorithms
- Principle
  - estimate the cost
  - find the minimum expected cost
  - execute query

# External Sorting

- almost all SQL queries involve sorting of tuple w.r.t ad-hoc sorting requests defined by the user
  - e.g. `SELECT DISTINC Salary` is equivalent to *sort by Salary* then identify clusters of distinct values

- **fundamental limitation** : we cannot store the entire relation into memory for sorting the records, so usual sorting algos are not applied
  - **solution** - *external sorting* algorithm 

- The ES algo is part of the *divide and conquer* family of algos

1. **Divide** the file of $b$ blocks into $L$ smaller sub-files with $\frac{b}{L}$ blocks each
1. Load each sub-file to memory , **sort** using some sorting algo (e.g. quick-sort) and write it back to the disk
1. **merge** the sorted sub-files loaded from disk in memory creating bigger sorted sub-files, that are merged in turn

## Expected Cost

$$2b(1 + \log_{M}L)$$

- $M$ : the degree of merging, i.e. the number of sorted blocks merged in each loop
  - $M=2$, merge in parallel only a pair of blocks at each step ; worst-performance
- $L$ : the number of initial sorted sub-files existent before the merging phase

# SELECT

```SQL
SELECT * FROM <relation>
WHERE <conditions>
```

### Linear Search over key

- Retrieve every record
- Test for condition
- **Expected cost** : $\frac{b}{2}$

### Binary Search over key

- **Expected Cost**
  - unsorted : $\log_2b + 2b(1 + \log_ML)$
  - sorted : $\log_2b$

### Primary Index/Hash Function over key

- Index of level $t$ , sorted by key
  - $t+1$
- Hash with the key with $n$ overflow buckets
  - $1 + O(n)$

### Primary Index over a key involved in a range query

- Use index to find the record satisfying the equality
- Retrieve all subsequent blocks from the ordered file
- Primary index of level $t$, sorted by key
  - $t + O(b)$

### Clustering Index over ordering, non-key

- retrieve all contiguous blocks of the cluster
- clustering index of level $t$ on non-key, sorted ; $n$ distinct values ; uniformly distributed
  $t + O(\frac{b}{n})$

### Secondary Index (B+ Tree) over non-ordering key

- file is not ordered by key
  - $t + 1$

### Secondary Index (B+ Tree) over non-ordering, non-key

- file is not ordered by key
  - $t + 1 + O(b)$

## Disjunctive

- conditions involving `OR`
  - return tuples satisfying the union of all conditions

- If an access path exists for *all* the attributes
  - use each to retrieve the set of records satisfying each condition
  - take the union of the retrieved sets
- Else
  - linear search

## Conjunctive

- conditions involving `AND`
  - return tuples satisfying the intersection of all conditions

- If an access path exists (index) for an attribute, use it to retrieve the tuples satisfying the condition
  - **in memory** check the returned set for all the other conditions

#### Which index to use first if multiple exist?

- use the index that generates the *smallest* intermediate result set hoping that it fits in memory
  - this can be further optimised by finding the execution sequence of conditions that minimise the expected cost
- the goal is to predict the selectivity beforehand
  - e.g. , if the conditions are based on salary and name , it is much more likely that there will be more employers with the same salary than with the same name

selectivity
: The fraction of tuples selected by a selection condition

# JOIN

```SQL
SELECT * FROM <relations>
WHERE <attribute = attribute2>
```

- the most resource consuming operator
- focus on two-way equi-join

## Naive

```SQL
SELECT *
FROM R,S
WHERE R.A = S.B
```

1. Compute the cartesian product of R,S
1. Store the result in a file T and for each concatenated tuple $t=(r,s)$ check if $r.A = s.B$

- inefficient, since usually the result is a small subset of T
  - the aim is to preduct the matching tuples in advance

## Nested-Loop

- For each tuple $r$
  - For each tuple $s$
    - If $r.A = s.B$ add $(r,s)$ to the result file

- **Challenge**
  - which relation should be in the outer loop and which should be in the inner loop?

### Algorithm in terms of block accesses

-  since we do not have direct access to tuples

![](@attachment/Clipboard_2021-07-06-19-30-16.png)

## Index-Based Nested-Loop

- use of an index on either A or B joining attributes
- let's assume that there exists an index I on attribute B of relation S
- for each tuple $r$
  - use index of B : $I(r,A)$ to retrieve all tuples $s$ such that $s.B = r.A$
  - for each tuple $s$ add matching tuple $(r,s)$ to the result file

- much faster because we get immediate access on $s$ with $s.B = r.A$ by searching for $r.A$ using the index I, avoiding linear search on S

- **Challenge**
  - which index to use to minimise the join processing cost?

## Sort-Merge

- use the merge-sort algorithm over two sorted relations w.r.t their joining attributes
  - R,S are physically ordered on their joingin attributes A,B

1. Load a pair $\{R.block, S.block\}$ of sorted blocks into memory
1. Run a linear scan concurrently over the join attributes
1. Store matching tuples in a buffer

- the advantage here is that the blocks of each file are scanned only once

#### Example

- see lecture @approx 15min

- start with the pointers at the first elements
- move pointer of relation where value is less than or equal to current value
  - e.g. 
    - (22,28) -> miss -> i < j -> i++
    - (28,28) -> OK -> write to buffer -> j++
    - (28,28) -> OK -> write to buffer -> j++
    - (28,31) -> miss -> i < j -> i++

![](@attachment/Clipboard_2021-07-06-19-46-39.png)

## Hash-Join

- File R is partitioned into $M$ buckets w.r.t the hash function $h$ over the joining attribute A
- File S is partitioned into $M$ buckets w.r.t the hash function $h$ over the joining attribute B
- R is the smallest file and fits into memory

- Partition Phase
  - For each tuple $r$
    - Compute the address of the bucket, $y = h(r.A)$
    - Place $r$ into bucket in memory
- Probing phase
  - For each tuple $s$
  - Compute the address of the bucket, $y = h(s.B)$
  - Find the bucket in the R partition in memory
  - For each tuple $r$ in the bucket $y = h(s.B)$
    - If $s.B = r.A$ add $(r,s)$ to the result file


![](@attachment/Clipboard_2021-07-06-20-00-37.png)

## Summary

![](@attachment/Clipboard_2021-07-06-20-01-34.png)

## Predicting Join Costs

### Nested-Loop

- $\frac{n_{E}}{n_{B}-2}$, is just the number of of the outer file "Employee" chunks we move into memory
  - we take 2 because we need 1 block for reading the inner file "Department" and another for writing the join result
- $\underline{n_{\mathrm{E}}}+\left(n_{\mathrm{E}} /\left(n_{\mathrm{B}-2)}\right) \underline{n_{\mathrm{D}}}\right.$
  - the first term is just the number of blocks of the outer relation
  - then the number of terms of the inner relation $n_D$ is read once for each chunk of the outer one (i.e the number of outer loops), hence the product

![](@attachment/Clipboard_2021-07-06-23-20-28.png)
![](@attachment/Clipboard_2021-07-06-22-25-11.png)
![](@attachment/Clipboard_2021-07-06-23-20-41.png)

- **Hence** , we now know that we should always choose the file with fewer blocks to be the outer relation

### Index-Based Nested-Loop

![](@attachment/Clipboard_2021-07-06-23-21-04.png)
![](@attachment/Clipboard_2021-07-06-23-21-12.png)

- The thing to note here is that even though our B+ Tree is larger in the second case, the fact that we are guaranteed to always perform meaningful searches, the total retrieval of blocks will be lower

- **Hence**, we should use the index built on the PK, unless the relationship is recursive

### Sort-Merge

![](@attachment/Clipboard_2021-07-06-23-23-42.png)
![](@attachment/Clipboard_2021-07-06-23-23-50.png)

- sorting simply for joining purposes should be a last resort solution since it is a very costly operation

### Hash

![](@attachment/Clipboard_2021-07-06-23-24-18.png)

- recall that you always need two extra blocks more than those in the inner relation for the probing phase, since you need to load the outer relation and the output buffer

> REM the proof for the normal case is beyond the scope

### Summary

![](@attachment/Clipboard_2021-07-06-23-24-38.png)

## Example - Choosing the best strategy

- See slides from 32 onward and lecture recording

