# English

## 0 Overview

Suggestion: read the whole lab document before implementing.

In Checkpoint 0, you implemented the abstraction of a flow-controlled byte stream (`ByteStream`). And in Checkpoint 1, you created a `Reassembler` that accepts a sequence of substrings, all excerpted from the same byte stream, and reassembles them back into the original stream. These modules will prove useful in your TCP implementation, but nothing in them was specific to the details of the Transmission Control Protocol. That changes now. In Checkpoint 2, you will implement the `TCPReceiver`, the part of a TCP implementation that handles the incoming byte stream.

The `TCPReceiver` receives messages from the peer's sender (via the `receive()` method) and turns them into calls to a `Reassembler`, which eventually writes to the incoming `ByteStream`. Applications read from this `ByteStream`, just as you did in Lab 0 by reading from the `TCPSocket`.

Meanwhile, the `TCPReceiver` also generates messages that go back to the peer's sender, via the `send()` method. These "receiver messages" are responsible for telling the sender:

1. the index of the "first unassembled" byte, which is called the "acknowledgment number" or "ackno." This is the first byte that the receiver needs from the sender.
2. the available capacity in the output `ByteStream`. This is called the "window size".

Together, the ackno and window size describe describes the receiver's window: a range of indexes that the TCP sender is allowed to send. Using the window, the receiver can control the flow of incoming data, making the sender limit how much it sends until the receiver is ready for more. We sometimes refer to the ackno as the "left edge" of the window (smallest index the `TCPReceiver` is interested in), and the ackno + window size as the "right edge" (just beyond the largest index the `TCPReceiver` is interested in).

You've already done most of the algorithmic work involved in implementing the `TCPReceiver` when you wrote the `Reassembler` and `ByteStream`; this lab is about wiring those general classes up to the details of TCP. The hardest part will involve thinking about how TCP will represent each byte's place in the stream—known as a "sequence number."

## 1 Getting started

Your implementation of a `TCPReceiver` will use the same Minnow library that you used in Checkpoints 0 and 1, with additional classes and tests. To get started:

1. Make sure you have committed all your solutions to Checkpoint 1. Please don't modify any files outside the top level of the src directory, or webget.cc. You may have trouble merging the Checkpoint 1 starter code otherwise.

2. While inside the repository for the lab assignments, run `git fetch --all` to retrieve the most recent version of the lab assignment.

3. Download the starter code for Checkpoint 2 by running `git merge origin/check2-startercode .`
   (If you have renamed the "origin" remote to be something else, you might need to use a different name here, e.g. `git merge upstream/check2-startercode`.)

4. Make sure your build system is properly set up: `cmake -S . -B build`

   - Note for arm64 (UTM) Mac users: The g++ 13 "sanitizers" (bug checkers) seem to run very slow on arm64. Minnow uses these to run the tests. If you are on an arm64 Mac, please configure cmake to use a different compiler:
     `cmake -S . -B build -DCMAKE_CXX_COMPILER=clang++`

5. Compile the source code: `cmake --build build`

6. Open and start editing the writeups/check2.md file. This is the template for your lab writeup and will be included in your submission.

## 2 Checkpoint 2: The TCP Receiver

TCP is a protocol that reliably conveys a pair of flow-controlled byte streams (one in each direction) over unreliable datagrams. Two parties, or "peers," participate in the TCP connection, and each peer acts as both "sender" (of its own outgoing byte stream) and "receiver" (of an incoming byte stream) at the same time.

This week, you'll implement the "receiver" part of TCP, responsible for receiving messages from the sender, reassembling the byte stream (including its ending, when that occurs), and determining that messages that should be sent back to the sender for acknowledgment and flow control.

⋆**Why am I doing this?** These signals are crucial to TCP's ability to provide the service of a flow-controlled, reliable byte stream over an unreliable datagram network. In TCP, acknowledgment means, "What's the index of the next byte that the receiver needs so it can reassemble more of the ByteStream?" This tells the sender what bytes it needs to send or resend. Flow control means, "What range of indices is the receiver interested and willing to receive?" (a function of its available capacity). This tells the sender how much it's allowed to send.

