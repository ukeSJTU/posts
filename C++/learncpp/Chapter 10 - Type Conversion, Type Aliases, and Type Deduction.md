# 10.1 Implicit type conversion
The value of an object is stored as a sequence of bits, and the data type of the object tells the compiler how to interpret those bits into meaningful values. Different data types may represent the “same” number differently. For example, the integer value `3` might be stored as binary `0000 0000 0000 0000 0000 0000 0000 0011`, whereas floating point value `3.0` might be stored as binary `0100 0000 0100 0000 0000 0000 0000 0000`.对象的值存储为位序列，对象的数据类型告诉编译器如何将这些位解释为有意义的值。不同的数据类型可能以不同的方式表示“相同”的数字。例如，整数值 `3` 可能存储为二进制 `0000 0000 0000 0000 0000 0000 0000 0011`，而浮点值 `3.0` 可能存储为二进制 `0100 0000 0100 0000 0000 0000 0000 0000`。

So what happens when we do something like this?那么，当我们做这样的事情时会发生什么呢？

```cpp
float f{ 3 }; // initialize floating point variable with int 3
```

In such a case, the compiler can’t just copy the bits representing the `int` value `3` into the memory allocated for `float` variable `f`. Instead, it needs to convert the integer value `3` to the equivalent floating point value `3.0`, which can then be stored in the memory allocated for `f`.在这种情况下，编译器不能只将表示 `int` 值 `3` 的位复制到分配给 `float` 变量 `f` 的内存中。相反，它需要将整数值 `3` 转换为等效的浮点值 `3.0`，然后可以将其存储在分配给 `f` 的内存中。

The process of producing a new value of some type from a value of a different type is called a **conversion**.从不同类型的值生成某种类型的新值的过程称为**转换**。

> **Key insight** 关键洞察
> 
> Conversions do not change the value or type being converted. Instead, a new value with the desired type is created as a result of the conversion. 类型转换不会改变被转换的值或类型。相反，转换会生成一个具有期望类型的新值。

