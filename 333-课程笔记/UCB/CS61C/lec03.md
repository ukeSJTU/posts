## Pointers

### Units of memory

bit：0或1
byte：一般用作最小的有实际作用的内存单元，例如char
nibble/nybble是4bits，也就是1hex digit
1KiB = 1024Bytes
大多数操作系统都是32-bit/64-bit的，也就是CPU可以处理的最大内存单元。因此32位系统更喜欢用`int32_t`，我们的课程中主要处理32bit

word的定义很多，在我们这个课程中指的是 4bytes = 32bits

下面开始研究Mem
Mem is a single huge array

var x存储在0x100到0x103，所以我们说它的地址是0x100 (永远都是小的那个)

pointer就是一个存储了其他变量的内存地址的变量，A variable that contains the memory address of another variable. 换句话说，指针 指向一个内存地址。

> 还需要注意，二进制数本身no meaning。

C中的指针就是通过`*`。最**重要的**是，32bit系统的所有指针都是4bytes，32bit，和它们所指向的变量的类型无关。

Pointer做两件事情：

- reference another var
- store a mem addr

`*`有三种用法：

- `int *p` 声明p是一个指针变量
- `*p`获取p所指向的变量的值
- `*p=`改变p所指向的变量的值

`&`可以获得一个变量的addr

尤其要注意：`int* p, q`这个声明p是整型指针，q是int；如果要两个都是整型指针，那么应该`int *p, *q`。上课推荐分开定义，不要放在一行。

使用指针的好处：

- 传递一个large struct / array 更快更简单
- 自由度更高
- 更底层，同时也是别的语言实现pass-by-reference的范式(paradigms)

但同时带来了 the Bad and the Ugly 那就是很容易引入bug

C语言还有一个NULL 指针，其实就是0.最简单的就是`if(!p)`

然后就是C里面的函数，默认是pass-by-value。那么可以借助指针来改变函数外部变量。

## Arrays

An array is just a block of variables of the same type, in consecutive memory addresses.

They act very similarly to pointers.

```c
int arr[2];
int arr_filled[] = {1,2};
int x = arr_filled[0];
```

arr和指针比较类似.

- 在大多数情况下，如果arr当作var来使用，它就是指向内部第一个元素的一个指针：`uint32_t *q = arr;`q存储的就是arr第一个元素的地址。
- 但如果arr和`&`一起使用，它就变成一个指向whole array的指针，也就是`arr`的值，例如`uint32_t *r = &arr;`
- 如果对arr进行sizeof运算，就是arr元素类型的字节数\*数组长度。例如`uint32_t arr[] = {50, 60, 70}; sizeof arr == 12`

指针本质上仍然是数字，所以当然可以进行加减运算，但是并不是直接的加减。在C里面，如果一个指针是int类型指针，你+n，C会加上`n*sizeof(int)`而不简单是n

例如有一个指针q，`uint32_t *q = arr == 0x100;`然后`uint32_t *r =q+1; == 0x104`。同理`*(arr+2)`就是数组的第2个元素（0-based）

关于`arr[1]`和`3[arr]`这种表述：前者本质上是 `*(arr+1)`的一种缩写；如果这样思考的话，后者就很显然是`*(3+arr)`也就是`arr[3]`

值得注意的是，arr变成指针的时候（例如作为函数参数传递），就丢失了数组大小。例如下面这个代码：

> 这里按照上课的说法我觉得可以理解成，C只在这个数组定义的frame才能记住数组的大小。

```c
void foo(int[] arr) { // 接收到参数后就是 0xFF0
	...
}
int[] arr = {1,2,3}; // 这个存储在0xFF0, 0xFF4, 0xFF8
foo(arr);
```

所以一般需要同时传递一个长度/大小参数：

```c
void foo(int[] arr, int size) {
	...
}
int[] arr = {1,2,3};
foo(arr, 3);
```

总的来说，C里面的数组是primitives，并且：

1. 访问元素的时候C不会检查数组边界
2. 数组会被当做指针传递给函数
3. 数组仅在自己声明的scope中有效