### 2.1 Translating between 64-bit indexes and 32-bit seqnos

As a warmup, we'll need to implement TCP's way of representing indexes. Last week you created a `Reassembler` that reassembles substrings where each individual byte has a 64-bit stream index, with the first byte in the stream always having index zero. A 64-bit index is big enough that we can treat it as never overflowing.¹ In the TCP headers, however, space is precious, and each byte's index in the stream is represented not with a 64-bit index but with a 32-bit "sequence number," or "seqno." This adds three complexities:

1. **Your implementation needs to plan for 32-bit integers to wrap around.**
   Streams in TCP can be arbitrarily long—there's no limit to the length of a `ByteStream` that can be sent over TCP. But 2³² bytes is only 4 GiB, which is not so big. Once a 32-bit sequence number counts up to 2³² − 1, the next byte in the stream will have the sequence number zero.

2. **TCP sequence numbers start at a random value:** To improve robustness and avoid getting confused by old segments belonging to earlier connections between the same endpoints, TCP tries to make sure sequence numbers can't be guessed and are unlikely to repeat. So the sequence numbers for a stream don't start at zero. The first sequence number in the stream is a random 32-bit number called the Initial Sequence Number (ISN). This is the sequence number that represents the "zero point" or the SYN (beginning of stream). The rest of the sequence numbers behave normally after that: the first byte of data will have the sequence number of the ISN+1 (mod 2³²), the second byte will have the ISN+2 (mod 2³²), etc.

3. **The logical beginning and ending each occupy one sequence number:** In addition to ensuring the receipt of all bytes of data, TCP makes sure that the beginning and ending of the stream are received reliably. Thus, in TCP the SYN (beginning-of-stream) and FIN (end-of-stream) control flags are assigned sequence numbers. Each of these occupies one sequence number. (The sequence number occupied by the SYN flag is the ISN.) Each byte of data in the stream also occupies one sequence number. Keep in mind that SYN and FIN aren't part of the stream itself and aren't "bytes"—they represent the beginning and ending of the byte stream itself.

