# Lab Checkpoint 6: building an IP router

## 0 Collaboration Policy

Collaboration Policy: Same as checkpoint 0. Please do not look at other students' code or solutions to past versions of these assignments. Please fully disclose any collaborators or any gray areas in your writeup—disclosure is the best policy.

## 1 Overview

In this week's lab checkpoint, you'll implement an IP router on top of your existing NetworkInterface. A router has several network interfaces, and can receive Internet datagrams on any of them. The router's job is to forward the datagrams it gets according to the routing table: a list of rules that tells the router, for any given datagram,

- What interface to send it out
- The IP address of the next hop

Your job is to implement a router that can figure out these two things for any given datagram. (You will not need to implement the algorithms that make the routing table, e.g. RIP, OSPF, BGP, or an SDN controller—just the algorithm that follows the routing table.)

Your implementation of the router will use the Minnow library with a new Router class, and tests that will check your router's functionality in a simulated network. Checkpoint 6 builds on your implementation of NetworkInterface from Checkpoint 5, but does not use the TCP stack you implemented previously. IP routers don't have to know anything about TCP, ARP, or Ethernet (only IP). We expect your implementation will require about 30–60 lines of code. (The scripts/lines-of-code tool prints "Router: 38 lines of code" from the starter code, and "89 lines of code" for our example solutions.)

## 2 Getting started

1. Make sure you have committed all your solutions to Checkpoint 5. Please don't modify any files outside the top level of the src directory, or webget.cc. You may have trouble merging the Checkpoint 6 starter code otherwise.
2. While inside the repository for the lab assignments, run `git fetch --all` to retrieve the most recent version of the lab assignment.
3. Download the starter code for Checkpoint 6 by running `git merge origin/check6-startercode`.
   (If you have renamed the "origin" remote to be something else, you might need to use a different name here, e.g. `git merge upstream/check5-startercode`.)
4. Make sure your build system is properly set up: `cmake -S . -B build`
5. Compile the source code: `cmake --build build`
6. Open and start editing the writeups/check6.md file. This is the template for your lab writeup and will be included in your submission.
7. Reminder: please make frequent small commits in your local Git repository as you work. If you need help to make sure you're doing this right, please ask a classmate or the teaching staff for help. You can use the `git log` command to see your Git history.

## 3 Implementing the Router

In this lab, you will implement a Router class that can:

- keep track of a routing table (the list of forwarding rules, or routes), and
- forward each datagram it receives:
  - to the correct next hop
  - on the correct outgoing NetworkInterface.

Your implementation will be added to the router.hh and router.cc skeleton files. Before you get to coding, please review the documentation for the new Router class in router.hh.

Here are the two methods you'll implement, and what we're expecting in each:

```cpp
void add_route(uint32_t route_prefix,
              uint8_t prefix_length,
              optional<Address> next_hop,
              size_t interface_num);
```

This method adds a route to the routing table. You'll want to add a data structure as a private member in the Router class to store this information. All this method needs to do is save the route for later use.

**What do the parts of a route mean?**

A route is a "match-action" rule: it tells the router that if a datagram is headed for a particular network (a range of IP addresses), and if the route is chosen as the most specific matching route, then the router should forward the datagram to a particular next hop on a particular interface.

The "match": is the datagram headed for this network? The route prefix and prefix length together specify a range of IP addresses (a network) that might include the datagram's destination. The route prefix is a 32-bit numeric IP address. The prefix length is a number between 0 and 32 (inclusive); it tells the router how many most-significant bits of the route prefix are significant. For example, to express a route to the network "18.47.0.0/16" (this matches any 32-bit IP address where the first two bytes are 18 and 47), the route prefix would be 305070080 (18 × 2^24 + 47 × 2^16), and the prefix length would be 16. Any datagram destined for "18.47.x.y" will match.

The "action": what to do if the route matches and is chosen. If the router is directly attached to the network in question, the next hop will be an empty optional. In that case, the next hop is the datagram's destination address. But if the router is connected to the network in question through some other router, the next hop will contain the IP address of the next router along the path. The interface num gives the index of the router's NetworkInterface that should use to send the datagram to the next hop. You can access this interface with the interface(interface_num) method.

```cpp
void route();
```

Here's where the rubber meets the road. This method needs to route each incoming datagram to the next hop, out the appropriate interface. It needs to implement the "longest-prefix match" logic of an IP router to find the best route to follow. That means:

- The Router searches the routing table to find the routes that match the datagram's destination address. By "match," we mean the most-significant prefix length bits of the destination address are identical to the most-significant prefix length bits of the route prefix.
- Among the matching routes, the router chooses the route with the biggest value of prefix length. This is the longest-prefix-match route.
- If no routes matched, the router drops the datagram.
- The router decrements the datagram's TTL (time to live). If the TTL was zero already, or hits zero after the decrement, the router should drop the datagram.
- Otherwise, the router sends the modified datagram on the appropriate interface (`interface(interface_num)->send_datagram()`) to the appropriate next hop.

