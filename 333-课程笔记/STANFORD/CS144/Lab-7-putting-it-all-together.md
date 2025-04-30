# Checkpoint 7: putting it all together

## 0 Collaboration Policy

Collaboration Policy: Checkpoint 7 asks you to work with a groupmate—you'll need to connect together and perhaps debug together. In general, though, the collaboration rules are the same as checkpoint 0. Please do not look at other students' code or solutions to past versions of these assignments. Please fully disclose any collaborators or any gray areas in your writeup—disclosure is the best policy.

## 1 Overview

By this point in the class, you've implemented a significant portion of the Internet's infrastructure. From Checkpoint 0 (a reliable byte stream), to Checkpoints 1–3 (the Transmission Control Protocol), Checkpoint 5 (an IP/Ethernet network interface) and Checkpoint 6 (an IP router), you have done a lot of coding!

In this checkpoint, you won't necessarily need to do any coding (assuming your previous checkpoints are in good working shape). Instead, to cap off your accomplishment, you're going to use all of your previous labs to create a real network that includes your network stack (host and router) talking to the network stack implemented by another student in the class.

This checkpoint is done in pairs. You will need to work with a lab partner (another student in the class). Please use the lab sessions to find lab partners, or EdStem if you cannot attend the lab session. If it's necessary, the same student can serve as "lab partner" more than once.

## 2 Getting started

1. Make sure you have committed all your solutions. Please don't modify any files outside the top level of the src directory, or webget.cc and ip raw.cc. You may have trouble merging the Checkpoint 7 starter code otherwise.
2. While inside the repository for the lab assignments, run `git fetch --all` to retrieve the most recent version of the lab assignment.
3. Download the starter code for Checkpoint 7 by running `git merge origin/check7-startercode`.
4. Make sure your build system is properly set up: `cmake -S . -B build`
5. Remember that if you have trouble, you can build "sanitizing" (bug-checking) versions of the applications with `cmake -S . -B build -DSANITIZED APPS=True`
6. Compile the source code: `cmake --build build`
7. Open and start editing the writeups/check7.md file. This is the template for your lab writeup and will be included in your submission.
8. Reminder: please make frequent small commits in your local Git repository as you work. If you need help to make sure you're doing this right, please ask a classmate or the teaching staff for help. You can use the `git log` command to see your Git history.

## 3 The Network

In this lab, you'll create a real network that combines your network stack with one implemented by another student in the class. You'll re-do the "1 megabyte challenge" that you did in checkpoint 3, but this time over an entire physical-layer network path (including your router and their router). Each of you will contribute one host (including your reliable Byte Stream, your TCP implementation, and your NetworkInterface) and one router (including two more of your NetworkInterfaces).

