RISC-V IV Instruction Format
本节具体的instruction formats以及特定的opcode/funct values也可以看reference-card
https://cs61c.org/su25/pdfs/resources/reference-card.pdf

## Agenda

- Intro
- R-types
- I-types
- S-types
- U-types
- B-types
- J-types
- Concluding Notes

## Intro

- 汇编语言只所以游泳是因为它们可以直接转换成二进制格式，直接由CPU运行
- RISC-V的所有指令都是32bits（RV32）
- 不同的指令需要不同的数值
  - 例如 add 需要3 个register inputs
  - 但是还有其他指令比如addi只需要2个registers以及1个immediate
  - jump等等
- 由此可见，我们需要多种formats，每个指令应该encode成某种format
- 总的设计方式就是把32bits分成不同的components，具体分割方式可以看ref-card，不需要记忆每一部分具体需要几个bits

## R-types

> Register types: 寄存器类型指令，操作数来自寄存器，结果也存入寄存器

所有的需要3个registers，没有立即数的指令，例如算数操作add/sub

总共32个registers也就是5bits可以全部表示，x0->0b00000, a0->x10->0x01010等等

```text
31    25  24   20 19   15 14   12 11    7 6     0
+--------+-------+-------+-------+-------+--------+
| funct7 |  rs2  |  rs1  |funct3 |  rd   | opcode |
+--------+-------+-------+-------+-------+--------+
  7 bits  5 bits  5 bits 3 bits 5 bits  7 bits
```

opcode永远都是32bits里面的最后7bits，这样无论具体格式，都可以知道指令类型是什么（是R还是I还是S等等）

一组比较接近的指令可能会分到相同的`opcode`，例如这里R-types的指令的opcode全部是`0x33`。但是我们还有`funct3`这个3-bit标识符来区别有着相同opcode的不同指令。

下面是个例子 转换`add s2 s3 s4`为hex格式：

1. 首先是add指令，属于R type；rd=s2, rs1=s3, rs2=s4
2. 查看ref-card， opcode是0b 011 0011，funct3 = 0b 000, funct7 = 0b 000 0000
3. 按照R type的format进行拼接：`funct7 rs2 rs1 funct3 rd opcode`:
   1. `0000000 rs2 rs1 000 rd 0110011`
   2. `0000000 rs2 rs1 000 10010 0110011`
   3. `0000000 rs2 10011 000 10010 0110011`
   4. `0000000 10100 10011 000 10010 0110011`
4. 调整一下格式`0000 0001 0100 1001 1000 1001 0011 0011` -> `0x01498933`

再来个例子：`0x01B3 42B3` 转换成RV32的指令：

1. 先转成二进制：`0b0000 0001 1011 0011 0100 0010 1011 0011`
2. 必须先看最后7bits的opcode，这样就可以知道是什么指令：`0b011 0011`会发现可能是add/sub/and等等但都是R type指令
3. 所以就可以按照R type的format进行分割：`0b0000000 11011 00110 100 00101 0110011`，再来确定funct7和funct3:`00000000`和`100`。查表发现是xor指令
4. 确定registers：rs2是11011也就是x27(s11)，rs1是00110也就是x6(t1)，rd是00101也就是x5(t0)
5. 拼接一下：`xor t0 t1 s11`

可以看一下ref-card感受一下哪些指令是R类型的，可以感觉到和算数有关的都是R type：

- add
- sub
- and
- or
- xor
- sll
- srl
- sra
- slt
- sltu

其中有一组没讲过的指令：slt(set less than 或者 sltu是 set less than unisgned) 的作用是`rd=(rs1 < rs2) ? 1 : 0`

## I-types

> Immediate types: 立即数类型指令，包含一个立即数（常数）作为操作数

2 registers and 1 immediate，包含：

- 有立即数参与的算数运算
- Loads
- `jalr`
- `ecall`和`ebreak` 这两个指令本质上也是I-types的指令，只是它们忽略了`rd/rs1/imm`这三个部分，本课程也不具体讨论

```text
31          20 19   15 14  12 11     7 6      0
+-------------+-------+-------+-------+-------+
|  imm[11:0]  |  rs1  |funct3 |  rd   |opcode |
+-------------+-------+-------+-------+-------+
   12 bits     5 bits  3 bits   5 bits  7 bits
```

其他都和R type差不多，除了这里的imm部分。注意的是第11个bit是在pos31，一直到0
th bit存储在pos 20.同时也说明I type immediates是12bits的

大部分指令用signed immediates，数据范围是`[-2048, 2047]`，换句话说`addi sp sp -2052`是非法的指令；`addi sp sp 0xFFF`的意思是`add -1`而不是`add 4095`

### `I*-Type`

对于shift操作，我们最大只能移动31位，因此这里imm只需要5bits，因此这些指令有funct7部分

