Integer Representations

- Unsigned numbers
- Sign-Magnitude
- Bias
- 2's Complement
  C Introduction
- Hello World!
- Compiled vs Interpreted Languages
- C vs Java
- Variables and Types
- `printf`
- Miscellaneous Syntax

先简单回顾一下上节课lec01的unsigned numbers
无符号，也就是不考虑负数。主要用在不需要负数或者处理bitwise operations的时候。C内置了 unsigned int/long 等等，但是不同系统长度不同，可以通过类似`uint8_t/uint16_t`这样的来规定长度

那么下面就会思考，假如我们要表示负数该怎么做？
第一种方法就是Sign-Magnitude，也就是第一位作为符号位（0+，1-）剩余的bits存储数字的abs。这种表示方法有两个问题：

1. 0被存储了两次，+0和-0
2. 计算效率不高，“比较”和“加减”需要对sign bit符号位进行处理。

第二种方法是Bias，相当于在原本的0， 255区间上加上一个bias，这个bias可以是-127或者-128，只要最后positive numbers和negative差不多就行。所以现在的`0b0000 1001`可以理解成`9+(-127)==-118`。由此可见，最小的数是-127，最大的数是128。但是这个方法的问题是：

1. 算数运算效率变低
2. 并且这个bias没有办法从8-bit中直接得到，所以需要在系统中某种方式记录这个bias导致不是很intuitive

这种bias方法主要用在数据只会被用来比较，而不是用来加减。例如生活中的温度。我们一般只关心冷热，温度高低，而不会直接将1摄氏度与100摄氏度相加，这个没有意义（除了化学实验等等）

第三种方法就是2's Complement Numbers 补码。首先这种方法的核心思想来自于前面处理 unsigned numbers的时候，我们通过对$2^n$取余来处理overflows，也许我们可以同样的处理负数:

1. 如果leading bit是0，那么当作unsigned来处理，也就是positive numbers。0b0001 0001=17
2. 如果leading bit是1，那么当作unsigned来处理，然后减去$2^n$，negative numbers。0b1110 1111=239-255=-17

对于补码而言，如果要乘以-1，例如17变成-17，相当于flip bits，然后+1。PPT P23有个简短的证明。

补码也是C中对于 有符号数 signed integers的存储方式。

---

下面C introduction

function-oriented。返回0表示成功，非0-failure。按照上课提问应该也可以不返回，编译器自动处理。

然后提到Compiled Languages。作为对比，Java转换成architecture-independent字节码，当运行的时候再编译，这种机制叫做JIT。Python是在运行时转换成字节码。

而这个课程使用C语言，C的编译器是将C语言代码转换成architecture-specific的machine code。这样的优点是：

- 运行速度快，因为optimize for a given arch
- 等等，不重要
  但是也有缺点：
- 不同系统要重新编译
- 修改代码后运行前要重新编译导致开发变慢

后续是一些简单的C和Java语法对比

省略……

然后是 Variables and Types

在C语言中，变量没有初始值。
这里还提到了Undefined behaviors：

- 不可预测
- 不同电脑行为不同
- 多次运行结果不同
- 大多数时候运行正确，但少时候运行错误
- 导致“Heisenbugs”

```c
int x = 4;
x = 'a'; // Warning not an error
```

C的类型是statically-typed。但是C允许你给错误类型的变量赋值，它就直接用二进制来处理。

int的大小不同计算机不同，但是C保证顺序：`sizeof(int) <= sizeof(int) <= sizeof(long)` 其中sizeof是一个C的运算符，它返回**given type**有多少字节。

bool其实不是一个C的primitive type（C23添加bool为一个built-in 类型）

### printf

`%`是 format specifier。会被第一个arg直接替换（当作string）

常见的如下：

| format | type                |
| ------ | ------------------- |
| `%d`   | signed int          |
| u      | unsigned int        |
| x      | hex lowercase       |
| X      | hex, uppercase      |
| s      | strings             |
| c      | chars               |
| f      | floating point      |
| `%%`   | % sign itself       |
| e      | scientific notation |
| p      | pointers/mem addr   |

## Miscellaneous Syntax

const 定义常量。任何var都可以声明为const

`#define`是一个C 预处理器Macro（宏），工作模式类似find-and-replace

enum：a group of options

```c
enum cardsuit{DIAMONDS, SPADES, HEARTS, CLUBS};

enum cardsuit suit;
suit = DIAMONDS;
```

添加自己的变量类型：`typedef`和`struct`

typedef允许给已经存在的类型定义新的名字：`typedef uint8_t BYTE`
struct允许你定义structured group of variables

```c
typedef enum cardsuit{DIAMONDS, SPADES, HEARTS, CLUBS} suit_t;
typedef struct cardstruct {
	int rank;
	suit_t suit;
} card_t;

card_t card;
card.rank = 1;
card.suit = SPADES;
```

需要注意的是：

1. struct和class类似但是没有methods这种概念
2. define工作模式和find-and-replace类似，甚至可以用来“定义函数”

这里这个例子需要观察：

```c
#define distance(x,y) x*x+y*y
int f(int n) {
	printf("%d\n", n);
	return n;
}
```

调用`distance(1+2, f(4))`会被编译器替换成 `1+2*1+2+f(4)*f(4)`，并且在运行的时候会输出两次4.
