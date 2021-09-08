# Lecture 3 - Memory & Pointers


### Memory

- memory as a labeled cabinet, where label == variable name

- memory as a street lane, each house as a unique address but we also have a notion of *spacial locality* which is a feature explored by *caches*

- **caches** are memories which are placed very close to the CPU, allowing fast access

- *byte-addressable* memory, every byte (8bit) has its own address. On an *n-bit* arch each address is $n$ bits long

- to modify a single bit we **always** have to load and store an entire byte

- the location of a variable is identifiable by its address and depending on the data type the value of a variable may span multiple bytes

### Pointers

- `&` - address-of-operator which returns the address of a variable
- `*` - deference operator which returns the value stored at an address
- ` (*ptr).value == ptr -> value` 

- **pointers** are a special type of variable which store addresses of variables

- a pointer to a variable of type `t` has type `t *`
- Every pointer has the same size because it always stores an address and not its value, if the type stored spans multiple bytes in memory then it will point to the start of the value

How would you store the address of a pointer in another ptrs? `int * * ptr2 = &ptr`

- we can change what a pointer points to

- If there is no meaningul value for a pointer at a certain time we use `NULL` or `0`  to represent that it points to nothing



#### Pointers & `const`

- making the pointer constant but allowing the value to change : `float * const ptr`
- making the value fixed : `const float * ptr`
- making both fixed : `const float * const ptr`

 
#### Arrays in Memory

- arrays are always stored in *row-major* format, i.e rows are stored after one another. So if you are storing a 2D array the only thing that will change is the label of a variable.

 ``` 
 	 matrix[2][3] = { {1,2},{3,4}}
     matrix[0][0] -> 1 , matrix[1][0] -> 4
     but this will be stored as a sequential block in memory 
     [1,2,3,4] 
```
- name of the array referes to the address of the 1st el of the array
- we can use array indexing notation on pointers ptr[n] -> el n+1

#### Pointer arithmetic

- used to modify the value of a pointer

- the compiler takes care of applying the appropriate size according to each pointer, i.e if you want to step 1 unit it will first check the data type of the value the pointer points to if e.g. `int` then `int * i_ptr = &i; i++` will add `4B` to ptr , dealing with chars will add `1B` and so on
Hence, `ptr[i]` is just sintactic sugar for `*(ptr + i)`


#### Pointers & Structs

**Building a LL using pointers and structs**

- `structs` are essentially grouped objects under a common label


```C
#include <stdio.h>

struct node {
  int value;
  struct node * next;
};

int main() {
  struct node c = {3, NULL};
  struct node b = {2, &c};
  struct node a = {1, &b};

  struct node * ptr = &a;
  while (ptr) {
    printf("%d\n", ptr->value);
    ptr = ptr->next;
  }
}
```


#### `void *`

- if you need to work on pointers (e.g swap pointers of unknown types) then we can use the generic pointer of type `void *` . Since pointers only contain addresses we can write a function which operates on these addresses, and then when we initialise the function all we need to do is to make sure that we initialise this void pointers into concrete types so that they can be dereferenced.
- **derefencering a void pointer is not allowed**

e.g generic swap function

#### `main` with cmd line arguments

``` C
int main(int argc, char* argv[])
``` 

- `argc` : # of arguments passed
- `argv` : array of args as strings, i.e as an array of `char`
- `argv char * []` == `char * *`

rem: recall that `array[]` is the same as `* array` because an array is treated like a pointer where `[]` just points to the first el

#### Function Pointers

- pointers pointing to code, e.g passing functions as args to other functions

- Type: ` return_type(*)(argument  types)`

!! EXPAND !!

### Stack vs Heap

- Stack : where variables with automatic lifetime are stored
	- static size, i.e known pre-compilation

- Heap : where variables which need to be **dynamically generated** are stored
	- memory has to be requested and freed manually

**n.b** stack and heap share the same address space and grow *towards* each other, they compete for access

## Dynamic Memory Management

### malloc

- responsible for requesting memory from the heap

`void* malloc(size_t size); // <stdlib.h>`

- pass the number of bytes to be allocated as an argument
	- using `sizeof` is a common approach

`void free(void* ptr)` : frees up allocated memory

- return values:
	- success : void pointer to first byte of the uninitialised memory
	- fail : NULL pointer



e.g // see extended LL example L3@23
