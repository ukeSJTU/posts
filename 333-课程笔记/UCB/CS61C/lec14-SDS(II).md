内容：Registers, State, Timing, FSMs

回顾上讲SDS有两种电路：

1. combinational logic circuits
2. State elements
   - Circuits that store information
   - Example: Registers

## Agenda

- state elements: registers
- flip-flops and timing
- accumulator circuit
- circuit timing constraints
- finite state machines

## State Elements 状态元素？

### What do state elements do?

- **State Elements** are circuits that store information.
- Store values for indeterminate amount of time
  - Register files x0-x31 in RISC-V
  - Memory
  - SR Latch
- **Control flow of information** between combinational logic blocks
  - 这样可以hold up信息流动，allow for orderly messages
- **Often Constrain the overall SDS performance**

### Register: a circuit with state

寄存器是一种特殊的电路，可以stores information for a period of time

- Special _INPUT_ signal **LOAD** is a trigger
- On trigger: Sample **Input** & transfer to **output**

但在其他任意时刻，忽略输入。

> 我感觉简单来说就是寄存器的电路一致处于阻塞状态，这个是output和input是无关的。但是假如LOAD使能的话，output立刻和input同步。

本节课局限于RISC-V，所以寄存器的输入输出都是32-bit

### 回顾一下SDS

我们前面说到，在几乎所有processor之下的hardware就是SDS

- 在物理层面：
  - wires and transistors
- 在设计层面（on a design block level):
  - combinational logic and state elements
  - each just consists of different combinations of wires and transistors
- 在更高层面，两个特性：
  - Synchronous：coordinated by a central clock
  - Digital: binary digits

这个clock，也就是说为了控制信息的流动，我们需要clock our statements.

- Clock period 或者
- Clock frequency

### clocked registers

在我们这个课程中，我们只讨论rising edge-triggered state elements，也就是positive edge。

- 触发Trigger：LOAD信号从0到1
- LOAD信号就是clock signal（CLK，时钟信号）
  - 在每个clock cycle，加载input value
- 当然其实还有falling-edge registers, non-CLK triggers等等，但是不在本课程范围内。
