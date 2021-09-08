# Week 9 - Query Optimisation (SELECT)

- fundamental optimisations to optimal execute queries
- selection selectivity
- predicting
  - selection cardinality
  - number of blocks required to be retrieved
- refine the expected cost of selection strategies involving the selectivity metric, i.e express expected cost as a function of selectivity

# Query Optimisation

- Input : Query
- Output : *Optimal* execution plan

- **Heuristic Optimisation**
  - transform a SQL query into an equivalent and efficient query using relational algebra

- **Cost-based Optimisation**
  - provide alternative execution plans and predict their costs
  - choose the plan with the minimum cost
  - return a cost function with optimisation parameters
    - $c(a,b,c)$ , where $a,b,c$ may represent e.g. number of block accessed, memory requirements, CPU etc.


# Cost-Based Optimisation

- exploits statistical information to estimate the execution cost of a query

- Information required

![](@attachment/Clipboard_2021-07-07-19-59-15.png)

- histograms as a good approximation of a distribution, indicating the frequency (probability) of each value $x \in A$ in the relation

![](@attachment/Clipboard_2021-07-07-20-00-38.png)

# Selection Selectivity

Selection selectivity
: $sl(A)$ of attribute $A$ , $0 \leq sl(A) \leq 1 \in \mathbb{R}$ . We can frame it as representing the probability that a tuple satisfies a selection condition

# Selection Cardinality

**Challenge** : Given $r$ tuples and a selection condition over $A$ we want to predict the expected number of tuples satisfying this condition without having to scan the file

$$s = r \times sl(A) \in [0,r]$$

# Selectivity Prediction

- difficult, so often we must deal with assumptions and approximations

## No assumption, approximation

- approximate the distribution of values via a histogram
- **advantage** : accurate
- **cost** : maintenance overhead to keep the histogram updated

- a good selectivity estimate 

$$
\operatorname{sl}(\mathrm{A}=x) \approx \mathrm{P}(\mathrm{A}=x), \text { which depends on the value of } x \in[\min (A), \max (A)]
$$

![](@attachment/Clipboard_2021-07-07-20-15-09.png)

## Uniformity assumption

- simplest solution, since we just assume that all values are equiprobable
- **advantage** : no overhead , cause no histogram
- **cost** : less accurate

$$
\text { sl }(\mathrm{A}=x) \approx \text { constant independent of the } x \text { value; } \forall x \in[\min (A), \max (A)]
$$

![](@attachment/Clipboard_2021-07-07-20-17-58.png)

### Impact of type of attribute

#### Key

- Assume an equality condition on a key attribute
  - good estimate since we know that only one tuple can satisfy the selection condition over a *unique* attribute

$$
\operatorname{sl}(\mathrm{A}=x)=1 / r, \quad \forall x \in[\min (A), \max (A)]
$$

```SQL
SELECT * FROM EMPLOYEE WHERE SSN=12345678
```

- with $r=1000$ 
  - then $\operatorname{sl}(SSN) = \frac{1}{r} = 0.001$

#### Non-Key

- Assume an equality condition on a non-key attribute with $n = NDV(A) < r$ number of distinct values
  - much more problematic, since all records are uniformly distributed across the $n$ distinct values, but the probability of an attribute having uniform distribution is almost zero
  - $P(A = x) = \frac{\frac{r}{n}}{r} = \frac{1}{n}$ , not a very good estimate for the selectivity

```SQL
SELECT * FROM EMPLOYEE WHERE DNO=5
```

- with $n = 10$ , $r=1000$
  - $\operatorname{sl}(DNO)=\frac{1}{10}$