Type conversion can be invoked in one of two ways: either implicitly (as needed by the compiler), or explicitly (when requested by the programmer). We’ll cover implicit type conversion in this lesson, and explicit type conversions (casting) in upcoming lesson [10.6 -- Explicit type conversion (casting) and static_cast](https://www.learncpp.com/cpp-tutorial/explicit-type-conversion-casting-and-static-cast/).可以通过以下两种方式之一调用类型转换：隐式（根据编译器的需要）或显式（当程序员请求时）。我们将在这节课中介绍隐式类型转换，在即将到来的第 [10.6 课 -- 显式类型转换（强制转换）和static_cast](https://www.learncpp.com/cpp-tutorial/explicit-type-conversion-casting-and-static-cast/)中介绍显式类型转换（强制转换）。

## Implicit type conversion 隐式类型转换
**Implicit type conversion** (also called **automatic type conversion** or **coercion**) is performed automatically by the compiler when one data type is required, but a different data type is supplied. The vast majority of type conversions in C++ are implicit type conversions. For example, implicit type conversion happens in all of the following cases:当需要一种数据类型，但提供了另一种数据类型时，编译器会自动执行**隐式类型转换**（也称为**自动类型转换**或**强制**转换）。C++ 中的绝大多数类型转换都是隐式类型转换。例如，隐式类型转换发生在以下所有情况下：

When initializing (or assigning a value to) a variable with a value of a different data type:初始化具有不同数据类型值的变量（或为其赋值）时：

```cpp
double d{ 3 }; // int value 3 implicitly converted to type double
d = 6; // int value 6 implicitly converted to type double
```

When the type of a return value is different from the function’s declared return type:当返回值的类型与函数声明的返回类型不同时：

```cpp
float doSomething()
{
    return 3.0; // double value 3.0 implicitly converted to type float
}
```

When using certain binary operators with operands of different types:将某些二元运算符与不同类型的操作数一起使用时：

```cpp
double division{ 4.0 / 3 }; // int value 3 implicitly converted to type double
```

When using a non-Boolean value in an if-statement:在 if 语句中使用非布尔值时：

```cpp
if (5) // int value 5 implicitly converted to type bool
{
}
```

When an argument passed to a function is a different type than the function parameter:当传递给函数的参数与函数参数的类型不同时：

```cpp
void doSomething(long l)
{
}

doSomething(3); // int value 3 implicitly converted to type long
```

## What happens when a type conversion is invoked 调用类型转换时会发生什么

When a type conversion is invoked (whether implicitly or explicitly), the compiler will determine whether it can convert the value from the current type to the desired type. If a valid conversion can be found, then the compiler will produce a new value of the desired type. Note that type conversions don’t change the value or type of the value or object being converted.当调用类型转换时（无论是隐式还是显式），编译器将确定是否可以将值从当前类型转换为所需类型。如果可以找到有效的转换，则编译器将生成所需类型的新值。请注意，类型转换不会更改要转换的值或对象的值或类型。

If the compiler can’t find an acceptable conversion, then the compilation will fail with a compile error. Type conversions can fail for any number of reasons. For example, the compiler might not know how to convert a value between the original type and the desired type. In other cases, statements may disallow certain types of conversions. For example: 如果编译器无法找到一个可接受的转换，那么编译将失败，并出现编译错误。类型转换可能由于各种原因失败。例如，编译器可能不知道如何在原始类型和目标类型之间进行转换。在其他情况下，语句可能会禁止某些类型的转换。例如：

```cpp
int x { 3.5 }; // brace-initialization disallows conversions that result in data loss
```

Even though the compiler knows how to convert a `double` value to an `int` value, such conversions are disallowed when using brace-initialization.尽管编译器知道如何将 `double` 值转换为 `int` 值，但在使用大括号初始化时不允许进行此类转换。

There are also cases where the compiler may not be able to figure out which of several possible type conversions is unambiguously the best one to use. We’ll see examples of this in lesson [11.3 -- Function overload resolution and ambiguous matches](https://www.learncpp.com/cpp-tutorial/function-overload-resolution-and-ambiguous-matches/).在某些情况下，编译器可能无法确定几种可能的类型转换中哪一种是最适合使用的类型。我们将在课程[11.3——函数重载解析和不明确匹配](https://www.learncpp.com/cpp-tutorial/function-overload-resolution-and-ambiguous-matches/)中看到这方面的示例。

So how does the compiler actually determine whether it can convert a value from one type to another?那么编译器实际上如何确定它是否可以将值从一种类型转换为另一种类型呢？

## The standard conversions 标准转换
The C++ language standard defines how different fundamental types (and in some cases, compound types) can be converted to other types. These conversion rules are called the **standard conversions**.C++ 语言标准定义了如何将不同的基本类型（以及某些情况下的复合类型）转换为其他类型。这些转换规则称为**标准转换**。

The standard conversions can be broadly divided into 4 categories, each covering different types of conversions:标准转换大致可分为 4 类，每一类涵盖不同类型的转换：

- Numeric promotions (covered in lesson [10.2 -- Floating-point and integral promotion](https://www.learncpp.com/cpp-tutorial/floating-point-and-integral-promotion/))数字提升（在课程 [10.2 -- 浮点和整数提升](https://www.learncpp.com/cpp-tutorial/floating-point-and-integral-promotion/)中介绍）
- Numeric conversions (covered in lesson [10.3 -- Numeric conversions](https://www.learncpp.com/cpp-tutorial/numeric-conversions/))数字转换（课程 [10.3 -- 数字转换](https://www.learncpp.com/cpp-tutorial/numeric-conversions/)中介绍）
- Arithmetic conversions (covered in lesson [10.5 -- Arithmetic conversions](https://www.learncpp.com/cpp-tutorial/arithmetic-conversions/))算术转换（在课程 [10.5 -- 算术转换](https://www.learncpp.com/cpp-tutorial/arithmetic-conversions/)中介绍）
- Other conversions (which includes various pointer and reference conversions)其他转换（包括各种指针和引用转换）

When a type conversion is needed, the compiler will see if there are standard conversions that it can use to convert the value to the desired type. The compiler may apply zero, one, or (in certain cases) two standard conversions in the conversion process.当需要类型转换时，编译器将查看是否存在可用于将值转换为所需类型的标准转换。编译器可以在转换过程中应用零次、一次或（在某些情况下）两次标准转换。

> **As an aside…** 顺便说一句……
> 
> How do you have a type conversion with zero conversions? As an example, on architectures where `int` and `long` both have the same size and range, the same sequence of bits is used to represent values of both types. Therefore, no actual conversion is needed to convert a value between those types -- the value can simply be copied.如何实现零转换的类型转换？例如，在 `int` 和 `long` 都具有相同大小和范围的体系结构上，使用相同的位序列来表示两种类型的值。因此，不需要实际转换来在这些类型之间转换值——可以简单地复制该值。

The full set of rules describing how type conversions work is both lengthy and complicated, and for the most part, type conversion “just works”. In the next set of lessons, we’ll cover the most important things you need to know about type conversions. If finer detail is required for some uncommon case, the full rules are detailed in [technical reference documentation for implicit conversions](https://en.cppreference.com/w/cpp/language/implicit_conversion).描述类型转换如何工作的全套规则既冗长又复杂，而且在大多数情况下，类型转换“正常工作”。在下一组课程中，我们将介绍您需要了解的有关类型转换的最重要的事情。如果某些不常见的情况需要更详细的信息，[隐式转换的技术参考文档](https://en.cppreference.com/w/cpp/language/implicit_conversion)中详细介绍了完整的规则。

Let’s get to it!让我们开始吧！
# 10.2 Floating-point and integral promotion 浮点数和整数提升
In lesson [4.3 -- Object sizes and the sizeof operator](https://www.learncpp.com/cpp-tutorial/object-sizes-and-the-sizeof-operator/), we noted that C++ has minimum size guarantees for each of the fundamental types. However, the actual size of these types can vary based on the compiler and architecture.在第 [4.3 课 -- 对象大小和 sizeof 运算符](https://www.learncpp.com/cpp-tutorial/object-sizes-and-the-sizeof-operator/)中，我们提到C++对每种基本类型都有最小大小保证。然而，这些类型的实际大小可能会根据编译器和体系结构的不同而有所变化。

This variability was allowed so that the `int` and `double` data types could be set to the size that maximizes performance on a given architecture. For example, a 32-bit computer will typically be able to process 32-bits of data at a time. In such cases, an `int` would likely be set to a width of 32-bits, since this is the “natural” size of the data that the CPU operates on (and likely to be the most performant). 这种可变性允许 `int` 和 `double` 数据类型的大小可以根据特定体系结构的性能最大化而设定。例如，32位计算机通常可以一次处理32位的数据。在这种情况下，`int` 类型可能会设置为32位宽度，因为这是CPU处理数据的“自然”大小（也是性能最优的大小）。

> **A reminder** 回顾
> 
> The number of bits a data type uses is called its width. A wider data type is one that uses more bits, and a narrower data type is one that uses less bits. 数据类型使用的比特数称为其宽度。一个更宽的数据类型使用更多的比特，一个更窄的数据类型使用更少的比特。

But what happens when we want our 32-bit CPU to modify an 8-bit value (such as a `char`) or a 16-bit value? Some 32-bit processors (such as 32-bit x86 CPUs) can manipulate 8-bit or 16-bit values directly. However, doing so is often slower than manipulating 32-bit values! Other 32-bit CPUs (like 32-bit PowerPC CPUs), can only operate on 32-bit values, and additional tricks must be employed to manipulate narrower values. 但如果我们希望32位CPU修改一个8位值（如 `char`）或16位值会怎样？一些32位处理器（如32位x86 CPU）可以直接操作8位或16位的值。然而，这样做通常比操作32位的值要慢！其他32位CPU（如32位PowerPC CPU）只能操作32位的值，因此必须采用额外的技巧来操作更窄的值。
## Numeric promotion 数值提升
Because C++ is designed to be portable and performant across a wide range of architectures, the language designers did not want to assume a given CPU would be able to efficiently manipulate values that were narrower than the natural data size for that CPU. 由于C++被设计为可在广泛的体系结构上具有可移植性和高性能，语言设计者不希望假定某个CPU能够有效地操作比该CPU自然数据大小更窄的值。

To help address this challenge, C++ defines a category of type conversions informally called the `numeric promotions`. A **numeric promotion** is the type conversion of certain narrower numeric types (such as a `char`) to certain wider numeric types (typically `int` or `double`) that can be processed efficiently. 为了解决这个问题，C++定义了一类类型转换，非正式地称为**数值提升**。数值提升是指将某些较窄的数值类型（如 `char`）转换为某些较宽的数值类型（通常是 `int` 或 `double`），以便能够高效处理这些值。

All numeric promotions are value-preserving. A **value-preserving conversion** (also called a **safe conversion**) is one where every possible source value can be converted into an equal value of the destination type. 所有数值提升都是**保留值的**。保留值的转换（也称为安全转换）是指每个可能的源值都可以被转换为目标类型的等值。

Because promotions are safe, the compiler will freely use numeric promotion as needed, and will not issue a warning when doing so. 由于提升是安全的，编译器会在需要时自由使用数值提升，并且在执行这种转换时不会发出警告。
## Numeric promotion reduces redundancy 数值提升减少了冗余
Numeric promotion solves another problem as well. Consider the case where you wanted to write a function to print a value of type `int`: 数值提升还解决了另一个问题。考虑这样一个情况，我们想要编写一个函数来打印 `int` 类型的值：

```cpp
#include <iostream>

void printInt(int x)
{
    std::cout << x << '\n';
}
```

While this is straightforward, what happens if we want to also be able to print a value of type `short`, or type `char`? If type conversions did not exist, we’d have to write a different print function for `short` and another one for `char`. And don’t forget another version for `unsigned char`, `signed char`, `unsigned short`, `wchar_t`, `char8_t`, `char16_t`, and `char32_t`! You can see how this quickly becomes unmanageable. 这很直接，但如果我们还想打印 `short` 或 `char` 类型的值该怎么办？如果没有类型转换，我们将不得不为 `short` 编写一个 `print` 函数，另一个为 `char` 编写。而且不要忘了还要为 `unsigned char`、`signed char`、`unsigned short`、`wchar_t`、`char8_t`、`char16_t` 和 `char32_t` 编写各自的版本！你可以看到这种做法很快就会变得难以管理。

Numeric promotion comes to the rescue here: we can write functions that have `int` and/or `double` parameters (such as the `printInt()` function above). That same code can then be called with arguments of types that can be numerically promoted to match the types of the function parameters. **数值提升**在这里派上了用场：我们可以编写具有 `int` 或 `double` 参数的函数（如上面的 `printInt()` 函数）。然后，可以使用可以数值提升为函数参数类型的参数类型来调用相同的代码。
## Numeric promotion categories 数值提升类别
The numeric promotion rules are divided into two subcategories: `integral promotions` and `floating point promotions`. Only the conversions listed in these categories are considered to be numeric promotions. 数值提升规则分为两个子类别：**整数提升** 和 **浮点数提升**。只有在这些类别中列出的转换才被视为数值提升。

## Floating point promotions
We’ll start with the easier one. 我们从较简单的开始。

Using the **floating point promotion** rules, a value of type `float` can be converted to a value of type `double`. 使用浮点数提升规则时，可以将 `float` 类型的值转换为 `double` 类型的值。

This means we can write a function that takes a `double` and then call it with either a `double` or a `float` value: 这意味着我们可以编写一个接受 `double` 参数的函数，然后用 `double` 或 `float` 值来调用它：

```cpp
#include <iostream>

void printDouble(double d)
{
    std::cout << d << '\n';
}

int main()
{
    printDouble(5.0); // no conversion necessary
    printDouble(4.0f); // numeric promotion of float to double

    return 0;
}
```

In the second call to `printDouble()`, the `float` literal `4.0f` is promoted into a `double`, so that the type of argument matches the type of the function parameter. 在对 `printDouble()` 的第二次调用中，`float` 字面量 `4.0f` 被提升为 `double`，因此参数类型与函数参数的类型匹配。

## Integral promotions 整数提升
The integral promotion rules are more complicated. 整数提升规则更复杂一些。

Using the **integral promotion** rules, the following conversions can be made: 使用整数提升规则时，可以进行以下转换：

- signed char or signed short can be converted to int. `signed char` 或 `signed short` 可以转换为 `int`。
- unsigned char, char8_t, and unsigned short can be converted to int if int can hold the entire range of the type, or unsigned int otherwise. 如果 `int` 能容纳类型的全部范围，则 `unsigned char`、`char8_t` 和 `unsigned short` 可以转换为 `int`，否则转换为 `unsigned int`。
- If char is signed by default, it follows the signed char conversion rules above. If it is unsigned by default, it follows the unsigned char conversion rules above. 如果 `char` 默认是有符号的，它遵循上面的 `signed char` 转换规则。如果 `char` 默认是无符号的，它遵循上面的 `unsigned char` 转换规则。
- bool can be converted to int, with false becoming 0 and true becoming 1. `bool` 可以转换为 `int`，`false` 变为 0，`true` 变为 1。

Assuming an 8 bit byte and an `int` size of 4 bytes or larger (which is typical these days), the above basically means that `bool`, `char`, `signed char`, `unsigned char`, `signed short`, and `unsigned short` all get promoted to `int`. 假设 8 位字节和 `int` 的大小为 4 个字节或更大（这是当今的典型情况），上述规则基本上意味着 `bool`、`char`、`signed char`、`unsigned char`、`signed short` 和 `unsigned short` 都将提升为 `int`。

There are a few other integral promotion rules that are used less often. These can be found at [https://en.cppreference.com/w/cpp/language/implicit_conversion#Integral_promotion](https://en.cppreference.com/w/cpp/language/implicit_conversion#Integral_promotion). 还有一些其他不常用的整数提升规则。您可以在 [cppreference](https://en.cppreference.com/w/cpp/language/implicit_conversion#Integral_promotion) 上找到它们。

In most cases, this lets us write a function taking an `int` parameter, and then use it with a wide variety of other integral types. For example: 在大多数情况下，这让我们可以编写一个接受 `int` 参数的函数，然后可以使用多种其他整型类型。例如：

```cpp
#include <iostream>

void printInt(int x)
{
    std::cout << x << '\n';
}

int main()
{
    printInt(2);

    short s{ 3 }; // there is no short literal suffix, so we'll use a variable for this one
    printInt(s); // numeric promotion of short to int

    printInt('a'); // numeric promotion of char to int
    printInt(true); // numeric promotion of bool to int

    return 0;
}
```

There are two things worth noting here. First, on some architectures (e.g. with 2 byte ints) it is possible for some of the unsigned integral types to be promoted to `unsigned int` rather than `int`. 这里有两点值得注意。首先，在某些架构上（如使用 2 字节 `int` 的架构），某些无符号整型可能会提升为 `unsigned int` 而不是 `int`。

Second, some narrower unsigned types (such as `unsigned char`) may be promoted to larger signed types (such as `int`). So while integral promotion is value-preserving, it does not necessarily preserve the signedness (signed/unsigned) of the type. 其次，某些较窄的无符号类型（如 `unsigned char`）可能会提升为较大的有符号类型（如 `int`）。因此，虽然整数提升保留了数值，但它不一定保留类型的符号性（有符号/无符号）。
## Not all widening conversions are numeric promotions 并非所有扩宽转换都是数值提升
Some widening type conversions (such as `char` to `short`, or `int` to `long`) are not considered to be numeric promotions in C++ (they are `numeric conversions`, which we’ll cover shortly in lesson [10.3 -- Numeric conversions](https://www.learncpp.com/cpp-tutorial/numeric-conversions/)). This is because such conversions do not assist in the goal of converting smaller types to larger types that can be processed more efficiently. 某些扩宽类型转换（例如 `char` 转 `short` 或 `int` 转 `long`）在 C++ 中不被视为数值提升（它们是数值转换，我们将在第10.3节——数值转换中讨论）。这是因为此类转换并未帮助实现将较小类型转换为可以更高效处理的较大类型的目标。

The distinction is mostly academic. However, in certain cases, the compiler will favor numeric promotions over numeric conversions. We’ll see examples where this makes a difference when we cover function overload resolution (in upcoming lesson [11.3 -- Function overload resolution and ambiguous matches](https://www.learncpp.com/cpp-tutorial/function-overload-resolution-and-ambiguous-matches/)). 这种区分大多是理论性的。然而，在某些情况下，编译器会优先使用数值提升而不是数值转换。当我们讨论函数重载解析时（即将到来的第11.3节——函数重载解析与模糊匹配中），我们将看到一些例子，这种情况会产生差异。
# 10.3 Numeric conversions 数值转换
In the previous lesson ([[# 10.2]]), we covered numeric promotions, which are conversions of specific narrower numeric types to wider numeric types (typically `int` or `double`) that can be processed efficiently. 在之前的课程中 TODO 添加正确引用，我们讨论了数值提升，它是将某些较窄的数值类型转换为可以更高效处理的较宽数值类型（通常是 `int` 或 `double`）的转换。

C++ supports another category of numeric type conversions, called **numeric conversions**. These numeric conversions cover additional type conversions between fundamental types. C++ 还支持另一类数值类型转换，称为**数值转换**。这些数值转换涵盖了基础类型之间的额外类型转换。

> **Key insight**
> 
> Any type conversion covered by the numeric promotion rules ([10.2 -- Floating-point and integral promotion](https://www.learncpp.com/cpp-tutorial/floating-point-and-integral-promotion/)) is called a numeric promotion, not a numeric conversion. 任何受数值提升规则（[10.2 —— 浮点数和整数提升](https://www.learncpp.com/cpp-tutorial/floating-point-and-integral-promotion/)）约束的类型转换都称为**数值提升**，而不是**数值转换**。

There are five basic types of numeric conversions. 数值转换有五种基本类型。

1. Converting an integral type to any other integral type (excluding integral promotions): 将整型转换为任何其他整型（不包括整型提升）：

```cpp
short s = 3; // convert int to short
long l = 3; // convert int to long
char ch = s; // convert short to char
unsigned int u = 3; // convert int to unsigned int
```

2. Converting a floating point type to any other floating point type (excluding floating point promotions): 将浮点类型转换为任何其他浮点类型（不包括浮点提升）：

```cpp
float f = 3.0; // convert double to float
long double ld = 3.0; // convert double to long double
```

3. Converting a floating point type to any integral type: 将浮点类型转换为任何整型：

```cpp
int i = 3.5; // convert double to int
```

4. Converting an integral type to any floating point type: 将整型转换为任何浮点类型：

```cpp
double d = 3; // convert int to double
```

5. Converting an integral type or a floating point type to a bool: 将整型或浮点类型转换为 bool：

```cpp
bool b1 = 3; // convert int to bool
bool b2 = 3.0; // convert double to bool
```

> **As an aside…** 顺便说一句
> 
> Because brace initialization strictly disallows some types of numeric conversions (more on this next lesson), we use copy initialization in this lesson (which does not have any such limitations) in order to keep the examples simple. 由于大括号初始化严格不允许某些类型的数字转换（下一课将详细介绍），因此我们在本节课中使用复制初始化（没有任何对于类型的限制）以保持示例简单。

## Safe and unsafe conversions 安全和不安全的转换
Unlike numeric promotions (which are always value-preserving and thus “safe”), many numeric conversions are unsafe. An **unsafe conversion** is one where at least one value of the source type cannot be converted into an equal value of the destination type.  与数值提升（它们总是保留值，因此是“安全的”）不同，许多数值转换是不安全的。不安全的转换是指至少有一个源类型的值无法转换为目标类型的等值。

Numeric conversions fall into three general safety categories: 数值转换大致可以分为三类安全性类别：

1. _Value-preserving conversions_ are safe numeric conversions where the destination type can exactly represent all possible values in the source type. **保留值的转换** 是安全的数值转换，其中目标类型可以精确表示源类型中的所有可能值。

For example, `int` to `long` and `short` to `double` are safe conversions, as the source value can always be converted to an equal value of the destination type. 例如，`int` 到 `long` 和 `short` 到 `double` 是安全的转换，因为源值总是可以转换为目标类型的等值。

```cpp
int main()
{
    int n { 5 };
    long l = n; // okay, produces long value 5

    short s { 5 };
    double d = s; // okay, produces double value 5.0

    return 0;
}
```

Compilers will typically not issue warnings for implicit value-preserving conversions. 编译器通常不会对隐式的保留值转换发出警告。

A value converted using a value-preserving conversion can always be converted back to the source type, resulting in a value that is equivalent to the original value: 使用保留值转换转换的值可以始终转换回源类型，结果将是等于原始值的值：

```cpp
#include <iostream>

int main()
{
    int n = static_cast<int>(static_cast<long>(3)); // convert int 3 to long and back
    std::cout << n << '\n';                         // prints 3

    char c = static_cast<char>(static_cast<double>('c')); // convert 'c' to double and back
    std::cout << c << '\n';                               // prints 'c'

    return 0;
}
```

2. _Reinterpretive conversions_ are unsafe numeric conversions where the converted value may be different than the source value, but no data is lost. Signed/unsigned conversions fall into this category. **重新解释的转换** 是不安全的数值转换，其中转换后的值可能与源值不同，但不会丢失数据。带符号/无符号的转换属于这一类。

For example, when converting a `signed int` to an `unsigned int`: 例如，将带符号的 `int` 转换为无符号的 `int`：

```cpp
int main()
{
    int n1 { 5 };
    unsigned int u1 { n1 }; // okay: will be converted to unsigned int 5 (value preserved)

    int n2 { -5 };
    unsigned int u2 { n2 }; // bad: will result in large integer outside range of signed int

    return 0;
}
```

In the case of `u1`, the signed int value `5` is converted to unsigned int value `5`. Thus, the value is preserved in this case. 在 `u1` 的情况下，带符号的 `int` 值 5 被转换为无符号的 `int` 值 5，因此保留了值。

In the case of `u2`, the signed int value `-5` is converted to an unsigned int. Since an unsigned int can’t represent negative numbers, the result will be modulo wrapped to a large integral value that is outside the range of a signed int. The value is not preserved in this case. 在 `u2` 的情况下，带符号的 `int` 值 -5 被转换为无符号的 `int`，由于无符号的 `int` 不能表示负数，结果将会是一个模数运算后的大值，超出带符号 `int` 的范围，值没有得到保留。

Such value changes are typically undesirable, and will often cause the program to exhibit unexpected or implementation-defined behavior. 这种值的变化通常是不可取的，可能会导致程序表现出意外或实现定义的行为。

> **Related content** 相关内容
> 
> We discuss how out-of-range values are converted between signed and unsigned types in lesson [4.12 -- Introduction to type conversion and static_cast](https://www.learncpp.com/cpp-tutorial/introduction-to-type-conversion-and-static_cast/). 我们将在第 [4.12 课 -- 类型转换和static_cast简介](https://www.learncpp.com/cpp-tutorial/introduction-to-type-conversion-and-static_cast/)中讨论如何在有符号和无符号类型之间转换超出范围的值。

> **Warning** 警告
> 
> Even though reinterpretive conversions are unsafe, most compilers leave implicit signed/unsigned conversion warnings disabled by default. 尽管重新解释的转换是不安全的，但大多数编译器默认不会对隐式的带符号/无符号转换发出警告。
> 
> This is because in some areas of modern C++ (such as when working with standard library arrays), signed/unsigned conversions can be hard to avoid. And practically speaking, the majority of such conversions do not actually result in a value change. Therefore, enabling such warnings can lead to many spurious warnings for signed/unsigned conversions that are actually okay (drowning out legitimate warnings). 这是因为在某些现代 C++ 代码（例如使用标准库数组时），带符号/无符号的转换很难避免，且大多数情况下这种转换并不会导致值的改变，因此启用这些警告可能会导致大量无关的警告掩盖真正的问题。
> 
> If you choose to leave such warnings disabled, be extra careful of inadvertent conversions between these types (particularly when passing an argument to a function taking a parameter of the opposite sign).   如果您选择禁用此类警告，请格外小心这些类型之间的无意转换（尤其是在将参数传递给采用相反符号的参数的函数时）。

Values converted using a reinterpretive conversion can be converted back to the source type, resulting in a value equivalent to the original value (even if the initial conversion produced a value out of range of the source type). As such, reinterpretive conversions do not lose data during the conversion process. 使用重新解释的转换转换的值可以始终转换回源类型，结果将是等于原始值的值（即使初始转换产生了超出源类型范围的值）。因此，重新解释的转换在转换过程中不会丢失数据。

```cpp
#include <iostream>

int main()
{
    int u = static_cast<int>(static_cast<unsigned int>(-5)); // convert '-5' to unsigned and back
    std::cout << u << '\n'; // prints -5

    return 0;
}
```

> **For advanced readers** **高级读者提示**：
> 
> Prior to C++20, converting an unsigned value that is out-of-range of the signed value is technically implementation-defined behavior (due to the allowance that signed integers could use a different binary representation than unsigned integers). In practice, this was a non-issue on modern system. 在 C++20 之前，将超出带符号数值范围的无符号值转换为带符号值在技术上是实现自定义的行为（因为允许带符号整数使用与无符号整数不同的二进制表示）。实际上，在现代系统上这并不是问题。TODO implementation-defined 指的应该是不同实现行为不一样？
> 
> C++20 now requires that signed integers use 2s complement. As a result, the conversion rules were changed so that the above is now well-defined as a reinterpretive conversion (an out-of-range conversion will produce modulo wrapping). C++20 现在要求带符号整数使用二进制补码。因此，转换规则被更改为上述情况现在被明确定义为重新解释的转换（超出范围的转换将产生模数包裹）。
> 
> Note that while such conversions are well defined, signed arithmetic overflow (which occurs when an arithmetic operation produces a value outside the range that can be stored) is still undefined behavior. 请注意，虽然此类转换定义明确，但有符号算术溢出（当算术运算产生的值超出可存储的范围时发生）仍然是未定义的行为。

3. _Lossy conversions_ are unsafe numeric conversions where data may be lost during the conversion. **有损的转换** 是不安全的数值转换，在转换过程中可能会丢失数据。

For example, `double` to `int` is a conversion that may result in data loss: 例如，将 `double` 转换为 `int` 可能会导致数据丢失：

```cpp
int i = 3.0; // okay: will be converted to int value 3 (value preserved)
int j = 3.5; // data lost: will be converted to int value 3 (fractional value 0.5 lost)
```

Conversion from `double` to `float` can also result in data loss: 从 `double` 转换为 `float` 也可能导致数据丢失：

```cpp
float f = 1.2;        // okay: will be converted to float value 1.2 (value preserved)
float g = 1.23456789; // data lost: will be converted to float 1.23457 (precision lost)
```

Converting a value that has lost data back to the source type will result in a value that is different than the original value: 将丢失数据的值转换回源类型时，结果将不同于原始值：

```cpp
#include <iostream>

int main()
{
    double d { static_cast<double>(static_cast<int>(3.5)) }; // convert double 3.5 to int and back
    std::cout << d << '\n'; // prints 3

    double d2 { static_cast<double>(static_cast<float>(1.23456789)) }; // convert double 1.23456789 to float and back
    std::cout << d2 << '\n'; // prints 1.23457

    return 0;
}
```

For example, if `double` value `3.5` is converted to `int` value `3`, the fractional component `0.5` is lost. When `3` is converted back to a `double,` the result is `3.0`, not `3.5`. 例如，`double` 值 3.5 转换为 `int` 值 3 时，0.5 的小数部分被丢失。当 `3` 转换回 `double` 时，结果是 `3.0` 而不是 `3.5`。

Compilers will generally issue a warning (or in some cases, an error) when an implicit lossy conversion would be performed at runtime. 编译器通常会在隐式执行有损转换时发出警告（或者在某些情况下，会报错）。

> **Warning** 警告

Some conversions may fall into different categories depending on the platform. 某些转换可能根据平台的不同而属于不同的类别。

For example, `int` to `double` is typically a safe conversion, because `int` is usually 4 bytes and `double` is usually 8 bytes, and on such systems, all possible `int` values can be represented as a `double`. However, there are architectures where both `int` and `double` are 8 bytes. On such architectures, `int` to `double` is a lossy conversion! 例如，`int` 到 `double` 通常是安全的转换，因为 `int` 通常为 4 字节，而 `double` 通常为 8 字节，在这种情况下，所有可能的 `int` 值都可以表示为 `double`。然而，在某些架构中，`int` 和 `double` 都是 8 字节。在这些架构中，`int` 到 `double` 是有损的转换！

We can demonstrate this by casting a long long value (which must be at least 64 bits) to double and back: 我们可以通过将 `long long` 值（至少 64 位）转换为 `double` 再转换回来来演示这一点：

```cpp
#include <iostream>

int main()
{
    std::cout << static_cast<long long>(static_cast<double>(10000000000000001LL));

    return 0;
}
```

This prints: 这将输出：
``` text
10000000000000000
```

Note that our last digit has been lost! 注意，最后一位数字丢失了！

Unsafe conversions should be avoided as much as possible. However, this is not always possible. When unsafe conversions are used, it is most often when: 应尽可能避免不安全的转换。然而，这并不总是可能的。当使用不安全的转换时，通常是在以下情况下：

- We can constrain the values to be converted to just those that can be converted to equal values. For example, an `int` can be safely converted to an `unsigned int` when we can guarantee that the `int` is non-negative. 我们可以将要转换的值限制为可以转换为等值的值。例如，当我们能保证 `int` 是非负数时，可以安全地将 `int` 转换为无符号 `int`。
- We don’t mind that some data is lost because it is not relevant. For example, converting an `int` to a `bool` results in the loss of data, but we’re typically okay with this because we’re just checking if the `int` has value `0` or not. 我们不介意丢失一些数据，因为它并不相关。例如，将 `int` 转换为 `bool` 会导致数据丢失，但我们通常对此没有异议，因为我们只是检查 `int` 是否为 0。

## More on numeric conversions 更多关于数值转换的内容
The specific rules for numeric conversions are complicated and numerous, so here are the most important things to remember. 数值转换的具体规则非常复杂且繁多，以下是一些需要记住的重要点：

- In _all_ cases, converting a value into a type whose range doesn’t support that value will lead to results that are probably unexpected. For example: 在所有情况下，将值转换为不支持该值范围的类型将导致结果可能出乎意料。例如：

```cpp
int main()
{
    int i{ 30000 };
    char c = i; // chars have range -128 to 127

    std::cout << static_cast<int>(c) << '\n';

    return 0;
}
```

In this example, we’ve assigned a large integer to a variable with type `char` (that has range -128 to 127). This causes the char to overflow, and produces an unexpected result: 在这个例子中，我们将一个大整数赋值给 `char` 类型的变量（其范围是 -128 到 127）。这会导致 `char` 溢出，生成一个意外的结果：

``` text
48
```

- Remember that overflow is well-defined for unsigned values and produces undefined behavior for signed values. 溢出对无符号值是有定义的，而对带符号值则是未定义行为。
- Converting from a larger integral or floating point type to a smaller type from the same family will generally work so long as the value fits in the range of the smaller type. For example: 将较大的整数或浮点数类型转换为同一类型族中的较小类型，只要该值在较小类型的范围内，通常可以正常工作。例如：

```cpp
int i{ 2 };
short s = i; // convert from int to short
std::cout << s << '\n';

double d{ 0.1234 };
float f = d;
std::cout << f << '\n';
```

This produces the expected result: 这会产生预期的结果：

``` text
2
0.1234
```

- In the case of floating point values, some rounding may occur due to a loss of precision in the smaller type. For example: 在浮点数值的情况下，可能会由于较小类型的精度损失而发生一些四舍五入。例如：

```cpp
float f = 0.123456789; // double value 0.123456789 has 9 significant digits, but float can only support about 7
std::cout << std::setprecision(9) << f << '\n'; // std::setprecision defined in iomanip header
```

In this case, we see a loss of precision because the `float` can’t hold as much precision as a `double`: 在这种情况下，由于 `float` 无法保存与 `double` 一样多的精度，结果丢失了一些精度：

``` text
0.123456791
```

- Converting from an integer to a floating point number generally works as long as the value fits within the range of the floating point type. For example: 将整数转换为浮点数通常可以正常工作，只要该值在浮点数类型的范围内。例如：

```cpp
int i{ 10 };
float f = i;
std::cout << f << '\n';
```

This produces the expected result: 这会产生预期的结果：

``` text
10
```

- Converting from a floating point to an integer works as long as the value fits within the range of the integer, but any fractional values are lost. For example: 将浮点数转换为整数可以正常工作，只要该值在整数类型的范围内，但任何小数部分将会丢失。例如：

```cpp
int i = 3.5;
std::cout << i << '\n';
```

In this example, the fractional value (.5) is lost, leaving the following result 在这个例子中，小数部分（.5）丢失，结果是：

``` text
3
```

While the numeric conversion rules might seem scary, in reality the compiler will generally warn you if you try to do something dangerous (excluding some signed/unsigned conversions). 尽管数值转换规则可能看起来令人害怕，但实际上编译器通常会在你尝试做危险操作时发出警告（除了一些带符号/无符号转换）。

# 10.4 Narrowing conversions, list initialization, and constexpr initializers
# 10.5 Arithmetic conversions
# 10.6 Explicit type conversion (casting) and static_cast
# 10.7 Typedefs and type aliases
# 10.8 Type deduction for objects using the auto keyword
# 10.9 Type deduction for functions
# 10.x Chapter 10 summary and quiz