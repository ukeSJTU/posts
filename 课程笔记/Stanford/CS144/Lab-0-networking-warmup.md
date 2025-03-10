原本lab0要求文档在这里：[lab-check0](https://cs144.github.io/assignments/check0.pdf),先摘录调整为markdown格式如下，同时提供中文版本翻译，最后是我的实现部分。

# English

Welcome to CS144: Introduction to Computer Networking. In this warmup, you will set up an installation of GNU/Linux on your computer, learn how to perform some tasks over the Internet by hand, write a small program in C++ that fetches a Web page over the Internet, and implement (in memory) one of the key abstractions of networking: a reliable stream of bytes between a writer and a reader. We expect this warmup to take you between 2 and 6 hours to complete (future labs will take more of your time). Three quick points about the lab assignment:

- It’s a good idea to read the whole document before diving in!
- Over the course of this 8-part lab assignment, you’ll be building up your own implementation of a significant portion of the Internet—a router, a network interface, and the TCP protocol (which transforms unreliable datagrams into a reliable byte stream). Most weeks will build on work you have done previously, i.e., you are building up your own implementation gradually over the course of the quarter, and you’ll continue to use your work in future weeks. This makes it hard to "skip" a checkpoint.
- If you don’t meet the CS144 prerequisites, please don’t take this class yet—our teaching staff’s resources are limited. And please use checkpoints 0 and 1 as a gauge: if you find yourself uncomfortable with the programming in the first two checkpoints, please consider taking CS144 in a later year after you’ve attained more comfort with this kind of programming (perhaps after taking CS 106L, embarking on a self-directed programming project, or otherwise building up your comfort and experience level).
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
2. Now, you'll do the same thing the browser does, by hand.
   1. **On your VM** (or on your own computer - e.g. the Terminal program in macOS), run `telnet cs144.keithw.org http`. This tells the telnet program to open a reliable byte stream between your computer and another computer (named `cs144.keithw.org`), and with a particular _service_ running on that computer: the "http" service, for the Hyper-Text Transfer Protocol, used by the World Wide Web.
      If your computer has been set up properly and is on the Internet, you will see:
      ```bash
       user@computer:~$ telnet cs144.keithw.org http
       Trying 104.196.238.229...
       Connected to cs144.keithw.org.
       Escape character is '^]'.
      ```
      If you need to quit, hold down `ctrl` and press `]`, and then type `close<CR>`
   2. type `GET /hello HTTP/1.1 <CR>`. This tells the server the _path_ part of the URL. (The part starting with the third slash.)
   3. Type `Host: cs144.keithw.org <CR>`. This tells the server the _host_ part of the URL. (The part between `http://` and the third slash.)
   4. Type `Connection: close <CR>`. This tells the server that you are finished making requests, and it should close the connection as soon as it finished replying.
   5. Hit the Enter key one more time: `<CR>`. This sends an empty line and tells the server that you are done with your HTTP request.
   6. If all went well, you will see the same response that your browser saw, preceded by HTTP _headers_ that tell the browser how to interpret the response.
3. **Assignment:** Now that you know how to fetch a Web page by hand, show us you can! Use the above technique to fetch the URL http://cs144.keithw.org/lab0/sunetid, replacing _sunetid_ with your own primary SUNet ID. You will receive a secret code in the `X-Your-Code-Is: header`. Save your SUNet ID and the code for inclusion in your writeup.

### 2.2 Send yourself an email

### 2.3 Listening and connecting

## 3 Writing a network program using an OS stream socket

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

1. Still in the "minnow" directory, create a directory to compile the lab software: `cmake -S . -B build`
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
5. Test your program by running `./apps/webget cs144.keithw.org /hello`. How does this compare to what you see when visiting htto://cs144.keithw.org/hello in a Web browser? How does it compare to the results from Section [[#2.1 Fetch a Web Page|2.1]] ? Feel free to experiment—test it with any **http URL** you like!
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

```

1. The graders will run your `webget` program with a different hostname and path than `make check_webget` runs — so make sure it doesn’t _only_ work with the hostname and path used by the unit tests.

## 4 An in-memory reliable byte stream

## Submit

# 中文

# 我的实现

我用的是arm64版本的macOS，提前安装了orbstack所以我决定利用orbstack创建一个ubuntu24.04的容器。（我感觉这个类似windows上的wsl的操作）

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

```bash
sudo apt update && sudo apt install git cmake gdb build-essential clang \
	   clang-tidy clang-format gcc-doc pkg-config glibc-doc tcpdump tshark
```

具体的orb操作可以参考这个链接：https://docs.orbstack.dev/machines/ssh

总之我们还可以用vscode的ssh-remote插件连接进去进行开发。

---

访问页面：http://cs144.keithw.org/hello，看到内容是`Hello, CS144!`

在macOS宿主机或者ubuntu虚拟机都可以，我这里在macOS上运行是因为ubuntu没有telnet。

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

Q: 我这里有个问题：telnet命令已经指定了`cs144.keithw.org`为什么后面发送请求的时候仍然要输入：`Host: cs144.keithw.org`呢？
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

然后这里有个小Assignment：

![telnet-sunetid.png](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/03/telnet-sunetid.png)

看返回的数据，`X-Your-Code-Is: 403269`。感觉应该其实是要把`sunetid`替换成自己的，但是我没有办法注册，所以先这样。

---

后面要设置github等等，在github上面创建一个属于自己的private的minnow仓库，然后在linux上执行：

```bash
git remote add github https://github.com/ukeSJTU/minnow
```

链接一下git相关的操作：[[git]]

如果和下面结果一样说明操作正确：

```bash
$ git remote -v
github  https://github.com/ukeSJTU/minnow (fetch)
github  https://github.com/ukeSJTU/minnow (push)
origin  https://github.com/cs144/minnow (fetch)
origin  https://github.com/cs144/minnow (push)

$ git push github
Enumerating objects: 64, done.
Counting objects: 100% (64/64), done.
Delta compression using up to 8 threads
Compressing objects: 100% (57/57), done.
Writing objects: 100% (64/64), 40.84 KiB | 13.61 MiB/s, done.
Total 64 (delta 4), reused 52 (delta 3), pack-reused 0
remote: Resolving deltas: 100% (4/4), done.
To https://github.com/ukeSJTU/minnow
 * [new branch]      main -> main
```

[[cmake]]:

是的，cmake -S . -B build 和 cmake .. 在某些情况下作用相似，但它们的使用方式和适用场景有所不同。

1. cmake -S . -B build

这是 推荐的 CMake 现代用法，适用于 任何地方运行：
• -S .（source）明确指定源码目录。
• -B build（build）明确指定构建目录。

优点：
• 语义清晰，适用于任何终端环境（不受当前工作目录影响）。
• 不会污染源码目录，始终在 build/ 目录中生成构建文件。
• 现代 CMake 推荐这种写法，适合自动化脚本。

1. cmake ..

这是 传统用法，适用于 你已经 cd 进入 build/ 目录：

mkdir build
cd build
cmake ..

    •	.. 指代上一级目录，即源码所在目录。
    •	这等价于 cmake -S .. -B .，即：
    •	源码在 ..（上一级）
    •	构建目录是当前目录 .

缺点：
• 必须手动 cd build 进入构建目录后再执行，稍显繁琐。
• 不适用于自动化脚本（可能因为目录问题出错）。
• 容易混淆：如果你不在 build/ 目录执行，可能会污染源码目录。

什么时候用哪种？

用法 适用场景
cmake -S . -B build 推荐方式，适用于任何地方运行，现代 CMake 用法
cmake .. 适用于你已经 cd build，传统方式

推荐方式：

cmake -S . -B build
cmake --build build

这样不需要 cd build，更加通用。

如果你之前在某些项目执行 cmake ..，那说明当时你是手动进入 build/ 目录执行的，和 cmake -S . -B build 的方式本质上是相同的，只是使用方式不同。

---

开始实现`webget`

可以直接运行编译好的`webget`程序查看example用法：

```bash
$ ./build/apps/webget
Usage: ./build/apps/webget HOST PATH
        Example: ./build/apps/webget stanford.edu /class/cs144
```