- selection cardinality
  - $s=r^{*} \operatorname{sel}(\mathrm{A} = \frac{r}{n}$

### Example - Range Selection Selectivity

```SQL
SELECT * FROM EMPLOYEE WHERE Salary >= 1000
```

$\begin{array}{l}\text { Definition 1: Domain range: } \max (\mathrm{A})-\min (\mathrm{A}) ; \mathrm{A} \in[\min (\mathrm{A}), \max (\mathrm{A})] \\ \text { Definition 2: Query range: } \quad \max (\mathrm{A})-x ; \quad x \in[\min (\mathrm{A}), \max (\mathrm{A})]\end{array}$

$$
\begin{array}{l}s l(\mathrm{~A} \geq x)=0 \text { if } x>\max (\mathrm{A}) \\ s l(\mathrm{~A} \geq x)=(\max (\mathrm{A})-x) /(\max (\mathrm{A})-\min (\mathrm{A})) \in[0,1]\end{array}
$$

- Salary : [100,1000]
- $r = 1000$ , uniformly distributed among salaries

$$
s l \text { (Salary } \geq 1000)=(10000-1000) /(9900)=0.909(90.9 \%) \text { or } s=909 \text { employees }
$$

### Example - Conjuctive Selectivity

```SQL
SELECT * FROM EMPLOYEE WHERE
DNO=5 AND Salary=40000
```

$$
s l(Q)=s l(A=x) \cdot s l(B=y) \in[0,1]
$$

- NDV(Salary) = 100
- NDV(DNO) = 10
- r = 1000 , evenly distributed among salaries **and** departments
- salary is independent of the department (deeply flawed assumption)
  -  joint probability

$$
\begin{array}{l}s l(\text { Salary }=40 \mathrm{~K})=1 / \mathrm{NDV} \text { (Salary) }=1 / 100=0.01 \\ s l(\mathrm{DNO}=5)=1 / \mathrm{NDV}(\mathrm{DNO})=1 / 10=0.1 \\ s l(\mathrm{Q})=s l(\text { Salary }) \cdot s l(\mathrm{DNO})=(1 / 10) \cdot(1 / 100)=0.001 \text { or only } s=1 \text { tuple }\end{array}
$$

### Example - Disjunctive Selectivity

```SQL
SELECT * FROM EMPLOYEE WHERE
DNO=5 OR Salary=40000
```
$$
s l(Q)=s l(A)+s l(B)-s l(A) \cdot s l(B) \quad \in[0,1]
$$
- NDV(Salary) = 100
- NDV(DNO) = 10
- r = 1000 , evenly distributed among salaries **and** departments
- salary is independent of the department (deeply flawed assumption)

$$
\begin{array}{l} s l \text { (Salary) }=1 / \mathrm{NDV}(\text { Salary })=1 / 100=0.01 \\ s l(\mathrm{DNO})=1 / \mathrm{NDV}(\mathrm{DNO})=1 / 10=0.1 \\ s l(\mathrm{Q})=(10 / 100)+(1 / 100)-(1 / 10) \cdot(1 / 100)=0.109 \text { or } s=109 \text { tuples }\end{array}
$$

# Summary

![](@attachment/Clipboard_2021-07-07-20-52-17.png)

# Example - Predict the number of blocks satisfying a selection

- **Context**
  - blocking factor $f$
  - selection cardinality $s = \frac{1}{\text{NDV(A)} = \frac{r}{n}}$

- the predicted number of blocks retrieved is a reciprocal function of $n$
  - particularly useful, since we associate the retrieval cost with the attribute's characteristics
  - given the number of distinct values, we can accurately predict the number of tuples to be retrieved

$$
\operatorname{ceil}(s / f)=\operatorname{ceil}(r / f \cdot \operatorname{NDV}(\mathrm{A})))=\left[\frac{r}{n f}\right] \text { blocks }
$$

![](@attachment/Clipboard_2021-07-09-15-47-03.png)

# Selection Cost Refinement

- expressing cost as a function of $sl(A) = \frac{r}{n}$
  - i.e. as a function of the selection selectivity

```SQL
SELECT * FROM R WHERE A = x
```

- **Context**
  - $b$ blocks
  - $f$ blocking factor
  - $r$ blcoks
  - $n$ NDV(A)

### Binary Search

