# ANSI C - Compiling

C is a *general-purpose* , *imperative - procedural* , *statically typed* programming language. 

Every C programs consists only of functions and variables

### Supported Control-Flow Statements:

- decision : `if-else`
- cases : `switch`
- loops : `while`, `for`, `do`, `break`

### Not Supported

- operations that deal with composite objects (strings, sets, arrays, lists)
- no heap or garbage collection
- no I/O or file access methods (though common libraries include functions to achieve these)


## Compiling Process

The compiling of code is the act of transforming the source code of a program into an executable file which can be run by the OS.

There are two kinds of source files in C:
  - [Header Files](https://gcc.gnu.org/onlinedocs/cpp/Header-Files.html) : a file containing C declarations and macro definitions to be shared between several source files. Its contents can be requested in a program by including it, with the C preprocessing *directive* `#include`.  It is conventional to end filenames with `.h`

  - [Compilation Units] : These are `.c` files whose directives are replaced by the contents of the header files. Each file is compiled separately to keep compilation times short

The compilation process can be split into 3/4 main steps:

### Preprocessor

During the preprocessing stage the preprocessor will look at the source code and replace all directives and macros with the contents of their corresponsing files. For examples `#include <stdio.h>` will copy the contents of the I/O library `stdio.h`

To see an example of the output run `gcc -E`

#### Include syntax

- `#include <file>` : This variant is used for **system header files**. It searches for a file named file in a standard list of system directories

- `#include "file"` : This variant is used for header files of your own program. It searches for a file named file first in the directory containing the current file, then in the quote directories and then the same directories used for `<file>`

### Compiler & Assembler

The compiler transforms the preprocessed code into assembly code which in turn are turned into **object** files `.o` (almost executable) by the assembler

### Linker

The linker will then find, for each name appearing in the object code, the address that was eventually assigned to that name, make the substitution, and produce a true single binary executable in which all names have been replaced by addresses


### MacOS Compiler

The official compiler used to be the `GNU Compiler Collection - GCC` , nowadays is the `Clang` compiler. The process of compiling is very similar for both:

``` clang -o <outFile> <Source> ```



SOURCES:

https://www.cs.odu.edu/~zeil/cs252/latest/Public/compilation/index.html#the-structure-of-c-and-c-programs