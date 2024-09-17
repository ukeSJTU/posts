# 3.1 — 语法错误和语义错误
软件错误普遍存在。它们很容易产生，却很难发现。在本章中，我们将探讨与在C++程序中查找和消除错误相关的主题，包括学习如何使用集成开发环境（IDE）中的集成调试器。

尽管调试工具和技术并不是C++标准的一部分，但学习如何在你编写的程序中查找和消除错误是成为一名成功程序员的极其重要的部分。因此，我们将花一些时间来讨论这些主题，以便随着你编写的程序变得越来越复杂，你诊断和解决问题的能力也能相应提高。

如果你有使用其他编程语言调试程序的经验，这里的很多内容对你来说可能很熟悉。
## 语法错误
编程可能具有挑战性，而C++是一种有些特殊的语言。将两者结合起来，就有可能会犯很多错误。错误通常分为两类：语法错误和语义错误（逻辑错误）。

语法错误发生在你编写的语句不符合C++语言语法规则的时候。这包括诸如缺少分号、括号或大括号不匹配等错误。例如，以下程序包含了相当多的语法错误：

```cpp
#include <iostream>

int main( // 缺少右括号
{
    int 1x; // 变量名不能以数字开头
    std::cout << "Hi there"; << x +++ << '\n'; // 多余的分号，操作符+++不存在
    return 0 // 语句末尾缺少分号
}
```

幸运的是，编译器会检测语法错误并发出编译警告或错误，因此你可以轻松识别并修复问题。然后只需要不断编译，直到消除所有错误。
## 语义错误
语义错误是意义上的错误。这些错误的语句在语法上看起来是有效的，但要么违反了语言的其他规则，要么没有达到程序员的预期目的。

某些类型的语义错误可以被编译器捕获。常见的例子包括使用未声明的变量、类型不匹配（当我们在某处使用了错误类型的对象）等。

例如，以下程序包含几个编译时语义错误：

```cpp
int main()
{
    5 = x; // x未声明，不能给5赋值
    return "hello"; // "hello"不能转换为int类型
}
```

其他语义错误只有在运行时才会显现。有时这些错误会导致你的程序崩溃，比如除以零的情况：

```cpp
#include <iostream>

int main()
{
    int a { 10 };
    int b { 0 };
    std::cout << a << " / " << b << " = " << a / b << '\n'; // 除以0在数学上是未定义的
    return 0;
}
```

更常见的是，这些错误只会产生错误的值或行为：

```cpp
#include <iostream>

int main()
{
    int x; // 没有提供初始化器
    std::cout << x << '\n'; // 使用未初始化的变量会导致未定义的结果

    return 0;
}
```

或者

```cpp
#include <iostream>

int add(int x, int y) // 这个函数应该执行加法
{
    return x - y; // 但由于使用了错误的运算符，它没有执行加法
}

int main()
{
    std::cout << "5 + 3 = " << add(5, 3) << '\n'; // 应该输出8，但输出2

    return 0;
}
```

或者

```cpp
#include <iostream>

int main()
{
    return 0; // 函数在这里返回

    std::cout << "Hello, world!\n"; // 所以这行永远不会执行
}
```

在上面的例子中，错误相当容易发现。但在大多数复杂的程序中，运行时的语义错误通过肉眼检查代码是不容易发现的。这就是调试技术派上用场的地方。
# 3.2 The debugging process
# 3.3 A strategy for debugging
# 3.4 Basic debugging tactics
# 3.5 More debugging tactics
# 3.6 Using an integrated debugger: Stepping
# 3.7 Using an integrated debugger: Running and breakpoints
# 3.8 Using an integrated debugger: Watching variables
# 3.9 Using an integrated debugger: The call stack
# 3.10 Finding issues before they become problems
# 3.x Chapter 3 summary and quiz