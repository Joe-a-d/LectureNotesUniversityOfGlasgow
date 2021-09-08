# Week 5 - Process Scheduling


# TODO

- concept of global vs local algo
- advantages of each algorithm, and when are they suitable to use (see 2015 papers Q02 b)
- walkthrough an example of each algorithm

# Process Lifecycle

The main goal of scheduling is to allow for concurrency, this is particular important when dealing with I/O since the processor has to wait for the peripheral which can take a long time (e.g. a hard disk takes millions of clock cycles to respond).

Recall form the previous section that the PCB is represented by `task_scruct`, and when it comes to a process lifecycle the attribute of interest is `state`. This attribute is responsible for representing process states by setting its value to a unique bit. Scheduling is responsible for moving tasks between these states, in particular, from the run queue to the CPU and from the CPU to the run or waiting queue


![](@attachment/Clipboard_2021-02-22-10-35-06.png)


When a task is running on the CPU the OS in not running until an interrupt occurs, which can be raised by the timer that controls the time slice allocated to the running process or by peripherals. 

> REM most processes spend most of their time in the waiting state, because they often perform I/O operations

> REM in Linux you can get process time statistics by using the `time` command

Burst Time
: the time a process spends in the running state

## System Calls

System calls are essentially part of an API provided by the OS which allows communication between the hardware and applications. In Linux, system calls are implement via the `syscal()` library function.

`syscall()` is a small library function that invokes the system call whose assembly language interface has the specified number with the specified arguments. This is not commonly used for system calls in the C library, but it is particularly useful when invoking a system call which has no wrapper function in the library.

> REM in general a 0 return value indicates a succesfull cal, and -1 an error

Every system call involves a context switch with the accompanying overheads (approx 10K instructions could be executed while performing context switch), so to overcome this Linux uses the *vDSO Dynamic Shared Object* mechanism. Some system calls that are frequently used do not actually require kernel privileges, so these calls are implemented in a special dynamically shared library which is automatically provided by the kernel to any process created

> REM in Arm only two system calls are implemented this way

# Scheduling Algorithms

A first design choice whem implementing scheduling algorithms is to decide whether the scheduler will be able to interrupt running tasks - *pre-emptive* scheudling - or not - *non-preemptive*. 

> REM a process being oved to the waiting state is not considered a scheduling activity, from a scheduling perspective the remainder of the task is just seen as a new task

We can think of a scheduling algorithm as being responsible for deciding in which position of a list of tasks ready to run to position a task and to decide how long a task can run

## Criteria

The best algorithm for a particular process may not be the best for another set of processes. It is important that one is aware of this fact when choosing an algorithm. The following criteria are the ones most commonly used to compare algos:

- CPU utilization : maximize , in practice somewhere between 40%-90%

- Throughput : maximize , for any given time unit, one aims to complete
as many processes as possible

- Waiting Time : minimize , waiting time is wasted time

- Turnaround Time : minimize , the aim is faster total completion times

- Response Time : minimize , in an interactive system this criteria can
be better than turnaround time, we measure when the first response is
issued

- Load average : minimize, the average number of processes in the ready queue

Below are specs of several different algorithms, and the following task configuration will be used to create the Gantt charts (r1 = current time , r2 = arrived process , r3 = running process)

$$\begin{array}{|c|c|c|c|} \hline \text { Pid } & \text { Burst time } & \text { Arrival time } & \text { Priority } \\ \hline 1 & 12 & 0 & 0 \\ \hline 2 & 6 & 2 & 1 \\ \hline 3 & 2 & 4 & 1 \\ \hline 4 & 4 & 8 & 2 \\ \hline 5 & 8 & 16 & 0 \\ \hline 6 & 8 & 20 & 1 \\ \hline 7 & 2 & 20 & 0 \\ \hline 8 & 10 & 24 & 0 \\ \hline \end{array}$$

## FCFS

The simplest algorithm which simply executes the processes according to the order of their arrival. If a process is interrupted then it is moved to the back of the queue. Can lead to long waiting times


### Non-preemptive


$$
\begin{array}{|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|}\hline 0 & 2 & 4 & 6 & 8 & 10 & 12 & 14 & 16 & 18 & 20 & 22 & 24 & 26 & 28 & 30 & 32 & 34 & 36 & 38 & 40 \\ \hline 1 & 2 & 3 & & 4 & & & & 5 & & 6,7 & & 8 & & & & & & & & \\ \hline  1 & 1 & 1 & 1 & 1 & 1 & 2 & 2 & 2 & 3 & 4 & 4 & 5 & 5 & 5 & 5 & 6 & 6 & 6 & 6 & 7 \\ \hline\end{array}
$$


### Preemptive

![](@attachment/Clipboard_2021-07-27-21-44-46.png)

$$\begin{array}{|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|}\hline 0 & 2 & 4 & 6 & 8 & 10 & 12 & 14 & 16 & 18 & 20 & 22 & 24 & 26 & 28 & 30 & 32 & 34 & 36 & 38 & 40 \\ \hline 1 & 2 & 3 & & 4 & & & & 5 & & 6,7 & & 8 & & & & & & & & \\ \hline 1 & 1 & 2 & 3 & 4 & 4 & 1 & 1 & 5 & 5 & 6 & 6 & 8 & 8 & 8 & 8 & 8 & 1 & 1 & 2 & 2 \\ \hline\end{array}$$


