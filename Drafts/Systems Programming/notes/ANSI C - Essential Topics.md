# ANSI C - Essential Topics 

## Data Types

> The meaning of a value stored in an object or returned by a function is determined by the type of the expression used to access it.

Types are partioned into *object types* and *function types*
### Basic
  - `int`

  - `float`

  - `char`

  - `double`
  
  - `void`

#### Qualifiers

  - `signed`
  
  - `unsigned`

  - `short`

  - `long`

### Derived

  - `function`

  - `array` 

    - describes a contiguously allocated nonempty set of objects with a particular member object type, called the element type, i.e all elements of an array must have the same type

    - array types are characterized by their element type and the number of elements in the array

          element_type identifier[size]

  - `struct`
  
    - describes a sequentially allocated nonempty set of member objects, each of which has an *optionally* specified name and *possibly* distinct type, i.e a collection of objects of possibly different types grouped under a single name

        ```c
        // EXAMPLE anonymous/unnamed member struct:

        struct v {
          union { // anonymous union
          struct { int i, j; }; // anonymous structure
          struct { long k, l; } w; // not anonymous named w
          }; int m;
        } v1; // declare variable v1 of type struct v
 
        v1.i = 2;   // valid
        v1.k = 3;   // invalid: inner structure is not anonymous
        v1.w.k = 5; // valid```


  - `pointer`

 




## Declarations
### Declaring variable of the above types
### Scope and lifetime of variables
## Statements
### Assignment, including short forms such as x++
### If-statement
### While and for loops
## Functions
### Function declaration and invocation
### Parameters of types listed above; parameter passing; use of pointers when passing parameters
### Use of void as a return type
## Memory allocation; the stack and the heap
## The idea that a program contains a main method