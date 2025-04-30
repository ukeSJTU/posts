# Lab Checkpoint 1: stitching substrings into a byte stream

## 0 Overview

For Checkpoint 0, you used an _Internet stream socket_ to fetch information from a website and send an email message, using Linux's built-in implementation of the Transmission Control Protocol (TCP). This TCP implementation managed to produce a pair of _reliable in-order byte streams_ (one from you to the server, and one in the opposite direction), even though the underlying network only delivers "best-effort" datagrams. By this we mean: short packets of data that can be lost, reordered, altered, or duplicated. You also implemented the byte-stream abstraction yourself, in memory within one computer. Over the coming weeks, you'll implement TCP yourself, to provide the byte-stream abstraction between a pair of computers separated by an unreliable datagram network.

> _Why am I doing this?_ Providing a service or an abstraction on top of a different less-reliable service accounts for many of the interesting problems in networking. Over the last 40 years, researchers and practitioners have figured out how to convey all kinds of things—messaging and e-mail, hyperlinked documents, search engines, sound and video, virtual worlds, collaborative file sharing, digital currencies—over the Internet.TCP's own role, providing a pair of reliable byte streams using unreliable datagrams, is one of the classic examples of this. A reasonable view has it that TCP implementations count as the **most widely used** nontrivial computer programs on the planet.

The lab assignments will ask you to build up a TCP implementation in a modular way. Remember the `ByteStream` you just implemented in Checkpoint 0? In the coming labs, you'll end up convey two of them across the network: an "outbound" `ByteStream`, for data that a local application writes to a socket and that your TCP will send to the peer, and an "inbound" `ByteStream` for data coming from the peer that will be read by a local application.

This checkpoint contains a "hands-on" component and an implementation component. You might prefer to start the implementation component before the lab session, and do the hands-on component at the lab session. If you are a CGOE student, please use EdStem to coordinate a time with another student to do the hands-on component.

The hands-on component is new this year and involves multiple moving parts—so there might be some glitches. Please bear with us at the lab session and we'll do our best to get it working for everybody. If you see an error message from the https://cs144.net website, please report it in a public post on EdStem and we'll take a look.

## 1 Getting Started

Your implementation of TCP will use the same Minnow library that you used in Checkpoint0, with additional classes and tests. To get started:

1. Make sure you have committed all your solutions to Checkpoint 0. Please don't modify any files outside of the `src` directory, or `webget.cc`. You may have trouble merging the Checkpoint 1 starter code otherwise.
2. While inside the repository for the lab assignments, run `git fetch` to retrieve the most recent version of the lab assignments.
3. Download the starter code for Checkpoint 1 by running `git merge origin/check1-startercode`.
4. Make sure your build system is properly set up: `cmake -S . -B build`
5. Compile the source code: `cmake --build build`
6. Open and start editing the `writeups/check1.md` file. This is the template for your lab writeup and will be included in your submission.

## 2 Hands-on component: a private network for the class

We have created a private network for the CS144 class. This will allow your VM to send datagrams directly to and from the VMs of other students in the class. To make your VM join this network:

1. On your VM, install the "wireguard" package by running `sudo apt install wireguard`
2. Visit https://cs144.net/wg and follow the instructions to join the CS144 private network.
3. Once you have joined the network, verify that you can connect by following the "ping"instructions on that page (the instructions appear after you have joined the network).
4. Every time you reboot your VM, you'll have to rejoin the network (if you want to be able to send datagrams to and from other students in this class). You don't have to register a new public key each time, but you do have to rerun the commands on that webpage. The commands will be the same each time.

### 2.1 Ping a friend and look at the datagrams