There's a beauty (or at least a successful abstraction) in the Internet's design here: the router never thinks about TCP, about ARP, or about Ethernet frames. The router doesn't even know what the link layer looks like. The router only thinks about Internet datagrams, and only interacts with the link layer through the NetworkInterface abstraction. When it comes to questions like, "How are link-layer addresses resolved?" or "Does the link layer even have its own addressing scheme distinct from IP?" or "What's the format of the link-layer frames?" or "What's the meaning of the datagram's payload?", the router just doesn't care.

## 4 Testing

You can test your implementation by running `cmake --build build --target check5`. This will test your router in a particular simulated network, shown in Figure 2.

## 5 Q & A

- **What data structure should I use to record the routing table?**
  Up to you! But please don't get crazy. It's perfectly acceptable for each datagram to require O(N) work, where N is the number of entries in the routing table. If you'd like to do something more efficient, we'd encourage you to get a working implementation first before optimizing, and carefully document and comment whatever you choose to implement.

- **How do I convert an IP address that comes in the form of an Address object, into a raw 32-bit integer that I can write into the ARP message?**
  Use the `Address::ipv4_numeric()` method.

- **How do I convert an IP address that comes in the form of a raw 32-bit integer into an Address object?**
  Use the `Address::from_ipv4_numeric()` method.

- **How do I compare the most-significant N bits (where 0 ≤ N ≤ 32) of one 32-bit IP address with the most-significant N bits of another 32-bit IP address?**
  This is probably the "trickiest" part of this assignment—getting that logic right. It may be worth writing a small test program in C++ (a short standalone program) or adding a test to Minnow to verify your understanding of the relevant C++ operators and double-check your logic.

  Recall that in C and C++, it can produce undefined behavior to shift a 32-bit integer by 32 bits. The tests run your code under sanitizers that try to detect this. You can run the router test directly by running `./build/tests/router` from the minnow directory.

- **If the router has no route to the destination, or if the TTL hits zero, shouldn't it send an ICMP error message back to the datagram's source?**
  In real life, yes, that would be helpful. But not necessary in this lab—dropping the datagram is sufficient. (Even in the real world, not every router will send an ICMP message back to the source in these situations.)

