# 7.1 Compound statements (blocks) 复合语句（代码块）

复合语句（也称为代码块或块语句）是一组语句（零个或多个），编译器将它们视为单个语句。

代码块以 `{` 符号开始，以 `}` 符号结束，要执行的语句放在中间。代码块可以在任何允许单个语句的地方使用。代码块结束时不需要分号。

在编写函数时，你已经看到了代码块的例子，因为函数体就是一个代码块：

```cpp
int add(int x, int y)
{ // 开始代码块
    return x + y;
} // 结束代码块（不需要分号）

int main()
{ // 开始代码块

    // 多个语句
    int value {}; // 这是初始化，不是代码块
    add(3, 4);

    return 0;

} // 结束代码块（不需要分号）
```
## 代码块内的代码块

虽然函数不能嵌套（在其他函数内部），但代码块可以嵌套（在其他代码块内部）：

```cpp
int add(int x, int y)
{ // 代码块
    return x + y;
} // 结束代码块

int main()
{ // 外部代码块

    // 多个语句
    int value {};

    { // 内部/嵌套代码块
        add(3, 4);
    } // 结束内部/嵌套代码块

    return 0;

} // 结束外部代码块
```

当代码块嵌套时，包围的代码块通常被称为外部代码块，被包围的代码块被称为内部代码块或嵌套代码块。
## 使用代码块有条件地执行多个语句

代码块最常见的用例之一是与`if`语句结合使用。默认情况下，`if`语句在条件为真时执行单个语句。但是，如果我们希望在条件为真时执行多个语句，我们可以用一个代码块替换这个单个语句。

```cpp
#include <iostream>

int main()
{ // 外部代码块开始
    std::cout << "Enter an integer: ";
    int value {};
    std::cin >> value;

    if (value >= 0)
    { // 嵌套代码块开始
        std::cout << value << " is a positive integer (or zero)\n";
        std::cout << "Double this number is " << value * 2 << '\n';
    } // 嵌套代码块结束
    else
    { // 另一个嵌套代码块开始
        std::cout << value << " is a negative integer\n";
        std::cout << "The positive of this number is " << -value << '\n';
    } // 另一个嵌套代码块结束

    return 0;
} // 外部代码块结束
```

如果用户输入数字3，这个程序会打印：

```
Enter an integer: 3
3 is a positive integer (or zero)
Double this number is 6
```

如果用户输入数字-4，这个程序会打印：

```
Enter an integer: -4
-4 is a negative integer
The positive of this number is 4
```

## 嵌套块的层级
在C++中，块可以嵌套在块里，再嵌套在其他块中：

```cpp
#include <iostream>

int main()
{ // 块 1，嵌套层级 1
    std::cout << "Enter an integer: ";
    int value {};
    std::cin >> value;

    if (value > 0)
    { // 块 2，嵌套层级 2
        if ((value % 2) == 0)
        { // 块 3，嵌套层级 3
            std::cout << value << " is positive and even\n";
        }
        else
        { // 块 4，同样是嵌套层级 3
            std::cout << value << " is positive and odd\n";
        }
    }

    return 0;
}
```

嵌套层级（也称为嵌套深度）是指在函数中你可以同时位于的最大嵌套块数。在上述代码中，虽然有4个块，但嵌套层级是3，因为程序中任何时刻最多位于3个嵌套块内。

C++标准规定，编译器应支持最多256级嵌套，但并非所有编译器都支持（如在撰写本文时，Visual Studio支持的层级较少）。

通常建议将嵌套层级保持在3级或以下。就像过长的函数应被重构一样，过度嵌套的块也难以阅读，同样可以通过重构使代码更简洁。

