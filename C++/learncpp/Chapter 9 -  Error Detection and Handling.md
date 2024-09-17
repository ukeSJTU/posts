# 9.1 代码测试入门
所以,你已经写好了一个程序,它可以编译,看起来还能正常运行!接下来该怎么办?

嗯,这要看情况。如果你写的程序只需运行一次就可以丢弃,那么你就完成了。在这种情况下,你的程序可能不需要适用于所有情况 - 如果它适用于你所需要的那一种情况,而且你只打算运行一次,那么你就完成了。

如果你的程序完全是线性的(没有条件语句,如`if`语句或`switch`语句),不接受任何输入,并且产生了正确的答案,那么你可能也完成了。在这种情况下,你通过运行程序并验证输出,已经测试了整个程序。你可能想在几个不同的系统上编译和运行程序,以确保它的行为一致(如果不一致,你可能做了一些产生未定义行为的事情,只是碰巧在你最初的系统上能工作)。

但很可能你写的是一个打算多次运行的程序,它使用循环和条件逻辑,并且接受某种形式的用户输入。你可能还写了一些可能在未来其他程序中重复使用的函数。你可能经历了一些范围蔓延(scope creep),在其中添加了一些最初没有计划的新功能。也许你甚至打算将这个程序分发给其他人(他们可能会尝试你没有想到的事情)。在这种情况下,你真的应该验证你的程序在各种条件下是否如你所想的那样工作 —— 这需要一些主动测试。

仅仅因为你的程序对一组输入有效,并不意味着它在所有情况下都能正确工作。

软件测试(software testing,也称为软件验证 software validation)是确定软件是否真的按预期工作的过程。
## 测试的挑战
在我们讨论一些实际的代码测试方法之前，让我们先讨论一下为什么全面测试你的程序很困难。

考虑这个简单的程序：

```cpp
#include <iostream>

void compare(int x, int y)
{
    if (x > y)
        std::cout << x << " is greater than " << y << '\n'; // 情况 1
    else if (x < y)
        std::cout << x << " is less than " << y << '\n'; // 情况 2
    else
        std::cout << x << " is equal to " << y << '\n'; // 情况 3
}

int main()
{
    std::cout << "Enter a number: ";
    int x{};
    std::cin >> x;

    std::cout << "Enter another number: ";
    int y{};
    std::cin >> y;

    compare(x, y);

    return 0;
}
```

假设使用4字节整数,要明确测试这个程序的每一种可能的输入组合,需要运行程序18,446,744,073,709,551,616(约18千万亿)次。显然这不是一个可行的任务!

Every time we ask for user input, or have a conditional in our code, we increase the number of possible ways our program can execute by some multiplicative factor. For all but the simplest programs, explicitly testing every combination of inputs becomes impossible almost immediately. 每次我们要求用户输入,或者在代码中有条件语句,我们就会以 TODO修改翻译某种乘法因子增加程序可能执行的方式数量。对于除了最简单的程序以外的所有程序,明确测试每一种输入组合几乎立即就变得不可能。

现在,你的直觉应该告诉你,你真的不需要运行上面的程序18千万亿次来确保它能工作。你可能会合理地得出结论,如果case 1对于一对x > y的x和y值有效,那么它应该对任何x > y的x和y对都有效。考虑到这一点,显然我们只需要运行这个程序大约三次(每次执行compare()函数中的三种情况之一)就可以对它按预期工作有很高的信心。还有其他类似的技巧我们可以用来大大减少我们必须测试的次数,以使测试变得可管理。

关于测试方法可以写很多东西——事实上,我们可以写一整章。但由于这不是一个特定于C++的话题,我们将坚持简短和非正式的介绍,从你(作为开发者)测试自己的代码的角度来看。在接下来的几个小节中,我们将讨论一些你在测试代码时应该考虑的实际问题。
## 将你的程序分成小块进行测试
考虑一个正在制造定制概念车的汽车制造商。你认为他们会采取下面哪种措施?  
a) 在安装之前单独构建(或购买)并测试每个汽车部件。一旦部件被证明可以工作,就将其集成到汽车中并重新测试,以确保集成成功。最后,测试整辆车,作为一切看起来良好的最终验证。  
b) 一次性用所有部件构建一辆汽车,然后在最后第一次测试整辆车。