[The PDF contains a network diagram showing the connection between Lab Partner #1 and Lab Partner #2 with client and server hosts]

Because it's likely that you or your lab partner will be behind a Network Address Translator, the network connection between the two sides will flow through a relay server (cs144.keithw.org).

We have glued your code together in a new application that can be found in build/apps/endtoend. Here are the steps to run it:

1. Before doing these steps with a lab partner, try them by yourself. You can play both roles, client and server, by using two different windows or terminals on your VM. This way your network will include two copies of your code (host and router) talking to themselves. This is easier to debug than talking to a stranger!

   Once these steps work on your own, then try them with a lab partner. Decide which of the two of you will act as the "client" and who will be the "server". Once it works, you can always swap the roles and try again.

2. To use the relay, please pick a random even number between 1024 and 64000. This identifies your lab group and needs to be different from any other lab group working at the same time, so please do pick a random number. And it needs to be an even number. For the rest of these examples, we'll assume you picked "3000". But don't actually use "3000"—it needs to be a different number from everybody else.

3. The "server" student runs:

   ```
   ./build/apps/endtoend server cs144.keithw.org 3000
   ```

   (replace "3000" with your actual number).

   If all goes well, the "server" will print output like this:

   ```
   $ ./build/apps/endtoend server cs144.keithw.org 3000
   DEBUG: Network interface has Ethernet address 02:00:00:5e:61:17 and IP address 172.16.0.1
   DEBUG: Network interface has Ethernet address 02:00:00:cd:e7:e0 and IP address 10.0.0.172
   DEBUG: adding route 172.16.0.0/12 => (direct) on interface 0
   DEBUG: adding route 10.0.0.0/8 => (direct) on interface 1
   DEBUG: adding route 192.168.0.0/16 => 10.0.0.192 on interface 1
   DEBUG: Network interface has Ethernet address 5a:75:4e:8b:20:00 and IP address 172.16.0.100
   DEBUG: Listening for incoming connection...
   ```

4. The "client" student runs:

   ```
   ./build/apps/endtoend client cs144.keithw.org 3001
   ```

   (replace "3001" with whatever your random number was, plus one).

   If all goes well, the "client" will print output like this:

   ```
   $ ./build/apps/endtoend client cs144.keithw.org 3001
   DEBUG: Network interface has Ethernet address 02:00:00:41:c7:5b and IP address 192.168.0.1
   DEBUG: Network interface has Ethernet address 02:00:00:e6:66:d9 and IP address 10.0.0.192
   DEBUG: adding route 192.168.0.0/16 => (direct) on interface 0
   DEBUG: adding route 10.0.0.0/8 => (direct) on interface 1
   DEBUG: adding route 172.16.0.0/12 => 10.0.0.172 on interface 1
   DEBUG: Network interface has Ethernet address 26:05:12:4a:8a:c9 and IP address 192.168.0.50
   DEBUG: Connecting from 192.168.0.50:57005...
   DEBUG: Connecting to 172.16.0.100:1234...
   Successfully connected to 172.16.0.100:1234.
   ```

   and the "server" will print one more line:

   ```
   New connection from 192.168.0.50:57005.
   ```

5. If you see the expected output, you're in really good shape—the two computers have successfully exchanged a TCP handshake!

   a. Pat yourselves on the back (using appropriate social distancing protocols)—you've earned it!

   b. Now it's time to exchange data. Type in one of the windows, and see the output appear in the other. Try typing in the reverse direction.

   c. Try ending the connection. Type ctrl-D when you are done. When each side does so, it will end input on the outbound ByteStream in that direction, while continuing to receive incoming data until the peer ends its own ByteStream. Verify this happens.

   d. When both sides have ended their ByteStreams, and one side has finished lingering for a few seconds, both programs should exit gracefully.

6. If you don't see the expected output, it may be time to turn on "debug mode". Run the "endtoend" program with one additional argument: append a "debug" to the end of the command line. This will print out every Ethernet frame being exchanged, and you can see all the ARP and TCP/IP frames.

7. Once you have the network working between two windows on your own computer, it's time to try the same steps with a lab partner (and their own implementation).

## 4 Sending a file

Once it looks like you can have a basic conversation, try sending a file over the network. Again, you can try this yourself, and if all goes well, then try it with a lab partner. Here is how:

To write a one-megabyte random file to "/tmp/big.txt":

```
dd if=/dev/urandom bs=1M count=1 of=/tmp/big.txt
```

To have the server send the file as soon as it accepts an incoming connection:

```
./build/apps/endtoend server cs144.keithw.org even_number < /tmp/big.txt
```

To have the client close its outbound stream and download the file:

```
</dev/null ./build/apps/endtoend client cs144.keithw.org odd_number > /tmp/big-received.txt
```

To compare two files and make sure they're the same:

```
sha256sum /tmp/big.txt or sha256sum /tmp/big-received.txt
```

If the SHA-256 hashes match, you can be almost certain the file was transmitted correctly.

## 5 If you have trouble...

- Consider building the "sanitizing" (bug-checking) version of the endtoend program. It will find many instances of undefined behavior and use of invalid addresses in your code. (See above for directions.)
- Run the entire unit-test suite (including new tests your classmates have contributed this quarter) with `cmake --build build --target test`

## 6 Extra credit

For some (token) extra credit, if everything is working perfectly, we'd encourage you to do something creative and put something interesting in your writeup. Please feel free to modify the endtoend.cc program as you see fit. You could create a more complicated network involving more students at the same time, or do something else we haven't anticipated. (To be clear: this is not at all required.)

## 7 Submit

1. Write a report in writeups/check7.md. This file should be a roughly 30-to-70-line document with no more than 80 characters per line to make it easier to read. The report should contain the following sections:

   - Solo portion

     - Did your implementation successfully start and end a conversation with another copy of itself?
     - Did it successfully transfer a one-megabyte file, with contents identical upon receipt?
     - Please describe what code changes, if any, were necessary to pass these steps.

   - Group portion

     - Who is your lab partner (and what is their SUNet ID, e.g. winstein)?
     - Did your implementations successfully start and end a conversation with each other (with each implementation acting as "client" or as "server")?
     - Did you successfully transfer a one-megabyte file between your two implementations, with contents identical upon receipt?
     - Please describe what code changes, if any, were necessary to pass these steps, either by you or your lab partner.

   - Creative portion
     - If you did anything for our "creative challenge," please boast about it!

2. If you did have to make changes to source code, please only make changes to the .hh and .cc files in the top level of src. Within these files, please feel free to add private members as necessary, but please don't change the public interface.

3. Please don't add extra files—the automatic grader won't look at them and your code may fail to compile.

4. Please also fill in the number of hours the assignment took you and any other comments.

5. Please let the course staff know ASAP of any problems at the lab sessions, or by posting a question on EdStem.

# 中文

## 0 协作政策

协作政策：检查点 7 要求您与一名组员一起工作——您需要一起连接，可能还需要一起调试。然而，一般来说，协作规则与检查点 0 相同。请勿查看其他学生的代码或这些作业的过去版本的解决方案。请在您的报告中完全披露任何合作者或任何灰色地带——披露是最好的政策。

## 1 概述

到课程的这个阶段，您已经实现了互联网基础设施的重要部分。从检查点 0（可靠的字节流），到检查点 1-3（传输控制协议），检查点 5（IP/以太网网络接口）和检查点 6（IP 路由器），您已经完成了大量的编码工作！

在这个检查点中，您不一定需要进行任何编码（假设您之前的检查点工作状态良好）。相反，为了圆满完成您的成就，您将使用之前所有的实验来创建一个真实的网络，包括您的网络栈（主机和路由器）与班级中另一名学生实现的网络栈进行通信。

这个检查点是成对完成的。您需要与一名实验室伙伴（班级中的另一名学生）一起工作。请利用实验室课程寻找实验室伙伴，如果您无法参加实验室课程，可以使用 EdStem。如果有必要，同一名学生可以多次担任“实验室伙伴”。

## 2 开始

1. 确保您已提交了所有解决方案。请勿修改 src 目录顶层外的任何文件，或 webget.cc 和 ip raw.cc。否则，您可能会在合并检查点 7 起始代码时遇到麻烦。
2. 在实验作业的代码库内，运行 `git fetch --all` 以获取实验作业的最新版本。
3. 通过运行 `git merge origin/check7-startercode` 下载检查点 7 的起始代码。
4. 确保您的构建系统已正确设置：`cmake -S . -B build`
5. 请记住，如果您遇到问题，可以使用 `cmake -S . -B build -DSANITIZED APPS=True` 构建“sanitizing”（错误检查）版本的应用程序
6. 编译源代码：`cmake --build build`
7. 打开并开始编辑 writeups/check7.md 文件。这是您的实验报告模板，将包含在您的提交中。
8. 提醒：请在工作时在您的本地 Git 仓库中频繁进行小型提交。如果您需要帮助确保您正确执行此操作，请向同学或教学人员寻求帮助。您可以使用 `git log` 命令查看您的 Git 历史记录。

## 3 网络

在本实验中，您将创建一个真实的网络，将您的网络栈与班级中另一名学生实现的网络栈结合起来。您将重做在检查点 3 中完成的“1 兆字节挑战”，但这次是通过整个物理层网络路径（包括您的路由器和他们的路由器）。你们每个人将贡献一个主机（包括您的可靠字节流、您的 TCP 实现和您的 NetworkInterface）和一个路由器（包括另外两个您的 NetworkInterface）。

[PDF 包含一个网络图，显示实验室伙伴 #1 和实验室伙伴 #2 之间客户端和服务器主机的连接]

由于您或您的实验室伙伴很可能位于网络地址转换器（NAT）之后，两侧之间的网络连接将通过一个中继服务器（cs144.keithw.org）流动。

我们已经将您的代码粘合在一个新的应用程序中，可以在 build/apps/endtoend 中找到。以下是运行它的步骤：

1. 在与实验室伙伴一起执行这些步骤之前，先自己尝试。您可以在虚拟机上使用两个不同的窗口或终端扮演客户端和服务器角色。这样，您的网络将包括您的代码（主机和路由器）的两个副本与自己通信。这比与陌生人交流更容易调试！

   一旦这些步骤在您自己身上有效，然后与实验室伙伴一起尝试。决定你们两个中谁将扮演“客户端”，谁将是“服务器”。一旦成功，你们可以随时交换角色并再次尝试。

2. 要使用中继服务器，请选择一个介于 1024 和 64000 之间的随机偶数。这标识您的实验室小组，并且需要与其他同时工作的实验室小组不同，所以请确实选择一个随机数。而且它必须是一个偶数。在接下来的示例中，我们假设您选择了“3000”。但不要实际使用“3000”——它需要与其他人不同。

3. “服务器”学生运行：

   ```
   ./build/apps/endtoend server cs144.keithw.org 3000
   ```

   （将“3000”替换为您实际的数字）。

   如果一切顺利，“服务器”将打印类似以下输出：

   ```
   $ ./build/apps/endtoend server cs144.keithw.org 3000
   DEBUG: Network interface has Ethernet address 02:00:00:5e:61:17 and IP address 172.16.0.1
   DEBUG: Network interface has Ethernet address 02:00:00:cd:e7:e0 and IP address 10.0.0.172
   DEBUG: adding route 172.16.0.0/12 => (direct) on interface 0
   DEBUG: adding route 10.0.0.0/8 => (direct) on interface 1
   DEBUG: adding route 192.168.0.0/16 => 10.0.0.192 on interface 1
   DEBUG: Network interface has Ethernet address 5a:75:4e:8b:20:00 and IP address 172.16.0.100
   DEBUG: Listening for incoming connection...
   ```

4. “客户端”学生运行：

   ```
   ./build/apps/endtoend client cs144.keithw.org 3001
   ```

   （将“3001”替换为您随机选择的数字加一）。

   如果一切顺利，“客户端”将打印类似以下输出：

   ```
   $ ./build/apps/endtoend client cs144.keithw.org 3001
   DEBUG: Network interface has Ethernet address 02:00:00:41:c7:5b and IP address 192.168.0.1
   DEBUG: Network interface has Ethernet address 02:00:00:e6:66:d9 and IP address 10.0.0.192
   DEBUG: adding route 192.168.0.0/16 => (direct) on interface 0
   DEBUG: adding route 10.0.0.0/8 => (direct) on interface 1
   DEBUG: adding route 172.16.0.0/12 => 10.0.0.172 on interface 1
   DEBUG: Network interface has Ethernet address 26:05:12:4a:8a:c9 and IP address 192.168.0.50
   DEBUG: Connecting from 192.168.0.50:57005...
   DEBUG: Connecting to 172.16.0.100:1234...
   Successfully connected to 172.16.0.100:1234.
   ```

   并且“服务器”将再打印一行：

   ```
   New connection from 192.168.0.50:57005.
   ```

5. 如果您看到预期的输出，您的情况非常好——两台计算机已经成功交换了 TCP 握手！

   a. 拍拍自己的背（使用适当的社交距离协议）——您 заслужили это！

   b. 现在是时候交换数据了。在其中一个窗口中输入，查看输出在另一个窗口中出现。尝试反向输入。

   c. 尝试结束连接。当您完成后输入 ctrl-D。当每一方这样做时，它将结束该方向上的出站 ByteStream 的输入，同时继续接收传入数据，直到对等方结束自己的 ByteStream。验证这种情况发生。

   d. 当双方都结束了他们的 ByteStream，并且一方在几秒钟的逗留后完成时，两个程序都应该优雅地退出。

6. 如果您没有看到预期的输出，可能是时候开启“调试模式”。在命令行末尾添加一个“debug”作为额外参数运行“endtoend”程序。这将打印出交换的每个以太网帧，您可以看到所有的 ARP 和 TCP/IP 帧。

7. 一旦您在自己的计算机上的两个窗口之间使网络工作，是时候与实验室伙伴（和他们自己的实现）尝试相同的步骤了。

## 4 发送文件

一旦看起来您可以进行基本对话，尝试通过网络发送文件。同样，您可以自己尝试，如果一切顺利，然后与实验室伙伴一起尝试。以下是如何操作：

要将一个一兆字节的随机文件写入“/tmp/big.txt”：

```
dd if=/dev/urandom bs=1M count=1 of=/tmp/big.txt
```

要让服务器在接受传入连接后立即发送文件：

```
./build/apps/endtoend server cs144.keithw.org even_number < /tmp/big.txt
```

要让客户端关闭其出站流并下载文件：

```
</dev/null ./build/apps/endtoend client cs144.keithw.org odd_number > /tmp/big-received.txt
```

要比较两个文件并确保它们相同：

```
sha256sum /tmp/big.txt or sha256sum /tmp/big-received.txt
```

如果 SHA-256 哈希值匹配，您几乎可以确定文件已正确传输。

## 5 如果您遇到问题...

- 考虑构建“sanitizing”（错误检查）版本的 endtoend 程序。它将发现您代码中的许多未定义行为和无效地址使用实例。（参见上面的说明。）
- 使用 `cmake --build build --target test` 运行整个单元测试套件（包括您的同学在本季度贡献的新测试）

## 6 额外学分

为了获得一些（象征性的）额外学分，如果一切都完美运行，我们鼓励您做一些有创意的事情，并在您的报告中加入一些有趣的内容。请随意根据需要修改 endtoend.cc 程序。您可以创建一个涉及更多学生同时参与的更复杂的网络，或者做一些我们没有预料到的事情。（明确说明：这完全不是必需的。）

## 7 提交

1. 在 writeups/check7.md 中编写报告。此文件应为大约 30 到 70 行的文档，每行不超过 80 个字符，以便更容易阅读。报告应包含以下部分：

   - 个人部分

     - 您的实现是否成功地与自己的另一个副本开始和结束对话？
     - 它是否成功传输了一个一兆字节的文件，接收时内容相同？
     - 请描述通过这些步骤是否需要进行代码更改。

   - 小组部分

     - 您的实验室伙伴是谁（他们的 SUNet ID 是什么，例如 winstein）？
     - 您的实现是否成功地与对方的实现开始和结束对话（每个实现作为“客户端”或“服务器”）？
     - 您是否在两个实现之间成功传输了一个一兆字节的文件，接收时内容相同？
     - 请描述通过这些步骤是否需要进行代码更改，无论是您还是您的实验室伙伴。

   - 创意部分
     - 如果您为我们的“创意挑战”做了任何事情，请吹嘘一下！

2. 如果您确实需要对源代码进行更改，请仅对 src 顶层的 .hh 和 .cc 文件进行更改。在这些文件中，请根据需要自由添加私有成员，但请勿更改公共接口。

3. 请勿添加额外的文件——自动评分器不会查看它们，您的代码可能会无法编译。

4. 还请填写作业花费您的小时数和其他评论。

5. 请在实验课程中或通过在 EdStem 上发布问题尽快告知课程工作人员任何问题。

# 我的实现
