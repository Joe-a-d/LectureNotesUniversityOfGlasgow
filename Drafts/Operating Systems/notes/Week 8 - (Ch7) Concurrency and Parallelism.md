# Week 8 - (Ch7) Concurrency and Parallelism

## example of semaphore for buffer-prducer (sync) vs for mutual exclusion

https://www.unf.edu/public/cop4610/ree/Notes/PPT/PPT8E/CH%2005%20-OS8e.pdf

![](@attachment/Clipboard_2021-07-29-01-06-02.png)
![](@attachment/Clipboard_2021-07-29-01-06-23.png)
![](@attachment/Clipboard_2021-07-29-01-06-58.png)

# Today

- how OS supports concurrency
- how OS assists in exploiting hardware parallelism
- how the above are used to write parallel and concurrent programs
- POSIX threads
- parallel programming techniques
  - OpenMP, MPI, OpenCL

# Definitions

Concurrency
: more than one task is running in overlapping time, but not necessarily at the same instant

Parallelism
: when a system has more than one CPU core so that it can execute several tasks at the same time

> Concurrency is two lines of customers ordering from a single cashier (lines take turns ordering)
Parallelism is two lines of customers ordering from two cashiers (each line gets its own cashier)
[^1]

Deadlock
: when two or more processes are waiting indefinitely for an event that can be caused only by one of the waiting processes [^2]

Critical Section/Region
: portion of a program where no other process is allowed to execute at the same time because it affects a shared resource (e.g. common variables, writing to file etc.)

Synchronisation
: the cooperative act of two or more threads that ensures that each thread reaches a known point of operation in relationship to other threads before continuing [^3]

Semaphore
: a mechanism to protect a shared resource ; a non-negative integer variable which can only be accessed by two atomic operations (wait, signal)

Mutex
: a variable used to indicate the state of the critical section (locked , unlocked)

Memory Barrier
: imposes a perceived partial ordering over the memory operations on either side of the barrier, so that hardware performance improvement "tricks" do not override instructions in code

# Concurrency

## Issues

- two factors that can cause problems
  - shared resources
  - exchange of information between tasks

### Shared Resources

- train analogy
  - 4 tracks share a single track section
  - *semaphores* exist at the start of the shared section to indicate if it is already in use

- OS possible shared resources
  - file system, IO devices, memory
  - e.g. open a text file using an editor, modify it via another process and write to disk
    - the editor will warn you that the file has been changed so that changes are not overwritten
  - other resources are not controlled by the end user (though technically it is still up to the programmer to make use of the API (e.g. POSIX) to exploit the hardware support)
    - I/O up to OS
    - access to shared **memory** is particularly tricky because usually processes have their own memory space, **but** in multithreaded processes memory is shared between threads

### Exchanging Information

- if concurrent tasks need to exchange information to continue execution, the sender either
  - waits for the message (late arrival)
  - stores the messages until its needed (early arrival)
  - **deadlock** may occur if both tasks require information from one another
- communication between threads occurs via the shared memory
- communication between processes 
  - shared files
  - pipes
  - sockets
  - messaque queues
  - shared memory
- **producer-consumer problem**
  - each $p$ is either a producer or consumer of information
  - rate of consumption and production are usually not synchronised
  - require buffers (limited memory)
    - common for each consumer to have a buffer per producer
    - if buffer full -> producer waits
    - if buffer empty -> consumer waits

> control of access to shared resources and synchronisation of the exchange of information are two different views of the same problem. Hence, there will be a single set of mechanisms that can be used to address it

## Synchronisation Primitives

- software constructs provided by the OS which support thread/process synchronisation

### Semaphores - General Locks

- A semaphore can only be accessed through two atomic operations
  - `wait()` : blocks until the value of the register has been decremented
  - `signal()` : increment register

> Dijkstra introduced the above as `P(S)` and `V(S)` respectively from his native language

```
// definition of wait()
wait(S) {
  while (S <= 0)
    ; // busy wait
  S--;
}
```

```
// definition of signal()
signal(S){
  S++;
}
```

- Often a distinction is made between *counting* and *binary* semaphores
  - counting : ranges over an unrestricted positive domain
    - attempting to decrement when $S < 1$ blocks until another agent increments
  - binary : equivalent to a *mutex*
    - attempting to lock blocks until another agent unlocks

> IMPORTANT sempahores can be used in one of two ways. Binary semaphores like mutexes address the problem of mutual exclusion, addressing the problem of race conditions. The other use is for synchronisation where we want to make sure that different threads or processes access to the shared resource happen **in a certain order**. W.r.t the consumer-problem e.g. we want to guarantee that the producer waits before writing to the buffer if full and that the consumer goes to sleep if the buffer is empty

### ARM hardware support

> most details excluded

- **exclusive monitor** a simple state machine with the possible states open and exclusive
  - sync support between processors required
    - local monitor
    - global monitor
  - updates to state happen via *LOAD/STORE - exclusive* instructions
    - these are used by the kernel code to implement its own sync primitives, which in turn are used by POSIX

### Linux Synchronisation Primitives

- discussion of a few of the large number of sync primitives implemented

#### Atomic

- set of atomic operations know as *read-modify-write (RMW)*
  - value is read from a memory location, modified then written back **with the guarantee** that no other write will occur to that location between the read and the write
  - two classes
    - those that operate on special data types
    - those that operate on bitmaps
  - basic set written for each architecture are know as *atomic primitives*
    - used to write architecture-independent code (file system, drivers)

- atomic types
  - integers wrapped in a struct
  - wrapped because they need to opaque so that casting to a C int fails
