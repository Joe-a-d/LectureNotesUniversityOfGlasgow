# ANSI C - Syntax - Grammar

[^1] Sources

[^1]:https://www.programiz.com/c-programming/c-keywords-identifier

### Keywords, Identifiers and Directives 

**Identifier** refers to name given to entities such as variables, functions, structures, type aliases etc

**Directives** are instructions to the processor or the compiler and always start with a `#`

### Comments

`/* */`
`//`

### Identifiers - Definitions and Declarations

In C all identifiers must be **declared** before they are used. 
To declare a identifier just means to assign a name and type to that identifier, it allows the compiler to know the properties of that idenftifier. 

It is important to distinguish between the different elements of a variable. Take the counter `i` in a loop. The following declaration `size_t i;` tells us that we have declared a `variable` of type `size_t` whose identifier we've named as `i` and whose value is yet not defined.

>> Declarations are bound to the scope in which they appear


A declaration can then be **defined** , i.e instantiated, given a value at a later time, which the linker will need in order to link the references to the actual implementation.

```i = 0```

>> Declarations specify identifiers, whereas definitions specify objects

### Statements

Statements are instructions that tell the compiler what to do with the identifiers declared, e.g. iterators, function calls, function returns.

### Conditional Execution

C does not have boolean keywords, instead `0 == False` `!0 == True` . There is however the library `<stdbool.h>` which provides the boolean types `true, false`

>> Avoid boolean comparisons, use the values directly in the condition , i.e `if (b)` instead of `if (b != 0)`

### Iterators

`for (;;)` is just the same as `while (true)`, the controlling expression can be omited and it will evaluate to true








