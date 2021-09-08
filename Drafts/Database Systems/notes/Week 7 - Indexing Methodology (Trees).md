# Week 7 - Indexing Methodology (Trees)

- Multi-Level implementations in practice
  - B Tree
  - B+ Tree
- Study case : secondary index on non-ordering, key 
- Compare and contrast : primary access, secondary index, B+Tree

# Multilevel Index

- A big downside of using indexes is making sure that when a record is updated those changes are reflected at all levels. In order to improve on the previous methods, we'll use trees and we require that the indexes be dynamic such that they:
  - adjust to deletions/insertions of records
  - expand ad shrink following the distribution of the index values
  - self-balance

- e.g. below is a 2-level index over a non-ordering, key (secondary index)
  - root represents L2-index
  - root's immediate children L1-index
  - leaves the data blocks

![](@attachment/Clipboard_2021-07-01-20-05-49.png)


- our challenge in translating indexes to trees is ensuring that all the leaf nodes on the same level, i.e. ensuring that the tree is balanced, since we want the expected access cost to each data block to be the same.

## B-Tree - Non-Ordering Key

- The B-Tree index ensures that all leaf nodes are at the same level
  - a B-Tree Node of order $p$ splits the searching space up to $p$ subspaces
    - i.e. each node points to $p$ other nodes as we go down the tree hierarchy
  - $p > 2$

- **Node** (order $p$)
  - block pointer, points to the data block
  - $p$ tree pointers, pointing to other nodes in the tree
  - key values , sorted such that children nodes have values smaller than their parent
  - usually one per block
  - we can store $p-1$ key values
  
![](@attachment/Clipboard_2021-07-02-15-52-00.png)

### Example - Creating a 3-Level B-Tree Index of order $p=23$ over a non-ordering, key

![](@attachment/Clipboard_2021-07-02-15-56-27.png)



#### Example - How many keys can be stored? (p and the trade-off between search speed and redundancy)

![](@attachment/Clipboard_2021-07-02-15-57-24.png)

#### Example - Calculating the number of bytes and blocks in the index

![](@attachment/Clipboard_2021-07-02-15-57-34.png)

### Optimisation - Maximise Fan-Out and Minimise Storage

- A B-Tree stores too much meta-data leading to increased overhead

fan-out
: the splitting factor of the search space , represented by the node order/number of pointers in each node (16 in the example above)

- Goal 1 : improve storage efficiency by freeing up space from the nodes
- Goal 2 : improve searching efficiency by maximising the fan-out of a node

- Hence, we should
  - maximise the number of tree-pointers per node (++fan-out)
  - maximise the blocking factor by squeezing more tree-pointers
  - remove the data pointers from the nodes
- We achieve this by using **B+ Trees**

## B+ Tree - Non-Ordering Key

- give *semantics* to the nodes
  - **Internal nodes**
    - guide the searching process (improvement on speed)
    - have no data pointers (maximise storage)
    - key values corresponding to the medians of key values in sub-trees are replicated in order to guide and expedite search (algorithms for how to choose this values are beyond the scope of this course)
  - Leaf nodes : reserved as pointers to data blocks
    - hold the actual data pointers
    - hold **all** the key values 
    - all leaf nodes are chained via a linked list, so instead of a tree pointer they include a pointer to each node in the list


![](@attachment/Clipboard_2021-07-02-16-28-57.png)

### Example - B vs B+ : speed improvements by removal of internal nodes

- Context
  - block (B) : 512b
  - key (V) :9b
  - data_p (Q) : 7b
  - tree_p (P) : 6b

- Task : calculate the maximum order $p$ for a B-Tree and a B+ Tree such that we can fit each node in one block


- **B+ Tree - Internal**
  - size of an internal node : $pP + (p-1)V$
  - required size to fit into a block $pP + (p-1)V \leq B$
  - giving us a maximum order $p=34$
- **B+ Tree - Leaf**
  - size of a leaf node : $p_LQ + p_LV + P$ ; (P in this case is just the `p_next` pointer of the linked list node)
  - required size to fit into a block $p_L(Q+V) + P \leq B$
  - giving us a maximum order $p_L = 31$


- **B-Tree**
  - size of an internal node : $pP + (p-1)(V+Q)$
  - required size to fit into a block $pP + (p-1)(V+Q) \leq B$
  - giving us a maximum order $p = 23$


- **Hence** , the B+ Tree has higher fan-out which leads to higher search speed and optimised storage since each subspace is split into 34 per level against the B Tree's 23