- operations
    - init, read, write
    - macros exist to prevent unwanted behaviour from compiler optimisations
  - atomic behaviour is achieved by *masking the interrupt requests* and then restoring them through architecture-dependent functions
    - guarantees atomicity on single-core processor because the only way threads can interfere is via interrupts
  
#### Memory operation ordering

- in SMP system, access from different CPUs are in principle not ordered - *relaxed* 
- kernel imposes stric overall order via *memory barrier*
  - suppress hardware tricks that mess with ordering
  - general : no effect at runtime, compiler instruction
  - mandatory : full system level
  - conditional : consistency between different cores
  - implicit : use locking constructs to act as implicit barriers

#### Spin Lock

- simplest
- the task tying to acquire the lock goes into a loop doing nothing until it gets the lock
  - *busy waiting*
- useful for short tasks since it doesn't need to be put to sleep

#### Futex

- *fast user-space mutex*
- linux-specific mutex
  - optimised for the case when there is no contention for resources
- operations occur entirely in user space for the non-contented case
  - kernel steps in for the contended case
  - kernel creates a futex queue internally so that it can link the waiter to the waker without them having to communicate

#### Mutex

- linux mutexes are intended for kernel-use only
- three-state atomic counter
  - 1 : unlocked
  - 0 : locked (no waiters)
  - < 0 : locked (potential waiters)
- wait-queue 
  - access via spin lock
- three possible paths when acquiring mutex (failure means move to path below)
  - fastpath : try to atomically acquire lock by decrementing counter
  - midpath : spin for acquisition while the lock owner is running, and there are no other higher priority tasks ready
  - slowpath : add task to queue and sleep until woken by the unlock path

#### Semaphore

- generalisation of mutex
- integer count 
  - may be acquired $n$ times before sleeping
- spin lock controls access to the other members of the semaphore
- semaphore always sleeps

### POSIX sync primitives

- sync primitives provided by POSIX API for user space code

#### Mutex

- `pthread_mutex_t`
  - opaque
  - small integer

#### Semaphore

- counting
- `semt_t`
  - opaque
  - implements
    - `sem_wait()`
    - `sem_post()`
    - timed variants

#### Spin Lock

- `pthread_spin lock_t§
  - opaque
  - small integer
  - implements
    - init
    - destroy
    - lock
    - unlock

#### Condition Variables

- advanced locking construct
  - allows threads to sync based upon value of the data without need to poll
  - wait until condition is satisfied
- used in conjunction with mutex

```C
 pthread_mutex_t q_lock;
 pthread_cond_t q_cond;

void init(pthread_mutex_t* q_lock_ptr,q_cond_ptr) {
  pthread_mutex_init(q_lock_ptr,NULL);
  pthread_cond_init(q_cond_ptr,NULL);
 }

void wait_for_data(Queue_t* q) {
  pthread_mutex_lock(&q_lock);
  while(q->empty()) {
  // blocks until _cond_signal 
  // automatically and atomically unlocks the associated mutex when signal is received
    pthread_cond_wait(&q_cond, &q_lock); 
  }
  q->status=1;
pthread_mutex_unlock(&q_lock);
}

 void enqueue_data(Data_t* data, Queue_t* q) {
  pthread_mutex_lock(&q_lock);
  bool was_empty = (q->status==0);
  q->enqueue(data);
  q->status=1;
  pthread_mutex_unlock(&q_lock);
  if (was_empty)
  pthread_cond_signal(&q_cond); // request unlock
 }

 Data_t* dequeue_data(Queue_t* q) {
  pthread_mutex_lock(&RXlock);
  while(q->empty()) {
    pthread_cond_wait(&RXcond, &RXlock);
  }
  Data_t* t_elt=q->front();
  q->pop_front();
  if (q->empty()) q->status=0;
  pthread_mutex_unlock(&RXlock);
  return t_elt;
 }


 void clean_up(pthread_mutex_t* q_lock_ptr,q_cond_ptr) {
  pthread_mutex_destroy(q_lock_ptr);
  pthread_cond_destroy(q_cond_ptr);
 }
```

# Parallelism

## Programming Challenges

- Identifying tasks in a program which can be divided into separate concurrent tasks
- Balancing the computing resources by choosing tasks which perform equal work of equal value
- Split data to run on separate cores
- Examine data dependencies an sync access
- Multicore execution increases number of possible execution paths, making testing and debugging harder

## ARM , Linux support

SKIPPED

## Data vs Task

- Data parallelism focus on distributing parts of the same data across multiple cores and performing *the same* operation on each core
- Task parallelism means distributing tasks/threads across multiple computing cores

## pthreads

- API for creating and managing threads

- `pthread_t`
  - opaque (ID int)
  - implements (main)
    - `phtread_create()` : creates the thread
      - in : pointer to subroutine to be called in the thread ; pointer to its arguments ; attributes
    - `phtread_join()` : waits for thread passed as argument to terminate
      - in : thread pointer
    - `phtread_exit()` : terminates thread when called inside it and optionally passes a value pointer to `join`

- often default thread attributes are ok and don't need to be specified

![](@attachment/Clipboard_2021-07-28-23-58-52.png)

## OpenMP

- de-facto standard for shared-memory parallel programming

- SKIPPED

## MPI



## OpenCL

## MapReduce


# References

[^1]: https://stackoverflow.com/users/877703/chharvey
[^2]: Operating Systems Concepts , 9th Edition, Silberschatz
[^3]: https://www.ibm.com/docs/en/i/7.2?topic=techniques-synchronization-among-threads