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

在我们讨论第一个复合类型（**左值引用**）之前，我们先来简单介绍一下什么是**左值(lvalue)**。

在[[Chapter 1 - C++ basics#1.10 Introduction to expressions|1.10节——表达式简介]]中，我们将表达式定义为：“由字面值、变量、运算符和函数调用组成的一个组合，可以执行以产生单一值”。

例如：

```cpp
#include <iostream>

int main()
{
    std::cout << 2 + 3 << '\n'; // 表达式 2 + 3 生成值 5

    return 0;
}
```

在上面的程序中，表达式 `2 + 3` 计算后值是 `5`，然后将其打印到控制台。

在[[Chapter 6 - Operators#6.4 Increment/decrement operators, and side effects|第6.4节——自增/自减运算符及副作用]]中，我们还提到表达式可以产生超出表达式本身的副作用：

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

在上面的程序中，表达式`++x`增加了`x`的值，并且在表达式结束后`x`仍然保持更改。

除了产生值和副作用之外，表达式还可以做一件事：它们可以求值为**对象(objects)** 或**函数(functions)**。我们稍后将深入探讨这一点。
## 表达式的属性

为了帮助确定表达式应该如何评估以及它们可以在何处使用，C++中的所有表达式都有两个属性：**类型**和**值类别**。
### 表达式的类型

表达式的**类型**等同于求值后生成的值、对象或函数的类型。例如：

``` cpp
int main()
{
    auto v1 { 12 / 4 }; // int / int => int
    auto v2 { 12.0 / 4 }; // double / int => double

    return 0;
}
```

对于 `v1`，编译器将在编译时确定，两个`int`操作数的除法将产生一个`int`结果，因此该表达式的类型是 `int`。通过类型推断，`v1` 的类型将被设为 `int`。

对于`v2`，编译器将在编译时确定，一个`double`操作数和一个`int`操作数的除法将产生一个`double`结果。记住，算术运算符必须有匹配类型的操作数，因此在这种情况下，`int` 操作数将被转换为 `double`，并执行浮点除法。因此，该表达式的类型为 `double`。

编译器可以使用表达式的类型来确定表达式在给定的上下文中是否有效。例如：

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

在上面的程序中，`print(int)` 函数期望一个 `int` 参数。然而，我们传入的表达式（字符串字面值 `"foo"`）的类型不匹配，而且没有可以找到的转换。因此，产生编译错误。

注意，表达式的类型必须在编译时确定（否则类型检查和类型推断就无法工作）——然而，表达式的值可以在编译时（如果表达式是`constexpr`）或运行时（如果表达式不是`constexpr`）确定。
### 表达式的值类别

现在看一下这个程序：

``` cpp
int main()
{
    int x{};

    x = 5; // 有效：我们可以将 5 赋值给 x
    5 = x; // 错误：无法将 x 的值赋给字面值 5

    return 0;
}
```

其中，第一个赋值语句是有效的（将值 `5` 赋给变量 `x`），第二个则无效（将 `x` 的值赋给字面值 `5` 是没有意义的）。那么编译器如何知道哪些表达式可以合法地出现在赋值语句的两侧呢？

答案在于表达式的第二个属性：**值类别**。表达式（或子表达式）的**值类别**表示表达式解析为某种值、函数或某种对象。

在C++11之前，只有两种可能的值类别：**左值(lvalue)** 和 **右值(rvalue)**。

在 C++11 及以后，增加了三种额外的值类别：`glvalue`、`prvalue` 和 `xvalue` 以支持**移动语义(`move semantics`)** 这个新特性。

> [!note] 作者注
> 
> 在本课中，我们将坚持使用 C++11 之前的值类别观点，因为这更适合作为值类别的入门介绍（而且目前我们只需要这些内容）。我们将在以后的章节中讨论移动语义（以及新增的三种值类别）。
## 左值和右值表达式

**左值(`lvalue`)**（读作“ell-value”，是**左侧值(left value)** 或**定位值(locator value)** 的缩写，有时写作“l-value”）是一个计算为可识别的对象或函数（或位域）的表达式。

**"可识别性"(identity)** 是C++标准中使用的术语，但并没有明确定义。可识别的实体（例如对象或函数）可以与其他类似的实体区分开来（一般通过比较实体的地址）。

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

自从引入常量以来，左值有了两种子类型：**可修改的左值(modifiable lvalue)** 是可以修改其值的左值。**不可修改的左值(non-modifiable lvalue)** 是不能修改其值的左值（因为该左值是 `const` 或 `constexpr`）。

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

**右值(`rvalue`)**（读作“arr-value”，是**右侧值(right value)** 的缩写，有时写作“r-value”）指的是不属于左值的表达式。右值表达式解析为一个值。常见的右值包括字面值（除了 C 风格的字符串字面值，它们是左值）以及按值返回的函数和运算符的返回值。右值没有标识（这意味着它们必须立即使用），并且仅存在于它们被使用的表达式的范围内。

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

你可能想知道为什么 `return5()`、`x + 1` 和 `static_cast<int>(d)` 是右值：答案是这些表达式产生了没有标识的临时值。

> [!example] 关键见解
> 
> **左值表达式**解析为一个具有标识的、可识别的对象。
> **右值表达式**解析为一个值。

现在我们可以回答为什么 `x = 5` 是有效的，而 `5 = x` 是无效的：赋值操作要求赋值的左操作数是一个**可修改的左值表达式**，而右操作数是一个**右值表达式**。后一个赋值（`5 = x`）失败是因为左操作数表达式 `5` 不是左值。

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

> [!info] 相关内容
>  
>  完整的左值和右值表达式可以在[这里](https://en.cppreference.com/w/cpp/language/value_category)找到。在C++11及以后，右值分成两个子类别：`prvalues`和`xvalues`，所以我们这里讨论的右值包含了这两者。

> [!info] 提示
> 
> 如果你不确定某个表达式是左值还是右值，尝试使用 `&` 运算符获取其地址，`&` 需要其操作数是左值。如果 `&(表达式)` 可以编译通过，表达式必须是左值：
> 
> ``` cpp
> int foo()
> {
>     return 5;
> }
> 
> int main()
> {
>     int x { 5 };
>     &x; // 可以编译：x 是左值表达式
>     &5; // 无法编译：5 是右值表达式
>     &foo(); // 无法编译：foo() 是右值表达式
> }
> ```

> [!example] 关键见解
> 
> C风格的字符串字面值是一个左值，因为C风格的字符串（即C风格的数组）会**退化(decay)** 为指针。退化过程只有在数组是左值（并且有一个可以存储在指针中的地址）时才有效。C++为了向后兼容继承了这一特性。
> 
> 我们会在 [17.8 -- C-style array decay](https://www.learncpp.com/cpp-tutorial/c-style-array-decay/) 中讨论数组退化。 
## 左值到右值的转换

让我们再次看一下这个例子：

``` cpp
int main()
{
    int x { 5 };
    int y { x }; // x 是一个左值表达式

    return 0;
}
```

如果 `x` 是求值为变量 `x` 的左值表达式，那么 `y` 是如何得到值 `5` 的呢？

答案是：在需要右值的上下文中，左值表达式会**隐式转换为右值表达式**。`int`变量的初始化期望是一个右值表达式。因此，左值表达式`x`会经历**左值到右值转换(lvalue-to-rvalue conversion)**，计算为值`5`，然后用于初始化`y`。

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

在这种情况下，`y` 是一个左值表达式，但它经过了左值到右值的转换，求值为变量`y`的值（2），然后赋值给 `x`。

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

> [!example] 关键见解
> 
> 一个识别左值和右值表达式的经验法则：
> 
> - 左值表达式是那些解析为函数或可识别对象（包括变量）的表达式，这些对象在表达式结束后仍然存在。
> - 右值表达式是那些解析为值的表达式，包括字面值和在表达式结束后不再存在的临时对象。

# 12.3 Lvalue references 左值引用

在C++中，**引用(reference)** 是现有对象的别名。一旦定义了引用，对该引用的任何操作都会应用到所引用的对象上。

> [!example] 关键见解
>
> 本质上，引用与所引用的对象完全相同。

这意味着我们可以使用引用来读取或修改被引用的对象。尽管引用乍一看可能显得多余或无用，但它们在C++中被广泛使用（我们将在接下来的课程中看到许多例子）。

你也可以创建函数的引用，不过这较少使用。

现代C++包含两种类型的引用：**左值引用(lvalue reference)**和**右值引用(rvalue reference)**。在本章中，我们将讨论左值引用。

> [!info] 相关内容
>
> 由于我们将在本课中讨论左值和右值，如果你需要复习这些术语，请查看[[#12.2 Value categories (lvalues and rvalues) 数值类型（左值和右值）|12.2 —— 值类别（左值和右值）]]。右值引用将在[[Chapter 22 - Move Semantics and Smart Pointers|第22章]]关于移动语义的内容中介绍。

## 左值引用类型

**左值引用(lvalue reference)**（通常被简称为引用，因为在C++11之前只有一种引用类型）是现有左值（例如变量）的别名。

要声明一个左值引用类型，我们在类型声明中使用`&`符号：

```cpp
int // 一个普通的`int`类型 
int& // 一个指向`int`对象的左值引用 
double& // 一个指向`double`对象的左值引用
```

## 左值引用变量

左值引用类型的一个用途是创建**左值引用变量(lvalue reference variable)**。左值引用变量是一个充当某个左值（通常是另一个变量）引用的变量。

要创建左值引用变量，我们只需定义一个左值引用类型的变量：

```cpp
#include <iostream>

int main()
{
    int x { 5 };    // `x`是一个普通的整数变量
    int& ref { x }; // `ref`是一个左值引用变量，现在可以作为`x`的别名

    std::cout << x << '\n';  // 打印`x`的值 (5)
    std::cout << ref << '\n'; // 通过`ref`打印`x`的值 (5)

    return 0;
}
```

在上面的例子中，类型`int&`定义了`ref`作为一个指向`int`的左值引用，然后我们用左值表达式`x`来初始化它。从那时起，`ref`和`x`可以互换使用。因此，这个程序会输出：

``` plaintext
5
5
```

从编译器的角度来看，`&`符号是“附加”在类型名（`int& ref`）上还是变量名（`int &ref`）上无关紧要，如何选择取决于个人风格。现代C++程序员倾向于将`&`符号附加在类型名上，因为这样更清晰地表明引用是类型信息的一部分，而不是标识符。

> [!tip] 最佳实践
> 
> 当定义引用时，将`&`符号放在类型旁边（而不是引用变量的名称旁边）。

> [!info] 面向高级读者
> 
> 对于已经熟悉指针的人来说，这里的`&`符号并不表示“取地址”，而是表示“左值引用”。
## 通过左值引用修改值

在前面的例子中，我们展示了如何使用引用来读取被引用对象的值。我们也可以使用引用来修改被引用对象的值：

```cpp
#include <iostream>

int main()
{
    int x { 5 }; // 普通的整数变量
    int& ref { x }; // `ref`现在是`x`的别名

    std::cout << x << ref << '\n'; // 打印`55`

    x = 6; // `x`现在的值为6

    std::cout << x << ref << '\n'; // 打印`66`

    ref = 7; // 被引用的对象（`x`）现在的值为7

    std::cout << x << ref << '\n'; // 打印`77`

    return 0;
}
```

该代码输出：

``` plaintext
55
66
77
```

在上面的例子中，`ref`是`x`的别名，因此我们可以通过`x`或`ref`来改变`x`的值。
## 引用初始化

就像常量一样，所有的引用都必须初始化。引用使用一种称为**引用初始化(reference initialization)**的方式来进行初始化。

```cpp
int main()
{
    int& invalidRef;   // 错误：引用必须初始化

    int x { 5 };
    int& ref { x }; // 正确：`int`引用绑定到`int`变量

    return 0;
}
```

当引用被某个对象（或函数）初始化时，我们称其被**绑定(bound)** 到该对象（或函数）。这种引用被绑定的过程称为**引用绑定(reference binding)**。被引用的对象（或函数）有时被称为**被引用体(referent)**。

左值引用必须绑定到**可修改的左值**。

```cpp
int main()
{
    int x { 5 };
    int& ref { x }; // 有效：左值引用绑定到可修改的左值

    const int y { 5 };
    int& invalidRef { y };  // 无效：不能绑定到不可修改的左值
    int& invalidRef2 { 0 }; // 无效：不能绑定到右值

    return 0;
}
```

左值引用不能绑定到不可修改的左值或右值（否则你将能够通过引用修改这些值，这将违反它们的`const`特性）。因此，左值引用有时被称为“**指向非`const`的左值引用(non-const reference)**”。

在大多数情况下，引用的类型必须与被引用体的类型匹配。我们将在继承(`inheritance`)中讨论此规则的一些例外情况：

```cpp
int main()
{
    int x { 5 };
    int& ref { x }; // 正确：`int`引用绑定到`int`变量

    double y { 6.0 };
    int& invalidRef { y }; // 无效：`int`引用不能绑定到`double`变量
    double& invalidRef2 { x }; // 无效：`double`引用不能绑定到`int`变量

    return 0;
}
```

不允许存在指向`void`的左值引用（那有什么意义呢？）。
## 引用不能重新绑定（不能更改引用的对象）

一旦在C++中初始化了一个引用，它就不能被重新绑定，这意味着它不能被更改为引用另一个对象。

新手C++程序员通常试图通过赋值来重新绑定一个引用，将另一个变量赋给引用。这样做虽然可以编译并运行，但不会按预期工作。考虑以下程序：

```cpp
#include <iostream>

int main()
{
    int x { 5 };
    int y { 6 };

    int& ref { x }; // `ref`现在是`x`的别名

    ref = y; // 将`y`的值（6）赋给`ref`（即被`ref`引用的对象`x`）
    // 上面的语句并没有将`ref`更改为引用变量`y`！

    std::cout << x << '\n'; // 你可能期望它打印5

    return 0;
}
```

令人惊讶的是，这将输出：

``` plaintext
6
```

当在表达式中计算引用时，它会解析为它所引用的对象。因此，`ref = y`并不会将`ref`更改为引用`y`。相反，因为`ref`是`x`的别名，这个表达式会被解释为`x = y`——由于`y`的值为6，因此`x`被赋值为6。
## 左值引用的作用域和生命周期

引用变量遵循与普通变量相同的作用域和生命周期规则：

```cpp
#include <iostream>

int main()
{
    int x { 5 }; // 普通整数
    int& ref { x }; // 引用变量

     return 0;
} // `x`和`ref`在这里销毁
```
## 引用和被引用体的独立生命周期

有一个例外（我们将在下一节讨论），引用的生命周期和其被引用对象的生命周期是独立的。换句话说，以下两种情况都可能成立：

- 引用可以在它引用的对象之前被销毁。
- 被引用的对象可以在引用之前被销毁。

当引用在被引用体之前被销毁时，被引用体不会受到影响。下面的程序演示了这一点：

```cpp
#include <iostream>

int main()
{
    int x { 5 };

    {
        int& ref { x };   // `ref`是`x`的引用
        std::cout << ref << '\n'; // 打印`ref`的值（5）
    } // `ref`在此处被销毁 —— `x`对此毫不知情

    std::cout << x << '\n'; // 打印`x`的值（5）

    return 0;
} // `x`在此处被销毁
```

上述程序的输出为：
``` plaintext
5
5
```

当`ref`被销毁时，变量`x`继续正常存在，完全不知道它的引用已经被销毁。
### 悬空引用

当被引用的对象在引用之前被销毁时，引用将指向一个不再存在的对象。这样的引用称为**悬空引用(dangling reference)**。访问悬空引用会导致未定义行为。

悬空引用相对容易避免，但我们将在 [[Chapter 12 - Compound Types - References and Pointers 复合类型 - 引用和指针#12.12 Return by reference and return by address|12.12节——通过引用返回值和通过地址返回值]] 中展示一个在实践中可能发生的案例。
### 引用不是对象

可能让人惊讶的是，引用在C++中并不是对象。引用不需要存在或占据存储空间。如果可能，编译器将通过用被引用体替换引用的所有出现来优化引用。然而，这并不总是可行，在某些情况下，引用可能需要存储空间。

这也意味着“引用变量”这个术语有点误导，因为变量是具有名称的对象，而引用并不是对象。

由于引用不是对象，它们不能在需要对象的任何地方使用（例如，你不能有一个引用的引用，因为左值引用必须引用一个可识别的对象）。在你需要一个作为对象的引用或可以重新绑定的引用的情况下，`std::reference_wrapper`（我们将在 [[Chapter 23 - Object Relationships#23.3 Aggregation|23.3节——聚合]] 中讨论）提供了一个解决方案。

> [!note] 顺带一提
> 
> 考虑以下变量：
> 
> ```cpp
> int var{};
> int& ref1{ var };  // 一个绑定到`var`的左值引用
> int& ref2{ ref1 }; // 一个绑定到`var`的左值引用
> ```
> 
> 由于`ref2`（一个引用）是用`ref1`（一个引用）初始化的，你可能会认为`ref2`是一个引用的引用。事实并非如此。因为`ref1`是`var`的引用，当在表达式中使用时（例如在初始化中），`ref1`会解析为`var`。因此，`ref2`只是一个普通的左值引用（其类型为`int&`），绑定到`var`。
> 
> **引用的引用**（指向`int`的引用）语法是`int&&`，但由于C++不支持引用的引用，这个语法在C++11中被重新用于表示**右值引用**（我们将在 [[Chapter 22 - Move Semantics and Smart Pointers#22.2 R-value references|22.2节——右值引用]] 中讨论）。

> [!note] 作者注
> 
> 如果此时你觉得引用有点没用，不用担心。引用在很多地方都会用到，我们将在 [[#12.5 Pass by lvalue reference|12.5节——通过左值引用传递]] 和 [[#12.6 Pass by const lvalue reference|12.6节——通过`const`左值引用传递]] 中很快介绍它的主要用法。
## 小测

> [!question] Q1. 请自己确定以下程序的输出值（不要编译程序）。
> 
> ```cpp
> int main()
> {
>     int x{ 1 };
>     int& ref{ x };
> 
>     std::cout << x << ref << '\n';
> 
>     int y{ 2 };
>     ref = y;
>     y = 3;
> 
>     std::cout << x << ref << '\n';
> 
>     x = 4;
> 
>     std::cout << x << ref << '\n';
> 
>     return 0;
> }
> ```

> [!tip]- A1. 答案
> ``` plaintext
> 11  
> 22  
> 44
> ```
> 
> 因为`ref`绑定到`x`，所以`x`和`ref`是同义的，因此它们总是打印相同的值。`ref = y`这行代码将`y`的值（2）赋给`ref`，而不是将`ref`更改为引用`y`。随后的`y = 3`只会更改`y`的值。
# 12.4 Lvalue references to const 对常量的左值引用

在上一节 [[#12.3 Lvalue references 左值引用|12.3 —— 左值引用]] 中，我们说左值引用只能绑定到**可修改的左值**。这意味着下面的代码是非法的：

```cpp
int main()
{
    const int x { 5 }; // `x`是不可修改的（`const`）左值
    int& ref { x }; // 错误：`ref`不能绑定到不可修改的左值

    return 0;
}
```

这种用法是不允许的，因为它可能会允许我们通过非`const`引用（`ref`）修改`const`变量（`x`）。

那么，如果我们想为一个`const`变量创建一个引用该怎么办？普通的（指向非`const`值的）左值引用无法满足这种需求。
## 指向`const`的左值引用

通过在声明左值引用时使用`const`关键字，我们告诉左值引用将其所引用的对象视为`const`。这种引用称为**指向`const`值的左值引用** (有时也称为**指向`const`的引用** 或**`const`引用**)。

**指向`const`的左值引用**可以绑定到不可修改的左值：

```cpp
int main()
{
    const int x { 5 };    // `x`是不可修改的左值
    const int& ref { x }; // 合法：`ref`是指向`const`值的左值引用

    return 0;
}
```

因为**指向`const`的左值引用** 将其所引用的对象视为`const`，所以它们可以用于访问但不能修改被引用的值：

```cpp
#include <iostream>

int main()
{
    const int x { 5 };    // `x`是不可修改的左值
    const int& ref { x }; // 合法：`ref`是指向`const`值的左值引用

    std::cout << ref << '\n'; // 合法：我们可以访问`const`对象
    ref = 6;                  // 错误：我们不能通过`const`引用修改对象

    return 0;
}
```
## 使用可修改的左值初始化指向`const`的左值引用

**指向`const`的左值引用** 也可以绑定到**可修改的左值**。在这种情况下，通过引用访问的对象被视为`const`（尽管底层对象是非`const`的）：

```cpp
#include <iostream>

int main()
{
    int x { 5 };          // `x`是可修改的左值
    const int& ref { x }; // 合法：我们可以将`const`引用绑定到可修改的左值

    std::cout << ref << '\n'; // 合法：我们可以通过`const`引用访问对象
    ref = 7;                  // 错误：我们不能通过`const`引用修改对象

    x = 6;                // 合法：`x`是可修改的左值，我们仍然可以通过原始标识符修改它

    return 0;
}
```

在上面的程序中，我们将`const`引用`ref`绑定到可修改的左值`x`。然后我们可以使用`ref`访问`x`，但因为`ref`是`const`，我们不能通过`ref`修改`x`的值。然而，我们仍然可以直接使用标识符`x`来修改`x`的值。

> [!tip] 最佳实践
>
> 除非你需要修改被引用的对象，否则应该优先使用**指向`const`的左值引用**而不是**指向非`const`的左值引用**。
## 使用右值初始化指向`const`的左值引用

可能令人惊讶的是，**指向`const`的左值引用** 也可以绑定到右值：

```cpp
#include <iostream>

int main()
{
    const int& ref { 5 }; // 合法：`5`是一个右值

    std::cout << ref << '\n'; // 打印5

    return 0;
}
```

当这种情况发生时，会创建一个临时对象并用右值进行初始化，然后将`const`引用绑定到该临时对象。

> [!info] 相关内容
> 
> 我们在 [[Chapter 2 - C++ Basics - Functions and Files#2.5 Introduction to local scope|2.5 —— 局部作用域简介]] 中介绍了临时对象。
## 使用不同类型的值初始化指向`const`的左值引用

**指向`const`的左值引用** 甚至可以绑定到不同类型的值，只要这些值可以隐式转换为引用类型：

```cpp
#include <iostream>

int main()
{
    // 情况1
    const double& r1 { 5 };  // 用值5初始化的临时`double`，`r1`绑定到该临时对象

    std::cout << r1 << '\n'; // 打印5

    // 情况2
    char c { 'a' };
    const int& r2 { c };     // 用值'a'初始化的临时`int`，`r2`绑定到该临时对象

    std::cout << r2 << '\n'; // 打印97（因为`r2`是指向`int`的引用）

    return 0;
}
```

在情况1中，一个类型为`double`的临时对象被创建并用`int`值`5`初始化。然后`const double& r1`绑定到该临时`double`对象。

在情况2中，一个类型为`int`的临时对象被创建并用`char`值`'a'`初始化。然后`const int& r2`绑定到该临时`int`对象。

在这两种情况下，引用的类型和临时对象的类型是匹配的。

> [!example] 关键见解
> 
> 如果你尝试将一个`const`左值引用绑定到不同类型的值，编译器会创建一个与引用类型相同的临时对象，使用该值进行初始化，然后将引用绑定到临时对象。

还要注意，当我们打印`r2`时，它以`int`的形式打印而不是`char`。这是因为`r2`是指向`int`对象（创建的临时`int`）的引用，而不是`char`变量`c`。

尽管这看起来有些奇怪，但我们将在 [[Chapter 12 - Compound Types - References and Pointers 复合类型 - 引用和指针#12.6 Pass by const lvalue reference|12.6 通过`const`左值引用传递]] 中看到一些有用的例子。
## 绑定到临时对象的`const`引用会延长临时对象的生命周期

通常，临时对象会在创建它们的表达式结束时被销毁。

然而，考虑上面的例子，如果用于保存右值`5`的临时对象在初始化`ref`的表达式结束时被销毁，会发生什么呢？引用`ref`将变成悬空引用（指向一个已被销毁的对象），当我们尝试访问`ref`时会产生未定义行为。

为了避免这种情况下发生悬空引用，C++有一个特殊规则：当一个`const`左值引用**直接** 绑定到临时对象时，临时对象的生命周期将延长至与引用的生命周期一致。

```cpp
#include <iostream>

int main()
{
    const int& ref { 5 }; // 用于保存值5的临时对象的生命周期延长至与`ref`一致

    std::cout << ref << '\n'; // 因此，我们可以安全地在这里使用它

    return 0;
} // `ref`和临时对象在此处同时销毁
```

在上面的例子中，当`ref`用右值`5`初始化时，创建了一个临时对象，`ref`绑定到该临时对象。临时对象的生命周期与`ref`匹配。因此，我们可以安全地在接下来的语句中打印`ref`的值。然后，`ref`和临时对象在代码块结束时同时超出作用域并被销毁。

> [!example] 关键见解
> 
> - 左值引用只能绑定到可修改的左值。
> - **指向`const`的左值引用** 可以绑定到**可修改的左值**、**不可修改的左值** 和**右值**。这使得它们成为一种更灵活的引用类型。

> [!info] 面向高级读者
> 
> 生命周期延长仅适用于直接绑定到临时对象的`const`引用。从函数返回的临时对象（即使是通过`const`引用返回的）不符合生命周期延长的条件。
> 
> 我们将在 [[#12.12 Return by reference and return by address|12.12 通过引用返回值和通过地址返回值]] 中展示一个例子。

那么，为什么C++允许`const`引用绑定到右值呢？我们将在下一节中回答这个问题！
## `constexpr`左值引用

当应用于引用时，`constexpr`允许引用用于常量表达式。`constexpr`引用有一个特定的限制：它们只能绑定到具有静态持续时间的对象（全局变量或静态局部变量）。这是因为编译器知道静态对象将在内存中的哪个位置被实例化，因此可以将该地址视为编译时常量。

`constexpr`引用不能绑定到（非静态的）局部变量。这是因为局部变量的地址在其所在的函数被调用之前是未知的。

```cpp
int g_x { 5 };

int main()
{
    [[maybe_unused]] constexpr int& ref1 { g_x }; // 合法，可以绑定到全局变量

    static int s_x { 6 };
    [[maybe_unused]] constexpr int& ref2 { s_x }; // 合法，可以绑定到静态局部变量

    int x { 6 };
    [[maybe_unused]] constexpr int& ref3 { x }; // 编译错误：不能绑定到非静态对象

    return 0;
}
```

当定义一个指向`const`变量的`constexpr`引用时，我们需要同时使用`constexpr`（应用于引用）和`const`（应用于被引用的类型）。

```cpp
int main()
{
    static const int s_x { 6 }; // 一个`const` `int`
    [[maybe_unused]] constexpr const int& ref2 { s_x }; // 需要同时使用`constexpr`和`const`

    return 0;
}
```

鉴于这些限制，`constexpr`引用并不常用。
# 12.5 通过左值引用传递

在前面的课程中，我们介绍了**左值引用**( [[#12.3 Lvalue references 左值引用|12.3 左值引用]] )和**指向`const`的左值引用**( [[#12.4 Lvalue references to const 对常量的左值引用|12.4 左值引用到`const`]] )。单独看这些内容时，它们可能显得不太有用——为什么要创建一个变量的别名，而不直接使用变量本身呢？

在本节中，我们将深入了解引用的实际用途。接下来在本章的后续内容中，你会看到引用的常规使用。

首先，回顾一下背景知识。在 [[Chapter 2 - C++ Basics - Functions and Files#2.4 Introduction to function parameters and arguments|2.4 —— 函数参数和实参简介]] 中，我们讨论了**按值传递(pass by value)**，即将传递给函数的参数复制到函数的参数中：

```cpp
#include <iostream>

void printValue(int y)
{
    std::cout << y << '\n';
} // `y`在此处被销毁

int main()
{
    int x { 2 };

    printValue(x); // `x`按值传递（被复制）到参数`y`中（开销很小）

    return 0;
}
```

在上面的程序中，当调用`printValue(x)`时，`x`的值（`2`）被**复制**到参数`y`中。然后，在函数结束时，对象`y`被销毁。

这意味着当我们调用函数时，我们复制了参数的值，但只是短暂地使用它，然后将其销毁！幸运的是，由于基本类型的复制开销很小，这并不是问题。
## 某些对象的复制成本较高

标准库中提供的大多数类型（例如`std::string`）是**类类型（class types）**。类类型的复制通常成本较高。我们希望尽可能避免对复制成本较高的对象进行不必要的复制，特别是在我们几乎会立即销毁这些副本的情况下。

让我们看一下下面这个程序来理解问题所在：

```cpp
#include <iostream>
#include <string>

void printValue(std::string y)
{
    std::cout << y << '\n';
} // `y`在此处被销毁

int main()
{
    std::string x { "Hello, world!" }; // `x`是一个`std::string`

    printValue(x); // `x`按值传递（被复制）到参数`y`中（开销很大）

    return 0;
}
```

这会打印：

``` plaintext
Hello, world!
```

虽然该程序按预期运行，但效率低下。与前一个例子一样，当调用`printValue()`时，实参`x`被复制到`printValue()`的参数`y`中。然而，在这个例子中，实参是`std::string`而不是`int`，`std::string`是一个复制成本很高的类类型。而且每次调用`printValue()`时，都会进行这样“昂贵”的复制！

我们可以做得更好。
## 按引用传递

一种在调用函数时避免对参数进行昂贵复制的方法是使用 **按引用传递(pass by reference)** 而不是**按值传递**。使用 **按引用传递** 时，我们将函数参数声明为引用类型（或`const`引用类型）而不是普通类型。当函数被调用时，每个引用参数会绑定到相应的实参。因为引用只是实参的别名而不是一个完整的对象，所以不会对实参进行复制。

下面这个示例代码使用 **按引用传递** 而不是**按值传递**：

```cpp
#include <iostream>
#include <string>

void printValue(std::string& y) // 参数类型改为`std::string&`
{
    std::cout << y << '\n';
} // `y`在此处被销毁

int main()
{
    std::string x { "Hello, world!" };

    printValue(x); // `x`现在通过引用传递到引用参数`y`中（开销很小）

    return 0;
}
```

该程序与之前的例子相同，唯一的区别是参数`y`的类型从`std::string`更改为`std::string&`（一个左值引用）。现在，当调用`printValue(x)`时，左值引用参数`y`被绑定到实参`x`。绑定引用的开销始终很小，不需要对`x`进行复制。因为引用是被引用对象的别名，所以当`printValue()`使用引用`y`时，它实际上是在访问实参`x`（而不是`x`的副本）。

> [!example] 关键见解
> 
> **按引用传递**允许我们在调用函数时传递参数，而无需每次都对这些参数进行复制。
## 按引用传递允许我们修改实参的值

当对象按值传递时，函数参数接收的是实参的副本。这意味着对参数值的任何更改都只会影响参数的副本，而不会影响实参本身：

```cpp
#include <iostream>

void addOne(int y) // `y`是`x`的副本
{
    ++y; // 这只会修改`x`的副本，而非实际的对象`x`
}

int main()
{
    int x { 5 };

    std::cout << "value = " << x << '\n';

    addOne(x);

    std::cout << "value = " << x << '\n'; // `x`没有被修改

    return 0;
}
```

在上面的程序中，由于值参数`y`是`x`的副本，当我们递增`y`时，这只会影响`y`。该程序输出：

``` plaintext
value = 5
value = 5
```

然而，由于引用与被引用对象相同，因此在使用**按引用传递**时，对引用参数进行的任何更改都会影响实参：

```cpp
#include <iostream>

void addOne(int& y) // `y`绑定到实际的对象`x`
{
    ++y; // 这会修改实际的对象`x`
}

int main()
{
    int x { 5 };

    std::cout << "value = " << x << '\n';

    addOne(x);

    std::cout << "value = " << x << '\n'; // `x`已经被修改

    return 0;
}
```

该程序输出：

``` plaintext
value = 5
value = 6
```

在上面的例子中，`x`最初的值是`5`。当调用`addOne(x)`时，引用参数`y`绑定到实参`x`。当`addOne()`函数递增引用`y`时，它实际上递增了实参`x`，从`5`变为`6`（而不是`x`的副本）。即使`addOne()`执行完毕，这个更改后的值也会保留下来。

> [!example] 关键见解
> 
> 将值按非`const`引用传递，允许我们编写可以修改传入参数值的函数。

让函数修改传入参数值的能力很有用。想象一下，你编写了一个函数来确定怪物是否成功攻击了玩家。如果是，则怪物应对玩家的生命值造成一定的伤害。如果你通过引用传递玩家对象，函数可以直接修改传入的实际玩家对象的生命值。如果你按值传递玩家对象，则只能修改玩家对象的副本，这不如直接修改实用。
## 按引用传递只能接受可修改的左值实参

因为指向非`const`值的引用只能绑定到可修改的左值（本质上是非`const`变量），这意味着按引用传递只适用于可修改的左值实参。从实际角度来看，这极大地限制了按非`const`引用传递的用途，因为它意味着我们不能传递`const`变量或字面值。例如：

```cpp
#include <iostream>

void printValue(int& y) // `y`只接受可修改的左值
{
    std::cout << y << '\n';
}

int main()
{
    int x { 5 };
    printValue(x); // 合法：`x`是可修改的左值

    const int z { 5 };
    printValue(z); // 错误：`z`是不可修改的左值

    printValue(5); // 错误：`5`是右值

    return 0;
}
```

幸运的是，有一个简单的解决方法，我们将在下一节讨论。我们还将讨论何时使用按值传递和按引用传递。
# 12.6 - Pass by const lvalue reference 通过`const`左值引用传递

与只能绑定到可修改左值的非`const`引用不同，`const`引用可以绑定到可修改左值、不可修改左值和右值。因此，如果我们将引用参数声明为`const`，那么它将能够绑定到任何类型的实参：

```cpp
#include <iostream>

void printRef(const int& y) // `y`是一个`const`引用
{
    std::cout << y << '\n';
}

int main()
{
    int x { 5 };
    printRef(x);   // 合法：`x`是一个可修改的左值，`y`绑定到`x`

    const int z { 5 };
    printRef(z);   // 合法：`z`是一个不可修改的左值，`y`绑定到`z`

    printRef(5);   // 合法：`5`是右值字面值，`y`绑定到临时`int`对象

    return 0;
}
```

通过`const`引用传递与通过引用传递的主要好处相同（避免复制实参），同时还保证了函数**不能**更改被引用的值。

例如，以下代码是不允许的，因为`ref`是`const`常量：

```cpp
void addOne(const int& ref)
{
    ++ref; // 不允许：`ref`是`const`
}
```

在大多数情况下，我们不希望函数修改实参的值。

> [!tip] 最佳实践
> 
> 除非有特定的理由（例如函数需要更改实参的值），否则应优先通过`const`引用传递，而不是通过非`const`引用传递。

现在我们就能够理解为什么要允许`const`左值引用绑定到右值上：如果不能这样的话，我们就没有办法向按引用传递的函数传递字面量（或者其他右值）了。
## 将不同类型的值传递给`const`左值引用参数

在 [[#12.4 Lvalue references to const 对常量的左值引用|12.4 左值引用到`const`]] 中，我们提到`const`左值引用可以绑定到不同类型的值，只要该值可以转换为引用的类型。允许这样做的主要动机是可以以相同的方式将值作为实参传递给值参数或`const`引用参数：

```cpp
#include <iostream>

void printVal(double d)
{
    std::cout << d << '\n';
}

void printRef(const double& d)
{
    std::cout << d << '\n';
}

int main()
{
    printVal(5); // `5`被转换为临时`double`，并复制到参数`d`
    printRef(5); // `5`被转换为临时`double`，并绑定到参数`d`

    return 0;
}
```
## 混合按值和按引用传递

具有多个参数的函数可以单独确定每个参数是按值传递还是按引用传递。例如：

```cpp
#include <string>

void foo(int a, int& b, const std::string& c)
{
}

int main()
{
    int x { 5 };
    const std::string s { "Hello, world!" };

    foo(5, x, s);

    return 0;
}
```

在上述例子中，第一个实参是按值传递的，第二个是按引用传递的，第三个是通过`const`引用传递的。
## 何时使用(`const`)引用传递

由于类类型的复制成本可能很高（有时相当高），类类型通常通过`const`引用传递，而不是按值传递，以避免对实参进行昂贵的复制。基本类型复制成本较低，因此通常按值传递。

> [!tip] 最佳实践
> 
> 作为经验法则，基本类型按值传递，类（或结构）类型通过`const`引用传递。
> 
> - 其他通常按值传递的类型：枚举类型和`std::string_view`。  
> - 其他通常按（`const`）引用传递的类型：`std::string`、`std::array`和`std::vector`。
## 按值传递与按引用传递的成本

并不是所有的类类型都需要通过引用传递。你可能会问，为什么我们不把所有内容都通过引用传递呢？在本节（可选阅读）中，我们讨论按值传递与按引用传递的成本，并完善我们的最佳实践，以确定何时应该使用每种方式。

要了解何时应按值传递与按引用传递，有两个关键点：

1. 复制对象的成本通常与两件事成正比：
    
    - 对象的大小。占用更多内存的对象需要更多时间复制。
    - 任何额外的设置成本。一些类类型在实例化时会执行额外的设置（例如打开文件或数据库，或分配一定量的动态内存来保存可变大小的对象）。这些设置成本在每次复制对象时都必须支付。
2. 绑定引用到对象始终是快速的（大约与复制基本类型的速度相同）。


通过引用访问对象比通过普通变量标识符访问对象稍微昂贵一些。使用变量标识符时，运行的程序可以直接访问分配给该变量的内存地址并获取值。而通过引用访问时，通常需要额外一步：程序必须首先访问引用以确定所引用的对象，然后才能前往该对象的内存地址并获取值。编译器有时也可以对使用按值传递的对象的代码进行更高效的优化，这意味着对通过引用传递的对象的访问通常比对按值传递对象的访问慢。

现在我们可以回答为什么不把所有内容都按引用传递的问题了：

- 对于复制成本较低的对象，复制成本与绑定成本相似，因此我们更倾向于按值传递，以使生成的代码更快。
- 对于复制成本较高的对象，复制成本占主导地位，因此我们更倾向于通过（`const`）引用传递以避免复制。

> [!tip] 最佳实践
> 
> 对于复制成本较低的对象，优先按值传递；对于复制成本较高的对象，优先通过`const`引用传递。如果不确定对象的复制成本是高还是低，优先通过`const`引用传递。

最后一个问题就是我们如何定义“复制成本低”？这没有绝对的答案，因为这取决于编译器、使用场景和架构。然而，我们可以形成一个好的经验法则：如果对象使用的内存不超过2个“字（word）”的大小（一个“字”大致为一个内存地址的大小），并且没有额外的设置成本，那么它的复制成本就是低的。

以下程序定义了一个类似函数的宏，可以根据对象或类型判断其复制成本是否较低：

```cpp
#include <iostream>

// 函数宏，如果类型（或对象）大小小于或等于两个内存地址的大小，则返回true
#define isSmall(T) (sizeof(T) <= 2 * sizeof(void*))

struct S
{
    double a;
    double b;
    double c;
};

int main()
{
    std::cout << std::boolalpha; // 打印true或false，而不是1或0
    std::cout << isSmall(int) << '\n'; // true

    double d {};
    std::cout << isSmall(d) << '\n'; // true
    std::cout << isSmall(S) << '\n'; // false

    return 0;
}
```

> [!info] 顺带一提
> 因为C++的函数不允许将类型名作为参数进行传递，我们使用预处理的函数宏，这样我们可以将一个对象或者类型名作为参数。

但是想要知道某类对象有没有额外的设置成本比较困难。除非你明确知道没有，你最好还是假设大部分标准库里的类有设置成本。

> [!tip] 提示
> 
> 如果类型`T`的大小`sizeof(T) <= 2 * sizeof(void*)`，并且没有额外的设置成本，那么`T`的对象的复制成本就是低的。
## 函数参数中，优先使用`std::string_view`而不是`const std::string&`

一个经常在现代C++中出现的问题是：当编写具有字符串参数的函数时，参数类型应该是`const std::string&`还是`std::string_view`？

在大多数情况下，`std::string_view`是更好的选择，因为它可以高效处理更广泛的实参类型。

```cpp
void doSomething(const std::string&);
void doSomething(std::string_view);   // 大多数情况下优先使用这个
```

但下面这几种情况下使用`const std::string&`参数可能更合适：

- 如果你使用C++14或更早版本，`std::string_view`不可用。
- 如果你的函数需要调用另一个接收C风格字符串或`std::string`参数的函数，那么`const std::string&`可能是更好的选择，因为`std::string_view`不保证以空字符结尾（这是C风格字符串函数所期望的），并且不能高效地转换回`std::string`。

> [!tip] 最佳实践
> 
> 在传递字符串时，优先使用`std::string_view`（按值）而不是`const std::string&`，除非你的函数调用了需要C风格字符串或`std::string`参数的其他函数。

## 为什么`std::string_view`参数比`const std::string&`效率更高

在C++中，字符串参数的类型一般是`std::string`，`std::string_view`或C风格的字符串（字面量）。

As reminders:

- If the type of an argument does not match the type of the corresponding parameter, the compiler will try to implicitly convert the argument to match the type of the parameter.
- Converting a value creates a temporary object of the converted type.
- Creating (or copying) a `std::string_view` is inexpensive, as `std::string_view` does not make a copy of the string it is viewing.
- Creating (or copying) a `std::string` can be expensive, as each `std::string` object makes a copy of the string.

Here’s a table showing what happens when we try to pass each type:

|Argument Type|std::string_view parameter|const std::string& parameter|
|---|---|---|
|std::string|Inexpensive conversion|Inexpensive reference binding|
|std::string_view|Inexpensive copy|Requires expensive explicit conversion to `std::string`|
|C-style string / literal|Inexpensive conversion|Expensive conversion|

With a `std::string_view` value parameter:

- If we pass in a `std::string` argument, the compiler will convert the `std::string` to a `std::string_view`, which is inexpensive, so this is fine.
- If we pass in a `std::string_view` argument, the compiler will copy the argument into the parameter, which is inexpensive, so this is fine.
- If we pass in a C-style string or string literal, the compiler will convert these to a `std::string_view`, which is inexpensive, so this is fine.

As you can see, `std::string_view` handles all three cases inexpensively.

With a `const std::string&` reference parameter:

- If we pass in a `std::string` argument, the parameter will reference bind to the argument, which is inexpensive, so this is fine.
- If we pass in a `std::string_view` argument, the compiler will refuse to do an implicit conversion, and produce a compilation error. We can use `static_cast` to do an explicit conversion (to `std::string`), but this conversion is expensive (since `std::string` will make a copy of the string being viewed). Once the conversion is done, the parameter will reference bind to the result, which is inexpensive. But we’ve made an expensive copy to do the conversion, so this isn’t great.
- If we pass in a C-style string or string literal, the compiler will implicitly convert this to a `std::string`, which is expensive. So this isn’t great either.

Thus, a `const std::string&` parameter only handles `std::string` arguments inexpensively.

The same, in code form:

```cpp
#include <iostream>
#include <string>
#include <string_view>

void printSV(std::string_view sv)
{
    std::cout << sv << '\n';
}

void printS(const std::string& s)
{
    std::cout << s << '\n';
}

int main()
{
    std::string s{ "Hello, world" };
    std::string_view sv { s };

    // Pass to `std::string_view` parameter
    printSV(s);              // ok: inexpensive conversion from std::string to std::string_view
    printSV(sv);             // ok: inexpensive copy of std::string_view
    printSV("Hello, world"); // ok: inexpensive conversion of C-style string literal to std::string_view

    // pass to `const std::string&` parameter
    printS(s);              // ok: inexpensive bind to std::string argument
    printS(sv);             // compile error: cannot implicit convert std::string_view to std::string
    printS(static_cast<std::string>(sv)); // bad: expensive creation of std::string temporary
    printS("Hello, world"); // bad: expensive creation of std::string temporary

    return 0;
}
```

Additionally, we need to consider the cost of accessing the parameter inside the function. Because a `std::string_view` parameter is a normal object, the string being viewed can be accessed directly. Accessing a `std::string&` parameter requires an additional step to get to the referenced object before the string can be accessed.
# 12.7 - Introduction to pointers 指针简介

**指针(pointers)** 是 C++ 中的“历史难点”之一，许多学习 C++ 的人都会在这里遇到卡壳。但是你马上就会看到，指针并没有什么好害怕的。

事实上，指针和左值引用有很多相似之处。不过，在深入解释之前，我们先做一些准备工作。

> [!info] 相关内容
> 
> 如果你对左值引用不熟悉，现在是复习它们的好时机。我们在[[#12.3 Lvalue references 左值引用|12.3 —— 左值引用]]、[[#12.4 Lvalue references to const 对常量的左值引用|12.4 —— 指向`const`的左值引用]]以及[[#12.5 通过左值引用传递|12.5 —— 通过左值引用传递]]中介绍了左值引用。

来看一个普通的变量，如下所示：

```cpp
char x {}; // `char`类型占用1个字节的内存
```

当为这个变量生成的代码被执行时，一块来自RAM的内存将会被分配给这个对象。为了方便举例，假设变量`x`被分配的内存地址是`140`。无论何时我们在表达式或语句中使用变量`x`，程序将会前往内存地址`140`来访问存储在那里的值。

变量的好处在于我们不需要关心具体分配了什么内存地址，或对象值存储需要多少字节。我们只需通过变量的标识符来引用它，编译器会将这个名字转换为相应的内存地址。编译器负责所有的地址处理。

这对于引用来说也同样适用：

```cpp
int main()
{
    char x {}; // 假设它被分配的内存地址是140
    char& ref { x }; // `ref`是对`x`的左值引用（当与类型一起使用时，`&`表示左值引用）

    return 0;
}
```

因为`ref`是`x`的别名，所以无论何时我们使用`ref`，程序都会前往内存地址`140`来访问值。编译器同样会处理所有的地址问题，因此我们无需考虑这些细节。
## 取地址运算符（&）

虽然默认情况下变量的内存地址不会暴露给我们，但我们可以获取这些信息。**取地址运算符**（&）可以返回其操作数的内存地址。用法非常简单：

```cpp
#include <iostream>

int main()
{
    int x{ 5 };
    std::cout << x << '\n';  // 打印变量`x`的值
    std::cout << &x << '\n'; // 打印变量`x`的内存地址

    return 0;
}
```

在作者的计算机上，上述程序输出：

``` plaintext
5
0027FEA0
```

在这个例子中，我们使用取地址运算符`&`来获取分配给变量`x`的地址，并将该地址打印到控制台。内存地址通常以十六进制形式打印（十六进制在[[Chapter 5 - Constants and Strings#5.3 数字系统（十进制、二进制、十六进制和八进制）|5.3 —— 数字系统（十进制、二进制、十六进制和八进制）]]中介绍过），通常没有`0x`前缀。

对于使用多个字节内存的对象，取地址运算符将返回对象第一个字节的内存地址。

> [!tip] 提示
> `&`符号容易引起混淆，因为它在不同的上下文中具有不同的含义：
> - 当跟在类型名称后面时，`&`表示左值引用：`int& ref`。
> - 当在表达式中以一元运算符的形式使用时，`&`是取地址运算符：`std::cout << &x`。
> - 当在表达式中以二元运算符的形式使用时，`&`是按位与运算符：`std::cout << x & y`。

## 解引用运算符（*）

仅仅获取一个变量的地址并不太有用。

最有用的是，我们可以使用这个地址来访问存储在该地址的值。**解引用运算符(`*`)**（有时也称为**间接运算符(indirection operator)**）返回给定内存地址处的值，并将其作为左值：

```cpp
#include <iostream>

int main()
{
    int x{ 5 };
    std::cout << x << '\n';  // 打印变量`x`的值
    std::cout << &x << '\n'; // 打印变量`x`的内存地址

    std::cout << *(&x) << '\n'; // 打印变量`x`内存地址处的值（括号不是必须的，但可以提高可读性）

    return 0;
}
```

在作者的计算机上，以上程序输出：

``` plaintext
5
0027FEA0
5
```

这个程序很简单。首先，我们声明一个变量`x`并打印它的值。然后我们打印变量`x`的地址。最后，我们使用解引用运算符获取变量`x`内存地址处的值（就是`x`的值），并将其打印到控制台。

> [!example] 关键见解
> 
> 给定一个内存地址，我们可以使用解引用运算符(`*`)来获取该地址处的值（作为左值）。
> 取地址运算符(`&`)和解引用运算符(`*`)是相反的操作：取地址获取对象的地址，解引用获取指定地址处的对象。

> [!tip] 提示
> 尽管解引用运算符看起来和乘法运算符一样，但你可以区分它们，因为解引用运算符是一元的，而乘法运算符是二元的。

获取一个变量的内存地址然后立即解引用以获取该地址的值并不是很有用（毕竟我们可以直接使用变量来访问值）。但现在我们已经有了取地址运算符(`&`)和解引用运算符(`*`)，可以开始谈论指针了。
## 指针

**指针(pointers)** 是一个对象，它将内存地址（通常是另一个变量的地址）作为其值。这使我们可以存储其他对象的地址，以便以后使用。

> [!note] As an aside… 顺带一提
> 
> 在现代C++中，我们现在讨论的指针有时被称为“原生指针(raw pointers)”或“哑指针(dumb pointers)”，以和最近加入语言的“智能指针”进行区分。我们将在 [[Chapter 22 - Move Semantics and Smart Pointers|第22章]] 中讨论智能指针。

与引用类型使用`&`字符声明类似，指针类型使用星号`*`来声明：

```cpp
int;  // 普通的`int`
int&; // 指向`int`值的左值引用

int*; // 指向`int`值的指针（保存整数值的地址）
```

要创建一个指针变量，我们只需定义一个指针类型的变量：

```cpp
int main()
{
    int x { 5 };    // 普通变量
    int& ref { x }; // 一个整数引用（绑定到`x`）

    int* ptr;       // 一个指向整数的指针

    return 0;
}
```

请注意，这里的星号是指针声明语法的一部分，并不是解引用运算符。


> [!tip] 最佳实践
> 声明指针类型时，将星号放在类型名称旁边。

> [!warning] 警告
> 虽然通常不应该在一行上声明多个变量，但如果你一定要这么做，星号必须包含在每个变量的声明中。
> 
> ```cpp
> int* ptr1, ptr2;   // 错误：`ptr1`是指向`int`的指针，但`ptr2`只是一个普通的`int`！
> int* ptr3, *ptr4;  // 正确：`ptr3`和`ptr4`都是指向`int`的指针
> 
> ```
> 
> 有些人会因此认为不应该将星号放在类型名称旁边，而应放在变量名旁边，但更好的建议是避免在同一语句中定义多个变量。

## 指针初始化

像普通变量一样，指针默认情况下**不会**被初始化。未初始化的指针有时称为**野指针(wild pointer)**。野指针包含一个垃圾地址，解引用野指针会导致未定义行为。因此，你应该始终将指针初始化为一个已知值。

> [!tip] 最佳实践
> 每次都初始化你的指针。

```cpp
int main()
{
    int x{ 5 };

    int* ptr;        // 未初始化的指针（包含垃圾地址）
    int* ptr2{};     // 空指针（我们将在下一课讨论）
    int* ptr3{ &x }; // 用变量`x`的地址初始化指针

    return 0;
}
```

由于指针保存的是地址，因此在初始化或赋值给指针时，该值必须是一个地址。通常，指针用于保存另一个变量的地址（我们可以使用取地址运算符`&`来获取该地址）。

一旦我们有一个指针保存了另一个对象的地址，我们就可以使用解引用运算符`*`来访问该地址处的值。例如：

```cpp
#include <iostream>

int main()
{
    int x{ 5 };
    std::cout << x << '\n'; // 打印变量`x`的值

    int* ptr{ &x }; // `ptr`保存`x`的地址
    std::cout << *ptr << '\n'; // 使用解引用运算符打印`ptr`保存的地址处的值（即`x`的地址）

    return 0;
}
```

这将打印：

``` plaintext
5
5
```

从概念上来说，你可以像这样理解上面的代码片段：
![](https://www.learncpp.com/images/CppTutorial/Section6/6-Pointer.png?ezimgfmt=rs:409x145/rscb2/ng:webp/ngcb2)

这就是指针名称的由来——`ptr`保存了`x`的地址，因此我们说`ptr`“指向”`x`。

> [!note] 作者注
> 关于指针命名法：`X pointer`（其中X是某个类型）是“指向X的指针”的常用简写。因此，当我们说“一个整数指针”时，我们实际上是指“指向整数的指针”。这种理解在我们谈论`const`指针时会很有用。

就像引用的类型必须与被引用的对象类型匹配一样，指针的类型也必须与被指向对象的类型匹配：

```cpp
int main()
{
    int i{ 5 };
    double d{ 7.0 };

    int* iPtr{ &i };     // 合法：指向`int`的指针可以指向一个`int`对象
    int* iPtr2{ &d };    // 不合法：指向`int`的指针不能指向一个`double`对象
    double* dPtr{ &d };  // 合法：指向`double`的指针可以指向一个`double`对象
    double* dPtr2{ &i }; // 不合法：指向`double`的指针不能指向一个`int`对象

    return 0;
}
```

有一个例外情况我们将在下一课中讨论，那就是使用字面量来初始化指针是被禁止的：

```cpp
int* ptr{ 5 }; // 不合法
int* ptr{ 0x0012FF7C }; // 不合法，0x0012FF7C被视为整数字面值
```
## 指针与赋值

我们可以以两种不同的方式使用赋值语句来操作指针：

1. 改变指针所指向的对象（通过给指针分配一个新的地址）
2. 改变被指向对象的值（通过给解引用后的指针分配一个新的值）

首先，让我们来看一个改变指针指向对象的例子：

```cpp
#include <iostream>

int main()
{
    int x{ 5 };
    int* ptr{ &x }; // 用`x`的地址初始化`ptr`

    std::cout << *ptr << '\n'; // 打印指针所指地址处的值（`x`的地址）

    int y{ 6 };
    ptr = &y; // 改变`ptr`以指向`y`

    std::cout << *ptr << '\n'; // 打印指针所指地址处的值（`y`的地址）

    return 0;
}
```

这将输出：

``` plaintext
5
6
```

在上面的例子中，我们定义了指针`ptr`，用`x`的地址初始化它，然后解引用该指针以打印它所指向的值（`5`）。接着，我们使用赋值运算符将`ptr`保存的地址更改为`y`的地址。然后再次解引用指针以打印它所指向的值（现在是`6`）。

现在再来看我们如何使用指针来改变被指向对象的值：

```cpp
#include <iostream>

int main()
{
    int x{ 5 };
    int* ptr{ &x }; // 用变量`x`的地址初始化`ptr`

    std::cout << x << '\n';    // 打印`x`的值
    std::cout << *ptr << '\n'; // 打印`ptr`保存的地址处的值（即`x`的地址）

    *ptr = 6; // 将`ptr`保存的地址处的对象（`x`）赋值为`6`（注意这里`ptr`被解引用了）

    std::cout << x << '\n';
    std::cout << *ptr << '\n'; // 打印`ptr`保存的地址处的值（即`x`的地址）

    return 0;
}
```

这个程序输出：

``` plaintext
5
5
6
6
```

在这个例子中，我们定义了指针`ptr`，用`x`的地址初始化它，然后打印`x`和`*ptr`的值（`5`）。因为`*ptr`返回一个左值，所以我们可以在赋值语句的左侧使用它，我们这样做是为了将`ptr`所指向的值更改为`6`。接着我们再次打印`x`和`*ptr`的值，可以看到结果和我们预测的一样。

> [!example] 关键见解
> 
> 当我们使用未解引用的指针（`ptr`）时，我们访问的是指针保存的地址。修改它（`ptr = &y`）可以改变指针的指向。
> 
> 当我们解引用指针（`*ptr`）时，我们访问的是指针所指向的对象。修改它（`*ptr = 6`）可以改变指针所指向对象的值。
## 指针行为类似于左值引用

指针和左值引用的行为类似。考虑以下程序：

```cpp
#include <iostream>

int main()
{
    int x{ 5 };
    int& ref { x };  // 获取对`x`的引用
    int* ptr { &x }; // 获取`x`的指针

    std::cout << x;
    std::cout << ref;  // 使用引用打印`x`的值（5）
    std::cout << *ptr << '\n'; // 使用指针打印`x`的值（5）

    ref = 6; // 使用引用更改`x`的值
    std::cout << x;
    std::cout << ref;  // 使用引用打印`x`的值（6）
    std::cout << *ptr << '\n'; // 使用指针打印`x`的值（6）

    *ptr = 7; // 使用指针更改`x`的值
    std::cout << x;
    std::cout << ref;  // 使用引用打印`x`的值（7）
    std::cout << *ptr << '\n'; // 使用指针打印`x`的值（7）

    return 0;
}
```

该程序输出：

``` plaintext
555
666
777
```

在上面的程序中，我们创建了一个普通变量`x`，其值为`5`，然后创建了对`x`的左值引用和指针。接下来，我们使用左值引用将值从`5`更改为`6`，并展示我们可以通过所有三种方法访问更新后的值。最后，我们使用解引用的指针将值从`6`更改为`7`，再次展示我们可以通过所有三种方法访问更新后的值。

因此，指针和引用都提供了一种间接访问另一个对象的方法。主要区别在于，对于指针，我们需要显式获取指向的地址，并且需要显式地解引用指针来获取值。而对于引用，取地址和解引用是隐式进行的。

指针和引用还有一些其他值得注意的区别：

- 引用必须被初始化，指针不需要（但应当如此）。
- 引用不是对象，而指针是对象。
- 引用不能重新指向（更改为引用其他对象），而指针可以改变它们所指向的对象。
- 引用必须始终绑定到一个对象，指针可以指向空（我们将在下一课看到例子）。
- 引用是“安全”的（除了悬空引用），而指针本质上是危险的（我们也将在下一课讨论这个）。
## 取地址运算符返回一个指针

值得注意的是，取地址运算符（&）不会返回操作数的地址作为字面值。相反，它返回一个包含操作数地址的指针，其类型由参数推导而来（例如，获取一个`int`的地址将返回一个`int`指针）。

我们可以在下面的例子中看到这一点：

```cpp
#include <iostream>
#include <typeinfo>

int main()
{
    int x{ 4 };
    std::cout << typeid(&x).name() << '\n'; // 打印&x的类型

    return 0;
}
```

在Visual Studio上，这段代码输出：

``` plaintext
int *
```

而在gcc中，这段代码输出“pi”（指向`int`的指针: pointer to int）。因为`typeid().name()`的结果是与编译器相关的，所以你的编译器可能会打印不同的结果，但它们的含义是相同的。
## 指针的大小

指针的大小取决于可执行文件编译的架构——32位可执行文件使用32位内存地址，因此32位机器上的指针是32位（4字节）。对于64位可执行文件，指针为64位（8字节）。注意，这与被指向对象的大小无关：

```cpp
#include <iostream>

int main() // 假设是一个32位应用程序
{
    char* chPtr{};        // `char`占1个字节
    int* iPtr{};          // `int`通常占4个字节
    long double* ldPtr{}; // `long double`通常占8或12个字节

    std::cout << sizeof(chPtr) << '\n'; // 打印4
    std::cout << sizeof(iPtr) << '\n';  // 打印4
    std::cout << sizeof(ldPtr) << '\n'; // 打印4

    return 0;
}
```

指针的大小总是相同的。这是因为指针仅仅是一个内存地址，访问内存地址所需的位数是固定的。
## 悬空指针

与悬空引用类似，**悬空指针(dangling pointer)** 是指保存了一个不再有效的对象的地址（例如，因为该对象已被销毁）。

解引用悬空指针（例如，为了打印所指向的值）将导致未定义行为，因为你试图访问一个不再有效的对象。

TODO 这一段需要等到学习过未定义行为这一章后重新校对翻译：
Perhaps surprisingly, the standard says “Any other use of an invalid pointer _value_ has implementation-defined behavior”. This means that you can assign an invalid pointer a new value, such as nullptr (because this doesn’t use the invalid pointer’s value). However, any other operations that use the invalid pointer’s value (such as copying or incrementing an invalid pointer) will yield implementation-defined behavior.

也许出乎意料的是，标准规定“对无效指针值的任何其他使用具有实现定义的行为”。这意味着你可以给无效指针分配一个新值，例如`nullptr`（因为这不使用无效指针的值）。然而，任何其他使用无效指针值的操作（例如复制或递增无效指针）将产生实现定义的行为。

> [!example] 关键见解
> Dereferencing an invalid pointer will lead to undefined behavior. Any other use of an invalid pointer value is implementation-defined.
> 解引用无效指针将导致未定义行为。对无效指针值的任何其他使用是实现定义的。
> 
> 下面是一个创建悬空指针的例子：
> 
> ```cpp
> 
> int main()
> {
>     int x{ 5 };
>     int* ptr{ &x };
> 
>     std::cout << *ptr << '\n'; // 合法
> 
>     {
>         int y{ 6 };
>         ptr = &y;
> 
>         std::cout << *ptr << '\n'; // 合法
>     } // `y`超出作用域，`ptr`现在是悬空指针
> 
>     std::cout << *ptr << '\n'; // 解引用悬空指针导致未定义行为
> 
>     return 0;
> }
> ```

上述程序可能会输出：

``` plaintext
5
6
6
```

But it may not, as the object that `ptr` was pointing at went out of scope and was destroyed at the end of the inner block, leaving `ptr` dangling.

但也可能不会，因为`ptr`所指向的对象在内部代码块结束时超出作用域并被销毁，导致`ptr`悬空。
## 总结

指针是保存内存地址的变量。它们可以使用解引用运算符`*`来获取它们保存的地址处的值。解引用野指针、悬空指针或空指针将导致未定义行为，并可能使应用程序崩溃。

指针比引用更灵活，但也更危险。我们将在接下来的课程中继续探讨这一点。
## 小测

> [!question] Q1. 这个程序输出什么值？假设`short`类型占2个字节，并且是32位机器。
> 
> ``` cpp
> int main()
> {
>     short value{ 7 }; // &value = 0012FF60
>     short otherValue{ 3 }; // &otherValue = 0012FF54
> 
>     short* ptr{ &value };
> 
>     std::cout << &value << '\n';
>     std::cout << value << '\n';
>     std::cout << ptr << '\n';
>     std::cout << *ptr << '\n';
>     std::cout << '\n';
> 
>     *ptr = 9;
> 
>     std::cout << &value << '\n';
>     std::cout << value << '\n';
>     std::cout << ptr << '\n';
>     std::cout << *ptr << '\n';
>     std::cout << '\n';
> 
>     ptr = &otherValue;
> 
>     std::cout << &otherValue << '\n';
>     std::cout << otherValue << '\n';
>     std::cout << ptr << '\n';
>     std::cout << *ptr << '\n';
>     std::cout << '\n';
> 
>     std::cout << sizeof(ptr) << '\n';
>     std::cout << sizeof(*ptr) << '\n';
> 
>     return 0;
> }
> ```

> [!tip]- A1. 答案
> ``` plaintext
> 0012FF60
> 7
> 0012FF60
> 7
> 
> 0012FF60
> 9
> 0012FF60
> 9
> 
> 0012FF54
> 3
> 0012FF54
> 3
> 
> 4
> 2
> ```
> 
> 关于`4`和`2`的简单解释。32位机器意味着指针长度为32位，但`sizeof()`始终以字节打印大小。32位是4字节。因此，`sizeof(ptr)`为4。由于`ptr`是指向`short`的指针，所以`*ptr`是一个`short`。在这个例子中，`short`的大小是2个字节。因此，`sizeof(*ptr)`为2。

> [!question] Q2. 这段代码有什么问题？
> 
> ```cpp
> int v1{ 45 };
> int* ptr{ &v1 }; // 用v1的地址初始化ptr
> 
> int v2 { 78 };
> *ptr = &v2;    // 将ptr指向v2的地址
> ```

> [!tip]- A2. 答案
> 以上代码的最后一行无法编译。
> 
> 让我们更详细地检查这个程序。
> 
> 第一行和第四行包含标准的变量定义和初始化值。这部分没什么特别的。
> 
> 第二行，我们定义了一个名为`ptr`的新指针，并用`v1`的地址初始化它。请记住，在这个上下文中，星号是指针声明语法的一部分，而不是解引用运算符。因此，这一行是没问题的。
> 
> 第五行中的星号表示解引用，用于获取指针所指向的值。因此，这一行表示：“获取`ptr`指向的值（一个整数），并将其赋值为`v2`的地址。” 这没有任何意义——你不能将一个地址赋值给一个整数！
> 
> 第五行应为：
> 
> ``` cpp
> ptr = &v2;
> ```
> 
> 这将正确地将`v2`的地址赋给指针。
# 12.8 Null pointers 空指针

在上一课（[[#12.7 - Introduction to pointers 指针简介|12.7 - 指针简介]]）中，我们介绍了指针的基础知识。指针是保存另一个对象的地址的对象。可以通过解引用运算符`*`获取该地址上的对象：

```cpp
#include <iostream>

int main()
{
    int x{ 5 };
    std::cout << x << '\n'; // 打印变量 x 的值

    int* ptr{ &x }; // ptr 保存了 x 的地址
    std::cout << *ptr << '\n'; // 使用解引用运算符打印 ptr 所保存的地址上的对象的值（即 x 的地址）

    return 0;
}
```

上述代码输出：

``` plaintext
5
5
```

在前一课中，我们还指出指针不一定需要指向任何东西。在本课中，我们将进一步探讨此类指针（以及指向空的各种影响）。
## 空指针

除了一个内存地址之外，指针还可以保存一个额外的值：空值。**空值(null value)**，英语里通常简写为**空(null)**，是一种表示某个东西没有值的特殊值。当指针保存空值时，意味着该指针没有指向任何东西。这样的指针被称为**空指针(null pointer)**。

创建空指针最简单的方法是使用值初始化：

```cpp
int main()
{
    int* ptr{}; // ptr 现在是一个空指针，并没有保存任何地址

    return 0;
}
```

> [!tip] 最佳实践
>
> 如果你没有使用有效对象的地址来初始化指针，那么请使用值初始化使其成为空指针。

因为我们可以使用赋值来改变指针所指向的对象，所以最初设置为空的指针稍后可以更改为指向有效对象：

```cpp
#include <iostream>

int main()
{
    int* ptr{}; // ptr 是一个空指针，并没有保存任何地址

    int x{ 5 };
    ptr = &x; // ptr 现在指向对象 x（不再是空指针）

    std::cout << *ptr << '\n'; // 通过解引用 ptr 打印 x 的值

    return 0;
}
```

### `nullptr` 关键字

与表示布尔字面值的关键字 `true` 和 `false` 类似，**`nullptr`** 关键字表示空指针字面值。我们可以使用 `nullptr` 来显式初始化或为指针赋予一个空值。

```cpp
int main()
{
    int* ptr{ nullptr }; // 可以使用 nullptr 初始化指针为空指针

    int value{ 5 };
    int* ptr2{ &value }; // ptr2 是一个有效指针
    ptr2 = nullptr; // 可以赋值 nullptr 使指针成为空指针

    someFunction(nullptr); // 我们也可以将 nullptr 传递给具有指针参数的函数

    return 0;
}
```

在上面的例子中，我们使用赋值将 `ptr2` 的值设置为 `nullptr`，使 `ptr2` 成为一个空指针。

> [!tip] 最佳实践
> 
> 当你需要一个空指针字面值用于初始化、赋值或传递给函数时，请使用 `nullptr`。
### 解引用空指针会导致未定义行为

就像解引用悬空指针（或野指针）会导致未定义行为一样，解引用空指针也会导致未定义行为。在大多数情况下，这会导致你的应用程序崩溃。

下面的程序演示了这一点，运行它时很可能会崩溃或异常终止（试试看，你不会损坏你的计算机）：

```cpp
#include <iostream>

int main()
{
    int* ptr{}; // 创建一个空指针
    std::cout << *ptr << '\n'; // 解引用空指针

    return 0;
}
```

从概念上讲，这很容易理解。解引用一个指针意味着“前往指针所指向的地址并访问那里的值”。空指针保存了一个空值，语义上表示该指针没有指向任何东西。那么它会访问什么值呢？

意外地解引用空指针和悬空指针是 C++ 程序员最常犯的错误之一，也是 C++ 程序在实践中崩溃的最常见原因。

> [!warning] 警告
> 
> 每当你使用指针时，你需要格外小心，以确保你的代码没有解引用空指针或悬空指针，因为这会导致未定义行为（可能导致应用程序崩溃）。
## 检查空指针

就像我们可以使用条件语句测试布尔值是否为 `true` 或 `false` 一样，我们也可以使用条件语句测试指针是否具有 `nullptr` 值：

```cpp
#include <iostream>

int main()
{
    int x{ 5 };
    int* ptr{ &x };

    if (ptr == nullptr) // 显式测试相等性
        std::cout << "ptr is null\n";
    else
        std::cout << "ptr is non-null\n";

    int* nullPtr{};
    std::cout << "nullPtr is " << (nullPtr == nullptr ? "null\n" : "non-null\n"); // 显式测试相等性

    return 0;
}
```

上面的程序输出：

``` plaintext
ptr is non-null
nullPtr is null
```

在 [[Chapter 4 - Fundamental Data Types#4.9 Boolean values|4.9 - 布尔值]] 一课中，我们提到整型值会隐式转换为布尔值：整型值 `0` 转换为布尔值 `false`，其他任何整型值转换为布尔值 `true`。

类似地，指针也会隐式转换为布尔值：空指针转换为布尔值 `false`，非空指针转换为布尔值 `true`。这使我们可以跳过显式测试 `nullptr`，只需使用隐式转换为布尔值来测试指针是否为空指针。下面的程序和前面等效：

```cpp
#include <iostream>

int main()
{
    int x{ 5 };
    int* ptr{ &x };

    // 指针转换为布尔值 false 如果它们为空，转换为布尔值 true 如果它们为非空
    if (ptr) // 隐式转换为布尔值
        std::cout << "ptr is non-null\n";
    else
        std::cout << "ptr is null\n";

    int* nullPtr{};
    std::cout << "nullPtr is " << (nullPtr ? "non-null\n" : "null\n"); // 隐式转换为布尔值

    return 0;
}
```

> [!warning] 警告
> 
> 条件语句只能用于区分空指针和非空指针。没有便捷的方法来确定非空指针是指向有效对象还是悬空（指向无效对象）。
### 使用 `nullptr` 来避免悬空指针

上面我们提到，解引用空指针或悬空指针将导致未定义行为。因此，我们需要确保代码不会做这些事情。

我们可以通过使用条件语句确保指针在尝试解引用之前是非空的，来轻松避免解引用空指针：

```cpp
// 假设 ptr 是某个可能为空指针的指针
if (ptr) // 如果 ptr 不是空指针
    std::cout << *ptr << '\n'; // 可以解引用
else
    // 做一些不涉及解引用 ptr 的其他操作（打印错误信息、不做任何事等）
```

但是悬空指针呢？因为没有办法检测指针是否悬空，我们需要确保在程序中不存在悬空指针。我们可以通过确保任何不指向有效对象的指针都被设置为 `nullptr` 来实现这一点。

这样，在解引用指针之前，我们只需要测试它是否为空——如果它不是空的，我们就假设该指针不是悬空的。

> [!tip] 最佳实践
> 
> 指针应当要么保存有效对象的地址，要么设置为 `nullptr`。这样我们只需测试指针是否为空，并可以假设任何非空指针都是有效的。

不幸的是，避免悬空指针并不容易：当一个对象被销毁时，指向该对象的任何指针将被悬空。这些指针不会自动被置为空！程序员有责任确保所有指向刚被销毁对象的指针被正确设置为 `nullptr`。

> [!warning] 警告
> 
> 当一个对象被销毁时，指向该销毁对象的任何指针将被悬空（它们不会被自动设置为 `nullptr`）。你有责任检测这些情况并确保这些指针随后被设置为 `nullptr`。
## 传统空指针字面量：`0` 和 `NULL`

在较旧的代码中，你可能会看到使用另外两个字面值来代替 `nullptr`。

第一个是字面值 `0`。在指针的上下文中，字面值 `0` 被特别定义为表示空值，这是唯一可以将整型字面值赋值给指针的情况。

```cpp
int main()
{
    float* ptr { 0 };  // ptr is now a null pointer (for example only, don't do this)

    float* ptr2; // ptr2 is uninitialized
    ptr2 = 0; // ptr2 is now a null pointer (for example only, don't do this)

    return 0;
}
```

> [!note] As an aside…
> 
> 在现代架构上，地址 `0` 通常用来表示空指针。然而，C++ 标准并不保证这一点，有些架构使用其他值。在表示空指针的上下文中，字面值 `0` 将被翻译为架构用来表示空指针的地址。

此外，有一个名为 `NULL` 的预处理器宏（在 `<cstddef>` 头文件中定义）。这个宏继承自 C，在 C 中通常用来表示空指针。

```cpp
#include <cstddef> // 为了使用 NULL

int main()
{
    double* ptr{ NULL }; // ptr 是空指针

    double* ptr2; // ptr2 未初始化
    ptr2 = NULL; // ptr2 现在是空指针

    return 0;
}
```

Both `0` and `NULL` should be avoided in modern C++ (use `nullptr` instead). We discuss why in lesson [12.11 -- Pass by address (part 2)](https://www.learncpp.com/cpp-tutorial/pass-by-address-part-2/).

在现代 C++ 中应避免使用 `0` 和 `NULL`（而应使用 `nullptr`）。我们将在 [[#12.11 Pass by address (part 2)|12.11 - 通过地址传递（第二部分）]] 中讨论原因。
## 多用引用而非指针

指针和引用都为我们提供了间接访问其他对象的能力。

指针还具备改变它们所指向的对象以及指向空的能力。然而，这些指针的能力本身也是危险的：空指针有被解引用的风险，而改变指针所指向的对象可能会更容易创建悬空指针：

```cpp
int main()
{
    int* ptr{};

    {
        int x{ 5 };
        ptr = &x; // 将指针指向一个将被销毁的对象（引用不可能做到）
    } // ptr 现在悬空并指向无效对象

    if (ptr) // 条件为真，因为 ptr 不是 nullptr
        std::cout << *ptr; // 未定义行为

    return 0;
}
```

由于引用不能绑定到空(NULL)，因此我们不必担心空引用。而且，由于引用必须在创建时绑定到有效对象，且不能重新绑定，因此更难创建悬空引用。

因为它们更安全，除非需要指针提供的额外功能，否则应优先使用引用而非指针。

> [!tip] 最佳实践
> 
> 除非需要指针提供的额外功能，否则应优先使用引用。
## 小测
### 问题1

> [!question] 问题1-a
> 我们能确定一个指针是否是空指针吗？如果可以，如何做到？

> [!tip]- 答案1-a
> 我们可以在指针上使用条件语句（`if` 语句或条件运算符）。如果指针是空指针，则它将转换为布尔值 `false`，否则转换为 `true`。

> [!question] 问题1-b
> 我们能确定一个非空指针是否有效或悬空吗？如果可以，如何做到？

> [!tip]- 答案1-b
> 没有简单的方法可以做到这一点。
### 问题2

对于下面每一个问题，根据描述的操作，请回答该操作会导致以下哪种行为：可预测(predictable)、未定义(undefined)或可能未定义(possibly undefined)。如果答案是“可能未定义”，请说明何时可能出现这种情况。

> [!question] 问题2-a
> 为一个非常量指针分配一个新地址

> [!tip]- 答案2-a
> 可预测。

> [!question] 问题2-b
> 为指针赋值 `nullptr`

> [!tip]- 答案2-b
> 可预测。

> [!question] 问题2-c
> 解引用指向有效对象的指针

> [!tip]- 答案2-c
> 可预测。

> [!question] 问题2-d
> 解引用悬空指针

> [!tip]- 答案2-d
> 未定义。

> [!question] 问题2-e
> 解引用空指针

> [!tip]- 答案2-e
> 未定义。

> [!question] 问题2-f
> 解引用非空指针

> [!tip]- 答案2-f
> 可能未定义。如果指针是悬空的话就会出现未定义行为。
### 问题3

> [!question] 问题3
> 为什么我们要将不指向有效对象的指针设置为 `nullptr`？

> [!tip]- 答案3
> 我们无法确定非空指针是否有效或悬空，且访问悬空指针会导致未定义行为。因此，我们需要确保程序中不存在任何悬空指针。
> 
> 如果我们确保所有指针都要么指向有效对象，要么设置为 `nullptr`，那么我们可以使用条件语句测试指针是否为空，以确保我们不会解引用空指针，并假设所有非空指针都指向有效对象。
# 12.9 Pointers and const 指针和常量

考虑以下代码片段：

```cpp
int main()
{
    int x { 5 };
    int* ptr { &x }; // ptr 是一个普通（非 const）指针

    int y { 6 };
    ptr = &y; // 我们可以指向另一个值

    *ptr = 7; // 我们可以改变指针所指地址的值

    return 0;
}
```

对于普通（非 const）指针，我们可以改变指针指向的对象（通过给指针赋予一个新的地址），也可以改变指针所持有地址的值（通过给解引用的指针赋予新值）。

但是，如果我们想指向的值是 const，会发生什么呢？

```cpp
int main()
{
    const int x { 5 }; // x 现在是 const
    int* ptr { &x };   // 编译错误：无法从 const int* 转换为 int*

    return 0;
}
```

上面的代码片段无法通过编译——我们不能让一个普通指针指向一个 const 变量。原因在于：**const** 变量是其值不能被改变的变量。允许程序员使用非 const 指针指向 const 值，会使程序员能够通过解引用指针来改变该值。这将违反变量的 const 性。
## 指向 const 值的指针

**指向 const 值的指针**（有时简称为 `pointer to const`）是一个（非 const）指针，指向一个常量值。

要声明一个指向 `const` 值的指针，在指针的数据类型前使用 `const` 关键字：

```cpp
int main()
{
    const int x{ 5 };
    const int* ptr { &x }; // 可以：ptr 指向一个 "const int"

    *ptr = 6; // 不允许：我们不能改变一个 const 值

    return 0;
}
```

在上面的例子中，`ptr` 指向一个 `const int`。因为所指数据类型是 const，所以不能改变被指向的值。

然而，由于指向 const 的指针本身不是 const（它只是指向一个 const 值），我们可以通过给指针赋予一个新地址来改变指针指向的对象：

```cpp
int main()
{
    const int x{ 5 };
    const int* ptr { &x }; // ptr 指向 const int x

    const int y{ 6 };
    ptr = &y; // 可以：ptr 现在指向 const int y

    return 0;
}
```

就像对 const 的引用一样，指向 const 的指针也可以指向非 const 变量。指向 const 的指针将被指向的值视为常量，无论该地址的对象最初是否被定义为 const：

```cpp
int main()
{
    int x{ 5 }; // 非 const
    const int* ptr { &x }; // ptr 指向一个 "const int"

    *ptr = 6;  // 不允许：ptr 指向一个 "const int"，所以我们不能通过 ptr 改变该值
    x = 6; // 允许：通过非 const 标识符 x 访问时，该值仍是非 const 的

    return 0;
}
```

## const 指针

我们也可以使指针本身成为常量。一个 **const 指针** 是指初始化后地址不能被改变的指针。

要声明一个 const 指针，在指针声明中的星号后使用 `const` 关键字：

```cpp
int main()
{
    int x{ 5 };
    int* const ptr { &x }; // 星号后面的 const 表示这是一个 const 指针

    return 0;
}
```

在上面的例子中，`ptr` 是一个指向（非 const）int 值的 const 指针。

就像普通的 const 变量一样，const 指针必须在定义时初始化，并且这个值不能通过赋值来改变：

```cpp
int main()
{
    int x{ 5 };
    int y{ 6 };

    int* const ptr { &x }; // 可以：const 指针被初始化为 x 的地址
    ptr = &y; // 错误：一旦初始化，const 指针不能被改变。

    return 0;
}
```

然而，由于被指向的值是非 const 的，可以通过解引用 const 指针来改变被指向的值：

```cpp
int main()
{
    int x{ 5 };
    int* const ptr { &x }; // ptr 将始终指向 x

    *ptr = 6; // 可以：被指向的值是非 const 的

    return 0;
}
```
## 指向 const 值的 const 指针

最后，可以通过在类型前和星号后都使用 `const` 关键字来声明一个 **指向 const 值的 const 指针**：

```cpp
int main()
{
    int value { 5 };
    const int* const ptr { &value }; // 一个指向 const 值的 const 指针

    return 0;
}
```

指向 const 值的 const 指针不能改变其地址，也不能通过指针改变其所指向的值。它只能被解引用以获取其指向的值。
## 指针和 const 回顾

总结一下，你只需要记住 4 条规则，而且它们非常合乎逻辑：

- 非 const 指针可以被赋予另一个地址来改变它指向的对象。
- const 指针总是指向同一地址，这个地址不能被改变。
- 指向非 const 值的指针可以改变它所指向的值。这些指针不能指向 const 值。
- 指向 const 值的指针在通过指针访问时将值视为 const，因此不能改变它所指向的值。这些指针可以指向 const 或非 const 左值（但不能指向没有地址的右值）。

理清声明语法可能有点挑战：

- 在星号前面的 `const` 与被指向的类型相关。因此，这是一个指向 const 值的指针，不能通过指针修改该值。
- 在星号后面的 `const` 与指针本身相关。因此，该指针不能被赋予新的地址。

```cpp
int main()
{
    int v{ 5 };

    int* ptr0 { &v };             // 指向一个 "int"，但自身不是 const，所以这是一个普通指针。
    const int* ptr1 { &v };       // 指向一个 "const int"，但自身不是 const，所以这是一个指向 const 值的指针。
    int* const ptr2 { &v };       // 指向一个 "int"，自身是 const 的，所以这是一个 const 指针（指向非 const 值）。
    const int* const ptr3 { &v }; // 指向一个 "const int"，自身是 const 的，所以这是一个指向 const 值的 const 指针。

    // 如果 const 在 * 的左边，const 属于值
    // 如果 const 在 * 的右边，const 属于指针

    return 0;
}
```

我自己整理了以下表格：

| 声明方式                    | 指针类型             | 指针指向的值是否可变 `*ptr=val` | 指针地址是否可变 `ptr=&var` |
| ----------------------- | ---------------- | --------------------- | ------------------- |
| `int* ptr;`             | 普通指针             | 是                     | 是                   |
| `const int* ptr;`       | 指向const值的指针      | 否                     | 是                   |
| `int* const ptr;`       | const指针          | 是                     | 否                   |
| `const int* const ptr;` | 指向const值的const指针 | 否                     | 否                   |

# 12.10 - Pass by address 按地址传递

在之前的课程中，我们介绍了将参数传递给函数的两种不同方式：按值传递 [[Chapter 2 - C++ Basics - Functions and Files#2.4 Introduction to function parameters and arguments|2.4 —— 函数参数和实参简介]] 和按引用传递 [[#12.5 通过左值引用传递|12.5 —— 按左值引用传递]]。

下面是一个示例程序，展示了一个 `std::string` 对象按值传递和按引用传递：

```cpp
#include <iostream>
#include <string>

void printByValue(std::string val) // 函数参数是 str 的一个副本
{
    std::cout << val << '\n'; // 通过副本打印值
}

void printByReference(const std::string& ref) // 函数参数是绑定到 str 的引用
{
    std::cout << ref << '\n'; // 通过引用打印值
}

int main()
{
    std::string str{ "Hello, world!" };

    printByValue(str); // 按值传递 str，会复制 str
    printByReference(str); // 按引用传递 str，不会复制 str

    return 0;
}
```

当我们按值传递参数 `str` 时，函数参数 `val` 接收到该参数的一个副本。因为参数是实参的副本，对 `val` 的任何更改都是对副本的修改，而不是对原始参数的修改。

当我们按引用传递参数 `str` 时，引用参数 `ref` 绑定到实际的参数。这避免了复制参数。因为我们的引用参数是 const 的，我们不能修改 `ref`。但如果 `ref` 是非 const 的，我们对 `ref` 的任何修改都会改变 `str`。

在这两种情况下，调用者都提供了要作为函数调用参数的实际对象（`str`）。
## 按地址传递

C++ 提供了第三种将值传递给函数的方法，称为按地址传递。使用 **按地址传递** 时，调用者不是提供一个对象作为参数，而是提供一个对象的 **地址**（通过指针）。这个指针（持有对象的地址）被复制到被调用函数的指针参数中（现在也持有对象的地址）。然后，函数可以解引用该指针来访问传递地址的对象。

下面是上述程序的一个版本，添加了按地址传递的变体：

```cpp
#include <iostream>
#include <string>

void printByValue(std::string val) // 函数参数是 str 的一个副本
{
    std::cout << val << '\n'; // 通过副本打印值
}

void printByReference(const std::string& ref) // 函数参数是绑定到 str 的引用
{
    std::cout << ref << '\n'; // 通过引用打印值
}

void printByAddress(const std::string* ptr) // 函数参数是一个持有 str 地址的指针
{
    std::cout << *ptr << '\n'; // 通过解引用指针打印值
}

int main()
{
    std::string str{ "Hello, world!" };

    printByValue(str); // 按值传递 str，会复制 str
    printByReference(str); // 按引用传递 str，不会复制 str
    printByAddress(&str); // 按地址传递 str，不会复制 str

    return 0;
}
```

请注意，这三个版本有多么相似。让我们更详细地探讨按地址传递的版本。

首先，因为我们希望 `printByAddress()` 函数使用按地址传递，我们将函数参数设为名为 `ptr` 的指针。由于 `printByAddress()` 将以只读方式使用 `ptr`，`ptr` 是一个指向 const 值的指针。

```cpp
void printByAddress(const std::string* ptr)
{
    std::cout << *ptr << '\n'; // 通过解引用指针打印值
}
```

在 `printByAddress()` 函数内部，我们解引用 `ptr` 参数来访问被指向对象的值。

其次，当调用函数时，我们不能仅仅传入 `str` 对象——我们需要传入 `str` 的地址。最简单的方法是使用取地址符`&`来获取持有 `str` 地址的指针：

```cpp
printByAddress(&str); // 使用取地址符 (&) 获取持有 str 地址的指针
```

当执行此调用时，`&str` 将创建一个持有 `str` 地址的指针。然后，这个地址在函数调用时被复制到函数参数 `ptr` 中。因为 `ptr` 现在持有 `str` 的地址，当函数解引用 `ptr` 时，它将获得 `str` 的值，函数将其打印到控制台。

就是这样。

虽然在上面的例子中我们使用取地址符来获取 `str` 的地址，但如果我们已经有一个持有 `str` 地址的指针变量，我们也可以使用它：

```cpp
int main()
{
    std::string str{ "Hello, world!" };

    printByValue(str); // 按值传递 str，会复制 str
    printByReference(str); // 按引用传递 str，不会复制 str
    printByAddress(&str); // 按地址传递 str，不会复制 str

    std::string* ptr { &str }; // 定义一个持有 str 地址的指针变量
    printByAddress(ptr); // 按地址传递 str，不会复制 str

    return 0;
}
```

> [!info] Nomenclature 命名法
> 
> 当我们使用`&`取地址运算符将变量的地址作为参数传递时，我们说变量是 **按地址传递**。
> 
> 当我们有一个持有对象地址的指针变量，并将指针作为参数传递给相同类型的参数时，我们说对象是按地址传递的，指针是按值传递的。
## 按地址传递不会复制被指向的对象

考虑以下语句：

```cpp
std::string str{ "Hello, world!" };
printByAddress(&str); // 使用取地址符 (&) 获取持有 str 地址的指针
```

As we noted in [12.5 -- Pass by lvalue reference](https://www.learncpp.com/cpp-tutorial/pass-by-lvalue-reference/), copying a `std::string` is expensive, so that’s something we want to avoid. When we pass a `std::string` by address, we’re not copying the actual `std::string` object -- we’re just copying the pointer (holding the address of the object) from the caller to the called function. Since an address is typically only 4 or 8 bytes, a pointer is only 4 or 8 bytes, so copying a pointer is always fast.

正如我们在 [[#12.5 通过左值引用传递|12.5 —— 按左值引用传递]] 中指出的，复制一个 `std::string` 是很耗费资源的，这是我们想要避免的。当我们按地址传递一个 `std::string` 时，我们并没有复制实际的 `std::string` 对象——我们只是将持有对象地址的指针从调用者复制到被调用函数。由于地址通常只有 4 或 8 个字节，所以指针也只有 4 或 8 个字节，因此复制指针总是很快的。

因此，就像按引用传递一样，按地址传递也是快速的，避免了对参数对象的复制。
## 按地址传递允许函数修改参数的值

当我们按地址传递对象时，函数接收到被传递对象的地址，可以通过解引用访问它。因为这是被传递的实际参数对象的地址（而不是对象的副本），如果函数参数是指向非 const 的指针，函数可以通过指针参数修改参数：

```cpp
#include <iostream>

void changeValue(int* ptr) // 注意：在此示例中，ptr 是指向非 const 的指针
{
    *ptr = 6; // 将值改为 6
}

int main()
{
    int x{ 5 };

    std::cout << "x = " << x << '\n';

    changeValue(&x); // 我们将 x 的地址传递给函数

    std::cout << "x = " << x << '\n';

    return 0;
}
```

这将输出：

``` plaintext
x = 5
x = 6
```

如你所见，参数被修改了，这种修改在 `changeValue()` 运行完毕后仍然存在。

如果函数不应修改被传入的对象，可以将函数参数设为指向 const 的指针：

```cpp
void changeValue(const int* ptr) // 注意：ptr 现在是指向 const 的指针
{
    *ptr = 6; // 错误：不能改变 const 值
}
```
## 空指针检查

现在考虑这个看似无害的程序：

```cpp
#include <iostream>

void print(int* ptr)
{
    std::cout << *ptr << '\n';
}

int main()
{
    int x{ 5 };
    print(&x);

    int* myPtr {};
    print(myPtr);

    return 0;
}
```

当运行此程序时，它将打印值 `5`，然后很可能崩溃。

在调用 `print(myPtr)` 时，`myPtr` 是一个空指针，因此函数参数 `ptr` 也将是一个空指针。当在函数体内解引用这个空指针时，会导致未定义行为。

当按地址传递参数时，在解引用值之前应注意确保指针不是空指针。一种方法是使用条件语句：

```cpp
#include <iostream>

void print(int* ptr)
{
    if (ptr) // 如果 ptr 不是空指针
    {
        std::cout << *ptr << '\n';
    }
}

int main()
{
    int x{ 5 };

    print(&x);
    print(nullptr);

    return 0;
}
```

在上述程序中，我们测试 `ptr` 是否为 null，以确保在解引用之前它不是空指针。虽然对于这样一个简单的函数来说这没问题，但在更复杂的函数中，这可能会导致冗余的逻辑（多次测试 ptr 是否为 null）或嵌套函数的主要逻辑（如果包含在一个块中）。

在大多数情况下，更有效的方法是反过来：将函数参数是否为 null 作为前提条件进行测试([[Chapter 9 -  Error Detection and Handling#9.6 Assert and static_assert|9.6 —— assert 和 static_assert]])，并立即处理负面情况：

```cpp
#include <iostream>

void print(int* ptr)
{
    if (!ptr) // 如果 ptr 是空指针，提前返回给调用者
        return;

    // 如果执行到这里，我们可以假设 ptr 是有效的
    // 所以不需要更多的测试或嵌套

    std::cout << *ptr << '\n';
}

int main()
{
    int x{ 5 };

    print(&x);
    print(nullptr);

    return 0;
}
```

如果在你的程序流程设计中，空指针无论如何都不应该被传递给函数，我们就可以使用在 [[Chapter 9 -  Error Detection and Handling#9.6 Assert and static_assert|9.6 —— assert 和 static_assert]] 中介绍的 `assert`（单独用`assert`或者两者一起使用）。

断言旨在表明条件永远不应该发生：

```cpp
#include <iostream>
#include <cassert>

void print(const int* ptr) // 现在是指向 const int 的指针
{
    assert(ptr); // 如果传递了空指针，在调试模式下使程序失败（因为这永远不应该发生）

    // （可选）在生产模式下将其作为错误情况处理，以便如果确实发生了，我们不会崩溃
    if (!ptr)
        return;

    std::cout << *ptr << '\n';
}

int main()
{
    int x{ 5 };

    print(&x);
    print(nullptr);

    return 0;
}
```
## 优先使用按（const）引用传递

注意，上面示例中的 `print()` 函数无法很好地处理空值——它实际上只是中止了函数。鉴于此，为什么要允许用户传入空值呢？按引用传递具有与按地址传递相同的优点，而无需冒意外解引用空指针的风险。

按 const 引用传递比按地址传递还有其他一些优点。

首先，因为按地址传递的对象必须有一个地址，所以只能按地址传递左值（因为右值没有地址）。按 const 引用传递更灵活，因为它可以接受左值和右值：

```cpp
#include <iostream>

void printByValue(int val) // 函数参数是参数的一个副本
{
    std::cout << val << '\n'; // 通过副本打印值
}

void printByReference(const int& ref) // 函数参数是绑定到参数的引用
{
    std::cout << ref << '\n'; // 通过引用打印值
}

void printByAddress(const int* ptr) // 函数参数是一个持有参数地址的指针
{
    std::cout << *ptr << '\n'; // 通过解引用指针打印值
}

int main()
{
    printByValue(5);     // 有效（但会复制）
    printByReference(5); // 有效（因为参数是 const 引用）
    printByAddress(&5);  // 错误：无法获取右值的地址

    return 0;
}
```

其次，按引用传递的语法更自然，我们可以直接传入字面量或对象。使用按地址传递，我们的代码会充斥着 & 和 *。

在现代 C++ 中，大多数可以用按地址传递完成的事情，通过其他方法可以更好地完成。遵循这个常见的准则：“**尽可能按引用传递，必须时才按地址传递**”。

> 最佳实践
> 
> 除非有特定原因使用按地址传递，否则应优先使用按引用传递。
# 12.11 — Pass by address (part 2) 按地址传递（第二部分）

本节课接着上节课 [[#12.10 - Pass by address 按地址传递|12.10 —— 按地址传递]] 继续研究“按地址传递”。
## 为“可选”参数使用按地址传递

按地址传递的一个更常见的用途是允许函数接受一个“可选”参数。用例子来说明比描述更容易：

```cpp
#include <iostream>

void printIDNumber(const int *id = nullptr)
{
    if (id)
        std::cout << "Your ID number is " << *id << ".\n";
    else
        std::cout << "Your ID number is not known.\n";
}

int main()
{
    printIDNumber(); // 我们还不知道用户的 ID

    int userid{ 34 };
    printIDNumber(&userid); // 我们现在知道用户的 ID 了

    return 0;
}
```

该示例打印：

``` plaintext
Your ID number is not known.
Your ID number is 34.
```

在这个程序中，`printIDNumber()` 函数有一个按地址传递并默认值为 `nullptr` 的参数。在 `main()` 中，我们调用了两次这个函数。第一次调用时，我们不知道用户的 ID，所以不带参数地调用 `printIDNumber()`。`id` 参数默认值为 `nullptr`，函数打印 `Your ID number is not known.`。第二次调用时，我们有一个有效的 ID，所以调用 `printIDNumber(&userid)`。`id` 参数接收 `userid` 的地址，因此函数打印 `Your ID number is 34.`。

然而，在许多情况下，**函数重载(function overloading)** 是实现相同结果的更好选择：

```cpp
#include <iostream>

void printIDNumber()
{
    std::cout << "Your ID is not known\n";
}

void printIDNumber(int id)
{
    std::cout << "Your ID is " << id << "\n";
}

int main()
{
    printIDNumber(); // 我们还不知道用户的 ID

    int userid{ 34 };
    printIDNumber(userid); // 我们知道用户是 34

    printIDNumber(62); // 现在也可以使用右值参数

    return 0;
}
```

这有许多优点：我们不再需要担心空指针解引用，并且我们可以传递字面值或其他右值作为参数。
## 改变指针参数所指向的对象

当我们将一个地址传递给函数时，该地址从实参复制到指针参数中（这是可以的，因为复制地址很快）。现在考虑以下程序：

```cpp
#include <iostream>

// [[maybe_unused]] 消除关于 ptr2 被设置但未使用的编译器警告
void nullify([[maybe_unused]] int* ptr2)
{
    ptr2 = nullptr; // 将函数参数设为空指针
}

int main()
{
    int x{ 5 };
    int* ptr{ &x }; // ptr 指向 x

    std::cout << "ptr is " << (ptr ? "non-null\n" : "null\n");

    nullify(ptr);

    std::cout << "ptr is " << (ptr ? "non-null\n" : "null\n");
    return 0;
}
```

该程序将打印：

``` plaintext
ptr is non-null
ptr is non-null
```

如你所见，改变指针参数所持有的地址对实参的地址没有影响（`ptr` 仍然指向 `x`）。当调用函数 `nullify()` 时，`ptr2` 接收到传入地址的副本（在本例中，是 `ptr` 持有的地址，即 `x` 的地址）。当函数改变 `ptr2` 指向的对象时，这只影响了 `ptr2` 持有的副本。

那么，如果我们想允许函数改变指针参数所指向的对象，该怎么办？
## 按引用传递……地址？

是的，这确实可以。就像我们可以按引用传递普通变量一样，我们也可以按引用传递指针。下面是与上述相同的程序，但将 `ptr2` 改为对地址的引用：

```cpp
#include <iostream>

void nullify(int*& refptr) // refptr 现在是指针的引用
{
    refptr = nullptr; // 将函数参数设为空指针
}

int main()
{
    int x{ 5 };
    int* ptr{ &x }; // ptr 指向 x

    std::cout << "ptr is " << (ptr ? "non-null\n" : "null\n");

    nullify(ptr);

    std::cout << "ptr is " << (ptr ? "non-null\n" : "null\n");
    return 0;
}
```

该程序将打印：

``` plaintext
ptr is non-null
ptr is null
```

因为 `refptr` 现在是指针的引用，当 `ptr` 作为参数传递时，`refptr` 绑定到 `ptr`。这意味着对 `refptr` 的任何更改都会作用于 `ptr`。

> [!info] As an aside… 顺便说一下……
> 
> 由于指针的引用相当罕见，所以很容易混淆语法（到底是 `int*&` 还是 `int&*`？）。好消息是，如果你写反了，编译器会报错，因为你不能有指向引用的指针（因为指针必须持有对象的地址，而引用不是对象）。然后你可以将其调整过来。
## 为什么不再推荐使用 `0` 或 `NULL`（可选）

在本小节中，我们将解释为什么不再推荐使用 `0` 或 `NULL`。

字面值 `0` 可以被解释为整数字面值，或作为空指针字面值。在某些情况下，这可能会产生歧义——在这些情况下，编译器可能错误理解我们的意图，从而导致程序产生意外后果。

预处理器宏 `NULL` 的定义并未在语言标准中规定。它可以被定义为 `0`、`0L`、`((void*)0)` 或其他任何东西。

在 [[Chapter 11 - Function Overloading and Function Templates#11.1 Introduction to function overloading 函数重载简介|11.1 —— 函数重载简介]] 中，我们讨论了函数可以被重载（多个函数可以有相同的名称，只要它们可以通过参数的数量或类型来区分）。编译器可以通过函数调用中传递的参数来确定你希望调用哪个重载函数。

当使用 `0` 或 `NULL` 时，这可能会引起问题：

```cpp
#include <iostream>
#include <cstddef> // 为了使用 NULL

void print(int x) // 此函数接受一个整数
{
    std::cout << "print(int): " << x << '\n';
}

void print(int* ptr) // 此函数接受一个整数指针
{
    std::cout << "print(int*): " << (ptr ? "non-null\n" : "null\n");
}

int main()
{
    int x{ 5 };
    int* ptr{ &x };

    print(ptr);  // 总是调用 print(int*)，因为 ptr 的类型是 int*（很好）
    print(0);    // 总是调用 print(int)，因为 0 是一个整数字面值（希望这是我们期望的）

    print(NULL); // 这条语句可能会执行以下任意一种：
    // 调用 print(int)（Visual Studio 就是这样）
    // 调用 print(int*)
    // 导致函数调用歧义的编译错误（gcc 和 Clang 就会这样）

    print(nullptr); // 总是调用 print(int*)

    return 0;
}
```

在作者的机器上（使用 Visual Studio），这会打印：

``` plaintext
print(int*): non-null
print(int): 0
print(int): 0
print(int*): null
```

当将整数值 `0` 作为参数传递时，编译器会优先选择 `print(int)` 而不是 `print(int*)`。当我们希望使用空指针参数调用 `print(int*)` 时，这可能会导致意想不到的结果。

在 `NULL` 被定义为值 `0` 的情况下，`print(NULL)` 也会调用 `print(int)`，而不是你期望的作为空指针字面值调用 `print(int*)`。在 `NULL` 不被定义为 `0` 的情况下，可能会产生其他行为，例如调用 `print(int*)` 或出现编译错误。

使用 `nullptr` 消除了这种歧义（它总是调用 `print(int*)`），因为 `nullptr` 只会匹配指针类型。
## `std::nullptr_t`

由于 `nullptr` 可以在函数重载中与整数值区分开来，它必须有一个不同的类型。那么 `nullptr` 是什么类型呢？答案是 `nullptr` 的类型是 `std::nullptr_t`（在头文件 `<cstddef>` 中定义）。`std::nullptr_t` 只能持有一个值：`nullptr`！虽然这看起来有点傻，但在某种情况下很有用。如果我们想编写一个只接受 `nullptr` 字面值参数的函数，我们可以将参数设为 `std::nullptr_t`。

```cpp
#include <iostream>
#include <cstddef> // 为了使用 std::nullptr_t

void print(std::nullptr_t)
{
    std::cout << "in print(std::nullptr_t)\n";
}

void print(int*)
{
    std::cout << "in print(int*)\n";
}

int main()
{
    print(nullptr); // 调用 print(std::nullptr_t)

    int x{ 5 };
    int* ptr{ &x };

    print(ptr); // 调用 print(int*)

    ptr = nullptr;
    print(ptr); // 调用 print(int*)（因为 ptr 的类型是 int*）

    return 0;
}
```

在上述示例中，函数调用 `print(nullptr)` 解析为函数 `print(std::nullptr_t)` 而非 `print(int*)`，因为它不需要转换。

可能有点令人困惑的一种情况是，当我们在 `ptr` 持有值 `nullptr` 时调用 `print(ptr)`。请记住，函数重载是根据类型而不是值来匹配的，`ptr` 的类型是 `int*`。因此，将匹配 `print(int*)`。在这种情况下，`print(std::nullptr_t)` 甚至不会被考虑，因为指针类型不会隐式转换为 `std::nullptr_t`。

你可能永远不需要使用这个，但知道一下也是好的，以防万一。
## 其实只有按值传递

现在你已经理解了按引用、按地址和按值传递之间的基本区别，让我们简化一下。:)

虽然编译器通常可以完全优化掉引用，但在某些情况下这是不可能的，实际上需要一个引用。引用通常由编译器使用指针来实现。这意味着在幕后，按引用传递本质上就是按地址传递。

而在前一课中，我们提到按地址传递只是将一个地址从调用者复制到被调用函数——这实际上是按值传递一个地址。

因此，我们可以得出结论：C++ 其实真的都是按值传递的！按地址（和引用）传递的特性仅仅来自于我们可以解引用传递的地址来改变参数，而对于普通的值参数，我们无法做到这一点！
# 12.12 - Return by reference and return by address 按引用返回和按地址返回

在之前的课程中，我们讨论了当按值传递参数时，参数的副本会被复制到函数的参数中。对于基本类型（复制成本低），这没有问题。但对于类类型（如 `std::string`），复制通常代价高昂。我们可以通过使用按（const）引用传递（或按地址传递）来避免昂贵的复制。

当按值返回时，我们遇到了类似的情况：返回值的副本被传递回调用者。如果函数的返回类型是类类型，这可能会很昂贵（消耗性能）。

```cpp
std::string returnByValue(); // 返回一个 std::string 的副本（开销大）
```
## 按引用返回

当我们将类类型传递回调用者时，我们可能（或可能不）希望按引用返回。**按引用返回** 返回一个绑定到被返回对象的引用，从而避免了对返回值的复制。要按引用返回，我们只需将函数的返回值定义为引用类型：

```cpp
std::string&       returnByReference();       // 返回现有 std::string 的引用（开销小）
const std::string& returnByReferenceToConst(); // 返回现有 std::string 的 const 引用（开销小）
```

下面的示例程序演示了按引用返回：

```cpp
#include <iostream>
#include <string>

const std::string& getProgramName() // 返回一个 const 引用
{
    static const std::string s_programName { "Calculator" }; // 具有静态持续时间，在程序结束时销毁

    return s_programName;
}

int main()
{
    std::cout << "This program is named " << getProgramName();

    return 0;
}
```

该程序将打印：

``` plaintext
This program is named Calculator
```

因为 `getProgramName()` 返回一个 const 引用，当执行 `return s_programName` 时，`getProgramName()` 将返回对 `s_programName` 的 const 引用（因此避免了复制）。然后，调用者可以使用该 const 引用来访问 `s_programName` 的值，并打印出来。
## 按引用返回的对象在函数返回后必须存在

使用按引用返回有一个主要的注意事项：程序员必须确保被引用的对象在返回引用的函数之后仍然存在。否则，返回的引用将成为悬空引用（引用一个已被销毁的对象），使用该引用将导致未定义的行为。

在上述程序中，因为 `s_programName` 具有静态持续时间，它将一直存在到程序结束。当 `main()` 访问返回的引用时，实际上是在访问 `s_programName`，这是可以的，因为 `s_programName` 直到程序结束时才会被销毁。

现在，让我们修改上述程序，展示当我们的函数返回一个悬空引用时会发生什么：

```cpp
#include <iostream>
#include <string>

const std::string& getProgramName()
{
    const std::string programName { "Calculator" }; // 现在是非静态的局部变量，函数结束时销毁

    return programName;
}

int main()
{
    std::cout << "This program is named " << getProgramName(); // 未定义行为

    return 0;
}
```

该程序的结果是未定义的。当 `getProgramName()` 返回时，返回了绑定到局部变量 `programName` 的引用。然后，由于 `programName` 是具有自动持续时间的局部变量，在函数结束时被销毁。这意味着返回的引用现在是悬空的，在 `main()` 函数中使用 `programName` 将导致未定义行为。

现代编译器如果你试图按引用返回局部变量，会产生警告或错误（所以上述程序可能甚至无法编译），但编译器有时难以检测更复杂的情况。

> [!warning] 警告 warning
> 
> 按引用返回的对象必须在返回引用的函数作用域之外继续存在，否则将导致悬空引用。**切勿**按引用返回（非静态）局部变量或临时对象。
## 生命周期延长在函数边界之外不起作用

让我们看一个按引用返回临时对象的例子：

```cpp
#include <iostream>

const int& returnByConstReference()
{
    return 5; // 返回对临时对象的 const 引用
}

int main()
{
    const int& ref { returnByConstReference() };

    std::cout << ref; // 未定义行为

    return 0;
}
```

在上述程序中，`returnByConstReference()` 返回一个整数字面值，但函数的返回类型是 `const int&`。这导致创建并返回一个绑定到值为 5 的临时对象的临时引用。这个返回的引用被复制到调用者作用域中的临时引用中。然后，临时对象超出作用域，导致调用者作用域中的临时引用悬空。

当调用者作用域中的临时引用绑定到 const 引用变量 `ref`（在 `main()` 中）时，延长临时对象的生命周期已经太晚了——因为它已经被销毁了。因此，`ref` 是一个悬空引用，使用 `ref` 的值将导致未定义行为。

这里有一个不太明显但同样不起作用的例子：

```cpp
#include <iostream>

const int& returnByConstReference(const int& ref)
{
    return ref;
}

int main()
{
    // 情况 1：直接绑定
    const int& ref1 { 5 }; // 延长生命周期
    std::cout << ref1 << '\n'; // 正常

    // 情况 2：间接绑定
    const int& ref2 { returnByConstReference(5) }; // 绑定到悬空引用
    std::cout << ref2 << '\n'; // 未定义行为

    return 0;
}
```

在情况 2 中，创建了一个临时对象来保存值 `5`，函数参数 `ref` 绑定到它。函数只是将这个引用返回给调用者，调用者然后使用该引用初始化 `ref2`。由于这不是对临时对象的直接绑定（因为引用通过函数传递），生命周期延长不适用。这使得 `ref2` 悬空，随后使用它会导致未定义行为。

> [!warning] 警告
> 
> 引用的生命周期延长不适用于跨越函数边界的情况。
## 不要按引用返回非 const 的静态局部变量

在上面最一开始的示例中，我们按引用返回了一个 const 静态局部变量，以简单说明按引用返回的机制。然而，按引用返回非 const 的静态局部变量是相当不常用的(non-idiomatic)，通常应避免。下面是一个简化的例子，说明可能发生的此类问题：

```cpp
#include <iostream>
#include <string>

const int& getNextId()
{
    static int s_x{ 0 }; // 注意：变量是非 const 的
    ++s_x; // 生成下一个 id
    return s_x; // 并返回对它的引用
}

int main()
{
    const int& id1 { getNextId() }; // id1 是一个引用
    const int& id2 { getNextId() }; // id2 是一个引用

    std::cout << id1 << id2 << '\n';

    return 0;
}
```

该程序打印：

``` plaintext
22
```

这是因为 `id1` 和 `id2` 引用的是同一个对象（静态变量 `s_x`），因此当任何东西（例如 `getNextId()`）修改了该值时，所有的引用现在都访问修改后的值。

上述例子可以通过将 `id1` 和 `id2` 设为普通变量（而不是引用）来修正，这样它们保存返回值的副本，而不是对 `s_x` 的引用。

> [!info] For advanced readers 给高级读者
> 这里有另一个不太明显的同样问题的例子：
> 
> ```cpp
> 
> std::string& getName()
> {
>     static std::string s_name{};
>     std::cout << "Enter a name: ";
>     std::cin >> s_name;
>     return s_name;
> }
> 
> void printFirstAlphabetical(std::string_view s1, std::string_view s2)
> {
>     if (s1 < s2)
>         std::cout << s1 << " comes before " << s2 << '\n';
>     else
>         std::cout << s2 << " comes before " << s1 << '\n';
> }
> 
> int main()
> {
>     printFirstAlphabetical(getName(), getName());
> 
>     return 0;
> }
> ```
> 
> 这是该程序一次运行的结果：
> 
> ``` plaintext
> Enter a name: Dave
> Enter a name: Stan
> Stan comes before Stan
> ```
> 
> 在此示例中，`getName()` 返回对静态局部变量 `s_name` 的引用。使用对 `s_name` 的引用初始化 `std::string_view`，会使该 `std::string_view` 查看 `s_name`（而不是复制它）。
> 
> 因此，`s1` 和 `s2` 最终都是 `s_name`（它被赋予了我们输入的最后一个名字）。

另一个经常出现在按引用返回非 const 静态局部变量的程序中的问题是，没有标准化的方法将 `s_x` 重置为默认状态。这样的程序必须使用非常规的解决方案（例如重置函数参数），或者只能通过退出并重新启动程序来重置。

> [!tip] 最佳实践 Best practice
> 避免按引用返回非 const 的静态局部变量。

如果按引用返回的局部变量创建和/或初始化代价高昂，有时会返回对 **const** 静态局部变量的 const 引用（这样我们就不必在每次函数调用时重新创建变量）。但这很少见。

有时也会返回对 **const** 全局变量的 const 引用，作为封装对全局变量访问的一种方式。我们在 [[Chapter 7 - Scope, Duration, and Linkage#7.8 Why (non-const) global variables are evil|7.8 —— 为什么（非 const）全局变量是有害的]] 中讨论了这一点。如果你明确自己的意图并且小心地使用时，这也是可以的。
## 使用返回的引用为普通变量赋值/初始化会进行复制

如果一个函数返回一个引用，并且该引用用于初始化或赋值给一个非引用变量，则返回值将被复制（就像它是按值返回的一样）。

```cpp
#include <iostream>
#include <string>

const int& getNextId()
{
    static int s_x{ 0 };
    ++s_x;
    return s_x;
}

int main()
{
    const int id1 { getNextId() }; // id1 现在是普通变量，接收从 getNextId() 按引用返回值的副本
    const int id2 { getNextId() }; // id2 现在是普通变量，接收从 getNextId() 按引用返回值的副本

    std::cout << id1 << id2 << '\n';

    return 0;
}
```

在上述示例中，`getNextId()` 返回一个引用，但 `id1` 和 `id2` 是非引用变量。在这种情况下，返回引用的值被复制到普通变量中。因此，该程序打印：

``` plaintext
12
```

另外，请注意，如果程序返回一个悬空引用，引用在复制之前就已经悬空，这将导致未定义行为：

```cpp
#include <iostream>
#include <string>

const std::string& getProgramName() // 将返回一个 const 引用
{
    const std::string programName{ "Calculator" };

    return programName;
}

int main()
{
    std::string name { getProgramName() }; // 复制一个悬空引用
    std::cout << "This program is named " << name << '\n'; // 未定义行为

    return 0;
}
```
## 按引用返回引用参数是可以的

在许多情况下，按引用返回对象是有意义的，我们将在后续课程中遇到许多这样的例子。然而，现在有一个有用的例子我们可以展示。

如果一个参数通过引用传递给函数，那么按引用返回该参数是安全的。这是有道理的：为了将参数传递给函数，参数必须存在于调用者的作用域中。当被调用函数返回时，该对象仍然必须存在于调用者的作用域中。

下面是这样一个函数的简单示例：

```cpp
#include <iostream>
#include <string>

// 接受两个 std::string 对象，返回按字母顺序排列第一个
const std::string& firstAlphabetical(const std::string& a, const std::string& b)
{
    return (a < b) ? a : b; // 我们可以对 std::string 使用 operator< 来确定按字母顺序哪个在前
}

int main()
{
    std::string hello { "Hello" };
    std::string world { "World" };

    std::cout << firstAlphabetical(hello, world) << '\n';

    return 0;
}
```

这将打印：

``` plaintext
Hello
```

在上述函数中，调用者通过 const 引用传入两个 `std::string` 对象，按字母顺序排列在前的那个字符串通过 const 引用传回。如果我们使用按值传递和按值返回，我们将创建多达 3 个 `std::string` 的副本（每个参数一个，返回值一个）。通过使用按引用传递/按引用返回，我们可以避免这些复制。
## 按 const 引用返回通过 const 引用传递的右值是可以的

当 const 引用参数的实参是右值时，按 const 引用返回该参数仍然是可以的。

这是因为右值直到它们被创建的完整表达式结束时才会被销毁。

首先，让我们看一下这个例子：

```cpp
#include <iostream>
#include <string>

std::string getHello()
{
    return std::string{"Hello"};
}

int main()
{
    const std::string s{ getHello() };

    std::cout << s;

    return 0;
}
```

在这种情况下，`getHello()` 按值返回一个 `std::string`，这是一个右值。然后，这个右值被用于初始化 `s`。在 `s` 初始化之后，创建右值的表达式已经评估完毕，右值被销毁。

现在让我们看看这个类似的例子：

```cpp
#include <iostream>
#include <string>

const std::string& foo(const std::string& s)
{
    return s;
}

std::string getHello()
{
    return std::string{"Hello"};
}

int main()
{
    const std::string s{ foo(getHello()) };

    std::cout << s;

    return 0;
}
```

在这种情况下，唯一的区别是右值通过 const 引用传递给 `foo()`，然后按 const 引用返回给调用者，然后用于初始化 `s`。其他一切都相同。

我们在 [[Chapter 14 - Introduction to Classes#14.6 Access functions|14.6 —— 访问函数]] 中讨论了类似的情况。
## 调用者可以通过引用修改返回的值

当参数通过非 const 引用传递给函数时，函数可以使用该引用修改参数的值。

同样，当函数返回一个非 const 引用时，调用者可以使用该引用修改返回的值。

阅读下面的程序：

```cpp
#include <iostream>

// 通过非 const 引用传入两个整数，按引用返回较大的一个
int& max(int& x, int& y)
{
    return (x > y) ? x : y;
}

int main()
{
    int a{ 5 };
    int b{ 6 };

    max(a, b) = 7; // 将 a 或 b 中较大的一个设为 7

    std::cout << a << b << '\n';

    return 0;
}
```

在上述程序中，`max(a, b)` 使用 `a` 和 `b` 作为参数调用 `max()` 函数。引用参数 `x` 绑定到参数 `a`，引用参数 `y` 绑定到参数 `b`。然后，函数确定 `x`（`5`）和 `y`（`6`）中哪个更大。在这种情况下，是 `y`，所以函数将 `y`（仍然绑定到 `b`）返回给调用者。然后，调用者将值 `7` 赋给这个返回的引用。

因此，表达式 `max(a, b) = 7` 实际上等同于 `b = 7`。

这将打印：

``` plaintext
57
```
## 按地址返回

**按地址返回** 与按引用返回几乎相同，只是返回的是对象的指针而不是对象的引用。按地址返回与按引用返回有相同的主要注意事项——按地址返回的对象必须在返回地址的函数作用域之外继续存在，否则调用者将收到一个悬空指针。

按地址返回相对于按引用返回的主要优势是，如果没有有效的对象可返回，我们可以让函数返回 `nullptr`。例如，假设我们有一个要搜索的学生列表。如果我们在列表中找到我们正在寻找的学生，我们可以返回表示匹配学生的对象的指针。如果我们没有找到任何匹配的学生，我们可以返回 `nullptr` 来表示未找到匹配的学生对象。

按地址返回的主要缺点是，调用者必须记得在解引用返回值之前进行 `nullptr` 检查，否则可能发生空指针解引用，导致未定义行为。由于这种危险，除非需要返回“无对象”的能力，否则应优先使用按引用返回而非按地址返回。

> [!tip] 最佳实践 Best Practice
> 
> 除了返回"无对象 `nullptr`"的很有必要的情形，其他情形下应优先使用按引用返回而非按地址返回。

> [!info] 相关内容 Related content

请参见 [[Chapter 5 - Constants and Strings#5.11 `std string_view` (part 2)|5.11 —— std::string_view（第二部分）]] 中快速指南部分以了解何时返回 `std::string_view` 与 `const std::string&`。
# 12.13 - In and out parameters 输入参数和输出参数

函数和其调用者通过两种机制进行通信：参数和返回值。当函数被调用时，调用者提供实参，函数通过其参数接收这些实参。这些参数可以通过值、引用或地址传递。

通常，我们会按值或按 const 引用传递参数。但有时我们可能需要采用其他方式。
## 输入参数

在大多数情况下，函数参数仅用于从调用者那里接收输入。仅用于接收调用者输入的参数有时称为**输入参数（in parameter）**。

```cpp
#include <iostream>

void print(int x) // x 是一个输入参数
{
    std::cout << x << '\n';
}

void print(const std::string& s) // s 是一个输入参数
{
    std::cout << s << '\n';
}

int main()
{
    print(5);
    std::string s { "Hello, world!" };
    print(s);

    return 0;
}
```

输入参数通常通过值或 const 引用传递。
## 输出参数

通过（非 const）引用（或地址）传递的函数参数允许函数修改作为参数传递的对象的值。这为函数提供了一种方式，将数据返回给调用者，在某些情况下使用返回值不足以满足需求。

仅用于将信息返回给调用者的函数参数称为**输出参数（out parameter）**。

例如：

```cpp
#include <cmath>    // 为了使用 std::sin() 和 std::cos()
#include <iostream>

// sinOut 和 cosOut 是输出参数
void getSinCos(double degrees, double& sinOut, double& cosOut)
{
    // sin() 和 cos() 接受的是弧度而不是度数，所以我们需要转换
    constexpr double pi { 3.14159265358979323846 }; // π 的值
    double radians = degrees * pi / 180.0;
    sinOut = std::sin(radians);
    cosOut = std::cos(radians);
}

int main()
{
    double sin { 0.0 };
    double cos { 0.0 };

    double degrees{};
    std::cout << "Enter the number of degrees: ";
    std::cin >> degrees;

    // getSinCos 将把 sin 和 cos 的值返回到变量 sin 和 cos 中
    getSinCos(degrees, sin, cos);

    std::cout << "The sin is " << sin << '\n';
    std::cout << "The cos is " << cos << '\n';

    return 0;
}
```

该函数有一个参数 `degrees`（其实参通过值传递）作为输入，并通过引用“返回”两个参数作为输出。

我们在输出参数的名称后加上后缀“Out”以表示它们是输出参数。这有助于提醒调用者：这些参数传入的初始值无关紧要，应该预知它们会被覆盖。按照惯例，输出参数通常放在最右边的参数位置。

让我们更详细地探讨其工作原理。首先，主函数创建了局部变量 `sin` 和 `cos`。它们通过引用（而不是值）传递给函数 `getSinCos()`。这意味着函数 `getSinCos()` 可以访问 `main()` 中实际的 `sin` 和 `cos` 变量，而不仅仅是它们的副本。`getSinCos()` 相应地给 `sinOut` 和 `cosOut`（分别对应 `sin` 和 `cos` 的引用）赋予新值，覆盖了 `sin` 和 `cos` 中的旧值。然后，`main()` 函数打印这些更新后的值。

如果 `sin` 和 `cos` 是通过值而不是引用传递的，`getSinCos()` 将修改 `sin` 和 `cos` 的副本，导致在函数结束时任何更改都会被丢弃。但由于 `sin` 和 `cos` 是通过引用传递的，对 `sin` 或 `cos`（通过引用）的任何更改都将在函数之外保留。因此，我们可以使用这种机制将值返回给调用者。

> [!info] 顺便说一下 As an aside…

[StackOverflow 上的这个回答](https://stackoverflow.com/a/9779765) 是一篇有趣的阅读材料。它解释了为什么非 const 左值引用不能绑定到右值/临时对象（因为隐式类型转换在与输出参数结合使用时会产生意想不到的行为）。
## 输出参数的语法不够自然

虽然输出参数功能上可行，但有一些缺点。

首先，调用者必须实例化（并初始化）对象并将其作为参数传递，即使它并不打算使用它们。这些对象必须是可赋值的，这意味着它们不能被声明为 const。

其次，因为调用者必须传入对象，这些值不能作为临时对象，或在单个表达式中轻松使用。

下面的示例代码展示了这些缺点：

```cpp
#include <iostream>

int getByValue()
{
    return 5;
}

void getByReference(int& x)
{
    x = 5;
}

int main()
{
    // 按值返回
    [[maybe_unused]] int x{ getByValue() }; // 可用于初始化对象
    std::cout << getByValue() << '\n';      // 可在表达式中使用临时返回值

    // 通过输出参数返回
    int y{};                // 必须首先分配一个可赋值的对象
    getByReference(y);      // 然后传递给函数以赋予所需的值
    std::cout << y << '\n'; // 然后才能使用该值

    return 0;
}
```

如你所见，使用输出参数的语法有点不自然。
## 通过引用的输出参数修改值不明显

当我们将函数的返回值赋给一个对象时，很明显对象的值正在被修改：

```cpp
x = getByValue(); // 很明显 x 正在被修改
```

这很好，因为它清楚地表明我们应该预期 `x` 的值会发生变化。

然而，让我们再次看看上面示例中对 `getSinCos()` 的函数调用：

```cpp
getSinCos(degrees, sin, cos);
```

从这个函数调用中，并不清楚 `degrees` 是一个输入参数，而 `sin` 和 `cos` 是输出参数。如果调用者没有意识到 `sin` 和 `cos` 将被修改，可能会导致语义错误。

在某些情况下，使用按地址传递而不是按引用传递可以帮助使输出参数更加明显，因为它要求调用者将对象的地址作为参数传递。

考虑以下示例：

```cpp
void foo1(int x);  // 按值传递
void foo2(int& x); // 按引用传递
void foo3(int* x); // 按地址传递

int main()
{
    int i{};

    foo1(i);  // 不能修改 i
    foo2(i);  // 可以修改 i（不明显）
    foo3(&i); // 可以修改 i

    int* ptr { &i };
    foo3(ptr); // 可以修改 i（不明显）

    return 0;
}
```

注意在调用 `foo3(&i)` 时，我们必须传入 `&i` 而不是 `i`，这有助于更清楚地表明我们应该预期 `i` 会被修改。

然而，这并非万无一失，因为 `foo3(ptr)` 允许 `foo3()` 修改 `i`，并且不要求调用者对 `ptr` 取地址。

调用者还可能认为他们可以传入 `nullptr` 或空指针作为有效参数，而这是不允许的。而且函数现在需要进行空指针检查和处理，这增加了复杂性。这种需要额外的空指针处理通常会导致比坚持使用按引用传递更多的问题。

出于所有这些原因，除非没有其他好的选项，否则应避免使用输出参数。

> [!tip] 最佳实践 Best practice
> 
> 避免使用输出参数（除非在极少数情况下没有更好的选择）。
> 
> 对于非可选的输出参数，优先使用按引用传递。
## 输入/输出参数

在极少数情况下，函数实际上会在覆盖其值之前使用输出参数的值。这种参数称为**输入/输出参数（in-out parameter）**。输入/输出参数的工作方式与输出参数完全相同，并且问题也相同。
## 何时使用非 const 引用传递

如果你打算通过引用传递以避免复制参数的副本，你基本上都应该通过 const 引用传递。

> [!note] 作者注 Author’s note
> 
> 在以下示例中，我们将使用 `Foo` 来表示我们关心的某种类型。目前，你可以将 `Foo` 想象为你选择的类型的别名（例如 `std::string`）。

然而，有两种主要情况，非 const 引用传递可能是更好的选择。

首先，当参数是输入/输出参数时，使用非 const 引用传递。由于我们已经传入了我们需要返回的对象，直接修改该对象通常更直接和高效。

```cpp
void someFcn(Foo& inout)
{
    // 修改 inout
}

int main()
{
    Foo foo{};
    someFcn(foo); // 调用后 foo 被修改，可能不明显

    return 0;
}
```

为函数起一个好名字有所帮助：

```cpp
void modifyFoo(Foo& inout)
{
    // 修改 inout
}

int main()
{
    Foo foo{};
    modifyFoo(foo); // 调用后 foo 被修改，稍微更明显

    return 0;
}
```

另一种选择是按照常规方式通过值或 const 引用传递对象，并按值返回一个新对象，调用者然后可以将其赋回原始对象：

```cpp
Foo someFcn(const Foo& in)
{
    Foo foo { in }; // 这里进行复制
    // 修改 foo
    return foo;
}

int main()
{
    Foo foo{};
    foo = someFcn(foo); // 明确表明 foo 被修改，但这里又进行了复制

    return 0;
}
```

这具有使用更常规的返回语法的优点，但需要进行 2 次额外的复制（有时编译器可以优化掉其中一次复制）。

其次，当函数需要将对象按值返回给调用者，但复制该对象的成本非常高昂时，使用非 const 引用传递。特别是当函数在性能关键的代码段中被多次调用时。

```cpp
void generateExpensiveFoo(Foo& out)
{
    // 修改 out
}

int main()
{
    Foo foo{};
    generateExpensiveFoo(foo); // 调用后 foo 被修改

    return 0;
}
```

> [!info] 给高级读者 For advanced readers
> 
> 上述方法最常见的例子是，当函数需要用数据填充一个大的 C 风格数组或 `std::array`，且数组具有复制成本高昂的元素类型时。我们将在后续章节中讨论数组。

尽管如此，对象很少昂贵到值得采用如此不常用的方法来返回这些对象。
# 12.14 Type deduction with pointers, references, and const
# 12.15 `std::optional`
# 12.x Chapter 12 summary and quiz

