# Lab Checkpoint 3: the TCP sender

## 0 Overview

Suggestion: read the whole lab document before implementing.

In Checkpoint 0, you implemented the abstraction of a flow-controlled byte stream (ByteStream). In Checkpoints 1 and 2, you implemented the tools that translate from segments carried in unreliable datagrams to an incoming byte stream: the Reassembler and TCPReceiver.

Now, in Checkpoint 3, you'll implement the other side of the connection. The TCPSender is a tool that translates from an outbound byte stream to segments that will become the payloads of unreliable datagrams. Finally, in Checkpoint 4, you'll combine your work from the previous to labs to create a working TCP implementation: a TCPPeer that contains a TCPSender and TCPReceiver. You'll use this to talk to a classmate and to peers across the Internet—real servers that speak TCP.

## 1 Getting started

Your implementation of a TCPSender will use the same Minnow library that you used in Checkpoints 0–2, with additional classes and tests. To get started:

1. Make sure you have committed all your solutions to Checkpoint 1. Please don't modify any files outside the top level of the src directory, or webget.cc. You may have trouble merging the Checkpoint 1 starter code otherwise.

2. While inside the repository for the lab assignments, run `git fetch --all` to retrieve the most recent version of the lab assignment.

3. Download the starter code for Checkpoint 3 by running `git merge origin/check3-startercode`. (If you have renamed the "origin" remote to be something else, you might need to use a different name here, e.g. `git merge upstream/check3-startercode`.)

4. Make sure your build system is properly set up: `cmake -S . -B build`

5. Compile the source code: `cmake --build build`

6. Open and start editing the writeups/check3.md file. This is the template for your lab writeup and will be included in your submission.

7. Reminder: please make frequent small commits in your local Git repository as you work. If you need help to make sure you're doing this right, please ask a classmate or the teaching staff for help. You can use the `git log` command to see your Git history.

## 2 Checkpoint 3: The TCP Sender

TCP is a protocol that reliably conveys a pair of flow-controlled byte streams (one in each direction) over unreliable datagrams. Two party participate in the TCP connection, and each party is a peer of the other. Each peer acts as both "sender" (of its own outgoing byte-stream) and "receiver" (of an incoming byte-stream) at the same time.

This week, you'll implement the "sender" part of TCP, responsible for reading from a ByteStream (created and written to by some sender-side application), and turning the stream into a sequence of outgoing TCP segments. On the remote side, a TCP receiver transforms those segments (those that arrive—they might not all make it) back into the original byte stream, and sends acknowledgments and window advertisements back to the sender.

It will be your TCPSender's responsibility to:

- Keep track of the receiver's window (receiving incoming TCPReceiverMessages with their acknos and window sizes)
- Fill the window when possible, by reading from the ByteStream, creating new TCP segments (including SYN and FIN flags if needed), and sending them. The sender should keep sending segments until either the window is full or the outbound ByteStream has nothing more to send.
- Keep track of which segments have been sent but not yet acknowledged by the receiver—we call these "outstanding" segments
- Re-send outstanding segments if enough time passes since they were sent, and they haven't been acknowledged yet

⋆**Why am I doing this?** The basic principle is to send whatever the receiver will allow us to send (filling the window), and keep retransmitting until the receiver acknowledges each segment. This is called "automatic repeat request" (ARQ). The sender divides the byte stream up into segments and sends them, as much as the receiver's window allows. Thanks to your work last week, we know that the remote TCP receiver can reconstruct the byte stream as long as it receives each index-tagged byte at least once—no matter the order. The sender's job is to make sure the receiver gets each byte at least once.

### 2.1 How does the TCPSender know if a segment was lost?

Your TCPSender will be sending a bunch of TCPSenderMessages. Each will contain a (possibly empty) substring from the outgoing ByteStream, indexed with a sequence number to indicate its position in the stream, and marked with the SYN flag at the beginning of the stream, and FIN flag at the end.

In addition to sending those segments, the TCPSender also has to keep track of its outstanding segments until the sequence numbers they occupy have been fully acknowledged. Periodically, the owner of the TCPSender will call the TCPSender's tick method, indicating the passage of time. The TCPSender is responsible for looking through its collection of outstanding TCPSenderMessages and deciding if the oldest-sent segment has been outstanding for too long without acknowledgment (that is, without all of its sequence numbers being acknowledged). If so, it needs to be retransmitted (sent again).

Here are the rules for what "outstanding for too long" means. You're going to be implementing this logic, and it's a little detailed, but we don't want you to be worrying about hidden test cases trying to trip you up or treating this like a word problem on the SAT. We'll give you some reasonable unit tests this week, and fuller integration tests in Lab 4 once you've finished the whole TCP implementation. As long as you pass those tests 100% and your implementation is reasonable, you'll be fine.

⋆**Why am I doing this?** The overall goal is to let the sender detect when segments go missing and need to be resent, in a timely manner. The amount of time to wait before resending is important: you don't want the sender to wait too long to resend a segment (because that delays the bytes flowing to the receiving application), but you also don't want it to resend a segment that was going to be acknowledged if the sender had just waited a little longer—that wastes the Internet's precious capacity.

1. Every few milliseconds, your TCPSender's tick method will be called with an argument that tells it how many milliseconds have elapsed since the last time the method was called. Use this to maintain a notion of the total number of milliseconds the TCPSender has been alive. **Please don't try to call any "time" or "clock" functions from the operating system or CPU**—the tick method is your only access to the passage of time. That keeps things deterministic and testable.

2. When the TCPSender is constructed, it's given an argument that tells it the "initial value" of the retransmission timeout (RTO). The RTO is the number of milliseconds to wait before resending an outstanding TCP segment. The value of the RTO will change over time, but the "initial value" stays the same. The starter code saves the "initial value" of the RTO in a member variable called `initial_RTO_ms`.