选项a)可能看起来显然是更好的选择。然而,许多新程序员却像选项b)那样编写代码!

在情况b)中,如果任何汽车部件不能按预期工作,机械师就必须诊断整辆车来确定问题所在 - 问题可能出在任何地方。一个症状可能有很多原因——例如,汽车不能启动是由于火花塞故障、电池、燃油泵还是其他原因?这会导致浪费大量时间来确定问题的确切位置,以及如何解决它们。如果发现问题,后果可能是灾难性的——一个区域的变化可能会在多个其他地方造成"涟漪效应"(变化)。例如,一个太小的燃油泵可能导致发动机重新设计,从而导致汽车框架重新设计。在最坏的情况下,你可能最终会重新设计汽车的大部分,只是为了适应最初的一个小问题!

在情况a)中,公司边做边测试。如果任何部件一开始就有问题,他们会立即知道并可以修复/更换它。在被证明单独工作之前,没有任何东西会被集成到汽车中,然后一旦被集成到汽车中,该部件就会再次被重新测试。这样,任何意外问题都会在尽可能早的阶段，当它们仍然是可以轻松修复的小问题时，被发现。

当他们组装完整辆车时,他们应该对汽车能正常工作有合理的信心——毕竟,所有部件都已经在隔离状态下和初步集成时进行了测试。在这个阶段仍然可能发现意外问题,但由于之前的所有测试,这种风险已经被最小化了。

上述类比对程序也适用,尽管出于某种原因,新程序员经常没有意识到这一点。你最好写小的函数(或类),然后立即编译和测试它们。这样,如果你犯了错误,你就会知道错误一定在你上次编译/测试以来改变的那小部分代码中。这意味着需要查看的地方更少,花在调试上的时间也大大减少。

隔离测试代码的一小部分以确保该"单元"的代码是正确的,这被称为单元测试(unit testing)。每个单元测试都旨在确保该单元的特定行为是正确的。

>  最佳实践
>  
>  将你的程序编写成小的、定义良好的单元（函数或类），经常编译，并且边做边测试你的代码。

如果程序很短并且接受用户输入，那么尝试各种用户输入可能就足够了。但是随着程序越来越长，这就不够了，在将各个函数或类集成到程序的其余部分之前对其进行测试变得更有价值。

那么我们如何才能对代码进行单元测试呢？
## 非正式测试
测试代码的一种方法是在编写程序时进行非正式测试。在编写了一个代码单元（一个函数、一个类或其他一些离散的代码“包”）之后，你可以编写一些代码来测试刚刚添加的单元，然后在测试通过后删除测试代码。例如，对于下面的 isLowerVowel() 函数，你可以编写以下代码：

```cpp
#include <iostream>

// 我们要测试以下函数
// 为简单起见，我们将忽略“y”有时被算作元音的情况
bool isLowerVowel(char c)
{
    switch (c)
    {
    case 'a':
    case 'e':
    case 'i':
    case 'o':
    case 'u':
        return true;
    default:
        return false;
    }
}

int main()
{
    // 所以这里是我们用来验证它是否有效的临时测试
    std::cout << isLowerVowel('a') << '\n'; // 临时测试代码，应该产生 1
    std::cout << isLowerVowel('q') << '\n'; // 临时测试代码，应该产生 0

    return 0;
}
```

如果结果返回 1 和 0，那么你就成功了。你知道你的函数在一些基本情况下是有效的，并且你可以通过查看代码合理地推断出它在你没有测试的情况下（'e'、'i'、'o' 和 'u'）也是有效的。所以你可以删除那些临时测试代码，然后继续编程。
## 保留你的测试
尽管编写临时测试是一种快速简便的代码测试方法，但它没有考虑到这样一个事实：在某个时候，你可能想稍后再测试相同的代码。也许你修改了一个函数以添加一个新功能，并且想确保你没有破坏任何已经可以工作的东西。因此，保留你的测试以便将来可以再次运行它们可能更有意义。例如，你可以将测试移动到 `testVowel()` 函数中，而不是删除临时测试代码：