- R is sorted w.r.t A
  - A is **key** : $log_2(b)$
  - A is **not key** : $\log _{2}(b)+\lceil\frac{s}{f}\rceil -1=\log _{2}(b)+\lceil(r \cdot \operatorname{sl}(A) / f)\rceil-1$
    - $log_2b$ to reach the first block with records $A=x$
    - access all contiguous blocks whose records satisfy $A=x$
      - possible since the file is sorted w.r.t A
    - $s = r \times sl(A=x)$ tuples
    - access $\lceil\frac{s}{f}\rceil -1$ more blocks
      - number of tuples that satisfy the condition over the number of max tuples per block 
      - remove the first block already accounted for/retrieved

![](@attachment/Clipboard_2021-07-09-16-01-51.png)

### Multilevel Primary Index

- level $t$
- A is **key** : $t+1$
- **range $A \geq x$** : $t+\operatorname{ceil}(s / f)=t+\operatorname{ceil}(r \cdot s l(A) / f)$
  - Tree traversal : $t$ block accesses
  - Range selection cardinality $s = r \cdot \operatorname{sl}(A)$
    - sorted w.r.t A , hence we can retrieve contigous blocks satisfying the condition, whose number is given by the selection cardinality
  - blocking factor $f$ : $\operatorname{ceil}(\frac{s}{f})$

Equality          |  Range
:-------------------------:|:-------------------------:
![](@attachment/Clipboard_2021-07-09-16-01-58.png) | ![](@attachment/Clipboard_2021-07-09-16-02-03.png)



### Hash File Structure

- apply the hash function $h(A)$ over the key A and retrieve the block : $1$
  - best case, no overflown buckets

### Clustering

- **ordering, non-key** : $t+\operatorname{ceil}(s / f)=t+\operatorname{ceil}(r \cdot s l(A) / f)$
  - R is sorted w.r.t DNO
  - Tree traversal : $t$
  - Selection cardinality : $s=r \cdot s l(A)$
  - Blocking factor $f$ : $\text { ceil }(s / f)$

Index          |  Cost vs Unique Values
:-------------------------:|:-------------------------:
![](@attachment/Clipboard_2021-07-09-16-04-16.png) | ![](@attachment/Clipboard_2021-07-09-16-04-22.png)

### B+ Tree

- **non-ordering, key** : $t+1$
  - Tree traversal : $t$
  - Selection cardinality : $1$

- **non-ordering, non-key** : $t+1+s=t+1+r \cdot s l(A)$
  - Tree traversal : $t$
  - load block of pointers : $1$
    - we assume here that al pointers fit in a block
  - Selection cardinality : $s=r \cdot s l(A)$
    - allow us to know how many pointers we need
  - worst case, each tuple is in a different data block : $s$

![](@attachment/Clipboard_2021-07-09-16-06-45.png)


# Optimisation Examples

## 1

- **Context**
  - uniformity assumption
![](@attachment/Clipboard_2021-07-09-16-28-04.png)

- **Query and Plans**

![](@attachment/Clipboard_2021-07-09-16-30-30.png)
![](@attachment/Clipboard_2021-07-09-16-30-42.png)

## 2

- **Query and Plans**

- Disjunction of two conditions one of which is conjunctive

![](@attachment/Clipboard_2021-07-09-16-45-27.png)
![](@attachment/Clipboard_2021-07-09-16-31-30.png)


![](@attachment/Clipboard_2021-07-09-16-31-40.png)
![](@attachment/Clipboard_2021-07-09-16-31-52.png)
![](@attachment/Clipboard_2021-07-09-16-31-58.png)
![](@attachment/Clipboard_2021-07-09-16-32-05.png)
![](@attachment/Clipboard_2021-07-09-16-32-11.png)

# General Method

1. Draw the index
1. Identify the selection selectivity for each selection condition
  - range or equality?
1. Identify how many blocks are required to store the tuples
  - dependent on the type of attribute
    - if it's the sorting attribute, then you can exploit the fact that they are stored contiguously and most likely a clustering index was used
    - non-key, most likely a B+ Tree, and in the worst case scenario they might be spread across different blocks, so you'll need as many blocks as there are tuples satisfying the condition


![](@attachment/Clipboard_2021-07-09-17-49-57.png)