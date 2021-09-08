# Week 4 - Process Management


## Process Abstraction

Process management is essentially the reason why OS exist, and modern OS are characterised by their ability to run multiple processes seemingly simultaneously. Processes are therefore one of the most important abstractions that OS provide, since they turn a single CPU into multiple virtual CPUs.

It is important to understand the distinction between processes and programs. Programs are static objects consisting of written instructions whilst processes are instances of executing programs, i.e. they also encapsulate the runtime execution context (program counter, stack pointer, register values). Processes also record memory management information and keep track of owned resources such as open file handles and network connections.

Linux being a multiprogramming system, its main active entities are processes, and multiple independent processes may be running at the same time

> REM on `*nix` you can run `ps` to list running processes

## Process Creation

Child processes are spawned from their parents via the `fork` system call. When a process is forked an exact copy of the parent process is created with the only difference being the return value of `fork`. The parent's return value is set to the child's PID and the child's is set to 0 \mymarginpar{if forking is not allowed, 1 is returned instead}

> REM in linux `fork` is implemented via the `clone` system call

In general relevant information related to a process is stored in a data structure know as the *process control block*. The Linux kernel internally represents processes as tasks via the structure `task_struct`. It is here that execution context (process metadata) are stored. So, for each process, a process descriptor of type `task_struct` is resident in memory *at all times*. \mymarginpar{See [^1] @742 for examples of information contained within these descriptors} This is crucial since allows the OS to stop and resume execution of a process.

There are two other important structures:
- `thread_info` is responsible for storing mostly low-level processor context, such as register values and status flags and which points to `task_strcut`.
- `thread_struct` is a small block of memory referenced by `task_struct` which stores more processor-specific context relating to fault events and debugging information

![](@attachment/Clipboard_2021-02-16-16-56-29.png)

### Going Rogue 

There wouldn't be much use if processes could only copy themselves without the copies being able to be modified. In Linux we can execute a different program in a child process using the `exec` family of system calls, which causes its entire core image to be replaced by the file named in its first parameter. 

`execve` takes 3 parameters:
- the name of the file to be executed
- a pointer to the argument array
- a pointer to the environment array


### Implementation

When a fork system call is executed, the calling process *traps* to the kernel, i.e. a synchronous software interrupt occurs which causes the process to run in kernel mode. It then creates the data structures mentioned above and a few others such as the kernel-mode stack (the majority of the new processor's file descriptor values are filled out based on the parent's descriptor values). Once the structures are set up the OS updates the PID hash-table entry to point to the new `task_struct`

As we've mentioned above, the child process will now have it's own virtual address space, however the duplication of memory is done *lazily* using the **copy write** technique to avoid overhead. In short, the child's page tables point to the parents' with read-only privileges, and a new memory page with writing privileges is only created if either process tries to write to a page. In this way, only pages written to need to be duplicated, which saves time and RAM. \mymarginpar{See lecture 6 for more}

![](@attachment/Clipboard_2021-02-16-17-23-28.png)

\caption{user types a command, ls, on the terminal, the shell creates a new process
by forking off a clone of itself. The new shell then calls exec to overlay its memory
with the contents of the executable file ls. After that, ls can start.}

### Sharing Resources

Each process is an independent entity with its own program counter and internal state/private memory images. If the parent changes its internal state then those changes are not directly visible to the child and vice versa. Open files are shared however, since changes to files are visible to any processes which open them.

## Process Termination

Processes terminate usually due to:

1. Normal exit (voluntary)
1. Error exit (voluntary)
1. Fatal error (involuntary)
1. Killed by another process (involuntary)

If the parent process completes before the child process, then the child process becomes *orphan*. It can then be *re-parented* by one of the parent's ancestors know as the *subreaper*, but if one doesn't exist then it falls back to *init*. 


## Process States

During their lifetime processes move between various states :

|Linux Abbreviation|State|
|:-:|-|
|R|Running, or runnable|
|S|Sleeping, can be interrupted|
|D|Waiting on IO, not interruptible|
|T|Stopped, generally by a signal|
|Z|Zombie, a dead process|

![](@attachment/Clipboard_2021-02-01-11-38-37.png)

## Context Switch

The context switch operation enables the OS to run multiple programs *concurrently*. The OS serializes the process metadata, so that once a paused process can be picked up again and start where it left off. Processes are switched in and out as such high frequency that it appears that all are executing simultaneously. 

For short-term process scheduling, the process context data is stored in RAM, for other processes the process memory is paged out to disk.

## Inter-process communication

Processes in Linux can communicate with each other using *pipes*. This pipeline works by chaining together the processes' standard streams so that the output of one gets redirect to the input of the other. Synchronisation between processes is possible because when a process tries to read from an empty pipe it is blocked until data are available.

### Signals

Another way processes can communicate is via signals. A signal is essentially a software interrupt, i.e. it is an event generated by the kernel to invoke a signal handler in another process. Signals are a mechanism for *one-way, async* notifications with a minimal data payload.

When a signal arrives the process can decide to ignore it, catch it or to let the signal kill it. If the process decides to catch signals sent to it, it will require a handler, which is a callback routine installed by the process itself. \mymarginpar{with the exception of `SIGKILL` and `SIGSTOP` which cannot be handled by user processes} As with hardware interrupts, once a signal arrives control is immediately transferred to the handler, and once it finishes control returns to wherever it came from.


# What you will learn
After you have studied the material in this chapter, you will be able to:
1. Describe why processes are used in operating systems.
2. Justify the need for relevant metadata to be maintained for each process.
3. Sketch an outline data structure for the process abstraction.
4. Recognise the state of processes on a running Linux instance.
5. Develop simple programs that interact with processes in Linux.


[^1]: Andrew S. Tanenbaum and Herbert Bos. 2014. <i>Modern Operating Systems</i> (4th. ed.). Prentice Hall Press, USA.