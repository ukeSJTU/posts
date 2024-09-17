# 8.1 Control flow introduction

# 8.2 If statements and blocks
# 8.3 Common if statement problems
# 8.4 Constexpr if statements
# 8.5 Switch statement basics
# 8.6 Switch fallthrough and scoping
# 8.7 Goto statements
# 8.8 循环和`while`语句简介
TODO 本文都需要重新确定翻译
## 循环简介
现在真正的乐趣开始了 —— 在接下来的一系列课程中,我们将学习循环。循环是一种控制流结构,允许一段代码重复执行,直到满足某个条件为止。循环为您的编程工具箱增添了很大的灵活性,让您能够做许多原本困难的事情。

例如,假设您想打印1到10之间的所有数字。如果不使用循环,您可能会尝试这样做:

```cpp
#include <iostream>

int main()
{
    std::cout << "1 2 3 4 5 6 7 8 9 10";
    std::cout << " done!\n";
    return 0;
}
```

虽然这是可行的,但当您想打印更多数字时,这种方法就变得越来越不实际:如果您想打印1到1000之间的所有数字呢?那将需要大量的输入!但是这种程序之所以可以这样编写,是因为我们在编译时就知道要打印多少个数字。

现在,让我们稍微改变一下参数。如果我们想让用户输入一个数字,然后打印1到用户输入的数字之间的所有数字呢?用户将会输入的数字在编译时是未知的。那么我们该如何解决这个问题呢?
## `while`语句
`while`语句(也称为`while`循环)是C++提供的三种循环类型中最简单的一种,它的定义与if语句非常相似:

```cpp
while (条件)
    语句;
```

`while`语句使用`while`关键字声明。当执行`while`语句时,会评估表达式条件。如果条件评估为`true`,则执行相关的语句。

然而,与`if`语句不同的是,一旦语句执行完毕,控制权就会返回到while语句的顶部,并重复这个过程。这意味着while语句会持续循环,只要条件继续评估为true。

让我们看一个简单的while循环,它打印1到10之间的所有数字:

```cpp
#include <iostream>

int main()
{
    int count{ 1 };
    while (count <= 10)
    {
        std::cout << count << ' ';
        ++count;
    }

    std::cout << "done!\n";

    return 0;
}
```

这段代码输出:

```
1 2 3 4 5 6 7 8 9 10 done!
```

让我们仔细看看这个程序在做什么。

首先,我们定义了一个名为count的变量并将其设置为1。条件count <= 10为true,所以执行语句。在这个例子中,我们的语句是一个代码块,所以块中的所有语句都会执行。代码块中的第一个语句打印1和一个空格,第二个语句将count增加到2。控制权现在回到while语句的顶部,再次评估条件。2 <= 10评估为true,所以再次执行代码块。循环将重复执行,直到count为11,此时11 <= 10将评估为false,与循环相关的语句将被跳过。此时,循环结束。

虽然这个程序比直接输入1到10之间的所有数字要多写一些代码,但考虑一下如果要修改程序以打印1到1000之间的所有数字会有多容易:你只需要将count <= 10改为count <= 1000即可。

初始评估为false的while语句

请注意,如果条件最初评估为false,相关的语句将根本不会执行。考虑以下程序:

```cpp
#include <iostream>

int main()
{
    int count{ 15 };
    while (count <= 10)
    {
        std::cout << count << ' ';
        ++count;
    }

    std::cout << "done!\n";

    return 0;
}
```

条件15 <= 10评估为false,所以相关的语句被跳过。程序继续执行,只打印出done!。

无限循环

另一方面,如果表达式总是评估为true,while循环将永远执行。这被称为无限循环。以下是一个无限循环的例子:

```cpp
#include <iostream>

int main()
{
    int count{ 1 };
    while (count <= 10) // 这个条件永远不会为false
    {
        std::cout << count << ' '; // 所以这行代码会重复执行
    }

    std::cout << '\n'; // 这行代码永远不会执行

    return 0; // 这行代码永远不会执行
}
```

因为在这个程序中count从未增加,所以count <= 10将始终为true。因此,循环永远不会终止,程序将永远打印1 1 1 1 1...。

有意的无限循环

