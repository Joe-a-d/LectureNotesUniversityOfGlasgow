# Week 1 - Memory-Centric System Model




In this part of the course we'll cover some abstract *memory-centric* models for processor-based systems, so that you can better understand how fundamentally every action is reducible to operations on addresses.


> Every observable action in a processor-based system is the result of writing to or reading from an address location

## Modelling the system

System State
: a *fixed-size* array of unsigned integers. It represents *all of the memory* in the system (including I/O and other peripherals), not just the actual system memory. So, it is an array composed of the *sum* of the subarrays for each component 


`systemState = ramState + kbdState + nicState + ssdState + gpuState`

The above is an example of a possible *address space layout*

Address Map
: The description of the purpose, size and position of the address region for memory and peripherals