3. You'll implement the retransmission timer: an alarm that can be started at a certain time, and the alarm goes off (or "expires") once the RTO has elapsed. We emphasize that this notion of time passing comes from the tick method being called—not by getting the actual time of day.

4. Every time a segment containing data (nonzero length in sequence space) is sent (whether it's the first time or a retransmission), if the timer is not running, start it running so that it will expire after RTO milliseconds (for the current value of RTO). By "expire," we mean that the time will run out a certain number of milliseconds in the future.

5. When all outstanding data has been acknowledged, stop the retransmission timer.

6. If tick is called and the retransmission timer has expired:

   a. Retransmit the earliest (lowest sequence number) segment that hasn't been fully acknowledged by the TCP receiver. You'll need to be storing the outstanding segments in some internal data structure that makes it possible to do this.

   b. If the window size is nonzero:

   i. Keep track of the number of consecutive retransmissions, and increment it because you just retransmitted something. Your TCPConnection will use this information to decide if the connection is hopeless (too many consecutive retransmissions in a row) and needs to be aborted.

   ii. Double the value of RTO. This is called "exponential backoff"—it slows down retransmissions on lousy networks to avoid further gumming up the works.

   c. Reset the retransmission timer and start it such that it expires after RTO milliseconds (taking into account that you may have just doubled the value of RTO!).

7. When the receiver gives the sender an ackno that acknowledges the successful receipt of new data (the ackno reflects an absolute sequence number bigger than any previous ackno):

   a. Set the RTO back to its "initial value."

   b. If the sender has any outstanding data, restart the retransmission timer so that it will expire after RTO milliseconds (for the current value of RTO).

   c. Reset the count of "consecutive retransmissions" back to zero.

You might choose to implement the functionality of the retransmission timer in a separate class, but it's up to you. If you do, please add it to the existing files (tcp_sender.hh and tcp_sender.cc).

### 2.2 Implementing the TCP sender

Okay! We've discussed the basic idea of what the TCP sender does (given an outgoing ByteStream, split it up into segments, send them to the receiver, and if they don't get acknowledged soon enough, keep resending them). And we've discussed when to conclude that an outstanding segment was lost and needs to be resend.

Now it's time for the concrete interface that your TCPSender will provide. There are four important events that it needs to handle:

1. `void push(const TransmitFunction& transmit);`

   The TCPSender is asked to fill the window from the outbound byte stream: it reads from the stream and sends as many TCPSenderMessages as possible, as long as there are new bytes to be read and space available in the window. It sends them by calling the provided `transmit()` function on them.

   You'll want to make sure that every TCPSenderMessage you send fits fully inside the receiver's window. Make each individual message as big as possible, but no bigger than the value given by `TCPConfig::MAX_PAYLOAD_SIZE`.

   You can use the `TCPSenderMessage::sequence_length()` method to count the total number of sequence numbers occupied by a segment. Remember that the SYN and FIN flags also occupy a sequence number each, which means that they occupy space in the window.

   ⋆**What should I do if the window size is zero?** If the receiver has announced a window size of zero, the push method should pretend like the window size is one. The sender might end up sending a single byte that gets rejected (and not acknowledged) by the receiver, but this can also provoke the receiver into sending a new acknowledgment segment where it reveals that more space has opened up in its window. Without this, the sender would never learn that it was allowed to start sending again.

   **This is the only special-case behavior your implementation should have for the case of a zero-size window.** The TCPSender shouldn't actually remember a false window size of 1. The special case is only within the push method. Also, N.B. that even if the window size is one (or 20, or 200), the window might still be full. A "full" window is not the same as a "zero-size" window.

2. `void receive(const TCPReceiverMessage& msg);`

   A message is received from the receiver, conveying the new left (= ackno) and right (= ackno + window size) edges of the window. The TCPSender should look through its collection of outstanding segments and remove any that have now been fully acknowledged (the ackno is greater than all of the sequence numbers in the segment).