我们可以这样声明一个有意的无限循环:

```cpp
while (true)
{
  // 这个循环将永远执行
}
```

退出无限循环的唯一方法是通过return语句、break语句、exit语句、goto语句、抛出异常,或者用户终止程序。

这里有一个愚蠢的例子来演示这一点:

```cpp
#include <iostream>

int main()
{

    while (true) // 无限循环
    {
        std::cout << "Loop again (y/n)? ";
        char c{};
        std::cin >> c;

        if (c == 'n')
            return 0;
    }

    return 0;
}
```

这个程序将持续循环,直到用户输入n作为输入,此时if语句将评估为true,相关的return 0;将导致main()函数退出,终止程序。

在持续运行并处理网络请求的Web服务器应用程序中,经常可以看到这种循环。

最佳实践

对于有意的无限循环,优先使用while(true)。

循环变量和命名

循环变量是用于控制循环执行次数的变量。例如,给定while (count <= 10),count就是一个循环变量。虽然大多数循环变量的类型为int,但偶尔也会看到其他类型(例如char)。

循环变量通常被赋予简单的名称,其中i、j和k是最常见的。

顺便说一下...

使用i、j和k作为循环变量名称的做法源于Fortran编程语言,因为这些是Fortran中最短的整型变量名。这个惯例一直延续至今。

然而,如果你想知道程序中循环变量在哪里使用,并且你在i、j或k上使用搜索功能,搜索功能会返回你程序中的一半行!出于这个原因,一些开发人员更喜欢使用iii、jjj或kkk这样的循环变量名称。因为这些名称更加独特,这使得搜索循环变量变得更容易,并有助于它们作为循环变量脱颖而出。更好的做法是使用"真实"的变量名,如count、index,或给出更多关于你在计数什么的细节(例如userCount)。

最常见的循环变量类型称为计数器,它是一个计算循环执行次数的循环变量。在上面的例子中,变量count就是一个计数器。

整型循环变量应该是有符号的

整型循环变量几乎总是应该是有符号的,因为无符号整数可能会导致意想不到的问题。考虑以下代码:

```cpp
#include <iostream>

int main()
{
    unsigned int count{ 10 }; // 注意: 无符号

    // 从10倒数到0
    while (count >= 0)
    {
        if (count == 0)
        {
            std::cout << "blastoff!";
        }
        else
        {
            std::cout << count << ' ';
        }
        --count;
    }

    std::cout << '\n';

    return 0;
}
```

看看上面的例子,看你能不能发现错误。如果你以前没有见过这种情况,错误并不是很明显。

事实证明,这个程序是一个无限循环。它开始按照预期打印10 9 8 7 6 5 4 3 2 1 blastoff!,但然后循环变量count溢出,开始从4294967295开始倒数(假设是32位整数)。为什么?因为循环条件count >= 0永远不会为false!当count为0时,0 >= 0为true。然后执行--count,count回绕到4294967295。由于4294967295 >= 0为true,程序继续执行。因为count是无符号的,它永远不能为负,而且因为它永远不能为负,所以循环不会终止。

最佳实践

整型循环变量通常应该是有符号的整型类型。

每N次迭代做某事

每次循环执行时,称为一次迭代。

通常,我们想每2次、3次或4次迭代做某事,比如打印一个新行。这可以通过对我们的计数器使用余数运算符轻松实现:

```cpp
#include <iostream>

// 遍历1到50之间的每个数字
int main()
{
    int count{ 1 };
    while (count <= 50)
    {
        // 打印数字(为了格式化目的,对10以下的数字在前面填充一个前导0)
        if (count < 10)
        {
            std::cout << '0';
        }

        std::cout << count << ' ';

        // 如果循环变量能被10整除,打印一个新行
        if (count % 10 == 0)
        {
            std::cout << '\n';
        }

        // 增加循环计数器
        ++count;
    }

    return 0;
}
```

这个程序产生以下结果:

```
01 02 03 04 05 06 07 08 09 10
11 12 13 14 15 16 17 18 19 20
21 22 23 24 25 26 27 28 29 30
31 32 33 34 35 36 37 38 39 40
41 42 43 44 45 46 47 48 49 50
```

嵌套循环

