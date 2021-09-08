# Week 2 - Clustering , K-Means

<div id="content">

*"Clustering algorithms group a set of documents into subsets or clusters . The algorithms' goal is to create clusters that are coherent internally, but clearly different from each other. In other words, documents within a cluster should be as similar as possible"* [^1]

Flat Clustering Algorithm
: creates a flat set of clusters without any explicit structure that would realte clusters to each other [^1]

Hierarchical Clustering
: can be seen as creating clusters within clusters, where the partioning number is not given as a parameter but it emerges from the algorithm


**Key Properties**:
- Partitioning Criteria : flat vs hierarchical
- Separation of clusters : exclusive vs overlapping
- Hard vs fuzzy : in fuzzy an object belongs to every cluster with weight $0 \leq w \leq 1$

## Process

1. Derive a document representation (typically vectors of weighted terms)
2. Measure similarity
3. Apply a clustering method
4. Check the validity/quality of the clustering


## K-means

K-means is the most well known , and most important flat clustering algorithm, which works by minimising the average squared *Euclidean Distance* of documents from their cluster centres


Cluster Centre
: the mean/*centroid* of the documents in a cluster 

Centroid
: $$\vec{\mu}(\omega)=\frac{1}{|\omega|} \sum_{\vec{x} \in \omega} \vec{x}$$


Residual Sum of Squares
: the squared distance of each vector from its centroid summed over all vectors. It functions as a measure of how well the centroid represent the members of their clusters
: $$\mathrm{RSS}_{k}=\sum_{\vec{x} \in \omega_{k}}\left|\vec{x}-\vec{\mu}\left(\omega_{k}\right)\right|^{2}$$


WE can see RSS as our objective function when using K-means, hence our goal is to minimise it.


### Algorithm

Assume that there are $K$ clusters, where each cluster is defined by a position in the input space $\mu_k = [\mu_{k_1},\mu_{k_2}]^T$, then each example $x_n$ is assigned to the cluster whose euclidean distance from the example is the smallest

$$\min{d_{nk} = (x_n-\mu_k)^T(x_n-\mu_l)}$$

There is no analytical solution, i.e we can't write down $\mu_k$ as a function of our examples vector $X$, so we use an iterative algorithm. We move the cluster centres around in space in order to minimise RSS

1. Guess initial clusters
2. Assign each $x_n$ (documents) to its closest $\mu_k$
3. Set $z_{nk} = 1$ if $x_n$ assigned to $\mu_k$ or $0$ otherwise
4. Update $\mu_k$ to average of $x_n$s assigned to $\mu_k$
  MATHPIX
5. Repeat from 2. until assignments remain the same

![](@attachment/Clipboard_2021-02-02-12-12-22.png)

REM
: On top of termination when $RSS \leq \theta$ , where $\theta$ is some previously defined threshold, it is often necessary to bound the number of iterations to guarantee termination

#### Characteristics

- Converges quickly
- Sensitive to the choice of inicial seeds
- Breaks when data has a clear cluster structure

![](@attachment/Clipboard_2021-02-02-14-55-49.png)

- Complexity : $O(NK)$ , where $N,K$ represent the number of documents and clusters respectively

\mymarginpar{visualising k-means https://www.naftaliharris.com/blog/visualizing-k-means-clustering/}


### Choosing K 

K-means is sensitive to the value of $K$, and for $K>3$ is difficult to visualise the data dimensions in order to choose an appropriate one. Can we examine the "conherence" of each topic? What is the centroid representing?

#### Elbow Method

We run the algorithm for different values of $K$ and at each iteration we compute the distortion score metric. We'll observe that there will be a clear point of inflection on the curve which is a good indication that that is the best $K$ to use

Distortion Score
: computes the sum of squared distances from each point to its assigned centre

![](@attachment/Clipboard_2021-02-02-16-04-01.png)[^2]

#### Silhouette Coefficient

The SC combines ideas of both cohesion and separation, but for individual points, as well as clusters and clusterings. Let $i$ represent and individual object, and $C_i$ represent its cluster

Cohesion $a(i)$
: represents the mean distance between $i$ and all other data points in the same cluster; it represents how well $i$ was assigned to its cluster
: $$a(i)=\frac{1}{\left|C_{i}\right|-1} \sum_{j \in C_{i}, i \neq j} d(i, j)$$

- $d(i,j)$ represents the distance between points $i,j$ in the same cluster
- we divide by $\left|C_{i}\right|-1$ because $d(i,j)$ is not included in the sum

Separation $b(i)$
: represents the smallest distance of $i$ to all points in *any other* cluster of which $i$ is not a member
: $$b(i)=\min _{k \neq i} \frac{1}{\left|C_{k}\right|} \sum_{j \in C_{k}} d(i, j)$$

Silhouette Coefficient
: a measure of how similar an object is to its own cluster (cohesion) compared to other clusters (separation). The silhouette ranges from −1 to +1, where a high value indicates that the object is well matched to its own cluster and poorly matched to neighbouring clusters [^3]
: $$s(i)=\frac{b(i)-a(i)}{\max \{a(i), b(i)\}}, \text { if }\left|C_{i}\right|>1$$
: or
: $$s(i)=\left\{\begin{array}{ll}1-a(i) / b(i), & \text { if } a(i)<b(i) \\ 0, & \text { if } a(i)=b(i) \\ b(i) / a(i)-1, & \text { if } a(i)>b(i)\end{array}\right.$$

Note in the example below how the `n_clusters` value of 3, 5 and 6 are a bad pick for the given data due to :
- the presence of clusters with below average silhouette scores
- wide fluctuations in the size of the silhouette plots

![](@attachment/Clipboard_2021-02-02-16-28-14.png)

```bash
For n_clusters = 2 The average silhouette_score is : 0.7049787496083262
For n_clusters = 3 The average silhouette_score is : 0.5882004012129721
For n_clusters = 4 The average silhouette_score is : 0.6505186632729437
For n_clusters = 5 The average silhouette_score is : 0.56376469026194
For n_clusters = 6 The average silhouette_score is : 0.4504666294372765
```

Also from the thickness of the silhouette plot the cluster size can be visualized. The silhouette plot for cluster 0 when n_clusters is equal to 2, is bigger in size owing to the grouping of the 3 sub clusters into one big cluster. However when the n_clusters is equal to 4, all the plots are more or less of similar thickness and hence are of similar sizes as can be also verified from the labelled scatter plot on the right. [^4]

### Mini-batch K-means

Running similarity over all items in a large dataset is slow, so we can instead compare using a representative sample. 

The MBK uses  MB Gradient Descent for optimisation and reduces complexity while still achieving better results than regular SGD


![](@attachment/Clipboard_2021-02-02-16-45-52.png)

## Hierarchical Clustering

Results in a tree-like representation of the documents where clusters whose elements are highly similar are nested within clusters whose elements are less similar. There are two main approaches : agglomerative (bottom-up) and divisive (top-down)

### Agglomerative

Begin with singletons at the bottom and merge them until the whole dataset becomes the root of the tree

REM
: typical approach

#### Single-Link

A variant where at each step we combine two clusters that contain the closest pair of elements not yet belonging to the same cluster as each other, if the elements are closer than a set threshold

[Example](https://en.wikipedia.org/wiki/Single-linkage_clustering#Working_example)

### Divisive

Recursively partition the entire dataset until singleton sets are reached

## K-means vs Hierarchichal

- K-means is more efficient : $O(KN) vs O(N^2)$
- Produce similar clusters
- K-means main drawback is that $K$ needs to be defined upfront

## Clustering Evaluation

!! TODO look for external sources, messy wave-handing lecture !!


</div>

# REF

[^1]: https://nlp.stanford.edu/IR-book/html/htmledition/flat-clustering-1.html
[^2]:https://www.scikit-yb.org/en/latest/api/cluster/elbow.html
[^3]: https://en.wikipedia.org/wiki/Silhouette_(clustering)
[^4]: https://scikit-learn.org/stable/auto_examples/cluster/plot_kmeans_silhouette_analysis.html