```cpp
#include <iostream>

bool isLowerVowel(char c)
{
    switch (c)
    {
    case 'a':
    case 'e':
    case 'i':
    case 'o':
    case 'u':
        return true;
    default:
        return false;
    }
}

// 现在还没有从任何地方调用
// 但是如果你想稍后再测试，它就在这里
void testVowel()
{
    std::cout << isLowerVowel('a') << '\n'; // 临时测试代码，应该产生 1
    std::cout << isLowerVowel('q') << '\n'; // 临时测试代码，应该产生 0
}

int main()
{
    return 0;
}
```

当你创建更多测试时，你可以简单地将它们添加到 `testVowel()` 函数中。
## 自动化你的测试函数
上述测试函数的一个问题是,它依赖于你在运行时手动验证结果。这要求你在最坏的情况下记住预期的答案(假设你没有记录它),并手动将实际结果与预期结果进行比较。

我们可以通过编写一个测试函数来做得更好,该函数同时包含测试和预期答案,并进行比较,这样我们就不必手动比较了。

```cpp
#include <iostream>

bool isLowerVowel(char c)
{
    switch (c)
    {
    case 'a':
    case 'e':
    case 'i':
    case 'o':
    case 'u':
        return true;
    default:
        return false;
    }
}

// 返回失败的测试编号，如果所有测试都通过，则返回 0
int testVowel()
{
    if (!isLowerVowel('a')) return 1;
    if (isLowerVowel('q')) return 2;

    return 0;
}

int main()
{
    int result { testVowel() };
    if (result != 0)
        std::cout << "testVowel() 测试 " << result << " 失败.\n";
    else
        std::cout << "testVowel() 测试通过.\n";

    return 0;
}
```

现在，你可以随时调用 testVowel() 来重新证明你没有破坏任何东西，测试例程会为你完成所有工作，返回一个“一切正常”信号（返回值 0），或者返回没有通过的测试编号，这样你就可以调查它为什么失败了。这在回过头来修改旧代码时特别有用，可以确保你没有意外破坏任何东西！

> 对于高级读者
> 
> 一个更好的方法是使用 `assert`，如果任何测试失败，它将导致程序中止并显示错误信息。这样我们就不必创建和处理测试用例编号了。

```cpp
#include <cassert> // 用于 assert
#include <cstdlib> // 用于 std::abort
#include <iostream>

bool isLowerVowel(char c)
{
    switch (c)
    {
    case 'a':
    case 'e':
    case 'i':
    case 'o':
    case 'u':
        return true;
    default:
        return false;
    }
}

// 程序将在任何测试用例失败时停止
int testVowel()
{
#ifdef NDEBUG
    // 如果定义了 NDEBUG，则断言会被编译掉。
    // 由于此函数要求不断言被编译掉，因此如果在定义了 NDEBUG 时调用此函数，我们将终止程序。
    std::cerr << "在定义了 NDEBUG（断言被编译掉）的情况下运行测试";
    std::abort();
#endif

    assert(isLowerVowel('a'));
    assert(isLowerVowel('e'));
    assert(isLowerVowel('i'));
    assert(isLowerVowel('o'));
    assert(isLowerVowel('u'));
    assert(!isLowerVowel('b'));
    assert(!isLowerVowel('q'));
    assert(!isLowerVowel('y'));
    assert(!isLowerVowel('z'));

    return 0;
}

int main()
{
    testVowel();

    // 如果我们到达这里，则所有测试都必须通过
    std::cout << "所有测试都成功\n";

    return 0;
}
```