1. On your own computer (e.g. your Mac or Windows machine—not your VM), install the"wireshark" program by following the instructions at https://www.wireshark.org/. (If you are using Debian or Ubuntu GNU/Linux, the command is `sudo apt install wireshark`.
2. Ask a groupmate for their IP address (the one shown on the https://cs144.net/wgwebpage **for them**). Using the `ping` command, send some "echo request" datagrams to your friend, and make sure that you get some "echo reply" datagrams back.
3. Tips:
   - You can end the "ping" program by typing `ctrl-C`.
   - You can make the "ping" command go faster by including the argument `-i 0.2`. This will make it send an "echo request" every 0.2 seconds (5 times per second).
   - You can make the "ping" command print out a summary of the statistics so far(without ending it) by running this command in another terminal: `killall -QUIT ping`.
4. Begin a report in your writeup, including the following information:
   - (a) What is the average round-trip delay between when your VM sends an "echo request" and when it receives an "echo reply" from your groupmate's VM?
   - (b) What was the delivery rate (what percentage of "echo requests" received a corresponding "echo reply")? What was the loss rate (this is 100% minus the delivery rate)? Send at least 1,000 pings to get a reliable estimate. (This will take about three minutes if using `ping -i 0.2`.
   - (c) Did you see any duplicated datagrams (ping will print "DUP")?
   - (d) While the ping is running, you and your groupmate can capture some of the raw Internet datagrams by running `sudo rm /tmp/capture.raw; sudo tcpdump -n -w /tmp/capture.raw -i wg0 --print --packet-buffered`. This command will capture the datagrams on the "wg0" interface (the private class network) to a file ("/tmp/capture.raw"), while also printing them out to the screen. Make sure you see some "echo request" and "echo reply" lines printed—that indicates your groupmate is receiving your datagrams and replying to you.
   - (e) Use the `wireshark` program to inspect the `/tmp/capture.raw` file on each of your VMs. You probably want to `scp` the capture.raw file to your own computer (e.g. a Mac or Windows machine) and then use `wireshark` to open this file, so you can use its graphical interface. Can you find the fields of the Internet datagram that were discussed in the Jan. 10 (and match the diagram at https://www.rfc-editor.org/rfc/rfc791.html#page-11)?
   - (f) Are there any differences between the **same** datagrams when they were captured on your VM compared with when they were captured on your friend's VM? What?

### 2.2 Send an Internet datagram by hand

In the `apps/ip_raw.cc` file, write a program that sends an Internet datagram to your friend by using a raw socket, using the same method as the January 10 lecture. It's okay to adapt code from this lecture.

1. Send your groupmate an Internet datagram with IP protocol "5" (you'll have to use"sudo" to run the "`./build/apps/ip_raw`" program), and have your friend use `tcpdump` to make sure they receive the datagram. They can run `sudo tcpdump -n -i wg0 'proto 5'` to print out only datagrams matching protocol "5". Make sure they get it!
2. Send your groupmate a user datagram (with IP protocol "17"), using the "user datagram" header format in https://www.rfc-editor.org/rfc/rfc768. Have your groupmate receive this datagram without using "sudo". They can use the "nc -u" program as was done in lecture, or a C++ program using the `UDPSocket` class—whatever they prefer!
3. Include the code for your "ip_raw.cc" in your submission to this checkpoint.
4. Do the same in reverse and receive a datagram from your groupmate.

## 3 Implementation: putting substrings in sequence

As part of the lab assignment, you are implementing a TCP receiver: the module that receives datagrams and turns them into a reliable byte stream to be read from the socket by the application—just as your `webget` program read the byte stream from the webserver in Checkpoint 0.

The TCP sender is dividing its byte stream up into short _segments_ (substrings no more than about 1,460 bytes apiece) so that they each fit inside a datagram. But the network might reorder these datagrams, or drop them, or deliver them more than once. The receiver must reassemble the segments into the contiguous stream of bytes that they started out as.

In this lab you'll write the data structure that will be responsible for this reassembly: a `Reassembler`. It will receive substrings, consisting of a string of bytes, and the index of the first byte of that string within the larger stream. **Each byte of the stream** has its own unique index, starting from zero and counting upwards. As soon as the Reassembler knows the **next** byte of the stream, it will write it to the Writer side of a `ByteStream`— the same `ByteStream` you implemented in checkpoint 0. The Reassembler's "customer" can read from the Reader side of the same ByteStream.

Here's what the interface looks like:

```cpp
// Insert a new substring to be reassembled into a ByteStream.
void insert( uint64_t first_index, std::string data, bool is_last_substring );

// How many bytes are stored in the Reassembler itself?
// This function is for testing only; don't add extra state to support it.
uint64_t count_bytes_pending() const;

// Access output stream reader
Reader& reader();
```

> Why am I doing this? TCP robustness against reordering and duplication comes from its ability to stitch arbitrary excerpts of the byte stream back into the original stream. Implementing this in a discrete testable module will make handling incoming segments easier.

The full (public) interface of the reassembler is described by the `Reassembler` class in the `reassembler.hh` header. Your task is to implement this class. You may add any private members and member functions you desire to the `Reassembler` class, but you cannot change its public interface.

### 3.1 What should the Reassembler store internally?

The `insert` method informs the `Reassembler` about a new excerpt of the `ByteStream`, and where it fits in the overall stream (the index of the beginning of the substring).

In principle, then, the `Reassembler` will have to handle three categories of knowledge:

1. Bytes that are the **next bytes** in the stream. The Reassembler should push these to the stream (`output_.writer()`) as soon as they are known.
2. Bytes that fit within the stream's available capacity but can't yet be written, because earlier bytes remain unknown. These should be stored internally in the `Reassembler`.
3. Bytes that lie beyond the stream's available capacity. These should be discarded. The `Reassembler`'s will not store any bytes that can't be pushed to the `ByteStream` either immediately, or as soon as earlier bytes become known.

The goal of this behavior is to **limit the amount of memory** used by the `Reassembler` and `ByteStream`, no matter how the incoming substrings arrive. We've illustrated this in the picture below. The "capacity" is an upper bound on _both_:

1. The number of bytes buffered in the reassembled `ByteStream` (shown in green), and
2. The number of bytes that can be used by "unassembled" substrings (shown in red)

![SCR-20250317-jxgb.png](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/03/SCR-20250317-jxgb.webp)

You may find this picture useful as you implement the `Reassembler` and work through the tests—it's not always natural what the "right" behavior is.

### 3.2 FAQs

- _What is the index of the first byte in the whole stream?_ Zero.
- _How efficient should my implementation be?_ The choice of data structure is again important here. Please don't take this as a challenge to build a grossly space- or time-inefficient data structure—the Reassembler will be the foundation of your TCP implementation. You have a lot of options to choose from.
  We have provided you with a benchmark; anything greater than 0.1 Gbit/s (100 megabits per second) is acceptable. A top-of-the-line Reassembler will achieve 10 Gbit/s.
- _How should inconsistent substrings be handled?_ You may assume that they don't exist. That is, you can assume that there is a unique underlying byte-stream, and all substrings are (accurate) slices of it.
- _What may I use?_ You may use any part of the standard library you find helpful. In particular, we expect you to use at least one data structure.
- _When should bytes be written to the stream?_ As soon as possible. The only situation in which a byte should not be in the stream is that when there is a byte before it that has not been "pushed" yet.
- _May substrings provided to the insert() function overlap?_ Yes.
- `Will I need to add private members to the Reassembler?` Yes. Substrings may arrive in any order, so your data structure will have to "remember" substrings until they're ready to be put into the stream—that is, until all indices before them have been written.
- _Is it okay for our re-assembly data structure to store overlapping substrings?_ No. It is possible to implement an "interface-correct" reassembler that stores overlapping substrings. But allowing the re-assembler to do this undermines the notion of "capacity"as a memory limit. If the caller provides redundant knowledge about the same index, the `Reassembler` should only store one copy of this information.
- _Will the Reassembler ever use the Reader side of the ByteStream?_ No—that's for the external customer. The Reassembler uses the Writer side only.
- _How many lines of code are you expecting?_ When we run `./scripts/lines-of-code` on the starter code, it prints:

  ```plaintext
  ByteStream:82 lines of code
  Reassembler:26 lines of code
  ```

  and when we run it on our solutions, it prints:

  ```plaintext
  ByteStream:111 lines of code
  Reassembler:85 lines of code
  ```

  So a reasonable implementation of the `Reassembler` might be about 50–60 lines of code for the `Reassembler` (on top of the starter code).

- More FAQs: For more, please see https://cs144.github.io/lab_faq.html.

## 4 Development and debugging advice

1. You can test your code (after compiling it) with `cmake --build build --target check1`.
2. Please re-read the section on "using Git" in the Lab 0 document, and remember to keep the code in the Git repository it was distributed in on the `main` branch. Make small commits, using good commit messages that identify what changed and why.
3. Please work to make your code readable to the CA who will be grading it for style and soundness. Use reasonable and clear naming conventions for variables. Use comments to explain complex or subtle pieces of code. Use "defensive programming"—explicitly check preconditions of functions or invariants, and throw an exception if anything is ever wrong. Use modularity in your design—identify common abstractions and behaviors and factor them out when possible. Blocks of repeated code and enormous functions will make it hard to follow your code.
4. Please also keep to the "Modern C++" style described in the Checkpoint 0 document. The cppreference website (https://en.cppreference.com) is a great resource, although you won't need any sophisticated features of C++ to do these labs. (You may sometimes need to use the `move()` function to pass an object that can't be copied.)
5. If you get your builds stuck and aren't sure how to fix them, you can erase your `build` directory (`rm -rf build`—please be careful not to make a typo as this will erase whatever you tell it), and then run `cmake -S . -B build` again.

## 5 Submit

1. In your submission, please only make changes to the `.hh` and `.cc` files in the `src` directory. Within these files, please feel free to add private members as necessary, but please don't change the _public_ interface of any of the classes.
2. Before handing in any assignment, please run these in order:
   - (a) Make sure you have committed all of your changes to the Git repository. You can run `git status` to make sure there are no outstanding changes. Remember: make small commits as you code.
   - (b) `cmake --build build --target format` (to normalize the coding style)
   - (c) `cmake --build build --target check1` (to make sure the automated tests pass)
   - (d) Optional: `cmake --build build --target tidy` (suggests improvements to follow good C++ programming practices)
3. Write a report in `writeups/check1.md`. This file should be a roughly 20-to-50-line document with no more than 80 characters per line to make it easier to read. The report should contain the following sections:
   - (a) **Structure and Design.** Describe the high-level structure and design choices embodied in your code. You don't need to discuss in detail what you inherited from the starter code. Use this as an opportunity to highlight important design aspects and provide greater detail on those areas for your grading TA to understand. What data structures did you choose in your header file? Are any of them not _strictly_ necessary? We'd like you to avoid redundant state if at all possible, unless you think and can justify that there's a serious performance penalty from doing so. You are strongly encouraged to make this writeup as readable as possible by using subheadings and outlines. Please do not simply translate your program into an paragraph of English.
   - (b) **Alternative design choices** that you considered or ideally evaluated in terms of their performance, difficulty to write (e.g., hours required to produce a bug-free implementation), difficulty to read (e.g., lines of code and their degree of subtlety or nonobvious correctness), and any other dimensions you think are interesting for the reader (or for your own past self before you did this assignment). Include any measurements if applicable.
   - (c) **Implementation Challenges.** Describe the parts of code that you found most troublesome and explain why. Reflect on how you overcame those challenges and what helped you finally understand the concept that was giving you trouble. How did you attempt to ensure that your code maintained your assumptions, invariants, and preconditions, and in what ways did you find this easy or difficult? How did you debug and test your code?
   - (d) **Remaining Bugs.** Point out and explain as best you can any bugs (or unhandled edge cases) that remain in the code.
4. In your writeup, please also fill in the number of hours the assignment took you and any other comments.
5. The mechanics of "how to turn it in" will be announced before the deadline.
6. Please let the course staff know ASAP of any problems at the lab session, or by posting on Ed. Good luck!

# 中文

## 0 概述

在检查点 0 中，您使用*互联网流套接字*从网站获取信息并发送电子邮件消息，使用的是 Linux 内置的传输控制协议（TCP）实现。这个 TCP 实现成功地产生了一对*可靠的有序字节流*（一个从您到服务器，另一个反方向），尽管底层网络只提供“尽力而为”的数据报。这意味着：可能丢失、重新排序、更改或重复的数据短包。在接下来的几周中，您将自己实现 TCP，以在不可靠的数据报网络上提供字节流抽象。

> _我为什么要这样做？_ 在一个不同的、可靠性较低的服务之上提供服务或抽象是网络中许多有趣问题的根源。在过去 40 年中，研究人员和从业者已经弄清楚如何通过互联网传递各种内容——消息和电子邮件、超链接文档、搜索引擎、声音和视频、虚拟世界、协作文件共享、数字货币。TCP 自己的角色，使用不可靠的数据报提供一对可靠的字节流，是其中的经典示例。一种合理的观点认为，TCP 实现是地球上**使用最广泛的**非平凡计算机程序。

实验作业将要求您以模块化方式构建 TCP 实现。还记得您在检查点 0 中实现的 `ByteStream` 吗？在接下来的实验中，您将通过网络传输其中的两个：一个“出站”`ByteStream`，用于本地应用程序写入套接字并由您的 TCP 发送给对等方的数据；一个“入站”`ByteStream`，用于来自对等方的数据，将由本地应用程序读取。

这个检查点包含一个“动手”部分和一个实现部分。您可能更喜欢在实验课程之前开始实现部分，并在实验课程中完成动手部分。如果您是 CGOE 学生，请使用 EdStem 与另一名学生协调时间完成动手部分。

动手部分是今年新增的，涉及多个活动部件——因此可能会有一些小问题。请在实验课程中耐心等待，我们将尽最大努力让每个人都能正常工作。如果您在 https://cs144.net 网站上看到错误消息，请在 EdStem 上公开帖子报告，我们会查看。

## 1 开始

您的 TCP 实现将使用与检查点 0 中相同的 Minnow 库，增加了额外的类和测试。开始步骤：

1. 确保您已提交了检查点 0 的所有解决方案。请勿修改 `src` 目录外的任何文件，或 `webget.cc`。否则，您可能会在合并检查点 1 起始代码时遇到麻烦。
2. 在实验作业的代码库内，运行 `git fetch` 以获取实验作业的最新版本。
3. 通过运行 `git merge origin/check1-startercode` 下载检查点 1 的起始代码。
4. 确保您的构建系统已正确设置：`cmake -S . -B build`
5. 编译源代码：`cmake --build build`
6. 打开并开始编辑 `writeups/check1.md` 文件。这是您的实验报告模板，将包含在您的提交中。

## 2 动手部分：班级私有网络

我们为 CS144 班级创建了一个私有网络。这将允许您的虚拟机直接与其他班级学生的虚拟机发送和接收数据报。要让您的虚拟机加入此网络：

1. 在您的虚拟机上，通过运行 `sudo apt install wireguard` 安装“wireguard”软件包。
2. 访问 https://cs144.net/wg 并按照说明加入 CS144 私有网络。
3. 加入网络后，按照该页面上的“ping”说明验证您可以连接（加入网络后会显示说明）。
4. 每次重启虚拟机时，如果您希望能够与其他班级学生发送和接收数据报，您需要重新加入网络。您不需要每次都注册新的公钥，但您需要重新运行该网页上的命令。每次命令都将是相同的。

### 2.1 Ping 朋友并查看数据报

1. 在您自己的计算机上（例如您的 Mac 或 Windows 机器——不是您的虚拟机），按照 https://www.wireshark.org/ 上的说明安装“wireshark”程序。（如果您使用的是 Debian 或 Ubuntu GNU/Linux，命令是 `sudo apt install wireshark`。）
2. 向组员询问他们的 IP 地址（在 https://cs144.net/wg 网页上**对他们**显示的地址）。使用 `ping` 命令向您的朋友发送一些“回显请求”数据报，并确保您收到一些“回显回复”数据报。
3. 提示：
   - 您可以通过输入 `ctrl-C` 结束“ping”程序。
   - 您可以通过包含参数 `-i 0.2` 使“ping”命令更快。这将使其每 0.2 秒发送一个“回显请求”（每秒 5 次）。
   - 您可以通过在另一个终端中运行此命令使“ping”命令打印出迄今为止的统计摘要（不结束它）：`killall -QUIT ping`。
4. 在您的报告中开始记录，包括以下信息：
   - (a) 您的虚拟机发送“回显请求”和收到组员虚拟机的“回显回复”之间的平均往返延迟是多少？
   - (b) 整体交付率是多少（收到多少“回显回复”除以发送了多少“回显请求”）？丢失率是多少（这是 100% 减去交付率）？发送至少 1,000 个 ping 以获得可靠的估计。（如果使用 `ping -i 0.2`，这将需要大约三分钟。）
   - (c) 您是否看到任何重复的数据报（ping 将打印“DUP”）？
   - (d) 在 ping 运行时，您和您的组员可以通过运行 `sudo rm /tmp/capture.raw; sudo tcpdump -n -w /tmp/capture.raw -i wg0 --print --packet-buffered` 捕获一些原始互联网数据报。此命令将在“wg0”接口（班级私有网络）上捕获数据报到文件（"/tmp/capture.raw"），同时也将它们打印到屏幕上。确保您看到一些“回显请求”和“回显回复”行打印出来——这表明您的组员正在接收您的数据报并回复您。
   - (e) 使用 `wireshark` 程序检查您每个虚拟机上的 `/tmp/capture.raw` 文件。您可能希望将 capture.raw 文件 `scp` 到您自己的计算机（例如 Mac 或 Windows 机器），然后使用 `wireshark` 打开此文件，以便使用其图形界面。您能找到 1 月 10 日讨论的互联网数据报字段吗（并与 https://www.rfc-editor.org/rfc/rfc791.html#page-11 上的图表匹配）？
   - (f) 在您的虚拟机上捕获的**相同**数据报与在您朋友的虚拟机上捕获时是否有任何差异？是什么？

### 2.2 手动发送互联网数据报

在 `apps/ip_raw.cc` 文件中，编写一个程序，使用原始套接字向您的朋友发送互联网数据报，使用与 1 月 10 日讲座相同的方法。可以从该讲座中改编代码。

1. 向您的组员发送一个 IP 协议为“5”的互联网数据报（您需要使用“sudo”运行 `./build/apps/ip_raw` 程序），并让您的朋友使用 `tcpdump` 确保他们收到数据报。他们可以运行 `sudo tcpdump -n -i wg0 'proto 5'` 仅打印匹配协议“5”的数据报。确保他们收到！
2. 使用 https://www.rfc-editor.org/rfc/rfc768 中的“用户数据报”头部格式，向您的组员发送一个用户数据报（IP 协议为“17”）。让您的组员在不使用“sudo”的情况下接收此数据报。他们可以使用讲座中使用的“nc -u”程序，或者使用 `UDPSocket` 类的 C++ 程序——他们喜欢什么就用什么！
3. 在您的提交中包含您的“ip_raw.cc”代码。
4. 反向操作，接收来自您组员的数据报。

## 3 实现：将子字符串按顺序拼接

作为实验作业的一部分，您正在实现一个 TCP 接收器：接收数据报并将其转换为可靠字节流的模块，应用程序将从套接字读取该字节流——就像您的 `webget` 程序在检查点 0 中从 web 服务器读取字节流一样。

TCP 发送者将其字节流分成短*段*（每个子字符串不超过约 1,460 字节），以便每个段都能装入一个数据报。但网络可能会重新排序这些数据报，或丢弃它们，或多次传递。接收者必须将这些段重新组装成它们最初的连续字节流。

在本实验中，您将编写负责此重新组装的数据结构：一个 `Reassembler`。它将接收子字符串，包括一串字节，以及该字符串在较大流中的第一个字节的索引。**流的每个字节**都有其唯一的索引，从零开始向上计数。一旦 Reassembler 知道流的**下一个**字节，它将立即将其写入 `ByteStream` 的写入端——这是您在检查点 0 中实现的同一个 `ByteStream`。Reassembler 的“客户”可以从同一个 ByteStream 的读取端读取。

以下是接口的样子：

```cpp
// 将一个新的子字符串插入到 ByteStream 中进行重新组装。
void insert( uint64_t first_index, std::string data, bool is_last_substring );

// Reassembler 本身存储了多少字节？
// 此函数仅用于测试；不要添加额外状态来支持它。
uint64_t count_bytes_pending() const;

// 访问输出流读取器
Reader& reader();
```

> 我为什么要这样做？TCP 对重新排序和重复的鲁棒性来自于其将字节流的任意摘录重新拼接成原始流的能力。在一个离散的可测试模块中实现这一点将使处理传入段变得更容易。

Reassembler 的完整（公共）接口由 `reassembler.hh` 头文件中的 `Reassembler` 类描述。您的任务是实现这个类。您可以根据需要在 `Reassembler` 类中添加任何私有成员和成员函数，但不能更改其公共接口。

### 3.1 Reassembler 内部应该存储什么？

`insert` 方法通知 `Reassembler` 关于 `ByteStream` 的一个新摘录，以及它在整个流中的位置（子字符串开始的索引）。

因此，原则上，`Reassembler` 将处理三种知识类别：

1. 流中的**下一个字节**。Reassembler 应尽快将这些字节推送到流中（`output_.writer()`）。
2. 适合流可用容量内的字节，但由于之前的字节仍未知而无法写入。这些应在 `Reassembler` 内部存储。
3. 超出流可用容量的字节。这些应被丢弃。`Reassembler` 不会存储任何无法立即或在之前的字节已知后推送到 `ByteStream` 的字节。

这种行为的目标是**限制 `Reassembler` 和 `ByteStream` 使用的内存量**，无论传入的子字符串如何到达。我们在下面的图片中说明了这一点。“容量”是对以下两者的上限：

1. 重新组装的 `ByteStream` 中缓冲的字节数（显示为绿色），以及
2. “未组装”子字符串可以使用的字节数（显示为红色）

![SCR-20250317-jxgb.png](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/03/SCR-20250317-jxgb.webp)

在实现 `Reassembler` 并通过测试时，您可能会发现这张图片很有用——“正确”的行为并不总是显而易见的。

### 3.2 常见问题解答

- _整个流中第一个字节的索引是什么？_ 零。
- _我的实现应该有多高效？_ 数据结构的选择在这里再次很重要。请不要将其视为构建一个极其空间或时间低效的数据结构的挑战——Reassembler 将是您 TCP 实现的基础。您有很多选择。
  我们为您提供了基准测试；任何大于 0.1 Gbit/s（100 兆位每秒）的速度都是可以接受的。顶级的 Reassembler 将达到 10 Gbit/s。
- _如何处理不一致的子字符串？_ 您可以假设它们不存在。也就是说，您可以假设存在一个唯一的底层字节流，所有子字符串都是它的（准确）切片。
- _我可以使用什么？_ 您可以使用标准库中您认为有帮助的任何部分。特别是，我们期望您至少使用一种数据结构。
- _何时应将字节写入流中？_ 尽快。只有在之前的字节尚未“推送”时，字节才不应在流中。
- _提供给 insert() 函数的子字符串可能会重叠吗？_ 是的。
- _我需要为 Reassembler 添加私有成员吗？_ 是的。子字符串可能以任何顺序到达，因此您的数据结构必须“记住”子字符串，直到它们准备好放入流中——也就是说，直到它们之前的所有索引都已写入。
- _我们的重新组装数据结构存储重叠子字符串可以吗？_ 不可以。可以实现一个“接口正确”的重新组装器，存储重叠子字符串。但允许重新组装器这样做会破坏“容量”作为内存限制的概念。如果调用者提供了关于同一索引的冗余知识，`Reassembler` 应仅存储此信息的一份副本。
- _Reassembler 会使用 ByteStream 的读取端吗？_ 不会——那是给外部客户的。Reassembler 仅使用写入端。
- _您预计有多少行代码？_ 当我们在起始代码上运行 `./scripts/lines-of-code` 时，它打印：

  ```plaintext
  ByteStream:82 lines of code
  Reassembler:26 lines of code
  ```

  当我们在我们的解决方案上运行时，它打印：

  ```plaintext
  ByteStream:111 lines of code
  Reassembler:85 lines of code
  ```

  因此，`Reassembler` 的合理实现可能需要大约 50-60 行代码（在起始代码之上）。

- 更多常见问题解答：更多信息，请参见 https://cs144.github.io/lab_faq.html。

## 4 开发和调试建议

1. 您可以通过编译后使用 `cmake --build build --target check1` 测试您的代码。
2. 请重新阅读检查点 0 文档中关于“使用 Git”的部分，并记住将代码保存在分发的 Git 仓库的 `main` 分支上。进行小型提交，使用良好的提交消息来标识更改内容及原因。
3. 请努力使您的代码对将要评分风格的 CA 来说易于阅读。为变量使用合理且清晰的命名约定。使用注释来解释复杂或微妙的代码片段。使用“防御性编程”——明确检查函数或不变量的前提条件，如果有任何错误则抛出异常。在设计中使用模块化——识别常见的抽象和行为，并在可能时将其分解出来。重复代码块和巨大的函数会使您的代码难以理解。
4. 还请遵循检查点 0 文档中描述的“现代 C++”风格。cppreference 网站（https://en.cppreference.com）是一个很好的资源，尽管您不需要 C++ 的任何复杂功能来完成这些实验。（您有时可能需要使用 `move()` 函数来传递无法复制的对象。）
5. 如果您的构建卡住且不确定如何修复，您可以删除您的 `build` 目录（`rm -rf build`——请小心不要输入错误，因为这将删除您告诉它的任何内容），然后再次运行 `cmake -S . -B build`。

## 5 提交

1. 在您的提交中，请仅对 `src` 目录中的 `.hh` 和 `.cc` 文件进行更改。在这些文件中，请根据需要自由添加私有成员，但请勿更改任何类的*公共*接口。
2. 在提交任何作业之前，请按顺序运行以下内容：
   - (a) 确保您已将所有更改提交到 Git 仓库。您可以运行 `git status` 确保没有未完成的更改。请记住：在编码时进行小型提交。
   - (b) `cmake --build build --target format`（以规范编码风格）
   - (c) `cmake --build build --target check1`（确保自动化测试通过）
   - (d) 可选：`cmake --build build --target tidy`（建议改进以遵循良好的 C++ 编程实践）
3. 在 `writeups/check1.md` 中编写报告。此文件应为大约 20 到 50 行的文档，每行不超过 80 个字符，以便更容易阅读。报告应包含以下部分：
   - (a) **结构和设计。** 描述代码中体现的高层结构和设计选择。您不需要详细讨论从起始代码继承的内容。利用这个机会突出重要的设计方面，并为您的评分 TA 提供更多细节以理解。您的数据结构在头文件中选择了什么？其中是否有不*严格*必要的？我们希望您尽可能避免冗余状态，除非您认为这样做会带来严重的性能损失，并且可以证明这一点。我们强烈建议您通过使用子标题和大纲使这份报告尽可能易于阅读。请不要简单地将您的程序翻译成一段英文。
   - (b) **替代设计选择**，您考虑过或理想情况下评估过的，在性能、编写难度（例如，产生无 bug 实现所需的小时数）、阅读难度（例如，代码行数及其微妙或非显而易见的正确性程度）以及您认为对读者（或您自己在完成此作业之前的自己）有趣的任何其他维度方面的内容。如果适用，请包括任何测量结果。
   - (c) **实现挑战。** 描述您发现最麻烦的代码部分并解释原因。反思您是如何克服这些挑战的，以及是什么帮助您最终理解了困扰您的概念。您是如何尝试确保您的代码保持您的假设、不变量和前提条件的，以及您发现这在哪些方面容易或困难？您是如何调试和测试您的代码的？
   - (d) **剩余错误。** 尽可能指出并解释代码中存在的任何错误（或未处理的边缘情况）。
4. 在您的报告中，还请填写作业花费您的小时数和其他评论。
5. 提交方式的机制将在截止日期前公布。
6. 请在实验课程中或通过在 EdStem 上发布问题尽快告知课程工作人员任何问题。祝您好运！

# 我的实现

## 0 Overview

所谓的 hands-on component 这一部分是今年(2025)新加入的，所以可能有很多无法操作的地方。

## 1 Getting Started

这里按照 lab 的要求操作就可以了，如果没有冲突的话应该正常 merge 就行。

## 2 Hand-on component: a private network for the class

因为我不是斯坦福的学生，所以没有办法加入到 cs144 课程官方的 wireguard 网络中去，我决定利用一个云服务器组建一个开放的 wireguard 网络，这样其他人都可以加入进来。

### 2.1 Ping a friend and look at the datagrams

TODO：等待上面的配置完成

### 2.2 Send an Internet datagram by hand

TODO：等待上面的配置完成

## 3 Implementation: putting substrings in sequence

这节课负责在 TCP 接收端重新按照顺序组装接收到的数据。

### 3.1 What should the Reassembler store internally?

### 3.2 FAQs

这里提到了一个提供的[[SLOC]]的脚本`./scripts/lines-of-code`，我运行的时候提示：

```bash
$ ./scripts/lines-of-code
bash: ./scripts/lines-of-code: cannot execute: required file not found
```

这个报错是因为 shebang 行用到的`/usr/bin/python`不存在，我的 ubuntu 里面有`/usr/bin/python3`。两种办法：

**1. 创建符号链接：**

```bash
sudo ln -s /usr/bin/python3 /usr/bin/python
```

这会在`/usr/bin/`目录下创建一个名为`python`的符号链接，指向`python3`。这样当脚本调用`/usr/bin/python`时，实际上会使用`python3`。

**2. 直接用 python3 解释器运行脚本：**

```bash
python3 ./scripts/lines-of-code
```

这种方式会忽略脚本中的 shebang 行，直接使用指定的解释器。

如果运行脚本还是报错：

```plaintext
FileNotFoundError: [Errno 2] No such file or directory: 'sloccount'
```

这个是因为系统没有安装`sloccount`程序。

```bash
sudo apt-get update
sudo apt-get install sloccount
```

## 4 Development and debugging advice

## 5 Submit
