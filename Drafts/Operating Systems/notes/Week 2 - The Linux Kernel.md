# Week 2 - The Linux Kernel




We'll look at the linux system from the perspective of admins and app programmers, rather than kernel or driver programmers. We'll start with an overview of [basic OS concepts](basic-os-conecpts) whose in-depth discussion will form the content of later lectures ; we'll then move to the [booting and initialization](booting-and-initialization) and finally we'll cover [linux kernel modules](linux-kernel-module)


## Basic OS Concepts

The linux kernel is only one component of the OS which sits between the hardware and the application layer. The kernel communicates with the user space applications via the *System Call Interface*

The kernel provides functionality such as:
  - scheduling
  - mem mang
  - networking
  - file system support
  - support for interaction wuth system hardware via device drivers


![](@attachment/Clipboard_2021-01-23-15-41-21.png)


System Tools
: DEFINE

System Libraries
: DEFINE

System Call Interface
: DEFINE

Driver
: DEFINE

Firmware
: DEFINE



### Processes

Process
: a running program, the code for the program and all system resources it uses

The concept of a process is useful in order to separate code from resources

The OS kernel is responsible for allocating resources to processes, which are exclusive to it

Task
: an ammount of work to be done by a program, usually related with scheduling

Threads
: multiple concurrent tasks executing within a single process

REM
: for process with a single thread , task and process are used interchangeably

When a process is created the kernel assigns it a *PID* and creates a corresponding data structure, the *Process Control Block*, which in Linux is represented by a `struct` named `task_struct`. It is via this mechanism that the kernel manages processes

PCB
: DEFINE

### User and Kernel Spaces

the distinction is useful to indicate process execution with different privileges

User Space
: memory accessible by a user process

Kernel Space
: memory accessible by the kernel, which is effectively the whole memory space

### Device Tree and ATAGs

a kernel binary, though compiled for a target architecture, should be able to run on a wide variety of platforms for this architecture. Which means that the kernel requires information about the harware at boot time.

ATAG
: a data structure in Arm systems kernels which is populated with info that the bootloader provides

Device Tree
: a tree data structure with nodes describing the physical devices in a system

Device Tree Blob
: a machine-architecture independent binary which contains the device tree source files compiled using a special compiler 

before Arm systems used ATAGs, nowadays *Device Trees* are used because it is a more flexible approach. Device Tree Source files describe the hardware by defining a format and syntax

### Files and Persistent Storage

File
: a named colleciton of related data that appears to the user as a single, contiguous block on info and that is retained in storage

Persistent Storage
: non-volatile memory, i.e memory which can retain data for long periods of time

PS *"disks"* store data in a linear fashion with sequential access. However, in practice, the disk does not contain a single array of bytes. Instead it is organized using logical *partitions* and *file systems* \mymarginpar{for in-depth see 9}

Partition
: a logical division of a block of memory


Partition Table
: structure containing the info regarding how a disk is partioned (e.g. location, size, type, etc.)

File System
: a logical subdivision of a partition


the purpose of most file systems is to provide the *file* and *directory* abstractions. Within a file system information about the permissions of files and directories, as well as timestamp information (metadata) are stored along side them

Mounting
: the act of associating a storage device to a particular location in the directory tree 


### *"Everything is a file"*

not quite, but linux sees everything as *objects* which are just things that can be acted upon. By followig this philosophy, Linux can interact with different types of objects using a *consisten interface*. It would be more accurate to say that in Linux *"everything is a file descriptor"*

File Descriptor
: a non-negative integer which is used to represent I/O resource (e.g. socket, file), so that the kernel can keep track

Hence, in practice even , for example, interfaces are treated as files in the file sytem (in `/dev`)

### Users

The concept of a user is firmly connected to the concept of a file system. Users' ability to *read, write and execute* files may vary depending on where in the FS hierarchy the file exists

REM
: the priviliged user is called *root* 

### Credentials

Credentials
: set of privileges and permissions associated with an object, which can be found in the object descriptor

Objects
: things in the system that may be acted upon directly by userspace programs (e.g. files, sockets, tasks, message queues)

When a *subject* acts upon an *object*, a security calculation is made. This involves taking the *subjective context*, the *objective context* and the *action*, and searching one or more *sets of rules* to see whether the subject is granted or denied permission to act in the desired manner on the object, given those contexts.

REM 
: subject is just the "actor" object 

REM 
: the contexts are just subsets of general credentials

REM
: the user id UID and group id GID are carried by almost all objects, and (mostly) define their objective context

Note that the actual kernel security policies can restrict access further?

### Privileges and User Admin

see textbook


## Booting and Initialisation



## Linux Kernel Modules

the Linux kernel is modular, and functionality can be loaded at run time using *Loadable Kernel Modules (LKM)*. The main advantage here is that we don't need to recompile the whole kernel to add some extra functionality

These modules can do lots of things, but they typically are one of three things: 

1) device drivers
2) filesystem drivers
3) system calls

## Basic Module

```C
#include <linux/module.h>      /* Needed by all modules */
#include <linux/kernel.h>      /* Needed for KERN_ALERT */
#include <linux/init.h>        /* Needed for the macros */

static int hello3_data __initdata = 3;


static int __init hello_3_init(void)
{
   printk(KERN_ALERT "Hello, world %d\n", hello3_data);
   return 0;
}


static void __exit hello_3_exit(void)
{
   printk(KERN_ALERT "Goodbye, world 3\n");
}


module_init(hello_3_init);
module_exit(hello_3_exit);
```

The macros `module_init` and `module_exit` are used to identify which subroutines should be run when the module is loaded and unloaded

The general mechanism used in the kernel to connect a specific module to a generic API (e.g file system API) is via a struct with function pointers, which functions as an object interface declaration in Java. Hence, when implementing the module one looks at the API of the part of the kernel we need to interact with and create a `struct` in our module which maps whatever calls we need from the API to our own implementation

```C
// file_operations -> built in file system API
// my_file_ops -> our implementation

static struct file_operations my_file_ops =
{
 .open = my_file_open,
 .read = my_file_read,
 .write = dmy_file_write,
 .release = dmy_file_close,
};
```

Lastly, to make the kernel use this struct we use another API call in the initialization subroutine.

## LKM Utilities

The programs you need to load and unload and work with LKMs are in the package `modutils` . 

In order to *load* the module you can use:

modprobe
: intelligently adds or removes a module from the Linux kernel by looking at the module dependencies and loading them first

insmod
:  inserts the module into the kernel.

rmmod
: Remove an LKM from the kernel.

depmod
: Determine interdependencies between LKMs.

kerneld
: Kerneld daemon program

ksyms
: Display symbols that are exported by the kernel for use by new LKMs.

lsmod
: List currently loaded LKMs.

modinfo
: Display contents of .modinfo section in an LKM object file.




# REF

https://unix.stackexchange.com/questions/3192/what-is-meant-by-mounting-a-device-in-linux

https://www.kernel.org/doc/html/v4.14/security/credentials.html

https://tldp.org/HOWTO/Module-HOWTO/x73.html

https://www.linux.org/docs/man5