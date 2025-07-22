从本lecture开始，我们来到了我们之前学习的Machine Language Program的下一层：Hardware architecture以及再下一层Logical Circuit Description. 我们主要想要回答的问题是：

- 我们所谓的code本质是二进制数字，为什么通过电路我们就能运行电脑
- 为什么我们前面研究RISC-V instruction formats的时候有一些部分的排列非常奇怪

## Agenda

- Synchronous Digital System
- signals, transistors, Moore's laws
- logic gates and truth tables
- circuit design: compose blocks
- boolean algebra
- circuit design: simplify with boolean algebra

## Synchronous Digital System (SDS)

这部分课程的目标是学习现代处理器 (modern processor) 是如何从最基本的构建模块 (basic building blocks) 开始搭建的 。

### Hardware Design

为什么我们要学习硬件设计？

- 为了真正理解计算机如何工作，我们需要理解整个技术栈 (complete stack)，包括最底层的物理层面 (physical level) 。
- 理解硬件，特别是处理器的能力 (capabilities) 和限制 (limitations) 。
- 这门课是后续硬件课程 (如 EECS 151, CS 152) 的基础 。

### SDS

什么是SDS？几乎所有现代处理器都是一个 **Synchronous Digital System** 。

- **Synchronous (同步):** 系统中所有的操作都由一个中央时钟 (central clock) 来协调(coordinated by a central clock)。这个时钟就像系统的心跳 (Heartbeat)，让所有部件保持同步，从而简化了设计。所有操作也都不会比这个clock更快。
- **Digital (数字):** 所有的值都由离散的值来表示，也就是二进制数字 (binary digits) 。这些二进制值通过不同的电压水平 (electrical signals) 来表示 。

作为对比，还有asynchronous system以及analog circuits等等。后者更加复杂，但是一般最终都需要A转D的模块。

## signals, transistors, Moore's law

无论多么复杂的芯片，比如 CPU 或 GPU，其最核心的组成部分都是 **wires (导线)** 和 **transistors (晶体管)** 。

### wires: binary representation of signals

- 在芯片上，导线用来传输电信号 (electrical signals)，这些信号被用来表示二进制变量 。
- 我们使用不同的电压水平 (voltage levels) 来表示 0 或 1 。例如，0V 代表 '0'，1.5V 代表 '1'。为了抵抗噪声干扰，在 '0' 和 '1' 的电压范围之间会有一个 "Undefined" 的区域 。
- 为什么用二进制？因为只区分两种状态的电路设计起来更简单，并且可靠性高，有很好的抗噪声能力 (noise immunity) 。历史上的电脑可能驱动电压比较高，但是随着制作工艺变好，我们可能需要的电压越来越低，这也反过来意味着noise的影响更显著。
- 将几条wires组合在一起就可以表示multi-bit variables
  - 这里有个值得注意的例外就是Flash，后续讨论，two bits per storage cell

### transistors

- 在transistors之前用的是vacuum tubes，但是在出现了集成电路后就变成使用transistors。
- Transistors 是现代电子设备中的关键部件，其作用相当于一个**电压控制的开关 (voltage-controlled switches)** 。
- 尽管在模拟电路中，transistors可以当作放大器的一个部分，但是我们这个课程主要围绕数字电路，因此transistors的主要作用是开关 switch。
- 它有三个端口：**Gate (栅极)**, **Source (源极)**, and **Drain (漏极)** 。施加在 Gate 上的电压决定了 Source 和 Drain 之间是否导通：
  - 当G处电压大于S电压+threshold的时候关闭switch
  - 当G处电压比S电压小的时候导通

### Moore's Law

- **Moore's Law (摩尔定律)** 是 Intel 联合创始人 Gordon Moore 的观察：集成电路 (integrated circuit) 上的晶体管数量大约每两年翻一番 。
- 这个指数级增长驱动了计算能力几十年的飞速发展 。然而，最近的数据显示，这个趋势似乎正在**放缓 (tapering)** 。

## logic gates and truth tables

当代集成电路有很多multi-core/domain-specific processors：

- Six Cores
- GPU
- NPU
- 等等

SDS 由两种基本电路组成：

1.  **Combinational Logic (CL) circuits (组合逻辑电路):** 电路的输出仅取决于当前的输入 (output is a function of the inputs only) 。它没有记忆功能，像一个纯函数 $y=f(x)$ 。
2.  **State Elements (状态元件):** 能够存储信息的电路，例如寄存器 (Registers) 。

### Fundamental Logic Gates

CL 电路是由称为 **logic gates (逻辑门)** 的基本操作符构成的 。

- **AND (与门):** 只有当所有输入都为 1 时，输出才为 1 。
- **OR (或门):** 只要有任何一个输入为 1，输出就为 1 。
- **NOT (非门/反相器):** 输出与输入相反 。
  这三个门是 **functionally complete (功能完备的)**，意味着任何逻辑函数都可以只用这三种门来实现 。为了精确描述逻辑门的功能，我们使用 **truth tables (真值表)**，它列出了所有输入组合对应的输出结果 。上课的时候介绍了每个门的truth tables，这里为了节省篇幅就不罗列了。

尽管我们最一开始接触的AND/OR门都是两个inputs，实际上可以直接拓展成n-input的版本。

### Other Common Gates

这一部分上课的时候是在circuit design后，boolean algebra前面，但是我整理笔记选择放在这里。

