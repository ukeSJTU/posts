RISC-V basics(1/2)

## Agenda

- The RISC-V ISA
- CPU Anatomy: Registers
- Instruction Anatomy
  - Our first instruction
  - Immediates, Zero
  - The rest of arithmetic
  - PseudoInstructions
- Data Transfer
  - Main Memory
  - Instructions
  - Example

## The RISC-V ISA

1946 ENIAC: 是要通过物理连接电线来执行操作
1949 EDSAC: 是第一个General **Stored-Program** Computer，这样就不需要每次输入程序，而是可以存储起来

### Assembly Language, ISAs

CPU的工作就是execute lots of **instructions**. Instructions就是CPU可以进行的所有操作。就像语言有verbs和objects，在instructions里面我们有operations和operands。

An Instruction Set Architecture (ISA) defines the operations an CPU supports, and how they are implemented：

- **Assembly Language**: the low-level CPU instructions
- **Machine Language**: how the instructions are represented in bits

那么RISC-V defines instructions for CPU down to the bit level：

```text
add x3 x2 x1
-->
0000 0000 0001 0001 0000 0001 1011 0011
```

## CPU Anatomy: Registers

冯诺伊曼架构，a basic model of a computer has two parts:

- Processor (CPU)
- Memory (RAM)

5GHz的处理器，相当于每一个指令0.2ns。而光速1ns只移动one foot。Memory需要大约100ns，因此CPU在registers里面读取数据。

Registers是CPU的一部分，因此它的数量也是由ISA确定的：

- RISC-V一共有32个寄存器。
- 每一个寄存器是32bits，也就是4 bytes。这个在RISC-V里面叫做1 word
- 后续我们会用`R[register]`的记号来表示获取该寄存器存储的数值。

## Instruction Anatomy

**Register-Register Arithmetic Syntax**

`add rd rs1 rs2`分别是Operation，destination，以及两个source。

RISC-V的syntax非常rigid死板（1 operator以及3 operands），这样的好处是可以简化电路。（我们后面几周会更具体的看到这一点）

比如说加减运算：

- `add x1 x2 x3`就是`int x1 = x2 + x3;`
- `sub x1 x2 x3`就是`int x1 = x2 - x3;`

那么我们将RISC-V和高级语言例如C进行对比会发现：

- C里面变量类型决定了具体的运算操作，例如同样是加法，根据参与加法运算的变量类型不同，实际加的结果会不一样：`int x = 1 + 3; 和 int *p = arr + 2;`是不一样的
- 但是在RISC-V里面是Operation determines the type: 寄存器需要根据具体的operator才能知道到底是value还是addr还是其他。

同时也要注意到C里面的一行内容可能会变成多行RISC-V内容。

### Immediates， Zero

常量在RISC-V里面叫做Immediates立即数，许多算数指令可以将它们当作operands：

```text
addi rd rs1 imm
```

但可以注意到没有subtract immediate instruction，这是因为在**R**ISC里面，如果一个instruction可以分解成其他已经存在的operations，那么就不要添加到ISA里面去。

#### Register Zero

zero是非常常用的，所以RISC-V直接将x0这个寄存器hard wire到了0，意味着：

- `R[x0] == 0`是 **硬件** 来定义的
- 向 x0写入东西没有用
- 对后续的伪指令有帮助

### The rest of arithmetic

#### Bitwise operations

| 操作 | C 语言表示法                | RISC-V 指令 (R型)                    | RISC-V 指令 (I型)                      |
| ---- | --------------------------- | ------------------------------------ | -------------------------------------- |
| AND  | `0b1001 & 0b0111 = 0b0001`  | `and rd rs1 rs2`                     | `andi rd rs1 imm`                      |
| OR   | `0b1001 \| 0b0111 = 0b1111` | `or rd rs1 rs2`                      | `ori rd rs1 imm`                       |
| XOR  | `0b1001 ^ 0b0111 = 0b1110`  | `xor rd rs1 rs2`                     | `xori rd rs1 imm`                      |
| NOT  | `~0b1001 = 0b0110`          | `not rd rs1 rs2` (伪指令)            | N/A                                    |
| 左移 | `0b0001 << 3 = 0b1000 = 8`  | `sll rd rs1 rs2`                     | `slli rd rs1 imm`                      |
| 右移 | `0b1001 >> 2 = 0b0010 = 2`  | `srl rd rs1 rs2`<br>`sra rd rs1 rs2` | `srli rd rs1 imm`<br>`srai rd rs1 imm` |

关于SHIFT操作，之前也学到过，左移相当于乘法，右移相当于除法，那么移动后多出来的bits上该填充什么？显然Left Shift应该是填充0，也叫做Logical left shift（sll），但是右移呢？我们分为：

- Logical right shift, srl, add zeros是填充0：`9 >> 2 == floor(2.25) == 2`
- Arithmetic right shift, sra, sign extend是会保留符号的 `-9 >> 2 == floor(-2.25) == -3`

从上面这两种右移的对比也可以体现出我们前面说的：“RISC-V里面是Operations determine type(how register bits are interpreted)”

### Pseudo-instructions

不是真的指令，因为我们可以用已经存在的多条指令来做到同样的事情。当进行汇编assemling的时候，汇编器会自动将伪指令替换成等价的真的指令：

Load immediate就是一个伪指令：`li a0 3` --> 真实的指令应该是：`addi a0 x0 3`

## Data Transfer

那么很显然的问题就是寄存器可能不够用，因此需要指令能够将寄存器里的数据store to内存中，或者load 数据 from内存到寄存器中。

### Main Memory

RISC-V是little-endian的，也就是LSB得到least address。the address of the word is also the lowest address.

### Instructions

**Register-Memory Operation Syntax**

```text
lw rd imm(rs1)
```

注意到这里的新语法：`M[addr]`代表的意思是：go to memory and find the value at addr

#### Loading from Memory

`lw rd imm(rs1)`也就是`R[rd] = M[R[rs1] + imm]`，也就是：

- 先计算内存地址：`R[rs1] + imm`
- 然后从那个地址读取4个字节到`R[rd]`里面去

#### Storing to Memory

`sw rd imm(rs1)`也就是`M[R[rs1] + imm] = R[rd]`，也就是：

- 先计算内存地址：`R[rs1] + imm`
- 然后从`R[rd]`中存储4个字节的数据到那个地址上

#### Loading and Storing Bytes

上面都是word为单位的操作，RISC-V还支持bytewise数据移动

```text
lb rd imm(rs1)
sb rd imm(rs1)
```

那么问题就是：RISC-V是32bits，4字节的，怎么store/load一个字节呢？这就需要依靠它的SPEC来规定：

`sb`指令，我们store LSB

`lb`指令，我们仍然是load LSB，但是剩下的部分呢？RISC-V让程序员自己决定：

- `lb`: 对于有符号数，sign-extend，也就是按照MSB来填充
- `lbu`： 对于无符号数，zero-extend，也就是用0来填充

### Example

这里直接省略

### Long Example

这里有一个值得注意的是：`char b[] = "string";`并不是通过重复`li t0 0x73; sb t0 -12(sp)`这个样子来一个一个字符的存储，而是可以将4个字符当作一个word（也就是4 bytes）一起存储的，这个一定要记得考虑endianness