3. `void tick(uint64_t ms_since_last_tick, const TransmitFunction& transmit);`

   Time has passed — a certain number of milliseconds since the last time this method was called. The sender may need to retransmit an outstanding segment; it can call the `transmit()` function to do this. (Reminder: please don't try to use real-world "clock" or "gettimeofday" functions in your code; the only reference to time passing comes from the `ms_since_last_tick` argument.)

4. `TCPSenderMessage make_empty_message() const;`

   The TCPSender should generate and send a zero-length message with the sequence number set correctly. This is useful if the peer wants to send a TCPReceiverMessage (e.g. because it needs to acknowledge something from the peer's sender) and needs to generate a TCPSenderMessage to go with it.

   Note: a segment like this one, which occupies no sequence numbers, doesn't need to be kept track of as "outstanding" and won't ever be retransmitted.

To complete Checkpoint 3, please review the full interface in src/tcp_sender.hh implement the complete TCPSender public interface in the tcp_sender.hh and tcp_sender.cc files. We expect you'll want to add private methods and member variables, and possibly a helper class.

### 2.3 FAQs and special cases

- What should my TCPSender assume as the receiver's window size before the receive method informs it otherwise?

  One.

- What do I do if an acknowledgment only partially acknowledges some outstanding segment? Should I try to clip off the bytes that got acknowledged?

  A TCP sender could do this, but for purposes of this class, there's no need to get fancy. Treat each segment as fully outstanding until it's been fully acknowledged—all of the sequence numbers it occupies are less than the ackno.

- If I send three individual segments containing "a," "b," and "c," and they never get acknowledged, can I later retransmit them in one big segment that contains "abc"? Or do I have to retransmit each segment individually?

  Again: a TCP sender could do this, but for purposes of this class, no need to get fancy. Just keep track of each outstanding segment individually, and when the retransmission timer expires, send the earliest outstanding segment again.

- Should I store empty segments in my "outstanding" data structure and retransmit them when necessary?

  No—the only segments that should be tracked as outstanding, and possibly retransmitted, are those that convey some data—i.e. that consume some length in sequence space. A segment that occupies no sequence numbers (no SYN, payload, or FIN) doesn't need to be remembered or retransmitted.

- Where can I read if there are more FAQs after this PDF comes out?

  Please check the website (https://cs144.github.io/lab_faq.html) and Ed regularly.

## 3 Development and debugging advice

1. Implement the TCPSender's public interface (and any private methods or functions you'd like) in the file tcp_sender.cc. You may add any private members you like to the TCPSender class in tcp_sender.hh.

2. You can test your code with `cmake --build build --target check3`.

3. Please re-read the section on "using Git" in the Checkpoint 0 document, and remember to keep the code in the Git repository it was distributed in on the main branch. Make small commits, using good commit messages that identify what changed and why.

4. Please work to make your code readable to the CA who will be grading it for style. Use reasonable and clear naming conventions for variables. Use comments to explain complex or subtle pieces of code. Use "defensive programming"—explicitly check preconditions of functions or invariants, and throw an exception if anything is ever wrong. Use modularity in your design—identify common abstractions and behaviors and factor them out when possible. Blocks of repeated code and enormous functions will make it hard to follow your code.

## 4 Hands-on activity

Congratulations—you have made a fully working implementation of the Transmission Control Protocol, implementations of which are arguably the most prevalent computer program on the planet. It's time to take a victory lap! You'll communicate with Linux's TCP and with a lab partner, and then you'll modify your webget (from checkpoint 0) to use your TCP implementation. In your writeup, describe what you did, answer the questions below, and try to find something interesting to discuss!

### 4.1 Experiments within your own VM

We've given you a client program (`./build/apps/tcp_ipv4`) that uses your TCPSender and TCPReceiver to speak TCP-over-IP over the Internet. We've also given you a similar program (`./build/apps/tcp_native`) that uses a Linux TCPSocket.

The big question: Can your TCP implementation (tcp_ipv4) interoperate with Linux's TCP (tcp_native)?

#### 4.1.1 Have Linux's TCP talk to itself

- First, let's do the boring part of making sure Linux's TCP implementation can talk to itself. Run Linux's TCP as a "server" (the peer that waits for an incoming SYN segment), listening on port 9090. On your VM, run: `./build/apps/tcp_native -l 0 9090`

- Next, try using Linux's TCP as the "client": the peer that initiates the connection by sending the first SYN segment to the server. In another terminal window on your VM, run: `./build/apps/tcp_native 169.254.144.1 9090`

- If all goes well, the "server" will print something like `DEBUG: New connection from 169.254.144.1:36568` and the "client" will print something like `DEBUG: Connecting to 169.254.144.1:9090... DEBUG: Successfully connected to 169.254.144.1:9090.`

- Try typing into each window, and you will see the same bytes on the other window.

- To end a stream, type ctrl-D (on a line by itself) to close the ByteStream Writer in that direction. If all goes well, you'll see `Outbound stream...finished` on the terminal where you typed the ctrl-D, and `Inbound stream...finished` on the other terminal. Notice that the other peer can keep sending to the "closed" peer—each direction of the stream can be closed independently, without preventing the other direction from continuing.

- Now end the stream in the second direction by typing ctrl-D (on a line by itself) in the other terminal. If all went well, both programs will quit and bring you back to the command line in both terminals. This indicates the TCP connection has finished in both directions (as discussed in class, Linux will "linger" in the background before reusing one of the port numbers to reduce the chance of a "two general's problem").

#### 4.1.2 Have your TCP talk to Linux's

Repeat the above steps, but connect your TCP implementation to Linux's. First, run `sudo ./scripts/tun.sh start 144` to give your implementation permission to send raw Internet datagrams without needing to be root. You'll have to rerun this command any time you reboot your VM.

Then, rerun the above experiment, replacing one of the programs (the client or server) with tcp_ipv4 (which is your TCP implementation). Does the connection still get established as before, and can each peer still type at the other and have the text appear on the other peer's window? If so, pat yourself on the back (and we'll shake your hand)—you've earned it! If not. . . time to start debugging. You can capture the TCP segments with a command like
`sudo rm -f /tmp/capture.raw; sudo tcpdump -n -w /tmp/capture.raw -i tun144 --print --packet-buffered`;
the resulting `/tmp/capture.raw` file can be visualized in wireshark as before.

After you've typed a little in each direction, try closing one of the ByteStreams and keep typing a little in the other direction. Do both programs quit cleanly after both streams have finished with a ctrl-D? They should—although you may need to see tcp_ipv4 wait a little to reduce the chance of a "two general's problem." When does it need to wait (when it's the first to close or the second to close)? Does this match what was discussed in class?

#### 4.1.3 Try to pass the "one megabyte challenge"

Once it looks like you can have a basic conversation, try sending a file between tcp_ipv4 (your TCP) and tcp_native (Linux's TCP).

To create a random file that's 12345 bytes as "/tmp/big.txt":

```
dd if=/dev/urandom bs=12345 count=1 of=/tmp/big.txt
```

You can choose the direction of transmission—i.e. whether the client or server is the one to send the file.

To have the server send the file as soon as it accepts an incoming connection, redirect standard input to read from the file:

```
./build/apps/tcp_native -l 0 9090 < /tmp/big.txt
```

To have the client receive the file, close off its outgoing stream by redirecting from /dev/null, and redirect standard output to a second file named "/tmp/big-received.txt":

```
</dev/null ./build/apps/tcp_ipv4 169.254.144.1 9090 > /tmp/big-received.txt
```

Or to have the server receive the file:

```
</dev/null ./build/apps/tcp_native -l 0 9090 > /tmp/big-received.txt
```

Or to have the client send the file:

```
./build/apps/tcp_ipv4 169.254.144.1 9090 < /tmp/big.txt
```

To compare two files and make sure they're the same:

```
sha256sum /tmp/big.txt or sha256sum /tmp/big-received.txt
```

If the SHA-256 hashes match, you can be almost certain the file was transmitted correctly.

Try this with a tiny file (12 bytes), then 65534 bytes (a little less than 2^16), then 65537 bytes (a little more than 2^16), then 200000 bytes, then the full megabyte (1000000 bytes). If they all match, give yourself an even bigger pat on the back! If not. . . time to debug (possibly with tcpdump and wireshark as described above).

### 4.2 Reach out and talk to a friend

If everything works above, try communicating with a labmate over the Internet! One of you will run tcp_native as a server, as above. The other will run tcp_ipv4 as the client, connecting to the labmate's address on the CS144 private network (10.144....).

Can you type to each other and successfully end the two streams cleanly? And if so, can you pass the one-megabyte challenge (sending a random 1000000-byte file successfully over the Internet to your labmate's VM, with the SHA-256 hashes matching perfectly on both sides)? If so, congratulations. . . now trade places and try sending the file in the other direction!

What's the biggest file that you have the patience to successfully send to your labmate?

In your lab report, include the sizes of the two files (the output of `ls -l /tmp/big.txt` for the sender and `ls -l /tmp/big-received.txt` for the receiver) and the results of `sha256sum /tmp/big.txt` (on the sender's VM) and `sha256sum /tmp/big-received.txt` (on the receiver's).

### 4.3 webget revisited

Remember your webget.cc that you wrote in Checkpoint 0? It used a TCP implementation (TCPSocket) provided by the Linux kernel. We'd like you to switch it to use your own TCP implementation without changing anything else. We think that all you'll need to do is:

- Replace `#include "socket.hh"` with `#include "tcp_minnow_socket.hh"`.
- Replace the TCPSocket type with CS144TCPSocket.
- At the end of your get_URL() function, add a call to `socket.wait_until_closed()`.

⋆**Why am I doing this?** Normally the Linux kernel takes care of waiting for TCP connections to reach "clean shutdown" (and give up their port reservations) even after user processes have exited. But because your TCP implementation is all in user space, there's nothing else to keep track of the connection state except your program. Adding this call makes the socket wait until the connection is fully closed.

Recompile, and run make check_webget to confirm that you've gone full-circle: you've written a basic Web fetcher on top of your own complete TCP "stack", and it still successfully talks to a real webserver. If you have trouble, try running the program manually: `./build/apps/webget cs144.keithw.org /hasher/xyzzy`. You'll get some debugging output on the terminal that may be helpful.

## 5 Submit

1. In your submission, please only make changes to the .hh and .cc files in the src directory (and apps/webget.cc). Within these files, please feel free to add private members as necessary, but please don't change the public interface of any of the classes.

2. Before handing in any assignment, please run these in order:

   a. Make sure you have committed all of your changes to the Git repository. You can run `git status` to make sure there are no outstanding changes. Remember: make small commits as you code.

   b. `cmake --build build --target format` (to normalize the coding style)

   c. `cmake --build build --target check3` (to make sure the automated tests pass)

   d. Optional: `cmake --build build --target tidy` (suggests improvements to follow good C++ programming practices)

3. Write a report in writeups/check3.md. This file should be a roughly 20-to-50-line document with no more than 80 characters per line to make it easier to read. The report should contain the following sections:

   a. **Program Structure and Design**. Describe the high-level structure and design choices embodied in your code. You do not need to discuss in detail what you inherited from the starter code. Use this as an opportunity to highlight important design aspects and provide greater detail on those areas for your grading TA to understand. You are strongly encouraged to make this writeup as readable as possible by using subheadings and outlines. Please do not simply translate your program into an paragraph of English.

   b. **Alternative design choices** that you considered or ideally evaluated in terms of their performance, difficulty to write (e.g., hours required to produce a bug-free implementation), difficulty to read (e.g., lines of code and their degree of subtlety or nonobvious correctness), and any other dimensions you think are interesting for the reader (or for your own past self before you did this assignment). Include any measurements if applicable.

   c. **Implementation Challenges**. Describe the parts of code that you found most troublesome and explain why. Reflect on how you overcame those challenges and what helped you finally understand the concept that was giving you trouble. How did you attempt to ensure that your code maintained your assumptions, invariants, and preconditions, and in what ways did you find this easy or difficult? How did you debug and test your code?

   d. **Remaining Bugs**. Point out and explain as best you can any bugs (or unhandled edge cases) that remain in the code.

   e. **Hands-on Activity**. Include answers to the questions and some thoughtful commentary on the hands-on activity above.

4. Please also fill in the number of hours the assignment took you and any other comments.

5. Please let the course staff know ASAP of any problems at a lab session, or by posting a question on Ed. Good luck!

## 6 Extra Credit

Extra credit will be rewarded for improvements to the test suite. Add a test case to one of the files in the tests directory (e.g. minnow/tests/recv_connect.cc) that catches a real bug that somebody might reasonably make that isn't already caught by the existing test suite. Please post your test on EdStem (it's okay to make this public) so we can take a look and decide whether to add it to the overall testsuite. (This opportunity will remain open—e.g. if you find a good additional test for the Reassembler in week 10, that's great too.)

# 中文

## 0 概述

建议：在实现之前阅读整个实验文档。

在检查点 0 中，您实现了流控制字节流的抽象（ByteStream）。在检查点 1 和 2 中，您实现了将不可靠数据报中携带的段转换为传入字节流的工具：Reassembler 和 TCPReceiver。

现在，在检查点 3 中，您将实现连接的另一面。TCPSender 是一个将出站字节流转换为将成为不可靠数据报有效载荷的段的工具。最后，在检查点 4 中，您将结合之前实验的工作，创建一个工作的 TCP 实现：包含 TCPSender 和 TCPReceiver 的 TCPPeer。您将使用它与同学以及互联网上的对等方——真实的 TCP 服务器进行通信。

## 1 开始

您的 TCPSender 实现将使用与检查点 0-2 中相同的 Minnow 库，并增加额外的类和测试。开始步骤：

1. 确保您已提交了检查点 1 的所有解决方案。请勿修改 src 目录顶层外的任何文件，或 webget.cc。否则，您可能会在合并检查点 1 起始代码时遇到麻烦。
2. 在实验作业的代码库内，运行 `git fetch --all` 以获取实验作业的最新版本。
3. 通过运行 `git merge origin/check3-startercode` 下载检查点 3 的起始代码。（如果您已将“origin”远程仓库重命名为其他名称，您可能需要在这里使用不同的名称，例如 `git merge upstream/check3-startercode`。）
4. 确保您的构建系统已正确设置：`cmake -S . -B build`
5. 编译源代码：`cmake --build build`
6. 打开并开始编辑 writeups/check3.md 文件。这是您的实验报告模板，将包含在您的提交中。
7. 提醒：请在工作时在您的本地 Git 仓库中频繁进行小型提交。如果您需要帮助确保您正确执行此操作，请向同学或教学人员寻求帮助。您可以使用 `git log` 命令查看您的 Git 历史记录。

## 2 检查点 3：TCP 发送者

TCP 是一种协议，它通过不可靠的数据报可靠地传输一对流控制字节流（每个方向一个）。两个参与方参与 TCP 连接，每个参与方都是对方的对等方。每个对等方同时充当“发送者”（自己的出站字节流）和“接收者”（入站字节流）。

本周，您将实现 TCP 的“发送者”部分，负责从某个发送方应用程序创建并写入的 ByteStream 中读取数据，并将流转换为一系列出站 TCP 段。在远程端，TCP 接收者将这些段（到达的段——它们可能不会全部到达）转换回原始字节流，并向发送者发送确认和窗口通告。

您的 TCPSender 的职责将是：

- 跟踪接收者的窗口（接收包含其确认号和窗口大小的传入 TCPReceiverMessages）
- 尽可能填充窗口，从 ByteStream 读取数据，创建新的 TCP 段（包括需要时的 SYN 和 FIN 标志），并发送它们。发送者应继续发送段，直到窗口已满或出站 ByteStream 没有更多数据要发送。
- 跟踪哪些段已发送但尚未被接收者确认——我们称这些为“未完成”段
- 如果自发送以来经过了足够的时间，并且尚未收到确认，则重新发送未完成的段

⋆**我为什么要这样做？** 基本原则是发送接收者允许我们发送的任何内容（填充窗口），并持续重新传输，直到接收者确认每个段。这称为“自动重复请求”（ARQ）。发送者将字节流分成段并发送它们，尽可能多地利用接收者的窗口。由于您上周的工作，我们知道只要远程 TCP 接收者至少接收到每个索引标记的字节一次，无论顺序如何，它都可以重建字节流。发送者的工作是确保接收者至少接收到每个字节一次。

### 2.1 TCPSender 如何知道段是否丢失？

您的 TCPSender 将发送一系列 TCPSenderMessages。每个消息将包含来自出站 ByteStream 的（可能为空的）子字符串，用序列号索引以指示其在流中的位置，并在流的开始处标记 SYN 标志，在结束处标记 FIN 标志。

除了发送这些段，TCPSender 还必须跟踪其未完成的段，直到它们占用的序列号被完全确认。TCPSender 的拥有者会定期调用 TCPSender 的 tick 方法，指示时间的流逝。TCPSender 负责查看其未完成的 TCPSenderMessages 集合，并决定最早发送的段是否已经未完成太久而没有确认（即，其所有序列号都未被确认）。如果是，则需要重新传输（再次发送）。

以下是“未完成太久”含义的规则。您将实现此逻辑，细节有点复杂，但我们不希望您担心隐藏的测试用例试图绊倒您或将其视为 SAT 上的文字问题。我们本周将为您提供一些合理的单元测试，并在您完成整个 TCP 实现后，在实验 4 中提供更完整的集成测试。只要您 100% 通过这些测试并且您的实现合理，您就没问题。

⋆**我为什么要这样做？** 总体目标是让发送者及时检测到段丢失并需要重新发送。重新发送前等待的时间很重要：您不希望发送者等待太久才重新发送段（因为这会延迟字节流向接收应用程序），但您也不希望它重新发送一个如果发送者再等一会就会被确认的段——这会浪费互联网宝贵的容量。

1. 每隔几毫秒，您的 TCPSender 的 tick 方法将被调用，参数告诉它自上次调用该方法以来经过了多少毫秒。使用此参数维护 TCPSender 存活的总毫秒数的概念。**请不要尝试从操作系统或 CPU 调用任何“时间”或“时钟”函数**——tick 方法是您唯一获取时间流逝的方式。这保持了事物的确定性和可测试性。
2. 当 TCPSender 被构造时，它被赋予一个参数，告诉它重传超时（RTO）的“初始值”。RTO 是重新发送未完成 TCP 段之前等待的毫秒数。RTO 的值会随时间变化，但“初始值”保持不变。起始代码将 RTO 的“初始值”保存在一个名为 `initial_RTO_ms` 的成员变量中。
3. 您将实现重传计时器：一个可以在特定时间启动的警报，一旦 RTO 经过，警报就会触发（或“过期”）。我们强调，这种时间流逝的概念来自 tick 方法被调用——而不是通过获取实际的 daytime。
4. 每次发送包含数据的段（序列空间中非零长度），无论是第一次还是重新传输，如果计时器未运行，则启动计时器，使其在 RTO 毫秒后过期（针对 RTO 的当前值）。所谓“过期”，我们指的是时间将在未来某个毫秒数后用尽。
5. 当所有未完成数据都被确认时，停止重传计时器。
6. 如果调用 tick 并且重传计时器已过期：
   a. 重新传输最早（最低序列号）的尚未被 TCP 接收者完全确认的段。您需要将未完成的段存储在某个内部数据结构中，以便做到这一点。
   b. 如果窗口大小不为零：
   i. 跟踪连续重传的次数，并增加它，因为您刚刚重新传输了一些内容。您的 TCPConnection 将使用此信息来决定连接是否无望（连续重传次数过多）并需要中止。
   ii. 将 RTO 的值加倍。这称为“指数退避”——它在糟糕的网络上减缓重传速度，以避免进一步堵塞。
   c. 重置重传计时器并启动它，使其在 RTO 毫秒后过期（考虑到您可能刚刚将 RTO 的值加倍！）。
7. 当接收者向发送者提供一个确认号，确认成功接收新数据（确认号反映的绝对序列号大于之前的任何确认号）：
   a. 将 RTO 恢复到其“初始值”。
   b. 如果发送者有任何未完成数据，重新启动重传计时器，使其在 RTO 毫秒后过期（针对 RTO 的当前值）。
   c. 将“连续重传”计数重置为零。

您可以选择在单独的类中实现重传计时器的功能，但这取决于您。如果您这样做，请将其添加到现有文件（tcp_sender.hh 和 tcp_sender.cc）中。

### 2.2 实现 TCP 发送者

好的！我们已经讨论了 TCP 发送者所做事情的基本概念（给定一个出站 ByteStream，将其分成段，发送给接收者，如果它们没有很快得到确认，就继续重新发送它们）。我们还讨论了何时得出结论认为未完成的段丢失并需要重新发送。

现在是时候介绍您的 TCPSender 将提供的具体接口了。它需要处理四个重要事件：

1. `void push(const TransmitFunction& transmit);`

   TCPSender 被要求从出站字节流中填充窗口：它从流中读取数据并发送尽可能多的 TCPSenderMessages，只要有新字节可读且窗口中有可用空间。它通过在它们上调用提供的 `transmit()` 函数来发送它们。

   您要确保发送的每个 TCPSenderMessage 完全适合接收者的窗口。使每个单独的消息尽可能大，但不超过 `TCPConfig::MAX_PAYLOAD_SIZE` 给定的值。

   您可以使用 `TCPSenderMessage::sequence_length()` 方法来计算段占用的序列号总数。请记住，SYN 和 FIN 标志也各占用一个序列号，这意味着它们在窗口中占用空间。

   ⋆**如果窗口大小为零，我该怎么办？** 如果接收者宣布窗口大小为零，push 方法应假装窗口大小为 1。发送者可能最终发送一个被接收者拒绝（且不确认）的单个字节，但这也可以促使接收者发送一个新的确认段，显示其窗口中打开了更多空间。如果没有这个，发送者将永远不会知道它被允许再次开始发送。

   **这是您的实现对于窗口大小为零的情况应有的唯一特殊行为。** TCPSender 不应实际记住虚假的窗口大小为 1。特殊情况仅在 push 方法内。另外，请注意，即使窗口大小为 1（或 20，或 200），窗口可能仍然已满。“已满”的窗口与“零大小”的窗口不同。

2. `void receive(const TCPReceiverMessage& msg);`

   从接收者接收到消息，传达窗口的新左边缘（= ackno）和右边缘（= ackno + 窗口大小）。TCPSender 应查看其未完成段的集合，并移除任何已被完全确认的段（ackno 大于段中的所有序列号）。

3. `void tick(uint64_t ms_since_last_tick, const TransmitFunction& transmit);`

   时间已过去——自上次调用此方法以来经过了一定数量的毫秒。发送者可能需要重新传输一个未完成的段；它可以调用 `transmit()` 函数来做到这一点。（提醒：请不要在您的代码中尝试使用现实世界的“时钟”或“gettimeofday”函数；对时间流逝的唯一引用来自 `ms_since_last_tick` 参数。）

4. `TCPSenderMessage make_empty_message() const;`

   TCPSender 应生成并发送一个零长度消息，序列号设置正确。如果对等方想要发送 TCPReceiverMessage（例如，因为它需要确认来自对等方发送者的内容）并需要生成一个与之配套的 TCPSenderMessage，这很有用。

   注意：像这样的段，不占用任何序列号，不需要被跟踪为“未完成”，也不会被重新传输。

要完成检查点 3，请查看 src/tcp_sender.hh 中的完整接口，并在 tcp_sender.hh 和 tcp_sender.cc 文件中实现完整的 TCPSender 公共接口。我们预计您会想要添加私有方法和成员变量，可能还有一个辅助类。

### 2.3 常见问题和特殊情况

- 在 receive 方法告知之前，我的 TCPSender 应假设接收者的窗口大小是多少？

  1。

- 如果确认只部分确认了某个未完成的段，我该怎么办？我应该尝试剪掉已被确认的字节吗？

  TCP 发送者可以这样做，但就本课程而言，不需要过于复杂。直到段被完全确认——它占用的所有序列号都小于 ackno——才将其视为完全未完成。

- 如果我发送了三个包含“a”、“b”和“c”的单独段，并且它们从未被确认，我可以稍后重新传输一个包含“abc”的大段吗？还是必须单独重新传输每个段？

  同样：TCP 发送者可以这样做，但就本课程而言，不需要过于复杂。只需单独跟踪每个未完成的段，当重传计时器过期时，再次发送最早的未完成段。

- 我应该将空段存储在我的“未完成”数据结构中，并在必要时重新传输它们吗？

  不——唯一应该被跟踪为未完成并可能被重新传输的段是那些传递了一些数据的段——即在序列空间中消耗了一些长度。不占用任何序列号的段（没有 SYN、有效载荷或 FIN）不需要被记住或重新传输。

- 如果此 PDF 发布后有更多常见问题，我可以在哪里阅读？

  请定期查看网站（https://cs144.github.io/lab_faq.html）和 Ed。

## 3 开发和调试建议

1. 在 tcp_sender.cc 文件中实现 TCPSender 的公共接口（以及您想要的任何私有方法或函数）。您可以在 tcp_sender.hh 中为 TCPSender 类添加您喜欢的任何私有成员。
2. 您可以使用 `cmake --build build --target check3` 测试您的代码。
3. 请重新阅读检查点 0 文档中关于“使用 Git”的部分，并记住将代码保存在分发的 Git 仓库的主分支上。进行小型提交，使用良好的提交消息来标识更改内容及原因。
4. 请努力使您的代码对将要评分风格的 CA 来说易于阅读。为变量使用合理且清晰的命名约定。使用注释来解释复杂或微妙的代码片段。使用“防御性编程”——明确检查函数或不变量的前提条件，如果有任何错误则抛出异常。在设计中使用模块化——识别常见的抽象和行为，并在可能时将其分解出来。重复代码块和巨大的函数会使您的代码难以理解。

## 4 动手活动

恭喜您——您已经完成了一个完全工作的传输控制协议（TCP）实现，其实现可以说是地球上最普遍的计算机程序。是时候庆祝一下了！您将与 Linux 的 TCP 以及实验室伙伴进行通信，然后修改您在检查点 0 中编写的 webget，使用您的 TCP 实现。在您的报告中，描述您做了什么，回答以下问题，并尝试找到一些有趣的内容进行讨论！

### 4.1 在您自己的虚拟机内进行实验

我们为您提供了一个客户端程序（`./build/apps/tcp_ipv4`），它使用您的 TCPSender 和 TCPReceiver 通过互联网进行 TCP-over-IP 通信。我们还为您提供了一个类似的程序（`./build/apps/tcp_native`），它使用 Linux TCPSocket。

关键问题：您的 TCP 实现（tcp_ipv4）能否与 Linux 的 TCP（tcp_native）互操作？

#### 4.1.1 让 Linux 的 TCP 与自己通信

- 首先，让我们做一些无聊的部分，确保 Linux 的 TCP 实现可以与自己通信。将 Linux 的 TCP 作为“服务器”运行（等待传入 SYN 段的对等方），监听端口 9090。在您的虚拟机上运行：`./build/apps/tcp_native -l 0 9090`
- 接下来，尝试使用 Linux 的 TCP 作为“客户端”：通过向服务器发送第一个 SYN 段来发起连接的对等方。在您的虚拟机上的另一个终端窗口中运行：`./build/apps/tcp_native 169.254.144.1 9090`
- 如果一切顺利，“服务器”将打印类似 `DEBUG: New connection from 169.254.144.1:36568` 的内容，“客户端”将打印类似 `DEBUG: Connecting to 169.254.144.1:9090... DEBUG: Successfully connected to 169.254.144.1:9090.` 的内容。
- 尝试在每个窗口中输入，您将在另一个窗口中看到相同的字节。
- 要结束一个流，输入 ctrl-D（单独一行）以关闭该方向的 ByteStream Writer。如果一切顺利，您将在输入 ctrl-D 的终端上看到 `Outbound stream...finished`，在另一个终端上看到 `Inbound stream...finished`。请注意，另一个对等方可以继续向“关闭”的对等方发送数据——流的每个方向可以独立关闭，而不妨碍另一个方向继续。
- 现在通过在另一个终端中输入 ctrl-D（单独一行）结束第二个方向的流。如果一切顺利，两个程序都将退出并将您带回两个终端的命令行。这表明 TCP 连接在两个方向上都已完成（正如课堂上讨论的，Linux 会在后台“逗留”一段时间，然后再重用其中一个端口号，以减少“两个将军问题”的可能性）。

#### 4.1.2 让您的 TCP 与 Linux 的通信

重复上述步骤，但将您的 TCP 实现连接到 Linux 的。首先，运行 `sudo ./scripts/tun.sh start 144` 以授予您的实现发送原始互联网数据报的权限，而无需成为 root。每次重启虚拟机时，您都必须重新运行此命令。

然后，重新运行上述实验，将其中一个程序（客户端或服务器）替换为 tcp_ipv4（这是您的 TCP 实现）。连接是否仍像以前一样建立，每个对等方是否仍能在对方窗口中输入并显示文本？如果是这样，拍拍自己的背（我们会与您握手）——您 заслужили это！如果没有...是时候开始调试了。您可以使用类似 `sudo rm -f /tmp/capture.raw; sudo tcpdump -n -w /tmp/capture.raw -i tun144 --print --packet-buffered` 的命令捕获 TCP 段；生成的 `/tmp/capture.raw` 文件可以像以前一样在 wireshark 中可视化。

在您在每个方向上输入了一些内容后，尝试关闭其中一个 ByteStream 并在另一个方向上继续输入一些内容。两个程序在两个流都用 ctrl-D 完成后是否干净退出？它们应该会——尽管您可能需要看到 tcp_ipv4 等待一会以减少“两个将军问题”的可能性。它什么时候需要等待（当它是第一个关闭还是第二个关闭时）？这是否与课堂上讨论的内容相符？

#### 4.1.3 尝试通过“百万字节挑战”

一旦看起来您可以进行基本对话，尝试在 tcp_ipv4（您的 TCP）和 tcp_native（Linux 的 TCP）之间发送文件。

要创建一个 12345 字节的随机文件作为 "/tmp/big.txt"：

```
dd if=/dev/urandom bs=12345 count=1 of=/tmp/big.txt
```

您可以选择传输方向——即客户端还是服务器发送文件。

要让服务器在接受传入连接后立即发送文件，将标准输入重定向为从文件读取：

```
./build/apps/tcp_native -l 0 9090 < /tmp/big.txt
```

要让客户端接收文件，通过从 /dev/null 重定向关闭其出站流，并将标准输出重定向到名为 "/tmp/big-received.txt" 的第二个文件：

```
</dev/null ./build/apps/tcp_ipv4 169.254.144.1 9090 > /tmp/big-received.txt
```

或者要让服务器接收文件：

```
</dev/null ./build/apps/tcp_native -l 0 9090 > /tmp/big-received.txt
```

或者要让客户端发送文件：

```
./build/apps/tcp_ipv4 169.254.144.1 9090 < /tmp/big.txt
```

要比较两个文件并确保它们相同：

```
sha256sum /tmp/big.txt or sha256sum /tmp/big-received.txt
```

如果 SHA-256 哈希值匹配，您几乎可以确定文件已正确传输。

尝试使用小文件（12 字节），然后是 65534 字节（略小于 2^16），然后是 65537 字节（略大于 2^16），然后是 200000 字节，最后是完整的百万字节（1000000 字节）。如果它们都匹配，给自己一个更大的拍背！如果没有...是时候调试了（可能如上所述使用 tcpdump 和 wireshark）。

### 4.2 联系并与朋友交谈

如果上面的一切都正常工作，尝试通过互联网与实验室伙伴交流！你们中的一个将作为服务器运行 tcp_native，如上所述。另一个将作为客户端运行 tcp_ipv4，连接到实验室伙伴在 CS144 私有网络上的地址（10.144....）。

您能否互相输入并成功干净地结束两个流？如果是这样，您能否通过百万字节挑战（通过互联网成功向实验室伙伴的虚拟机发送一个随机的 1000000 字节文件，两侧的 SHA-256 哈希值完全匹配）？如果是这样，恭喜您...现在交换角色并尝试在另一个方向发送文件！

您有耐心成功发送给实验室伙伴的最大文件是多少？

在您的实验室报告中，包括两个文件的大小（发送者的 `ls -l /tmp/big.txt` 输出和接收者的 `ls -l /tmp/big-received.txt` 输出）以及 `sha256sum /tmp/big.txt`（在发送者的虚拟机上）和 `sha256sum /tmp/big-received.txt`（在接收者的虚拟机上）的结果。

### 4.3 重新审视 webget

还记得您在检查点 0 中编写的 webget.cc 吗？它使用了 Linux 内核提供的 TCP 实现（TCPSocket）。我们希望您将其切换为使用您自己的 TCP 实现，而不更改其他任何内容。我们认为您需要做的只是：

- 将 `#include "socket.hh"` 替换为 `#include "tcp_minnow_socket.hh"`。
- 将 TCPSocket 类型替换为 CS144TCPSocket。
- 在您的 get_URL() 函数末尾，添加对 `socket.wait_until_closed()` 的调用。

⋆**我为什么要这样做？** 通常 Linux 内核负责等待 TCP 连接达到“干净关闭”（并放弃其端口预留），即使在用户进程退出后也是如此。但因为您的 TCP 实现完全在用户空间中，除了您的程序之外，没有其他东西可以跟踪连接状态。添加此调用使套接字等待直到连接完全关闭。

重新编译，并运行 make check_webget 以确认您已经完成了一个完整的循环：您在自己的完整 TCP“堆栈”之上编写了一个基本的 Web 获取器，它仍然成功地与真实的 Web 服务器通信。如果您遇到问题，尝试手动运行程序：`./build/apps/webget cs144.keithw.org /hasher/xyzzy`。您将在终端上获得一些可能有帮助的调试输出。

## 5 提交

1. 在您的提交中，请仅对 src 目录中的 .hh 和 .cc 文件（以及 apps/webget.cc）进行更改。在这些文件中，请根据需要自由添加私有成员，但请勿更改任何类的公共接口。
2. 在提交任何作业之前，请按顺序运行以下内容：
   a. 确保您已将所有更改提交到 Git 仓库。您可以运行 `git status` 确保没有未完成的更改。请记住：在编码时进行小型提交。
   b. `cmake --build build --target format`（以规范编码风格）
   c. `cmake --build build --target check3`（确保自动化测试通过）
   d. 可选：`cmake --build build --target tidy`（建议改进以遵循良好的 C++ 编程实践）
3. 在 writeups/check3.md 中编写报告。此文件应为大约 20 到 50 行的文档，每行不超过 80 个字符，以便更容易阅读。报告应包含以下部分：
   a. **程序结构和设计**。描述代码中体现的高层结构和设计选择。您不需要详细讨论从起始代码继承的内容。利用这个机会突出重要的设计方面，并为您的评分 TA 提供更多细节以理解。您强烈建议通过使用子标题和大纲使这份报告尽可能易于阅读。请不要简单地将您的程序翻译成一段英文。
   b. **替代设计选择**，您考虑过或理想情况下评估过的，在性能、编写难度（例如，产生无 bug 实现所需的小时数）、阅读难度（例如，代码行数及其微妙或非显而易见的正确性程度）以及您认为对读者（或您自己在完成此作业之前的自己）有趣的任何其他维度方面的内容。如果适用，请包括任何测量结果。
   c. **实现挑战**。描述您发现最麻烦的代码部分并解释原因。反思您是如何克服这些挑战的，以及是什么帮助您最终理解了困扰您的概念。您是如何尝试确保您的代码保持您的假设、不变量和前提条件的，以及您发现这在哪些方面容易或困难？您是如何调试和测试您的代码的？
   d. **剩余错误**。尽可能指出并解释代码中存在的任何错误（或未处理的边缘情况）。
   e. **动手活动**。包括对问题的回答和对上述动手活动的一些深思熟虑的评论。
4. 还请填写作业花费您的小时数和其他评论。
5. 请在实验课程中或通过在 Ed 上发布问题尽快告知课程工作人员任何问题。祝您好运！

## 6 额外学分

将为测试套件的改进提供额外学分。向 tests 目录中的一个文件（例如 minnow/tests/recv_connect.cc）添加一个测试用例，捕获一个有人可能合理犯下的真实错误，而现有测试套件尚未捕获。请在 EdStem 上发布您的测试（公开是可以的），以便我们查看并决定是否将其添加到整体测试套件中。（这个机会将保持开放——例如，如果您在第 10 周为 Reassembler 找到一个好的额外测试，那也很棒。）
