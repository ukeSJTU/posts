# Lecture 1 - Functions

---

# Textbook

## 1.1 Getting Started

本书大量借鉴了经典教材[SICP](http://mitpress.mit.edu/sicp)，即《计算机程序的构造与解释》来教授基本思想：

1. 信息的表示
2. 处理的逻辑
3. 设计抽象来管理逻辑的复杂性

### 1.1.1 Programming in Python

> A language isn't something you learn so much as something you join.
> —[Arika Okrent](http://arikaokrent.com/)

这本书极力保留了 [SICP](http://mitpress.mit.edu/sicp) 的精神：通过抽象和严格的计算模型逐步介绍 Python 的特性。

### 1.1.2 Installing Python 3

略。

### 1.1.3 Interactive Sessions

In an interactive Python session, you type some Python *code* after the *prompt*, >>>. The Python *interpreter* reads and executes what you type, carrying out your various commands.

To start an interactive session, run the Python 3 application. Type python3 at a terminal prompt (Mac/Unix/Linux) or open the Python 3 application in Windows.

| Commands             | Effects                  |
| -------------------- | ------------------------ |
| <kbd>Control-P</kbd> | Access **Previous** line |
| <kbd>Control-N</kbd> | Access **Next** line     |
| <kbd>Control-D</kbd> | Exit **Session**         |

在某些系统上，上、下箭头也可以用于循环浏览历史记录。

### 1.1.4 First Example

本节将以一个使用“多种语言特性”的示例来介绍 Python，你可以将此部分视为即将到来的功能的预览，在下一节中，我们将从头开始逐步了解整个语言。

Python 内置了一些常见编程功能，例如处理文本、显示图形以及通过互联网进行通信。下面这行 Python 代码

```python
>>> from urllib.request import urlopen
```

是一个 `import` 语句，它会导入一个用于“访问互联网数据”的功能，该功能特别提供了一个名为 `urlopen` 的函数，可以访问 URL（也就是访问互联网上的某个网址）上的内容。

TODO: 这个对于python的引入值得学习

### 1.1.5 Errors

> ... `computer = powerful + stupid` ...
> —Francisco Cai and Nick Parlante, Stanford CS101

学着解释错误和找到错误的原因称为调试，关于调试的一些指导原则是：

1. **增量测试**：每个编写良好的程序都由可以单独测试的小型模块化组件组成。尽快测试你已经编写的所有内容，以尽早发现问题并获得对组件的信心。
2. **隔离错误**：语句输出中的错误通常可归因于特定的模块化组件。所以在诊断问题时，先追踪错误到最小的代码片段，然后再试着修复问题。
3. **检查你的假设**：解释器会一字不漏地执行你的指示——不多也不少。当某些代码的行为与程序员假设的行为不匹配时，它们的输出就是不符合预期的。明确你的假设，然后将调试的工作集中在验证你的假设上。
4. **咨询别人**：你不是一个人！如果你不理解错误信息，请询问朋友、老师或搜索引擎。如果你已经找出了一个错误，但却不知道如何更正它，可以请其他人查看。在小组解决问题的过程中会分享很多有价值的编程知识。

## 1.2 Elements of Programming 编程要素

程序必须是人类可以阅读的，并且“恰巧”能被机器执行。

当我们描述一种语言时，就需要特别注意该语言所提供的能够将简单思想组合成复杂思想的工具。每一种强大的语言都有这样三种机制：

- **原始表达式和语句**：语言所关心的最简单的个体
- **组合方法**：由简单元素组合构建复合元素
- **抽象方法**：命名复合元素，并将其作为单元进行操作

在编程中，我们只会处理两种元素：**函数**和**数据**（之后你会发现它们实际上并不是泾渭分明的），不那么正式的说法是：

- 数据是我们想要操作的东西
- 函数是操作这些数据的规则的描述。

因此，任何强大的编程语言都必须能表达基本的数据和函数，并且提供对函数和数据进行组合和抽象的方法。

### 1.2.1 Expressions 表达式

"数字 number"就是一种基本的表达式

```python
>>> 42
42
```

将数字与数学运算符组合可以形成一个复合表达式，解释器将对其进行求值：

```python
>>> -1 - -1
0
>>> 1/2 + 1/4 + 1/8 + 1/16 + 1/32 + 1/64 + 1/128
0.9921875
```

这些数学表达式使用中缀表示法（infix notation）

### 1.2.2 Call Expressions 调用表达式

最重要的一种复合表达式是*调用表达式(call expression)*，它将函数运用于一些参数上。

函数符号相比传统的中缀数学符号有三个主要优点。首先，因为函数名总是在参数前面，函数可以接收任意数量的参数而不会产生歧义。

```python
>>> max(1, -2, 3, -4)
3
```

其次，函数可以直接扩展为嵌套（nested）表达式，其元素本身就是复合表达式。不同于中缀复合表达式，调用表达式的嵌套结构在括号中是完全明确的。

```python
>>> max(min(1, -2), min(pow(3, 5), -4))
-2
```

这种嵌套的深度（理论上）没有任何限制，Python 解释器可以解释任何复杂的表达式。

第三点，数学符号在形式上多种多样。类似平方根这样的符号难以输入。但是，所有这些复杂事物都可以通过调用表达式的符号来进行统一。

> `Python`除了支持常见的中缀数学符号（如 `+` 和 `-`）之外，其他任何运算符都可以表示为一个带有名称的函数。

### 1.2.3 Importing Library Functions 导入库函数

Python 将已知函数和其他东西组织起来放入到了模块中，而这些模块共同组成了 Python 库。我们要使用的时候需要导入它们，例如 `operator`  模块提供了中缀运算符对应的函数：

```python
>>> from operator import add, sub, mul
>>> add(14, 28)
42
>>> sub(100, mul(7, add(8, 4)))
16
```

### 1.2.4 Names and the Environment 名称与环境

编程语言的一个要素就是使用名称来引用计算对象，如果一个值被赋予了名称，我们说名称绑定到了值上面。

在 Python 中，我们可以使用赋值语句建立新的绑定，`=` 左边是名称，右边是值。

名称也可以通过 `import` 语句绑定。

`=` 在 Python 中称为 **赋值** 符号（即 assignment operator，许多其他语言也是如此），赋值是最简单的 **抽象** 方法，因为它允许我们使用简单名称来指代复合操作的结果，例如上面计算的 `area`。

将名称与值绑定，之后通过名称检索可能的值，就意味着解释器必须维护某种内存来记录名称、值和绑定，这种内存就是 **环境（environment）**。

### 1.2.5 Evaluating Nested Expressions 求解嵌套表达式

这里利用前面的嵌套表达式，引入了**树**和**递归**的概念，展示“以程序的角度思考”。

### 1.2.6 The Non-Pure Print Function 非纯函数`print`

区分两种类型的函数。

- **纯函数（Pure functions）**：函数有一些输入（参数）并返回一些输出（调用返回结果）。
- **非纯函数（Non-pure functions）**：除了返回值外，调用一个非纯函数还会产生其他改变解释器和计算机的状态的副作用（side effect）。

1. 首先，纯函数可以更可靠地组成复合调用表达式。
2. 第二，纯函数往往更易于测试。相同的参数列表会返回相同的值，我们可以将其与预期的返回值进行比较。本章后面将更详细地讨论测试。
3. 第三，第四章将说明纯函数对于编写可以同时计算多个调用表达式的并发程序来说是必不可少的。

## 1.3 Defining New Functions

### 1.3.1 Environments

### 1.3.2 Calling User-Defined Functions

### 1.3.3 Example: Calling a User-Defined Function

### 1.3.4 Local Names

### 1.3.5 Choosing Names

### 1.3.6 Functions as Abstractions

### 1.3.7 Operators