We cover `assert` in lesson [9.6 -- Assert and static_assert](https://www.learncpp.com/cpp-tutorial/assert-and-static_assert/). 我们将在第 9.6 课——断言和 `static_assert` 中介绍 `assert`。TODO 补充链接
## 单元测试框架
因为编写函数来测试其他函数非常普遍和有用，所以有整个框架（称为单元测试框架）被设计用来帮助简化编写、维护和执行单元测试的过程。由于这些框架涉及第三方软件，我们在这里不做介绍，但你应该知道它们的存在。
## 集成测试
一旦你的每个单元都被隔离测试过，它们就可以被集成到你的程序中，并重新测试以确保它们被正确地集成。这被称为集成测试。集成测试往往更复杂——目前，运行你的程序几次并抽查集成单元的行为就足够了。
## 测验时间
### 问题 1

你应该什么时候开始测试你的代码？

一旦你写了一个非平凡 non-trivial TODO 修改翻译 的函数。
# 9.2 代码覆盖率
在上一节课[[#9.1 - 代码测试入门]]中,我们讨论了如何编写和保存简单的测试。在本课中,我们将讨论编写什么样的测试来确保代码正确性。
## 代码覆盖率
代码覆盖率这个术语用来描述在测试过程中执行了多少源代码。有许多不同的指标用于代码覆盖率。我们将在以下部分介绍一些更有用和流行的指标。
### 语句覆盖率
语句覆盖率指的是被测试程序执行的代码语句的百分比。

考虑以下函数:

``` cpp
int foo(int x, int y)
{
    int z{ y };
    if (x > y)
    {
        z = x;
    }
    return z;
}
```

调用这个函数 foo(1, 0) 将给你这个函数的完整语句覆盖率,因为函数中的每个语句都会执行。

对于我们的 `isLowerVowel()` 函数:

``` cpp
bool isLowerVowel(char c)
{
    switch (c) // 语句 1
    {
    case 'a':
    case 'e':
    case 'i':
    case 'o':
    case 'u':
        return true; // 语句 2
    default:
        return false; // 语句 3
    }
}
```

这个函数需要两次调用来测试所有语句,因为无法在同一个函数调用中同时到达语句2和语句3。

虽然争取100%的语句覆盖率是好的,但通常还不足以确保正确性。
### 分支覆盖率
分支覆盖率指的是已执行分支的百分比,每个可能的分支单独计算。if语句有两个分支——条件为真时执行的分支,以及条件为假时执行的分支(即使没有相应的else语句执行)。switch语句可以有多个分支。

``` cpp
int foo(int x, int y)
{
    int z{ y };
    if (x > y)
    {
        z = x;
    }
    return z;
}
```

之前对 `foo(1, 0)` 的调用给了我们100%的语句覆盖率,并测试了 `x > y`的用例,但这只给了我们50%的分支覆盖率。我们还需要一次调用, `foo(0, 1)`,来测试if语句不执行的用例。

``` cpp
bool isLowerVowel(char c)
{
    switch (c)
    {
    case 'a':
    case 'e':
    case 'i':
    case 'o':
    case 'u':
        return true;
    default:
        return false;
    }
}
```

在 `isLowerVowel()` 函数中,需要两次调用来给你100%的分支覆盖率:一次(比如 `isLowerVowel('a')`)来测试第一组case,另一次(比如 `isLowerVowel('q')`)来测试default case。多个导向同一主体 TODO 这里的翻译需要修改 的case不需要单独测试 —— 如果一个工作,它们都应该工作。

现在考虑以下函数:
``` cpp
void compare(int x, int y)
{
    if (x > y)
        std::cout << x << " is greater than " << y << '\n'; // 情况1
    else if (x < y)
        std::cout << x << " is less than " << y << '\n'; // 情况2
    else
        std::cout << x << " is equal to " << y << '\n'; // 情况3
}
```

这里需要3次调用来获得100%的分支覆盖率: `compare(1, 0)` 测试第一个if语句的正面用例。`compare(0, 1)` 测试第一个if语句的反面用例和第二个if语句的正面用例。`compare(0, 0)` 测试第一个和第二个if语句的反面用例并执行`else`语句。因此,我们可以说这个函数用3次调用就可以可靠地测试(这比18万亿次要好得多)。

> 最佳实践
> 
> 争取实现100%的代码分支覆盖率。

### 循环覆盖率
循环覆盖率(非正式称为0, 1, 2测试)表示如果你的代码中有循环,你应该确保它在迭代0次、1次和2次时正常工作。如果它在2次迭代的情况下正确工作,那么它应该在所有大于2次的迭代中正确工作。因此,这三个测试涵盖了所有可能性(因为循环不可能执行负数次)。

考虑：
``` cpp
#include <iostream>

void spam(int timesToPrint)
{
    for (int count{ 0 }; count < timesToPrint; ++count)
         std::cout << "Spam! ";
}
```

要正确测试这个函数中的循环,你应该调用它三次: spam(0) 测试零次迭代的情况, spam(1) 测试一次迭代的情况, spam(2) 测试两次迭代的情况。如果 spam(2) 正常工作,那么 spam(n) 应该也正常工作,其中 n > 2。

> 最佳实践
> 
> 使用0, 1, 2测试来确保你的循环在不同的迭代次数下正确工作。

## 测试不同类别的输入
在编写接受参数的函数或接受用户输入时,考虑不同类别的输入会发生什么。在这个情景中,我们使用"类别"这个术语来表示具有相似特征的一组输入。

例如,如果我写了一个函数来产生一个整数的平方根,用什么值来测试它会有意义呢?你可能会从一些正常值开始,比如4。但测试0和一个负数也是个好主意。

以下是类别测试的一些基本指导原则:

对于整数,确保你已考虑你的函数如何处理负值、零和正值。如果相关的话,你还应该检查溢出。

对于浮点数,确保你已考虑你的函数如何处理有精度问题的值(比预期略大或略小的值)。好的`double`类型测试值是`0.1`和`-0.1`(测试比预期略大的数)以及`0.6`和`-0.6`(测试比预期略小的数)。

对于字符串,确保你已考虑你的函数如何处理空字符串、字母数字字符串、有空白的字符串(前导、尾随和内部)以及全是空白的字符串。

如果你的函数接受指针,别忘了也测试`nullptr`(如果这没有意义,别担心,我们还没有讲到)。

> 最佳实践
> 
> 测试不同类别的输入值,以确保你的单元正确处理它们。

## 测验时间

问题#1

什么是分支覆盖率?

分支覆盖率是已执行分支的百分比,肯定情况和否定情况分别计算。

问题#2

以下函数需要多少次测试才能最小程度地验证它的工作?

``` cpp
bool isLowerVowel(char c, bool yIsVowel)
{
    switch (c)
    {
    case 'a':
    case 'e':
    case 'i':
    case 'o':
    case 'u':
        return true;
    case 'y':
        return yIsVowel;
    default:
        return false;
    }
}
```

4次测试。一次测试a/e/i/o/u的情况。一次测试default情况。一次测试 isLowerVowel('y', true)。一次测试 isLowerVowel('y', false)。
# 9.3 C++中常见的语义错误
在[[Chapter 3 - Debugging C++ Programs#3.1 — 语法错误和语义错误]]中，我们讨论了语法错误，这种错误发生在你编写的代码不符合C++语言语法规则时。编译器会提示你这些错误，所以它们很容易发现，通常也很容易修复。

我们还讨论了语义错误，这种错误发生在你编写的代码没有达到你预期的效果时。编译器通常不会捕捉到语义错误（尽管在某些情况下，智能编译器可能会生成警告）。

语义错误可能导致与未定义行为相同的大多数症状，比如导致程序产生错误结果、导致不稳定的行为、损坏程序数据、导致程序崩溃 — 或者可能根本不会产生任何影响。

在编写程序时，几乎不可避免地会出现语义错误。你可能会通过使用程序注意到其中的一些错误：例如，如果你正在编写一个迷宫游戏，而你的角色能够穿墙而过。测试你的程序[[#9.1 - 代码测试入门]]也可以帮助发现语义错误。

但还有一件事可以帮助你——那就是了解哪些类型的语义错误最常见，这样你就可以在这些情况下多花一些时间确保代码正确。

在本课中，我们将介绍C++中最常见的几种语义错误类型（其中大多数都与某种形式的流程控制有关）。
## 条件逻辑错误
最常见的语义错误类型之一是条件逻辑错误。当程序员错误地编码条件语句或循环条件的逻辑时，就会发生条件逻辑错误。这里有一个简单的例子：

```cpp
#include <iostream>

int main()
{
    std::cout << "Enter an integer: ";
    int x{};
    std::cin >> x;

    if (x >= 5) // 糟糕，我们使用了操作符>=而不是操作符>
        std::cout << x << " is greater than 5\n";

    return 0;
}
```

这是程序运行时展示条件逻辑错误的情况：

```
Enter an integer: 5
5 is greater than 5
```

当用户输入5时，条件表达式 `x >= 5` 评估为真，所以相关的语句被执行。

这里是另一个使用for循环的例子：

```cpp
#include <iostream>

int main()
{
    std::cout << "Enter an integer: ";
    int x{};
    std::cin >> x;

    // 糟糕，我们使用了操作符>而不是操作符<
    for (int count{ 1 }; count > x; ++count)
    {
        std::cout << count << ' ';
    }

    std::cout << '\n';

    return 0;
}
```

这个程序本应打印1到用户输入的数字之间的所有数字。但实际上它是这样的：

```
Enter an integer: 5
```

它什么也没打印。这是因为在进入for循环时，`count > x` 为假，所以循环根本不会迭代。
## 无限循环

在[[Chapter 8 - Control Flow#8.8 — 循环和`while`语句简介]]中，我们讨论了无限循环，并展示了这个例子：

```cpp
#include <iostream>

int main()
{
    int count{ 1 };
    while (count <= 10) // 这个条件永远不会为假
    {
        std::cout << count << ' '; // 所以这行将重复执行
    }

    std::cout << '\n'; // 这行永远不会执行

    return 0; // 这行永远不会执行
}
```

在这种情况下，我们忘记了增加count，所以循环条件永远不会为假，循环将继续打印：

```
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
```

... 直到用户关闭程序。

这里还有一个老师很喜欢作为测验问题的例子。下面的代码有什么问题？

```cpp
#include <iostream>

int main()
{
    for (unsigned int count{ 5 }; count >= 0; --count)
    {
        if (count == 0)
            std::cout << "blastoff! ";
        else
          std::cout << count << ' ';
    }

    std::cout << '\n';

    return 0;
}
```

这个程序应该打印 5 4 3 2 1 blastoff!，确实如此，但它并没有在那里停止。实际上，它打印：

```
5 4 3 2 1 blastoff! 4294967295 4294967294 4294967293 4294967292 4294967291
```

然后就一直递减下去。程序永远不会终止，因为当count是无符号整数时，`count >= 0` 永远不可能为假。
## 差一错误
差一错误是指循环执行次数比预期多一次或少一次的错误。这里有一个我们在[[Chapter 8 - Control Flow#8.10 — For语句]]中讨论过的例子：

```cpp
#include <iostream>

int main()
{
    for (int count{ 1 }; count < 5; ++count)
    {
        std::cout << count << ' ';
    }

    std::cout << '\n';

    return 0;
}
```

程序员原本打算让这段代码打印 `1 2 3 4 5`。然而，使用了错误的关系运算符（`<` 而不是 `<=`），所以循环比预期少执行一次，打印 `1 2 3 4`。
## 不正确的运算符优先级
从第6.7课 — 逻辑运算符中，以下程序犯了一个运算符优先级的错误：TODO missing links

```cpp
#include <iostream>

int main()
{
    int x{ 5 };
    int y{ 7 };

    if (!x > y) // 糟糕：运算符优先级问题
        std::cout << x << " is not greater than " << y << '\n';
    else
        std::cout << x << " is greater than " << y << '\n';

    return 0;
}
```

因为`逻辑NOT`的优先级高于运算符`>`，条件评估就好像它被写成了`(!x) > y`，这不是程序员的本意。

结果，这个程序打印：

```
5 is greater than 7
```

当在同一个表达式中混合使用逻辑OR和逻辑AND时也会发生这种情况（逻辑AND的优先级高于逻辑OR）。使用显式括号来避免这类错误。
## 浮点类型的精度问题
以下浮点变量没有足够的精度来存储整个数字：

```cpp
#include <iostream>

int main()
{
    float f{ 0.123456789f };
    std::cout << f << '\n';

    return 0;
}
```

由于精度不足，数字被稍微四舍五入了：

```
0.123457
```

在第6.6课 — 关系运算符和浮点比较中，我们讨论了由于小的舍入错误，使用运算符`==`和运算符`!=`对浮点数可能会有问题（以及如何解决这种问题）。这里有一个例子：
```cpp
#include <iostream>

int main()
{
    double d{ 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 + 0.1 }; // 应该加和为1.0

    if (d == 1.0)
        std::cout << "equal\n";
    else
        std::cout << "not equal\n";

    return 0;
}
```

这个程序会输出：
```
not equal
```

你对浮点数进行的算术运算越多，它累积的小舍入错误就越多。

## 整数除法

在下面的例子中，我们本意是进行浮点除法，但因为两个操作数都是整数，所以我们最终进行了整数除法：

```cpp
#include <iostream>

int main()
{
    int x{ 5 };
    int y{ 3 };

    std::cout << x << " divided by " << y << " is: " << x / y << '\n'; // 整数除法

    return 0;
}
```

这打印：

```
5 divided by 3 is: 1
```

在第6.2课 — 算术运算符中，我们展示了可以使用static_cast将一个整数操作数转换为浮点值，以进行浮点除法。

## 意外的空语句

在第8.3课 — 常见的if语句问题中，我们讨论了空语句，这是不做任何事情的语句。

在下面的程序中，我们只想在得到用户许可的情况下才炸掉世界：

```cpp
#include <iostream>

void blowUpWorld()
{
    std::cout << "Kaboom!\n";
}

int main()
{
    std::cout << "Should we blow up the world again? (y/n): ";
    char c{};
    std::cin >> c;

    if (c == 'y');     // 这里有一个意外的空语句
        blowUpWorld(); // 所以这总是会执行，因为它不是if语句的一部分

    return 0;
}
```

然而，由于意外的空语句，对blowUpWorld()的函数调用总是被执行，所以我们无论如何都会炸掉世界：

```
Should we blow up the world again? (y/n): n
Kaboom!
```

## 需要复合语句时没有使用

这是另一个总是炸掉世界的程序变体：

```cpp
#include <iostream>

void blowUpWorld()
{
    std::cout << "Kaboom!\n";
}

int main()
{
    std::cout << "Should we blow up the world again? (y/n): ";
    char c{};
    std::cin >> c;

    if (c == 'y')
        std::cout << "Okay, here we go...\n";
        blowUpWorld(); // 总是会执行。应该在复合语句内。

    return 0;
}
```

这个程序打印：

```
Should we blow up the world again? (y/n): n
Kaboom!
```

悬空else（在第8.3课 — 常见的if语句问题中讨论）也属于这一类。

## 在条件语句中使用赋值而不是相等

因为赋值运算符（=）和相等运算符（==）很相似，我们可能本打算使用相等但意外使用了赋值：

```cpp
#include <iostream>

void blowUpWorld()
{
    std::cout << "Kaboom!\n";
}

int main()
{
    std::cout << "Should we blow up the world again? (y/n): ";
    char c{};
    std::cin >> c;

    if (c = 'y') // 使用赋值运算符而不是相等运算符
        blowUpWorld();

    return 0;
}
```

这个程序打印：

```
Should we blow up the world again? (y/n): n
Kaboom!
```

赋值运算符返回其左操作数。`c = 'y'` 首先执行，将y赋给c并返回c。然后评估 `if (c)`。由于c现在是非零的，它被隐式转换为布尔值true，if语句相关的语句被执行。

因为在条件语句中的赋值几乎从未被有意使用，现代编译器在遇到这种情况时通常会发出警告。然而，如果你没有养成解决所有警告的习惯，这样的警告很容易被忽略。

## 还有什么？

以上代表了新C++程序员倾向于犯的最常见的语义错误类型的一个很好的样本，但还有很多其他类型。读者们，如果你有任何你认为是常见陷阱的其他例子，请在评论中留言。
# 9.4 Detecting and handling errors
# 9.5 `std::cin` and handling invalid input
# 9.6 Assert and static_assert
# 9.x Chapter 9 summary and quiz