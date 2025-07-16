## AGENDA

- Endianness
- Function Pointers
- Void Pointers
- Floating Point
  - Simplified Model
  - Optimizations
  - IEEE 754

## Endianness

Two main ways:

- Big endian 就是比较符合直观顺序的，MSB的内存地址更小（come first）
- Little endian 反过来

可以和日期进行类比，有不同顺序。

- Europe 30-6-2025 类似little endian
- China/Japan 2025年6月30日 类似big endian
- US：6/26/2025 好比 middle endian

little-endian在系统架构里面非常常用，unless otherwise stated；但是在network中，big-endian更加常用。

在创建arr的时候，会把数据根据endianness存入每一个内存位置；读区的时候，读取4个bytes然后按照正确顺序进行组合。

两种endianness在C都可以工作，但是尝试将int分割成chars然后读取单个char是undefined behavior

写的时候和读取都要记住注意endianness

对于：

- 变量间的顺序，由编译器和alignment规则决定，endianness不影响
- 多字节变量内部，endianness决定字节顺序
- 单字节变量：endianness对其无影响（只有1个字节）

## More Pointers

Pointers can point to more than just variables.

### Function Pointers

类似：`int *(*fp) (int, int)`

具体用法：

```c
int *(*fp) (int, int) = &foo;
int *(*fp) (int, int) = foo;    // '&' Can only be omitted for function pointers
```

To use:

```c
(*fp)(x, y)
fp(x, y) // Can only be omitted for function pointers
```

推荐还是要写上`&`, `*`等等符号。去掉这些符号和python里面HoF用法类似，但本质上是不一样的。

### Generic Pointers

类似：`void* p`

首先，为什么要用generic functions？想要write general-purpose code这样同一个功能可以处理不同类型的输入数据。总的来说：

- Generics should work for any argument type
- Updates blocks of memory regardless of data types

`void*`指针不是pointer to nothing 而是 pointer to anything，因此要注意：

- 永远不可以对`void* `指针解引用，因为会得到void。但是`**doubleptr`是可以的，解引用得到一个void pointer
- 不能对`void* `指针进行算数运算
- 可以safely automatically转换成其他类型的指针，但不能变成函数指针

实际的用法可以在C对于内存的操作中看到：

- `void* memcpy(void *dest, void *src, size_t count)` 速度很快，但是如果src和dest有重合的地方的话是undefined behavior
- `void* memmove(void *dest, void *src, size_t count)` 速度比较慢，但不会有上面的问题

这两个函数都返回 a copy of `dest`。如果src或者dest二者中任意一个invalid或者是NULL的话会fail

`void* pointer`的好处也可以从下面看出来：

```c
// 多种数据类型的swap
void swap_ints(int *x, int *y) {
	int tmp = *x;
	*x = *y;
	*y = tmp;
}
void swap_floats(float *x, float *y) {
	float tmp = *x;
	*x = *y;
	*y = tmp;
}
void swap_strings(char **x, char **y) {
	char *tmp = *x;
	*x = *y;
	*y = tmp;
}
// ----- 应该是下面这个样子 -----
void swap(void *x, void *y) {
	/* Save x in tmp
	 * Copy value in y to x
	 * Copy value in tmp to x        */
}
// 当然会注意到上面这个代码存在问题，就是因为用了 void *，我么不知道传入的数据类型是什么，也就是不知道具体的内存大小，因此需要添加一个新的 size_t nbytes
void swap(void *x, void *y, size_t nbytes) {
	char tmp[nbytes];  // create space to hold x
	memcpy(tmp, x, nbytes); // save value of x in tmp
	memcpy(x, y, nbytes); // copy value in y to x
	memcpy(y, tmp, nbytes); // copy value in tmp to y
}
// --> 因为 sizeof(char) == 1, 所以说char可以算作C版本的byte类型
```

上面最后的这个generic swap为什么不能替换成 `*x = *y`?因为这样我们相当于在dereferencing `void*`!!!

#### Generic Functions on Arrays

如果需要对 `void *` 指针做pointer arithmetic的话，需要先 cast！下面是个具体的例子。

给定之前的swap函数，怎么实现`void swap_ends(void *arr, size_t nelems, size_t nbytes)`

```c
void swap_ends(void *arr, size_t nelems, size_t nbytes) {
	void *start = arr;
	void *end = (char *)arr + (nelems - 1) * nbytes;
	swap(start, end, nbytes);
}

// 如果不是void *来传递数组的话，我们一般可以 &arr[nelems - 1]，
// 但现在的问题是转换成char *后，每次pointer只会移动1 byte，可能会和原本的数据匹配不上
// 因此需要乘上 size of element
```

## Floating Point

Storing Data in Binary

之前我们讨论了很多数在计算机的表示，现在还剩最后一个：浮点数。

先简单回顾一下一个scheme的要求是什么？

目前的版本是IEEE-754，但在这之前有很多优化导致表示方法非常复杂。

对于浮点数来说，我们想要handle：

- 非常大的，阿伏加德罗常数
- 非常小的，普朗克常量

值得注意的是，当要表示的数越来越大，我们越来越不关心最后几位微小的差异。所以最终的目标就是，存储relative precision

科学计数法 Scientific Notation，对$6.022\times 10^{23}$:

- 1 bit 存储正负号
- 4 decimal digits 6022
- An exponent 23

下面我们先提出最基本最直观的一种存储方法，然后不断探索该方法存在的限制，再进行优化，最后得到现行标准IEEE-754标准。

### V0

