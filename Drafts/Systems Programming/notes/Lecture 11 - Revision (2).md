# Lecture 11 - Revision

# Part 1

- data types
  - meaning
  - details (bits in memory)
- structs
  - how we use them to implement data structures
  - basic ADTs
- pointers
- variable storage in memory
  - fixed location
  - how it is stored
  - how much space a type needs
  - how pointers use memory addresses to redirect to other addresses
- stack vs heap
  - automatically vs manually memory management
- ownership of memory

# Part 2 - Concurrency

- what?
- threads
  - within process
  - shared address space
  - communicate via shared memory
- issues
  - race conditions, etc

- read and write **thread safe** code using *pthreads*
  - mutual exclusion with mutex
  - condition variables to avoid busy waiting

- coordination vs computation
  - discuss different levels of abstraction
- understand the bounded-buffer/producer-consumer problem
- read and write **thread-safe** *abstractions*
  - monitors
  - semaphores
### C++
- read and write code for synchronisation
  - mutexes
  - async , futures/promises
- manipulating tasks as first class objects
  - pacakged_task
- be able to explain differences between different C++ coordination abstractions
  - pros/cons

# New Types of Questions

- **Stack, Heap**
  - you will be asked to show the stack and heap after a progam executes
  - show how they grow opposite, towards middle
  - show how the whole structure occupies the memory, showing a line for each variable

![](@attachment/Clipboard_2021-08-12-19-23-55.png)

- mostly fill the gap questions for the code question, except for part 2 where you are expected to write blocks of code