也可以在其他循环内部嵌套循环。嵌套循环对新程序员来说往往有点令人困惑,所以让我们从一个稍微简单一点的例子开始:

```cpp
#include <iostream>

void printUpto(int outer)
{
    // 循环1到outer之间的数
    // 注意: inner将在块结束时被创建和销毁
    int inner{ 1 };
    while (inner <= outer)
    {
        std::cout << inner << ' ';
        ++inner;
    }
} // inner在这里被销毁

int main()
{
    // outer在1到5之间循环
    int outer{ 1 };
    while (outer <= 5)
    {
        // 对于外层循环的每次迭代,循环体中的代码执行一次

        // 这个函数打印1到outer之间的数字
        printUpto(outer);

        // 在每行结束时打印一个新行
        std::cout << '\n';
        ++outer;
    }

    return 0;
}
```

在这个例子中,我们有一个外层循环,其计数器名为outer,从1计数到5。对于每次循环迭代,循环体调用printUpto()函数,使用外层循环变量作为参数,打印一个新行,然后增加outer。printUpto()函数也有一个循环,打印1到传入值之间的所有数字。

因此,当outer为1时,循环体调用printUpto(1),打印数字1。然后循环体打印一个新行并增加outer。现在outer为2。循环体再次执行,调用printUpto(2),打印1 2。循环体打印另一个新行并增加outer。后续迭代调用printUpto(3)、printUpto(4)和printUpto(5)。

因此,这个程序打印:

```
1
1 2
1 2 3
1 2 3 4
1 2 3 4 5
```

注意,这是嵌套循环的一种形式 —— 在外层循环的主体中,我们调用了一个自身包含循环的函数。换句话说,对于外层循环的每次迭代,函数中的循环都会执行。

现在让我们来看一个更复杂的例子:

```cpp
#include <iostream>

int main()
{
    // outer在1到5之间循环
    int outer{ 1 };
    while (outer <= 5)
    {
        // 对于外层循环的每次迭代,循环体中的代码执行一次

        // inner在1到outer之间循环
        // 注意: inner将在块结束时被创建和销毁
        int inner{ 1 };
        while (inner <= outer)
        {
            std::cout << inner << ' ';
            ++inner;
        }

        // 在每行结束时打印一个新行
        std::cout << '\n';
        ++outer;
    } // inner在这里被销毁

    return 0;
}
```

这个程序有完全相同的输出:

```
1
1 2
1 2 3
1 2 3 4
1 2 3 4 5
```

因为我们有一个while循环直接嵌套在另一个while循环内,这看起来有点更复杂。然而,我们所做的只是将原本在printUpto()函数内的代码直接放在外层循环体内。

让我们更详细地检查一下这是如何工作的。

首先,我们有一个外层循环(循环变量为outer),它将循环5次(outer依次取值1、2、3、4和5)。

在外层循环的第一次迭代中,outer的值为1,然后执行外层循环体。在外层循环体内,我们有另一个循环,循环变量为inner。内层循环从1迭代到outer(此时值为1),所以这个内层循环将执行一次,打印值1。然后我们打印一个新行,并将outer增加到2。

在外层循环的第二次迭代中,outer的值为2,然后执行外层循环体。在外层循环体内,inner再次从1迭代到outer(现在值为2),所以这个内层循环将执行两次,打印值1和2。然后我们打印一个新行,并将outer增加到3。

这个过程继续,内层循环在后续的通过中依次打印1 2 3、1 2 3 4和1 2 3 4 5。最终,outer增加到6,因为外层循环条件(outer <= 5)此时为false,外层循环结束。然后程序结束。

如果你仍然觉得这很confusing,在调试器中逐行步进这个程序,观察inner和outer的值是很好的理解方式。

测验时间

问题 #1

在上面的程序中,为什么变量inner声明在while块内,而不是紧随outer的声明之后?

显示答案

变量inner声明在while块内,这样每次外层循环执行时,它都会被重新创建(并重新初始化为1)。如果变量inner在外层while循环之前声明,它的值将永远不会被重置为1,或者我们必须用赋值语句来重置它。此外,因为变量inner只在外层while循环块内使用,所以在那里声明它是有意义的。记住,在尽可能小的作用域内声明你的变量!

