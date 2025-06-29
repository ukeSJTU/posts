Link to slides: [here](https://docs.google.com/presentation/d/11jtwKiPnlgU2FnnZt7qaw107IU10n3Im0T9kX6IDDCU/edit?slide=id.g3677d2b82f0_0_59#slide=id.g3677d2b82f0_0_59)

Binary

- Binary and Hexadecimal
- Representing Data using Binary
- Binary Mathematics

Binary 用01存储，可以用`0b`作为前缀。二进制数据本身没有含义，取决于怎么解读。

Representation scheme。最理想的情况，shceme应该要满足：

- Represent data that's relevant to whatever we're making
- Store things efficiently
  - Optimal memory use
  - Efficient operators
- Be intuitive for humans to understand

上课先从 unsigned numbers 开始讲解。

需要记住 $2^1$ 到 $2^16$ 对应的十进制以及0-15对应的二进制

因为$2^10=1024\approx 1000$ 所以可以进行估算

因为二进制数写起来太长了，所以经常用16进制/8进制来表示

16->2: 一位变成4位
2->16：从后往前4位变成1位

8进制与2进制转换同上，但4位变成3位

其他进制都是通过下标表示：$43_5==23$

下面进入Representing Data using Binary。那么如何表示Nonnegative 整数

1. （python/实际的数学表示）类似的方法，将整数当作一个长度可变的数组
2. fixed bitlength。像C一样，一般固定n-bit unsigned integers覆盖了0到$2^{n-1}$。那么这个就需要完整的n-bit包括leading zeros。同时需要超过maximum values时候的特殊处理

那么二进制也可以表达Boolean Values
1是True，0是False
同时4种运算符 OR,AND,NOT,XOR

下面进入Binary Mathematics，首先是 Bitwise Operations
在C里面有 `&` `|` `~(tilda)` `^(caret)`, `<<` `>>`
前四个分别是AND/OR/NOT/XOR这些operators，先将数字转换成binary，然后对each pair of bits使用
后两个是left/right shift，向左移动二进制数，append 0s或者向右移动二进制数，prepend 0s，多出来的bits直接省略。在本课中，用$<<_{10}$表示将十进制数向左移动，$1234<<_{10}==12340$。右移同理

C还允许常规的数学运算加减乘除取余大于小于等等。这些在二进制数上运算规律和十进制基本一致。但是需要处理“正确的”运算产生的yields a number outisde range PPT上举例如下，假设是8bit unsigned integers：

- 200 + 200 或者 100 x 4 或者 100 << 2 这些都是going too high (overflow)
- 100 - 200 going too low 但是也叫overflow
- 10/3 fraction result

对于小数结果，当作floor division 也就是类似python的`//`; 对于too big/small的数学结果，wrap around，也就是说 最大的数+1就会变成最小的数，`255 + 1 == 0`。它的等价计算方法是：

1. 将结果 mod $2^n$
2. 或者是看作只取结果的lowest n bits

---
