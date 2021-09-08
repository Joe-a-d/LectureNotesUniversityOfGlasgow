# Week 6 - Memory Management

- Contrast the speed and size of data storage locations across the range of physical memory technologies
- Justify the use of Virtual addressing scheme
- Navigate Linux page table data structures to decode a virtual address
- Compare page replacement policies
- Arm hardware support for virtual memory design decisions
- key kernel routine operations for virtual memory abstraction management

## Physical Memory 

- complexity arises from trade-off between access speed and size

## Virtual Memory

> The basic idea behind virtual memory is that each program has its own address space, which is broken up into chunks called pages. Each page is a contiguous range of addresses. These pages are mapped onto physical memory, but not all pages have  to be in physical memory at the same time to run the program. When the program references a part of its address space that is in physical memory, the hardware performs the necessary mapping on the fly. When the program references a part of its address space that is not in physical memory, the operating system is alerted to go get the missing piece and re-execute the instruction that failed. [^2]

How OS assists processes in organising their allocated memory

- we can model memory as a large linear array data structure, such as a 1D array 
  - accessing data may follow a classic load/store approach

- In Linux *each process has its own virtual address space* with virtual/logical addresses mapping onto physical ones

**BENEFITS OF VIRTUAL MEMORY**
---
1. Process Isolation : It is impossible to trash another process' memory if the executing process is unable to access that memory directly
1. Code Relocation : Binary objects files are loaded at the same virtual address, making linking and loading easier. Ensures locality in VA space, minimising memory fragmentation
1. Hardware Abstraction : Uniform, hardware-independent view of memory
---

- **Memory Management Unit (MMU)** is integrated hardware support for virtual addressing.
  - steps in between processor and memory to translate virtual addresses (processor domain) to physical addresses (memory domain) , a process know as **hardware-assisted dynamid address relocation**

![](@attachment/Clipboard_2021-05-20-02-00-59.png)

- Initialisation steps
  - on OS bootup the processor starts in a physical addressing configuration 
  - on kernel boot init virtual mem mamangement data structures
  - turn on MMU


Paging
---

- Paging is the mechanism chosen to implement virtual addressing in Linux
  - supports fine-grained resource allocation and management of physical memory
  - physical memory is divided into *fixed-size* frames - **page frames**
  - virtual memory is divide into fixed-size pages, with size(pages) = size(frames)
  - 1-1 mapping between frames and pages
  - a page is the minimum granularity of memory that can be allocated to a user process

- Page sizes small vs large
  - in general, large pages are appropriate for data-intensive application systems (e.g. databases)
  - small : minimise fragmentation 
  - large : 
    - fewer virtual to physical address translation mappings need to be stored
    - internal fragmentation, i.e. there is free memory allocated to a process going to waste because a process cannot use large amounts contiguous space effectively

> REM : typical page = 4KB , 32-bit Arm


![](@attachment/Clipboard_2021-05-20-02-39-10.png)

> EXAMPLE : virtual address 20500 is 20 bytes from the start of virtual page 5 (virtual addresses 20480 to 24575) and maps onto physical address 12288 + 20 = 12308 . Note the use of the offset!!


---

Page Tables
---

Page Table
: in-memory data structure that translates from virtual to physical addresses

- processors and caches operate entirely in terms of virtual addresses
  - translation process relies on a mapping table - **page table** - stored in memory
  - dedicated MMU base registers point to page tables for rapid access. A cache of freq used address mappings lives in the look-aside buffer
- OS intervenes when a translation does not succeeded - **page fault**
  - process executes 
  - OS sets up the initial page table and maintains it as the VA space evolves
  - if the OS needs to operate on physical addresses directly (e.g. device drivers), macros convert between V-P



### Page Table Structure

- simplest is the *single-level* page table
  - for each page in the VAS there is an entry in the table for the corresponding physical address
  - wasteful

Each entry in the theoretical page table contains the following information: [^1]

  - Valid flag. This indicates if this page table entry is valid,
  - The physical page frame number that this entry is describing,
  - Access control information. This describes how the page may be used. Can it be written to? Does it contain executable code? 

- The virtual addresses are split into high-order bits representing the page number and lower-order bits representing the offset from the start of the page
  - the page number is used as an index into the page table (quick lookup via indexing)
  - other bits are used for the address within the page

