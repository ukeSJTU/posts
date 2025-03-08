原本lab0要求文档在这里：[lab-check0](https://cs144.github.io/assignments/check0.pdf),先摘录调整为markdown格式如下，同时提供中文版本翻译，最后是我的实现部分。

# English

Welcome to CS144: Introduction to Computer Networking. In this warmup, you will set up an installation of GNU/Linux on your computer, learn how to perform some tasks over the Internet by hand, write a small program in C++ that fetches a Web page over the Internet, and implement (in memory) one of the key abstractions of networking: a reliable stream of bytes between a writer and a reader. We expect this warmup to take you between 2 and 6 hours to complete (future labs will take more of your time). Three quick points about the lab assignment:

- It’s a good idea to read the whole document before diving in!
- Over the course of this 8-part lab assignment, you’ll be building up your own implementation of a significant portion of the Internet—a router, a network interface, and the TCP protocol (which transforms unreliable datagrams into a reliable byte stream). Most weeks will build on work you have done previously, i.e., you are building up your own implementation gradually over the course of the quarter, and you’ll continue to use your work in future weeks. This makes it hard to “skip” a checkpoint.
- If you don’t meet the CS144 prerequisites, please don’t take this class yet—our teaching staff’s resources are limited. And please use checkpoints 0 and 1 as a gauge: if you find yourself uncomfortable with the programming in the first two checkpoints, please consider taking CS144 in a later year after you’ve attained more comfort with this kind of programming (perhaps after taking CS 106L, embarking on a self-directed programming project, or otherwise building up your comfort and experience level).
- The lab documents aren’t “specifications”—meaning they’re not intended to be consumed in a one-way fashion. They’re written closer to the level of detail that a software engineer will get from a boss or client. We expect that you’ll benefit from attending the lab sessions and asking clarifying questions if you find something to be ambiguous and you think the answer matters. We’ll update the “lab FAQ” document on the course website in response to late questions that need clarification.

## 0 Collaboration Policy

**The programming assignments must be your own work:** You must write all the code you hand in for the programming assignments, except for the code that we give you as part of the assignment. Please do not copy-and-paste code from Stack Overflow, GitHub, or other sources. If you base your own code on examples you find on the Web or elsewhere, cite the URL in a comment in your submitted source code.

**Working with others:** You may not show your code to anyone else, look at anyone else’s code, or look at solutions from previous years. You may discuss the assignments with other students, but do not copy anybody’s code. If you discuss an assignment with another student, please name them in a comment in your submitted source code. Please refer to the course administrative handout for more details, and ask on EdStem if anything is unclear. Services like GitHub Copilot or ChatGPT should be considered to be equivalent to “a student that took CS144 in a prior year.”

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

4. **Use another GNU/Linux distribution “at your own risk”**, but be aware that you may hit roadblocks along the way and will need to be comfortable debugging them.Your code will be tested on **Ubuntu 24.04 LTS** with **g++ 13.3** and must compile and run properly under those conditions.

5. If you have a 2020–24 MacBook (with the ARM64 M-series chips), VirtualBox will not successfully run. Instead, please install the UTM virtual machine software and our ARM64 virtual machine image from [CS144 VM Howto](https://stanford.edu/class/cs144/vm-howto/).

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

### 3.3 Modern C++: mostly safe but still fast and low-level

### 3.4 Reading the Minnow support code

### 3.5 Writing `webget`

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