> 最佳实践 
> 
> 将函数的嵌套层级限制在3级以内。如需更多嵌套层级时，考虑将代码重构为子函数。
# 7.2 User-defined namespaces and the scope resolution operator 用户自定义命名空间和作用域解析运算符
在课程 [[Chapter 2 - C++ Basics - Functions and Files#2.9 Naming collisions and an introduction to namespaces|2.9 — 命名冲突和命名空间简介]] 中，我们介绍了命名冲突和命名空间的概念。回顾一下，命名冲突发生在两个相同的标识符被引入到同一作用域时，编译器无法明确使用哪个标识符。当这种情况发生时，编译器或链接器会产生错误，因为它们无法解决这个歧义。

> 关键见解
> 
> 随着程序变大，标识符的数量也随之增加，从而命名冲突发生的概率会显著增加。因为同一作用域中的每一个名字都有可能与其他名字发生冲突，标识符数量的线性增加会导致潜在冲突的指数增加！这也是将标识符定义在最小作用域内的关键原因之一。

让我们重新审视一个命名冲突的例子，并展示如何使用命名空间改进。以下例子中，`foo.cpp` 和 `goo.cpp` 是两个包含具有相同名称和参数的函数的源文件，但这些函数的功能不同。

**foo.cpp:**

```cpp
// 这个 doSomething() 函数相加它的参数
int doSomething(int x, int y)
{
    return x + y;
}
```

**goo.cpp:**

```cpp
// 这个 doSomething() 函数相减它的参数
int doSomething(int x, int y)
{
    return x - y;
}
```

**main.cpp:**

```cpp
#include <iostream>

int doSomething(int x, int y); // doSomething 的前向声明

int main()
{
    std::cout << doSomething(4, 3) << '\n'; // 我们会调用哪个 doSomething 函数？
    return 0;
}
```

如果项目中只包含 `foo.cpp` 或 `goo.cpp`，则编译和运行时不会出现问题。然而，如果将它们同时编译到同一个程序中，我们就引入了两个相同名称和参数的函数到同一作用域（全局作用域），导致命名冲突。结果，链接器将发出错误：

```plaintext
goo.cpp:3: multiple definition of `doSomething(int, int)'; foo.cpp:3: first defined here
```

注意，这个错误发生在函数重定义处，所以即使 `doSomething` 函数从未被调用，也会产生错误。

解决此问题的一种方法是重命名其中一个函数，这样名字就不会再冲突了。但这也要求更改所有函数调用的名字，可能带来麻烦并容易出错。更好的避免冲突的方法是将函数放入命名空间中。正是因为这个原因，标准库被放入了 `std` 命名空间中。
## 定义用户自定义命名空间

C++ 允许我们通过 `namespace` 关键字定义自己的命名空间。你在程序中创建的命名空间通常被称为**用户自定义命名空间**（但更准确地说应该称为程序定义命名空间）。

命名空间的语法如下：

```cpp
namespace NamespaceIdentifier
{
    // 命名空间的内容
}
```

我们从 `namespace` 关键字开始，后跟命名空间标识符，接着是包含命名空间内容的大括号。

历史上来看，命名空间的名称通常不使用大写字母，许多风格指南仍然推荐这种约定。

> 面向高级读者
> 
> 一些建议首字母大写命名空间的原因：
>
> 1. 按约定，程序定义的类型以大写字母开头。为程序定义的命名空间使用相同的约定是一种一致性做法（特别是使用诸如 `Foo::x` 这样合格的名称时，`Foo` 既可以是命名空间，也可以是类类型）。
> 2. 这有助于防止与系统或库提供的小写名称发生命名冲突。
> 3. C++20 标准文档采用了这种风格。
> 4. C++ 核心指南文档使用了这种风格。

我们推荐命名空间名以大写字母开头。然而，无论哪种风格都是可以接受的。

命名空间必须在全局作用域中定义，或者嵌套在另一个命名空间中。与函数内容类似，命名空间的内容通常缩进一级。你偶尔会看到大括号后加一个可选的分号。

下面是使用命名空间重写之前的例子：

**foo.cpp:**

```cpp
namespace Foo // 定义名为 Foo 的命名空间
{
    // 这个 doSomething() 属于 Foo 命名空间
    int doSomething(int x, int y)
    {
        return x + y;
    }
}
```

**goo.cpp:**

```cpp
namespace Goo // 定义名为 Goo 的命名空间
{
    // 这个 doSomething() 属于 Goo 命名空间
    int doSomething(int x, int y)
    {
        return x - y;
    }
}
```

现在 `foo.cpp` 中的 `doSomething()` 位于 `Foo` 命名空间，而 `goo.cpp` 中的 `doSomething()` 位于 `Goo` 命名空间。让我们看看重新编译程序时会发生什么。

**main.cpp:**

```cpp
int doSomething(int x, int y); // doSomething 的前向声明

int main()
{
    std::cout << doSomething(4, 3) << '\n'; // 我们会调用哪个 doSomething 函数？
    return 0;
}
```

现在我们会得到另一个错误：

```plaintext
ConsoleApplication1.obj : error LNK2019: unresolved external symbol "int __cdecl doSomething(int,int)" (?doSomething@@YAHHH@Z) referenced in function _main
```

在这种情况下，编译器被前向声明满足了，但链接器找不到全局命名空间中的 `doSomething` 定义。因为我们两个版本的 `doSomething` 都不再在全局命名空间中！它们现在位于各自命名空间的作用域中。

有两种不同的方法告诉编译器使用哪个版本的 `doSomething()`：通过**作用域解析运算符**，或者通过 **using** 语句（我们将在本章后面的课程中讨论）。
## 使用作用域解析运算符`::`访问命名空间
告诉编译器在特定命名空间中查找标识符的最佳方法是使用作用域解析运算符 `::`。作用域解析运算符告诉编译器，右侧操作数指定的标识符应在左侧操作数的作用域中查找。

```cpp
#include <iostream>

namespace Foo // 定义名为 Foo 的命名空间
{
    // 这个 doSomething() 属于 Foo 命名空间
    int doSomething(int x, int y)
    {
        return x + y;
    }
}

namespace Goo // 定义名为 Goo 的命名空间
{
    // 这个 doSomething() 属于 Goo 命名空间
    int doSomething(int x, int y)
    {
        return x - y;
    }
}

int main()
{
    std::cout << Foo::doSomething(4, 3) << '\n'; // 使用 Foo 命名空间中的 doSomething()
    return 0;
}
```

这将输出预期结果：

```plaintext
7
```

如果我们想使用 `Goo` 命名空间中的 `doSomething()` 版本：

```cpp
#include <iostream>

namespace Foo // 定义名为 Foo 的命名空间
{
    // 这个 doSomething() 属于 Foo 命名空间
    int doSomething(int x, int y)
    {
        return x + y;
    }
}

namespace Goo // 定义名为 Goo 的命名空间
{
    // 这个 doSomething() 属于 Goo 命名空间
    int doSomething(int x, int y)
    {
        return x - y;
    }
}

int main()
{
    std::cout << Goo::doSomething(4, 3) << '\n'; // 使用 Goo 命名空间中的 doSomething()
    return 0;
}
```

这将输出结果：

```plaintext
1
```

作用域解析运算符非常有用，因为它允许我们明确选择要查找的命名空间，从而避免任何潜在的歧义。我们甚至可以像这样做：

```cpp
#include <iostream>

namespace Foo // 定义名为 Foo 的命名空间
{
    // 这个 doSomething() 属于 Foo 命名空间
    int doSomething(int x, int y)
    {
        return x + y;
    }
}

namespace Goo // 定义名为 Goo 的命名空间
{
    // 这个 doSomething() 属于 Goo 命名空间
    int doSomething(int x, int y)
    {
        return x - y;
    }
}

int main()
{
    std::cout << Foo::doSomething(4, 3) << '\n'; // 使用 Foo 命名空间中的 doSomething()
    std::cout << Goo::doSomething(4, 3) << '\n'; // 使用 Goo 命名空间中的 doSomething()
    return 0;
}
```

这会输出：

```plaintext
7
1
```

### 在没有命名空间前缀的情况下使用作用域解析运算符

作用域解析运算符还可以在不提供命名空间名称的情况下使用（例如 `::doSomething`）。在这种情况下，标识符（例如 `doSomething`）将在**全局命名空间**中查找。

```cpp
#include <iostream>

void print() // 这个 print() 在全局命名空间中
{
	std::cout << " there\n";
}

namespace Foo
{
	void print() // 这个 print() 在 Foo 命名空间中
	{
		std::cout << "Hello";
	}
}

int main()
{
	Foo::print(); // 调用 Foo 命名空间中的 print()
	::print();    // 调用全局命名空间中的 print()（在这种情况下与直接调用 print() 相同）

	return 0;
}
```

在上面的例子中，`::print()` 的行为与直接调用 `print()` 相同，因此这里使用作用域解析运算符是多余的。但接下来的例子将展示一个作用域解析运算符有用的情况。

### 命名空间内部的标识符解析

如果命名空间内部使用了一个标识符且没有提供作用域解析，编译器首先会尝试在同一命名空间内找到匹配的声明。如果没有找到匹配的标识符，编译器将依次检查每个包含的命名空间，最后检查全局命名空间。

```cpp
#include <iostream>

void print() // 这个 print() 在全局命名空间中
{
	std::cout << " there\n";
}

namespace Foo
{
	void print() // 这个 print() 在 Foo 命名空间中
	{
		std::cout << "Hello";
	}

	void printHelloThere()
	{
		print();   // 调用 Foo 命名空间中的 print()
		::print(); // 调用全局命名空间中的 print()
	}
}

int main()
{
	Foo::printHelloThere();

	return 0;
}
```

输出结果为：

```plaintext
Hello there
```

在上面的例子中，`print()` 的调用没有提供作用域解析。因为这个 `print()` 调用位于 `Foo` 命名空间内，编译器会首先查找 `Foo::print()` 的声明。由于存在匹配的声明，因此调用的是 `Foo::print()`。

如果 `Foo::print()` 不存在，编译器会检查包含的命名空间（在这种情况下是全局命名空间），以查看是否可以匹配全局命名空间中的 `print()`。

我们还使用了没有命名空间的作用域解析运算符 `::print()` 来显式调用全局版本的 `print()`。
#### 命名空间中的前向声明
在课程 [[Chapter 2 - C++ Basics - Functions and Files#2.10 Introduction to the preprocessor|2.11 — 头文件]]中，我们讨论了如何使用头文件来传播前向声明。对于命名空间中的标识符，这些前向声明也需要位于同一个命名空间内：

**add.h**

```cpp
#ifndef ADD_H
#define ADD_H

namespace BasicMath
{
    // 函数 add() 是 BasicMath 命名空间的一部分
    int add(int x, int y);
}

#endif
```

**add.cpp**
```cpp
#include "add.h"

namespace BasicMath
{
    // 在 BasicMath 命名空间中定义函数 add()
    int add(int x, int y)
    {
        return x + y;
    }
}
```

**main.cpp**
```cpp
#include "add.h" // 为了使用 BasicMath::add()

#include <iostream>

int main()
{
    std::cout << BasicMath::add(4, 3) << '\n';

    return 0;
}
```

如果 `add()` 的前向声明不放在 `BasicMath` 命名空间内，那么 `add()` 将在全局命名空间中声明，编译器将报错，提示没有看到 `BasicMath::add(4, 3)` 的声明。如果函数 `add()` 的定义不在 `BasicMath` 命名空间中，链接器将报错，提示找不到与 `BasicMath::add(4, 3)` 调用匹配的定义。
## 允许多个命名空间块
在多个位置声明命名空间块是合法的（可以跨多个文件，或在同一个文件的多个位置）。命名空间中的所有声明都被视为命名空间的一部分。

**circle.h：**
```cpp
#ifndef CIRCLE_H
#define CIRCLE_H

namespace BasicMath
{
    constexpr double pi{ 3.14 };
}

#endif
```

**growth.h：**
```cpp
#ifndef GROWTH_H
#define GROWTH_H

namespace BasicMath
{
    // 常量 e 也是 BasicMath 命名空间的一部分
    constexpr double e{ 2.7 };
}

#endif
```

**main.cpp：**
```cpp
#include "circle.h" // 为了使用 BasicMath::pi
#include "growth.h" // 为了使用 BasicMath::e

#include <iostream>

int main()
{
    std::cout << BasicMath::pi << '\n';
    std::cout << BasicMath::e << '\n';

    return 0;
}
```

这会产生如下结果：

```plaintext
3.14
2.7
```

标准库广泛使用了这种功能，因为每个标准库头文件都包含其声明在 `std` 命名空间块中。如果不是这样，整个标准库将不得不在一个单一的头文件中定义！

值得注意的是，这种功能也意味着你可以向 `std` 命名空间添加自己的功能。然而，这通常会导致未定义的行为，因为 `std` 命名空间有一个特别的规则，禁止用户代码扩展它。

> **警告**  
> 
> 不要向 `std` 命名空间添加自定义功能。

## 嵌套命名空间
命名空间可以嵌套在其他命名空间中。例如：

```cpp
#include <iostream>

namespace Foo
{
    namespace Goo // Goo 是 Foo 命名空间中的一个命名空间
    {
        int add(int x, int y)
        {
            return x + y;
        }
    }
}

int main()
{
    std::cout << Foo::Goo::add(1, 2) << '\n';
    return 0;
}
```

注意，由于 `Goo` 是 `Foo` 命名空间中的一个（子）命名空间，我们通过 `Foo::Goo::add` 来访问 `add`。

从 C++17 开始，嵌套命名空间也可以这样声明：

```cpp
#include <iostream>

namespace Foo::Goo // Goo 是 Foo 命名空间中的一个命名空间（C++17 风格）
{
    int add(int x, int y)
    {
        return x + y;
    }
}

int main()
{
    std::cout << Foo::Goo::add(1, 2) << '\n';
    return 0;
}
```

这与之前的例子是等价的。

如果你以后需要仅向 `Foo` 命名空间添加声明，可以定义一个单独的 `Foo` 命名空间来完成：

```cpp
#include <iostream>

namespace Foo::Goo // Goo 是 Foo 命名空间中的一个命名空间（C++17 风格）
{
    int add(int x, int y)
    {
        return x + y;
    }
}

namespace Foo
{
     void someFcn() {} // 这个函数只在 Foo 命名空间中
}

int main()
{
    std::cout << Foo::Goo::add(1, 2) << '\n';
    return 0;
}
```

你是选择使用单独的 `Foo::Goo` 定义，还是在 `Foo` 中嵌套 `Goo`，这仅仅是编码风格上的不同。
## 命名空间别名

由于在嵌套命名空间中键入完整的变量或函数名会比较麻烦，C++ 允许你创建命名空间别名，它可以暂时将一个长序列的命名空间缩短为更简单的名称：

```cpp
#include <iostream>

namespace Foo::Goo


{
    int add(int x, int y)
    {
        return x + y;
    }
}

int main()
{
    namespace Active = Foo::Goo; // Active 现在指代 Foo::Goo

    std::cout << Active::add(1, 2) << '\n'; // 实际上是 Foo::Goo::add()

    return 0;
} // Active 别名在此结束
```

命名空间别名的一个好处是：如果你以后想将 `Foo::Goo` 中的功能移动到另一个地方，你只需更新 `Active` 别名，而不必找到并替换所有 `Foo::Goo` 的实例。

```cpp
#include <iostream>

namespace Foo::Goo
{
}

namespace V2
{
    int add(int x, int y)
    {
        return x + y;
    }
}

int main()
{
    namespace Active = V2; // Active 现在指代 V2

    std::cout << Active::add(1, 2) << '\n'; // 我们不需要更改这个调用

    return 0;
}
```

## 如何使用命名空间

值得注意的是，C++ 中的命名空间最初并不是为了实现信息层次结构而设计的——它们主要是为了解决命名冲突问题。一个证据就是，整个标准库都位于单一的顶级命名空间 `std` 中。引入大量名称的新标准库功能开始使用嵌套命名空间（例如 `std::ranges`）来避免 `std` 命名空间内的命名冲突。

为你自己使用开发的小型应用程序通常不需要放入命名空间中。然而，对于包含大量第三方库的大型个人项目，给你的代码添加命名空间可以帮助防止与那些没有正确命名空间化的库发生命名冲突。

> 作者注
> 
> 在这些教程中，除非我们专门展示命名空间的某些特性，否则示例通常不会使用命名空间，以便使例子更加简洁。

如果代码将分发给他人，则绝对应该使用命名空间来防止与集成到其他代码中的冲突。通常单一顶级命名空间就足够了（例如 `Foologger`）。此外，将库代码放入命名空间中还允许用户通过编辑器的自动补全和建议功能查看库的内容（例如，如果输入 `Foologger`，自动补全将显示 `Foologger` 内的所有名称）。

在多团队组织中，通常使用两级甚至三级命名空间来防止不同团队生成的代码之间的命名冲突。这些命名空间通常采用以下形式：

- 项目或库 :: 模块（例如 `Foologger::Lang`）
- 公司或组织 :: 项目或库（例如 `Foosoft::Foologger`）
- 公司或组织 :: 项目或库 :: 模块（例如 `Foosoft::Foologger::Lang`）

使用模块级别的命名空间可以帮助将可能以后可重用的代码与不可重用的应用程序特定代码分开。例如，物理和数学函数可以放入一个命名空间（如 `Math::`），语言和本地化函数放入另一个命名空间（如 `Lang::`）。不过，目录结构也可以用于此目的（将应用程序特定代码放在项目目录树中，将可重用代码放在单独的共享目录树中）。

一般来说，你应该避免使用过深的命名空间（超过三级）。

> 相关内容
> 
> C++ 提供了其他有用的命名空间功能。在[[Chapter 7 - Scope, Duration, and Linkage#7.13 Unnamed and inline namespaces| 7.13 — 未命名和内联命名空间]]这节课中，我们将介绍未命名命名空间和内联命名空间。
# 7.3 Local variables
# 7.4 Introduction to global variables
# 7.5 Variable shadowing (name hiding)
# 7.6 Internal linkage
# 7.7 External linkage and variable forward declarations
# 7.8 Why (non-const) global variables are evil
# 7.9 Sharing global constants across multiple files (using inline variables)
# 7.10 Static local variables
# 7.11 Scope, duration, and linkage summary
# 7.12 Using declarations and using directives
# 7.13 Unnamed and inline namespaces
# 7.x Chapter 7 summary and quiz