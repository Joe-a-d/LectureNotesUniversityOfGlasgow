# Week 2 - Functional Dependency & Normalisation Theory

## TOPICS

- judging the efficiency of a schema
- Functional Dependency theory : quantify the degree of goodness
- Normalisation Theory : framework to transform a schema into a set of good and efficient relations
- Boyce-Codd Normal Form 

<div id="content"> 

## Design Guidelines for Relational Schemas

1. The Attributes of a relation should make sense
  - The goal is to *minimise the similarity* between relations
  - Relationships between relations should be represented via common attributes which map to FKs, PKs
2. Avoid redundant tuples
  - Storage cost
  - Prone to inconsistency (e.g. missing relations on update)
3. Relations should have as few `NULL` values as possible
  - attributes that are frequently `NULL` should be placed in separate relations to avoid wasting storage
4. Design relations to avoid spurious tuples
  - avoid relations that contain matching attributes that are not keys combinations *because* joingin on such attributes may produces spurious tuples \mymarginpar{see lecture slides and [^1] for worked example}

# Functional Dependency

Functional Dependency
: a formal metric of the degree of goodness of relational schema

Formally, a FD denoted by $X \to Y$ between two sets of attributes $X, Y$ that are subsets of R specifies a *constraint* on the possible tuples that can form a relation state $r$ of $R$. That constraint is that, for any two tuples $t_1 , t_2$ in $r$ that have $t_1[X] = t_2[X]$, they must also have $t_1[Y] = t_2[Y]$ [^1]

Codd [^2] , expressed the constraint presented above as "We say that an attribute $X$ *functionally determines* an attribute $Y$ if a value of $X$ determines a *unique* value for Y"

> LEMMA If $X$ is a candidate key of $R$, then $X \to R$

If $X$ is a *candidate key* of $R$, then there is a constraint on $R$ which states that there cannot be more than one tuple with a given $X$ value in any relation instance $r(R)$. This is because the key constraint implies that no two tuples in any *legal state* $r(R)$ will have the same value of $X$, which is precisely the definition of FD given above

Legal State
: relation extensions $r(R)$ that satisfy the FD constraints

Extension
: the set of tuples of a relation at a given instance

> REM the main use of FD is to further describe a schema $R$ by specifying constraints on its attributes that *must hold at all times*

> LEMMA $X \to Y \in R \;\not\!\!\!\implies Y \to X \in R$

William W. Armstrong introduced the following *inference rules* for FDs:

> LEMMA Reflexive : $Y \subseteq X \implies X \to Y$
> LEMMA Augmentation : $X \to Y \implies X \cup \{Z\} \to Y \cup \{U\}$
> LEMMA Transitive : $(X \to Y) \land (Y \to Z) \implies X \to Z$

#### anchor
> EXAMPLE
$$
\begin{array}{|c|c|c|c|c|c|}\hline \text { SSN } & \text { Pnumber } & \text { Hours } & \text { Ename } & \text { Pname } & \text { Plocation } \\ \hline 1 & 5 & 10 & \text { Chris } & \text { PX } & \text { G12 } \\ \hline 2 & 5 & 30 & \text { Stella } & \text { PX } & \text { G12 } \\ \hline 1 & 7 & 15 & \text { Chris } & \text { PY } & \text { G45 } \\ \hline\end{array}
$$


- FD1 : $\text{SSN} \to \text{Ename}$ , i.e. we know that we can search all tuples with `SSN[1]` and we'll always get `Ename["Chris"]`

- FD2 : $\text { Pnumber } \rightarrow \text { \{Pname, Plocation\} }$

- FD3 : $\text { \{SSN, Pnumber\} } \rightarrow \text { Hours }$

# Normalisation

We can use this notion of FDs to specify which attributes can become PKs and FKs. We assume that a set of FDs exists for each relation and that each relation has a designated PK, we then combine this information with the conditions for normal forms to drive the *normalisation process*.

1. Assert FDs
1. Take a pool and put into all the asserted FDs
1. Create a universal big relation with all the attributes
1. Recursively decompose the big relation based on the FDs into many smaller ones, such that when we re-join them , there's a guarantee that no information is lost and the original relation can be obtained without spurious tupples

Normal Form
: the degree of progressive decomposition , e.g. 1NF, 2NF etc.

In order to recursively decompose unsatisfactory relations, Codd proposed certain tests/conditions which if not met indicate that the relation schema attributes should be split into different subsets forming new relations until the tests are passed

Prime Attribute
: an attribute that belongs to *some* candidate key of the relation , e.g. SSN

## 1NF

The firs normal form states that the domain of an attribute must include only *atomic* values and that the value of any attribute in a tuple must be a *single* value from the domain of the attribute, i.e. 1NF disallows nested relations and multivalued attributes

## 2NF

Full FD
: a FD $X \to Y$ whose removal of any attribute $A$ from $X$ means that the dependency no longer holds

2NF
: every non-prime attribute $A$ in $R$ is fully FD on $R$'s PK

In order to decompose from 1NF to 2NG we need to remove the PKs which cause partial dependencies:
1. Identify all partial FDs
1. For each partial FD create a new relation such that all non-prime attributes are only associated with the part of the primary key on which they are FFD, i.e. we make the verbose PK the PK of the new relation

