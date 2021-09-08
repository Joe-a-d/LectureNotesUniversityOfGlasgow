# Lecture 4 - Memory Management & Ownership

## Pointer Recap 

![](@attachment/Clipboard_2021-05-22-02-03-02.png)



#### Binary Tree

```C
#include <stdio.h>
#include <stdlib.h>

struct node {
  const void * value_ptr; // void allows for generic tree
  struct node * left_child;
  struct node * right_child;

  node(const void * value_ptr) {
      this->value_ptr = value_ptr;
      this->left_child = NULL;
      this->right_child = NULL;
  }

  void add_left_child(const void* value_ptr) {
    if (this->left_child) free(this->left_child);
    this->left_child = (struct node *)malloc(sizeof(struct node));
    if (this->left_child) {
      this->left_child->value_ptr = value_ptr;
      this->left_child->left_child = NULL;
      this->left_child->right_child = NULL;
    }
  }

  void add_right_child(const void* value_ptr) {
    if (this->right_child) free(right_child);
    this->right_child = (struct node *)malloc(sizeof(struct node));
    if (this->right_child) {
      this->right_child->value_ptr = value_ptr;
      this->right_child->left_child = NULL;
      this->right_child->right_child = NULL;
    }
  }

  ~node() {
    free(this->left_child);
    free(this->right_child);
  }
};

typedef struct node node;

void print_string(const void * value_ptr) {
  const char * string = (const char*)value_ptr; // by changing the type we give the bits again meaning
  printf("%s\n", string);
}

// because we cannot dereference a void pointer, we need to allow the caller to specify how to print the value
//// we can do this by using **function pointers** which in this case converts the void pointer to string type
void print(node * root, void (* print_function)(const void *) ) {
  if (root) {
    print_function(root->value_ptr);
    print(root->left_child, print_function);
    print(root->right_child, print_function);
  }
}

int main() {
  //   b    |
  //  / \   |
  // a  c   |
  //   / \  |
  //  d  e  |
  node root = node("b");
  root.add_left_child("a");
  root.add_right_child("c");
  root.right_child->add_left_child("d");
  root.right_child->add_right_child("e");
  print(&root, print_string);
}
```

### Mem Management Challenges

- *double free error* : attempting to free a pointer which was not allocated
- *dangling pointers*

- *memory leak* : when `free` is not called for a an heap-allocated pointer
  - below a 20b memory is allocated
  - we allocate further 30b, so the pointer moves to this new block
  - we call free which removes the 30b
  - we never call free on the first 20b block and so it stays in memory, it leaked

![](@attachment/Clipboard_2020-11-02-04-18-14.png)

## Ownership

- a strategy to better manage what can create and destroy pointers
- make a specific part of your program responsible for calling `malloc` and `free`
  - e.g., make the parent in a tree own its children, such that the parent is responsible for allocating and freeing memory used by its children

- REM : In C this is just a convention/suggestion, nothing in the language enforces or helps with this

### C++ RAII

- a programming idiom existent in the language, *Resource acquisition is initialisation*
  - we tie the management of a resource to the lifetime of a variable on the stack
  - the allocation of the resource (e.g. malloc call) is done when we create the variable
  - the deallocation (e.g free) is done when the variable is destroyed

- Implemented by representing a resource by a local *object*, where the :
  - constructor creates the values, allocating the resource
  - destructor frees up the resource
- this way, the programmer cannot forget to release the resource, since when a resource-owning stack object goes out of scope, its destructor is automatically invoked

```cpp
struct ints_on_the_heap { // This is C++ code and not legal C!
int * ptr;
// constructor
ints_on_the_heap(int size) {
ptr = (int*)malloc(sizeof(int) * size);
}
// destructor
~ints_on_the_heap() { free(ptr); }
};
typedef struct ints_on_the_heap ints_on_the_heap;
```

- C++ provides common data types build with RAII for easy and non-leaking mem management
  - `std::vector` for storing multiple values of the same type on the heap
  - for storing single values, there exist two "smart" pointers:
    -  `std::unique_ptr` for unique ownership (owner is known, e.g. simple scope)
    -  `std::share_ptr` for shared ownership (unknown owner, e.g. concurrency and multithreading)


### Ownership transfer

see slides

