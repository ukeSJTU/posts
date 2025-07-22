Single-Cycle Datapath I

## Agenda

- Building a RISC-V Processor
- CPU Elements and Stages
- R-Type: add Datapath
- R-Type: sub Datapath
- Datapath with immediates: addi
- Implementing Loads
- Implementing Stores
- Implementing Jumps

从上次的最基础的logic circuits向上面移动一层，这样更接近构建我们自己的CPU。

TOD

## CPU Elements and Stages

TODO

### Combinational Logic Blocks

从理论上来说，可以只用OR, AND, NOT gates来实现任何功能。例如：

- Adder
- Mux

在电路中，wire要么是0要么是1，不存在unknown voltage的状态。并且每个component will run every cycle

- 也就是说adder每一个cycle都一定会运行一次，和你实际上要不要进行add操作没有关系。

但是因为？？？？

has a delay TODO

从今天开始我们的加法电路就可以简化成一个block了。

### State Elements

RISC-V被确定为**只**根据state elements运行。换句话说，假如两个CPU有着完全一样的state elements的话，那么两个CPU将会运行完全相同的指令操作。

每一个指令至少应该修改一部分state elements（否则相当于进入infinite-loop）

CPU里面有 three main state elements:

- Registers（PC）
- ？？？
- Main memory

#### State element: register

Input:

- 32-bit data input bus(D)
- Write Enable "Control" bit (1=Enabled, 0=Disabled)
  Output:
- 32-bit data output bus (Q)
  Behavior:
- If Write Enable is 1 on rising clock edge, set Data Out = Data In.
- At **all other times**, Data Out will not change; it will output its current value
- 所以需要注意：Reading the value of a reg doesn't take a clock tick TODO

#### State element: Register File

Group of 32 registers, 用来管理改变/读取哪些registers

Input:
TODO

#### State element: Memory

Input: TODO
