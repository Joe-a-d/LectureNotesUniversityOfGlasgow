# Lecture 2 - Representation of Numbers

![](@attachment/Clipboard_2021-05-21-21-26-56.png)


# Number Types

- different represenations of numbers can be stored in arrays
  - highlight integers and floating point numbers
- algebraic properties of operators on real numbers are not preserved with the representation of numbers used for computations due to approximations used to store these numbers

## Integers 

- represent whole numbers
  - signed (binary 2's complemenent)
  - unsigned (unsigned binary)

Most 64bit systems support operations on at least the following integer types: 
$$
\begin{array}{rrrr}\text { name } & \text{ bytes } & \text { min } & \text { max } \\ \hline \text { int8 } & 1 & -128 & 127 \\ \text { uint8 } & 1 & 0 & 255 \\ \text { int16 } & 2 & -32,768 & 32,767 \\ \text { uint16 } & 2 & 0 & 65,535 \\ \text { int32 } & 4 & -2,147,483,648 & 2,147,483,647 \\ \text { uint32 } & 4 & 0 & 4,294,967,295 \\ \text { int64 } & 8 & -9,223,372,036,854,775,808 & +9,223,372,036,854,775,807 \\ \text { uint64 } & 8 & 0 & 18,446,744,073,709,551,615\end{array}
$$

- if an operation exceeds the bound of the type, an *overflow* occurs , usually what happens is that they would wrap around

## Floats

- may be very large or very small
- fractional parts
- not straightforward to work with, because have some properties which can cause numerical issues
- usually supported at the hardware level


### Representation

- sign
- *mantissa* : a fractional number with a standardised range (1.0 just below 2.0)
- *exponent* : scaling factor (powers of 2)

```
sign * (1.[mantissa]) * (2^exponent)
```

- think of floats as numbers [1.0 - 2.0) that cna be shifted and stretched by doubling or halving multiple times
  - allows representation of very large range of numbers using a relatively small number of digits
  - variable precision
    - the spacing of the gaps between the ranges becomes larger as it scales up

- the leading one is not stores, instead is implied

**EXAMPLE - FLOAT32**

- the exponent are stored with an implied offset of -127 (the bias)
- take the following `float32` number
  - `1 10000011 00100111010001001000101`

- Sign : `1` , hence negative
- Mantissa : `00100111010001001000101` = $1.00100111010001001000101_2 = 1.153389573097229_{10}$
- Exponent : `10000011` = $131$ , hence shift of $2^{131} - 2^{127} = 2^4$


#### IEEE 754

- standard ways of representing floating point numbers

- binary 32 , 64 are the most common
  - *single precision* : base 2 , 24 digits
  - *double precision* : base 2 , 53 digits


![Float64 representation of 5.0](@attachment/Clipboard_2021-05-21-22-00-02.png)

![Float64 representation of 1.0/3.0](@attachment/Clipboard_2021-05-21-22-00-48.png)

- For `float64` integers in the range [$-2^53 , 2^53$] can be represented precisely, since that's the effectively the number of bits available in the mantissa

### Special Properties

#### Exceptions

- Occur in hardware during calculations, propagating up through he software to handle
  - untrapped : hardware does nothing, but instead just substitutes by a default values (e.g. NaN)
  - trapped : software is notified and decides how to handle

- **Invalid Operation** 
- **Division by Zero**
- **Overflow**
- **Underflow**
- **Inexact** : error due to rounding

#### Zero, inf, NaN

- Zero has both positive and negative representations
  - work the same way, and compare equal but the sign bit propagates
- Infinity has both positive and negative representations
  - represented by using a bit pattern of all ones for the exponent and all zeros for the mantissa
- NaN represents invalid numbers
  - it propagates, so that every operation involving NaN results in NaN
  - comparison evaluates to false, but `NaN ≠ False`
  - represented by having exponent bits all set to ones and any non-zero bits in the mantissa


### Roundoff and Precision

- can introduce roundoff error, because the operations involved have to quantise the
results of computations
  - precision varies with the magnitude of the number

- rounding errors accumulate when doing repeated operations, leading to very innacurate results.
  - *magnitude error* : adding numbers with very different magnitudes
  - *cancelation error* : subtracting numbers very close to each other

- because floating point errors accumulate, equality comparisons `==` are not appropriate, instead one should compare that their absolute difference is smaller than some threshold
  - numpy uses sensible defaults in `allclose()`

- we can quanitfy how good or bad floating points are at representing real numbers by calculating its *relative error*
  - IEEE 754 guaranteed that this error is always less than 
$$
\epsilon \leq \frac{1}{2} 2^{-t}, \epsilon \leq 2^{-t-1}
$$

$$
\epsilon=\frac{\mid \text { float }(x)-x \mid}{|x|}
$$


## Array Layout and Structure

- multidimensional numeric arrays `ndarrays` are the fundamental data structure for this course
  - efficient in memory and computational terms
  - by default in numpy are `float64` if any float exists upon creation `int32` otherwise
- specific implementations differ, but a common thing to use is a *densely packed format*, where numbers are stored in a block right after another. There is no metadata, pointers in between just a header at the start describing its shape for indexing
  - `np.ravel()` unravels the blocks into a 1D array, in order of how they are stored in memory

### Strides and Shape

- striding implements multidimensional indexing
  - strides tells you the memory offsets for each dimension in bytes, indicating how far you need to jump in order to get to the next element in a particular dimension

EXAMPLE : To find the array element at index `[i,j]` in a 2D matrix, the memory offset from the start of the number block will be:
`i * stride[0] + j * stride[1]`


  ![](@attachment/Clipboard_2021-05-22-00-11-52.png)

#### Dope fiends

- this kind of representation is called a *dope vector*, where the striding info (the dope vector) lives in the header of the array

- the *Illife vector* uses nested pointers (e.g. a python list)
  - easy to store but computationally far less efficient

  ![](@attachment/Clipboard_2021-05-22-00-17-04.png)

### Transposing

- transposition can be done in `O(1)` because the elements are never touched, instead the shape and stride elements of the dope vector are swapped
  - similarly, reversing can be done by just pointing to the end of the array and change the strides to be negative
  - other rigid transformations such as flipping, can be done in similar ways

### Order

- two standard ways to order an array in memory
  - C order (or row major) : reads them inline, i.e. left-right
  - Fortran order (or column major) : reads them column wise, i.e top-bottom

## Tensor Operations

### Reshaping
- rewriting the stride vector
- allows operations which interpret the way in which the array is ordered but don't change the elements themselves, the number of elements, or what its contained within them
- the order in memory never changes, but they may wrap at different points
- the speed at which it changes follows the *"pouring rule"*, where the last dimension changes fastest, the second last second fastest, etc.

- squeezing and adding dimensions allow us to work with a *singleton dimension*
  - in order to work on vectors using matrix operations, we need to *promote* the vectors to matrix
  - this can be done by adding a new *singleton dimension* via reshaping, i.e. adding a new dimension with a shape of 1
  - in numpy you can pass the index `None` or `np.newaxis`, which inserts a new dimension in the strides
  - these singleton dimensions can be removed by simply indexing into the dimension
    - squeeze removes every singleton dimension
      - `np.squeeze()`

### Swapping and Rearranging Axes

- `np.swapaxes()` , swaps any pair of axes
- often used in combination with reshaping, because reshaping always follows the pouring rules, which is not what you might want
  - rearrange
  - reshape
  - (optionally) rearrange


> REM for examples of practical applications such as image manipulation, see the jupyter notebook


### Einstein Summation Notation

- a powerful generalisation of these operations
  - `np.einsum()`
  - a much simpler way to reorder higher-rank tensors
  - works by assigning a letter to each dimension and then write the dimension rearrangement as a string
    - e.g., `ij -> ji` transposes a 2D matrix
