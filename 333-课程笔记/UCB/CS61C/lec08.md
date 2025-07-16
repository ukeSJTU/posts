RISC-V Procedures

## Agenda

- Function Calls
  - More Jumps
  - The `ra` Register
- Argument Passing
  - `a` Registers
- Stack Frames
  - The `sp` Register
- RISC-V Calling Convention
  - `s` Registers
  - `t` Registers
  - Prologues and Epilogues
  - `ra` is weird
  - Recursion!

## Function calls

上一讲（lec07）提到了Jump，比如说函数调用是一种unconditional jump，但是现在的问题是C怎么知道return该回到哪里？以及我们如何传递参数呢？

实际上C的函数调用按照以下顺序：

1. Set up args
2. **Transfer control to function**
3. Prologue
4. Perform desired task
5. Epilogue
6. **Return control to the point of call**

这里简单回顾一下C的内存模型，RISC-V和它基本一样，本讲主要关注Text(Code)以及Stack段

这里省略具体图片。可以在lec04或者lec08的PPT上找到。

RISC-V的代码也是text/code段的数据（我感觉这里PPT上的data应该不是想说代码应该在static/data段的意思吧）。本讲我们只需要知道RISC-V的每个指令都可以转换成单独的4bytes，下一讲深入研究具体怎么转换的。

换句话说，下一条指令就是4bytes后。

因此有一个隐藏的register叫做Program Counter也就是PC，存储the address of the current line of code. 这里“隐藏”的意思是，PC并不是之前我们说的x0-x31这32个通用寄存器中的一个，而是独立的特殊寄存器，一般不能直接写入。

### More Jumps

调用函数是`jal`: Jump And Link

```text
jal rd Label
等价于
R[rd] = PC + 4 // 相当于存储了函数执行完后应该执行的下一行代码
PC = <address of Label> // 跳转到要执行的函数的位置去
```

从函数返回是`jr`: Jump Register

**注意**：这是一个伪指令

```text
jr rs1
等价于
PC = R[rs1] // unconditional jump, go to statement at address R[rs1]
```

因此这两个形成了很常见的一对指令：

```text
jal ra FunctionName
---
jr ra
```

#### Jump Summary Table

|                   | Jumps to a Label               | Jumps to a Register                        |
| ----------------- | ------------------------------ | ------------------------------------------ |
| Saves `ra`        | `jal rd Label` Call a function | `jalr rd rs1` Less common, HoF or Lib func |
| Doesn't save `ra` | `j Label` Looping              | `jr rs1` return from a function            |

caller就是parent functions也就是调用者，callee就是child functions也就是被调用者。一个函数can be both a caller and a callee.

### The `ra` Register

如果每个人/每个函数都随意使用寄存器的话，容易因为错位overwrite values导致问题，因此我们给寄存器names以及和名字关联的一套conventions（rules）

#### x0 - 0

x0就是我们之前学到的，硬编码为0

#### x1 - ra

x1的名字是`ra`，也就是Return Address的意思，它的唯一用处就是 When we are in a function, `ra` holds the address oof the line immediately after whatever line called us.

到这里，我们回顾一下本讲最一开始提到的6步fundamental steps in calling a function:

1. Set up args
2. **Transfer control to function** `jal ra fnLabel`
3. Prologue
4. Perform desired task
5. Epilogue
6. **Return control to the point of call** `jr ra`

## Argument passing

这个关注的是第一步，也就是如何set up arguments

#### x10-x17 - a0-a7

任何以a开头的名字的寄存器就是可以用来传递参数，而`a0`和`a1`有时候用来从函数return values

因此，为了传递参数，就需要在`jal`前，先将参数放到a开头的寄存器里面去。

#### pseudo mv

为了方便我们在不同寄存器之间move values，有一个伪指令：

```text
mv rd rs1
等价于
addi rd rs1 0
```

## Stack Frames

从C高级语言的角度看：

- stack向下增长
- 每一个function call会创建自己的stack frame

但是在RISC-V里面：

- 我们需要手动实现stack growing的过程
- 我们有一个寄存器指向bottom of the stack

### The `sp` Register

#### x2 - sp

sp指向**bottom** of the stack：

- Anything above `sp` is some other functions data, 所以一定一定不要修改
- Anything below `sp` is safe to change，但有可能别人也可以修改

因此，一个函数可以通过decrement `sp`来获取栈空间，但是它也一定**must**要在返回前，恢复`sp`到函数最一开始的状态

总的来说：

1. 先decrement sp来获得所需要的空间，然后用positive offsets from `sp`来load data，而不是用negative offsets，否则其他地方可能会修改你的数据因为没有claim space
2. 在用完后一定要恢复restore sp，这也是为什么从函数返回后C里面栈上的变量都消失了
3. stack仍然是mem的一部分
   - 可以做任何事情：keep local arrays, local structs, local strings, etc...
   - C里面栈上做的事情，也可以在RISC-V里面做
   - C里面不应该对stack做的事情，也不应该在RISC-V里面做

## RISC-V Calling Convention

按照我们前面提出的conventions，我们定义两种寄存器类型：

- Temporary：在函数调用后，里面的数值可能发生变化
- Persistent（Saved）：函数调用后，里面的数值**must not changed**

下面具体来看这两类寄存器

### t Registers - Temporary

方便我们在计算的时候存储intermediate values

具体是t0-t6总共7个寄存器，其中t0-t2对应x5-x7，而t3-t6对应x28-x31

### s Registers - Saved / Persistent

这些寄存器就像sp一样，如果被调用的函数要使用这些寄存器，必须先保存它们的原值，并在函数返回前恢复。

名字是s0-s11,其中s0-s1对应x8-x9，而s2-s11对应x18-x27。

### Prologues and Epilogues

1. Set up args
2. Transfer control to function
3. **Prologue**
4. Perform desired task
5. **Epilogue**
6. Return control to the point of call

#### Prologue

Acquire (local) storage resources for function: stack, registers

#### Epilogue

- Put return value in a0 (or a1)
- Restore any registers used
- Release local storage on stack

上面这些叫做callee-perspective，也就是callee负责存储/恢复s寄存器。

但是假如我们想要保持a或者t的寄存器的数值呢？

那么就应该要Caller-saving，也就是要caller来保存，也叫做caller perspective