**MMU translation:**
- the MMU will look first at the high-order bits to quickly hit the virtual page
- then looks at the "present/absent" bit to check that the page is in use, if a page fault happens it transfers control to the OS
- it will then use the offset to locate the specific address within it
- lastly it will replace the high-order bits (the virtual page number) by the page frame number (physical frame) forming the physical address
- it sends this address via the BUS

![](@attachment/Clipboard_2021-05-20-02-47-47.png)

![](@attachment/Clipboard_2021-07-27-19-46-02.png)
![](@attachment/Clipboard_2021-07-27-19-46-15.png)
![](@attachment/Clipboard_2021-07-27-19-46-23.png)

- *hierarchical page table* (e.g 32-bit, with 2 levels)
  - 10-bit *first-level* page table index : $2^{10} = 1024$ 32-bit addressable word entries , each containing a single address. Hence, each sub-table fits into a single apge
  - 10-bit  *second-level* page table index
  - 12-bit page offset

- by paging the page table we bring down the physical memory requirements for the physical page table. Each page table can fit into a single page. 
  - Processes tend not to use their entire virtual space, so if the OS see unused regions of the address space it can invalidate the corresponsing entries in the first-level page table, no 2nd level page tables are required for those addresses. 
  - Recall that each first-level page maps onto a second level page table block consisting of $2^{10} =1024$ entries. This means a potential saving of up to 4MB for each first-level page saved
    - Total memory = $2^{32} =$ 4GB
    - First level table = $2^{32} / 2^{10}$ = 1024 , 4MB entries
    - Second level table = $2^{22} / 2^{10}$ = 1024 , 4KB entries


[Hierarchical vs Sinlge Page](https://stackoverflow.com/questions/9834542/why-using-hierarchical-page-tables)
---

---
ARM SPECIFIC SECTIONS SKIPPED
---

### Translation Lookaside Buffer

- used for faster lookups
- bypasses the page table
- most programs tent to make a large number of references to a small number of pages (tend to represent the essential parts of the program, data being accessed, stack etc)
  - cache those pages (usually no more than 256)[^2] and essential metadata inside the MMU and look there first before looking at the page table

![](@attachment/Clipboard_2021-05-20-03-44-55.png)

Memory Constraints Handling
---
### Swapping

- when there are more pages allocated than there are physical frames available in memory the OS has to swap/page pages out of the RAM into the backing store
  - swap space is *persistent storage* , i.e. much slower than RAM
  - some OS indicate swapped status in page table entries' metadata
  - if a running process tries to access swapped out memory a page fault occurs

### Handling page faults

- page faults trigger processor exception, which handle control to OS

![](@attachment/Clipboard_2021-05-20-04-01-05.png)

## Page Replacement Algorithms

### Theoretical Optimal

- best but impossible to implement

- replaces the page who will need to be accessed the furthest in the future
  - problem is that it is impossible to compute how long it will be before a page is needed
  - this is *theoretically* possible because one can analyse the first run of a specific program with certain input data and use the page reference information from the first run for computing the required metrics


### Random

- selects a random victim page to be swapped out immediately

### Not Recently Used

- a page is NRU if its access metadata bit is unset
1. a page $p$ is randomly selected as a candidate
1. if $p$ access bit is set `goto 1`
1. else , select $p$

> There is no guarantee of termination with NRU, since all pages may have access bits set. We assume the OS will periodically unset all bits

### Clock

- a more efficient version of FIFO
  - *second chance* algorithm
- keeps a circular list of pages
- there's a sort of clock "hand" which points to the next candidate for page replacement
- when a page replacement is needed
  - inspect current candidate
    - if R bit is 1 -> set to 0
      - advance clock hand (hence the second change)
  - select the first page with an unset R bit

![](@attachment/Clipboard_2021-07-27-15-11-36.png)

### Least Recently Used

- based on the observation that pages that have been heavily used in the last few instructions will probably be heavily used again soon
  - when a page fault occurs, throw out the page that has been **unused** for the longest time
- (LINUX implementation)
  - allocated pages are added to the head of a active pages queue
  - page replacement needed
    - examine **tail** of queue
      - if bit set -> unset
      - else move to the inactive pages queue -> candidate for replacement


---
[^1]: https://tldp.org/LDP/tlk/tlk.html
[^2]: Tanenbaum, *Mordern OS*