- **Where can I read if there are more FAQs after this PDF comes out?**
  Please check the website (https://cs144.github.io/lab_faq.html) and EdStem regularly.

## 6 Submit

1. In your submission, please only make changes to the .hh and .cc files in the src directory. Within these files, please feel free to add private members as necessary, but please don't change the public interface of any of the classes.

2. Before handing in any assignment, please run these in order:
   a. Make sure you have committed all of your changes to the Git repository. You can run `git status` to make sure there are no outstanding changes. Remember: make small commits as you code.
   b. `cmake --build build --target format` (to normalize the coding style)
   c. `cmake --build build --target check6` (to make sure the automated tests pass)
   d. Optional: `cmake --build build --target tidy` (suggests improvements to follow good C++ programming practices)

3. Write a report in writeups/check6.md. This file should be a roughly 20-to-50-line document with no more than 80 characters per line to make it easier to read. The report should contain the following sections:
   a. **Program Structure and Design.** Describe the high-level structure and design choices embodied in your code. You do not need to discuss in detail what you inherited from the starter code. Use this as an opportunity to highlight important design aspects and provide greater detail on those areas for your grading TA to understand. You are strongly encouraged to make this writeup as readable as possible by using subheadings and outlines. Please do not simply translate your program into an paragraph of English.
   b. **Implementation Challenges.** Describe the parts of code that you found most troublesome and explain why. Reflect on how you overcame those challenges and what helped you finally understand the concept that was giving you trouble. How did you attempt to ensure that your code maintained your assumptions, invariants, and preconditions, and in what ways did you find this easy or difficult? How did you debug and test your code?
   c. **Remaining Bugs.** Point out and explain as best you can any bugs (or unhandled edge cases) that remain in the code.

4. Please also fill in the number of hours the assignment took you and any other comments.

5. Please let the course staff know ASAP of any problems at the lab sessions, or by posting a question on EdStem.

# 中文

## 0 协作政策

协作政策：与检查点 0 相同。请勿查看其他学生的代码或这些作业的过去版本的解决方案。请在您的报告中完全披露任何合作者或任何灰色地带——披露是最好的政策。

## 1 概述

在本周的实验检查点中，您将在现有的 NetworkInterface 之上实现一个 IP 路由器。路由器有多个网络接口，可以在其中任何一个上接收互联网数据报。路由器的任务是根据路由表转发它收到的数据报：路由表是一个规则列表，告诉路由器对于任何给定的数据报，

- 通过哪个接口发送出去
- 下一跳的 IP 地址

您的任务是实现一个路由器，可以为任何给定的数据报确定这两件事。（您不需要实现制作路由表的算法，例如 RIP、OSPF、BGP 或 SDN 控制器——只需实现遵循路由表的算法。）

您的路由器实现将使用 Minnow 库和一个新的 Router 类，以及在模拟网络中检查路由器功能的测试。检查点 6 建立在您在检查点 5 中实现的 NetworkInterface 之上，但不使用您之前实现的 TCP 栈。IP 路由器不需要了解 TCP、ARP 或以太网（仅 IP）。我们预计您的实现将需要大约 30-60 行代码。（scripts/lines-of-code 工具从起始代码中打印“Router: 38 lines of code”，从我们的示例解决方案中打印“89 lines of code”。）

## 2 开始

1. 确保您已提交了检查点 5 的所有解决方案。请勿修改 src 目录顶层外的任何文件，或 webget.cc。否则，您可能会在合并检查点 6 起始代码时遇到麻烦。
2. 在实验作业的代码库内，运行 `git fetch --all` 以获取实验作业的最新版本。
3. 通过运行 `git merge origin/check6-startercode` 下载检查点 6 的起始代码。（如果您已将“origin”远程仓库重命名为其他名称，您可能需要在这里使用不同的名称，例如 `git merge upstream/check5-startercode`。）
4. 确保您的构建系统已正确设置：`cmake -S . -B build`
5. 编译源代码：`cmake --build build`
6. 打开并开始编辑 writeups/check6.md 文件。这是您的实验报告模板，将包含在您的提交中。
7. 提醒：请在工作时在您的本地 Git 仓库中频繁进行小型提交。如果您需要帮助确保您正确执行此操作，请向同学或教学人员寻求帮助。您可以使用 `git log` 命令查看您的 Git 历史记录。

## 3 实现路由器

在本实验中，您将实现一个 Router 类，可以：

- 跟踪路由表（转发规则或路由的列表），以及
- 转发它收到的每个数据报：
  - 到正确的下一跳
  - 通过正确的出站 NetworkInterface。

您的实现将添加到 router.hh 和 router.cc 骨架文件中。在开始编码之前，请查看 router.hh 中新的 Router 类的文档。

以下是您将实现的两个方法，以及我们对每个方法的期望：

```cpp
void add_route(uint32_t route_prefix,
              uint8_t prefix_length,
              optional<Address> next_hop,
              size_t interface_num);
```

此方法向路由表添加一个路由。您需要在 Router 类中添加一个数据结构作为私有成员来存储此信息。此方法只需保存路由以供以后使用。

**路由的各个部分是什么意思？**

路由是一个“匹配-动作”规则：它告诉路由器，如果数据报的目标是特定网络（一系列 IP 地址），并且如果该路由被选为最具体的匹配路由，那么路由器应将数据报转发到特定下一跳的特定接口上。

“匹配”：数据报是否目标是此网络？路由前缀和前缀长度一起指定了一个可能包含数据报目标的 IP 地址范围（一个网络）。路由前缀是一个 32 位的数字 IP 地址。前缀长度是一个介于 0 和 32 之间（包括）的数字；它告诉路由器路由前缀的多少最高有效位是重要的。例如，要表示到网络“18.47.0.0/16”的路由（这匹配任何前两个字节为 18 和 47 的 32 位 IP 地址），路由前缀将是 305070080 (18 × 2^24 + 47 × 2^16)，前缀长度将是 16。任何目标为“18.47.x.y”的数据报都将匹配。

“动作”：如果路由匹配并被选中，该做什么。如果路由器直接连接到相关网络，下一跳将是一个空的 optional。在这种情况下，下一跳是数据报的目标地址。但如果路由器通过其他路由器连接到相关网络，下一跳将包含路径上下一台路由器的 IP 地址。接口编号给出了路由器的 NetworkInterface 的索引，该接口应使用该索引将数据报发送到下一跳。您可以使用 interface(interface_num) 方法访问此接口。

```cpp
void route();
```

这里是关键所在。此方法需要将每个传入的数据报路由到下一跳，通过适当的接口发送出去。它需要实现 IP 路由器的“最长前缀匹配”逻辑，以找到要遵循的最佳路由。这意味着：

- 路由器搜索路由表，找到与数据报目标地址匹配的路由。所谓“匹配”，我们指的是目标地址的最高有效前缀长度位与路由前缀的最高有效前缀长度位相同。
- 在匹配的路由中，路由器选择前缀长度值最大的路由。这是最长前缀匹配路由。
- 如果没有路由匹配，路由器丢弃数据报。
- 路由器减少数据报的 TTL（生存时间）。如果 TTL 已经是零，或者在减少后变为零，路由器应丢弃数据报。
- 否则，路由器在适当的接口上发送修改后的数据报（`interface(interface_num)->send_datagram()`）到适当的下一跳。

互联网设计在这里有一种美感（或者至少是一种成功的抽象）：路由器从不考虑 TCP、ARP 或以太网帧。路由器甚至不知道链路层是什么样子。路由器只考虑互联网数据报，并且只通过 NetworkInterface 抽象与链路层交互。至于“链路层地址如何解析？”或“链路层是否有与 IP 不同的自己的寻址方案？”或“链路层帧的格式是什么？”或“数据报有效载荷的含义是什么？”等问题，路由器根本不在乎。

## 4 测试

您可以通过运行 `cmake --build build --target check5` 测试您的实现。这将在图 2 所示的特定模拟网络中测试您的路由器。

## 5 问答

- **我应该使用什么数据结构来记录路由表？**
  由您决定！但请不要过于复杂。对于每个数据报需要 O(N) 的工作是完全可以接受的，其中 N 是路由表中的条目数。如果您想做一些更高效的事情，我们鼓励您先获得一个工作的实现，然后再进行优化，并仔细记录和注释您选择实现的任何内容。

- **我如何将以 Address 对象形式出现的 IP 地址转换为可以写入 ARP 消息的原始 32 位整数？**
  使用 `Address::ipv4_numeric()` 方法。

- **我如何将以原始 32 位整数形式出现的 IP 地址转换为 Address 对象？**
  使用 `Address::from_ipv4_numeric()` 方法。

- **我如何比较一个 32 位 IP 地址的最高有效 N 位（其中 0 ≤ N ≤ 32）与另一个 32 位 IP 地址的最高有效 N 位？**
  这可能是此作业中最“棘手”的部分——确保逻辑正确。可能值得在 C++ 中编写一个小型测试程序（一个简短的独立程序）或向 Minnow 添加一个测试，以验证您对相关 C++ 运算符的理解，并仔细检查您的逻辑。

  回想一下，在 C 和 C++ 中，将 32 位整数移位 32 位可能会产生未定义的行为。测试会在尝试检测此问题的 sanitizer 下运行您的代码。您可以通过从 minnow 目录运行 `./build/tests/router` 直接运行路由器测试。

- **如果路由器没有到目标的路由，或者如果 TTL 变为零，不应该向数据报的源发送 ICMP 错误消息吗？**
  在现实生活中，是的，那会很有帮助。但在本实验中不是必需的——丢弃数据报就足够了。（即使在现实世界中，也不是每个路由器都会在这些情况下向源发送 ICMP 消息。）

- **如果此 PDF 发布后有更多常见问题，我可以在哪里阅读？**
  请定期查看网站 (https://cs144.github.io/lab_faq.html) 和 EdStem。

## 6 提交

1. 在您的提交中，请仅对 src 目录中的 .hh 和 .cc 文件进行更改。在这些文件中，请根据需要自由添加私有成员，但请勿更改任何类的公共接口。

2. 在提交任何作业之前，请按顺序运行以下内容：
   a. 确保您已将所有更改提交到 Git 仓库。您可以运行 `git status` 确保没有未完成的更改。请记住：在编码时进行小型提交。
   b. `cmake --build build --target format`（以规范编码风格）
   c. `cmake --build build --target check6`（确保自动化测试通过）
   d. 可选：`cmake --build build --target tidy`（建议改进以遵循良好的 C++ 编程实践）

3. 在 writeups/check6.md 中编写报告。此文件应为大约 20 到 50 行的文档，每行不超过 80 个字符，以便更容易阅读。报告应包含以下部分：
   a. **程序结构和设计。** 描述代码中体现的高层结构和设计选择。您不需要详细讨论从起始代码继承的内容。利用这个机会突出重要的设计方面，并为您的评分 TA 提供更多细节以理解。您强烈建议通过使用子标题和大纲使这份报告尽可能易于阅读。请不要简单地将您的程序翻译成一段英文。
   b. **实现挑战。** 描述您发现最麻烦的代码部分并解释原因。反思您是如何克服这些挑战的，以及是什么帮助您最终理解了困扰您的概念。您是如何尝试确保您的代码保持您的假设、不变量和前提条件的，以及您发现这在哪些方面容易或困难？您是如何调试和测试您的代码的？
   c. **剩余错误。** 尽可能指出并解释代码中存在的任何错误（或未处理的边缘情况）。

4. 还请填写作业花费您的小时数和其他评论。

5. 请在实验课程中或通过在 EdStem 上发布问题尽快告知课程工作人员任何问题。

# 我的实现
