# 12.1 - Introduction to compound data types 复合数据类型简介
In lesson [4.1 -- Introduction to fundamental data types](https://www.learncpp.com/cpp-tutorial/introduction-to-fundamental-data-types/), we introduced the fundamental data types, which are the basic data types that C++ provides as part of the core language. 在 4.1TODO补充链接节课中，我们介绍了基本数据类型，它们是C++作为核心语言的一部分提供的基础数据类型。

We’ve made much use of these fundamental types in our programs so far, especially the `int` data type. And while these fundamental types are extremely useful for straightforward uses, they don’t cover our full range of needs as we begin to do more complicated things. 到目前为止，我们的程序中大量使用了这些基本类型，尤其是 `int` 数据类型。虽然这些基本类型在简单应用中非常有用，但随着我们开始进行更复杂的操作，它们无法完全满足我们的需求。

For example, imagine you were writing a math program to multiply two fractions. How would you represent a fraction in your program? You might use a pair of integers (one for the numerator, one for the denominator), like this: 例如，假设你正在编写一个数学程序来相乘两个分数。你会如何在程序中表示一个分数？你可能会使用一对整数（一个表示分子，一个表示分母），如下所示：

```cpp
#include <iostream>

int main()
{
    // Our first fraction
    int num1 {};
    int den1 {};

    // Our second fraction
    int num2 {};
    int den2 {};

    // Used to eat (remove) the slash between the numerator and denominator
    char ignore {};

    std::cout << "Enter a fraction: ";
    std::cin >> num1 >> ignore >> den1;

    std::cout << "Enter a fraction: ";
    std::cin >> num2 >> ignore >> den2;

    std::cout << "The two fractions multiplied: "
        << num1 * num2 << '/' << den1 * den2 << '\n';

    return 0;
}
```

And a run of this program: 程序运行结果如下：
``` text
Enter a fraction: 1/2
Enter a fraction: 3/4
The two fractions multiplied: 3/8
```

While this program works, it introduces a couple of challenges for us to improve upon. First, each pair of integers is only loosely linked -- outside of comments and the context of how they are used in the code, there’s little to suggest that each numerator and denominator pair are related. Second, following the DRY (don’t repeat yourself) principle, we should create a function to handle the user inputting a fraction (along with some error handling). However, functions can only return a single value, so how would we return the numerator and denominator back to the caller? 虽然这个程序可以正常工作，但它为我们提出了一些可以改进的挑战。首先，每对整数的关联很弱——除了代码中的注释和上下文，几乎没有任何东西表明分子和分母是一对。其次，遵循DRY（不要重复自己）原则，我们应该创建一个函数来处理用户输入分数（并包括一些错误处理）。然而，函数只能返回一个值，那么我们如何将分子和分母一起返回给调用者呢？

Now imagine another case where you’re writing a program that needs to keep a list of employee IDs. How might you do so? You might try something like this: 再想象另一种情况，假设你正在编写一个需要维护员工ID列表的程序。你可能会这样做：

```cpp
int main()
{
    int id1 { 42 };
    int id2 { 57 };
    int id3 { 162 };
    // and so on
}
```

But what if you had 100 employees? First, you’d need to type in 100 variable names. And what if you needed to print them all? Or pass them to a function? We’d be in for a lot of typing. This simply doesn’t scale. 但是如果你有100个员工呢？首先，你需要输入100个变量名。而如果你需要打印它们或传递给函数呢？我们将要输入大量的代码。显然，这种方法无法扩展。

Clearly fundamental types will only carry us so far. 显然，基本类型的应用是有限的。
## Compound data types 复合数据类型
Fortunately, C++ supports a second set of data types called `compound data types`. **Compound data types** (also sometimes called **composite data types**) are data types that can be constructed from fundamental data types (or other compound data types). Each compound data type has its own unique properties as well. 幸运的是，C++支持另一类数据类型，称为复合数据类型。复合数据类型（有时也称为组合数据类型）是由基本数据类型（或其他复合数据类型）构造的。每种复合数据类型都有其独特的属性。

As we’ll show in this chapter and future chapters, we can use compound data types to elegantly solve all of the challenges we presented above. 正如我们将在本章和后续章节中展示的那样，我们可以使用复合数据类型优雅地解决上述所有问题。

C++ supports the following compound types: C++支持以下复合类型：
- Functions 函数
- Arrays 数组
- Pointer types: 指针类型
    - Pointer to object 对象指针
    - Pointer to function 函数指针
- Pointer to member types: 成员指针类型
    - Pointer to data member 数据成员指针
    - Pointer to member function 成员函数指针
- Reference types: 引用类型
    - L-value references 左值引用
    - R-value references 右值引用
- Enumerated types: 枚举类型
    - Unscoped enumerations 无范围枚举
    - Scoped enumerations 有范围枚举
- Class types: 类类型
    - Structs 绝构体
    - Classes 类
    - Unions 联合体

You’ve already been using one compound type regularly: functions. For example, consider this function: 你已经经常使用过一种复合类型：**函数**。例如，考虑以下函数：

```cpp
void doSomething(int x, double y)
{
}
```

The type of this function is `void(int, double)`. Note that this type is composed of fundamental types, making it a compound type. Of course, functions also have their own special behaviors as well (e.g. being callable). 这个函数的类型是 `void(int, double)`。注意，这种类型是由基本数据类型组成的，因此它是一种复合类型。当然，函数还有一些特殊行为（例如可以被调用）。

Because there’s a lot of material to cover here, we’ll do it over multiple chapters. In this chapter, we’ll cover some of the more straightforward compound types, including `l-value references`, and `pointers`. Next chapter, we’ll cover `unscoped enumerations`, `scoped enumerations`, and basic `structs`. Then, in the chapters beyond that, we’ll introduce class types and dig into some of the more useful `array` types. This includes `std::string` (introduced in lesson [5.9 -- Introduction to std::string](https://www.learncpp.com/cpp-tutorial/introduction-to-stdstring/)), which is actually a class type! 因为这里涉及的内容很多，我们会分多个章节来介绍。在本章中，我们将介绍一些较为直接的复合类型，包括左值引用和指针。在下一章中，我们将介绍无范围枚举、有范围枚举和基本结构体。接下来的章节中，我们将引入类类型，并深入介绍一些更有用的数组类型。这包括在第5.9节**std::string简介**中引入的 `std::string`，它实际上是一种类类型！

Got your game face on? Let’s go! 准备好了吗？让我们开始吧！
# 12.2 Value categories (lvalues and rvalues) 数值类型（左值和右值）
Before we talk about our first compound type (lvalue references), we’re going to take a little detour and talk about what an lvalue is. 在讨论我们的第一个复合类型（左值引用）之前，我们先稍微绕个弯，来谈谈什么是左值（lvalue）。

In lesson 1.10 -- Introduction to expressions, we defined an expression as “a combination of literals, variables, operators, and function calls that can be executed to produce a singular value”. 在**第1.10节——表达式简介** TODO 补充引用链接 中，我们定义了表达式是“字面值、变量、运算符和函数调用的组合，可以执行并生成一个单一的值”。

例如：

```cpp
#include <iostream>

int main()
{
    std::cout << 2 + 3 << '\n'; // 表达式 2 + 3 生成值 5

    return 0;
}
```

在上面的程序中，表达式 `2 + 3` 计算后生成值 `5`，然后将其打印到控制台。

在**第6.4节——自增/自减运算符及副作用**中，我们还指出，表达式可以产生超出表达式生命周期的副作用：

``` cpp
#include <iostream>

int main()
{
    int x { 5 };
    ++x; // 这个表达式语句有副作用，x 的值增加了
    std::cout << x << '\n'; // 打印 6

    return 0;
}
```

在上面的程序中，表达式 `++x` 增加了 `x` 的值，并且该值在表达式结束后仍然保持更改。

除了生成值和副作用之外，表达式还可以做一件事：它们可以求值为对象或函数。我们稍后将深入探讨这一点。
## The properties of an expression 表达式的属性
为了帮助确定表达式应该如何求值以及它们可以在哪些地方使用，C++中的所有表达式都有两个属性：类型和值类别。
### The type of an expression 表达式的类型
表达式的类型等同于求值后生成的值、对象或函数的类型。例如：

``` cpp
int main()
{
    auto v1 { 12 / 4 }; // int / int => int
    auto v2 { 12.0 / 4 }; // double / int => double

    return 0;
}
```

对于 `v1`，编译器将在编译时确定使用两个 `int` 操作数的除法将生成 `int` 结果，因此该表达式的类型是 `int`。通过类型推断，`v1` 的类型将被设为 `int`。

对于 `v2`，编译器将在编译时确定 `double` 操作数和 `int` 操作数的除法将生成 `double` 结果。记住，算术运算符必须有匹配类型的操作数，因此在这种情况下，`int` 操作数将被转换为 `double`，并执行浮点除法。因此，该表达式的类型为 `double`。

编译器可以使用表达式的类型来确定表达式在特定上下文中是否有效。例如：

``` cpp
#include <iostream>

void print(int x)
{
    std::cout << x << '\n';
}

int main()
{
    print("foo"); // 错误：print() 期望一个 int 参数，我们传入了一个字符串字面值

    return 0;
}

```

在上面的程序中，`print(int)` 函数期望一个 `int` 参数。然而，我们传入的表达式（字符串字面值 `"foo"`）的类型不匹配，并且找不到可以转换的途径。因此，产生了编译错误。

注意，表达式的类型必须在编译时确定（否则类型检查和类型推断将无法工作）——然而，表达式的值可以在编译时（如果该表达式是 `constexpr`）或运行时（如果该表达式不是 `constexpr`）确定。
### The value category of an expression 表达式的值类别
现在，考虑以下程序：

``` cpp
int main()
{
    int x{};

    x = 5; // 有效：我们可以将 5 赋值给 x
    5 = x; // 错误：无法将 x 的值赋给字面值 5

    return 0;
}
```

其中一个赋值语句是有效的（将值 `5` 赋给变量 `x`），另一个则无效（将 `x` 的值赋给字面值 `5` 是没有意义的）。那么编译器如何知道哪些表达式可以合法地出现在赋值语句的任意一侧呢？

答案在于表达式的第二个属性：值类别。表达式的值类别（或子表达式的值类别）指示表达式是否解析为值、函数或某种对象。

在 C++11 之前，只有两种可能的值类别：左值（lvalue）和右值（rvalue）。

在 C++11 中，为了支持一种称为**移动语义**的新特性，增加了三种额外的值类别：glvalue、prvalue 和 xvalue。

> **作者提示**
> 
> 在本课中，我们将坚持使用 C++11 之前的值类别观点，因为这更适合作为值类别的入门介绍（而且目前我们只需要这些内容）。我们将在以后的章节中讨论移动语义（以及新增的三种值类别）。

## Lvalue and rvalue expressions 左值和右值表达式
左值（lvalue，读作“ell-value”，是“left value”或“locator value”的缩写，有时写作“l-value”）是求值为可识别的对象或函数（或位域）的表达式。

术语“标识”是 C++ 标准中使用的术语，但定义不明确。具有标识的实体（例如对象或函数）可以与其他类似的实体区分开来（通常通过比较实体的地址）。

具有标识的实体可以通过标识符、引用或指针访问，通常其生命周期比单个表达式或语句更长。

``` cpp
int main()
{
    int x { 5 };
    int y { x }; // x 是一个左值表达式

    return 0;
}
```

在上面的程序中，表达式 `x` 是一个左值表达式，因为它求值为变量 `x`（它有一个标识符）。

自从引入常量以来，左值有了两种子类型：可修改的左值是可以修改其值的左值。不可修改的左值是不能修改其值的左值（因为该左值是 `const` 或 `constexpr`）。

``` cpp
int main()
{
    int x{};
    const double d{};

    int y { x }; // x 是一个可修改的左值表达式
    const double e { d }; // d 是一个不可修改的左值表达式

    return 0;
}
```

右值（rvalue，读作“arr-value”，是“right value”的缩写，有时写作“r-value”）是指不是左值的表达式。右值表达式求值为值。常见的右值包括字面值（除了 C 风格的字符串字面值，它们是左值）以及按值返回的函数和运算符的返回值。右值没有标识（这意味着它们必须立即使用），并且只在其使用的表达式范围内存在。

``` cpp
int return5()
{
    return 5;
}

int main()
{
    int x{ 5 }; // 5 是一个右值表达式
    const double d{ 1.2 }; // 1.2 是一个右值表达式

    int y { x }; // x 是一个可修改的左值表达式
    const double e { d }; // d 是一个不可修改的左值表达式
    int z { return5() }; // return5() 是一个右值表达式（因为结果按值返回）

    int w { x + 1 }; // x + 1 是一个右值表达式
    int q { static_cast<int>(d) }; // 对 d 的 static_cast 转换结果是一个右值表达式

    return 0;
}
```

你可能想知道为什么 `return5()`、`x + 1` 和 `static_cast<int>(d)` 是右值：答案是这些表达式产生了不具备标识的临时值。

> Key insight 关键见解
> 
> 左值表达式求值为一个可识别的对象。  
> 右值表达式求值为一个值。

现在我们可以回答为什么 `x = 5` 是有效的，而 `5 = x` 是无效的：赋值操作要求赋值运算符的左操作数是一个可修改的左值表达式，右操作数是一个右值表达式。后一个赋值（`5 = x`）失败是因为左操作数表达式 `5` 不是左值。

``` cpp
int main()
{
    int x{};

    // 赋值要求左操作数是一个可修改的左值表达式，右操作数是一个右值表达式
    x = 5; // 有效：x 是可修改的左值表达式，5 是右值表达式
    5 = x; // 错误：5 是右值表达式，x 是可修改的左值表达式

    return 0;
}
```

> Related content
> 
> A full list of lvalue and rvalue expressions can be found [here](https://en.cppreference.com/w/cpp/language/value_category). In C++11, rvalues are broken into two subtypes: prvalues and xvalues, so the rvalues we’re talking about here are the sum of both of those categories. TODO 补充翻译

> **提示**
> 
> 如果你不确定某个表达式是左值还是右值，尝试使用 `&` 运算符获取其地址，`&` 需要其操作数是左值。如果 `&(表达式)` 可以编译通过，表达式必须是左值：

``` cpp
int foo()
{
    return 5;
}

int main()
{
    int x { 5 };
    &x; // 可以编译：x 是左值表达式
    &5; // 无法编译：5 是右值表达式
    &foo(); // 无法编译：foo() 是右值表达式
}
```

> **关键见解**
> 
> A C-style string literal is an lvalue because C-style strings (which are C-style arrays) decay to a pointer. The decay process only works if the array is an lvalue (and thus has an address that can be stored in the pointer). C++ inherited this for backwards compatibility. C 风格的字符串字面值是左值，因为 C 风格字符串（C 风格数组）会衰减 TODO 翻译有待商榷为指针。衰减过程仅在数组是左值时（因此具有可以存储在指针中的地址）才有效。C++ 为了向后兼容继承了这一点。
> 
> We cover array decay in lesson [17.8 -- C-style array decay](https://www.learncpp.com/cpp-tutorial/c-style-array-decay/). 

## Lvalue to rvalue conversion 左值到右值的转换
让我们再次看看这个例子：
``` cpp
int main()
{
    int x { 5 };
    int y { x }; // x 是一个左值表达式

    return 0;
}
```

如果 `x` 是求值为变量 `x` 的左值表达式，那么 `y` 是如何得到值 `5` 的呢？

答案是，在期望右值但提供了左值的上下文中，左值表达式将隐式地转换为右值表达式。`int` 变量的初始化器应为右值表达式。因此，左值表达式 `x` 经过左值到右值的转换，求值为值 `5`，然后用于初始化 `y`。

我们之前说过，赋值运算符要求右操作数是右值表达式，那么为什么像下面这样的代码可以正常工作呢？

``` cpp
int main()
{
    int x{ 1 };
    int y{ 2 };

    x = y; // y 是一个可修改的左值，不是右值，但这是合法的

    return 0;
}
```

在这种情况下，`y` 是一个左值表达式，但它经过了左值到右值的转换，求值为 `y` 的值（2），然后赋值给 `x`。

现在，考虑这个例子：

``` cpp
int main()
{
    int x { 2 };

    x = x + 1;

    return 0;
}
```

在这个语句中，变量 `x` 在两个不同的上下文中使用。在赋值运算符的左侧，`x` 是求值为变量 `x` 的左值表达式。在赋值运算符的右侧，`x + 1` 是求值为值 `3` 的右值表达式。

现在我们已经了解了左值，接下来可以讨论第一个复合类型：左值引用。

> **关键见解**
> 
> 一个识别左值和右值表达式的经验法则：
> 
> - 左值表达式是那些求值为函数或可识别对象（包括变量）的表达式，这些对象在表达式结束后仍然存在。
> - 右值表达式是那些求值为值的表达式，包括字面值和在表达式结束后不再存在的临时对象。


# 12.3 Lvalue references
# 12.4 Lvalue references to const
# 12.5 Pass by lvalue reference
# 12.6 Pass by const lvalue reference
# 12.7 Introduction to pointers
# 12.8 Null pointers
# 12.9 Pointers and const
# 12.10 Pass by address
# 12.11 Pass by address (part 2)
# 12.12 Return by reference and return by address
# 12.13 In and out parameters
# 12.14 Type deduction with pointers, references, and const
# 12.15 `std::optional`
# 12.x Chapter 12 summary and quiz

