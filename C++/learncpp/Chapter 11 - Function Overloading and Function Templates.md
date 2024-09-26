# 11.1 Introduction to function overloading 函数重载简介

考虑有这样的一个函数：
``` cpp
int add(int x, int y)
{
	return x + y; 
}
```

这个函数将两个整数作为参数并返回它们的和。那如果我想要将两个浮点数相加呢？这个`add`函数就没法用了，如果仍然调用的话就会因为浮点数向整数的类型转换而损失精度。

一种解决办法就是定义许多相同的，有着类似名字的函数：

```cpp
int addInteger(int x, int y)
{
    return x + y;
}

double addDouble(double x, double y)
{
    return x + y;
}
```

但这也有个显而易见的问题：你需要一套完整、规范的函数名称这样你才能在调用函数的时候不至于搞错函数名称。

而如果你又需要将3个参数相加而不仅仅是2个，上面的方法就会显得更难用了。
## 重载函数简介

幸运的是，C++ 有一个优雅的解决方案来处理此类情况——**函数重载**。函数重载允许我们创建多个**同名**的函数，只要每个同名函数具有不同的参数类型（或者可以以其他方式区分这几个函数）。共享一个名称（在同一个作用域范围内）的每个函数称为**重载函数**（有时简称为**重载**）。

要重载我们的 `add()` 函数，我们可以简单地声明另一个采用双精度参数的 `add()` 函数：
``` cpp
double add(double x, double y)
{
    return x + y;
}
```

现在，我们在同一个作用域中有两个版本的 `add()`

``` cpp
int add(int x, int y) // integer version
{
    return x + y;
}

double add(double x, double y) // floating point version
{
    return x + y;
}

int main()
{
    return 0;
}
```

上面的程序可以通过变异。因为这两个`add`函数的参数数据类型不同，所以编译器能够区分这些函数，并将它们看作两个恰好名字相同的函数。

> [!example] 关键洞察
> 只要编译器能够区分重名的函数，那你就可以重载它们。如果没有办法区分就会导致编译错误。

> [!info] 相关内容
> 运算符也可以以类似的方式重载。我们将在 [[Chapter 21 - Operator Overloading#21.1 Introduction to operator overloading|21.1 - 运算符重载简介]] 中讨论运算符重载。

## 重载决议简介
上面我们简要介绍了如何编写（定义）重载函数，下面我们再来看看如何调用重载函数。换句话说，编译器的**重载决议**(Overload Resolution)。

请看下面这个程序：

``` cpp
#include <iostream>

int add(int x, int y)
{
    return x + y;
}

double add(double x, double y)
{
    return x + y;
}

int main()
{
    std::cout << add(1, 2); // calls add(int, int)
    std::cout << '\n';
    std::cout << add(1.2, 3.4); // calls add(double, double)

    return 0;
}
```

编译然后运行的结果是：

``` plaintext
3
4.6
```

当我们在调用的时候提供整数参数，比如`add(1, 2)`，编译器能够判断出我们是在调用`add(int, int)`。当我们在调用的时候提供浮点数参数，比如`add(1.2, 3.4)`，编译器能够判断出我们是在调用`add(double, double)`。

## 让程序通过编译

要让一个使用重载函数的程序通过编译，必须要满足下面这两个条件：
- 每个重载函数都必须能够与其他函数区分开来。我们将在第 [[Chapter 11 - Function Overloading and Function Templates#11.2 Function overload differentiation|11.2 课 - 函数重载区分]] 中讨论如何区分函数。

- 每次对重载函数的调用都必须能够被解析为重载函数。我们将在第 [[Chapter 11 - Function Overloading and Function Templates#11.3 Function overload resolution and ambiguous matches|11.3 课 - 函数重载解析和不明确匹配]] 中讨论编译器如何将函数调用与重载函数进行匹配。

如果没有办法区分重载函数，或者对重载函数的函数调用无法解析为重载函数，就会编译错误。

在下一课中，我们将探讨如何区分重载函数。然后，在下面的课程中，我们将探讨编译器如何将函数调用解析为重载函数。

## 结论
函数重载提供了一种很好的方法，可以通过减少需要记住的函数名称的数量来降低程序的复杂性。它可以而且应该被自由使用。

> [!tip] 最佳实践
> 使用函数重载可简化程序。

# 11.2 Function overload differentiation
# 11.3 Function overload resolution and ambiguous matches
# 11.4 Deleting functions
# 11.5 Default arguments
# 11.6 Function templates
# 11.7 Function template instantiation
# 11.8 Using function templates in multiple files
# 11.9 Function templates with multiple template types
# 11.10 Non-type template parameters
# 11.x Chapter 11 summary and quiz