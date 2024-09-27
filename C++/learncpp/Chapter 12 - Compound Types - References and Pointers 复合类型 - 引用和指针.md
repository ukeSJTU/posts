# 12.1 - Introduction to compound data types 复合数据类型简介

在 [[Chapter 4 - Fundamental Data Types#4.1 Introduction to fundamental data types 基本数据类型简介|4.1节——基本数据类型简介]] 中，我们介绍了基本数据类型，它们是C++作为核心语言的一部分提供的基础数据类型。

到目前为止，我们在程序中大量使用了这些基本类型，特别是`int`数据类型。虽然这些基本类型在简单使用时非常有用，但随着我们开始做更复杂的事情，它们无法满足我们的全部需求。

例如，假设你正在编写一个数学程序来讲两个分数相乘。你会如何在程序中表示一个分数？你可能会使用一对整数（一个表示分子，一个表示分母），就像这样：

```cpp
#include <iostream>

int main()
{
    // 我们的第一个分数
    int num1 {};
    int den1 {};

    // 我们的第二个分数
    int num2 {};
    int den2 {};

    // 用于移除分子和分母之间的斜杠
    char ignore {};

    std::cout << "输入一个分数: ";
    std::cin >> num1 >> ignore >> den1;

    std::cout << "输入一个分数: ";
    std::cin >> num2 >> ignore >> den2;

    std::cout << "两个分数相乘: "
        << num1 * num2 << '/' << den1 * den2 << '\n';

    return 0;
}
```

这个程序的运行结果：

``` plaintext
输入一个分数: 1/2
输入一个分数: 3/4
两个分数相乘: 3/8
```

虽然这个程序可以正常工作，但它带来了一些挑战需要我们改进。首先，每对整数之间的联系非常松散——除了注释和它们在代码中使用的上下文外，几乎没有什么提示说明每个分子和分母的配对是相关的。其次，遵循DRY（不要重复自己 don't repeat yourself）原则，我们应该创建一个函数来处理用户输入的分数（以及一些错误处理）。然而，函数只能返回一个值，那我们该如何将分子和分母返回给调用者呢？

现在想象另一种情况，你正在编写一个需要保存员工ID列表的程序。你可能会这样做：

```cpp
int main()
{
    int id1 { 42 };
    int id2 { 57 };
    int id3 { 162 };
    // and so on
}
```

但是如果你有100个员工呢？首先，你需要输入100个变量名。而如果你需要打印它们或传递给函数呢？我们将要输入大量的代码。这显然是不够灵活的。

显然，基本类型的应用是有限的。
## 复合数据类型

幸运的是，C++支持另一组数据类型，称为**复合数据类型(Compound data types)**。复合数据类型（有时也称为**复合类型(Composite data types)**）是可以由基本数据类型（或其他复合数据类型）构造的数据类型。每种复合数据类型也具有其独特的属性。

正如我们将在本章和后续章节中展示的那样，我们可以使用复合数据类型优雅地解决上述所有问题。

C++支持以下复合类型：
- 函数
- 数组
- 指针类型：
    - 指向对象的指针
    - 指向函数的指针
    - 指向成员类型的指针：
        - 指向数据成员的指针
        - 指向成员函数的指针
- 引用类型：
    - 左值引用
    - 右值引用
- 枚举类型：
    - 无作用域枚举
    - 有作用域枚举
- 类类型：
    - 结构体
    - 类
    - 联合体


你已经定期使用一种复合类型：函数。例如，考虑这个函数：

```cpp
void doSomething(int x, double y)
{
}
```

这个函数的类型是 `void(int, double)`。注意，这种类型是由基本数据类型组成的，因此它是一种复合类型。当然，函数还有其特殊的行为（例如，可以被调用）。

因为这里涉及的内容很多，我们会分多个章节来介绍。在本章中，我们将介绍一些较为直接的复合类型，包括**左值引用(`l-value references`)** 和**指针(`pointers`)** 。在下一章中，我们将介绍**无范围枚举(`unscoped enumerations`)**、**有范围枚举(`scoped enumerations`)** 和基本的**结构体(`structs`)** 。再往后的章节中，我们将引入类类型，并深入介绍一些更有用的**数组(`array`)**。这包括在 [[Chapter 5 - Constants and Strings#5.9 Introduction to `std string`|5.9 std::string 简介]] 中引入的 `std::string`，它实际上是一种类类型！

准备好了吗？让我们开始吧！
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