- **NAND (与非门):** AND 的反向。
- **NOR (或非门):** OR 的反向。
- **XOR (异或门):** 当输入不相同时，输出为 1 。
- **NAND** 门特别重要，因为它是一个 **universal gate (通用门)**，可以用它来构建任何其他逻辑门 。在硬件实现上，它也通常比 AND 门更高效。
  - 实际上NOR也有同样的性质，但是从硬件实现的角度（NAND实现需要的transistors数量更少）NAND更加优秀。

## circuit design: compose blocks

在设计复杂电路时，我们采用**模块化设计 (Modular design)** 的思想：

1. 按照功能列写一个简单的truth table
2. 定义好小的功能模块并实现
3. 然后用小模块来搭建更复杂的系统 。

**例子: 32-bit Equality Checker**

- **问题:** 如何比较两个 32-bit 的数是否相等？真值表将会有 $2^{64}$ 行，这在现实中是不可能实现的 。
- **解决方案:** 分解问题。两个 32-bit 的数 A 和 B 相等，当且仅当它们所有对应的 bit 位都相等，即 ($a_0==b_0$) AND ($a_1==b_1$) AND ... AND ($a_{31}==b_{31}$) 。
- **实现:** 我们可以先设计一个 1-bit 比较器，然后使用 32 个这样的模块，并将它们的所有输出连接到一个 32-输入的 AND 门 。

**Sum-of-Products (SoP)**

- SoP (乘积和) 是一种通用的、从真值表直接生成电路的方法 。
- 方法是：找出真值表中所有输出为 1 的行，为每一行写一个 AND (product) 项，最后将所有这些项 OR (sum) 起来 。
- 这个方法保证能用，但是存在一些不足之处：
  - 得到的电路可能非常复杂
  - 许多diagrams可能对应相同的truth tables

第二个不足之处的问题其实等价于：

- 我们怎么证明两个gate diagrams是equivalent等价的？
- 我们如何设计简化的电路图？

## boolean algebra

- **Boolean Algebra (布尔代数)** 是19世纪数学家 George Boole 发展的用于逻辑运算的数学系统 。
- 20世纪的 Claude Shannon 建立了布尔代数和电子电路之间的一一对应关系，为电路的分析和简化提供了数学理论基础 。
- **符号表示:** AND 用乘法 (`·`) 表示，OR 用加法 (`+`) 表示，NOT 用上划线 (`Ā`) 表示 。

### Laws of Boolean Algebra

布尔代数有一系列定律，可以用来化简表达式，从而化简电路 。

| AND Form                                             | OR Form                                              | Laws                            |
| ---------------------------------------------------- | ---------------------------------------------------- | ------------------------------- |
| $x \cdot y = y \cdot x$                              | $x + y = y + x$                                      | **Commutativity 交换律**        |
| $(x \cdot y) \cdot z = x \cdot (y \cdot z)$          | $(x + y) + z = x + (y + z)$                          | **Associativity 结合律**        |
| $x \cdot 1 = x$                                      | $x + 0 = x$                                          | **Identity 恒等律**             |
| $x \cdot 0 = 0$                                      | $x + 1 = 1$                                          | **Laws of 0's and 1's 零一律**  |
| $x \cdot (x + y) = x$                                | $x + (x \cdot y) = x$                                | **Absorption 吸收律**           |
| $x \cdot (y + z) = (x \cdot y) + (x \cdot z)$        | $x + (y \cdot z) = (x + y) \cdot (x + z)$            | **Distributivity 分配律**       |
| $x \cdot x = x$                                      | $x + x = x$                                          | **Idempotence 幂等律**          |
| $x \cdot \overline{x} = 0$                           | $x + \overline{x} = 1$                               | **Inverse (Complement) 互补律** |
| $\overline{x \cdot y} = \overline{x} + \overline{y}$ | $\overline{x + y} = \overline{x} \cdot \overline{y}$ | **DeMorgan's Laws 德摩根定律**  |

## circuit design: simplify with boolean algebra

利用布尔代数来简化电路是最高效的设计策略 。
**核心流程:**

1.  从功能需求出发，建立 **Truth Table** 。
2.  根据真值表写出初始的 **Boolean Expression** (例如使用 SoP) 。
3.  应用**布尔代数定律**来化简这个表达式 。
4.  根据化简后的表达式画出最终的、更简单的 **Gate Diagram** 。

**例子:**
一个复杂的电路表达式 $y=ab+a+c$ 可以被化简 。
$y = a(b+1) + c \rightarrow y = a(1) + c \rightarrow y = a + c$ 。
这证明了一个复杂的电路可以等效于一个简单的两输入 OR 门，从而大大降低了成本和延迟 。

**关于算法化简:**
寻找任意逻辑函数的最简形式是一个非常困难的计算问题 (与 P=NP 问题相关) 。幸运的是，CPU 中设计的电路是高度结构化的，而不是随机的，这使得布尔代数简化非常有效 。

## Summary: how to build combinational logic blocks?

### Strategy 1: Truth Table -> Gate Diagra,

- Modular Design: If truth tables are too big to construct, define smaller blocks first.
  - Drawbacks: Going from the truth table to a working gate diagram can be complex
- Sum-Product Rule: OR together rows of truth tables in gates
  - Drawbacks: Can have unnecessarily complex results

### Strategy 2: Gate Diagram -> Boolean Algebra -> Gate Diagram

- Use boolean algebra: Use Boolean Algebra Laws
- Design equivalent gate diagrams, which can be simpler

### Strategy 3: Truth Table -> Boolean Algebra -> Gate Diagram

- Sum-Product Rule: OR together rows of truth table in Boolean algebra
- Simplify using Boolean Algebra laws if needed
- Draw Gate Diagram