> EXAMPLE
FD3 from our [example](#anchor) above is fully FD. On the other hand if we were to have the FD {SSN, Pnumber} $\to$ Ename, this would be a partially dependency since SSN fully determines Ename (FD1). Hence, Pnumber is *verbose*

![](@attachment/Clipboard_2021-02-21-05-30-09.png)

## 3NF

3NF
: it satisfies 2NF and no non-prime attribute of $R$ is transitively dependent on the PK

$$
\begin{array}{|c|c|c|c|c|c|c|}\hline \text { SSN } & \text { Ename } & \text { Bdate } & \text { Address } & \text { Dnumber } & \text { Dname } & \text { Dmgr\_ssn } \\ \hline 1 & \text { Chris } & 1970 & \mathrm{~A} 1 & 3 & \mathrm{SoCS} & 12 \\ \hline 2 & \text { Stella } & 1988 & \mathrm{~A} 2 & 3 & \mathrm{SoCS} & 12 \\ \hline 3 & \text { Philip } & 2001 & \mathrm{~A} 3 & 3 & \mathrm{SoCS} & 12 \\ \hline 4 & \text { John } & 1966 & \mathrm{~A} 4 & 3 & \mathrm{SoCS} & 12 \\ \hline 5 & \text { Chris } & 1955 & \mathrm{~A} 5 & 3 & \mathrm{SoCS} & 12 \\ \hline 6 & \text { Anna } & 1999 & \mathrm{~A} 6 & 4 & \text { Maths } & 44 \\ \hline 7 & \text { Thalia } & 2006 & \mathrm{~A} 7 & 4 & \text { Maths } & 44 \\ \hline\end{array}
$$

When looking at the relation above, we see that it is 1NF and 2NF, but we also see that there is a lot of redundancy, in particular within the last three attributes. Note that there exists a transitive dependency between `Dmgr_ssn`  and `SSN` via `Dnumber`, i.e `SSN` → `Dnumber` and `Dnumber` → `Dmgr_Ssn`, so the relation is not in 3NF. We can transform it by:

1. Identifying the non-prime transitive attribute (Dnumber)
1. Splitting the relation , making the non-prime attribute the PK of the new relation and a FK of the other

![](https://cdn.mathpix.com/snip/images/9Ct6brjkYKleeuUpJs5K49H5HmrXJUjmFGHgkynQERc.original.fullsize.png)

Intuitively we see that ED1 and ED2 represent *independent facts* about employees and departments, both of which are now entities in their own right. This schema then makes more sense semantically and it also makes DB records' manipulation more efficient

### Generalized 3NF

Every non-prime attribute $A \in R$ :
- is FFD on every candidate key 
- id non-transitively dependent on every candidate key

## Summary

In general, we want our schemas to have neither partial nor transitive dependencies, because these will cause update anomalies.

|Normal Form | Test | Remedy  (Normalization)|
|:--:|:--:|:--:|
|First (1NF)|Relation should have no multivalued attributes or nested relations.| Form new relations for each multivalued attribute or nested relation.|
|Second (2NF)|For relations where primary key contains multiple attributes, no nonkey attribute should be functionally dependent on a part of the primary key.| Decompose and set up a new relation for each partial key with its dependent attribute(s). Make sure to keep a relation with the original primary key and any attributes that are fully functionally dependent on it.|
|Third (3NF)|Relation should not have a nonkey attribute functionally determined by another nonkey attribute (or by a set of nonkey attributes). That is, there should be no transitive dependency of a nonkey attribute on the primary key.| Decompose and set up a relation that includes the nonkey attribute(s) that functionally determine(s) other nonkey attribute(s).|


## BCNF

A stricter definition of a normal form. Every relation in BCNF is also in 3NF.

BCNF
: if a nontrivial FD $X \to A \implies$ that $X$ is a superkey

![](@attachment/Clipboard_2021-02-27-03-38-47.png)

- 3NF because C is FD on both $A, C$ individually and non-transitively

- NOT BCNF, because $X \to C$ but $X$ is not a PK

### Decomposition

> THEOREM BCNF Decomposition
> If $R$ is not in BCNF and $X \to A$ violates BCNF, then $R$ can be repeatedly decomposed until:
> - $R_1 = R \setminus \{A\}$
> - $R_2 = \{X\} \cup \{A\}$

> EXAMPLE
$$
\begin{array}{lll}\hline \text { STUDENT } & \text { COURSE } & \text { INSTRUCTOR } \\ \hline \text { Narayan } & \text { Database } & \text { Mark } \\ \text { Smith } & \text { Database } & \text { Navathe } \\ \text { Smith } & \text { Operating Systems } & \text { Ammar } \\ \text { Smith } & \text { Theory } & \text { Schulman }\end{array}
$$

> FD1 : {Student, Course} $\to$ Instructor
> FD2 : Instructor $to$ Course

Here FD2 violates BCNF. Hence, take $X = \text{Instructor}$ and $A = \text{Course}$. Then, by THEOREM:

- $R_1 = R \setminus \{\text{Course}\} = \{\text{Student}, \text{Instructor}\}$
- $R_2 = \{\text{Instructor}\} \cup \{\text{Course}\} = \{\text{Instructor}, \text{Course}\}$



</div>

[^1]: Fundamentals of Database Systems, Elmasri, Navathe, 2016, 9780133970777
[^2]: Codd, 1970