These sequence numbers (seqnos) are transmitted in the header of each TCP segment. (And, again, there are two streams—one in each direction. Each stream has separate sequence numbers and a different random ISN.) It's also sometimes helpful to talk about the concept of an "absolute sequence number" (which always starts at zero and doesn't wrap), and about a "stream index" (what you've already been using with your `Reassembler`: an index for each byte in the stream, starting at zero).

To make these distinctions concrete, consider the byte stream containing just the three-letter string 'cat'. If the SYN happened to have seqno 2³² − 2, then the seqnos, absolute seqnos, and stream indices of each byte are:

| element        | syn     | c       | a   | t   | fin |
| -------------- | ------- | ------- | --- | --- | --- |
| seqno          | 2³² − 2 | 2³² − 1 | 0   | 1   | 2   |
| absolute seqno | 0       | 1       | 2   | 3   | 4   |
| stream index   |         | 0       | 1   | 2   |     |

The figure shows the three different types of indexing involved in TCP:

| Sequence Numbers    | Absolute Sequence Numbers | Stream Indices          |
| ------------------- | ------------------------- | ----------------------- |
| - Start at the ISN  | - Start at 0              | - Start at 0            |
| - Include SYN/FIN   | - Include SYN/FIN         | - Omit SYN/FIN          |
| - 32 bits, wrapping | - 64 bits, non-wrapping   | - 64 bits, non-wrapping |
| - "seqno"           | - "absolute seqno"        | - "stream index"        |

Converting between absolute sequence numbers and stream indices is easy enough—just add or subtract one. Unfortunately, converting between sequence numbers and absolute sequence numbers is a bit harder, and confusing the two can produce tricky bugs. To prevent these bugs systematically, we'll represent sequence numbers with a custom type: `Wrap32`, and write the conversions between it and absolute sequence numbers (represented with `uint64_t`).

`Wrap32` is an example of a wrapper type: a type that contains an inner type (in this case `uint32_t`) but provides a different set of functions/operators.

We've defined the type for you and provided some helper functions, but you'll implement the conversions in wrapping_integers.cc:

1. `static Wrap32 Wrap32::wrap( uint64_t n, Wrap32 zero_point )`
   Convert absolute seqno → seqno. Given an absolute sequence number (n) and an Initial Sequence Number (zero_point), produce the (relative) sequence number for n.

2. `uint64_t unwrap( Wrap32 zero_point, uint64_t checkpoint ) const`
   Convert seqno → absolute seqno. Given a sequence number (the Wrap32), the Initial Sequence Number (zero_point), and an absolute checkpoint sequence number, find the corresponding absolute sequence number that is closest to the checkpoint.

Note: A checkpoint is required because any given seqno corresponds to many absolute seqnos. E.g. with an ISN of zero, the seqno "17" corresponds to the absolute seqno of 17, but also 2³² + 17, or 2³³ + 17, or 2³³ + 2³² + 17, or 2³⁴ + 17, or 2³⁴ + 2³² + 17, etc. The checkpoint helps resolve the ambiguity: it's an absolute seqno that the user of this class knows is "in the ballpark" of the correct answer. In your TCP implementation, you'll use the first unassembled index as the checkpoint.

Hint: The cleanest/easiest implementation will use the helper functions provided in wrapping_integers.hh. The wrap/unwrap operations should preserve offsets—two seqnos that differ by 17 will correspond to two absolute seqnos that also differ by 17.

Hint #2: We're expecting one line of code for wrap, and less than 10 lines of code for unwrap. If you find yourself implementing a lot more than this, it might be wise to step back and try to think of a different strategy.

You can test your implementation by running the tests: `cmake --build build --target check2` . (Reminder: Mac arm64 users should have configured to use the "clang++" compiler—see above.)

### 2.2 Implementing the TCP receiver

Congratulations on getting the wrapping and unwrapping logic right! We'll shake your hand (or, post-covid, elbow-bump) if this victory happens at the lab session. In the rest of this lab, you'll be implementing the `TCPReceiver`. It will (1) receive messages from its peer's sender and reassemble the `ByteStream` using a `Reassembler`, and (2) send messages back to the peer's sender that contain the acknowledgment number (ackno) and window size. We're expecting this to take about 15 lines of code in total.

First, let's review the format of a TCP "sender message," which contains the information about the `ByteStream`. These messages are sent from a `TCPSender` to its peer's `TCPReceiver`:

```cpp
/** The TCPSenderMessage structure contains five fields (minnow/util/tcp_sender_message.hh):
 *
 * 1) The sequence number (seqno) of the beginning of the segment. If the SYN flag is set,
 *    this is the sequence number of the SYN flag. Otherwise, it's the sequence number of
 *    the beginning of the payload.
 *
 * 2) The SYN flag. If set, this segment is the beginning of the byte stream, and the seqno field
 *    contains the Initial Sequence Number (ISN) -- the zero point.
 *
 * 3) The payload: a substring (possibly empty) of the byte stream.
 *
 * 4) The FIN flag. If set, the payload represents the ending of the byte stream.
 *
 * 5) The RST (reset) flag. If set, the stream has suffered an error and the connection
 *    should be aborted.
 */
struct TCPSenderMessage
{
  Wrap32 seqno { 0 };
  bool SYN {};
  std::string payload {};
  bool FIN {};
  bool RST {};

  // How many sequence numbers does this segment use?
  size_t sequence_length() const { return SYN + payload.size() + FIN; }
};
```

The `TCPReceiver` generates its own messages back to the peer's `TCPSender`:

```cpp
/** The TCPReceiverMessage structure contains three fields (minnow/util/tcp_receiver_message.hh):
 *
 * 1) The acknowledgment number (ackno): the *next* sequence number needed by the TCP Receiver.
 *    This is an optional field that is empty if the TCPReceiver hasn't yet received the
 *    Initial Sequence Number.
 *
 * 2) The window size. This is the number of sequence numbers that the TCP receiver is interested
 *    to receive, starting from the ackno if present. The maximum value is 65,535 (UINT16_MAX from
 *    the <cstdint> header).
 *
 * 3) The RST (reset) flag. If set, the stream has suffered an error and the connection
 *    should be aborted.
 */
struct TCPReceiverMessage
{
  std::optional<Wrap32> ackno {};
  uint16_t window_size {};
  bool RST {};
};
```

Your `TCPReceiver`'s job is to receive one of these kinds of messages and send the other:

```cpp
class TCPReceiver
{
public:
  // Construct with given Reassembler
  explicit TCPReceiver( Reassembler&& reassembler ) : reassembler_( std::move( reassembler ) ) {}

  // The TCPReceiver receives TCPSenderMessages from the peer's TCPSender.
  void receive( TCPSenderMessage message );

  // The TCPReceiver sends TCPReceiverMessages to the peer's TCPSender.
  TCPReceiverMessage send() const;

  // Access the output (only Reader is accessible non-const)
  const Reassembler& reassembler() const { return reassembler_; }
  Reader& reader() { return reassembler_.reader(); }
  const Reader& reader() const { return reassembler_.reader(); }
  const Writer& writer() const { return reassembler_.writer(); }

private:
  Reassembler reassembler_;
};
```

#### 2.2.1 receive()

This is method will be called each time a new segment is received from the peer's sender. This method needs to:

- Set the Initial Sequence Number if necessary. The sequence number of the first-arriving segment that has the SYN flag set is the initial sequence number. You'll want to keep track of that in order to keep converting between 32-bit wrapped seqnos/acknos and their absolute equivalents. (Note that the SYN flag is just one flag in the header. The same message could also carry data or have the FIN flag set.)

- Push any data to the `Reassembler`. If the FIN flag is set in a TCPSegment's header, that means that the last byte of the payload is the last byte of the entire stream. Remember that the `Reassembler` expects stream indexes starting at zero; you will have to unwrap the seqnos to produce these.

#### 2.2.2 send()

This method generates the TCPReceiverMessage that will be sent back to the peer's TCPSender. The message should contain:

1. The ackno. This is the sequence number of the first byte that the `TCPReceiver` doesn't know yet. If the `TCPReceiver` has received at least one byte of the stream (i.e., at least one segment with the SYN flag set), this will be the sequence number of the first missing byte of the stream. If the stream has ended and the `TCPReceiver` has received the complete stream, this will be one beyond the FIN.

2. The window size. This is the number of sequence numbers that the receiver is willing to accept, beyond the ackno. This is limited by two things: the size of the window size field in the TCP header (16 bits, so the maximum value is 65,535), and the amount of space available in the `ByteStream` (the `ByteStream::remaining_capacity()`).

Hint: You'll want to use the `Wrap32::wrap()` function you implemented in the previous step to convert from a 64-bit absolute seqno to a 32-bit relative seqno.

### 2.3 Development and debugging advice

You should implement the `TCPReceiver` in the tcp_receiver.cc file. You can test your code by running the tests: `cmake --build build --target check2`. We've provided a set of tests that check your implementation against the requirements.

As you're developing, we recommend that you use Git to save versions of your code as you make progress. This will help you recover if you make a mistake. You can use `git add` to stage changes, `git commit` to save them, and `git checkout` to switch between different versions of your code. Try to make small, incremental commits as you work.

We recommend using a "modern C++" style, where you avoid raw pointers and explicit memory management, and instead use smart pointers, references, and standard library containers and algorithms. You should also use meaningful variable names and write clear comments to explain your code.

# 中文

## 0 概述

建议：在实现之前阅读整个实验文档。

在检查点 0 中，你实现了流控制字节流的抽象（`ByteStream`）。在检查点 1 中，你创建了一个`Reassembler`，它接受一系列子字符串，所有这些子字符串都摘自同一字节流，并将它们重新组装回原始流。这些模块在你的 TCP 实现中将证明是有用的，但它们中没有任何内容是特定于传输控制协议的细节。现在这一切都改变了。在检查点 2 中，你将实现`TCPReceiver`，这是 TCP 实现的一部分，用于处理传入的字节流。

`TCPReceiver`通过`receive()`方法接收来自对等方发送者的消息，并将它们转换为对`Reassembler`的调用，最终写入传入的`ByteStream`。应用程序从这个`ByteStream`读取数据，就像你在实验 0 中通过从`TCPSocket`读取所做的那样。

同时，`TCPReceiver`还通过`send()`方法生成返回给对等方发送者的消息。这些"接收者消息"负责告诉发送者：

1. "第一个未组装"字节的索引，称为"确认号"或"ackno"。这是接收者需要从发送者那里获取的第一个字节。
2. 输出`ByteStream`中的可用容量。这被称为"窗口大小"。

确认号和窗口大小一起描述了接收者的窗口：TCP 发送者被允许发送的索引范围。使用窗口，接收者可以控制传入数据的流量，使发送者限制发送的数量，直到接收者准备好接收更多。我们有时将 ackno 称为窗口的"左边缘"（`TCPReceiver`感兴趣的最小索引），将 ackno + window size 称为"右边缘"（刚好超过`TCPReceiver`感兴趣的最大索引）。

当你编写`Reassembler`和`ByteStream`时，你已经完成了实现`TCPReceiver`所涉及的大部分算法工作；这个实验是关于将这些通用类连接到 TCP 的细节。最困难的部分将涉及思考 TCP 如何表示流中每个字节的位置——即"序列号"。

## 1 开始

你的`TCPReceiver`实现将使用与检查点 0 和 1 中相同的 Minnow 库，并增加了额外的类和测试。开始步骤：

1. 确保你已经提交了检查点 1 的所有解决方案。请不要修改 src 目录顶层之外的任何文件，或 webget.cc。否则，你可能会在合并检查点 1 的起始代码时遇到麻烦。

2. 在实验作业的代码库内，运行`git fetch --all`以获取实验作业的最新版本。

3. 通过运行`git merge origin/check2-startercode .`下载检查点 2 的起始代码。
   （如果你已将"origin"远程仓库重命名为其他名称，你可能需要在这里使用不同的名称，例如`git merge upstream/check2-startercode`。）

4. 确保你的构建系统已正确设置：`cmake -S . -B build`

   - arm64 (UTM) Mac 用户注意：g++ 13 的"sanitizers"（错误检查器）在 arm64 上运行似乎非常慢。Minnow 使用这些来运行测试。如果你使用的是 arm64 Mac，请配置 cmake 使用不同的编译器：
     `cmake -S . -B build -DCMAKE_CXX_COMPILER=clang++`

5. 编译源代码：`cmake --build build`

6. 打开并开始编辑 writeups/check2.md 文件。这是你的实验报告模板，将包含在你的提交中。

## 2 检查点 2：TCP 接收器

TCP 是一种协议，它可靠地通过不可靠的数据报传输一对流控制字节流（每个方向一个）。两个参与方，或称"对等方"，参与 TCP 连接，每个对等方同时充当"发送者"（自己的出站字节流）和"接收者"（入站字节流）。

本周，你将实现 TCP 的"接收者"部分，负责接收来自发送者的消息，重新组装字节流（包括在发生时的结束），并确定应该发送回发送者的消息，用于确认和流量控制。

⋆**为什么我要做这个？** 这些信号对于 TCP 能够在不可靠的数据报网络上提供流控制、可靠的字节流服务至关重要。在 TCP 中，确认意味着"接收者需要的下一个字节的索引是什么，以便它可以重新组装更多的 ByteStream？"这告诉发送者它需要发送或重新发送哪些字节。流量控制意味着"接收者对哪些索引范围感兴趣并愿意接收？"（这是其可用容量的函数）。这告诉发送者它被允许发送多少。

### 2.1 在 64 位索引和 32 位序列号之间转换

作为热身，我们需要实现 TCP 表示索引的方式。上周你创建了一个`Reassembler`，它重新组装子字符串，其中每个单独的字节都有一个 64 位流索引，流中的第一个字节始终具有索引零。64 位索引足够大，我们可以将其视为永不溢出。¹ 然而，在 TCP 头部中，空间是宝贵的，流中每个字节的索引不是用 64 位索引表示，而是用 32 位"序列号"或"seqno"表示。这增加了三个复杂性：

1. **你的实现需要计划 32 位整数的环绕。**
   TCP 中的流可以任意长——通过 TCP 发送的`ByteStream`的长度没有限制。但 2³² 字节只有 4 GiB，这并不是很大。一旦 32 位序列号计数到 2³² − 1，流中的下一个字节将具有序列号零。

2. **TCP 序列号从随机值开始：** 为了提高健壮性并避免被同一端点之间早期连接的旧段混淆，TCP 试图确保序列号不能被猜测并且不太可能重复。因此，流的序列号不从零开始。流中的第一个序列号是一个称为初始序列号（ISN）的随机 32 位数字。这是表示"零点"或 SYN（流的开始）的序列号。此后，其余序列号正常行为：第一个数据字节将具有 ISN+1（模 2³²）的序列号，第二个字节将具有 ISN+2（模 2³²）的序列号，等等。

3. **逻辑开始和结束各占用一个序列号：** 除了确保接收所有数据字节外，TCP 还确保流的开始和结束都可靠地接收。因此，在 TCP 中，SYN（流的开始）和 FIN（流的结束）控制标志被分配序列号。这些每个都占用一个序列号。（SYN 标志占用的序列号是 ISN。）流中的每个数据字节也占用一个序列号。请记住，SYN 和 FIN 不是流本身的一部分，也不是"字节"——它们代表字节流本身的开始和结束。

这些序列号（seqnos）在每个 TCP 段的头部中传输。（再次，有两个流——每个方向一个。每个流有单独的序列号和不同的随机 ISN。）有时谈论"绝对序列号"的概念（总是从零开始且不环绕）以及"流索引"（你已经在`Reassembler`中使用的：流中每个字节的索引，从零开始）也很有帮助。

为了使这些区别具体化，考虑只包含三个字母字符串'cat'的字节流。如果 SYN 碰巧有 seqno 2³² − 2，那么每个字节的 seqnos、绝对 seqnos 和流索引是：

| 元素       | syn     | c       | a   | t   | fin |
| ---------- | ------- | ------- | --- | --- | --- |
| seqno      | 2³² − 2 | 2³² − 1 | 0   | 1   | 2   |
| 绝对 seqno | 0       | 1       | 2   | 3   | 4   |
| 流索引     |         | 0       | 1   | 2   |     |

该图显示了 TCP 中涉及的三种不同类型的索引：

| 序列号         | 绝对序列号         | 流索引           |
| -------------- | ------------------ | ---------------- |
| - 从 ISN 开始  | - 从 0 开始        | - 从 0 开始      |
| - 包括 SYN/FIN | - 包括 SYN/FIN     | - 省略 SYN/FIN   |
| - 32 位，环绕  | - 64 位，非环绕    | - 64 位，非环绕  |
| - "seqno"      | - "absolute seqno" | - "stream index" |

在绝对序列号和流索引之间转换很简单——只需加上或减去一。不幸的是，在序列号和绝对序列号之间转换有点困难，混淆这两者可能会产生棘手的错误。为了系统地防止这些错误，我们将使用自定义类型`Wrap32`表示序列号，并编写它与绝对序列号（用`uint64_t`表示）之间的转换。

`Wrap32`是一个包装类型的例子：一个包含内部类型（在这种情况下是`uint32_t`）但提供不同函数/操作符集的类型。

我们已经为你定义了类型并提供了一些辅助函数，但你将在 wrapping_integers.cc 中实现转换：

1. `static Wrap32 Wrap32::wrap( uint64_t n, Wrap32 zero_point )`
   转换绝对 seqno → seqno。给定一个绝对序列号（n）和一个初始序列号（zero_point），为 n 生成（相对）序列号。

2. `uint64_t unwrap( Wrap32 zero_point, uint64_t checkpoint ) const`
   转换 seqno → 绝对 seqno。给定一个序列号（Wrap32），初始序列号（zero_point）和一个绝对检查点序列号，找到最接近检查点的相应绝对序列号。

注意：需要检查点是因为任何给定的 seqno 对应多个绝对 seqnos。例如，对于 ISN 为零，seqno"17"对应的绝对 seqno 为 17，但也可以是 2³² + 17，或 2³³ + 17，或 2³³ + 2³² + 17，或 2³⁴ + 17，或 2³⁴ + 2³² + 17 等。检查点有助于解决歧义：它是该类用户知道"在正确答案范围内"的绝对 seqno。在你的 TCP 实现中，你将使用第一个未组装的索引作为检查点。

提示：最干净/最容易的实现将使用 wrapping_integers.hh 中提供的辅助函数。wrap/unwrap 操作应该保留偏移量——相差 17 的两个 seqnos 将对应于也相差 17 的两个绝对 seqnos。

提示#2：我们期望 wrap 的代码只有一行，unwrap 的代码少于 10 行。如果你发现自己实现的代码比这多得多，最好退一步，尝试思考不同的策略。

你可以通过运行测试来测试你的实现：`cmake --build build --target check2`。（提醒：Mac arm64 用户应该已经配置为使用"clang++"编译器——见上文。）

### 2.2 实现 TCP 接收器

恭喜你正确实现了包装和解包逻辑！如果这个胜利发生在实验课上，我们会与你握手（或者，后疫情时代，碰肘）。在本实验的剩余部分，你将实现`TCPReceiver`。它将（1）接收来自对等方发送者的消息，并使用`Reassembler`重新组装`ByteStream`，以及（2）向对等方发送者发送包含确认号（ackno）和窗口大小的消息。我们预计这总共需要大约 15 行代码。

首先，让我们回顾一下 TCP"发送者消息"的格式，它包含有关`ByteStream`的信息。这些消息从`TCPSender`发送到其对等方的`TCPReceiver`：

```cpp
/** TCPSenderMessage结构包含五个字段（minnow/util/tcp_sender_message.hh）：
 *
 * 1) 段开始的序列号（seqno）。如果设置了SYN标志，
 *    这是SYN标志的序列号。否则，它是有效负载开始的序列号。
 *
 * 2) SYN标志。如果设置，此段是字节流的开始，seqno字段
 *    包含初始序列号（ISN）——零点。
 *
 * 3) 有效负载：字节流的子字符串（可能为空）。
 *
 * 4) FIN标志。如果设置，有效负载表示字节流的结束。
 *
 * 5) RST（重置）标志。如果设置，流已遭受错误，连接
 *    应该中止。
 */
struct TCPSenderMessage
{
  Wrap32 seqno { 0 };
  bool SYN {};
  std::string payload {};
  bool FIN {};
  bool RST {};

  // 此段使用多少个序列号？
  size_t sequence_length() const { return SYN + payload.size() + FIN; }
};
```

`TCPReceiver`生成自己的消息回送给对等方的`TCPSender`：

```cpp
/** TCPReceiverMessage结构包含三个字段（minnow/util/tcp_receiver_message.hh）：
 *
 * 1) 确认号（ackno）：TCP接收器需要的*下一个*序列号。
 *    这是一个可选字段，如果TCPReceiver尚未收到
 *    初始序列号，则为空。
 *
 * 2) 窗口大小。这是TCP接收器感兴趣接收的序列号数量，
 *    从ackno开始（如果存在）。最大值为65,535（来自
 *    <cstdint>头文件的UINT16_MAX）。
 *
 * 3) RST（重置）标志。如果设置，流已遭受错误，连接
 *    应该中止。
 */
struct TCPReceiverMessage
{
  std::optional<Wrap32> ackno {};
  uint16_t window_size {};
  bool RST {};
};
```

你的`TCPReceiver`的工作是接收这些类型的消息之一并发送另一个：

```cpp
class TCPReceiver
{
public:
  // 使用给定的Reassembler构造
  explicit TCPReceiver( Reassembler&& reassembler ) : reassembler_( std::move( reassembler ) ) {}

  // TCPReceiver从对等方的TCPSender接收TCPSenderMessages。
  void receive( TCPSenderMessage message );

  // TCPReceiver向对等方的TCPSender发送TCPReceiverMessages。
  TCPReceiverMessage send() const;

  // 访问输出（只有Reader可以非const访问）
  const Reassembler& reassembler() const { return reassembler_; }
  Reader& reader() { return reassembler_.reader(); }
  const Reader& reader() const { return reassembler_.reader(); }
  const Writer& writer() const { return reassembler_.writer(); }

private:
  Reassembler reassembler_;
};
```

#### 2.2.1 receive()

每次从对等方的发送者接收到新段时，都会调用此方法。此方法需要：

- 如有必要，设置初始序列号。设置了 SYN 标志的第一个到达段的序列号是初始序列号。你需要跟踪它，以便继续在 32 位包装的 seqnos/acknos 和它们的绝对等效项之间进行转换。（注意，SYN 标志只是头部中的一个标志。同一消息也可能携带数据或设置 FIN 标志。）

- 将任何数据推送到`Reassembler`。如果在 TCPSegment 的头部中设置了 FIN 标志，这意味着有效负载的最后一个字节是整个流的最后一个字节。请记住，`Reassembler`期望流索引从零开始；你将不得不解包 seqnos 以生成这些索引。

#### 2.2.2 send()

此方法生成将发送回对等方 TCPSender 的 TCPReceiverMessage。该消息应包含：

1. 确认号（ackno）。这是`TCPReceiver`尚不知道的第一个字节的序列号。如果`TCPReceiver`已经接收到流的至少一个字节（即，至少一个设置了 SYN 标志的段），这将是流中第一个缺失字节的序列号。如果流已结束且`TCPReceiver`已接收到完整的流，这将是 FIN 之后的一个位置。

2. 窗口大小。这是接收器愿意接受的序列号数量，超出 ackno。这受到两个因素的限制：TCP 头部中窗口大小字段的大小（16 位，所以最大值是 65,535），以及`ByteStream`中可用的空间量（`ByteStream::remaining_capacity()`）。

提示：你需要使用在上一步中实现的`Wrap32::wrap()`函数，将 64 位绝对 seqno 转换为 32 位相对 seqno。

### 2.3 开发和调试建议

你应该在 tcp_receiver.cc 文件中实现`TCPReceiver`。你可以通过运行测试来测试你的代码：`cmake --build build --target check2`。我们提供了一组测试，以根据需求检查你的实现。

在开发过程中，我们建议你使用 Git 保存代码的版本，以便在取得进展时进行保存。这将帮助你在犯错时恢复。你可以使用`git add`暂存更改，`git commit`保存它们，以及`git checkout`在代码的不同版本之间切换。尽量在工作时进行小的、增量式的提交。

我们建议使用"现代 C++"风格，避免原始指针和显式内存管理，而是使用智能指针、引用以及标准库容器和算法。你还应该使用有意义的变量名并编写清晰的注释来解释你的代码。

# 我的实现