## RR

Processes are executed according to time of arrival but only for a certain time period - *quantum*. If the process finished early then the dispatcher moves down the queue, if the opposite happens the process is added to the back of the queue.

> REM on the Raspberry Pi 3 , `q = 10ms`

For `q = 4` , 

$$\begin{array}{|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|}\hline 0 & 2 & 4 & 6 & 8 & 10 & 12 & 14 & 16 & 18 & 20 & 22 & 24 & 26 & 28 & 30 & 32 & 34 & 36 & 38 & 40 \\ \hline 1 & 2 & 3 & & 4 & & & & 5 & & 6,7 & & 8 & & & & & & & & \\ \hline 1 & 1 & 2 & 2 & 3 & 4 & 4 & 1 & 5 & 5 & 6 & 6 & 7 & 8 & 8 & 1 & 1 & 2 & 5 & 5 & 6 \\ \hline\end{array}$$

## Priority-driven

The algos below are priority-driven, i.e. the order in the run queue is determined by the priority of the process

- do not precopmpute a schedule of jobs
- priorities are assigned when jobs are released and place them on a ready job queue in priority order
- if preemption is allowed the scheduling decision is made when a job is released or completed
- at each scheduling decision time the scheduler updates the ready job queue and then schedules and executes the job at the head

Fixed-priority
: algorithm which assigns the same priority to all jobs in the task

Dynamic-priority
: algorithm which assigns different priorities to the individual jobs in a task

## SJF

Uses time-related information as the priority, in particular SJF chooses the processes with the lowest CPU burst time to be executed first, if the processes have the same CPU burst time then it falls back to FIFO. This is also simple to implement, but an obvious problem is that processes with large CPU burst times may take much more to implement

$$\begin{array}{|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|}\hline 0 & 2 & 4 & 6 & 8 & 10 & 12 & 14 & 16 & 18 & 20 & 22 & 24 & 26 & 28 & 30 & 32 & 34 & 36 & 38 & 40 \\ \hline 1 & 2 & 3 & & 4 & & & & 5 & & 6,7 & & 8 & & & & & & & & \\ \hline 1 & 1 & 1 & 1 & 1 & 1 & 3 & 4 & 4 & 2 & 2 & 2 & 7 & 5 & 5 & 5 & 5 & 6 & 6 & 6 & 6 \\ \hline\end{array}$$

> REM it is not very practical as in general the scheduler can’t know how long a task will take to complete

## SRTF

Uses time-related information as the priority, in particular SRTF looks at the list of processes in the ready queue with each new arrival and compares the total remaining completion times, if the total time of a waiting process is lower than the one currently in execution then it will interrupt execution and swap them.

$$\begin{array}{|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|r|}\hline 0 & 2 & 4 & 6 & 8 & 10 & 12 & 14 & 16 & 18 & 20 & 22 & 24 & 26 & 28 & 30 & 32 & 34 & 36 & 38 & 40 \\ \hline 1 & 2 & 3 & & 4 & & & & 5 & & 6,7 & & 8 & & & & & & & & \\ \hline 1 & 2 & 3 & 2 & 2 & 4 & 4 & 1 & 5 & 5 & 5 & 5 & 7 & 6 & 6 & 6 & 6 & 1 & 1 & 1 & 1 \\ \hline\end{array}$$

> REM preemptive SJF

> REM both SJF and SRTF can lead to *starvation*, where some tasks are never run because their remaining time is always longer than that of any other task


## SEFT

Uses time-related information as the priority, but unlike the previous 2 algos it relies on *elapsed* run time which is more easily measurable by the OS, and therefore more practical to implement

[^1] showed that SETF obtains good average-case response time and does not starve any job

## Priority Scheduling

The priority of the task is an entirely separate attribute not related to other task attributes. The main advanatge is that the priority can be changed if needed, which is essential to prevent starvation. To counter the risk of lower priority processes never executing , prioritites *age* , i.e. increase with waiting time.

## Real-time Scheduling

Real-time applications
: process data without delays

Soft RT
: gives no guarantee as to when a critical real-time process will be scheduled but only guarantee that the critical process will have a higher priority (e.g. video, audio streaming)

Hard RT
: a task *must* be services by its deadline. (e.g. safety-critical systems)

RT apps require tasks to have well defined time constraints, and processing must be done within those constraints to be considered correct

The Linux kernel supports both types of real-time scheduling. For soft real-time scheduling, it uses
Round-Robin or FIFO, for HRT uses Earliset Deadline First

## EDF

A dynamic priority-driven scheduling algorithm for periodic tasks (jobs). The job queue is ordered by the earliest deadline of the jobs

# TODO


# Scheduling in the Linux kernel



# What you will learn
After you have studied the material in this chapter, you will be able to:
1. Explain the rationale for scheduling and relationship to the process lifecycle.
2. Discuss the pros and cons of different policies for scheduling in terms of the principles and criteria.
3. Calculate scheduling criteria and reason about scheduling policy performance with respect to the criteria.
4. Analyze the implementation of scheduling in the Linux kernel.
5. Control scheduling of threads and processes as a programmer or system administrator.


[^1]: B. Kalyanasundaram and K. Pruhs, “Speed is as powerful as clairvoyance,” J. ACM, vol. 47, no. 4, pp. 617–643, Jul. 2000. [Online].
Available: http://doi.acm.org/10.1145/347476.347479