```text
31   25 24    20 19   15 14  12 11     7 6      0
+------+--------+-------+-------+-------+-------+
|funct7|imm[4:0]|  rs1  |funct3 |  rd   |opcode |
+------+--------+-------+-------+-------+-------+
 7 bits 5 bits   5 bits  3 bits   5 bits  7 bits
```

因此，总结一下，I包括I-star类型的指令有：

- addi
- andi
- ori
- xori
- slli （这个是`I*`类型）
- srli（这个是`I*`类型）
- srai（这个是`I*`类型）
- slti
- sltiu
- jalr
- ecall / ebreak 超纲

## S-Type

> Store type: 存储类型指令，将数据从寄存器存储到内存

```text
31    25 24   20 19   15 14  12 11    7 6     0
+-------+-------+-------+-----+-------+-------+
|imm[11:5]| rs2 |  rs1  |funct3|imm[4:0]|opcode|
+-------+-------+-------+-----+-------+-------+
  7 bits  5 bits  5 bits 3 bits  5 bits 7 bits
```

Designed for 2 source registers and an immediate: Store instructions

这种设计里面rs1和rs2的位置是为了和R-type指令里面的rs1以及rs2对齐，也因此将这里的imm拆成了两部分，处理的时候要记得拼起来。

- sb: store byte, 7-0, 8bits
- sh: store half-word, 15-0, 16bits
- sw: store word, 31-0, 32bits

## U type

> Upper Immediate type: 高位立即数类型指令，操作20位的高位立即数

我们之前还一直没有讨论过`lui` 和 `auipc` 这两个指令的作用。

Load Upper Immediate: `lui rd imm`的作用是：sets `rd` to `imm << 12`

Add Upper Immediate to Program Counter: `auipc rd imm`：sets `rd` to `(imm<<12)+PC`

主要用在两个伪指令：

- `li rd imm`
- `la rd Label`

### lui

`li t0 0x12345678`是不成立的，因为这个立即数太大了。但是可以先load最高的5位数字，也就是20bits，利用lui直接shift12位，相当于32bits后面的12bits空出来，然后用addi

```text
lui t0 12345
addi t0 t0 678
```

但是这里也有corner case：

`li t0 0xABCDEFFF`如果仿照上面直接转换：

```text
lui t0 0xABCDE
addi t0 t0 0xFFF // Error
```

问题在于`0xFFF`不是4095而是-1，导致最终t0结果是`0xABCDDFFF`

那么我们提前先+1:

```text
lui t0 0xABCDF // t0 store 0xABCDF000
addi t0 t0 0xFFF // t0 stores 0xABCDEFFF
```

### AUIPC and Relative Addressing

```text
auipc rd immu
-->
imm = immu << 12
R[rd] = PC + imm
```

`auipc`也是主要和`addi`来配合着存储任意的数值，（有点类似上面的lui配合addi），但是主要区别在于：auipc会把结果加到PC上。

那为什么需要这个指令呢？我们想象这个场景：我们的代码很多时候是可以组合起来用的，例如libraries（库），但是将不同代码组合到一起意味着Labels的地址会改变。为了避免这个问题，很多涉及到Labels的指令都用relative addressing而不是absolute addressing：

- Absolute addressing：例如“This label is at location 0x000000FC”。如果代码加载到了内存的其他区域的话，就会出错
- Relative addressing: 例如“This label is 48 bytes after the current line of code.”这样无论代码在哪里都可以正常运行

因此`auipc`经常和`la`指令一起使用。

### U type

```text
31                    12 11    7 6     0
+----------------------+-------+-------+
|      imm[31:12]      |  rd   |opcode |
+----------------------+-------+-------+
       20 bits          5 bits  7 bits
```

U-type的指令就是给需要20bits的立即数的指令：

- `lui`
- `auipc`

需要注意的是指令本身里面的立即数和我们实际处理的不太一样，指令里面没有存储立即数的低12bits，也就是说当指令是`lui t0 0x12345`，我们实际上所指的立即数是`0x12345000`，也就说`0x12345`存储到了20bits的位置上，而不是`0x00123`

## B types

> Branch type: 分支类型指令，条件跳转指令，根据比较结果决定是否跳转

### Labels

我们先来简单看一下Labels的概念：Labels并不是真实存在的，尤其是当我们把RISC-V代码转换成binary格式的时候，我们需要把 labels 转换成explicit references to a particular line of code。

而且正如我们之前提到的，我们希望用relative addressing。

具体的方法就是将指令里面的label替换成一个offset，这个offset说明需要从当前行代码跳转多少个bytes才能跳转到那个标签。

下面通过一个具体例子来说明究竟如何 Converting Labels into offsets，重点关注注释部分里面的offset是怎么计算的。

