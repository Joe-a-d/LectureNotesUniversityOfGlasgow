# Week 5 - Physical Design & Hashing


## Overview

- Physical Storage and File Organisation
- Record, Block and Blocking Factor
- File Structures
  - Heap
  - Sequential
  - Hash
- Search, Insert, Delete, Updata algorithms and expected cost

# Physical Storage


3-level storage hierarchy

- Primary (e.g. RAM, cache)
- Secondary (e.g. HDD)
- Tertiary (e.g. optical drives)

A DB holds too much data to fit in the main memory, hence:

1. DB is not CPU-accessible
1. Data access is slow (30 ms HDD vs 30ns RAM)

> REM HDD access is the main bottleneck 

The goal is to optimise data storage in HDD so as to minimise this latency

## Components

Record
: single tuple 

CAPTION: a 74 bytes record
![](@attachment/Clipboard_2021-02-27-15-33-47.png)

Block
: a group of records

> REM Blocks are of fixed-length ([512B-4096B])

Blocking Factor
: the number of records that can be stored in a block , $\text{bfr} = \Big\lfloor{\frac{B}{R}}\Big\rfloor , \ B \geq R$ where $B,R$ represent the size of the block and records respectively

File
: a group of blocks

## From blocks to files

We can allocate blocks of files on disk via *linked allocation*

Linked Allocation
: each block *i* has a pointer to the physical address of the next logical block $i+1$ anywhere on the disk

> EXAMPLE
> The relation EMPLOYEE has $r = 1103$ tuples, each one corresponding to a fixed length record. Each record has the fields NAME 30 bytes, SSN 10 bytes,ADDRESS 60 bytes. Given a block size $B = 512B$:
> 1. What's the bfr of the file that accomodates this relation?
> bfr $=\Big\lfloor{\frac{512}{100}}\Big\rfloor = 5$
> 
> 1. How many blocks $b$ are in the file?
> $b = \Big\lceil{\frac{1103}{5}}\Big\rceil = 221$ , 220 *full* and one $\frac{3}{5}$

To utilise unused space within a block, we can store part of a record on one block and the rest on another. A pointer at the end of the first block points to the block containing the remainder of the record in case it is not the next consecutive block on disk. This organisation is called *spanned* because records can span more than one block.

## File Structures

- Heap (unordered, append) : a new record is added to the end of the file
- Ordered (sequential) : records are kept physically sorted with respect to some ordering field
- Hash (map) : a hashing function $y=h(x)$ is applied to each record field $x$ - *hash field* - which returns the physical block address $y$

# Expected I/O Access Cost

A file type (heap, ordered or hash) can be operated upon in one of two ways:
  - *Retrieval* : a whole block is fetched from disk to memory in order to locate certain records
  - *Update* : transfer the whole block from memory to disk in order to insert, delete or update 

Both of this groups of operations have a cost associated with it which can be represented by a *cost function*

Cost Function
: a function which calculates the expected number of block accesses (read/write) to perform the operation

If we assign for each value $x$ a real-valued function $C(X)$ indicating the cost of accessing $X$ in number of block accesses, we can calculated the expect cost $E\Big(C(X)\Big)$ by taking $C(X)$ to be a random variable itself.

$$E\Big(C(X)\Big)=\sum_{x} P(X=x) \cdot C(x)$$

## Heap

Characterised by efficient insertion and inefficient retrieval and deletion

### Insertion

1. Load the last block from disk to memory
1. Insert the new record at the end of the block
1. Write block back to disk

Complexity : $O(1)$ , 2 block accesses

### Retrieval 
1. Linear search through all $b$ file blocks
1. Load a block at a time from disk to memory
1. Search for record
1. Repeat until found

Complexity : $O(b)$ 

### Deletion
1. Retrieve block (root of the inefficiency; explained above)
1. Remove the record from the block
1. Write the block back to disk

Complexity : $O(b) + O(1)$

Note that every time a record is deleted there's some unused spaced left within blocks. In order to handle this, records have a bit flag know as *deletion marker*. The DBMS will periodically re-organise the file by gathering the records with unset flags (non-deleted records) and freeing up blocks who have their flag set (deleted).

## Sequential

Optimal for retrieval on retrieval on the ordering field and updating on a non-ordering field

Suitable for SQL queries that
- require sequential scanning (`ORDER BY`)
- involve ordering field in the search (`WHERE <OrdField> LIKE X`)
- range queries over the ordering field (`WHERE <OrdField> > X AND <OrdField> < Y`)

### Retrieval (on ordered field)

1. Use binary search on the OF \mymarginpar{see algo in slides 20,21}

Complexity : $O(\log_2b$) , sub-linear with $b$

### Retrieval (on non-OF)

1. Linear scan (does not exploit order)

