RISC-V Basics(2/2)

## Agenda

- Data Transfer
  - Main Memory
  - Instructions
  - Example
  - Long Example
- Control
  - Instructions
  - Loops
- Summary

这里最一开始仍然是上一讲最后的部分（Instructions for Data Transfer) 所以我整理笔记的时候放到lec06的笔记里面去了

---

## Control

C的代码通常是一行接一行运行的，但是控制流程意味着有时候要jump到其他行去，：

- if 这样的控制叫做 conditional jump
- 调用函数这样的叫做unconditional jump

### Instructions

**Jump Syntax**

`beq rs1 rs2 Label`，Labels标记了lines of code with names，或者写作伪代码`j Label`

Branch if EQual -> `beq` 会检查两个寄存器里面的值是否一样
Branch if Not Equal -> `bne`

同样的还有其他Control Flow：

| Instruction | Name / Description                 |
| ----------- | ---------------------------------- |
| beq         | if equal                           |
| bne         | if not equal                       |
| blt         | if less than (signed)              |
| bge         | if greater than or equal (signed)  |
| bltu        | if less than Unsigned              |
| bgeu        | if greater than or equal Unisigned |
| j           | unconditional Jump                 |

为什么没有bgt或者ble？

它们可以看作伪指令，例如ble本质上是：

```text
ble rs1 rs2 Label
也就是
bge rs2 rs1 Label
```

### Loops

C里面有3种循环：for，while，do-while。但是显然三者可以相互转化。而在RISC-V中我们仍然用的是jump，因此可以这样转化：

```c
// 原始代码
int arr[20];
// ...
int sum = 0;
for (int i=0; i<20; i++) {
    sum += arr[i];
} // ...
```

先变成while循环

```c
// while 循环
int arr[20];
// ...
int sum = 0;
int i = 0;
while (i < 20) {
    sum += arr[i];
    i++;
} // ...
```

然后变成infinite loop：

```c
// 无限循环
int arr[20];
// ...
int sum = 0;
int i = 0;
while (true) {
	if (i >= 20) { break; }
    sum += arr[i];
    i++;
} // ...
```

到这一步就可以开始向汇编转换，先规定`arr <-> t0, sum <-> t1, i <-> t2`

1. 给`while(true)`这一行添加Loop的标签，循环结束的位置添加End标签
2. while内部第一行是判断是否退出循环，因此`if (i >= 20) { break; }`等价于`li t3 20 | bge t2 t3 End`（如果大于等于就跳转到循环外部）
3. Loop部分的最后一行应该重新回到循环的开始也就是 `j Loop`

```text
      # ...
Loop: li t3 20
      bge t2 t3 End
      # Fill in the rest on your own!
      # 这里的剩余代码答案可以在PPT最后的补充中找到

      j Loop
End:
```

## Summary

### Arithmetic

- add
- sub
- and
- or
- xor
- sll
- srl
- sra

### Immediate

- addi
- andi
- ori
- xori
- slli
- srli
- srai

### Memory

- lw
- lb
- lbu
- sw
- sb

### Control

- beq
- bne
- bgt
- blt
- bgeu
- bltu
- j