```text
		beq x0 x0 target # +2 instructions = 8 bytes, so offset=8
		addi x0 x0 100
target: addi x0 x0 100
		j target # -1 instruction = -4 bytes, so offset=-4
		li t0 0x5F3759DF # The li here is actually 2 instructions
		beq t0 t0 target # -4 instructions, so offset=-16
```

**尤其要注意**：上面的li是一个伪指令，实际上展开为两条指令，所以最后的beq的offset是-16！

可以想象，因为每个指令都是32bits也就是4字节，因此差多少条指令，对应的offset就要乘上4.

那么进一步推理，如果我们把所有的offset作为有符号数存储，所有的last two bits都是0（乘以4对应二进制类似左移2位）。但同时，我们用来存储立即数的bits是有限的，也就是说这会限制我们能够跳跃的距离。

但是实际上有一部分RISC-V拓展用的是16-bit指令，因此我们不能盲目认为最后2bits都是0。最终我们的实际做法是不存储offset的最后一个bit。

### B-Type

```text
31           25 24 20 19 15 14    12 11          7 6       0
+--------------+-----+-----+--------+-------------+--------+
| imm[12|10:5] | rs2 | rs1 | funct3 | imm[4:1|11] | opcode |
+--------------+-----+-----+--------+-------------+--------+
    6+1 bits      5     5      3         4+1 bits   7 bits
```

B-Type指令也用两个source registers和一个立即数，所以格式和S-Type很像，因此有时候这种格式称为SB-Type

立即数一共有13bits，数据范围`[-4096, 4096]`，也就是1024条指令。

总共有以下这些B-Type指令：

- beq
- bne
- blt
- bltu
- bge
- bgeu

## J-types

> J type: 跳转类型指令，无条件跳转指令

J-Type指令只有一个destination和一个立即数，所以我们可以用U-Type的格式来添加额外的立即数位，因此有时候这种格式也叫做UJ-type指令。

尤其要注意这里的立即数的格式更加奇怪，假如我们要存储`0b A BCDE FGHI JKLM NOPQ RSTU`（这里每一个字母代表一个bit），最终存储的格式是`0b AKLM NOPQ RSTJ BCDE FGHI`

可以看到：

1. 最后一个bit（也就是上面例子里面的U）没有存储
2. bits19-12和U类型的位置一样
3. bits10-1和I类型的位置一样

Jumps可以操作21-bit的立即数，也就是向上/向下$2^{18}$条指令。

J-type指令有：

- jal

```text
31  30      21 20  19     12 11    7 6     0
+--+---------+--+---------+-------+-------+
|imm[20]|imm[10:1]|imm[11]|imm[19:12]| rd |opcode|
+--+---------+--+---------+-------+-------+
1bit   10bits  1bit  8bits    5bits  7bits
```

## Summary

TODO: 下面这个不同类型的指令的表格需要有个更好的展示形式，并且缺少`I-* type`

```text no-wrap
Bit Position: 31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10  9  8  7  6  5  4  3  2  1  0

R-type:       [    funct7    ] [  rs2  ] [  rs1  ] [funct3] [  rd   ] [  opcode  ]
I-type:       [         imm[11:0]         ] [  rs1  ] [funct3] [  rd   ] [  opcode  ]
S-type:       [ imm[11:5] ] [  rs2  ] [  rs1  ] [funct3] [imm[4:0]] [  opcode  ]
B-type:       [imm[12]] [imm[10:5]] [  rs2  ] [  rs1  ] [funct3] [imm[4:1]] [imm[11]] [  opcode  ]
U-type:       [              imm[31:12]                ] [  rd   ] [  opcode  ]
J-type:       [imm[20]] [    imm[10:1]     ] [imm[11]] [imm[19:12]] [  rd   ] [  opcode  ]

```

### How to handle immediates larger than you can store

#### R和U

不需要，因为R指令根本没有立即数部分，U指令不需要超过它能表示的位数的立即数

#### I和S

- 对于算数运算，可以先讲立即数放进一个寄存器里面：`xori t0 t1 0xDEADBEEF`可以用`li t2 0xDEADBEEF | xor t0 t1 t2`来代替
- 对于load和store，可以先相加计算出offset，然后0-offset load，例如`lw t0, 0x12345678(x0)`可以替换成`lui t1, 0x12345 | lw t0 0x678(t1)`

#### B和J

- 如果Branch在1024条指令内，正常操作`beq t0 t1 Label`
- 如果Branch超过了1024条指令，就反转branch条件，然后用j指令跳转，例如`bne t0 t1 Next | j Label | Next: ...`
- 如果Jump在$2^{18}$条指令内，正常跳转`j Label`
- 如果Jump的超过了$2^{18}$条指令，那么就用auipc配合jalr立即数：`auipc t0 0x12345 | jalr ra t0 0x678` (jalr负责剩余的低12bits立即数部分)

### Summary

更多的参考信息请看：https://cs61c.org/su25/pdfs/resources/reference-card.pdf