### Example - Creating a 3 Internal Level , 1 Leaf Level B+ Tree Index of order $p=34$ and $p_L=31$ over a non-ordering, key

![](@attachment/Clipboard_2021-07-02-17-59-28.png)

#### Example - How many keys can be stored? (p and the trade-off between search speed and redundancy)

![](@attachment/Clipboard_2021-07-02-17-59-43.png)

- The number of values we index is calculated by looking **only** at the values in the leaf nodes

### Appropriateness of B+ Tree

![](@attachment/Clipboard_2021-07-02-18-30-50.png)

- we define $a$ to be the ratio of total employees satisfying the query for some lower $L$ and upper $U$ bounds, and our goal would be to come up with a cost function w.r.t $a$

![](@attachment/Clipboard_2021-07-02-18-30-57.png)
![](@attachment/Clipboard_2021-07-02-18-31-04.png)

- as before, when we are dealing with a range query we must first find the leaf node corresponding to the lower bound key
  - if we define the path from the root to that node, we get at least $t$ block accesses
  - if we then look at the worst case scenario, where all the employees within the range live in different data blocks, we'll then need to retrieve all those blocks linked to the leaf node, giving us a further cost of $q$
  - we'll then traverse the linked list until we reach the leaf node containing the upper bound. Since our range is $(U-L)$ and each leaf node can store $q$ blocks we'll need to access $\frac{(U-L)}{q}-1$ leaf blocks (we subtract the lower bound node which we've already accounted for). Lastly, we can rewrite this expression in terms of our definition of the ratio $a = \frac{U-L}{n}$, giving us a further cost of $\frac{an}{q} - 1$
  - Once we know which leaf nodes we need to access, all it's left is retrieving the $q$ data blocks from each of those nodes. Giving us a further cost of $(\frac{an}{q} - 1)q$

- Hence, our total cost $C(a)$ is given by:

$$C(a) = q + t + \frac{an}{q} - 1 + (frac{an}{q} - 1)q = an\Big(1 + \frac{1}{q}\Big) + (t-1)$$

![](@attachment/Clipboard_2021-07-02-18-31-12.png)

- If we plugin the known variables from our context we get our cost function in terms of our range $a$

$$C(a) = 1375a + 3$$

- We are now able to see for which values of $a$ it makes sense to use our B+ Tree over the linear scan, in particular we want $C(a) < 1250$ , since in the linear scan case (primary path search) the cost is independent of the range ratio we would just need to scan all of the blocks.
  - Hence, we find that $a < 0.906$

## Overall Comparison

### Context , Secondary Index
![](@attachment/Clipboard_2021-07-02-18-05-26.png)

![](@attachment/Clipboard_2021-07-02-18-10-22.png)

### B+ Tree

![](@attachment/Clipboard_2021-07-02-18-27-23.png)

- how to decide on the required number of levels?
  - we must start from the root and we keep adding levels until reaching the level such that the corresponding leaf node level is large enough to hold all keys (the 100K records)
  - since the number of keys at the nth level (0 index) is given by $25^n \times 24$ we require $25^n \times 24 \geq 100,000 \equiv n \geq 2.5$ , i.e 3 levels
- note that the lead nodes in this case will be very sparse since we'll have a total of 375K leaf nodes, leading to a staggering 73% memory waste 
- note also that we would require more blocks than those existent in the file , leading to huge overhead

- In general (here just for clarity, but it is fairly straightforward to derive): number of required levels for $k$ keys given a tree of order $p$
$$\Big\lceil\log_{p}\Big(\frac{k}{p-1}\Big)\Big\rceil$$

## Example (Tutorial) B+ Tree - Non-ordering , Non-Key


![](@attachment/Clipboard_2021-07-03-00-10-14.png)
![](@attachment/Clipboard_2021-07-03-00-26-11.png)
![](@attachment/Clipboard_2021-07-03-00-26-39.png)
![](@attachment/Clipboard_2021-07-03-00-26-54.png)

- We pair the B+ Tree with a secondary index, in doing so we can use the tree (instead of a simple index) to efficiently search the block of pointers leading to the actual values pointed by the secondary index
- Since each DNO can have at most 100 employees and each leaf node can take 100 pointer blocks, even in the worst case scenario where each employee lives in a separate data block (meaning that we need 100 pointers) we have enough space in each node to store all the pointers. Hence, we only need as many leaf nodes as there are distinct DNOs