问题 #2

编写一个程序,打印出字母a到z以及它们的ASCII码。使用char类型的循环变量。

Hint: To print characters as integers, you have to use a static_cast.

显示答案

```cpp
#include <iostream>

int main()
{
    char myChar{ 'a' };
    while (myChar <= 'z')
    {
        std::cout << myChar << ' ' << static_cast<int>(myChar) << '\n';
        ++myChar;
    }

    return 0;
}
```

问题 #3

反转嵌套循环示例,使其打印以下内容:

```
5 4 3 2 1
4 3 2 1
3 2 1
2 1
1
```

显示答案

```cpp
#include <iostream>

// 在5和1之间循环
int main()
{
	int outer{ 5 };
	while (outer >= 1)
	{
		// 在outer和1之间循环
		int inner{ outer };
		while (inner >= 1)
        {
			std::cout << inner-- << ' ';
        }

		// 在每行结束时打印一个新行
		std::cout << '\n';
		--outer;
	}

	return 0;
}
```

问题 #4

现在让数字像这样打印:

```
        1
      2 1
    3 2 1
  4 3 2 1
5 4 3 2 1
```

提示:首先想办法让它这样打印:

```
X X X X 1
X X X 2 1
X X 3 2 1
X 4 3 2 1
5 4 3 2 1
```

显示答案

```cpp
// 感谢Shiva提供这个解决方案
#include <iostream>

int main()
{
	// 有5行,我们可以从1循环到5
	int outer{ 1 };

	while (outer <= 5)
	{
		// 行元素以降序出现,所以从5开始循环到1
		int inner{ 5 };

		while (inner >= 1)
		{
			// 任何行中的第一个数字与行号相同
			// 所以只有当数字 <= 行号时才应该打印数字,否则打印空格
			if (inner <= outer)
				std::cout << inner << ' '; // 打印数字和一个空格
			else
				std::cout << "  "; // 不打印数字,但打印两个空格

			--inner;
		}

		// 一行已经打印完成,移动到下一行
		std::cout << '\n';

		++outer;
	}

	return 0;
}
```

# 8.9 Do while statements
# 8.10 For语句 
TODO 翻译需要修改
到目前为止，C++中最常用的循环语句是for语句。当我们有一个明显的循环变量时，for语句（也称为for循环）是首选，因为它让我们能够轻松简洁地定义、初始化、测试和改变循环变量的值。

从C++11开始，有两种不同类型的for循环。我们将在本课中介绍经典的for语句，而较新的基于范围的for语句将在未来的课程（16.8 -- 基于范围的for循环（for-each)）中介绍，届时我们将已经涵盖了其他一些先决条件主题。

for语句在抽象上看起来相当简单：

```cpp
for (init-statement; condition; end-expression)
   statement;
```

最初理解for语句工作原理的最简单方法是将其转换为等效的while语句：

```cpp
{ // 注意这里的代码块
    init-statement; // 用于定义循环中使用的变量
    while (condition)
    {
        statement; 
        end-expression; // 用于在重新评估条件之前修改循环变量
    }
} // 在循环内定义的变量在这里超出作用域
```

## for语句的评估

for语句的评估分为3个部分：

1. 首先，执行`init-statement`。这只在循环开始时发生一次。`init-statement`通常用于变量定义和初始化。这些变量具有"循环作用域"，实际上只是一种块作用域，其中这些变量从定义点存在到循环语句结束。在我们的while循环等效中，你可以看到`init-statement`位于包含循环的代码块内，所以在`init-statement`中定义的变量在包含循环的代码块结束时超出作用域。

2. 其次，在每次循环迭代中，都会评估`condition`。如果评估结果为true，则执行`statement`。如果评估结果为false，则循环终止，执行继续进行到循环之后的下一个语句。

3. 最后，在执行`statement`之后，评估`end-expression`。通常，这个表达式用于增加或减少在`init-statement`中定义的循环变量。在评估了`end-expression`之后，执行返回到第二步（并再次评估`condition`）。

> **提示**
>
> for循环的`end-expression`在循环语句之后执行。

让我们看一个for循环的示例并讨论它是如何工作的：