首先按照前面的讨论，一个浮点数我们要存储：

- Sign bit
- Mantissa：没有前导0的正数
- Exponent：可以是正数或者负数

例如：`0b1.011 * 2^5 = 1.375 * 2^5`

Mantissa 就是 positive integer所以可以按照unsigned number进行存储。

那怎么存储exponent？三种方法：

- Sign Magnitude
- Bias
- 2‘s complement

具体怎么选择首先要看和floats以及ints相关的运算。

- 加减：首先是加法，两个科学计数法相加的结果基本只影响exponent，结果近似于两者中较大的一个
- 乘除
- 比较

会注意到，加减乘除对于运算都是不够确定的。但是比较两个科学计数法表示的数可以通过exponent的相对大小直接看出来，所以可以选择Bias存储方法。

进一步，浮点数的三个组成部分按照sign-exponent-mantissa的顺序存储，这样sign-exponent可以重复使用sign-magnitude的比较电路。

对于n-bit exponent，一般将bias设置成$-(2^{n-1}-1)$ 这样正数和负数的数量比较接近。

### V1

正如我们上面提到的，浮点数的存储顺序：sign-exponent-mantissa。在这里，我们给exponent 3bits，mantissa4bits，也就是下面这个样子：

```text
S XXX MMMM
```

它表示的数是：$(-1)^S\times 0bM.MMM \times 2^{(0bXXX+(-3))}$

下面简单通过10进制2.75转换成我们的V1版本的浮点数表示作为例子：

1. 2.75在2进制是0b10.11, 也就是 `0b1.011000... * 2^1`
2. 计算出Sign / Exponent / Mantissa
   - Sign: positive所以是0
   - Exponent：1，所以减去bias -3也就是4，换成二进制0b100
   - Mantissa：0b1011
3. Concatenate拼接起来也就是`0b0 100 1011` = `0x4B`

下面拓展到8-bit exponent（也就是-127的bias）以及23-bit mantissa。
将`0xC3CC0000`的V1版本的float转换成10进制：

- 上面的16进制等效成：`1 10000111 10011000000000000000000`
- 也就是说Sign是1，代表负数；Exponent是`0b1000 0111`也就是`135+(-127)=8`
- Mantissa部分：`0b1001 1000...`代表$1+2^{-3}+2^{-4}$
- 总的就是$(1+2^{-3}+2^{-4})*2^8=2^8+2^5+2^4=304$

再考虑下面这个稍微特殊一点的例子：`0x0000 0000`，

- Sign是0，说明是正数
- Exponent是-127
- Mantissa是0
- 总的就是$0\times 2^{-127}=0$

### V2 with Optimization 1: The implicit 1

可以注意到mantissa部分按照我们前面的定义是没有前导0的。而二进制里面不是0就是1，并且mantissa的MSB一定不是0，那么只能是1，这样我们就可以不存储的第一位的1了。这种存储的方法也叫normalized number也就是规格化

由此：

```text
S XXX MMMM
```

就可以表示：$(-1)^S\times 0b1.MMMM \times 2^{(0bXXX+(-3))}$

还是2.75的那个例子，其他都一样但是这一次mantissa是：0b0110

但是值得注意的是，在V2版本的表示中，`0x0000 0000`但表$1\times 2^{-127}$，而`0x0000 0001`代表$2^{-127} + 2^{-150}$

#### Problems with implicit 1: Underflow

从上面可以看到，V2版本的浮点数表示最小的（abs）是$2^{-127}$，也就是说我们表示不了0，第二小的就是$2^{-127} + 2^{-150}$

这个问题叫做**underflow**，也就是说计算结果太小以至于表示不了。这里如果想要更加形象的解释可以看HW2配套的一个讲解视频：https://www.youtube.com/watch?v=VeZad7r94Pc

为了解决上面的问题，我们提出下面这种办法：

### V3

对于`S XXX MMMM`而言

- 如果exponent bits是非0的，那么表示方法不变
- 如果exponent bits全是0，那么它表示：$(-1)^S\times \text{0b0.MMMM}\times 2^{(0b000+(-3)+1)}$ 这个也叫做denormalized number或者denorm。这个和前面的V2略有不同，因为这里不再规定mantissa一定是1开始的，所以也叫做非规格化。

这种做法牺牲了一定的精度，但是至少能够表示0，并且平滑的处理underflow的问题。

例子1:`0x0000 0000`转换成10进制：

- Sign：0，正数
- Exponent：全是0，所以是0+(-127)+1=-126
- Mantissa: 0
- 放在一起：0

例子2:`0x0000 0001`转换成10进制：

- Sign：0，正数
- Exponent：`0b0000 0000`仍然全是0，对应-126
- Mantissa：`0b000...1`也就是$2^{-23}$
- 总的来说是$2^{-149}$。可以看到这个比前面的V2版本里面的$2^{-127} + 2^{-150}$ 要更靠近0.

#### Optimization 2: dealing with infinity

在前面的表示方法下，如果是8-bit exponent，我们已经可以表示$10^{38}$这么大的数，但是我们还想要更够表示更大的数来处理类似“除以0”的这种操作。

既然是想要表达最大的数，那么可以考虑exponent全是1，也就是添加下面这个新的规则：

如果exponent都是1，然后

- mantissa部分全0，根据sign bit要么是正无穷大，要么是负无穷大
- 如果mantissa不全是0，那么就是NaN，not a number

### 总结：IEEE-754

IEEE-754规定了五个方面：

1. Arithmetic formats：
