# What is Concurrent Programming | Codecademy

https://www.codecademy.com/enrolled/courses/learn-advanced-python-3-concurrency

# What is Concurrent Programming

Learn about concurrent programming!

#### Introduction

In this article, we are going to talk about the following topics:

- Sequential Programming
- Concurrency and Parallelism
- Asynchronous Programming
- threading, multiprocessing, and asyncio modules

#### Sequential Programming

As you have gone along your Python journey, you have most likely worked with _sequential programs_. These are programs that follow a set order of instructions. We can view this on the following diagram:

![sequential programming diagram](https://static-assets.codecademy.com/Courses/advanced-python/sequential.svg)

For example, if we have the following program:

```
for i in range(4):  print(i)print("end program")
```

we will see the numbers 0-3 printed in order as the program follows the sequence of events:

```
print(0)print(1)print(2)print(3)print("end program")
```

Great! We have a deterministic algorithm that suits our needs. However, in this program, we have four steps that do not take a long time. Let’s imagine we are a data scientist working on a complex learning model or a backend developer working with an extensive database. Suddenly, we are dealing with many more steps that take a lot more processing power.

In situations like this, the concepts of _concurrent programming_ and _parallel programming_ come into play. To give us a basic intuition behind each of these paradigms, let’s picture three separate scenarios of ordering food at a deli.

#### Analogies

We can view sequential programming as a line of customers with access to one register. In this scenario, each customer has to wait in a single-file line until they can make their order. This is fine if there are only a few customers. However, as the number of customers piles up, this can be incredibly inefficient for the deli.

We can view concurrent programming as multiple lines of customers with access to one register. In this model, we might have three separate lines. The cashier can pick one of the customers who is ready to order from the front of a line. This can speed up ordering for the deli as if a customer decides they are not quite ready to order yet, they can let one of the other people in the front of the line go ahead.

We can view parallel programming as multiple lines of customers with access to multiple registers. In this model, there are multiple registers that can divvy up the customers. This way, the deli is more likely to avoid long lines and run a more efficient operation.

Finally, we can also have asynchronous programs. If we add this paradigm to our analogy, we can view it as having a wait queue where each customer has a ticket. Once a customer’s food is ready, their ticket gets called. However, the tickets don’t necessarily get called in order; instead, any ticket can be called once the customer’s food is ready. Sequential (synchronous) would mean that customers would have to wait for each customer before them to get their food.

#### Defining Technical Terms

Now that we have some high-level understanding of these concepts, let’s get back to programming mode and develop technical definitions for these terms.

- Concurrency is the process in which we have multiple tasks running and completing during overlapping periods of time.
- Parallelism is the process in which we simultaneously have multiple tasks or separate parts of the same task running using multiple CPUs (core processing units). These definitions seem quite similar; however, we should identify some key difference between the two processes:

- Parallelism needs hardware with multiple processing units, whereas concurrency only utilizes one.
- Concurrency requires at least two tasks to exist whereas parallelism only requires one.
- Parallelism assigns each task for a core to execute, whereas concurrency executes all tasks by switching tasks simultaneously.
- Parallelism means we can do multiple things at once, while concurrency means we can juggle between tasks. ![This diagram compares having one line versus multiple lines.](https://static-assets.codecademy.com/Courses/advanced-python/concurrent-programming.svg) These diagrams should remind us of our deli line analogy from before. Think of each processing unit as a register and each task as a line. With one core, we can split up the tasks cleverly to speed up the runtime. With multiple cores, we can run those tasks at the same time.

#### Methods in Python

In Python, we are going to go over the following libraries:

- `threading`
- `multiprocessing`
- `asyncio`

Using these, we can create concurrent, parallel, and asynchronous programs that are much faster than synchronous ones.

We can map these libraries one-to-one as:

- `threading` –> concurrency
- `multiprocessing` –> parallelism
- `asyncio` –> asynchronous

In the next few lessons, we will learn about the concepts of threads and processes. Then we will see how to use these concepts to create powerful and efficient programs and see our conceptual understanding of concurrency, parallelism, and asynchronous programming come to life!

# Introduction to Processes | Processes and Threads | Codecademy

# Processes and Threads: Introduction to Processes

## Narrative and Instructions

Learn

Processes and Threads

### Introduction to Processes

1 min

When using a computer, multiple programs can often be found running at the same time. Perhaps one for playing music, another for creating documents, and one for browsing the web. All of these programs have certain functionalities, but on their own they do nothing. To actually make use of them, they must be executed.

While a computer program is a static collection of coded instructions stored on a disk, a _process_ is an abstraction representing the program when it is running. A process is created when a program is executed. These processes are not only central for the usability of a computer, but they are the building blocks of an operating system. Managing these processes is central to operating system development.

Processes can sometimes also be called “tasks” or “jobs”, although these definitions are ambiguous. The key defining factor is that processes generally operate independently and do not share data; for example, a music player program will launch a music player process that would be independent of the process managing an office suite.

Instructions

All of the processes running on your system can be found in the operating system’s process manager:

- Task Manager in Windows
- Activity Monitor in MacOS
- System Monitor or top in most Linux Distributions

Concept Review

Want to quickly review some of the concepts you’ve been learning? Take a look at this material's [cheatsheet](/learn/learn-advanced-python-3-concurrency/modules/concurrent-programming-course/cheatsheet)!

Community Support

Still have questions? Get help from the [Codecademy community](https://community.codecademy.com/c/start-here/).

## Image

![Screenshots of process managers from a variety of operating systems](https://static-assets.codecademy.com/Courses/Operating-Systems/OS-Task-Managers-Screenshot.svg)

## Embedded Content

# Lifecycle of a Process | Processes and Threads | Codecademy

# Processes and Threads: Lifecycle of a Process

## Narrative and Instructions

Learn

Processes and Threads

### Lifecycle of a Process

3 min

To best optimize the performance of processes as their priority changes or as they wait for access to a limited resource, processes are put into one of five states:

- `New`: The program has been started and waits to be added into memory in order to become a full process.
- `Ready`: Process fully initialized, loaded into memory, and waiting to be picked up by the processor.
- `Running`: Currently being executed by the processor.
- `Blocked`: The process requires a contested resource that it must wait for.
- `Finished`: The process has been completed.

The life cycle of a process is its journey between these five states, beginning with `New` and ending with `Finished`. As CPU cores traditionally only executed one task at a time, managing the state of processes allows the processor to interleave these tasks and allows multiple processes to best share these cores and other limited computer resources. For example, instead of a process occupying the processor while waiting for user input, it can be marked as blocked to have the processor focus on another process in the ready state until that input arrives.

Blocking isn’t inherently negative as some tasks require more time. Marking these processes as blocked allows the processor to prioritize other tasks, creating a more responsive and efficient system. Similarly, some processes may also be reverted to the `Ready` state through preemption, where tasks are temporarily interrupted by an external scheduler for urgent reasons, such as a hardware interrupt signal asking the system to shutdown.

All of these switching processes do come with overhead that is best to be avoided. This is called _context switching_ and is typically an expensive operation as the current state of the process needs to be stored and then be reloaded later to resume execution.

Instructions

How could the `Blocked` state be further broken down to be more descriptive?

Concept Review

Want to quickly review some of the concepts you’ve been learning? Take a look at this material's [cheatsheet](/learn/learn-advanced-python-3-concurrency/modules/concurrent-programming-course/cheatsheet)!

Community Support

Still have questions? Get help from the [Codecademy community](https://community.codecademy.com/c/start-here/).

## Image

![A graph showing how a process moves between its five possible states](https://static-assets.codecademy.com/Courses/Operating-Systems/Process-Lifecycle-Diagram.svg)

# Process Layout and Process Control Block | Processes and Threads | Codecademy

# Processes and Threads: Process Layout and Process Control Block

## Narrative and Instructions

Learn

Processes and Threads

### Process Layout and Process Control Block

3 min

When a process is initialized, its layout within memory has four distinct sections:

- A text section for the compiled code
- A data section for initialized variables
- A stack for local

  Preview: Docs Loading link description

  [variables](https://www.codecademy.com/resources/docs/python/variables)

  defined within functions

- A heap for dynamic memory allocation

Processes are also initialized with a _Process Control Block_ that is required by the operating system for managing the process. This contains:

- A unique process ID and the ID of any parent processes that launched the current one
- The current process state
- How long the process has been running and any time limits the process may have
- Allowed system resources and other permissions
- The priority of the process
- The program counter for the address of the instruction currently being executed
- The address of other registers within the CPU holding intermediate values
- Information required for memory management such as page and segment tables

Additionally, when one process launches another, the original enters a parent-child relationship with the newly-launched process that shares much of the above data. For example, when an existing music player process starts a new process for scanning the user’s music library, both of these processes generally share the same system resources and permissions. Parent processes usually also wait for their children to complete before terminating themselves, unless the child was created specifically to run independently in the background.

Instructions

What other information may be useful to store on the Process Control Block?

Concept Review

Want to quickly review some of the concepts you’ve been learning? Take a look at this material's [cheatsheet](/learn/learn-advanced-python-3-concurrency/modules/concurrent-programming-course/cheatsheet)!

Community Support

Still have questions? Get help from the [Codecademy community](https://community.codecademy.com/c/start-here/).

## Image

![An image of process layout within memory adjacent to a table of the data contained in a process control block](https://static-assets.codecademy.com/Courses/Operating-Systems/Process-Layout-and-Control-Block-Diagram.svg)

# Introduction to Threads | Processes and Threads | Codecademy

# Processes and Threads: Introduction to Threads

## Narrative and Instructions

Learn

Processes and Threads

### Introduction to Threads

2 min

While a process is an abstract data structure that represents all of the necessary information to run a program, a _thread_ represents the actual sequence of processor instructions that are actively being executed.

Each process contains at least one thread to be able to execute, although more can be created to allow for concurrent processing if it is supported by the CPU. These threads live within the process and share all of the common resources available to it, such as memory pages and active

Preview: Docs Loading link description

[files](https://www.codecademy.com/resources/docs/python/files)

, as shown in the image to the right.

These shared resources are critical for the definition of a thread. While each process is typically independent, multiple threads usually work together within the context of a process. By sharing data directly, there is faster communication and context switching between threads than what is possible for processes, all while taking fewer system resources.

For example, within a video game process, multiple threads may exist to manage separate services relating to the operation of the game, such as one thread for collecting user inputs and another for producing sounds. As these threads live within the same process, they can easily share information about the game, such as the type of ground the player is walking on. This can be used to affect both the speed the character moves from the input thread as well as the noises created by the sound thread.

Instructions

Why might a browser application prefer to create each tab as a separate process instead of a thread?

Ans: A browser might prefer to create each tab as a separate process to enhance stability and security. If one tab crashes, it won't affect the others, as each process is isolated. This isolation also improves security by preventing one tab from accessing the memory of another. Additionally, separate processes can take advantage of multi-core processors, potentially improving performance.

Concept Review

Want to quickly review some of the concepts you’ve been learning? Take a look at this material's [cheatsheet](/learn/learn-advanced-python-3-concurrency/modules/concurrent-programming-course/cheatsheet)!

Community Support

Still have questions? Get help from the [Codecademy community](https://community.codecademy.com/c/start-here/).

## Image

![A thread existing within a process with local and shared memory](https://static-assets.codecademy.com/Courses/Operating-Systems/Single-Thread-Data.svg)

# Multithreading | Processes and Threads | Codecademy

# Processes and Threads: Multithreading

## Narrative and Instructions

Learn

Processes and Threads

### Multithreading

2 min

Typically, a single CPU core can only execute one thread, and therefore one process, at a time. With a clever use of blocking and context switching, this limitation can be obscured to users through nanosecond-long pauses that allow processes to be completed near-simultaneously. With some hardware advances, single CPU cores can now execute multiple threads at once, which is a capability called _multithreading_.

Parallelizing computations have a variety of benefits, such as improved system utilization and system responsiveness. This is because tasks can be more evenly split between multiple threads, exhausting all available computing resources and allowing longer tasks to run in the background, separate from user input. The image to the right shows how threads share data to achieve this.

However, these optimizations come with disadvantages due to the additional complexity required for the implementation. Not only are these programs more difficult to write because of their non-sequential nature, but they also create whole new

Preview: Docs Loading link description

[classes](https://www.codecademy.com/resources/docs/python/classes)

of bugs.

The two of the most common examples are data races, where multiple threads attempt to modify the same piece of data, and deadlocks, where multiple threads all attempt to wait for each other and freeze the system. Also, since these bugs are usually related to the tight timing of CPU interactions, the programs can be considered non-deterministic and therefore untestable, compounding the problem.

Community Support

Still have questions? Get help from the [Codecademy community](https://community.codecademy.com/c/start-here/).

## Image

![Multiple threads existing within a process with local and shared memory](https://static-assets.codecademy.com/Courses/Operating-Systems/Multithread-Data.svg)

# Kernel Threads vs User Threads | Processes and Threads | Codecademy

# Processes and Threads: Kernel Threads vs User Threads

## Narrative and Instructions

Learn

Processes and Threads

### Kernel Threads vs User Threads

2 min

Threads can behave differently depending on the environment they are created in.

A thread built into the existing process is considered a _kernel thread_. This means that the kernel within the operating system is fully aware of these threads and directly manages their execution.

There are also _user threads_ that exist solely in userspace and, while functionally identical, are not known or controlled by the kernel. This allows for more fine-grained control by developers. These threads are even more efficient than their kernel counterparts as they save on the costly indirection of making a system call to constantly interact with the kernel.

While these user threads typically operate independently of the kernel, they do need to be mapped to existing kernel threads in order to have the operating system execute them. There are three common models for mapping user threads to kernel threads, as shown in the image to the right:

- **1:1 Kernel-level threading** for a simple implementation that best allows for hardware acceleration provided by the kernel threads.
- **N:1 User-level threading** for ultra-light threads that can quickly communicate and context switch, but do not benefit from hardware acceleration due to sharing the same kernel thread.
- **M:N Hybrid threading** to get the best of both of the above solutions: very light and fast threads that can be hardware accelerated as necessary. However, this complex implementation can lead to bugs such as priority inversion where less important tasks are mistakenly prioritized and run first.

Instructions

Which mapping of user threads to kernels threads would be preferred if the computer hardware does not support multiple kernel threads?

Ans: If the computer hardware does not support multiple kernel threads, the preferred mapping would be N:1 User-level threading. This model allows multiple user threads to be managed within a single kernel thread, making it suitable for environments where hardware does not support multiple kernel threads.

Concept Review

Want to quickly review some of the concepts you’ve been learning? Take a look at this material's [cheatsheet](/learn/learn-advanced-python-3-concurrency/modules/concurrent-programming-course/cheatsheet)!

Community Support

Still have questions? Get help from the [Codecademy community](https://community.codecademy.com/c/start-here/).

## Image

![Diagrams for how user threads can be mapped to kernel threads](https://static-assets.codecademy.com/Courses/Operating-Systems/Kernel-Mapping.svg)

# Review and Wrap-up | Processes and Threads | Codecademy

# Processes and Threads: Review and Wrap-up

## Narrative and Instructions

Learn

Processes and Threads

### Review and Wrap-up

1 min

Congratulations! You have finished learning about some of the key foundations of an operating system: the processes and threads that all of the other code on the system rests upon.

A process is an abstraction within the operating system that represents the program while it is in execution. These processes exist in five states that are leveraged to allow the CPU cores to alternate between ready and blocked processes to best take advantage of limited computing resources.

A thread represents the actual sequence of processor instructions that are actively being executed. Each process contains at least one thread and can contain many such structures that all share resources among each other to allow for faster communication and context switching between them. This all allows them to be “lighter” and require fewer system resources. With the hardware advancement of multithreading, individual cores can also execute multiple threads at once, further improving system utilization and responsiveness by more efficiently splitting up tasks.

Threads behave differently depending on the environment they were created in. Kernel threads are constructed through system calls to the kernel while user threads are constructed using local function calls. User threads, therefore, allow for more fine-grained control by developers that can be more efficient than their kernel counterparts. However, these user threads have to be mapped to their kernel counterparts in order to be actually executed.

Instructions

All of the processes running on your system can be found in the operating system’s process manager:

- Task Manager in Windows
- Activity Monitor in MacOS
- System Monitor or top in most Linux Distributions

Concept Review

Want to quickly review some of the concepts you’ve been learning? Take a look at this material's [cheatsheet](/learn/learn-advanced-python-3-concurrency/modules/concurrent-programming-course/cheatsheet)!

Community Support

Still have questions? Get help from the [Codecademy community](https://community.codecademy.com/c/start-here/).

## Image

![Screenshots of process managers from a variety of operating systems](https://static-assets.codecademy.com/Courses/Operating-Systems/OS-Task-Managers-Screenshot.svg)
