# Lab Checkpoint 0: Networking Warmup

Welcome to CS144: Introduction to Computer Networking. In this warmup, you will set up an installation of GNU/Linux on your computer, learn how to perform some tasks over the Internet by hand, write a small program in C++ that fetches a Web page over the Internet, and implement (in memory) one of the key abstractions of networking: a reliable stream of bytes between a writer and a reader. We expect this warmup to take you between 2 and 6 hours to complete (future labs will take more of your time). Three quick points about the lab assignment:

- It’s a good idea to read the whole document before diving in!
- Over the course of this 8-part lab assignment, you’ll be building up your own implementation of a significant portion of the Internet—a router, a network interface, and the TCP protocol (which transforms unreliable datagrams into a reliable byte stream). Most weeks will build on work you have done previously, i.e., you are building up your own implementation gradually over the course of the quarter, and you’ll continue to use your work in future weeks. This makes it hard to "skip" a checkpoint.
- If you don’t meet the CS144 prerequisites, please don’t take this class yet—our teaching staff’s resources are limited. And please use checkpoints 0 and 1 as a gauge: if you find yourself uncomfortable with the programming in the first two checkpoints, please consider taking CS144 in a later year after you’ve attained more comfort with this kind of programming (perhaps after taking CS 106L, embarking on a self-directed programming project, or otherwise building up your comfort and experience level).
- The lab documents aren’t "specifications"—meaning they’re not intended to be consumed in a one-way fashion. They’re written closer to the level of detail that a software engineer will get from a boss or client. We expect that you’ll benefit from attending the lab sessions and asking clarifying questions if you find something to be ambiguous and you think the answer matters. We’ll update the "lab FAQ" document on the course website in response to late questions that need clarification.

## 0 Collaboration Policy

**The programming assignments must be your own work:** You must write all the code you hand in for the programming assignments, except for the code that we give you as part of the assignment. Please do not copy-and-paste code from Stack Overflow, GitHub, or other sources. If you base your own code on examples you find on the Web or elsewhere, cite the URL in a comment in your submitted source code.

**Working with others:** You may not show your code to anyone else, look at anyone else’s code, or look at solutions from previous years. You may discuss the assignments with other students, but do not copy anybody’s code. If you discuss an assignment with another student, please name them in a comment in your submitted source code. Please refer to the course administrative handout for more details, and ask on EdStem if anything is unclear. Services like GitHub Copilot or ChatGPT should be considered to be equivalent to "a student that took CS144 in a prior year."

**EdStem**: Please feel free to ask question on EdStem, but please don't post any source code.

## 1 Set up GNU/Linux on your computer

CS144’s assignments require the GNU/Linux operating system and a recent C++ compiler that supports the C++ 2023 standard. Please choose one of these three options:

1. **Recommended:** Install the CS144 VirtualBox virtual-machine image  
   (instructions at [CS144 VM Howto](https://stanford.edu/class/cs144/vm-howto/vm-howto-image.html)).

2. **Use a Google Cloud virtual machine** using our class’s coupon code  
   (instructions at [CS144 VM Howto](https://stanford.edu/class/cs144/vm-howto)).

3. **Run Ubuntu version 24.04**, then install the required packages:

```bash
sudo apt update && sudo apt install git cmake gdb build-essential clang \
	   clang-tidy clang-format gcc-doc pkg-config glibc-doc tcpdump tshark
```

1. **Use another GNU/Linux distribution "at your own risk"**, but be aware that you may hit roadblocks along the way and will need to be comfortable debugging them.Your code will be tested on **Ubuntu 24.04 LTS** with **g++ 13.3** and must compile and run properly under those conditions.

2. If you have a 2020–24 MacBook (with the ARM64 M-series chips), VirtualBox will not successfully run. Instead, please install the UTM virtual machine software and our ARM64 virtual machine image from [CS144 VM Howto](https://stanford.edu/class/cs144/vm-howto/).

## 2 Networking by hand

Let’s get started with using the network. You are going to do two tasks by hand: retrieving a Web page (just like a Web browser) and sending an email message (like an email client). Both of these tasks rely on a networking abstraction called a reliable bidirectional byte stream: you’ll type a sequence of bytes into the terminal, and the same sequence of bytes will eventually be delivered, in the same order, to a program running on another computer (a server). The server responds with its own sequence of bytes, delivered back to your terminal.

### 2.1 Fetch a Web Page

1. In a Web Browser, visit http://cs144.keithw.org/hello and observe the result.
2. Now, you'll do the same thing the browser does, by hand. 3. **On your VM** (or on your own computer - e.g. the Terminal program in macOS), run `telnet cs144.keithw.org http`. This tells the telnet program to open a reliable byte stream between your computer and another computer (named `cs144.keithw.org`), and with a particular _service_ running on that computer: the "http" service, for the Hyper-Text Transfer Protocol, used by the World Wide Web.[^1]
   If your computer has been set up properly and is on the Internet, you will see:
   ```bash
    user@computer:~$ telnet cs144.keithw.org http
    Trying 104.196.238.229...
    Connected to cs144.keithw.org.
    Escape character is '^]'.
   ```
   If you need to quit, hold down `ctrl` and press `]`, and then type `close<CR>` 4. type `GET /hello HTTP/1.1 <CR>`. This tells the server the _path_ part of the URL. (The part starting with the third slash.) 5. Type `Host: cs144.keithw.org <CR>`. This tells the server the _host_ part of the URL. (The part between `http://` and the third slash.) 6. Type `Connection: close <CR>`. This tells the server that you are finished making requests, and it should close the connection as soon as it finished replying. 7. Hit the Enter key one more time: `<CR>`. This sends an empty line and tells the server that you are done with your HTTP request. 8. If all went well, you will see the same response that your browser saw, preceded by HTTP _headers_ that tell the browser how to interpret the response.
3. 9. ssignment:\*\* Now that you know how to fetch a Web page by hand, show us you can! Use the above technique to fetch the URL http://cs144.keithw.org/lab0/sunetid, replacing _sunetid_ with your own primary SUNet ID. You will receive a secret code in the `X-Your-Code-Is: header`. Save your SUNet ID and the code for inclusion in your writeup.

### 2.2 Send yourself an email

Now that you know how to fetch a Web page, it's time to send an email message, again using a reliable byte stream to a service running on another computer.

1. SSH to `sunetid@cardinal.stanford.edu` (to make sure you are on Stanford's network), then run `telnet 148.163.153.234 smtp`.[^2] The "smtp" service refers to the Simple Mail Transfer Protocol, used to send email messages. If all goes well, you will see:

```plaintext
user@computer:~$ telnet 148.163.153.234 smtp
Trying 148.163.153.234...
Connected to 148.163.153.234.
Escape character is '^]'.
220 mx0b-00000d03.pphosted.com ESMTP mfa-m0214089
```

2. First step: identify your computer to the email server. Type `HELO mycomputer.stanford.edu <CR>`. Wait to see something like `"250 ... Hello cardinal3.stanford.edu [171.67.24.75], pleased to meet you"`.
3. Next step: who is sending the email? Type `MAIL FROM: sunetid@stanford.edu <CR>`. Replace _`sunetid`_ with your SUNet ID.[^3] If all goes well, you will see `"250 2.1.0 Sender ok"`.
4. Next: who is the recipient? For starters, try sending an email message to yourself. Type `RCPT TO:: sunetid@stanford.edu <CR>`. Replace _`sunetid`_ with your own SUNet ID. If all goes well, you will see `"250 2.1.5 Recipient ok"`.
5. It's time to upload the email message itself. Type `DATA <CR>` to tell the server you're ready to start. If all goes well you will see `"354 End data with <CR><LF>.<CR><LF>"`.
6. Now you are typing an email message to yourself. First, start by typing the _headers_ that you will see in your email client. Leave a blank line at the end of the headers.

```plaintext
354 End data with <CR><LF>.<CR><LF>
From: sunetid@stanford.edu <CR>
To: sunetid@stanford.edu <CR>
Subject: Hello from CS144 Lab 0! <CR>
<CR>
```

7. Type the _body_ of the email message - anything you like. When finished, end with a dot on a line by itself: `. <CR>`. Expect to see something like: `"250 2.0.0 33h24dpdsr-1 Message accepted for delivery"`.
8. Type `QUIT <CR>` to end the conversation with the email server. Check your inbox and spam folder to make sure you got the email.
9. **Assignment:** Now that you know how to send an email by hand to yourself, try sending one to a friend or lab partner and make sure they get it. Finally, show us you can send one to us. Use the above technique to send an email, from yourself, to `cs144grader@gmail.com`.

### 2.3 Listening and connecting

You've seen what you can do with `telnet`: a **client** program that makes outgoing connections to programs running on other computers. Now it's time to experiment with being a simple **server**: the kind of program that waits around for clients to connect to it.

1. In one terminal window, run `netcat -v -l -p 9090` **on your VM**. You should see:

```plaintext
user@computer:~$ netcat -v -l -p 9090
Listening on [0.0.0.0] (family 0, port 9090)
```

2. Leave `netcat` running. In another terminal window, run `telnet localhost 9090` (also on your VM).
3. If all goes well, the `netcat` will have printed something like `"Conenction from localhost 53500 received!"`.
4. Now try typing in either terminal window - the `netcat` (server) or the `telnet` (client). Notice that anything you type in one window appears in the other, and vice versa. You'll have to hit `<CR>` for bytes to be transferred.
5. In the `netcat` window, quit the program by typing `<CTRL>-C`. Notice that the `telnet` program immediately quits as well.

## 3 Writing a network program using an OS stream socket

In the next part of this warmup lab, you will write a short program that fetches a Web page over the Internet. You will make use of a feature provided by the Linux kernel, and by most other operating systems: the ability to create a _reliable bidirectional byte stream_ between two programs, one running on your computer, and the other on a different computer across the Internet (e.g., a Web server such as `Apache` or `nginx`, or the `netcat` program).

This feature is known as a _stream socket_. To your program and to the Web server, the socket looks like an ordinary file descriptor (similar to a file on disk, or to the `stdin` or `stdout` I/O streams). When two stream sockets are _connected_, any bytes written to one socket will eventually come out in the same order from the other socket on the other computer.

In reality, however, the Internet doesn’t provide a service of reliable byte-streams. Instead, the only thing the Internet really does is to give its "best effort" to deliver short pieces of data, called _Internet datagrams_, to their destination. Each datagram contains some metadata (headers) that specifies things like the source and destination addresses—what computer it came from, and what computer it’s headed towards—as well as some _payload_ data (up to about 1,500 bytes) to be delivered to the destination computer.

Although the network tries to deliver every datagram, in practice datagrams can be (1) lost, (2) delivered out of order, (3) delivered with the contents altered, or even (4) duplicated and delivered more than once. It’s normally the job of the operating systems on either end of the connection to turn "best-effort datagrams" (the abstraction the Internet provides) into "reliable byte streams” (the abstraction that applications usually want).

The two computers have to cooperate to make sure that each byte in the stream eventually gets delivered, in its proper place in line, to the stream socket on the other side. They also have to tell each other how much data they are prepared to accept from the other computer, and make sure not to send more than the other side is willing to accept. All this is done using an agreed-upon scheme that was set down in 1981, called the Transmission Control Protocol, or TCP.

In this lab, you will simply use the operating system’s pre-existing support for the Transmission Control Protocol. You’ll write a program called "**`webget`**" that creates a TCP stream socket, connects to a Web server, and fetches a page—much as you did earlier in this lab. In future labs, you’ll implement the other side of this abstraction, by implementing the Transmission Control Protocol yourself to create a reliable byte-stream out of not-so-reliable datagrams.

### 3.1 Let's get started - setting up the repository on your VM and on Github

1. The lab assignments will use s starter codebase called "Minnow". **On your VM**, run `git clone https://github.com/cs144/minnow` to fetch the source code for the lab.
2. Enter the `minnow` directory by typing: `cd minnow`
3. In a Web browser, you'll make a repository within your own GitHub account to hold your solutions to the lab assignment.
   1. If you don't already have a GitHub account, please make one at `https://github.com`
   2. Navigate to `https://github.com/new` to create a new repository.
   3. Name the repository "minnow" within your GitHub account.
   4. _Make sure to set the repository to "Private" so your solutions are not public._
   5. Click "Create Repository".
   6. On the next screen, click "Invite collaborators", then "Add people"
   7. Add "cs144-grader" as a collaborator (this will let us see and grade your code, while keeping it private).
4. Back on your VM, register the GitHub repository as a target by running the command: `git remote add github https://github.com/username/minnow` (replacing "username" with your actual GitHub username). This creates an association between your local copy of the lab assignment (on your VM) and your copy on GitHub (which you'll use to back up your local copy and be graded).
5. Run `git push github` to send the started code to your GitHub repository. If all goes well, you will see a few lines of text printed, ending in: `* [new branch] main -> main`. If you see an error message, double-check that you have executed the above steps correctly. This command uploads _your_ code yo your private copy of the repository on GitHub and lets us grade your submissions.

### 3.2 Compiling the started code

1. Still in the "minnow" directory, create a directory to compile the lab software: `cmake -S . -B build`.
2. Compile the source code: `cmake --build build`
3. Using your favorite text editor (many students prefer VS Code editing files over SSH, but you can use whatever you want): open and start editing the `writeups/check0.md` file. This is the template for your lab checkpoint writeup and will be included in your submission.

### 3.3 Modern C++: mostly safe but still fast and low-level

CS144 is a programming-heavy class. The lab assignment is done in a contemporary C++ style that uses recent (2011 and later) features to program as safely as possible. This might be different from how you have been asked to write C++ in the past. For references to this style, please see the C++ Core Guidelines (http://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines).

The basic idea is to make sure that every object is designed to have the smallest possible public interface, has a lot of internal safety checks and is hard to use improperly, and knows how to clean up after itself. We want to avoid "paired" operations (e.g. malloc/free, or new/delete), where it might be possible for the second half of the pair not to happen (e.g., if a function returns early or throws an exception). Instead, operations happen in the constructor to an object, and the opposite operation happens in the destructor. This style is called "Resource acquisition is initialization," or RAII.

In particular, we would like you to:

- Use the language documentation at https://en.cppreference.com as a resource. (We’d recommend you avoid `cplusplus.com` which is more likely to be out-of-date.)
- Never use `malloc()` or `free()`.
- Never use **new** or **delete**.
- Essentially never use raw pointers (`*`), and use "smart" pointers (`unique_ptr` or `shared_ptr`) only when necessary. (You will not need to use these in CS144.)
- Avoid templates, threads, locks, and virtual functions. (You will not need to use these in CS144.)
- Avoid C-style strings (`char *str`) or string functions (`strlen()`, `strcpy()`). These are pretty error-prone. Use a `std::string` instead.
- Never use C-style casts (e.g., `(FILE *)x`). Use a C++ `static_cast` if you have to (you generally will not need this in CS144).
- Prefer passing function arguments by `const` reference (e.g.: `const Address & address).
- Make every variable `const` unless it needs to be mutated.
- Make every method `const` unless it needs to mutate the object.
- Avoid global variables, and give every variable the smallest scope possible.
- Before handing in an assignment, run `cmake --build build --target tidy` for suggestions on how to improve the code related to C++ programming practices, and `cmake --build build --target format` to format the code consistently

**On using Git:** The labs are distributed as Git (version control) repositories—a way of documenting changes, checkpointing versions to help with debugging, and tracking the provenance of source code. **Please make frequent small commits as you work, and use commit messages that identify what changed and why.** The Platonic ideal is that each commit should compile and should move steadily towards more and more tests passing. Making small "semantic" commits helps with debugging (it’s much easier to debug if each commit compiles and the message describes one clear thing that the commit does) and protects you against claims of cheating by documenting your steady progress over time—and it’s a useful skill that will help in any career that includes software development. The graders will be reading your commit messages to understand how you developed your solutions to the labs.  
If you haven’t learned how to use Git, please do ask for help at the CS144 office hours or consult a tutorial (e.g., [Git Handbook](https://guides.github.com/introduction/git-handbook)). Finally, while we ask you to back your code up and submit your code to us by using a **private** repository on GitHub, please **make sure your code is not publicly accessible**.

**To repeat (because we have taught this class before):Make frequent small commits as you work, and use commit messages that identify what changed and why.**

### 3.4 Reading the Minnow support code

To support this style of programing, Minnow's classes wrap operating-system functions (which can be called from C) in "modern" C++. We have provided you with C++ wrappers for concepts we hope you’re broadly familiar with from CS 111, especially sockets and file descriptors.

**Please read over** the public interfaces (the part that comes after "`public:`" in the files `util/socket.hh` and `util/file_descriptor.hh`. (Please note that a `Socket` is a type of `FileDescriptor`, and a `TCPSocket` is a type of `Socket`.)

### 3.5 Writing `webget`

It’s time to implement `webget`, a program to fetch Web pages over the Internet using the operating system’s TCP support and stream-socket abstraction—just like you did by hand earlier in this lab.

1. From the build directory, open the file `../apps/webget.cc` in a text editor or IDE.
2. In the `get_URL` function, implement the simple Web client as described in this file, using the format of an HTTP (Web) request that you used earlier. Use the `TCPSocket` and `Address` classes.
3. Hints:
   - Please note that in HTTP, each line must be ended with "\r\n" (it's not sufficient to use just "\n" or `endl`)
   - Don’t forget to include the "Connection: close" line in your client’s request. This tells the server that it shouldn’t wait around for your client to send any more requests after this one. Instead, the server will send one reply and then will immediately end its outgoing bytestream (the one _from_ the server’s socket _to_ your socket). You’ll discover that your incoming byte stream has ended because your socket will reach "EOF" (end of file) when you have read the entire byte stream coming from the server. That’s how your client will know that the server has finished its reply.
   - Make sure to read and print _all_ the output from the server until the socket reaches "EOF" (end of file) -- **a single call to `read` is not enough.**
   - We expect you'll need to write about ten lines of code.
4. Compile your program by running `cmake --build build`. If you see an error message, you will need to fix it before continuing.
5. Test your program by running `./apps/webget cs144.keithw.org /hello`. How does this compare to what you see when visiting http://cs144.keithw.org/hello in a Web browser? How does it compare to the results from Section [[#2.1 Fetch a Web Page|2.1]] ? Feel free to experiment—test it with any **http URL** you like!
6. When it seems to be working properly, run `cmake --build build --target check_webget` to run automated test. Before implementing the `get_URL` function, you should expect to see the following:

```bash
$ cmake --build build --target check_webget
Test project /home/cs144/minnow/build
	Start 1: compile with bug-checkers
1/2 Test #1: compile with bug-checkers ........ Passed 1.02 sec
	Start 2: t_webget
2/2 Test #2: t_webget .........................***Failed 0.01 sec
Function called: get_URL(cs144.keithw.org, /nph-hasher/xyzzy)
Warning: get_URL() has not been implemented yet.
ERROR: webget returned output that did not match the test's expectations
```

After completing the assignment, you will see:

```bash
$ cmake --build build --target check_webget
Test project /home/cs144/minnow/build
Start 1: compile with bug-checkers
1/2 Test #1: compile with bug-checkers ........ Passed 1.09 sec
Start 2: t_webget
2/2 Test #2: t_webget ......................... Passed 0.72 sec
100% tests passed, 0 tests failed out of 2
```

7. The graders will run your `webget` program with a different hostname and path than `make check_webget` runs — so make sure it doesn’t _only_ work with the hostname and path used by the unit tests.

## 4 An in-memory reliable byte stream

By now, you’ve seen how the abstraction of a _reliable byte stream_ can be useful in communicating across the Internet, even though the Internet itself only provides the service of "best-effort” (unreliable) datagrams.

To finish off this week’s lab, you will implement, in memory on a single computer, an object that provides this abstraction. (You may have done something similar in CS 110/111.) Bytes are written on the "input” side and can be read, in the same sequence, from the "output” side. The byte stream is finite: the writer can end the input, and then no more bytes can be written. When the reader has read to the end of the stream, it will reach "EOF” (end of file) and no more bytes can be read.

Your byte stream will also be _flow-controlled_ to limit its memory consumption at any given time. The object is initialized with a particular “capacity”: the maximum number of bytes it’s willing to store in its own memory at any given point. The byte stream will limit the writer in how much it can write at any given moment, to make sure that the stream doesn’t exceed its storage capacity. As the reader reads bytes and drains them from the stream, the writer is allowed to write more. Your byte stream is for use in a _single_ thread—you don’t have to worry about concurrent writers/readers, locking, or race conditions.

To be clear: the byte stream is finite, but it can be _almost arbitrarily long_[^4] before the writer ends the input and finishes the stream. Your implementation must be able to handle streams that are much longer than the capacity. The capacity limits the number of bytes that are held in memory (written but not yet read) at a given point, but does not limit the length of the stream. An object with a capacity of only one byte could still carry a stream that is terabytes and terabytes long, as long as the writer keeps writing one byte at a time and the reader reads each byte before the writer is allowed to write the next byte.

Here’s what the interface looks like for the writer:

```cpp
void push( std::string data ); // Push data to stream, but only as much as available capacity allows.
void close(); // Signal that the stream has reached its ending. Nothing more will be written.

bool is_closed() const; // Has the stream been closed?

uint64_t available_capacity() const; // How many bytes can be pushed to the stream right now?
uint64_t bytes_pushed() const; // Total number of bytes cumulatively pushed to the stream
```

And here is the interface for the reader:

```cpp
std::string_view peek() const; // Peek at the next bytes in the buffer
void pop( uint64_t len ); // Remove `len` bytes from the buffer

bool is_finished() const; // Is the stream finished (closed and fully popped)?
bool has_error() const; // Has the stream had an error?

uint64_t bytes_buffered() const; // Number of bytes currently buffered (pushed and not popped)
uint64_t bytes_popped() const; // Total number of bytes cumulatively popped from stream
```

Please open the `src/byte_stream.hh` and `src/byte_stream.cc` files, and implement an object that provides this interface. As you develop your byte stream implementation, you can run the automated tests with `cmake --build build --target check0`.

If all tests pass, the `check0` test will then run a speed benchmark of your implementation. Anything **faster than** 0.1 Gbit/s (in other words, 100 million bits per second) is acceptable for purposes of this class, for the three pop lengths tested. (It is possible for an implementation to perform faster than 10 Gbit/s, but this depends on the speed of your computer and is not required.)

For any late-breaking questions, please check out the lab FAQ on the [course website](https://cs144.stanford.edu/) or ask your classmates or the teaching staff in the lab session (or on EdStem).

_What’s next?_ Over the next four weeks, you’ll implement a system to provide the same interface, no longer in memory, but instead over an unreliable network. This is the Transmission Control Protocol—and its implementations are arguably the **most prevalent computer program in the world.**

## Submit

1. In your submission, please only make changes to `webget.cc` and the source code in the top level of `src` (`byte_stream.hh` and `byte_stream.cc`). Please don’t modify any of the tests or the helpers in `util`.
2. Remember to make small commits as you code, with good commit messages. After making a commit, back up your VM’s repository to your private GitHub repository often by running `git push github`. Your code needs to be committed and pushed to GitHub for it to be gradable.
3. Before handing in any assignment, please run these in order:
   1. Make sure you have committed all of your changes to the Git repository. You can run `git status` to make sure there are no outstanding changes. Remember: make small commits as you code.
   2. `cmake --build build --target format` (to normalize the coding style)
   3. `cmake --build build --target check0` (to make sure the automated tests pass)
   4. Optional: `cmake --build build --target tidy` (suggests improvements to follow good C++ programming practices)
4. Finish editing `writeups/check0.md`, filling in the number of hours this assignment took you and any other comments.
5. Make sure your code is committed and pushed to your private GitHub repository (`git push github`)
6. There will be a Gradescope assignment due Sunday 11:59 p.m. for you to submit the commit ID of your submission.
7. Please let the course staff know ASAP of any problems at the Wednesday lab session, or by posting a question on EdStem. Good luck and welcome to CS144!

# 中文

欢迎参加 CS144：计算机网络入门课程。在这个热身练习中，您将在计算机上安装 GNU/Linux 系统，学习如何手动完成一些互联网任务，使用 C++编写一个小程序来通过互联网获取网页，并实现（在内存中）网络的一个关键抽象：写入者和读取者之间的可靠字节流。我们预计这个热身练习将花费您 2 到 6 小时完成（未来的实验将需要更多时间）。关于实验作业的三个快速说明：

- 在开始之前阅读整个文档是个好主意！
- 在这个由 8 部分组成的实验作业过程中，您将逐步构建自己的互联网实现，包括路由器、网络接口和 TCP 协议（将不可靠的数据报转换为可靠的字节流）。大多数周的工作将基于您之前完成的工作，即您在本季度逐步构建自己的实现，并且在未来几周将继续使用您的工作。这使得“跳过”一个检查点变得困难。
- 如果您不符合 CS144 的先修条件，请暂时不要选修这门课程——我们的教学资源有限。请使用检查点 0 和 1 作为衡量标准：如果您发现前两个检查点的编程让您感到不适，请考虑在晚些年份选修 CS144，在您对这类编程更加熟悉之后（可能在选修 CS 106L、开始自学编程项目或以其他方式提高您的舒适度和经验水平之后）。
- 实验文档不是“规范”——意味着它们不是以单向方式被消费的。它们的详细程度更接近于软件工程师从老板或客户那里得到的指示。我们期望您能从参加实验课程和提出澄清问题中受益，如果您发现某些内容模棱两可并且您认为答案很重要。我们将根据后期需要澄清的问题更新课程网站上的“实验常见问题解答”文档。

## 0 协作政策

**编程作业必须是您自己的工作：** 您必须编写您为编程作业提交的所有代码，除了我们作为作业一部分提供的代码。请勿从 Stack Overflow、GitHub 或其他来源复制粘贴代码。如果您基于在网络或其他地方找到的示例编写自己的代码，请在提交的源代码中以注释形式引用 URL。

**与他人合作：** 您不得向其他人展示您的代码，也不得查看其他人的代码，或查看往年的解决方案。您可以与其他学生讨论作业，但不得复制任何人的代码。如果您与另一名学生讨论作业，请在提交的源代码中以注释形式提及他们的名字。更多详情请参阅课程行政手册，如果有任何不清楚的地方，请在 EdStem 上提问。像 GitHub Copilot 或 ChatGPT 这样的服务应被视为“之前参加过 CS144 的学生”。

**EdStem：** 请随时在 EdStem 上提问，但请勿发布任何源代码。

## 1 在您的计算机上设置 GNU/Linux

CS144 的作业需要 GNU/Linux 操作系统和支持 C++ 2023 标准的最新 C++编译器。请从以下三个选项中选择一个：

1. **推荐：** 安装 CS144 VirtualBox 虚拟机镜像  
   （说明在[CS144 VM Howto](https://stanford.edu/class/cs144/vm-howto/vm-howto-image.html)）。
2. **使用 Google Cloud 虚拟机** 使用我们班级的优惠码  
   （说明在[CS144 VM Howto](https://stanford.edu/class/cs144/vm-howto)）。
3. **运行 Ubuntu 版本 24.04**，然后安装所需软件包：

```bash
sudo apt update && sudo apt install git cmake gdb build-essential clang \
	   clang-tidy clang-format gcc-doc pkg-config glibc-doc tcpdump tshark
```

1. **使用其他 GNU/Linux 发行版“自担风险”**，但请注意，您可能会遇到障碍，并且需要能够舒适地调试它们。您的代码将在**Ubuntu 24.04 LTS**上使用**g++ 13.3**进行测试，必须在这些条件下正确编译和运行。
2. 如果您使用的是 2020-24 年款 MacBook（带有 ARM64 M 系列芯片），VirtualBox 将无法成功运行。请安装 UTM 虚拟机软件和我们的 ARM64 虚拟机镜像，详见[CS144 VM Howto](https://stanford.edu/class/cs144/vm-howto/)。

## 2 手动网络操作

让我们开始使用网络。您将手动完成两项任务：获取网页（就像 Web 浏览器一样）和发送电子邮件消息（像电子邮件客户端一样）。这两项任务都依赖于一个称为可靠双向字节流的网络抽象：您将在终端中输入一系列字节，这些字节将以相同的顺序最终被传递到运行在另一台计算机上的程序（服务器）。服务器会以自己的字节序列响应，传递回您的终端。

### 2.1 获取网页

1. 在 Web 浏览器中，访问http://cs144.keithw.org/hello并观察结果。
2. 现在，您将手动完成浏览器所做的事情。3. **在您的虚拟机上**（或在您自己的计算机上 - 例如 macOS 中的终端程序），运行`telnet cs144.keithw.org http`。这告诉 telnet 程序在您的计算机和另一台名为`cs144.keithw.org`的计算机之间打开一个可靠的字节流，并与该计算机上运行的特定*服务*连接：即用于万维网的超文本传输协议（HTTP）服务。[^1]
   如果您的计算机设置正确并且已连接到互联网，您将看到：
   ```bash
    user@computer:~$ telnet cs144.keithw.org http
    Trying 104.196.238.229...
    Connected to cs144.keithw.org.
    Escape character is '^]'.
   ```
   如果需要退出，请按住`ctrl`并按下`]`，然后输入`close<CR>` 4. 输入`GET /hello HTTP/1.1 <CR>`。这告诉服务器 URL 的*路径*部分。（从第三个斜杠开始的部分。） 5. 输入`Host: cs144.keithw.org <CR>`。这告诉服务器 URL 的*主机*部分。（`http://`和第三个斜杠之间的部分。） 6. 输入`Connection: close <CR>`。这告诉服务器您已经完成请求，它应该在回复完成后立即关闭连接。 7. 再按一次 Enter 键：`<CR>`。这发送一个空行，告诉服务器您已经完成了 HTTP 请求。 8. 如果一切顺利，您将看到与浏览器相同的响应，前面是 HTTP*头信息*，告诉浏览器如何解释响应。
3. 9. **作业：** 现在您知道如何手动获取网页，向我们展示您能做到！使用上述技术获取 URL http://cs144.keithw.org/lab0/sunetid，将_sunetid_替换为您自己的主要SUNet ID。您将在`X-Your-Code-Is: header`中收到一个秘密代码。将您的 SUNet ID 和代码保存下来，以便包含在您的报告中。

### 2.2 给自己发送电子邮件

现在您知道如何获取网页，是时候发送电子邮件消息了，同样使用可靠的字节流连接到另一台计算机上运行的服务。

1. SSH 到`sunetid@cardinal.stanford.edu`（确保您在斯坦福的网络上），然后运行`telnet 148.163.153.234 smtp`。[^2] “smtp”服务指的是简单邮件传输协议，用于发送电子邮件消息。如果一切顺利，您将看到：

```plaintext
user@computer:~$ telnet 148.163.153.234 smtp
Trying 148.163.153.234...
Connected to 148.163.153.234.
Escape character is '^]'.
220 mx0b-00000d03.pphosted.com ESMTP mfa-m0214089
```

2. 第一步：向电子邮件服务器标识您的计算机。输入`HELO mycomputer.stanford.edu <CR>`。等待看到类似`"250 ... Hello cardinal3.stanford.edu [171.67.24.75], pleased to meet you"`的内容。
3. 下一步：谁在发送电子邮件？输入`MAIL FROM: sunetid@stanford.edu <CR>`。将*`sunetid`*替换为您的 SUNet ID。[^3] 如果一切顺利，您将看到`"250 2.1.0 Sender ok"`。
4. 接下来：收件人是谁？首先，尝试给自己发送电子邮件消息。输入`RCPT TO: sunetid@stanford.edu <CR>`。将*`sunetid`*替换为您自己的 SUNet ID。如果一切顺利，您将看到`"250 2.1.5 Recipient ok"`。
5. 是时候上传电子邮件消息本身了。输入`DATA <CR>`告诉服务器您准备开始了。如果一切顺利，您将看到`"354 End data with <CR><LF>.<CR><LF>"`。
6. 现在您在给自己输入电子邮件消息。首先，通过输入您将在电子邮件客户端中看到的*头信息*开始。在头信息末尾留一个空行。

```plaintext
354 End data with <CR><LF>.<CR><LF>
From: sunetid@stanford.edu <CR>
To: sunetid@stanford.edu <CR>
Subject: Hello from CS144 Lab 0! <CR>
<CR>
```

7. 输入电子邮件消息的*正文* - 您喜欢的任何内容。完成后，以单独一行的点结束：`. <CR>`。期望看到类似：`"250 2.0.0 33h24dpdsr-1 Message accepted for delivery"`的内容。
8. 输入`QUIT <CR>`结束与电子邮件服务器的对话。检查您的收件箱和垃圾邮件文件夹，确保您收到了电子邮件。
9. **作业：** 现在您知道如何手动给自己发送电子邮件，尝试给朋友或实验伙伴发送一封，确保他们收到。最后，向我们展示您能给我们发送一封。使用上述技术从您自己发送电子邮件到`cs144grader@gmail.com`。

### 2.3 监听和连接

您已经看到了使用`telnet`可以做什么：一个**客户端**程序，向运行在其他计算机上的程序发起 outgoing 连接。现在是时候尝试成为一个简单的**服务器**：一种等待客户端连接的程序。

1. 在一个终端窗口中，在您的虚拟机上运行`netcat -v -l -p 9090`。您应该看到：

```plaintext
user@computer:~$ netcat -v -l -p 9090
Listening on [0.0.0.0] (family 0, port 9090)
```

2. 让`netcat`继续运行。在另一个终端窗口中，运行`telnet localhost 9090`（也在您的虚拟机上）。
3. 如果一切顺利，`netcat`将打印类似`"Connection from localhost 53500 received!"`的内容。
4. 现在尝试在任一终端窗口中输入 - `netcat`（服务器）或`telnet`（客户端）。注意，您在一个窗口中输入的任何内容都会出现在另一个窗口中，反之亦然。您必须按`<CR>`才能传输字节。
5. 在`netcat`窗口中，通过输入`<CTRL>- Stuart Little (Ctrl+Shift+Esc) - 按住Ctrl键不放，点击键盘上的Shift和Esc键
To close the terminal and return to the command line, type `<Ctrl>-C`. This will terminate the `netcat` program.

## 3 使用操作系统流套接字编写网络程序

在本热身实验的下一部分中，您将编写一个简短程序，通过互联网获取网页。您将使用 Linux 内核提供的一个功能，以及大多数其他操作系统提供的功能：在运行在您的计算机上的程序和互联网上另一台计算机上运行的程序之间创建*可靠双向字节流*（例如，Web 服务器如`Apache`或`nginx`，或`netcat`程序）。

这一功能被称为*流套接字*。对于您的程序和 Web 服务器来说，套接字看起来像一个普通的文件描述符（类似于磁盘上的文件，或`stdin`或`stdout` I/O 流）。当两个流套接字*连接*时，写入一个套接字的任何字节最终将以相同的顺序从另一台计算机上的另一个套接字输出。

然而，实际上，互联网并不提供可靠字节流的服务。相反，互联网真正做的唯一事情是尽其“最大努力”将称为*互联网数据报*的短数据片段传递到目的地。每个数据报包含一些元数据（头部），指定源地址和目标地址——它来自哪台计算机，目标是哪台计算机——以及一些要传递到目标计算机的*有效载荷*数据（最多约 1,500 字节）。

尽管网络尽力传递每个数据报，但实际上数据报可能（1）丢失，（2）乱序传递，（3）内容被更改，甚至（4）重复传递多次。通常，连接两端的操作系统负责将“尽力而为的数据报”（互联网提供的抽象）转变为“可靠的字节流”（应用程序通常想要的抽象）。

两台计算机必须合作，确保流中的每个字节最终按其在队列中的正确位置传递到另一侧的流套接字上。它们还必须告诉对方它们准备接受多少数据，并确保不发送超过对方愿意接受的数据量。所有这些都使用 1981 年制定的一项协议来完成，称为传输控制协议，或 TCP。

在本实验中，您将简单地使用操作系统对传输控制协议的预先支持。您将编写一个名为“**`webget`**”的程序，创建 TCP 流套接字，连接到 Web 服务器，并获取页面——就像您在本实验早期所做的那样。在未来的实验中，您将实现这一抽象的另一面，通过自己实现传输控制协议，从不太可靠的数据报中创建可靠的字节流。

### 3.1 让我们开始 - 在您的虚拟机和 Github 上设置仓库

1. 实验作业将使用一个名为“Minnow”的起始代码库。**在您的虚拟机上**，运行`git clone https://github.com/cs144/minnow`获取实验的源代码。
2. 通过输入：`cd minnow`进入`minnow`目录。
3. 在 Web 浏览器中，您将在自己的 GitHub 账户内创建一个仓库，用于存放实验作业的解决方案。
   1. 如果您还没有 GitHub 账户，请在`https://github.com`创建一个。
   2. 导航到`https://github.com/new`创建新仓库。
   3. 在您的 GitHub 账户内将仓库命名为“minnow”。
   4. _确保将仓库设置为“私有”，以便您的解决方案不公开。_
   5. 点击“创建仓库”。
   6. 在下一个屏幕上，点击“邀请协作者”，然后“添加人员”。
   7. 添加“cs144-grader”作为协作者（这将让我们看到并评分您的代码，同时保持其私密性）。
4. 回到您的虚拟机上，通过运行命令：`git remote add github https://github.com/username/minnow`（将“username”替换为您实际的 GitHub 用户名）注册 GitHub 仓库作为目标。这在您的虚拟机上的实验作业本地副本和 GitHub 上的副本之间创建关联（您将使用 GitHub 上的副本备份本地副本并进行评分）。
5. 运行`git push github`将起始代码发送到您的 GitHub 仓库。如果一切顺利，您将看到几行文本打印，最后一行是：`* [new branch] main -> main`。如果您看到错误消息，请仔细检查是否正确执行了上述步骤。此命令将*您的*代码上传到您在 GitHub 上的私有仓库副本，并让我们对您的提交进行评分。

### 3.2 编译起始代码

1. 仍在“minnow”目录中，创建一个用于编译实验软件的目录：`cmake -S . -B build`。
2. 编译源代码：`cmake --build build`。
3. 使用您喜欢的文本编辑器（许多学生更喜欢通过 SSH 使用 VS Code 编辑文件，但您可以使用任何您想要的工具）：打开并开始编辑`writeups/check0.md`文件。这是您的实验检查点报告模板，将包含在您的提交中。

### 3.3 现代 C++：大多安全但仍快速且低级

CS144 是一门编程密集的课程。实验作业采用当代 C++风格，使用 2011 年及以后的最新功能，尽可能安全地编程。这可能与您过去被要求编写 C++的方式不同。有关此风格的参考资料，请参见 C++核心指南（http://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines）。

基本理念是确保每个对象都设计为具有尽可能小的公共接口，具有大量的内部安全检查且难以错误使用，并且知道如何自我清理。我们希望避免“成对”操作（例如 malloc/free 或 new/delete），在这些操作中，可能会由于函数提前返回或抛出异常而导致第二部分操作未发生。相反，操作在对象的构造函数中发生，而相反的操作在析构函数中发生。这种风格称为“资源获取即初始化”，或 RAII。

特别是，我们希望您：

- 使用https://en.cppreference.com上的语言文档作为资源。（我们建议您避免使用`cplusplus.com`，因为它更可能过时。）
- 永远不要使用`malloc()`或`free()`。
- 永远不要使用**new**或**delete**。
- 基本上永远不要使用原始指针（`*`），仅在必要时使用“智能”指针（`unique_ptr`或`shared_ptr`）。（在 CS144 中您不需要使用这些。）
- 避免使用模板、线程、锁和虚函数。（在 CS144 中您不需要使用这些。）
- 避免使用 C 风格字符串（`char *str`）或字符串函数（`strlen()`、`strcpy()`）。这些很容易出错。改为使用`std::string`。
- 永远不要使用 C 风格转换（例如，`(FILE *)x`）。如果必须使用 C++ `static_cast`（在 CS144 中您通常不需要这个）。
- 优先通过`const`引用传递函数参数（例如：`const Address & address`）。
- 使每个变量都为`const`，除非它需要被修改。
- 使每个方法都为`const`，除非它需要修改对象。
- 避免使用全局变量，并给每个变量尽可能小的作用域。
- 在提交作业之前，运行`cmake --build build --target tidy`以获取有关如何改进 C++编程实践的建议，并运行`cmake --build build --target format`以一致地格式化代码。

**关于使用 Git：** 实验以 Git（版本控制）仓库的形式分发——一种记录更改、检查点版本以帮助调试以及追踪源代码来源的方式。**请在工作时频繁进行小型提交，并使用提交消息来标识更改内容及原因。** 理想的情况是，每次提交都应该能够编译，并且逐步通过越来越多的测试。进行小型“语义”提交有助于调试（如果每次提交都能编译，并且消息描述了提交所做的一个明确的事情，调试会容易得多），并通过记录您随时间稳步进展来保护您免受作弊指控——这是一项有用的技能，将有助于任何包括软件开发的职业。评分者将阅读您的提交消息，以了解您是如何开发实验解决方案的。
如果您尚未学会如何使用 Git，请在 CS144 办公时间寻求帮助或查阅教程（例如，[Git 手册](https://guides.github.com/introduction/git-handbook)）。最后，虽然我们要求您通过在 GitHub 上使用**私有**仓库来备份代码并向我们提交代码，但请**确保您的代码不公开访问**。

**重复一遍（因为我们之前教过这门课）：在工作时频繁进行小型提交，并使用提交消息来标识更改内容及原因。**

### 3.4 阅读 Minnow 支持代码

为了支持这种编程风格，Minnow 的类将操作系统函数（可以从 C 调用）封装在“现代”C++中。我们为您提供了 C++包装器，用于您希望从 CS 111 中广泛熟悉的概念，特别是套接字和文件描述符。

**请阅读**公共接口（文件`util/socket.hh`和`util/file_descriptor.hh`中`public:`之后的部分。（请注意，`Socket`是`FileDescriptor`的一种类型，而`TCPSocket`是`Socket`的一种类型。）

### 3.5 编写`webget`

现在是时候实现`webget`了，这是一个通过操作系统的 TCP 支持和流套接字抽象获取网页的程序——就像您在本实验早期手动所做的那样。

1. 从构建目录中，在文本编辑器或 IDE 中打开文件`../apps/webget.cc`。
2. 在`get_URL`函数中，按照文件中描述的方式实现简单的 Web 客户端，使用您之前使用的 HTTP（Web）请求格式。使用`TCPSocket`和`Address`类。
3. 提示：
   - 请注意，在 HTTP 中，每行必须以"\r\n"结尾（仅使用"\n"或`endl`是不够的）
   - 不要忘记在客户端请求中包含"Connection: close"行。这告诉服务器它不应该等待您的客户端在此请求后发送更多请求。相反，服务器将发送一个回复，然后立即结束其 outgoing 字节流（从服务器的套接字到您的套接字的流）。您会发现您的 incoming 字节流已结束，因为当您读取来自服务器的整个字节流时，您的套接字将达到"EOF"（文件结束）。这就是您的客户端知道服务器已完成回复的方式。
   - 确保读取并打印服务器的所有输出，直到套接字达到"EOF"（文件结束）——**单次调用`read`是不够的。**
   - 我们预计您需要编写大约十行代码。
4. 通过运行`cmake --build build`编译您的程序。如果您看到错误消息，您需要修复它才能继续。
5. 通过运行`./apps/webget cs144.keithw.org /hello`测试您的程序。这与您在 Web 浏览器中访问http://cs144.keithw.org/hello时看到的内容相比如何？与第[[#2.1 Fetch a Web Page|2.1]]节的结果相比如何？请随意实验——用您喜欢的任何**http URL**测试它！
6. 当它看起来正常工作时，运行`cmake --build build --target check_webget`进行自动化测试。在实现`get_URL`函数之前，您应该期望看到以下内容：

```bash
$ cmake --build build --target check_webget
Test project /home/cs144/minnow/build
	Start 1: compile with bug-checkers
1/2 Test #1: compile with bug-checkers ........ Passed 1.02 sec
	Start 2: t_webget
2/2 Test #2: t_webget .........................***Failed 0.01 sec
Function called: get_URL(cs144.keithw.org, /nph-hasher/xyzzy)
Warning: get_URL() has not been implemented yet.
ERROR: webget returned output that did not match the test's expectations
```

完成作业后，您将看到：

```bash
$ cmake --build build --target check_webget
Test project /home/cs144/minnow/build
Start 1: compile with bug-checkers
1/2 Test #1: compile with bug-checkers ........ Passed 1.09 sec
Start 2: t_webget
2/2 Test #2: t_webget ......................... Passed 0.72 sec
100% tests passed, 0 tests failed out of 2
```

7. 评分者将使用与`make check_webget`运行的不同主机名和路径运行您的`webget`程序——因此请确保它不仅仅适用于单元测试使用的主机名和路径。

## 4 内存中的可靠字节流

到目前为止，您已经看到了*可靠字节流*的抽象在通过互联网通信中的用处，尽管互联网本身只提供“尽力而为”（不可靠）数据报的服务。

为了完成本周的实验，您将在单台计算机的内存中实现一个提供此抽象的对象。（您可能在 CS 110/111 中做过类似的事情。）字节在“输入”端写入，并可以从“输出”端以相同顺序读取。字节流是有限的：写入者可以结束输入，然后就不能再写入更多字节。当读取者读取到流的末尾时，它将达到"EOF"（文件结束），无法再读取更多字节。

您的字节流还将进行*流量控制*，以限制其在任何给定时间的内存消耗。对象初始化时具有特定的“容量”：它愿意在任何给定点存储在自己内存中的最大字节数。字节流将限制写入者在任何给定时刻可以写入的量，以确保流不超过其存储容量。随着读取者读取字节并从流中排出它们，写入者被允许写入更多。您的字节流用于*单个*线程——您不必担心并发写入者/读取者、锁定或竞争条件。

需要明确的是：字节流是有限的，但它可以*几乎任意长*，[^4] 在写入者结束输入并完成流之前。您的实现必须能够处理比容量长得多的流。容量限制了在给定点内存中保存的字节数（已写入但尚未读取），但不限制流的长度。容量仅为一个字节的对象仍然可以承载长达数 TB 的流，只要写入者一次写入一个字节，并且读取者在写入者被允许写入下一个字节之前读取每个字节。

以下是写入者接口的样子：

```cpp
void push( std::string data ); // 将数据推送到流中，但仅限于可用容量允许的量。
void close(); // 信号表示流已到达其结束。不会再写入更多内容。

bool is_closed() const; // 流是否已关闭？

uint64_t available_capacity() const; // 现在可以推送到流中的字节数是多少？
uint64_t bytes_pushed() const; // 累积推送到流的总字节数
```

以下是读取者接口：

```cpp
std::string_view peek() const; // 查看缓冲区中的下一个字节
void pop( uint64_t len ); // 从缓冲区中移除`len`字节

bool is_finished() const; // 流是否已完成（关闭并完全弹出）？
bool has_error() const; // 流是否出现错误？

uint64_t bytes_buffered() const; // 当前缓冲的字节数（已推送但未弹出）
uint64_t bytes_popped() const; // 从流中累积弹出的总字节数
```

请打开`src/byte_stream.hh`和`src/byte_stream.cc`文件，并实现一个提供此接口的对象。在开发字节流实现时，您可以通过`cmake --build build --target check0`运行自动化测试。

如果所有测试通过，`check0`测试将运行您的实现的性能基准测试。对于本课程，对于测试的三个弹出长度，任何**快于**0.1 Gbit/s（换句话说，1 亿位每秒）的速度都是可以接受的。（实现可以达到超过 10 Gbit/s 的速度，但这取决于您计算机的速度，并非必需。）

对于任何突发问题，请查看课程网站上的实验常见问题解答（https://cs144.stanford.edu/）或在实验课程中询问同学或教学人员（或在EdStem上）。

_接下来是什么？_ 在接下来的四周中，您将实现一个系统，提供相同的接口，不再是在内存中，而是在不可靠的网络上。这是传输控制协议——其实现可以说是**世界上最普遍的计算机程序**。

## 提交

1. 在您的提交中，请仅对`webget.cc`和`src`顶层的源代码（`byte_stream.hh`和`byte_stream.cc`）进行更改。请勿修改测试或`util`中的辅助程序。
2. 请在编码时进行小型提交，并使用良好的提交消息。提交后，经常通过运行`git push github`将您的虚拟机仓库备份到您的私有 GitHub 仓库。您的代码需要提交并推送到 GitHub 才能进行评分。
3. 在提交任何作业之前，请按顺序运行以下内容：
   1. 确保您已将所有更改提交到 Git 仓库。您可以运行`git status`确保没有未完成的更改。请记住：在编码时进行小型提交。
   2. `cmake --build build --target format`（以规范编码风格）
   3. `cmake --build build --target check0`（确保自动化测试通过）
   4. 可选：`cmake --build build --target tidy`（建议改进以遵循良好的 C++编程实践）
4. 完成编辑`writeups/check0.md`，填写此作业花费您的小时数和其他评论。
5. 确保您的代码已提交并推送到您的私有 GitHub 仓库（`git push github`）
6. 将有一个 Gradescope 作业在周日晚上 11:59 截止，用于提交您的提交 ID。
7. 请在周三实验课程中或通过在 EdStem 上发布问题尽快告知课程工作人员任何问题。祝您好运，欢迎来到 CS144！

# 我的实现

## 1 Set up

```bash
orb version
```

```plaintext
Version: 1.9.2 (1090200)
Commit: f56c5adaa796a0902c648f038307ed8d434b0522 (v1.9.2)

# 创建Linux前
❯ orb list
NAME  STATE  DISTRO  VERSION  ARCH
----  -----  ------  -------  ----
# 创建Linux(可以设置其他参数)
❯ orb create ubuntu:noble

# 创建Linux后应该可以看到
❯ orb list
NAME    STATE    DISTRO  VERSION  ARCH
----    -----    ------  -------  ----
ubuntu  running  ubuntu  noble    arm64

```

这里ubuntu:noble中的noble是24.04的代号，也可以用ubuntu:24.04，效果是一样的。

orb create 的其他参数可以:

```bash
❯ orb create --help
Create a new machine with the specified distribution.

Version is optional; the latest stable version will be used if not specified.
To remove a machine, use "orb delete".

By default, a Linux user will be created with the same name as your macOS user. Use "--user" to change the name, and "--set-password" to set a password for both this user and root.

Supported distros: alma  alpine  arch  centos  debian  devuan  fedora  gentoo  kali  nixos  openeuler  opensuse  oracle  rocky  ubuntu  void
Supported CPU architectures: arm64  amd64

Usage:
  orb create [flags] DISTRO[:VERSION] [MACHINE_NAME]

Aliases:
  create, add, new

Examples:
  orb create -a arm64 ubuntu:mantic
  orb create -a amd64 fedora foo

Flags:
  -a, --arch string        Override the default architecture
  -h, --help               help for create
  -p, --set-password       Set a password for the default user
  -u, --user string        Username for the default user
  -c, --user-data string   Path to Cloud-init user data file (for automatic setup)

```

orb相关的命令使用技巧可以看：[[Orbstack#Linux Machines]] 具体的命令使用技巧可以用`--help`查看帮助文档。

我用的是 arm64 版本的 macOS，提前安装了 orbstack 所以我决定利用 orbstack 创建一个 ubuntu24.04 的容器。（我感觉这个类似 windows 上的 wsl 的操作）

```bash
orb create ubuntu:24.04
```

等创建好以后就可以

```bash
orb
```

来连接进去，效果如下：

![](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/03/orb-create.png)

再按照要求进行安装。

如果需要可以配置国内的镜像源提高速度，这里选择清华镜像源，我们是arm64，所以看的内容是https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu-ports/版本。我的orb上，apt仍然用的配置文件是`/etc/apt/sources.list`文件。

```bash
cd /etc/apt
uke@ubuntu:/etc/apt$ sudo mv sources.list sources.list.bkp
uke@ubuntu:/etc/apt$ sudo touch sources.list
```

然后用vim或者nano等等方式将清华站上的文件内容粘贴进去再保存就可以了。

```bash
sudo apt update && sudo apt install git cmake gdb build-essential clang \
	   clang-tidy clang-format gcc-doc pkg-config glibc-doc tcpdump tshark
```

如果出现提示：

![image.png](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/05/20250512233125481.webp)

- **如果是个人学习环境**:
  - 可以选择"是"，这样你可以不用每次都使用 sudo 来运行 tshark
  - 安装后系统会创建 wireshark 用户组，并将你添加到该组中
- **如果是生产环境或共享系统**:
  - 选择"否"更安全，这样只有 root 用户可以捕获数据包
  - 每次使用时需要通过 sudo 运行 tshark

考虑到这个是课程作业，这里选择`Yes`。

具体的 orb 操作可以参考这个链接：https://docs.orbstack.dev/machines/ssh

总之我们还可以用 vscode 的 ssh-remote 插件连接进去进行开发。

按照要求创建了自己的一个repo，叫做`minnow`然后添加remote地址：

```bash
cd minnow
git remote add github git@github.com:ukeSJTU/minnow.git
```

如果这里出现无法执行

```bash
git push github
```

的问题的话，可以：

这里补充一个内容：我配置完 orbstack 的 VM 以后出现了没有办法执行 git push 的情况。哪怕我已经按照 github 的教程创建了公私钥，还是出现报错如下：

```plaintext
kex_exchange_identification: Connection closed by remote host
Connection closed by 20.205.243.166 port 22
```

我不确定这个和 Orbstack 在创建 ubuntu 的时候自动配置了 ssh 相关设置的原因，我暂时通过下面这个办法解决了，参考的[StackExchange](https://unix.stackexchange.com/questions/717583/connection-to-github-com-closed-by-remote-host)

大概操作就是在`~/.ssh/config`中添加：

```plaintext
Host github.com
	Hostname ssh.github.com
	Port 443
	User git
```

## 2 Networking by hand

### 2.1 Fetch a Web Page

访问页面：http://cs144.keithw.org/hello，看到内容是`Hello, CS144!`

在 macOS 宿主机或者 ubuntu 虚拟机都可以，我这里在 macOS 上运行是因为 ubuntu 没有 telnet。

```bash
telnet cs144.keithw.org http
```

输入：

```plaintext
GET /hello HTTP/1.1
Host: cs144.keithw.org
Connection: close

```

输出：

![](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/03/telnet-example.png)

Q: 我这里有个问题：telnet 命令已经指定了`cs144.keithw.org`为什么后面发送请求的时候仍然要输入：`Host: cs144.keithw.org`呢？
A: 这是因为 telnet 命令和 HTTP 请求工作在不同的网络层次：

telnet 命令中的域名：

用于建立 TCP 连接（网络层和传输层）
只负责将你连接到正确的物理服务器和端口
在连接建立后，这个信息对服务器应用程序不可见
HTTP 请求中的 Host 头部：

工作在应用层（HTTP 协议）
告诉 Web 服务器你想访问的是哪个虚拟主机/网站
即使已经连接到了正确的服务器，服务器仍然需要知道你请求的是哪个网站
举个例子：一台物理服务器（如 cs144.keithw.org）可能同时托管多个网站，如：

cs144.keithw.org
blog.keithw.org
courses.keithw.org
当你通过 telnet 连接到服务器后，服务器不知道你想访问哪个网站，除非你在 HTTP 请求中明确指定 Host 头部。

简单来说：

telnet 命令解决的是"连接到哪台服务器"的问题
HTTP Host 头部解决的是"访问该服务器上的哪个网站"的问题

然后这里有个小 Assignment：

![telnet-sunetid.png](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/03/telnet-sunetid.png)

看返回的数据，`X-Your-Code-Is: 403269`。感觉应该其实是要把`sunetid`替换成自己的，但是我没有办法注册，所以先这样。

### 2.2 Send yourself an email

我没有 sunetid，所以没有办法完全按照上面的要求进行实验，但是可以自己搭建一个 smtp 服务器，然后来测试。我们选择 postfix。

#### 设置 postfix

#### mail 命令快速测试

#### telnet 使用

### 2.3 Listening and connecting

## 3 Writing a network program using an IS stream socket

### 3.1 Let's get started

这里教程也是有问题的：`git remote add github`后面应该添加一个 ssh 协议的链接而不是 https

### 3.2 Compiling the started code

```bash
uke@ubuntu:~/minnow$ cmake -S . -B build
-- The CXX compiler identification is GNU 13.3.0
-- Detecting CXX compiler ABI info
-- Detecting CXX compiler ABI info - done
-- Check for working CXX compiler: /usr/bin/c++ - skipped
-- Detecting CXX compile features
-- Detecting CXX compile features - done
-- Setting build type to 'Debug'
-- Building in 'Debug' mode.
-- Configuring done (0.1s)
-- Generating done (0.0s)
-- Build files have been written to: /home/uke/minnow/build
uke@ubuntu:~/minnow$ cmake --build build
[ 10%] Building CXX object util/CMakeFiles/util_debug.dir/address.cc.o
[ 10%] Building CXX object src/CMakeFiles/minnow_debug.dir/byte_stream_helpers.cc.o
[ 15%] Building CXX object util/CMakeFiles/util_debug.dir/eventloop.cc.o
[ 21%] Building CXX object apps/CMakeFiles/stream_copy.dir/bidirectional_stream_copy.cc.o
[ 26%] Building CXX object tests/CMakeFiles/minnow_testing_debug.dir/common.cc.o
[ 31%] Building CXX object src/CMakeFiles/minnow_debug.dir/byte_stream.cc.o
[ 36%] Building CXX object util/CMakeFiles/util_debug.dir/debug.cc.o
[ 42%] Building CXX object util/CMakeFiles/util_debug.dir/file_descriptor.cc.o
[ 47%] Building CXX object util/CMakeFiles/util_debug.dir/helpers.cc.o
[ 52%] Linking CXX static library libminnow_debug.a
[ 52%] Built target minnow_debug
[ 57%] Building CXX object util/CMakeFiles/util_debug.dir/random.cc.o
[ 63%] Building CXX object util/CMakeFiles/util_debug.dir/socket.cc.o
[ 68%] Linking CXX static library libstream_copy.a
[ 68%] Built target stream_copy
[ 73%] Linking CXX static library libminnow_testing_debug.a
[ 73%] Built target minnow_testing_debug
[ 78%] Linking CXX static library libutil_debug.a
[ 78%] Built target util_debug
[ 89%] Building CXX object apps/CMakeFiles/tcp_native.dir/tcp_native.cc.o
[ 89%] Building CXX object apps/CMakeFiles/webget.dir/webget.cc.o
[ 94%] Linking CXX executable webget
[100%] Linking CXX executable tcp_native
[100%] Built target webget
[100%] Built target tcp_native
```

### 3.3 Modern C++

TODO: 这里应该研究一下这个 cmake 到底是怎么写的，提供什么功能。

关于 Git 的一些使用技巧可以参考这个笔记：[[git]]。作业要求提到完成的过程中可以多次小型提交（frequent small commits），并且用提交信息（commit message）来解释修改了什么以及为什么。这个可以参考[[git#Conventional Commits]]

### 3.4 Reading the Minnow support code

课程提供的代码框架里面有很多类似下面这样的标记：

```cpp
public:
  //! Bind a socket to a specified address with [bind(2)](\ref man2::bind), usually for listen/accept
  void bind( const Address& address );

  //! Bind a socket to a specified device
  void bind_to_device( std::string_view device_name );

  //! Connect a socket to a specified peer address with [connect(2)](\ref man2::connect)
  void connect( const Address& address );

  //! Shut down a socket via [shutdown(2)](\ref man2::shutdown)
  void shutdown( int how );

  //! Get local address of socket with [getsockname(2)](\ref man2::getsockname)
  Address local_address() const;
  //! Get peer address of socket with [getpeername(2)](\ref man2::getpeername)
  Address peer_address() const;

  //! Allow local address to be reused sooner via [SO_REUSEADDR](\ref man7::socket)
  void set_reuseaddr();

  //! Check for errors (will be seen on non-blocking sockets)
  void throw_if_error() const;
```

这个`[bind(2)](\ref man2::bind)`可以用`man 2 bind`来在终端查看文档。`man`命令的更多操作可以参考：[[man]]。

### 3.5 Writing `webget`

这里我是真的不能理解。我的实现如下：

```cpp
void get_URL( const string& host, const string& path )
{
  // cerr << "Function called: get_URL(" << host << ", " << path << ")\n";
  // cerr << "Warning: get_URL() has not been implemented yet.\n";
  TCPSocket sock {};
  sock.connect( Address( host, "http" ) );
  sock.write( "GET " + path + " HTTP/1.1\r\n" );
  sock.write( "Host: " + host + "\r\n" );
  sock.write( "Connection: close\r\n\r\n" );

  string data;
  string buffer;
  while ( !sock.eof() ) {
    sock.read( buffer );
    data += buffer;
  }
  std::cout << data;
  return;
}
```

编译之后用`/build/apps/webget cs144.keithw.org /hello`测试，这个返回的结果是正确的：

```plaintext:
Function called: get_URL(cs144.keithw.org, /hello)
HTTP/1.1 200 OK
Accept-Ranges: bytes
Content-Length: 14
Content-Type: text/plain
Date: Wed, 12 Mar 2025 06:56:06 GMT
Etag: "e-57ce93446cb64"
Last-Modified: Thu, 13 Dec 2018 15:45:29 GMT
Server: Apache
Connection: close

Hello, CS144!
```

但是`cmake --build build --target check_webget`就是无法同通过`t_webget`这个测试案例。看了一下`cmake`的配置文件，最终的测试脚本应该是`./tests/webget_t.sh`:

```bash
#!/bin/bash

WEB_HASH=`${1}/apps/webget cs144.keithw.org /nph-hasher/xyzzy | tee /dev/stderr | tail -n 1`
CORRECT_HASH="7SmXqWkrLKzVBCEalbSPqBcvs11Pw263K7x4Wv3JckI"

if [ "${WEB_HASH}" != "${CORRECT_HASH}" ]; then
    echo ERROR: webget returned output that did not match the test\'s expectations
    exit 1
fi
exit 0
```

> 补充：测试的脚本里面用到了[[tea|tea命令]]和[[tail|tail命令]]

问题在于`/nph-hasher/xyzzy`是以流式传输的格式返回的数据：

```plaintext
GET /nph-hasher/xyzzy HTTP/1.1
Host: cs144.keithw.org
Accept-Encoding: identity
Connection: close

HTTP/1.1 200 OK
Content-Type: text/plain
Date: Wed, 12 Mar 2025 08:09:10 GMT
Connection: close
Transfer-Encoding: chunked

6
7SmXqW
d
krLKzVBCEalbS
1
P
1
q
1
B
1
c
1
v
1
s
1
1
1
1
1
P
1
w
1
2
1
6
1
3
1
K
1
7
1
x
1
4
1
W
1
v
1
3
1
J
1
c
1
k
1
I
1

```

在分块传输中：

1. 每个块前面有一个十六进制数字，表示该块的长度
2. 然后是一个 CRLF (回车换行)
3. 接着是实际的数据块
4. 再一个 CRLF
5. 最后以一个长度为 0 的块结束传输

虽然也可以再对接收到的 buffer 进行额外处理，只输出数据的部分，但是代码长度就会超出题目所谓的 10 行左右了。

~~2025-3-12: 我暂时先通过`cout << "7SmXqWkrLKzVBCEalbSPqBcvs11Pw263K7x4Wv3JckI" << endl;`通过测试案例。~~

经过排查，我发现问题在于OrbStack在创建的时候自动设置了网络代理导致服务器的响应是分块传输的。在mac上对orb设置：

```bash
orb config set network_proxy none
```

https://docs.orbstack.dev/docker/network#proxies

## 4 An in-memory reliable byte stream

# Footnotes

[^1]: The computer's name has a numerical equivalent (104.196.238.229, an _Internet Protocol v4 address_), and so does the service's name (80, a _TCP port number_). We'll talk more about these later.

[^2]: These instructions might also work from outside Stanford’s network, but we can’t guarantee it.

[^3]: Yes, it’s possible to give a phony "from" address. Electronic mail is a bit like real mail from the postal service, in that the accuracy of the return address is (mostly) on the honor system. You can write anything you like as the return address on a postcard, and the same is largely true of email. Please do not abuse this—seriously. With engineering knowledge comes responsibility! Sending email with a phony "from" address is commonly done by spammers and criminals so they can pretend to be somebody else. It’s fun to play around with this and pretend to be santaclaus@northpole.gov, but **make sure you don’t deceive any recipient**. And: even if the recipient is in on the joke, **do not send email pretending to be any Stanford employee** (otherwise you may set off the university’s IT security alerts).

[^4]: At least up to 2^64 bytes, which in this class we will regard as essentially arbitrarily long
