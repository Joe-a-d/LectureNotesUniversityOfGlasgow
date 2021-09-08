# Week 10 - Query Optimisation (JOIN)

- Join Selectivity
- Join Cardinality
- Express the cost of all strategies as a function of select and join selectivity
- Optimisation plans
  - 3-way join queries

# Join Selectivity and Cardinality

Join Selectivity
: the fraction of the matching tuples between the relation R,S out of the cartesian cardinality , i.e. the number of concatenated tuples

$$
j s=|\mathbf{R} \bowtie \mathbf{S}| /|\mathbf{R} \times \mathbf{S}| \text { with } 0 \leq j s \leq 1
$$

Cartesian Cardinality
: $|\mathbf{R} \times \mathbf{S}|=|\mathbf{R}| \cdot|\mathbf{S}|$

Join Cardinality
: the number of matching tuples of a join query ; $j c:=j s \cdot|\mathbf{R}| \cdot|\mathbf{S}|$

# Predicting JC 

- our goal is to predict the join cardinality without executing the join query

## Join Selectivity Theorem

$$
\begin{aligned} \text { Theorem 1. Given } n &=\mathrm{NDV}(\mathrm{A}, \mathbf{R}) \text { and } m=\mathrm{NDV}(\mathrm{B}, \mathrm{S}) \text { : } \\ j s &=1 / \max (n, \mathrm{~m}) \\ j c &=(|\mathbf{R}| \cdot|\mathrm{S}|) / \max (n, m) \end{aligned}
$$

- js is a function of the number of distinct values of the two joining attributes (A,R)

### Example

- Show the dependents of each employee

```SQL
SELECT * FROM EMPLOYEE E, DEPENDENT P
WHERE E.SSN = P.E_SSN
```

$\begin{array}{l}n=\mathrm{NDV}(\mathrm{SSN}, \mathrm{E})=2000 ;|\mathrm{E}|=2000 \text { employees } \\ m=\mathrm{NDV}\left(\mathrm{E}_{-} \mathrm{SSN}, \mathbf{P}\right)=3 ;|\mathbf{P}|=5 \text { dependents } \\ j s=1 / \max (2000,3)=1 / 2000=0.0005 \text { or } 0.05 \% \text { (probability of matching tuple) } \\ j c=0.0005 * 2000 * 5=5 \text { matching tuples (as expected) }\end{array}$

### Executing a Join Query - Revision

![](@attachment/Clipboard_2021-07-10-14-21-33.png)

- recall that in a join query we store resulting tuples in buffers until they are full before storing them into the disk
  - the blocking factor of the result blocks gives us the max number that can be stores in a memory block
- in order to know the number of result blocks we just need to know the number of result tuples (jc) and the result blocking factor

# Cost Refinement

- we'll refine our results from the previous lecture on join queries to now include the cost of writing the result blocks into memory

## Nested-Loop

![](@attachment/Clipboard_2021-07-10-14-24-19.png)

## Index-Based Nested-Loop

### Primary Index on ordering key

![](@attachment/Clipboard_2021-07-10-14-25-42.png)

### Clustering Index on ordering non-key

![](@attachment/Clipboard_2021-07-10-14-31-04.png)

- why selection cardinality?
  - because we need to know how many employees exist on each department, in order to know how many blocks we are about to retrieve
  - we load a block at the time from the relation department then go down the tree to retrieve all those employees of that department

### B+ Tree on non-ordering , non-key

![](@attachment/Clipboard_2021-07-10-14-33-26.png)

### Sort-Merge

$$
b_{\mathrm{R}}+b_{\mathrm{S}}+\left(j s \cdot|\mathrm{R}| \cdot|\mathrm{S}| / f_{\mathrm{RS}}\right)
$$

### Hash-Join

$$
3 \cdot\left(b_{\mathrm{R}}+b_{\mathrm{S}}\right)+\left(j s \cdot|\mathrm{R}| \cdot|\mathrm{S}| / f_{\mathrm{RS}}\right)
$$

## Example

![](@attachment/Clipboard_2021-07-10-14-53-17.png)
![](@attachment/Clipboard_2021-07-10-14-53-23.png)
![](@attachment/Clipboard_2021-07-10-14-53-31.png)

# 3-Way Join Optimisation

![](@attachment/Clipboard_2021-07-10-14-57-38.png)

- since we have a conjunctive query, we have the option of two plans
  - execute the join on the LHS and then the one on RHS on the resulting table
  - vice-versa

## Plan 1 - find employees having at least one dependent and check if they are managers

### 1.1 - join employees with dependents

![](@attachment/Clipboard_2021-07-10-14-57-48.png)

### 1.2 - join employees with dependents ($b_{ET} = 25 \text{blocks}$) with department

![](@attachment/Clipboard_2021-07-10-14-59-06.png)

## Plan 2 - find employees who are managers and check if they have dependents

### 2.1 - Join employees with departments

![](@attachment/Clipboard_2021-07-10-15-00-20.png)

### 2.2 - Join managers ($b_{\mathrm{ED}}=63 \text { blocks; } r_{\mathrm{ED}}=125 \text { managers }$) with dependents 

![](@attachment/Clipboard_2021-07-10-15-01-00.png)

# Holistic Optimisation

- query involving a select and join query

- conjunctive
  - selection on the employee relation `SALARY=1000`
  - join on employee and department `SSN = MGR_SSN`


![](@attachment/Clipboard_2021-07-10-15-26-04.png)

## Plan 1 - Select followed by Join

- likely to reduce the number of matched tuples, since we filter out on salary before joining

### 1.1. - Clustering index for selection

![](@attachment/Clipboard_2021-07-10-15-34-41.png)

### 1.2 - Primary index for joining

![](@attachment/Clipboard_2021-07-10-15-34-50.png)

## Plan 2 - Join followed by Select

- likely to generate big intermediate results

### 2.1 - B+ Tree (SSN) for join

![](@attachment/Clipboard_2021-07-10-15-35-04.png)

### 2.2 - in memory filtering

![](@attachment/Clipboard_2021-07-10-15-35-15.png)

- **Hence** , first select and then join since we reduce the tuple space before joining