```cpp
#include <iostream>

int main()
{
    for (int i{ 1 }; i <= 10; ++i)
        std::cout << i << ' ';

    std::cout << '\n';

    return 0;
}
```

首先，我们声明一个名为`i`的循环变量，并用值1初始化它。

其次，评估`i <= 10`，由于`i`是1，所以这个评估结果为true。因此，执行`statement`，打印1和一个空格。

最后，评估`++i`，将`i`增加到2。然后循环回到第二步。

现在，再次评估`i <= 10`。由于`i`的值为2，这个评估结果为true，所以循环再次迭代。`statement`打印2和一个空格，`i`增加到3。循环继续迭代，直到最终`i`增加到11，此时`i <= 10`评估为false，循环退出。

因此，这个程序打印的结果是：

```
1 2 3 4 5 6 7 8 9 10
```

为了举例说明，让我们将上面的for循环转换为等效的while循环：

```cpp
#include <iostream>

int main()
{
    { // 这里的代码块确保i具有块作用域
        int i{ 1 }; // 我们的init-statement
        while (i <= 10) // 我们的condition
        {
            std::cout << i << ' '; // 我们的statement
            ++i; // 我们的end-expression
        }
    }

    std::cout << '\n';
}
```

看起来不那么糟糕，对吧？请注意，这里外部的大括号是必要的，因为当循环结束时`i`超出了作用域。

for循环对于新程序员来说可能难以阅读 -- 然而，有经验的程序员喜欢它们，因为它们是一种非常紧凑的方式来执行带有计数器的循环，所有关于循环变量、循环条件和循环变量修改器的必要信息都在前面呈现。这有助于减少错误。

## 更多for循环示例

这里是一个使用for循环计算整数幂的函数示例：

```cpp
#include <cstdint> // 用于固定宽度整数

// 返回 base ^ exponent 的值 -- 注意溢出！
std::int64_t pow(int base, int exponent)
{
    std::int64_t total{ 1 };

    for (int i{ 0 }; i < exponent; ++i)
        total *= base;

    return total;
}
```

这个函数返回`base^exponent`（底数的指数次幂）的值。

这是一个简单的递增for循环，`i`从0循环到（但不包括）`exponent`。

- 如果`exponent`为0，for循环将执行0次，函数将返回1。
- 如果`exponent`为1，for循环将执行1次，函数将返回1 * base。
- 如果`exponent`为2，for循环将执行2次，函数将返回1 * base * base。

虽然大多数for循环将循环变量递增1，但我们也可以递减它：

```cpp
#include <iostream>

int main()
{
    for (int i{ 9 }; i >= 0; --i)
        std::cout << i << ' ';

    std::cout << '\n';

    return 0;
}
```

这将打印结果：

```
9 8 7 6 5 4 3 2 1 0
```

另外，我们可以在每次迭代中将循环变量的值改变超过1：

```cpp
#include <iostream>

int main()
{
    for (int i{ 0 }; i <= 10; i += 2) // 每次迭代增加2
        std::cout << i << ' ';

    std::cout << '\n';

    return 0;
}
```

这将打印结果：

```
0 2 4 6 8 10
```

## for循环条件中使用!=运算符的危险

在编写涉及值的循环条件时，我们通常可以用多种不同的方式来编写条件。以下两个循环的执行是相同的：

```cpp
#include <iostream>

int main()
{
    for (int i { 0 }; i < 10; ++i) // 使用 <
         std::cout << i;

    for (int i { 0 }; i != 10; ++i) // 使用 !=
         std::cout << i;

     return 0;
}
```

那么我们应该选择哪一个呢？前者是更好的选择，因为即使`i`跳过了值10，它仍会终止，而后者则不会。以下示例演示了这一点：

```cpp
#include <iostream>

int main()
{
    for (int i { 0 }; i < 10; ++i) // 使用 <，仍然会终止
    {
         std::cout << i;
         if (i == 9) ++i; // 跳过值10
    }

    for (int i { 0 }; i != 10; ++i) // 使用 !=，无限循环
    {
         std::cout << i;
         if (i == 9) ++i; // 跳过值10
    }

     return 0;
}
```

> **最佳实践**
>
> 在for循环条件中进行数值比较时，避免使用`!=`运算符。尽可能使用`<`或`<=`运算符。

