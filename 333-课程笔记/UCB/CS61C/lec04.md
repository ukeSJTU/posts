C - Generics
但我看来是 C Memory Model, Endianness, Strings, Generics

## Strings

### ASCII

如何表示字符

2\^8=256和字符对应。ASCII算是current standard

> C不区分chars和8-bit integers: '2'->50 in ascii, so '2' + '2' = 100 -> 'b'

不需要背ASCII，但可以知道几个flag HEX常数，例如:

- 0x31->1
- 0x41->A
- 0x61->a

### Strings

C里面的String类似python。也就是 `char[]`, `char*`。问题在于C不知道string的长度：

1. 用另一个变量存储“长度”
2. 用一个特殊END标记字符串结束

NULL，`\0`

比如说"Hi"就是`{'H', 'i', '\0'}`或者说`{72, 105, 0}`。string literals的NULL会被自动添加，但是自己的处理string一定要考虑这个问题。否则C就会一直读取下去。

## C Memory Model

从内存地址高到低分别是：

- Stack
- Heap
- Static/Data
- Text/Code

### Memory Structure - Code/text

Executables are data
code segment存储的是actual bytecode，它们代表程序的实际内容

固定大小，加载程序后理应不变

这里也会包含一些constants, 是“built-in”的那些，例如`x = y + 1`里面的1，因为这个1是程序的一部分。对于编译器来说，这种整型字面量可以转化成`ADD EAX 1`这样的指令，1转化为二进制`0000 0001`从而和代码本身一起放在.text段

### Memory Structure - Static/Data

存储所有大小固定的东西：

- Global vars 全局变量
- String Literals 字符串字面量。这里需要注意，C里面可能会有两种写法：
  1.  `char* i = "Hi"`。首先C将"Hi"放到data段，并且在stack上申请一个4字节（32位）的内存存放i，然后i指向Hi所在的内存地址。正因为这个Hi的实际数据是在Static/Data上的，所以`i[0]='P'`这样的修改是错误的，没有编译错误，但是运行时出现BusError错误。
  2.  `char[] i = "Hi"`。首先C将"Hi"放到data段，然后计算出这个字符串是3字节，随后在Stack上申请3字节的空间来存储i，并将static段里面的"Hi"复制到栈上的空间。这个时候i里面是这个字符串的一个副本，所以可以修改。

Stack和Heap比较难，所以单独分出下面的sections

### 关于DEFINE的问题

实际上DEFINE是preprocessor macro，也就是说在正式编译前，文本内容已经被替换了。例如下面的代码：

```c
#define AGE 30

void my_function() {
    int current_age = AGE;
    int next_year_age = AGE + 1;
}
```

在编译器看起来就是：

```c
void my_function() {
    int current_age = 30;
    int next_year_age = 30 + 1;
}
```

替换后的内容就根据它们各自的规则进行替换（例如30是整型字面量，放到code/text段）

## Stack

有点类似61A的Env Diagrams

Stack Pointer (sp)

temporary storage, 当从函数返回的时候就 free 这一部分

stack的大小是动态变化，当调用函数的时候grows downward，从函数返回的时候就shrink。形成连续的block of memory

**所有的局部变量local variables**都是在stack上的

stack底部有一个 stack pointer

由此产生的常见C Bug：就是在一个函数内返回一个pointer指向函数内的local vars。但是反过来，上层的可以给调用的函数传递pointers（caller to callee is ok, but callee to caller not)

## Heap

为什么需要Heap。因为Stack上的返回就消失。

在C里面，heap上内存是要manually allocated。同样要手动释放，没有 Garbage Collector

Heap是Grows upward，所以理论上Heap和Stack的内存不会冲突。Heap有一个自己的Heap Pointer hp.

> 这里的Heap和数据结构没有任何关系

Heap的内存远大于Stack，而且不是连续的。

系统本身有一个*memory manager*，需要ask for permission from the manager。下面就看看具体怎么申请/释放Heap上的内存。

> 下面这些代码都要引入 `#include <stdlib.h>`

### malloc

`void* malloc(size_t n)` 申请n个连续的字节。不会清楚空间内的数据，如果找不到足够内存会返回NULL。

具体可以这样用：`int* a = malloc(10000);` 我这里原本有疑惑，按照函数签名，返回的是`void*`怎么变成的`int*`，按照gemini的解释，`void*`是比较特殊的一类指针，可以隐式转化成左边的指针类型。当然也要注意这个只能在C里面用，C++必须要显式转化：强制转换`int *p = (int*)malloc(sizeof(int));`或者更加C++风格：`int *p = static_cast<int*>(malloc(sizeof(int)));`。并且还值得注意的是，支持C风格的原因是，不加转换的话：

如果你忘记了 `#include <stdlib.h>`，`malloc` 的原型就不可用。在旧的C标准下，编译器会默认 `malloc` 返回 `int`。如果你没有加 `(int*)`，编译器就会因为你试图将一个 `int` 赋值给 `int *` 而发出警告，帮助你发现忘记包含头文件的错误。如果你加了 `(int*)`，就等于告诉编译器“我知道我在做什么”，从而屏蔽了这个有用的警告。

### free

