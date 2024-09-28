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