## 差一错误

新程序员在使用for循环（以及其他使用计数器的循环）时遇到的最大问题之一是差一错误。差一错误发生在循环迭代次数比预期多一次或少一次时。

这里是一个例子：

```cpp
#include <iostream>

int main()
{
    // 糟糕，我们使用了运算符<而不是运算符<=
    for (int i{ 1 }; i < 5; ++i)
    {
        std::cout << i << ' ';
    }

    std::cout << '\n';

    return 0;
}
```

这个程序本应打印`1 2 3 4 5`，但它只打印了`1 2 3 4`，因为我们使用了错误的关系运算符。

虽然这些错误最常见的原因是使用了错误的关系运算符，但有时它们也可能由使用前增量或前减量而不是后增量或后减量（或反之亦然）引起。

## 省略表达式

可以编写省略任何或所有语句或表达式的for循环。例如，在以下示例中，我们将省略`init-statement`和`end-expression`，只留下`condition`：

```cpp
#include <iostream>

int main()
{
    int i{ 0 };
    for ( ; i < 10; ) // 没有init-statement或end-expression
    {
        std::cout << i << ' ';
        ++i;
    }

    std::cout << '\n';

    return 0;
}
```

这个for循环产生的结果是：

```
0 1 2 3 4 5 6 7 8 9
```

我们没有让for循环进行初始化和增量操作，而是手动完成了这些操作。在这个例子中，我们这样做纯粹是出于学术目的，但在某些情况下，不定义循环变量（因为你已经有一个）或不在`end-expression`中增加它（因为你以其他方式增加它）是需要的。

虽然你不经常看到，但值得注意的是，以下示例会产生一个无限循环：

```cpp
for (;;)
    statement;
```

上面的示例等同于：

```cpp
while (true)
    statement;
```

这可能有点出乎意料，因为你可能会期望省略的`condition-expression`被视为false。然而，C++标准明确（且不一致地）定义，for循环中省略的`condition-expression`应被视为true。

我们建议完全避免这种形式的for循环，而使用`while (true)`。

## 具有多个计数器的for循环

尽管for循环通常只迭代一个变量，但有时for循环需要处理多个变量。为了帮助实现这一点，程序员可以在`init-statement`中定义多个变量，并可以使用逗号运算符在`end-expression`中更改多个变量的值：

```cpp
#include <iostream>

int main()
{
    for (int x{ 0 }, y{ 9 }; x < 10; ++x, --y)
        std::cout << x << ' ' << y << '\n';

    return 0;
}
```

这个循环定义并初始化了两个新变量：`x`和`y`。它将`x`迭代over范围0到9，每次迭代后`x`增加，`y`减少。

这个程序产生的结果是：

```
0 9
1 8
2 7
3 6
4 5
5 4
6 3
7 2
8 1
9 0
```

这大概是C++中唯一一个在同一语句中定义多个变量，以及使用逗号运算符被认为是可接受做法的地方。

**相关内容**

我们在6.5课 -- 逗号运算符中介绍了逗号运算符。

> **最佳实践**
>
> 在for语句内定义多个变量（在`init-statement`中）和使用逗号运算符（在`end-expression`中）是可以接受的。

## 嵌套for循环

像其他类型的循环一样，for循环可以嵌套在其他循环内。在以下示例中，我们将一个for循环嵌套在另一个for循环内：

```cpp
#include <iostream>

int main()
{
	for (char c{ 'a' }; c <= 'e'; ++c) // 外部循环处理字母
	{
		std::cout << c; // 先打印我们的字母

		for (int i{ 0 }; i < 3; ++i) // 内部循环处理所有数字
			std::cout << i;

		std::cout << '\n';
	}

	return 0;
}
```

对于外部循环的每次迭代，内部循环都会完整运行。因此，输出是：

```
a012
b012
c012
d012
e012
```

这里是更多关于这里发生的详细信息。外部循环首先运行，`char c`被初始化为'a'。然后评估`c <= 'e'`，这是true，所以循环体执行。由于`c`设置为'a'，这首先打印a。接下来，内部循环完全执行（打印0、1和2）。然后打印一个换行。现在外部循环体完成，所以外部循环返回到顶部，`c`增加到'b'，重新评估循环条件。由于循环条件仍然为true，外部循环的下一次迭代开始。这打印b012\n。依此类推。