`void free(void* ptr)`释放内存块，但如果参数的ptr addr并不是原本获取的/指针指向分配的block中见一个地址/已经释放过的指针，对于mananger来说会直接代码中断 code crashes。

并且free也不会帮你清除数据。

### calloc

`void* calloc(size_t nitems, size_t size)`会分配`nitems * size`个字节，并且保证返回的内存地址块内容已经清除了。memory manager一般两种途径：

- 直接找到一个本来就是empty的
- 运行`malloc`然后清除里面的数据

无论如何都会让calloc稍微慢于malloc。

TODO：为什么需要两个参数，和malloc比起来？gemini的回答是calloc这样的参数设计让它看起和数组的感觉更加接近，并且会主动检查需要分配的字节数`nitems*size`会不会超过`size_t`本身能够存储的量。反之malloc不检查并且在申请极大内存的时候可能发生wrap-around导致程序以为申请到了内存但是实际上只有很小一部分的内存。

### realloc

`void* realloc(void* ptr, size_t n)`为了申请更大的存储空间，用旧的指针换取新的指针，并且memory manager会帮你移动数据。

- 有可能tear down a wall然后直接返回旧的指针
- 但也有可能因为后续的地址分配给其他变量了，导致需要从heap其他位置开始存储
- 假如没有空间的话就会返回NULL

### Heap Example

这里的代码是上课用一个一个同学模拟4个bytes（32bits）来理解的，不再展开讲解，但是补充一下[ed](https://edstem.org/us/courses/80131/discussion/6793986?comment=15757825)上的补充解释：

There are a few ways programmers have historically written `malloc`:

```c
int *arr = malloc(3 * sizeof(int)); // One old way
```

Note that this way (in my opinion) is particularly error prone, since you could write the following fairly easily:

```c
int *arr = malloc(3 * sizeof(int*)); // Will cause error if sizeof(int) != sizeof(int*)
long *arr = malloc(3 * sizeof(int)); // Changed the type of arr, but forgot to change the size in the declaration
```

The way I personally prefer is

```c
int *arr = malloc(3 * sizeof *arr); // Parentheses around *arr are optional
```

Note that here, if you change the type of `arr`, the memory allocated will automatically change. Additionally, if we were to change the name of `arr` to something else, then we would get a compiler error (since `arr` doesn't exist anymore), so we cannot have an error from forgetting to change the right-hand side of the assignment statement.

Also, if we have a complicated data structure, keeping track of types of the internals might be hard, but writing

```c
typedef struct {
    ... complicated internals
} my_struct_t;

my_struct_t x; // Puts a thing on the stack

// If you know this is a pointer that needs to be allocated,
// but are unsure of the type, you can write this:

x->foo->bar->baz = malloc(3 * sizeof *x->foo->bar->baz);
```

is quick and simple.

### Best Practices

- Return your meme before you forget
  - Might lose them
  - Frees are NOT recursive. 先释放结构体里面的components，后释放结构体的指针本身
- 可以用sizeof来决定要分配多少内存
- 大多数情况下stack用起来更快，但是存储不了大量的数据，也不能长时间存储数据。响应的要结合heap来存储。

## C Demos

这里有几个demo程序展示：

1. malloc大概比calloc快50%。这个测试程序可以稍微研究一下，比如说printf的位置有没有影响

从上面的程序也可以看出来：

### The heap is a scary, scary place

- Code, Data -- Never change
- Stack -- managed automatically
  - 需要记住不要return返回指向local vars的指针
- Heap 最困难的，4类常见导致的Bugs：
  - 忘记释放导致 Memory Leak
  - 使用已经释放掉的内存 Use after free
  - 对已经释放的内存再次释放 Double free
  - 忘记realloc 可能会改变地址

#### Memory Leak

这个错误C编译器无法检查

#### Use After Use

也叫做 Dangling Reference，可以看 CVE-2022-48771

#### Double Free

可以看 CVE-2023-39975

#### realloc

CVE-2024-22088

### valgrind

可以用valgrind来检查下面这些错误：

- Memory Leaks
- Misuse of free
- Buffer overflows

但是这也会让C运行的非常慢。10x

## Alignment and Endianness

首先，在Stack上的变量会被自动对齐，甚至可能调换顺序以节省空间。

而对于结构体来说：

1. Members must be in the order given, but padding can be added between members
2. Every member must have its alignment satisfied
3. The entire struct is aligned to its largest aligned member

比如说：

```c
struct foo {
	int8_t a;
	int32_t b;
	int16_t c;
};
```

结合上面这个例子来看三条规定。根据规则1，要按照给定顺序进行分配。那么a需要1个字节，假设分配到0x100。随后分配b，b需要4个字节，但是不能从0x101，不然就违反了规则2，因此按照规则1，可以在a后面添加三个字节的padding，然后b分配到0x104开始的4个字节；最后来到需要两个字节的c，c可以从0x108开始两个字节到0x109.最后的最后，根据规则3，结构体本身也需要对齐，也就是说还需要pad 0x110以及0x111

上面这样分配结束后可以看到`sizeof(struct foo) == 12`。然而调换b和c两个变量的顺序就只需要8字节了。

### Endianness
