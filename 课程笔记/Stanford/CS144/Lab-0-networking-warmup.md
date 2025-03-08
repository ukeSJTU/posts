Welcome to CS144: Introduction to Computer Networking. In this warmup, you will set up an installation of GNU/Linux on your computer, learn how to perform some tasks over the Internet by hand, write a small program in C++ that fetches a Web page over the Internet, and implement (in memory) one of the key abstractions of networking: a reliable stream of bytes between a writer and a reader. We expect this warmup to take you between 2 and 6 hours to complete (future labs will take more of your time). Three quick points about the lab assignment:

- It’s a good idea to read the whole document before diving in!
- Over the course of this 8-part lab assignment, you’ll be building up your own implementation of a significant portion of the Internet—a router, a network interface, and the TCP protocol (which transforms unreliable datagrams into a reliable byte stream). Most weeks will build on work you have done previously, i.e., you are building up your own implementation gradually over the course of the quarter, and you’ll continue to use your work in future weeks. This makes it hard to “skip” a checkpoint.
- If you don’t meet the CS144 prerequisites, please don’t take this class yet—our teaching staff’s resources are limited. And please use checkpoints 0 and 1 as a gauge: if you find yourself uncomfortable with the programming in the first two checkpoints, please consider taking CS144 in a later year after you’ve attained more comfort with this kind of programming (perhaps after taking CS 106L, embarking on a self-directed programming project, or otherwise building up your comfort and experience level).
- The lab documents aren’t “specifications”—meaning they’re not intended to be consumed in a one-way fashion. They’re written closer to the level of detail that a software engineer will get from a boss or client. We expect that you’ll benefit from attending the lab sessions and asking clarifying questions if you find something to be ambiguous and you think the answer matters. We’ll update the “lab FAQ” document on the course website in response to late questions that need clarification.

# Collaboration Policy

**The programming assignments must be your own work:** You must write all the code you hand in for the programming assignments, except for the code that we give you as part of the assignment. Please do not copy-and-paste code from Stack Overflow, GitHub, or other sources. If you base your own code on examples you find on the Web or elsewhere, cite the URL in a comment in your submitted source code.

**Working with others:** You may not show your code to anyone else, look at anyone else’s code, or look at solutions from previous years. You may discuss the assignments with other students, but do not copy anybody’s code. If you discuss an assignment with another student, please name them in a comment in your submitted source code. Please refer to the course administrative handout for more details, and ask on EdStem if anything is unclear. Services like GitHub Copilot or ChatGPT should be considered to be equivalent to “a student that took CS144 in a prior year.”

**EdStem**: Please feel free to ask question on EdStem, but please don't post any source code.

# Set up GNU/Linux on your computer

CS144’s assignments require the GNU/Linux operating system and a recent C++ compiler that supports the C++ 2023 standard. Please choose one of these three options:

1. **Recommended:** Install the CS144 VirtualBox virtual-machine image  
   (instructions at [CS144 VM Howto](https://stanford.edu/class/cs144/vm-howto/vm-howto-image.html)).

2. **Use a Google Cloud virtual machine** using our class’s coupon code  
   (instructions at [CS144 VM Howto](https://stanford.edu/class/cs144/vm-howto)).

3. **Run Ubuntu version 24.04**, then install the required packages:

   ```sh
   sudo apt update && sudo apt install git cmake gdb build-essential clang \
   clang-tidy clang-format gcc-doc pkg-config glibc-doc tcpdump tshark
   ```

```

1. **Use another GNU/Linux distribution “at your own risk”**, but be aware that you may hit roadblocks along the way and will need to be comfortable debugging them.

Your code will be tested on **Ubuntu 24.04 LTS** with **g++ 13.3** and must compile and run properly under those conditions.

1. **Mac users (2020–24 MacBook with ARM64 M-series chips):**

VirtualBox will not successfully run. Instead, please install the **UTM virtual machine software** and use our **ARM64 virtual machine image**

([CS144 VM Howto](https://stanford.edu/class/cs144/vm-howto/)).

```