## 仅在循环内使用的变量应该在循环内定义

新程序员经常认为创建变量是昂贵的，所以最好创建一次变量（然后给它赋值）而不是多次创建（并使用初始化）。这导致了看起来像以下变体的循环：

```cpp
#include <iostream>

int main()
{
    int i {}; // i在循环外定义
    for (i = 0; i < 10; ++i) // i被赋值
    {
        std::cout << i << ' ';
    }

    // i在这里仍然可以访问

    std::cout << '\n';

    return 0;
}
```

然而，创建一个变量是没有成本的 -- 是初始化有成本，并且初始化和赋值之间通常没有成本差异。上面的例子使`i`在循环之外仍然可用。除非需要在循环之外使用变量，否则在循环外定义变量可能会产生两个后果：

1. 它使我们的程序更复杂，因为我们必须阅读更多代码来看到变量在哪里使用。
2. 它可能实际上更慢，因为编译器可能无法像优化作用域较小的变量那样有效地优化作用域较大的变量。

与我们在可能的最小合理作用域内定义变量的最佳实践一致，只在循环内使用的变量应该在循环内定义，而不是在循环外定义。

> **最佳实践**
>
> 只在循环内使用的变量应该在循环的作用域内定义。

## 结论

for语句是C++语言中最常用的循环。尽管它的语法对新程序员来说通常有点令人困惑，但你会经常看到for循环，以至于很快就会理解它们！

当你有一个计数器变量时，for语句表现出色。如果没有计数器，while语句可能是更好的选择。

> **最佳实践**
>
> - 当有明显的循环变量时，优先选择for循环而不是while循环。
> - 当没有明显的循环变量时，优先选择while循环而不是for循环。

## 测试时间

**问题#1**

编写一个for循环，打印从0到20的每个偶数。

**问题#2**

编写一个名为`sumTo()`的函数，该函数接受一个名为`value`的整数参数，并返回从1到`value`的所有数字的和。

例如，`sumTo(5)`应返回15，即1 + 2 + 3 + 4 + 5。

提示：使用一个非循环变量来累加和，就像上面的`pow()`示例使用`total`变量来累加每次迭代的返回值一样。

**问题#3**

下面的for循环有什么问题？

```cpp
// 打印从9到0的所有数字
for (unsigned int i{ 9 }; i >= 0; --i)
    std::cout << i<< ' ';
```

**问题#4**

Fizz Buzz是一个简单的数学游戏，用于教孩子们关于可除性的知识。它有时也被用作面试问题来评估基本的编程技能。

游戏规则很简单：从1开始向上计数，将任何只能被3整除的数字替换为"fizz"，将任何只能被5整除的数字替换为"buzz"，将任何既能被3又能被5整除的数字替换为"fizzbuzz"。

在一个名为`fizzbuzz()`的函数中实现这个游戏，该函数接受一个参数来确定计数到多少。使用for循环和一个单一的if-else链（意味着你可以使用任意多个else-if）。

`fizzbuzz(15)`的输出应该与以下内容匹配：

```
1
2
fizz
4
buzz
fizz
7
8
fizz
buzz
11
fizz
13
14
fizzbuzz
```

**问题#5**

修改你在上一个测验中编写的FizzBuzz程序，添加规则：能被7整除的数字应该被替换为"pop"。运行程序150次迭代。

在这个版本中，使用if/else链来明确涵盖每种可能的单词组合将导致函数过长。优化你的函数，使其只使用4个if语句：一个用于每个非复合单词（"fizz"、"buzz"、"pop"），一个用于打印数字的情况。

以下是预期输出的一些片段：

```
4
buzz
fizz
pop
8
19
buzz
fizzpop
22
104
fizzbuzzpop
106
```

# 8.11 Break and continue
# 8.12 Halts (exiting your program early)
# 8.13 Introduction to random number generation
# 8.14 Generating random numbers using Mersenne Twister
# 8.15 Global random numbers (Random.h)
# 8.x Chapter 8 summary and quiz