Complexity : $O(b)$ , linear with $b$

### Range queries (on OF)

1. Using binary search, find the block $i$ which contains the record where OF equals to lower bound of the range
1. Fetch contiguous blocks $i+k$ until the range is exhausted , $k=0,\dots,<b$

Complexity : $O(\log_2b) + O(b)$

> REM the key idea here is that given the sequential nature of the file, we know that blocks are in order, so we can assume that files with upper bound value will necessarily follow LB

### Insertion

1. Using binary search, locate the block where the record should be inserted
1. Shift the records (costly)
1. Insert new record

#### Alternative - Chain Pointers & Overflow Block

1. Create an unordered *overflow* file at the end of the *main* file
1. Insert new record at the end of the overflow file
1. Point overflow block to its logically related main block counterpart and vice-versa (almost like a linked-list)
1. Periodically sort overflow and merge during file reorganisation

> REM trades insertion efficiency by higher search algorithm complexity

### Deletion

1. Using binary search, locate the block
1. Update the deletion marker
1. Remove pointer
1. Periodically re-sort file to restore the physically sequential order (external sorting is expensive)

### Update (on OF)

1. Delete 
1. Insert

### Update (on non-OF)

1. Retrieve on OF
1. Update value

Complexity : $O(\log_2b) + O(1)$

### Summary 

$$\begin{array}{l|l}\text { Sequential File } & \text { I/O Cost Complexity } \\ \hline \text { Search by ordering field } & \mathrm{O}\left(\log _{2}(b)\right) \text { binary search } \\ \text { Search by non-ordering field } & \mathrm{O}(b) \text { linear search }\end{array}$$

## External Hashing

The main idea behind hashing is that records are partitioned and there exists a *hash function* $y=h(k)$ which maps records to buckets. The search condition must be an equality condition on a single field, called the *hash field*

$h$ uniformly distributes records into the buckets, i.e there is an equal probability $\frac{1}{M}$ ($M$ == #buckets) of each value $k$ belonging to any given bucket 

$$y = h(k) = k \mod M$$

External Hashing
: mapping a record to a partition over a hash-field $k$

Collision
: when the hash field value of a record that is being inserted hashes to an address that already contains a different record. This is less severe in external hashing, because as many records as will fit in a bucket can hash to the same bucket without causing problems, but we still need to handle the case where the bucket is full

> EXAMPLE
$\begin{array}{l}\text{Let } \mathrm{M}=3 \mathrm{~b} h(k)=k \bmod 3 \in\{0,1,2\}, \text { thus, we obtain three buckets. } \\ \text { Records with } k=1,11,2, \text { and } 4 \text { are stored to buckets } 0,2,2, \text { and } 1, \text { respectively. } \\ \text { Collision on bucket } 2 .\end{array}$

Hash Map
: a table which keeps a record of the partition-address mappings

### Retrieval

### Algorithm  $\text{Attr} = k$

1. Hash $k$ and get the corresponding bucket $P$
1. Get the corresponding address from the map
1. Fetch the block from disk to memory
1. Linear search to find the record such that $h(\text{Attr}) = P$

Complexity : $O(1)$

In order to address the collision problem we can once again use the chaining pointer strategy, where each pointer points to a linked list of overflow records for the bucket

> REM the pointers are *record pointers* , i.e. they include both a block address and a relative record position within the block

![](@attachment/Clipboard_2021-02-27-18-38-53.png)

Complexity : $O(1) + O(n)$

> REM we assume that on average the number of overflow blocks is $n$

### Deletion

1. If in the main bucket delete, $O(1)$
1. Else, follow the chain $O(1) + O(n)$
1. Periodically pack together blocks of the same bucket to free up blocks with deleted records

### Update (non-hash field)

1. Locate record in main $O(1)$
1. Else, $O(1) + O(n)$
1. Load block into memory, update, write back

### Update (hash-field)

1. Locate
1. Delete
1. Insert in new bucket


> EXAMPLE slides 31-34

### Range Queries (inneficient)

- Find the bucket which contains the records with hash field equal to LB : $O(1) + O(n)$
- The continuous values (LB, UP] are not mapped to the same bucket, because an ideal hash function *uniformly* distributes the values over buckets
- Hence, each value in range is treated as a separated query

Complexity : $O(m) + O(mn)$ for $m$ distinct values in the range with $n$ overflow blocks per bucket

#### Is the expected cost of a range query predictable?

See slides 36,37 ; the expected cost is dependent on the underlying distribution of the hash-field 

### Example - Comparisons

![](@attachment/Clipboard_2021-08-01-23-58-24.png)

![](@attachment/Clipboard_2021-08-01-23-58-46.png)

![](@attachment/Clipboard_2021-08-02-00-00-02.png)