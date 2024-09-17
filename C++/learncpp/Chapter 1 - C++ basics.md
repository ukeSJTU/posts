# 1.1 Statements and the structure of a program 语句和程序的结构
## Chapter introduction 本章简介
Welcome to the first primary chapter of these C++ tutorials!欢迎来到这些 C++ 教程的第一章！

In this chapter, we’ll take a first look at a number of topics that are essential to every C++ program. Because there are quite a few topics to cover, we’ll cover most at a fairly shallow level (just enough to get by). The goal of this chapter is to help you understand how basic C++ programs are constructed. By the end of the chapter, you will be able to write your own simple programs.在本章中，我们将首先了解每个 C++ 程序必不可少的许多主题。因为有相当多的主题要涵盖，所以我们将在相当浅的层面上介绍大部分（刚好够用）。本章的目标是帮助您了解基本 C++ 程序是如何构建的。在本章结束时，您将能够编写自己的简单程序。

In future chapters, we’ll revisit the majority of these topics and explore them in more detail. We’ll also introduce new concepts that build on top of these.在接下来的章节中，我们将重新审视其中的大部分主题，并更详细地探讨它们。我们还将介绍基于这些概念构建的新概念。

In order to keep the lesson lengths manageable, topics may be split over several subsequent lessons. If you feel like some important concept isn’t covered in a lesson, it’s possible that it’s covered in the next lesson.为了保持课程长度可控，主题可能会分为几节后续课程。如果您觉得某节课没有涉及某个重要概念，则下一课可能会涵盖该概念。

---
## Statements 语句
A computer program is a sequence of instructions that tell the computer what to do. A **statement** is a type of instruction that causes the program to _perform some action_.计算机程序是告诉计算机该做什么的一系列指令。**语句**是使程序_执行某些操作_的一种指令类型。

Statements are by far the most common type of instruction in a C++ program. This is because they are the smallest independent unit of computation in the C++ language. In that regard, they act much like sentences do in natural language. When we want to convey an idea to another person, we typically write or speak in sentences (not in random words or syllables). In C++, when we want to have our program do something, we typically write statements.到目前为止，语句是 C++ 程序中最常见的指令类型。这是因为它们是 C++ 语言中最小的独立计算单元。在这方面，它们的行为很像自然语言中的句子。当我们想将一个想法传达给另一个人时，我们通常会用句子来写或说（而不是用随机的单词或音节）。在 C++ 中，当我们想让我们的程序做某事时，我们通常会编写语句。

Most (but not all) statements in C++ end in a semicolon. If you see a line that ends in a semicolon, it’s probably a statement.C++ 中的大多数（但不是全部）语句都以分号结尾。如果您看到以分号结尾的行，则它可能是一个语句。

In a high-level language such as C++, a single statement may compile into many machine language instructions.在 C++ 等高级语言中，单个语句可以编译成许多机器语言指令。

> **For advanced readers**  
> **对于高级读者**
> 
> There are many different kinds of statements in C++:  
> C++ 中有许多不同种类的语句：
> 
> - **Declaration statements** 声明语句
> - **Jump statements** Jump 语句
> - **Expression statements** 表达式语句
> - **Compound statements** 复合语句
> - **Selection statements (conditionals)** 选择语句（条件）
> - **Iteration statements (loops)** 迭代语句（循环）
> - **Try blocks** Try 块
> 
> **By the time you’re through with this tutorial series, you’ll understand what all of these are!**  
> **当您完成本教程系列时，您将了解所有这些内容！**

## Functions and the main function 函数和 main 函数
In C++, statements are typically grouped into units called functions. A **function** is a collection of statements that get executed sequentially (in order, from top to bottom). As you learn to write your own programs, you’ll be able to create your own functions and mix and match statements in any way you please (we’ll show how in a future lesson).在 C++ 中，语句通常分组为称为函数的单元。**函数**是按顺序 （按顺序，从上到下） 执行的语句的集合。当您学习编写自己的程序时，您将能够以任何您喜欢的方式创建自己的函数和混合和匹配语句（我们将在以后的课程中介绍如何操作）。

> **Rule** 规则
> Every C++ program must have a special function named **main** (all lower case letters). When the program is run, the statements inside of `main` are executed in sequential order.每个 C++ 程序都必须有一个名为 **main** 的特殊函数（全部为小写字母）。当程序运行时，`main` 内部的语句按顺序执行。

Programs typically terminate (finish running) after the last statement inside function `main` has been executed (though programs may abort early in some circumstances, or do some cleanup afterwards).程序通常在执行函数 `main` 中的最后一个语句后终止（完成运行）（尽管在某些情况下程序可能会提前中止，或者在之后进行一些清理）。

Functions are typically written to do a specific job or perform some useful action. For example, a function named `max` might contain statements that figures out which of two numbers is larger. A function named `calculateGrade` might calculate a student’s grade from a set of test scores. A function named `printEmployee` might print an employee’s information to the console. We will talk a lot more about functions soon, as they are the most commonly used organizing tool in a program.编写函数通常是为了执行特定工作或执行一些有用的操作。例如，名为 `max` 的函数可能包含用于确定两个数字中哪个更大的语句。名为 `calculateGrade` 的函数可能会根据一组测试分数计算学生的成绩。名为 `printEmployee` 的函数可能会将员工的信息打印到控制台。我们很快就会更多地讨论函数，因为它们是程序中最常用的组织工具。

> **Nomenclature** 命名法
> When discussing functions, it’s fairly common shorthand to append a pair of parenthesis to the end of the function’s name. For example, if you see the term `main()` or `doSomething()`, this is shorthand for functions named `main` or `doSomething` respectively. This helps differentiate functions from other things with names (such as variables) without having to write the word “function” each time.在讨论函数时，在函数名称的末尾附加一对括号是相当常见的简写。例如，如果您看到术语 `main()` 或 `doSomething()`则它分别是名为 `main` 或 `doSomething` 的函数的简写。这有助于将函数与具有名称的其他事物（例如变量）区分开来，而不必每次都编写“函数`function`”一词。

In programming, the name of a function (or object, type, template, etc…) is called its **identifier**.在编程中，函数的名称（或对象、类型、模板等）称为其**标识符**。
## Dissecting Hello world! 剖析 Hello world！
Now that you have a brief understanding of what statements and functions are, let’s return to our “Hello world” program and take a high-level look at what each line does in more detail.现在，您已经简要了解了什么是语句和函数，让我们返回到 “Hello world” 程序，并更详细地了解每行的作用。

``` cpp
#include <iostream>

int main()
{
   std::cout << "Hello world!";
   return 0;
}
```

Line 1 is a special type of line called a preprocessor directive. This `#include` preprocessor directive indicates that we would like to use the contents of the `iostream` library, which is the part of the C++ standard library that allows us to read and write text from/to the console. We need this line in order to use `std::cout` on line 5. Excluding this line would result in a compile error on line 5, as the compiler wouldn’t otherwise know what `std::cout` is.第 1 行是一种特殊类型的行，称为预处理器指令。此 `#include` 预处理器指令表示我们希望使用 `iostream` 库的内容，该库是 C++ 标准库的一部分，允许我们从控制台读取文本和向控制台写入文本。我们需要这一行，以便在第 5 行使用 `std::cout`。排除此行将导致第 5 行出现编译错误，否则编译器将不知道 `std::cout` 是什么。

Line 2 is blank, and is ignored by the compiler. This line exists only to help make the program more readable to humans (by separating the `#include` preprocessor directive and the subsequent parts of the program).第 2 行为空，编译器将忽略该行。此行的存在只是为了帮助使程序对人类更具可读性（通过将 `#include` preprocessor 指令和程序的后续部分分开）。

Line 3 tells the compiler that we’re going to write (define) a function whose name (identifier) is `main`. As you learned above, every C++ program must have a `main` function or it will fail to link.第 3 行告诉编译器，我们将编写（定义）一个名称（标识符）为 `main` 的函数。正如您在上面所学到的，每个 C++ 程序都必须有一个 `main` 函数，否则将无法链接。

Lines 4 and 7 tell the compiler which lines are part of the _main_ function. Everything between the opening curly brace on line 4 and the closing curly brace on line 7 is considered part of the `main` function. This is called the function body.第 4 行和第 7 行告诉编译器哪些行是 _main_ 函数的一部分。第 4 行的左大括号和第 7 行的右大括号之间的所有内容都被视为 `main` 函数的一部分。这称为函数体。

Line 5 is the first statement within function `main`, and is the first statement that will execute when we run our program. `std::cout` (which stands for “character output”) and the `<<` operator allow us to display information on the console. In this case, we’re displaying the text “Hello world!”. This statement creates the visible output of the program.第 5 行是函数 `main` 中的第一个语句，也是我们运行程序时将执行的第一个语句。`std::cout`（代表 “字符输出”）和 `<<` 运算符允许我们在控制台上显示信息。在本例中，我们显示文本 “Hello world！”。此语句创建程序的可见输出。

Line 6 is a return statement. When an executable program finishes running, the program sends a value back to the operating system in order to indicate whether it ran successfully or not. This particular return statement returns the value `0` to the operating system, which means “everything went okay!”. This is the last statement in the program that executes.第 6 行是 return 语句。当可执行程序完成运行时，程序会将一个值发送回操作系统，以指示它是否成功运行。此特定 return 语句将值 `0` 返回给操作系统，这意味着“一切正常！这是程序中执行的最后一条语句。

All of the programs we write will follow this general template, or a variation on it.我们编写的所有程序都将遵循这个通用模板，或者它的一个变体。

> **Author’s note** 作者注
> If parts (or all) of the above explanation are confusing, that’s to be expected at this point. This was just to provide a quick overview. Subsequent lessons will dig into all of the above topics, with plenty of additional explanation and examples.如果上述解释的部分（或全部）令人困惑，那么在这一点上这是可以预料的。这只是为了提供一个快速的概述。后续课程将深入探讨上述所有主题，并提供大量额外的解释和示例。

You can compile and run this program yourself, and you will see that it outputs the following to the console:您可以自己编译并运行此程序，您将看到它将以下内容输出到控制台：

Hello world!

If you run into issues compiling or executing this program, check out lesson [0.8 -- A few common C++ problems](https://www.learncpp.com/cpp-tutorial/a-few-common-cpp-problems/).如果您在编译或执行此程序时遇到问题，请查看第 [0.8 课 -- 一些常见的 C++ 问题](https://www.learncpp.com/cpp-tutorial/a-few-common-cpp-problems/)。

---
## Syntax and syntax errors 语法和语法错误
In English, sentences are constructed according to specific grammatical rules that you probably learned in English class in school. For example, normal sentences end in a period. The rules that govern how sentences are constructed in a language is called **syntax**. If you forget the period and run two sentences together, this is a violation of the English language syntax.在英语中，句子是根据您可能在学校英语课上学到的特定语法规则构建的。例如，普通句子以句点结尾。控制句子在语言中如何构建的规则称为**语法**。如果您忘记了句号并将两个句子放在一起运行，则违反了英语语法。

C++ has a syntax too: rules about how your programs must be constructed in order to be considered valid. When you compile your program, the compiler is responsible for making sure your program follows the basic syntax of the C++ language. If you violate a rule, the compiler will complain when you try to compile your program, and issue you a **syntax error**.C++ 也有一个语法：关于必须如何构造程序才能被视为有效的规则。编译程序时，编译器负责确保程序遵循 C++ 语言的基本语法。如果您违反了规则，编译器将在您尝试编译程序时发出抱怨，并向您发出**语法错误**。

Let’s see what happens if we omit the semicolon on line 5 of the “Hello world” program, like this:让我们看看如果我们省略 “Hello world” 程序第 5 行的分号会发生什么，如下所示：
``` cpp
#include <iostream>

int main()
{
   std::cout << "Hello world!"
   return 0;
}
```

Feel free to compile this ill-formed program yourself.请随意自己编译这个格式不正确的程序。

Visual Studio produces the following error (your compiler may generate an error message with different wording):Visual Studio 生成以下错误（编译器可能会生成具有不同措辞的错误消息）：
``` shell
c:\vcprojects\hello.cpp(6): error C2143: syntax error : missing ';' before 'return'
```

The compiler is telling you that it encountered a syntax error on line 6: it was expecting a semicolon before the return statement, but it didn’t find one. Although the compiler will tell you which line of code it was compiling when it encountered the syntax error, the thing that needs to be fixed may actually be on a previous line. In this case, we’d conventionally place the semicolon at the end of line 5.编译器告诉您，它在第 6 行遇到了语法错误：它期望在 return 语句之前有一个分号，但没有找到分号。尽管编译器在遇到语法错误时会告诉你它正在编译哪一行代码，但需要修复的东西实际上可能位于前一行。在这种情况下，我们通常会将分号放在第 5 行的末尾。

Syntax errors are common when writing a program. Fortunately, they’re typically straightforward to find and fix, as the compiler will generally point you right at them. Compilation of a program will only complete once all syntax errors are resolved.编写程序时，语法错误很常见。幸运的是，它们通常很容易找到和修复，因为编译器通常会将您直接指向它们。只有在解决所有语法错误后，程序的编译才会完成。

You can try deleting characters or even whole lines from the “Hello world” program to see different kinds of errors that get generated. Try restoring the missing semicolon at the end of line 5, and then deleting lines 1, 3, or 4 and see what happens.您可以尝试从 “Hello world” 程序中删除字符甚至整行，以查看生成的各种错误。尝试恢复第 5 行末尾缺失的分号，然后删除第 1、3 或 4 行，看看会发生什么。

---
## Quiz time 测验时间
The following quiz is meant to reinforce your understanding of the material presented above.以下测验旨在加强您对上述材料的理解。

Question #1问题 #1

What is a statement?什么是对账单？

Hide Solution

A statement is an instruction in a computer program that tells the computer to perform an action.

Question #2问题 #2

What is a function?什么是函数？

Hide Solution

A function is a collection of statements that executes sequentially.

Question #3问题 #3

What is the name of the function that all programs must have?所有程序都必须具有的函数名称是什么？

Hide Solution

main

Question #4问题 #4

When a program is run, where does execution start?当程序运行时，从哪里开始执行？

Hide Solution

Execution starts with the first statement inside the _main_ function.

Question #5问题 #5

What symbol are statements in C++ often ended with?C++ 中的语句通常以什么符号结尾？

Hide Solution

The semicolon (`;`)

Question #6问题 #6

What is a syntax error?什么是语法错误？

Hide Solution

A syntax error is a compiler error that occurs at compile-time when your program violates the grammar rules of the C++ language.

Question \#7问题 #7

What is the C++ Standard Library?什么是 C++ 标准库？

Hint: Review lesson [0.5 -- Introduction to the compiler, linker, and libraries](https://www.learncpp.com/cpp-tutorial/introduction-to-the-compiler-linker-and-libraries/)

Hide Solution

A library file is a collection of precompiled code that has been “packaged up” for reuse in other programs. The C++ Standard Library is a library that ships with C++. It contains additional functionality to use in your programs.
# 1.2 - Comments 注释
A **comment** is a programmer-readable note that is inserted directly into the source code of the program. Comments are ignored by the compiler and are for the programmer’s use only.**注释**是程序员可读的注释，直接插入到程序的源代码中。编译器将忽略注释，仅供程序员使用。

In C++ there are two different styles of comments, both of which serve the same purpose: to help programmers document the code in some way.在 C++ 中，有两种不同样式的注释，它们都有相同的目的：帮助程序员以某种方式注解代码。
## Single-line comments 单行注释
The `//` symbol begins a C++ single-line comment, which tells the compiler to ignore everything from the `//` symbol to the end of the line. For example:该符号以 C++ 单行注释开头，该注释指示编译器忽略从该符号到行尾的所有内容。例如：

```cpp
std::cout << "Hello world!"; // Everything from here to the end of the line is ignored
```

Typically, the single-line comment is used to make a quick comment about a single line of code.通常，单行注释用于对单行代码进行快速注释。

```cpp
std::cout << "Hello world!\n"; // std::cout lives in the iostream library
std::cout << "It is very nice to meet you!\n"; // these comments make the code hard to read
std::cout << "Yeah!\n"; // especially when lines are different lengths
```

Having comments to the right of a line can make both the code and the comment hard to read, particularly if the line is long. If the lines are fairly short, the comments can simply be aligned (usually to a tab stop), like so:在行右侧添加注释会使代码和注释都难以阅读，尤其是在行很长的情况下。如果行相当短，则可以简单地对齐注释（通常对齐到制表位），如下所示：

```cpp
std::cout << "Hello world!\n";                 // std::cout lives in the iostream library
std::cout << "It is very nice to meet you!\n"; // this is much easier to read
std::cout << "Yeah!\n";                        // don't you think so?
```

However, if the lines are long, placing comments to the right can make your lines really long. In that case, single-line comments are often placed above the line it is commenting:但是，如果行很长，将注释放在右侧可能会使您的行非常长。在这种情况下，单行注释通常位于它正在注释的行的上方：
``` cpp
// std::cout lives in the iostream library
std::cout << "Hello world!\n";

// this is much easier to read
std::cout << "It is very nice to meet you!\n";

// don't you think so?
std::cout << "Yeah!\n";
```

> **Author’s note** 作者注  
> In this tutorial series, our examples fall into one of the following categories: 在本教程系列中，我们的示例分为以下类别之一：
> - Full programs (those with a `main()` function). These are ready to be compiled and run. 完整程序（具有 `main()` 函数的程序）。这些已准备好进行编译和运行。
> - Snippets (small pieces) of code, such as the statements above. We use these to demonstrate specific concepts in a concise manner. 代码片段（小段），例如上面的语句。我们使用这些来以简洁的方式演示特定概念。
> 
> We don’t intend for you to compile snippets. But if you’d like to, you’ll need to turn them into a full program. Typically, that program will look something like this: 我们不打算让您编译代码段。但是，如果您愿意，则需要将它们转换为一个完整的程序。通常，该程序将如下所示：
> 
> ```cpp
 #include TODO
>  
> int main()
> {
>     // Replace this line with the snippet(s) of code you'd like to compile
> 
>     return 0;
> }
> ```

## Multi-line comments 多行注释
The `/*` and `*/` pair of symbols denotes a C-style multi-line comment. Everything in between the symbols is ignored.`/*` 和 `*/` 对符号表示 C 样式的多行注释。符号之间的所有内容都将被忽略。

``` cpp
/* This is a multi-line comment.
   This line will be ignored.
   So will this one. */
```

Since everything between the symbols is ignored, you will sometimes see programmers “beautify” their multi-line comments:由于符号之间的所有内容都被忽略了，你有时会看到程序员 “美化” 他们的多行注释：

```cpp
/* This is a multi-line comment.
 * the matching asterisks to the left
 * can make this easier to read
 */
```

Multi-line style comments can not be nested. Consequently, the following will have unexpected results:多行样式注释不能嵌套。因此，以下情况将产生意外结果：

```cpp
/* This is a multi-line /* comment */ this is not inside the comment */
// The above comment ends at the first */, not the second */
```

When the compiler tries to compile this, it will ignore everything from the first `/*` to the first `*/`. Since `this is not inside the comment */` is not considered part of the comment, the compiler will try to compile it. That will inevitably result in a compile error.当编译器尝试编译此部分时，它将忽略从第一个 `/*` 到第一个 `*/` 的所有内容。由于 `this is not inside the comment */`没有算作注释的一部分，因此编译器将尝试编译它。这将不可避免地导致编译错误。

This is one place where using a syntax highlighter can be really useful, as the different coloring for comment should make clear what’s considered part of the comment vs not.这是使用语法高亮工具非常有用的地方，因为不同的颜色应该清楚地表明什么被认为是注释的一部分，什么不是。

> **Warning** 警告
> Don’t use multi-line comments inside other multi-line comments. Wrapping single-line comments inside a multi-line comment is okay.不要在其他多行注释中使用多行注释。将单行注释括在多行注释中是可以的。

## Proper use of comments 正确使用注释
Typically, comments should be used for three things. First, for a given library, program, or function, comments are best used to describe _what_ the library, program, or function, does. These are typically placed at the top of the file or library, or immediately preceding the function. For example:通常，注释应该用于三件事。首先，对于给定的库、程序或函数，注释最适合_用于描述库_、程序或函数的作用。这些通常位于文件或库的顶部，或紧靠在函数之前。例如：
```cpp
// This program calculates the student's final grade based on their test and homework scores.
```

```cpp
// This function uses Newton's method to approximate the root of a given equation.
```

```cpp
// The following lines generate a random item based on rarity, level, and a weight factor.
```

All of these comments give the reader a good idea of what the library, program, or function is trying to accomplish without having to look at the actual code. The user (possibly someone else, or you if you’re trying to reuse code you’ve previously written) can tell at a glance whether the code is relevant to what he or she is trying to accomplish. This is particularly important when working as part of a team, where not everybody will be familiar with all of the code.所有这些注释都使读者可以很好地了解库、程序或函数试图完成什么，而不必查看实际代码。用户（可能是其他人，或者如果您尝试重用以前编写的代码，则可能是您）可以一目了然地判断代码是否与他或她要完成的任务相关。这在作为团队的一部分工作时尤其重要，因为不是每个人都熟悉所有代码。

Second, _within_ a library, program, or function described above, comments can be used to describe _how_ the code is going to accomplish its goal.其次，_在_ 上述库、程序或函数中，可以使用注释来描述代码将 _如何_ 实现其目标。
```cpp
/* To calculate the final grade, we sum all the weighted midterm and homework scores
    and then divide by the number of scores to assign a percentage, which is
    used to calculate a letter grade. */
```

```cpp
// To generate a random item, we're going to do the following:
// 1) Put all of the items of the desired rarity on a list
// 2) Calculate a probability for each item based on level and weight factor
// 3) Choose a random number
// 4) Figure out which item that random number corresponds to
// 5) Return the appropriate item
```

These comments give the user an idea of how the code is going to accomplish its goal without having to understand what each individual line of code does.这些注释让用户了解代码将如何实现其目标，而不必了解每行代码的作用。

Third, at the statement level, comments should be used to describe _why_ the code is doing something. A bad statement comment explains _what_ the code is doing. If you ever write code that is so complex that needs a comment to explain _what_ a statement is doing, you probably need to rewrite your statement, not comment it.第三，在语句层面上，应该使用注释来描述代码执行某项操作 _的原因_ 。错误的 statement  _注释解释了代码_ 正在做什么。如果您编写的代码非常复杂，以至于需要一个注释 _来解释语句_ 的作用，则可能需要重写您的语句，而不是注释它。

Here are some examples of bad line comments and good statement comments.以下是一些不太好的 line 注释和比较好的 statement 注释的例子。 TODO 我感觉这里翻译的不好

Bad comment: 比较差的注释写法：
```cpp
// Set sight range to 0
sight = 0;
```

Reason: We already can see that sight is being set to 0 by looking at the statement原因：通过查看语句，我们已经可以看到 sight 设置为 0

Good comment:好的注释：
```cpp
// The player just drank a potion of blindness and can not see anything
sight = 0;
```

Reason: Now we know why the player’s sight is being set to 0原因：现在我们知道为什么玩家的视线被设置为 0

Bad comment:不好的注释：
```cpp
// Calculate the cost of the items
cost = quantity * 2 * storePrice;
```

Reason: We can see that this is a cost calculation, but why is quantity multiplied by 2?原因：我们可以看到这是一个成本计算，但为什么数量要乘以 2？

Good comment:好的注释：
```cpp
// We need to multiply quantity by 2 here because they are bought in pairs
cost = quantity * 2 * storePrice;
```

Reason: Now we know why this formula makes sense.原因：现在我们知道为什么这个公式有意义了。

Programmers often have to make a tough decision between solving a problem one way, or solving it another way. Comments are a great way to remind yourself (or tell somebody else) the reason you made one decision instead of another.程序员经常不得不在以一种方式解决问题或以另一种方式解决问题之间做出艰难的决定。评论是提醒自己（或告诉其他人）您做出一个决定而不是另一个决定的原因的好方法。

Good comments:好的注释：

```cpp
// We decided to use a linked list instead of an array because
// arrays do insertion too slowly.
```

```cpp
// We're going to use Newton's method to find the root of a number because
// there is no deterministic way to solve these equations.
```

Finally, comments should be written in a way that makes sense to someone who has no idea what the code does. It is often the case that a programmer will say “It’s obvious what this does! There’s no way I’ll forget about this”. Guess what? It’s _not_ obvious, and you _will_ be amazed how quickly you forget. :) You (or someone else) will thank you later for writing down the what, how, and why of your code in human language. Reading individual lines of code is easy. Understanding what goal they are meant to accomplish is not.最后，注释的编写方式应该对不知道代码做什么的人来说有意义。通常情况下，程序员会说“这很明显是做什么的！我不可能忘记这件事”。你猜怎么着？这_并不_明显_，您会惊_讶于忘记的速度有多快。:)您（或其他人）稍后会感谢您用人类语言写下代码的内容、方式和原因。读取单行代码很容易。了解他们应该实现的目标并非如此。

> **Related content** 相关内容
> We discuss commenting for variable declaration statements in lesson [1.7 -- Keywords and naming identifiers](https://www.learncpp.com/cpp-tutorial/keywords-and-naming-identifiers/).我们将在第 [1.7 课 -- 关键字和命名标识符](https://www.learncpp.com/cpp-tutorial/keywords-and-naming-identifiers/)中讨论变量声明语句的注释。

> **Best practice** 最佳实践
> Comment your code liberally, and write your comments as if speaking to someone who has no idea what the code does. Don’t assume you’ll remember why you made specific choices.自由地注释您的代码，并像与不知道代码作用的人交谈一样编写您的注释。不要假设你会记得你为什么做出特定的选择。

> **Author’s note** 作者注
> Throughout the rest of this tutorial series, we’ll use comments inside code blocks to draw your attention to specific things, or help illustrate how things work (while ensuring the programs still compile). Astute readers will note that by the above standards, most of these comments are horrible. :) As you read through the rest of the tutorials, keep in mind that the comments are serving an intentional educational purpose, not trying to demonstrate what good comments look like.在本系列教程的其余部分，我们将在代码块中使用注释来吸引您对特定事物的注意，或帮助说明事物的工作原理（同时确保程序仍然可编译）。精明的读者会注意到，按照上述标准，这些评论中的大多数都是可怕的。:)在阅读其余教程时，请记住，这些评论是有意的教育目的，而不是试图演示好的评论是什么样子的。

## Commenting out code 注释掉代码
Converting one or more lines of code into a comment is called **commenting out** your code. This provides a convenient way to (temporarily) exclude parts of your code from being included in your compiled program.将一行或多行代码转换为注释称为**注释掉**您的代码。这提供了一种方便的方法来（临时）将部分代码排除在编译程序中。

To comment out a single line of code, simply use the // style comment to turn a line of code into a comment temporarily:要注释掉一行代码，只需使用 // 样式的注释将一行代码临时转换为注释：

Uncommented out:未注释掉：
```cpp
std::cout << 1;
```

Commented out:注释掉：
```cpp
//    std::cout << 1;
```

To comment out a block of code, use // on multiple lines of code, or the /* */ style comment to turn the block of code into a comment temporarily.要注释掉代码块，请在多行代码上使用 //，或者使用 /* */ 样式注释将代码块临时转换为注释。TODO 这里格式有问题

Uncommented out:未注释掉：
```cpp
std::cout << 1;
std::cout << 2;
std::cout << 3;
```

Commented out:注释掉：
```cpp
//    std::cout << 1;
//    std::cout << 2;
//    std::cout << 3;
```

or或
```cpp
/*
    std::cout << 1;
    std::cout << 2;
    std::cout << 3;
*/
```

There are quite a few reasons you might want to do this:您可能想要这样做的原因有很多：

1. You’re working on a new piece of code that won’t compile yet, and you need to run the program. The compiler won’t let you compile the code if there are compiler errors. Commenting out the code that won’t compile will allow the program to compile so you can run it. When you’re ready, you can uncomment the code, and continue working on it.您正在处理一段尚未编译的新代码，您需要运行该程序。如果存在编译器错误，编译器不会让你编译代码。注释掉无法编译的代码将允许程序编译，以便您可以运行它。准备就绪后，您可以取消对代码的注释，然后继续处理它。
2. You’ve written new code that compiles but doesn’t work correctly, and you don’t have time to fix it until later. Commenting out the broken code will ensure the broken code doesn’t execute and cause problems until you can fix it.您编写了可以编译但无法正常工作的新代码，您目前暂时没有时间修复它。注释掉无法运行的代码将确保无法运行的代码不会执行并导致问题，直到您可以修复它。
3. To find the source of an error. If a program isn’t producing the desired results (or is crashing), it can sometimes be useful to disable parts of your code to see if you can isolate what’s causing it to not work correctly. If you comment out one or more lines of code, and your program starts working as expected (or stops crashing), odds are whatever you last commented out was part of the problem. You can then investigate why those lines of code are causing the problem.查找错误的来源。如果程序没有产生所需的结果（或崩溃），有时禁用部分代码以查看是否可以隔离导致其无法正常工作的原因可能很有用。如果你注释掉一行或多行代码，并且你的程序开始按预期工作（或停止崩溃），则很可能你上次注释掉的东西是问题的一部分。然后，您可以调查这些代码行导致问题的原因。
4. You want to replace one piece of code with another piece of code. Instead of just deleting the original code, you can comment it out and leave it there for reference until you’re sure your new code works properly. Once you are sure your new code is working, you can remove the old commented out code. If you can’t get your new code to work, you can always delete the new code and uncomment the old code to revert to what you had before.您希望将一段代码替换为另一段代码。您可以将其注释掉并保留以供参考，直到您确定新代码正常工作，而不是直接删除原始代码。确定新代码正常工作后，可以删除已注释掉的旧代码。如果您无法让新代码正常工作，您可以随时删除新代码并取消注释旧代码以恢复到以前的代码。

Commenting out code is a common thing to do while developing, so many IDEs provide support for commenting out a highlighted section of code. How you access this functionality varies by IDE. 注释掉代码是开发时经常做的事情，因此许多 IDE 都支持注释掉突出显示的代码部分。访问此功能的方式因 IDE 而异。

> **For Visual Studio users** 对于 Visual Studio 用户
> You can comment or uncomment a selection via Edit menu > Advanced > Comment Selection (or Uncomment Selection).您可以通过 Advanced > Comment Selection（或取消注释所选内容）> Edit 菜单对所选内容进行注释或取消注释。

> **For Code::Blocks users** 对于 Code：：Blocks 用户
> You can comment or uncomment a selection via Edit menu > Comment (or Uncomment, or Toggle comment, or any of the other comment tools).您可以通过 Comment（或取消注释、Toggle comment（切换注释或任何其他注释工具）> Edit 菜单对选择进行注释或取消注释。

> **For VS Code users** 对于 VS Code 用户
> You can comment or uncomment a selection by pressing ctrl-/.您可以通过按 ctrl-/ 来注释或取消注释所选内容。TODO 考虑macOS上面的command情况，具体的快捷键可以参考原文内容评论区讨论 https://www.learncpp.com/cpp-tutorial/comments/

> **Tip** 提示
> If you always use single line comments for your normal comments, then you can always use multi-line comments to comment out your code without conflict. If you use multi-line comments to document your code, then commenting-out code using comments can become more challenging.如果您始终用单行注释(`//`)来注释或者说解释代码，那么您就可以用多行注释来注释掉您的代码而不会发生冲突。但如果你用多行注释来注解代码（写文档，函数接口定义），那么使用注释来屏蔽代码会变得更加困难。
>
> If you do need to comment out a code block that contains multi-line comments, you can also consider using the `#if 0` preprocessor directive, which we discuss in lesson [2.10 -- Introduction to the preprocessor](https://www.learncpp.com/cpp-tutorial/introduction-to-the-preprocessor/#if0).如果您确实需要注释掉包含多行注释的代码块，您还可以考虑使用 `#if 0` 预处理器指令，我们将在第 [2.10 课 -- 预处理器简介](https://www.learncpp.com/cpp-tutorial/introduction-to-the-preprocessor/#if0)中讨论。

## Summary 总结
- At the library, program, or function level, use comments to describe _what_.在库、程序或函数级别，使用注释来描述 _内容_ 。
- Inside the library, program, or function, use comments to describe _how_.在库、程序或函数中，使用注释来描述 _如何操作_ 。
- At the statement level, use comments to describe _why_.在语句级别，使用注释来描述 _原因_ 。

# 1.3 - Introduction to objects and variables 对象和变量简介
## Data and values 数据和值

In lesson [1.1 -- Statements and the structure of a program](https://www.learncpp.com/cpp-tutorial/statements-and-the-structure-of-a-program/), you learned that the majority of instructions in a program are statements, and that functions are groups of statements that execute sequentially. The statements inside the function perform actions that (hopefully) generate whatever result the program was designed to produce.在第 [1.1 课 -- 语句和程序的结构](https://www.learncpp.com/cpp-tutorial/statements-and-the-structure-of-a-program/)中，您了解了程序中的大多数指令都是语句，而函数是按顺序执行的语句组。函数内的语句执行操作（希望）生成程序设计产生的任何结果。

But how do programs actually produce results? They do so by manipulating (reading, changing, and writing) data. In computing, **data** is any information that can be moved, processed, or stored by a computer.但是程序实际上是如何产生结果的呢？它们通过操作 （读取、更改和写入） 数据来实现此目的。在计算中，**数据**是可以由计算机移动、处理或存储的任何信息。

> **Key insight** 关键洞察
> 
> Programs are collections of instructions that manipulate data to produce a desired result.程序是处理数据以产生所需结果的指令集合。

A program can acquire data to work with in many ways: from a file or database, over a network, from the user providing input on a keyboard, or from the programmer putting data directly into the source code of the program itself. In the “Hello world” program from the aforementioned lesson, the text “Hello world!” was inserted directly into the source code of the program, providing data for the program to use. The program then manipulates this data by sending it to the monitor to be displayed.程序可以通过多种方式获取要使用的数据：从文件或数据库、通过网络、从用户在键盘上提供输入，或者从程序员将数据直接放入程序本身的源代码中。在上述课程的 “Hello world” 程序中，文本 “Hello world！” 被直接插入到程序的源代码中，为程序提供要使用的数据。然后，程序通过将这些数据发送到监视器来显示这些数据。

Data on a computer is typically stored in a format that is efficient for storage or processing (and is thus not human readable). Thus, when the “Hello World” program is compiled, the text “Hello world!” is converted into a more efficient format for the program to use (binary, which we’ll discuss in a future lesson).计算机上的数据通常以可有效存储或处理的格式存储（因此不是人类可读的）。因此，当编译 “Hello World” 程序时，文本 “Hello world！” 被转换为一种更有效的格式供程序使用（二进制，我们将在以后的课程中讨论）。

A single piece of data is called a **value**. Common examples of values include letters (e.g. `a`), numbers (e.g. `5`), and text (e.g. `Hello`).单个数据片段称为**值**。值的常见示例包括字母（例如 `a`）、数字（例如 `5`）和文本（例如 `Hello`）。
## Random Access Memory RAM 内存
The main memory in a computer is called **Random Access Memory** (often called **RAM** for short). When we run a program, the operating system loads the program into RAM. Any data that is hardcoded into the program itself (e.g. text such as “Hello, world!”) is loaded at this point.计算机中的主内存称为**随机存取存储器**（通常简称 **RAM**）。当我们运行一个程序时，操作系统会将程序加载到 RAM 中。此时将加载硬编码到程序本身中的任何数据（例如，诸如 “Hello， world！” 之类的文本）。

The operating system also reserves some additional RAM for the program to use while it is running. Common uses for this memory are to store values entered by the user, to store data read in from a file or network, or to store values calculated while the program is running (e.g. the sum of two values) so they can be used again later.操作系统还保留了一些额外的 RAM 供程序在运行时使用。此内存的常见用途是存储用户输入的值，存储从文件或网络读取的数据，或存储程序运行时计算的值（例如两个值的总和），以便以后可以再次使用。

You can think of RAM as a series of numbered boxes that can be used to store data while the program is running.您可以将 RAM 视为一系列编号框，可用于在程序运行时存储数据。

In some older programming languages (like Applesoft BASIC), you could directly access these boxes (e.g. you could write a statement to “go get the value stored in mailbox number 7532”).在一些较旧的编程语言（如 Applesoft BASIC）中，您可以直接访问这些框（例如，您可以编写一个语句来“获取存储在标号为7532的框中的数据”）。
## Objects and variables 对象和变量
In C++, direct memory access is discouraged. Instead, we access memory indirectly through an object. An **object** is a region of storage (usually memory) that can store a value, and has other associated properties (that we’ll cover in future lessons). How the compiler and operating system work to assign memory to objects is beyond the scope of this lesson. But the key point here is that rather than say “go get the value stored in mailbox number 7532”, we can say, “go get the value stored by this object” and let the compiler figure out where and how to retrieve the value. This means we can focus on using objects to store and retrieve values, and not have to worry about where in memory those objects are actually being placed.在 C++ 中，不建议直接访问内存。相反，我们通过对象间接访问内存。**对象**是可以存储值的存储区域（通常是内存），并具有其他关联的属性（我们将在以后的课程中介绍）。编译器和操作系统如何为对象分配内存超出了本课的范围。但这里的关键点是，与其说“去获取存储在邮箱号 7532 中的值”，不如说“去获取此对象存储的值”，然后让编译器弄清楚在何处以及如何检索该值。这意味着我们可以专注于使用对象来存储和检索值，而不必担心这些对象在内存中的实际放置位置。

Although objects in C++ can be unnamed (anonymous), more often we name our objects using an identifier. An object with a name is called a **variable**.尽管 C++ 中的对象可以是未命名的（匿名），但更多时候我们使用标识符来命名对象。具有名称的对象称为**变量**。

> **Key insight** 关键洞察 TODO 应该有个更好的翻译，并且全局替换
> 
> An object is used to store a value in memory. A variable is an object that has a name (identifier).对象用于将值存储在内存中。变量是具有名称 （标识符） 的对象。
> 
> Naming our objects let us refer to them again later in the program.命名我们的对象让我们稍后在程序中再次引用它们。

> **Nomenclature** 命名法 TODO 不理解为什么这里的意思是命名法
> 
> In general programming, the term _object_ typically refers to an unnamed object in memory, a variable, or a function. In C++, the term _object_ has a narrower definition that excludes functions.在一般编程中，对象 _object_ 这个术语通常是指内存中的未命名对象、变量或函数。在 C++ 中，对象 _object_ 的定义范围较窄，不包括函数。

## Variable instantiation 变量实例化
In order to create a variable, we use a special kind of declaration statement called a **definition** (we’ll clarify the difference between a declaration and definition later).为了创建一个变量，我们使用一种特殊的声明语句，称为**定义**（我们稍后会阐明声明和定义之间的区别）。

Here’s an example of defining a variable named `x`:下面是定义名为 `x` 的变量的示例：
```cpp
int x; // define a variable named x, of type int
```

At compile time, when the compiler sees this statement, it makes a note to itself that we are defining a variable, giving it the name `x`, and that it has the data type `int` (more on data types in a moment). From that point forward (with some limitations that we’ll talk about in a future lesson), whenever the compiler sees the identifier `x`, it will know that we’re referencing this variable.在编译时，当编译器看到此语句时，它会记录我们正在定义一个变量，为其指定名称 `x`，并且它具有数据类型 `int` （稍后将详细介绍数据类型）。从那时起（有一些限制，我们将在以后的课程中讨论），每当编译器看到标识符 `x` 时，它就会知道我们指的是这个变量。

When the program is run (called **runtime**), the variable will be instantiated. **Instantiation** is a fancy word that means the object will be created and assigned a memory address. Variables must be instantiated before they can be used to store values. For the sake of example, let’s say that variable _x_ is instantiated at memory location 140. Whenever the program uses variable x, it will access the value in memory location 140. An instantiated object is sometimes called an **instance**.当程序运行 （称为 **runtime**） 时，变量将被实例化。**Instantiation** 是一个花哨的词，表示将创建对象并为其分配内存地址。必须先实例化变量，然后才能用于存储值。例如，假设变量 _x_ 在内存位置 140 处实例化。每当程序使用变量 x 时，它将访问内存位置 140 中的值。实例化的对象有时称为**实例**。
## Data types 数据类型
So far, we’ve covered that objects are regions of storage that can store a data value (how exactly data is stored is a topic for a future lesson). A **data type** (more commonly just called a **type**) determines what kind of value (e.g. a number, a letter, text, etc…) the object will store.到目前为止，我们已经介绍了对象是可以存储数据值的存储区域（数据的确切存储方式是以后课程的主题）。**数据类型**（通常简称为**类型**）决定了对象将存储什么样的值（例如数字、字母、文本等）。

In the above example, our variable `x` was given type `int`, which means variable `x` will store an integer value. An **integer** is a number that can be written without a fractional component, such as `4`, `27`, `0`, `-2`, or `-12`. For short, we can say that `x` is an `integer variable`.在上面的例子中，我们的变量 `x` 被赋予了 `int` 类型，这意味着变量 `x` 将存储一个整数值。**整数**是不带小数部分的数字，例如 `4`、`27`、`0`、`-2` 或 `-12`。简而言之，我们可以说 `x` 是一个整型变量`integer variable`。

In C++, the type of an object must be known at **compile-time** (when the program is compiled), and that type can not be changed without recompiling the program. This means an integer variable can only hold integer values. If you want to store some other kind of value, you’ll need to use a different type.在 C++ 中，对象的类型必须在**编译时**（编译程序时）已知，并且在不重新编译程序的情况下无法更改该类型。这意味着 integer 变量只能保存 integer 值。如果要存储其他类型的值，则需要使用不同的类型。

> **Key insight** 关键洞察

> The data type of an object must be known at compile-time (in order to instantiate it). 对象的数据类型必须在编译时确定（以便实例化它）。

Integers are just one of many types that C++ supports out of the box. For illustrative purposes, here’s another example of defining a variable using data type `double`:整数只是 C++ 开箱即用支持的众多类型之一。为了便于说明，以下是使用 `double` 数据类型定义变量的另一个示例：

```cpp
double width; // define a variable named width, of type double
```

C++ also allows you to create your own custom types. This is something we’ll do a lot of in future lessons, and it’s part of what makes C++ powerful.C++ 还允许您创建自己的自定义类型。这是我们在以后的课程中会经常做的事情，也是 C++ 强大的部分原因。

For these introductory chapters, we’ll stick with integer variables because they are conceptually simple, but we’ll explore many of the other types C++ has to offer (including `double`) soon.在这些介绍性章节中，我们将坚持使用整数变量，因为它们在概念上很简单，但我们很快就会探索 C++ 必须提供的许多其他类型（包括 `double`）。
## Defining multiple variables 定义多个变量
It is possible to define multiple variables _of the same type_ in a single statement by separating the names with a comma. The following 2 snippets of code are effectively the same:可以通过用逗号分隔名称，在单个语句中定义 _多个相同类型的_ 变量。以下 2 段代码实际上是相同的：

```cpp
int a;
int b;
```

is the same as:等同于：
```cpp
int a, b;
```

When defining multiple variables this way, there are two common mistakes that new programmers tend to make (neither serious, since the compiler will catch these and ask you to fix them):以这种方式定义多个变量时，新程序员往往会犯两个常见的错误（这些错误都不严重，因为编译器会捕获这些错误并要求您修复它们）：

The first mistake is giving each variable a type when defining variables in sequence.第一个错误是在按顺序定义变量时给每个变量一个类型。

```cpp
int a, int b; // wrong (compiler error)

int a, b; // correct
```

The second mistake is to try to define variables of different types in the same statement, which is not allowed. Variables of different types must be defined in separate statements.第二个错误是尝试在同一语句中定义不同类型的变量，这是不被允许的。不同类型的变量必须在单独的语句中定义。

```cpp
int a, double b; // wrong (compiler error)

int a; double b; // correct (but not recommended)

// correct and recommended (easier to read)
int a;
double b;
```

> **Best practice** 最佳实践
> 
> Although the language allows you to do so, avoid defining multiple variables of the same type in a single statement. Instead, define each variable in a separate statement on its own line (and then use a single-line comment to document what it is used for).尽管该语言允许您这样做，但请避免在单个语句中定义多个相同类型的变量。相反，在单独的语句中定义每个变量在其自己的行上（然后使用单行注释来记录它的用途）。

## Summary 总结
In C++, we use objects to access memory. A named object is called a variable. Variables have an identifier, a type, and a value (and some other attributes that aren’t relevant here). A variable’s type is used to determine how the value in memory should be interpreted.在 C++ 中，我们使用对象来访问内存。命名对象称为变量。变量具有标识符、类型和值（以及此处不相关的一些其他属性）。变量的类型用于确定应如何解释内存中的值。

In the next lesson, we’ll look at how to give values to our variables and how to actually use them.在下一课中，我们将了解如何为变量赋值以及如何实际使用它们。
## Quiz time 测验时间
TODO 以下格式内容全部需要调整
Question #1问题 #1

What is data?什么是数据？

Hide Solution隐藏解决方案

Data is any information that can be moved, processed, or stored by a computer.数据是计算机可以移动、处理或存储的任何信息。

Question #2问题 #2

What is a value?什么是值？

Hide Solution隐藏解决方案

A value is a letter (e.g. `a`), number (e.g. `5`), text (e.g. `Hello`), or instance of some other useful concept that can be represented as data.值是字母（例如 `a`）、数字（例如 `5`）、文本（例如 `Hello`）或其他一些可以表示为数据的有用概念的实例。

Question #3问题 #3

What is an object?什么是对象？

Hide Solution隐藏解决方案

An object is a region of storage (usually memory) that can store a value.对象是可以存储值的存储区域（通常是内存）。

Question #4问题 #4

What is a variable?什么是变量？

Hide Solution隐藏解决方案

A variable is an object that has a name.变量是具有名称的对象。

Question #5问题 #5

What is an identifier?什么是标识符？

Hide Solution隐藏解决方案

An identifier is the name that a variable is accessed by.标识符是访问变量时所依据的名称。

Question #6问题 #6

What is a data type used for?数据类型是做什么用的？

Hide Solution隐藏解决方案

A data type determines what kind of value (e.g. a number, a letter, text, etc…) the object will store.数据类型决定了对象将存储什么样的值（例如数字、字母、文本等）。

Question #7问题 #7

What is an integer?什么是整数？

Hide Solution隐藏解决方案

An integer is a number that can be written without a fractional component.整数是可以写入而不带小数分量的数字。

# 1.4 Variable assignment and initialization 变量赋值和初始化
In the previous lesson ([1.3 -- Introduction to objects and variables](https://www.learncpp.com/cpp-tutorial/introduction-to-objects-and-variables/)), we covered how to define a variable that we can use to store values. In this lesson, we’ll explore how to actually put values into variables and use those values.在上一课 （[1.3 -- 对象和变量简介](https://www.learncpp.com/cpp-tutorial/introduction-to-objects-and-variables/)） 中，我们介绍了如何定义可用于存储值的变量。在本课中，我们将探讨如何将值实际放入变量中并使用这些值。

As a reminder, here’s a short snippet that first allocates a single integer variable named _x_, then allocates two more integer variables named _y_ and _z_:提醒一下，下面是一个简短的代码片段，它首先分配一个名为 _x_ 的整数变量，然后分配另外两个名为 _y_ 和 _z_ 的整数变量：

```cpp
int x;    // define an integer variable named x
int y, z; // define two integer variables, named y and z
```
## Variable assignment 变量赋值
After a variable has been defined, you can give it a value (in a separate statement) using the _= operator_. This process is called **assignment**, and the _= operator_ is called the **assignment operator**.定义变量后，您可以使用 `=`运算符为其指定一个值（在单独的语句中）。此过程称为 **assignment**赋值，`=`运算符称为 **赋值运算符**。

```cpp
int width; // define an integer variable named width
width = 5; // assignment of value 5 into variable width

// variable width now has value 5
```
By default, assignment copies the value on the right-hand side of the _= operator_ to the variable on the left-hand side of the operator. This is called **copy assignment**.默认情况下，赋值会将  _= 运算符_ 右侧的值复制到运算符左侧的变量。这称为**复制赋值**。

Here’s an example where we use assignment twice:下面是一个我们使用两次赋值的示例：
```cpp
#include <iostream>

int main()
{
	int width;
	width = 5; // copy assignment of value 5 into variable width

	std::cout << width; // prints 5

	width = 7; // change value stored in variable width to 7

	std::cout << width; // prints 7

	return 0;
}
```

This prints:这将打印出：
``` text
57
```

When we assign value 7 to variable _width_, the value 5 that was there previously is overwritten. Normal variables can only hold one value at a time.当我们为变量 _width_ 分配值 7 时，之前的值 5 将被覆盖。Normal 变量一次只能保存一个值。TODO 完善翻译

> **Warning** 警告
> 
> One of the most common mistakes that new programmers make is to confuse the assignment operator (`=`) with the equality operator (`==`). Assignment (`=`) is used to assign a value to a variable. Equality (`==`) is used to test whether two operands are equal in value.新程序员最常犯的错误之一是将赋值运算符 （`=`） 与相等运算符 （`==` 混淆。赋值 （`=`） 用于为变量赋值。相等 （`==`） 用于测试两个操作数的值是否相等。

## Variable initialization 变量初始化
One downside of assignment is that it requires at least two statements: one to define the variable, and another to assign the value.赋值的一个缺点是它至少需要两个语句：一个用于定义变量，另一个用于赋值。

These two steps can be combined. When an object is defined, you can optionally give it an initial value. The process of specifying an initial value for an object is called **initialization**, and the syntax used to initialize an object is called an **initializer**. 这两个步骤可以合并。当定义一个对象时，你可以选择为其赋予一个初始值。为对象指定初始值的过程称为**初始化**，用于初始化对象的语法称为**初始化器**。TODO 我也不知道initializer怎么翻译

```cpp
int width { 5 }; // define variable width and initialize with initial value 5

// variable width now has value 5
```

In the above initialization of variable `width`, `{ 5 }` is the initializer, and `5` is the initial value.

> **Key insight** 关键洞察
> 
> Initialization provides an initial value for a variable. Think “initial-ization”.初始化为变量提供初始值。想想 “initial-ization”。

## Different forms of initialization 不同形式的初始化
Initialization in C++ is surprisingly complex, so we’ll present a simplified view here. C++中的初始化非常复杂，因此我们在此给出简化的介绍。

There are 6 basic ways to initialize variables in C++:C++中有6种基本的变量初始化方式：

```cpp
int a;         // no initializer (default initialization)
int b = 5;     // initial value after equals sign (copy initialization)
int c( 6 );    // initial value in parenthesis (direct initialization)

// List initialization methods (C++11) (preferred)
int d { 7 };   // initial value in braces (direct list initialization)
int e = { 8 }; // initial value in braces after equals sign (copy list initialization)
int f {};      // initializer is empty braces (value initialization)
```

You may see the above forms written with different spacing (e.g. `int d{7};`). Whether you use extra spaces for readability or not is a matter of personal preference.您可能会看到上述形式以不同的间距书写（例如 `int d{7};`）。您是否使用额外的空格来提高可读性是个人喜好的问题。
## Default initialization 默认初始化

When no initializer is provided (such as for variable `a` above), this is called **default initialization**. In most cases, default initialization performs no initialization, and leaves a variable with an indeterminate value.如果未提供初始化器（例如上面的变量 `a`），这称为 **default initialization**。在大多数情况下，默认初始化不执行初始化，并留下具有不确定值的变量。

We’ll discuss this case further in lesson ([1.6 -- Uninitialized variables and undefined behavior](https://www.learncpp.com/cpp-tutorial/uninitialized-variables-and-undefined-behavior/)).我们将在 lesson （[1.6 -- 未初始化的变量和未定义的行为](https://www.learncpp.com/cpp-tutorial/uninitialized-variables-and-undefined-behavior/)） 中进一步讨论这种情况。
## Copy initialization 复制初始化
When an initial value is provided after an equals sign, this is called **copy initialization**. This form of initialization was inherited from C.当在等号后提供初始值时，这称为**复制初始化**。这种形式的初始化继承自 C。

```cpp
int width = 5; // copy initialization of value 5 into variable width
```

Much like copy assignment, this copies the value on the right-hand side of the equals into the variable being created on the left-hand side. In the above snippet, variable `width` will be initialized with value `5`.与复制赋值非常相似，这会将 equals 右侧的值复制到左侧创建的变量中。在上面的代码片段中，变量 `width` 将初始化为值 `5`。

Copy initialization had fallen out of favor in modern C++ due to being less efficient than other forms of initialization for some complex types. However, C++17 remedied the bulk of these issues, and copy initialization is now finding new advocates. You will also find it used in older code (especially code ported from C), or by developers who simply think it looks more natural and is easier to read.复制初始化在现代 C++ 中已不再受欢迎，因为对于某些复杂类型，复制初始化的效率低于其他形式的初始化。但是，C++17 修复了大部分这些问题，复制初始化现在正在寻找新的倡导者。您还会发现它在较旧的代码中使用（尤其是从 C 移植的代码），或者被那些只是认为它看起来更自然且更易于阅读的开发人员使用。

> **For advanced readers** 对于高级读者
> 
> Copy initialization is also used whenever values are implicitly copied or converted, such as when passing arguments to a function by value, returning from a function by value, or catching exceptions by value.每当隐式复制或转换值时，也会使用复制初始化，例如按值将参数传递给函数、按值从函数返回或按值捕获异常时。
## Direct initialization直接初始化
When an initial value is provided inside parenthesis, this is called **direct initialization**.当括号内提供初始值时，这称为**直接初始化**。

```cpp
int width( 5 ); // direct initialization of value 5 into variable width
```

Direct initialization was initially introduced to allow for more efficient initialization of complex objects (those with class types, which we’ll cover in a future chapter). Just like copy initialization, direct initialization had fallen out of favor in modern C++, largely due to being superseded by list initialization. However, we now know that list initialization has a few quirks of its own, and so direct initialization is once again finding use in certain cases. 直接初始化最初被引入是为了更高效地初始化复杂对象（那些具有类类型的对象，我们将在后续章节中讨论）。与复制初始化类似，直接初始化在现代C++中曾一度失宠，主要是因为它被列表初始化所取代。然而，我们现在知道列表初始化有一些自身的 quirks（怪癖），因此直接初始化在某些情况下再次得到了使用。

> **For advanced readers** 对于高级读者
> 
> Direct initialization is also used when values are explicitly cast to another type.当值显式转换为另一种类型时，也会使用直接初始化。
> 
> One of the reasons direct initialization had fallen out of favor is because it makes it hard to differentiate variables from functions. For example:直接初始化失宠的原因之一是因为它使得很难区分变量和函数。例如：
```cpp
int x();  // forward declaration of function x
int x(0); // definition of variable x with initializer 0
```
## List initialization列表初始化
The modern way to initialize objects in C++ is to use a form of initialization that makes use of curly braces. This is called **list initialization** (or **uniform initialization** or **brace initialization**).在 C++ 中初始化对象的现代方法是使用一种使用大括号的初始化形式。这称为**列表初始化**（或**统一初始化**或**大括号初始化**）。

List initialization comes in three forms:列表初始化有三种形式：
```cpp
int width { 5 };    // direct list initialization of initial value 5 into variable width
int height = { 6 }; // copy list initialization of initial value 6 into variable height
int depth {};       // value initialization (covered below)
```

Prior to the introduction of list initialization, some types of initialization required using copy initialization, and other types of initialization required using direct initialization. List initialization was introduced to provide a more consistent initialization syntax (which is why it is sometimes called “uniform initialization”) that works in most cases. 在引入列表初始化之前，某些类型的初始化需要使用复制初始化，而其他类型的初始化则需要使用直接初始化。列表初始化的引入是为了提供一种更一致的初始化语法（这也是为什么它有时被称为“统一初始化”），它适用于大多数情况。

Additionally, list initialization provides a way to initialize objects with a list of values (which is why it is called “list initialization”). We show an example of this in lesson [16.2 -- Introduction to std::vector and list constructors](https://www.learncpp.com/cpp-tutorial/introduction-to-stdvector-and-list-constructors/).此外，列表初始化提供了一种使用值列表初始化对象的方法（这就是它被称为“列表初始化”的原因）。我们在第 [16.2 课 -- std：：vector 和列表构造函数简介](https://www.learncpp.com/cpp-tutorial/introduction-to-stdvector-and-list-constructors/)中展示了一个例子。

List initialization disallows narrowing conversions列表初始化不允许缩小转换范围

The primary benefit of list initialization is that “narrowing conversions” are disallowed. This means that if you try to list initialize a variable using a value that the variable can not safely hold, the compiler is required to produce a diagnostic (usually an error). For example:列表初始化的主要好处是不允许 “缩小转换范围”。这意味着，如果尝试使用变量无法安全保存的值列出初始化变量，编译器会生成诊断（通常是错误）。例如：

```cpp
int main()
{
    // An integer can only hold non-fractional values
    int w1 { 4.5 }; // compile error: list init does not allow narrowing conversion of 4.5 to 4

    int w2 = 4.5;   // compiles: copy init initializes width with 4
    int w3(4.5);    // compiles: direct init initializes width with 4

    return 0;
}
```

On line 4 of the above program, we’re using a value (`4.5`) with a fractional component (`.5`) to list initialize an integer variable (which can only hold non-fractional values). Because this is a narrowing conversion, the compiler is required to generate a diagnostic in such cases.在上面程序的第 4 行，我们使用一个带有小数分量 （`.5`） 的值 （`4.5`） 来列出初始化一个整数变量（只能保存非小数值）。因为这是一个 narrowing conversion，所以在这种情况下需要编译器生成诊断。

Copy initialization (line 6) and direct initialization (line 7) both silently drop the `.5` and initialize the variable with the value `4` (which probably isn’t what we want). Your compiler may warn you about this, since losing data is rarely desired, but it also may not. 复制初始化（第6行）和直接初始化（第7行）都会悄悄地去掉 `.5`，并使用值 `4` 初始化变量（这可能不是我们想要的结果）。编译器可能会对此发出警告，因为丢失数据通常不是我们想要的，但也可能不会发出警告。

Note that this restriction on narrowing conversions only applies to the list initialization, not to any subsequent assignments to the variable:请注意，此对缩小转换范围的限制仅适用于列表初始化，而不适用于对变量的任何后续赋值：

```cpp
int main()
{
    int w1 { 4.5 }; // compile error: list init does not allow narrowing conversion of 4.5 to 4

    w1 = 4.5;       // okay: copy assignment allows narrowing conversion of 4.5 to 4

    return 0;
}
```
## List initialization is the preferred form of initialization in modern C++列表初始化是现代 C++ 中首选的初始化形式
To summarize, list initialization is generally preferred over the other initialization forms because it works in most cases (and is therefore most consistent), it disallows narrowing conversions (which we normally don’t want), and it supports initialization with lists of values (something we’ll cover in a future lesson). While you are learning, we recommend sticking with direct list initialization (and value initialization).总而言之，列表初始化通常比其他初始化形式更可取，因为它在大多数情况下都有效（因此是最一致的），它不允许缩小转换范围（我们通常不想要），并且它支持使用值列表进行初始化（我们将在以后的课程中介绍）。在你学习的时候，我们建议坚持使用直接列表初始化（和值初始化）。

> **Best practice** 最佳实践
> 
> Prefer direct list initialization (or value initialization) for initializing your variables.首选直接列表初始化（或值初始化）来初始化变量。

> **Author’s note** 作者注
> 
> Bjarne Stroustrup (creator of C++) and Herb Sutter (C++ expert) also recommend [using list initialization](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#Res-list) to initialize your variables.Bjarne Stroustrup（C++ 的创建者）和 Herb Sutter（C++ 专家）也建议使用[列表初始化](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines#Res-list)来初始化变量。
> 
> In modern C++, there are some cases where list initialization does not work as expected. We cover one such case in lesson [16.2 -- Introduction to std::vector and list constructors](https://www.learncpp.com/cpp-tutorial/introduction-to-stdvector-and-list-constructors/).在现代 C++ 中，在某些情况下，列表初始化无法按预期工作。我们在第 16.2 课中介绍了一个这样的例子 [-- std：：vector 和列表构造函数简介](https://www.learncpp.com/cpp-tutorial/introduction-to-stdvector-and-list-constructors/)。
> 
> Because of such quirks, some experienced developers now advocate for using a mix of copy, direct, and list initialization, depending on the circumstance. Once you are familiar enough with the language to understand the nuances of each initialization type and the reasoning behind such recommendations, you can evaluate on your own whether you find these arguments persuasive.由于这些怪癖，一些有经验的开发人员现在提倡根据情况混合使用复制、直接和列表初始化。一旦您足够熟悉语言，能够理解每种初始化类型的细微差别以及此类建议背后的原因，您就可以自行评估这些参数是否具有说服力。

## Value initialization and zero initialization值初始化和零初始化
When a variable is initialized using empty braces, **value initialization** takes place. In most cases, **value initialization** will initialize the variable to zero (or empty, if that’s more appropriate for a given type). In such cases where zeroing occurs, this is called **zero initialization**.使用空大括号初始化变量时，将进行**值初始化**。在大多数情况下，**值初始化**会将变量初始化为零（或空，如果这更适合给定类型）。在发生清零的情况下，这称为**零初始化**。

```cpp
int width {}; // value initialization / zero initialization to value 0
```

> **Q: When should I initialize with { 0 } vs {}?** 问：何时应使用 { 0 } 与 {} 进行初始化？
> 
> Use an explicit initialization value if you’re actually using that value.如果您实际使用的是显式初始化值，请使用该值。

```cpp
int x { 0 };    // explicit initialization to value 0
std::cout << x; // we're using that zero value
```

> Use value initialization if the value is temporary and will be replaced.如果值是临时的，并且将被替换，请使用值初始化。

```cpp
int x {};      // value initialization
std::cin >> x; // we're immediately replacing that value
```

TODO 这里格式需要调整
## Initialize your variables初始化变量
Initialize your variables upon creation. You may eventually find cases where you want to ignore this advice for a specific reason (e.g. a performance critical section of code that uses a lot of variables), and that’s okay, as long as the choice is made deliberately. 在创建变量时对其进行初始化。你可能最终会遇到一些特殊情况，需要出于特定原因忽略这一建议（例如，性能关键的代码段中使用了大量变量），这没问题，只要这个选择是经过慎重考虑的。

> **Related content** 相关内容
> 
> For more discussion on this topic, Bjarne Stroustrup (creator of C++) and Herb Sutter (C++ expert) make this recommendation themselves [here](https://github.com/isocpp/CppCoreGuidelines/blob/master/CppCoreGuidelines.md#es20-always-initialize-an-object).有关此主题的更多讨论，Bjarne Stroustrup（C++ 的创建者）和 Herb Sutter（C++ 专家[）在此处提出](https://github.com/isocpp/CppCoreGuidelines/blob/master/CppCoreGuidelines.md#es20-always-initialize-an-object)此建议。

We explore what happens if you try to use a variable that doesn’t have a well-defined value in lesson [1.6 -- Uninitialized variables and undefined behavior](https://www.learncpp.com/cpp-tutorial/uninitialized-variables-and-undefined-behavior/).我们将在第 [1.6 课 -- 未初始化的变量和未定义的行为](https://www.learncpp.com/cpp-tutorial/uninitialized-variables-and-undefined-behavior/)中探讨如果你尝试使用没有明确定义的值的变量会发生什么情况。

> **Best practice** 最佳实践
> 
> Initialize your variables upon creation.在创建时初始化变量。

## Initializing multiple variables初始化多个变量
In the last section, we noted that it is possible to define multiple variables _of the same type_ in a single statement by separating the names with a comma:在上一节中，我们注意到可以通过用逗号分隔名称来在单个语句中定义 _多个相同类型的_ 变量：

```cpp
int a, b;
```

We also noted that best practice is to avoid this syntax altogether. However, since you may encounter other code that uses this style, it’s still useful to talk a little bit more about it, if for no other reason than to reinforce some of the reasons you should be avoiding it.我们还注意到，最佳做法是完全避免这种语法。但是，由于您可能会遇到使用此样式的其他代码，因此多讨论一下它仍然很有用，如果不是其他原因，只是为了强调您应该避免使用它的一些原因。

You can initialize multiple variables defined on the same line:您可以初始化在同一行中定义的多个变量：

```cpp
int a = 5, b = 6;          // copy initialization
int c( 7 ), d( 8 );        // direct initialization
int e { 9 }, f { 10 };     // direct brace initialization
int g = { 9 }, h = { 10 }; // copy brace initialization
int i {}, j {};            // value initialization
```

Unfortunately, there’s a common pitfall here that can occur when the programmer mistakenly tries to initialize both variables by using one initialization statement:不幸的是，当程序员错误地尝试使用一个初始化语句来初始化这两个变量时，这里可能会发生一个常见的陷阱：TODO 翻译改善

```cpp
int a, b = 5; // wrong (a is not initialized!)

int a = 5, b = 5; // correct
```

In the top statement, variable “a” will be left uninitialized, and the compiler may or may not complain. If it doesn’t, this is a great way to have your program intermittently crash or produce sporadic results. We’ll talk more about what happens if you use uninitialized variables shortly.在 top 语句中，变量 “a” 将保持未初始化状态，编译器可能会也可能不会抱怨。如果没有，这是让您的程序间歇性崩溃或产生偶发结果的好方法。我们稍后将详细讨论如果您使用未初始化的变量会发生什么。

The best way to remember that this is wrong is to consider the case of direct initialization or brace initialization:记住这是错误的最好方法是考虑直接初始化或大括号初始化的情况：

```cpp
int a, b( 5 );
int c, d{ 5 };
```

Because the parenthesis or braces are typically placed right next to the variable name, this makes it seem a little more clear that the value 5 is only being used to initialize variable _b_ and _d_, not _a_ or _c_.因为括号或大括号通常放在变量名称的旁边，所以这使得值 5 仅用于初始化变量 _b_ 和 _d_，而不是 _a_ 或 _c_ 看起来更清楚一些。

## Unused initialized variables warnings未使用的初始化变量警告
Modern compilers will typically generate warnings if a variable is initialized but not used (since this is rarely desirable). And if “treat warnings as errors” is enabled, these warnings will be promoted to errors and cause the compilation to fail.如果变量已初始化但未使用，现代编译器通常会生成警告（因为这种情况很少可取）。如果启用了“将警告视为错误”，则这些警告将被提升为错误并导致编译失败。

Consider the following innocent looking program:考虑以下看起来无害的程序：

```cpp
int main()
{
    int x { 5 }; // variable defined

    // but not used anywhere

    return 0;
}
```

When compiling this with the g++ compiler, the following error is generated:使用 g++ 编译器编译此代码时，会生成以下错误：
``` text
prog.cc: In function 'int main()':
prog.cc:3:9: error: unused variable 'x' [-Werror=unused-variable]
```

and the program fails to compile.并且程序编译失败。

There are a few easy ways to fix this.有几种简单的方法可以解决这个问题。
1. If the variable really is unused, then the easiest option is to remove the definition of `x` (or comment it out). After all, if it’s not used, then removing it won’t affect anything.如果变量确实未使用，那么最简单的选择是删除 `x` 的定义（或将其注释掉）。毕竟，如果不使用它，那么删除它不会对任何事情产生任何影响。
2. Another option is to simply use the variable somewhere:另一种选择是简单地在某处使用变量：

```cpp
#include <iostream>

int main()
{
    int x { 5 };

    std::cout << x; // variable now used somewhere

    return 0;
}
```

But this requires some effort to write code that uses it, and has the downside of potentially changing your program’s behavior. 但这需要花费一定的精力来编写使用它的代码，并且可能带来改变程序行为的缺点。
## The `[[maybe_unused]]` attribute C++17`[[maybe_unused]]` 属性 C++17

In some cases, neither of the above options are desirable. Consider the case where we have a set of math/physics values that we use in many different programs: 在某些情况下，上述选项都不是理想的选择。考虑这样一个情况：我们有一组数学/物理值，需要在许多不同的程序中使用:

```cpp
#include <iostream>

int main()
{
    // Here's some math/physics values that we copy-pasted from elsewhere
    double pi { 3.14159 };
    double gravity { 9.8 };
    double phi { 1.61803 };

    std::cout << pi << '\n';
    std::cout << phi << '\n';

    // We're not using gravity in this program
    // The compiler will likely complain about gravity being defined but unused

    return 0;
}
```

If we use these values a lot, we probably have these saved somewhere and copy/paste/import them all together.如果我们经常使用这些值，我们可能会将它们保存在某个地方，然后一起复制/粘贴/导入它们。

However, in any program where we don’t use _all_ of these values, the compiler will likely complain about each variable that isn’t actually used. While we could go through and remove/comment out the unused ones for each program, this takes time and energy. And later if we need one that we’ve previously removed, we’ll have to go back and re-add it. 然而，在任何没有使用 _所有_ 这些值的程序中，编译器可能会对每个未实际使用的变量发出警告。虽然我们可以遍历并删除或注释掉每个程序中未使用的变量，但这会耗费时间和精力。而且，如果之后我们需要重新使用之前删除的变量，还得重新添加它们。

To address such cases, C++17 introduced the `[[maybe_unused]]` attribute, which allows us to tell the compiler that we’re okay with a variable being unused. The compiler will not generate unused variable warnings for such variables.为了解决这种情况，C++17 引入了 `[[maybe_unused]]` 属性，它允许我们告诉编译器，我们可以接受未使用的变量。编译器不会为此类变量生成未使用的变量警告。

The following program should generate no warnings/errors:以下程序不应生成任何警告/错误：

```cpp
#include <iostream>

int main()
{
    [[maybe_unused]] double pi { 3.14159 };
    [[maybe_unused]] double gravity { 9.8 };
    [[maybe_unused]] double phi { 1.61803 };

    std::cout << pi << '\n';
    std::cout << phi << '\n';

    // The compiler will no longer warn about gravity not being used

    return 0;
}
```

Additionally, the compiler will likely optimize these variables out of the program, so they have no performance impact.此外，编译器可能会在程序之外优化这些变量，因此它们不会影响性能。

The `[[maybe_unused]]` attribute should only be applied selectively to variables that have a specific and legitimate reason for being unused.`[[maybe_unused]]` 属性应仅选择性地应用于具有特定且合法的未使用原因的变量。

> **Author’s note** 作者注
> 
> In future lessons, we’ll often define variables we don’t use again, in order to demonstrate certain concepts. Making use of `[[maybe_unused]]` allows us to do so without compilation warnings/errors.在以后的课程中，我们通常会定义不再使用的变量以演示某些概念。使用 `[[maybe_unused]]` 可以让我们在没有编译警告/错误的情况下做到这一点。

## Quiz time测验时间
Question #1问题 #1

What is the difference between initialization and assignment?初始化和赋值有什么区别？

Hide Solution隐藏解决方案

Initialization gives a variable an initial value at the point when it is created. Assignment gives a variable a value at some point after the variable is created.初始化在创建变量时为其提供初始值。赋值在创建变量后的某个时间点为变量提供值。

Question #2问题 #2

What form of initialization should you prefer when you want to initialize a variable with a specific value?当您想用特定值初始化变量时，您应该更喜欢哪种形式的初始化？

Hide Solution隐藏解决方案

Direct list initialization (aka. direct brace initialization).直接列表初始化（又名直接大括号初始化）。

Question #3问题 #3

What are default initialization and value initialization? What is the behavior of each? Which should you prefer?什么是默认初始化和值初始化？每个的行为是什么？您应该更喜欢哪个？

Hide Solution隐藏解决方案

Default initialization is when a variable initialization has no initializer (e.g. `int x;`). In most cases, the variable is left with an indeterminate value.默认初始化是当变量初始化没有初始化器（例如 `int x;`）时。在大多数情况下，变量会留下一个不确定的值。

Value initialization is when a variable initialization has an empty brace (e.g. `int x{};`). In most cases this will perform zero-initialization.值初始化是指变量初始化具有空大括号（例如 `int x{};`）。在大多数情况下，这将执行零初始化。

You should prefer value initialization to default initialization.您应该更喜欢值初始化而不是默认初始化。
# 1.5 - Introduction to iostream: cout, cin, and endl
In this lesson, we’ll talk more about std::cout, which we used in our _Hello world!_ program to output the text _Hello world!_ to the console. We’ll also explore how to get input from the user, which we will use to make our programs more interactive.在本课中，我们将更多地讨论 std：：cout，我们在 _Hello world！_ 程序中使用它来将文本 _Hello world！_ 输出到控制台。我们还将探索如何从用户那里获取输入，我们将使用这些输入来提高程序的交互性。
## The input/output library 输入/输出库
The **input/output library** (io library) is part of the C++ standard library that deals with basic input and output. We’ll use the functionality in this library to get input from the keyboard and output data to the console. The _io_ part of _iostream_ stands for _input/output_.**输入/输出库**（io 库）是处理基本输入和输出的 C++ 标准库的一部分。我们将使用此库中的功能从键盘获取输入并将数据输出到控制台。_iostream_ 的 _io_ 部分代表 _输入/输出_ 。

To use the functionality defined within the _iostream_ library, we need to include the _iostream_ header at the top of any code file that uses the content defined in _iostream_, like so: 要使用 _iostream_ 库中定义的功能，我们需要在任何使用 _iostream_ 内容的代码文件顶部包含 _iostream_ 头文件，如下所示：

```cpp
#include <iostream>

// rest of code that uses iostream functionality here
```
## `std::cout`
The _iostream_ library contains a few predefined variables for us to use. One of the most useful is **std::cout**, which allows us to send data to the console to be printed as text. _cout_ stands for “character output”._iostream_ 库包含一些预定义的变量供我们使用。最有用的一个是 **`std::cout`**，它允许我们将数据发送到控制台以打印为文本。`cout` 代表 “character output”。

As a reminder, here’s our _Hello world_ program:提醒一下，这是我们的 _Hello world_ 程序：
```cpp
#include <iostream> // for std::cout

int main()
{
    std::cout << "Hello world!"; // print Hello world! to console

    return 0;
}
```

In this program, we have included _iostream_ so that we have access to _std::cout_. Inside our _main_ function, we use _std::cout_, along with the **insertion operator (`<<`)**, to send the text _Hello world!_ to the console to be printed.在这个程序中，我们包含了 `iostream`库，以便我们可以访问`std::cout`。在我们的`main`函数中，我们使用`std::cout`和插入运算符 （`<<`） 将文本  _Hello world!_ 发送到控制台进行打印。

_std::cout_ can not only print text, it can also print numbers: `std::cout`不仅可以打印文本，还可以打印数字：
```cpp
#include <iostream> // for std::cout

int main()
{
    std::cout << 4; // print 4 to console

    return 0;
}
```

This produces the result:这将产生结果：
``` text
4
```

It can also be used to print the value of variables:它也可以用于打印变量的值：
```cpp
#include <iostream> // for std::cout

int main()
{
    int x{ 5 }; // define integer variable x, initialized with value 5
    std::cout << x; // print value of x (5) to console
    return 0;
}
```

This produces the result:这将产生结果：
``` text
5
```

To print more than one thing on the same line, the insertion operator (`<<`) can be used multiple times in a single statement to concatenate (link together) multiple pieces of output. For example:要在同一行上打印多个内容，可以在单个语句中多次使用插入运算符 （`<<`） 来连接（链接在一起）多个输出。例如：

```cpp
#include <iostream> // for std::cout

int main()
{
    std::cout << "Hello" << " world!";
    return 0;
}
```

This program prints:该程序输出：

``` text
Hello world!
```

Here’s another example where we print both text and the value of a variable in the same statement:这是另一个示例，我们在同一语句中同时打印文本和变量的值：

```cpp
#include <iostream> // for std::cout

int main()
{
    int x{ 5 };
    std::cout << "x is equal to: " << x;
    return 0;
}
```

This program prints:程序输出：
``` text
x is equal to: 5
```

> **Related content** 相关内容
> 
> We discuss what the _std::_ prefix actually does in lesson [2.9 -- Naming collisions and an introduction to namespaces](https://www.learncpp.com/cpp-tutorial/naming-collisions-and-an-introduction-to-namespaces/).我们在[2.9课——命名冲突和命名空间简介](https://www.learncpp.com/cpp-tutorial/naming-collisions-and-an-introduction-to-namespaces/)中讨论`std::`前缀的实际作用。

## Using `std::endl` to output a newline使用 `std::endl` 输出换行符
What would you expect this program to print? 阅读下面这个程序你觉得会输出什么？

```cpp
#include <iostream> // for std::cout

int main()
{
    std::cout << "Hi!";
    std::cout << "My name is Alex.";
    return 0;
}
```

You might be surprised at the result:您可能会对结果感到惊讶：
``` text
Hi!My name is Alex.
```

Separate output statements don’t result in separate lines of output on the console. 的输出语句不会在控制台上产生单独的输出行。

If we want to print separate lines of output to the console, we need to tell the console to move the cursor to the next line. We can do that by outputting a newline. A **newline** is an OS-specific character or sequence of characters that moves the cursor to the start of the next line. 如果我们想要在控制台上打印出单独的输出行，需要告诉控制台将光标移动到下一行。我们可以通过输出一个换行符来实现。**换行符**是一个操作系统特定的字符或字符序列，它将光标移动到下一行的开头。

One way to output a newline is to output `std::endl` (which stands for “end line”):输出换行符的一种方法是输出 `std::endl` （代表“结束行”）：

```cpp
#include <iostream> // for std::cout and std::endl

int main()
{
    std::cout << "Hi!" << std::endl; // std::endl will cause the cursor to move to the next line
    std::cout << "My name is Alex." << std::endl;

    return 0;
}
```

This prints:这打印：
``` text
Hi!
My name is Alex.
```

> **Tip** 提示
> 
> In the above program, the second `std::endl` isn’t technically necessary, since the program ends immediately afterward. However, it serves a few useful purposes.在上面的程序中，第二个 `std::endl` 在技术上不是必需的，因为程序随后立即结束。然而，它有一些有用的目的。
> 
> First, it helps indicate that the line of output is a “complete thought” (as opposed to partial output that is completed somewhere later in the code). In this sense, it functions similarly to using a period in standard English.首先，它有助于表明输出行是一个“完整的想法”（而不是在代码后面的某个地方完成的部分输出）。从这个意义上说，它的功能类似于标准英语中使用句号。
> 
> Second, it positions the cursor on the next line, so that if we later add additional lines of output (e.g. have the program say “bye!”), those lines will appear where we expect (rather than appended to the prior line of output).其次，它将光标定位在下一行，这样如果我们稍后添加额外的输出行（例如让程序说“再见！”），这些行将出现在我们期望的位置（而不是附加到输出的前一行的后面）。
> 
> Third, after running an executable from the command line, some operating systems do not output a new line before showing the command prompt again. If our program does not end with the cursor on a new line, the command prompt may appear appended to the prior line of output, rather than at the start of a new line as the user would expect.第三，在命令行中运行可执行文件后，某些操作系统在再次显示命令提示符之前不会输出新行。如果我们的程序没有以光标在新行上结束，则命令提示符可能会附加到输出的前一行，而不是像用户期望的那样出现在新行的开头。

> **Best practice** 最佳实践
> 
> Output a newline whenever a line of output is complete.每当一行输出完成时，输出换行符。

## `std::cout` is buffered `std::cout` 是缓冲输出的

Consider a rollercoaster ride at your favorite amusement park. Passengers show up (at some variable rate) and get in line. Periodically, a train arrives and boards passengers (up to the maximum capacity of the train). When the train is full, or when enough time has passed, the train departs with a batch of passengers, and the ride commences. Any passengers unable to board the current train wait for the next one. 可以把它想象成你最喜欢的游乐园的过山车之旅。乘客们（以不同的速率）陆续到达并排队等待。周期性地，会有一列过山车到达，载上乘客（直到车的最大容量）。当车满员，或者经过足够的时间后，车就会载着一批乘客出发，开始旅程。而那些没能赶上这趟车的乘客则需要等待下一趟车。

This analogy is similar to how output sent to `std::cout` is typically processed in C++. Statements in our program request that output be sent to the console. However, that output is typically not sent to the console immediately. Instead, the requested output “gets in line”, and is stored in a region of memory set aside to collect such requests (called a **buffer**). Periodically, the buffer is **flushed**, meaning all of the data collected in the buffer is transferred to its destination (in this case, the console).此类比类似于在 C++ 中通常如何处理发送到 `std::cout` 的输出。我们程序中的语句请求将输出发送到控制台。但是，该输出通常不会立即发送到控制台。相反，请求的输出“排队”，并存储在专门用于收集此类请求的内存区域中（称为**缓冲区**）。缓冲区会定期**刷新**，这意味着缓冲区中收集的所有数据都会传输到其目的地（在本例中为控制台）。

> **Author’s note** 作者注
> 
> To use another analogy, flushing a buffer is kind of like flushing a toilet. All of your collected “output” is transferred to … wherever it goes next. Eew. 换个比喻，刷新缓冲区就像冲马桶一样。你所有积累的“输出”都会被传送到……它接下来该去的地方。呃。

This also means that if your program crashes, aborts, or is paused (e.g. for debugging purposes) before the buffer is flushed, any output still waiting in the buffer will not be displayed.这也意味着，如果您的程序在刷新缓冲区之前崩溃、中止或暂停（例如出于调试目的），则缓冲区中仍在等待的任何输出都不会显示。

> **Key insight** 关键见解
> 
> The opposite of buffered output is unbuffered output. With unbuffered output, each individual output request is sent directly to the output device. 与缓冲输出相反的是非缓冲输出。在非缓冲输出中，每个单独的输出请求都会直接发送到输出设备。
> 
> Writing data to a buffer is typically fast, whereas transferring a batch of data to an output device is comparatively slow. Buffering can significantly increase performance by batching multiple output requests together to minimize the number of times output has to be sent to the output device. 将数据写入缓冲区通常很快，而将一批数据传输到输出设备相对较慢。通过将多个输出请求批量处理在一起，缓冲可以显著提高性能，从而减少输出需要发送到输出设备的次数。

## `std::endl` vs `\n` `std::endl` 与 `\n`

Using `std::endl` is often inefficient, as it actually does two jobs: it outputs a newline (moving the cursor to the next line of the console), and it flushes the buffer (which is slow). If we output multiple lines of text ending with `std::endl`, we will get multiple flushes, which is slow and probably unnecessary.使用 `std::endl` 通常效率很低，因为它实际上执行两项工作：输出换行符（将光标移动到控制台的下一行），并刷新缓冲区（速度很慢） 。如果我们输出多行以 `std::endl` 结尾的文本，我们将得到多次刷新，这很慢而且可能是不必要的。

When outputting text to the console, we typically don’t need to explicitly flush the buffer ourselves. C++’s output system is designed to self-flush periodically, and it’s both simpler and more efficient to let it flush itself.当将文本输出到控制台时，我们通常不需要自己显式刷新缓冲区。 C++ 的输出系统被设计为定期自刷新，让它自行刷新既简单又高效。

To output a newline without flushing the output buffer, we use `\n` (inside either single or double quotes), which is a special symbol that the compiler interprets as a newline character. `\n` moves the cursor to the next line of the console without causing a flush, so it will typically perform better. `\n` is also more concise to type and can be embedded into existing double-quoted text.要输出换行符而不刷新输出缓冲区，我们使用 `\n` （在单引号或双引号内），这是编译器将其解释为换行符的特殊符号。 `\n` 将光标移动到控制台的下一行，而不会导致刷新，因此通常会表现得更好。 `\n` 的输入也更加简洁，并且可以嵌入到现有的双引号文本中。

Here’s an example that uses `\n` in a few different ways:下面是一个以几种不同方式使用 `\n` 的示例：

```cpp
#include <iostream> // for std::cout

int main()
{
    int x{ 5 };
    std::cout << "x is equal to: " << x << '\n'; // single quoted (by itself) (conventional)
    std::cout << "Yep." << "\n";                 // double quoted (by itself) (unconventional but okay)
    std::cout << "And that's all, folks!\n";     // between double quotes in existing text (conventional)
    return 0;
}
```

This prints:这打印：
``` text
x is equal to: 5
Yep.
And that's all, folks!
```

When `\n` is not being embedded into an existing line of double-quoted text (e.g. `"hello\n")`, it is conventionally single quoted (`'\n'`).当 `\n` 未嵌入到现有的双引号文本行中（例如 `"hello\n")` 时，它通常是单引号 (`'\n'`）。

> **For advanced readers** 对于高级读者
> 
> In C++, we use single quotes to represent single characters (such as `'a'` or `'$'`), and double-quotes to represent text (zero or more characters).在C++中，我们使用单引号来表示单个字符（例如`'a'`或`'$'`），使用双引号来表示文本（零个或多个字符） 。
> 
> Even though ‘\n’ is represented in source code as two symbols, it is treated by the compiler as a single linefeed (LF) character (with ASCII value 10), and thus is conventionally single quoted (unless embedded into existing double-quoted text). We discuss this more in lesson [4.11 -- Chars](https://www.learncpp.com/cpp-tutorial/chars/).尽管 '\n' 在源代码中表示为两个符号，但编译器将其视为单个换行 (LF) 字符（ASCII 值为 10），因此通常是单引号的（除非嵌入到现有的双引号中）文本）。我们将在[4.11——字符](https://www.learncpp.com/cpp-tutorial/chars/)课中对此进行更多讨论。
> 
> When `\n` is output, the library doing the outputting is responsible for translating this single LF character into the appropriate newline sequence for the given OS. See [Wikipedia](https://en.wikipedia.org/wiki/Newline) for more information on OS conventions for newlines.当输出`\n`时，执行输出的库负责将这个单个 LF 字符转换为给定操作系统的适当换行序列。有关换行符的操作系统约定的更多信息，请参阅[维基百科](https://en.wikipedia.org/wiki/Newline)。

> **Author’s note** 作者注
> 
> Although unconventional, we believe it’s fine to use (or even prefer) double quoted `"\n"` in standard output statements.尽管非常规，但我们相信在标准输出语句中使用（甚至更喜欢）双引号 `"\n"` 是可以的。
> 
> This has two primary benefits:这有两个主要好处:
> 
> 1. It’s simpler to double-quote all outputted text rather than having to determine what should be single-quoted and double-quoted.对所有输出的文本加双引号比必须确定哪些内容应该用单引号引起来更简单。
> 
> 2. More importantly, it helps avoid inadvertent multicharacter literals. We cover multicharacter literals and some of the unexpected output they can cause in lesson [4.11 -- Chars](https://www.learncpp.com/cpp-tutorial/chars/).更重要的是，它有助于避免无意的多字符文字。我们在课程 [4.11 -- Chars](https://www.learncpp.com/cpp-tutorial/chars/) 中介绍了多字符文字以及它们可能导致的一些意外输出。
> 
> Single quotes should be preferred in non-output cases.在非输出情况下应首选单引号。

We’ll cover what ‘\n’ is in more detail when we get to the lesson on chars ([4.11 -- Chars](https://www.learncpp.com/cpp-tutorial/chars/)).当我们学习字符课程时（[4.11 -- Chars](https://www.learncpp.com/cpp-tutorial/chars/)），我们将更详细地介绍“\n”的含义。

> **Best practice** 最佳实践
> 
> Prefer `\n` over `std::endl` when outputting text to the console.将文本输出到控制台时，优先使用 `\n` 而不是 `std::endl`。

> **Warning** 警告
> 
> `'\n'` uses a backslash (as do all special characters in C++), not a forward slash.`'\n'` 使用反斜杠（C++ 中的所有特殊字符也是如此），而不是正斜杠。
> 
> Using a forward slash (e.g. `'/n'`) or including other characters inside the single quotes (e.g. `' \n'` or `'.\n'`) will result in unexpected behavior. For example, `std::cout << '/n';` will often print as `12142`, which probably isn’t what you were expecting.使用正斜杠（例如 `'/n'`）或在单引号内包含其他字符（例如 `' \n'` 或 `'.\n'`) 将导致意外行为。例如， `std::cout << '/n';` 通常会打印为 `12142`，这可能不是您所期望的。

## `std::cin`
`std::cin` is another predefined variable in the `iostream` library. Whereas `std::cout` prints data to the console (using the insertion operator `<<` to provide the data), `std::cin` (which stands for “character input”) reads input from keyboard. We typically use the extraction operator `>>` to put the input data in a variable (which can then be used in subsequent statements).`std::cin` 是 `iostream` 库中的另一个预定义变量 TODO真的不是函数吗？。 `std::cout` 将数据打印到控制台（使用插入运算符 `<<` 提供数据），`std::cin` （其中代表“字符输入”）从键盘读取输入。我们通常使用提取运算符 `>>` 将输入数据放入变量中（然后可以在后续语句中使用）。

```cpp
#include <iostream>  // for std::cout and std::cin

int main()
{
    std::cout << "Enter a number: "; // ask user for a number

    int x{};       // define variable x to hold user input (and value-initialize it)
    std::cin >> x; // get number from keyboard and store it in variable x

    std::cout << "You entered " << x << '\n';
    return 0;
}
```

  
Try compiling this program and running it for yourself. When you run the program, line 5 will print “Enter a number: “. When the code gets to line 8, your program will wait for you to enter input. Once you enter a number (and press enter), the number you enter will be assigned to variable `x`. Finally, on line 10, the program will print “You entered ” followed by the number you just entered.尝试自己编译该程序并运行它。运行程序时，第 5 行将打印“Enter a number:”。当代码到达第 8 行时，你的程序将等待你输入。输入数字（并按 Enter 键）后，您输入的数字将分配给变量 `x`。最后，在第 10 行，程序将打印“You Enter”，后跟您刚刚输入的数字。

For example (entering the value 4 as input):例如（输入值 4 作为输入）：
``` text
Enter a number: 4
You entered 4
```

This is an easy way to get keyboard input from the user, and we will use it in many of our examples going forward.这是从用户获取键盘输入的简单方法，我们将在以后的许多示例中使用它。

> **Tip** 提示
> 
> Note that you don’t need to output `'\n'` when accepting a line of input, as the user will need to press the _enter_ key to have their input accepted, and this will move the cursor to the next line of the console. 请注意，当接受一行输入时，你不需要输出 `'\n'`，因为用户需要按下 _Enter_ 键来确认输入，这将自动把光标移动到控制台的下一行。
> 
> If your screen closes immediately after entering a number, please see lesson [0.8 -- A few common C++ problems](https://www.learncpp.com/cpp-tutorial/a-few-common-cpp-problems/) for a solution.如果您的屏幕在输入数字后立即关闭，请参阅课程[0.8 -- 一些常见的C++问题](https://www.learncpp.com/cpp-tutorial/a-few-common-cpp-problems/)以获取解决方案。

Just like it is possible to output more than one bit of text in a single line, it is also possible to input more than one value on a single line:就像可以在一行中输出多于一位文本一样，也可以在一行中输入多个值：

```cpp
#include <iostream>  // for std::cout and std::cin

int main()
{
    std::cout << "Enter two numbers separated by a space: ";

    int x{}; // define variable x to hold user input (and value-initialize it)
    int y{}; // define variable y to hold user input (and value-initialize it)
    std::cin >> x >> y; // get two numbers and store in variable x and y respectively

    std::cout << "You entered " << x << " and " << y << '\n';

    return 0;
}
```

This produces the output:这会产生输出：

``` text
Enter two numbers separated by a space: 5 6
You entered 5 and 6
```

Values entered should be separated by whitespace (spaces, tabs, or newlines).输入的值应以空格（空格、制表符或换行符）分隔。

> **Key insight** 关键见解
> 
> There’s some debate over whether it’s necessary to initialize a variable immediately before you give it a user provided value via another source (e.g. std::cin), since the user-provided value will just overwrite the initialization value. In line with our previous recommendation that variables should always be initialized, best practice is to initialize the variable first.关于是否有必要在通过另一个源（例如 std::cin）向变量提供用户提供的值之前立即初始化变量存在一些争议，因为用户提供的值只会覆盖初始化值。根据我们之前关于变量应始终初始化的建议，最佳实践是首先初始化变量。

> **For advanced readers** 对于高级读者
> 
> The C++ I/O library does not provide a way to accept keyboard input without the user having to press _enter_. If this is something you desire, you’ll have to use a third party library. For console applications, we’d recommend [pdcurses](https://pdcurses.org/), [FXTUI](https://github.com/ArthurSonzogni/FTXUI), [cpp-terminal](https://github.com/jupyter-xeus/cpp-terminal), or [notcurses](https://github.com/dankamongmen/notcurses). Many graphical user interface libraries have their own functions to do this kind of thing.C++ I/O 库不提供无需用户按 _enter_ 即可接受键盘输入的方法。如果这是您想要的，则必须使用第三方库。对于控制台应用程序，我们建议使用 [pdcurses](https://pdcurses.org/)、[FXTUI](https://github.com/ArthurSonzogni/FTXUI)、[cpp-terminal](https://github.com/jupyter-xeus/cpp-terminal) 或 [notcurses](https://github.com/dankamongmen/notcurses)。许多图形用户界面库都有自己的函数来完成这种事情。

## `std::cin` is buffered `std::cin` 是缓冲输入的
In a prior section, we noted that outputting data is actually a two stage process:在上一节中，我们注意到输出数据实际上是一个两个阶段的过程：
- The data from each output request is added (to the end) of an output buffer.来自每个输出请求的数据被添加（到末尾）输出缓冲区。
- Later, data from (the front of) the output buffer is flushed to the output device (the console).随后，来自输出缓冲区（前面）的数据将刷新到输出设备（控制台）。

> **Key insight** 关键见解
> 
> Adding data to the end of a buffer and removing it from the front of a buffer ensures data is processed in the same order in which it was added. This is sometimes called FIFO (first in, first out).将数据添加到缓冲区的末尾并将其从缓冲区的前面删除可确保按照添加数据的顺序处理数据。这有时称为 FIFO（先进先出 first in first out）。

Similarly, inputting data is also a two stage process:同样，输入数据也是一个两阶段过程：
- The individual characters you enter as input are added to the end of an input buffer (inside `std::cin`). The enter key (pressed to submit the data) is also stored as a `'\n'` character.您输入的各个字符将添加到输入缓冲区的末尾（在 `std::cin` 内）。 Enter 键（按下以提交数据）也存储为 `'\n'` 字符。
- The extraction operator ‘>>’ removes characters from the front of the input buffer and converts them into a value that is assigned to the associated variable. This variable can then be used in subsequent statements.提取运算符“>>”从输入缓冲区的前面删除字符并将它们转换为分配给关联变量的值。然后可以在后续语句中使用该变量。

> **Key insight** 关键见解
> 
> Each line of input data in the input buffer is terminated by a `'\n'` character.输入缓冲区中的每行输入数据均以 `'\n'` 字符终止。

We’ll demonstrate this using the following program:我们将使用以下程序来演示这一点：

```cpp
#include <iostream>  // for std::cout and std::cin

int main()
{
    std::cout << "Enter two numbers: ";

    int x{};
    std::cin >> x;

    int y{};
    std::cin >> y;

    std::cout << "You entered " << x << " and " << y << '\n';

    return 0;
}
```

This program inputs to two variables (this time as separate statements). We’ll run this program twice.该程序输入两个变量（这次作为单独的语句）。我们将运行该程序两次。

Run #1: When `std::cin >> x;` is encountered, the program will wait for input. Enter the value `4`. The input `4\n` goes into the input buffer, and the value `4` is extracted to variable `x`.运行#1：当遇到`std::cin >> x;`时，程序将等待输入。输入值`4`。输入 `4\n` 进入输入缓冲区，值 `4` 被提取到变量 `x` 中。

When `std::cin >> y;` is encountered, the program will again wait for input. Enter the value `5`. The input `5\n` goes into the input buffer, and the value `5` is extracted to variable `y`. Finally, the program will print `You entered 4 and 5`.当遇到`std::cin >> y;`时，程序将再次等待输入。输入值`5`。输入 `5\n` 进入输入缓冲区，值 `5` 被提取到变量 `y` 中。最后，程序将打印`You entered 4 and 5`。

There should be nothing surprising about this run.这次运行应该没有什么令人惊讶的。

Run #2: When `std::cin >> x` is encountered, the program will wait for input. Enter `4 5`. The input `4 5\n` goes into the input buffer, but only the `4` is extracted to variable `x` (extraction stops at the space).运行#2：当遇到`std::cin >> x`时，程序将等待输入。输入`4 5`。输入 `4 5\n` 进入输入缓冲区，但只有 `4` 被提取到变量 `x` （提取在空格处停止）。

When `std::cin >> y` is encountered, the program will _not_ wait for input. Instead, the `5` that is still in the input buffer is extracted to variable `y`. The program then prints `You entered 4 and 5`.当遇到`std::cin >> y`时，程序将**不**等待输入。相反，仍在输入缓冲区中的 `5` 被提取到变量 `y` 中。然后程序打印 `You entered 4 and 5`。

Note that in run 2, the program didn’t wait for the user to enter additional input when extracting to variable `y` because there was already prior input in the input buffer that could be used.请注意，在运行 2 中，程序在提取到变量 `y` 时并没有等待用户输入其他输入，因为输入缓冲区中已经有可以使用的先前输入。

> **Key insight** 关键见解
> 
> `std::cin` is buffered because it allows us to separate the entering of input from the extract of input. We can enter input once and then perform multiple extraction requests on it.`std::cin` 被缓冲，因为它允许我们将输入的输入与输入的提取分开。我们可以输入一次，然后对其执行多个提取请求。

## The basic extraction process 基本提取过程
Here’s a simplified view of how operator `>>` works for input:以下是运算符 `>>` 如何用于输入的简化视图：

1. First, leading whitespace (spaces, tabs, and newlines at the front of the buffer) is discarded from the input buffer. This will discard any unextracted newline character remaining from a prior line of input.首先，从输入缓冲区中丢弃前导空白（缓冲区前面的空格、制表符和换行符）。这将丢弃前一行输入中剩余的任何未提取的换行符。
2. If the input buffer is now empty, operator `>>` will wait for the user to enter more data. Leading whitespace is again discarded.如果输入缓冲区现在为空，则运算符 `>>` 将等待用户输入更多数据。前导空格再次被丢弃。
3. operator `>>` then extracts as many consecutive characters as it can, until it encounters either a newline character (representing the end of the line of input) or a character that is not valid for the variable being extracted to.然后，运算符 `>>` 提取尽可能多的连续字符，直到遇到换行符（表示输入行的结尾）或对于提取到的变量无效的字符。

The result of the extraction is as follows:提取结果如下：

- If any characters were extracted in step 3 above, extraction is a success. The extracted characters are converted into a value that is then assigned to the variable.如果在上述步骤3中提取到任何字符，则提取成功。提取的字符将转换为值，然后分配给变量。
- If no characters could be extracted in step 3 above, extraction has failed. The object being extracted to is assigned the value `0` (as of C++11), and any future extractions will immediately fail (until `std::cin` is cleared).如果在上述步骤3中无法提取字符，则提取失败。被提取到的对象被分配值 `0` （从 C++11 开始），任何未来的提取都将立即失败（直到 `std::cin` 被清除）。

Any non-extracted characters (including newlines) remain available for the next extraction attempt.任何未提取的字符（包括换行符）仍可用于下一次提取尝试。

> **Related content** 相关内容
> 
> We discuss how to detect and handle extraction failures, handle extraneous input, and clear `std::cin` in lesson [9.5 -- std::cin and handling invalid input](https://www.learncpp.com/cpp-tutorial/stdcin-and-handling-invalid-input/).我们在课程 [9.5 -- std::cin 和处理无效输入](https://www.learncpp.com/cpp-tutorial/stdcin-and-handling-invalid-input/) 中讨论如何检测和处理提取失败、处理无关输入以及清除 `std::cin`。

For example, given the following snippet:例如，给出以下代码片段：

```cpp
int x{};
std::cin >> x;
```

If the user types `5a` and enter, `5a\n` will be added to the buffer. `5` will be extracted, converted to an integer, and assigned to variable `x`. `a\n` will be left in the input buffer for the next extraction.如果用户输入 `5a` 并回车，`5a\n` 将被添加到缓冲区中。 `5` 将被提取，转换为整数，并分配给变量 `x`。 `a\n` 将保留在输入缓冲区中以供下次提取。

If the user types ‘b’ and enter, `b\n` would be added to the buffer. Because `b` is not a valid integer, no characters can be extracted, so this is an extraction failure. Variable `x` would be set to `0`, and future extractions will fail until the input stream is cleared.如果用户输入“b”并回车，`b\n` 将被添加到缓冲区中。由于 `b` 不是有效整数，因此无法提取任何字符，因此这是提取失败。变量 `x` 将设置为 `0`，并且在清除输入流之前，未来的提取将失败。

We’ll explore more cases in the quiz below.我们将在下面的测验中探索更多案例。
## `operator<<` vs `operator>>`
New programmers often mix up `std::cin`, `std::cout`, the insertion operator (`<<`) and the extraction operator (`>>`). Here’s an easy way to remember:新程序员经常混淆 `std::cin`、`std::cout`、插入运算符 (`<<`) 和提取运算符 (`>>`）。这是一个简单的记住方法：

- `std::cin` and `std::cout` always go on the left-hand side of the operator.`std::cin` 和 `std::cout` 始终位于运算符的左侧。
- `std::cout` is used to output a value (cout = character output).`std::cout` 用于输出一个值（cout = 字符输出）。
- `std::cin` is used to get an input value (cin = character input).`std::cin` 用于获取输入值（cin = 字符输入）。
- `<<` is used with `std::cout`, and shows the direction that data is moving. `std::cout << 4` moves the value `4` to the console.`<<` 与 `std::cout` 一起使用，显示数据移动的方向。 `std::cout << 4` 将值 `4` 移动到控制台。
- `>>` is used with `std::cin`, and shows the direction that data is moving. `std::cin >> x` moves the value the user entered from the keyboard into variable `x`.`>>` 与 `std::cin` 一起使用，显示数据移动的方向。 `std::cin >> x` 将用户从键盘输入的值移动到变量 `x` 中。

We’ll talk more about operators in lesson [1.9 -- Introduction to literals and operators](https://www.learncpp.com/cpp-tutorial/introduction-to-literals-and-operators/).我们将在[1.9——文字和运算符简介](https://www.learncpp.com/cpp-tutorial/introduction-to-literals-and-operators/)课程中详细讨论运算符。

## Quiz time问答时间

Question #1问题#1

Consider the following program that we used above:考虑我们上面使用的以下程序：

```cpp
#include <iostream>  // for std::cout and std::cin

int main()
{
    std::cout << "Enter a number: "; // ask user for a number
    int x{}; // define variable x to hold user input
    std::cin >> x; // get number from keyboard and store it in variable x
    std::cout << "You entered " << x << '\n';

    return 0;
}
```

The program expects you to enter an integer value, as the variable `x` that the user input will be put into is an integer variable.该程序希望您输入一个整数值，因为用户输入将放入的变量 `x` 是一个整数变量。

Run this program multiple times and describe the output that results when you enter the following types of input:多次运行该程序并描述输入以下类型的输入时产生的输出：

a) A letter, such as `h`.a) 一个字母，例如`h`。

Hide Solution隐藏解决方案

Result: 0 is always printed.结果：始终打印 0。  
What’s happening: An integer can’t hold a letter, so extraction completely fails.发生了什么：整数无法容纳字母，因此提取完全失败。`x` is assigned the value 0.`x` 被赋予值 0。

b) A number with a fractional part (e.g. `3.2`). Try numbers with fractional parts less than 0.5 and greater than 0.5 (e.g. `3.2` and `3.7`).b) 带有小数部分的数字（例如 `3.2`）。尝试小数部分小于 0.5 和大于 0.5 的数字（例如 `3.2` 和 `3.7`）。

Hide Solution隐藏解决方案

Result: The fractional part is dropped (not rounded).结果：小数部分被舍去（不四舍五入）。  
What’s happening: Given the number发生了什么：给定数字`3.2`, the `3` gets extracted, but `.` is an invalid character, so extraction stops here. The `.2` remains for a future extraction attempt.`3.2`，`3` 被提取，但 `.` 是无效字符，因此提取在此停止。 `.2` 保留用于将来的提取尝试。

c) A small negative integer, such as `-3`.c) 一个小的负整数，例如`-3`。

Hide Solution隐藏解决方案

Result: The entered number is output.结果：输出输入的数字。  
What’s happening: A minus sign at the beginning of a number is acceptable, so it is extracted. The remaining numbers are extracted as well.发生了什么：数字开头的减号是可以接受的，因此它被提取出来。剩余的数字也被提取。

d) A word, such as `Hello`.d) 一个单词，例如`Hello`。

Hide Solution隐藏解决方案

Result: 0 is always printed.结果：始终打印 0。  
What’s happening: An integer can’t hold a letter, so extraction completely fails.发生了什么：整数无法容纳字母，因此提取完全失败。`x` is assigned the value 0.`x` 被赋予值 0。

e) A really big number (at least 3 billion).e) 一个非常大的数字（至少 30 亿）。

Hide Solution隐藏解决方案

Result: You are most likely to get the number `2147483647`.结果：您最有可能获得号码 `2147483647`。  
What’s happening:发生了什么：`x` can only hold numbers up to a certain size. If you enter a value larger than the largest number `x` can hold, it will be set to the largest number that `x` can hold (which is probably `2147483647`, but might be different on your system). We discuss this further in lesson [4.4 -- Signed integers](https://www.learncpp.com/cpp-tutorial/signed-integers/).`x` 只能容纳特定大小的数字。如果您输入的值大于`x`可以容纳的最大数字，它将被设置为`x`可以容纳的最大数字（可能是`2147483647`，但在您的系统上可能有所不同）。我们在[4.4——有符号整数](https://www.learncpp.com/cpp-tutorial/signed-integers/)课中进一步讨论这个问题。

f) A small number followed by some letters, such as `123abc`.f) 一个小数字后跟一些字母，例如 `123abc`。

Hide Solution隐藏解决方案

Result: The numeric values are printed (e.g. 123).结果：打印数值（例如 123）。  
What’s happening:发生了什么：`123` is extracted, the remaining characters (e.g. `abc`) are left for a later extraction.`123` 被提取，其余字符（例如 `abc`）留待以后提取。

g) A few letters followed by a small number, such as `abc123`.g) 几个字母后跟一个小数字，例如`abc123`。

Hide Solution隐藏解决方案

Result: 0 is always printed.结果：始终打印 0。  
What’s happening: An integer can’t hold a letter, so extraction completely fails.发生了什么：整数无法容纳字母，因此提取完全失败。`x` is assigned the value 0.`x` 被赋予值 0。

h) `+5` (three spaces, followed by a plus symbol, and a 5).h) `+5`（三个空格，后跟一个加号和一个 5）。

Hide Solution隐藏解决方案

Result: 5 is printed.结果：打印 5。  
What’s happening: The leading whitespace is skipped. Plus is a valid symbol at the start of a number (just as a minus sign would be), so it is extracted. The 5 is also extracted.发生了什么：跳过前导空格。加号是数字开头的有效符号（就像减号一样），因此它被提取。 5 也被提取出来。

h) `5b6`.

Hide Solution隐藏解决方案

Result: 5 is printed.结果：打印 5。  
What’s happening:发生了什么：`5` is extracted. `b` is invalid, so extraction stops here. The `b6` remains for a future extraction attempt.`5` 被提取。 `b` 无效，因此提取在此停止。 `b6` 保留用于将来的提取尝试。

Question #2问题#2

Ask the user to enter three values. The program should then print these values. Add an appropriate comment above function `main()`.要求用户输入三个值。然后程序应该打印这些值。在函数 `main()` 上方添加适当的注释。

The program should match the following output (when run with input values `4`, `5`, and `6`):该程序应匹配以下输出（当使用输入值 `4`、`5` 和 `6` 运行时）：

Enter three numbers: 4 5 6
You entered 4, 5, and 6.

Hint: Comments above a function should describe _what_ the function does.提示：函数上方的注释应描述该函数的_内容_。

Hint: Make sure you’re double quoting your output.提示：确保对输出进行双引号。

Hide Solution隐藏解决方案

```cpp
#include <iostream>

// Asks the user to enter three values and then print those values as a sentence.
int main()
{
    std::cout << "Enter three numbers: ";

    int x{};
    int y{};
    int z{};
    std::cin >> x >> y >> z;

    std::cout << "You entered " << x << ", " << y << ", and " << z << ".\n";

    return 0;
}
```

Note that `".\n"` must be double-quoted since we’re outputting more than one character.请注意，`".\n"` 必须用双引号引起来，因为我们要输出多个字符。

# 1.6 Uninitialized variables and undefined behavior 未初始化变量和未定义行为
## 未初始化变量
与一些编程语言不同，C/C++不会自动将大多数变量初始化为给定值（例如零）。当一个未初始化的变量被分配内存地址来存储数据时，该变量的默认值是该内存地址中已经存在的任何（垃圾）值！尚未被赋予已知值（通过初始化或赋值）的变量称为未初始化变量。

> 术语说明
> 
> 许多读者期望"已初始化"和"未初始化"这两个术语是严格的对立面，但实际上并非如此！在通常的语言中，"已初始化"意味着对象在定义点被提供了初始值。"未初始化"意味着对象尚未被赋予已知值（通过任何方式，包括赋值）。因此，一个未在定义时初始化但随后被赋值的对象不再是未初始化的（因为它已被赋予了已知值）。
> 
> 总结一下：
> 
> - 初始化 = 对象在定义点被赋予已知值。
> - 赋值 = 对象在定义点之后被赋予已知值。
> - 未初始化 = 对象尚未被赋予已知值。
> 
> 相关地，考虑以下变量定义：
> 
```cpp
int x;
```
TODO 格式问题
> 
> 在[[#1.4 Variable assignment and initialization 变量赋值和初始化]]中，我们注意到当没有提供初始化器时，变量被默认初始化。在大多数情况下（如本例），默认初始化不执行实际的初始化。因此我们说x是未初始化的。我们关注的是结果（对象尚未被赋予已知值），而不是过程。

> 顺便说一下… 
> 
> 这种缺乏初始化的做法是从C语言继承来的性能优化，那时计算机速度很慢。想象一个你要从文件中读取100,000个值的情况。在这种情况下，你可能会创建100,000个变量，然后用文件中的数据填充它们。
> 
> 如果C++在创建时用默认值初始化所有这些变量，这将导致100,000次初始化（这将会很慢），而收益很小（因为你无论如何都要覆盖这些值）。
> 
> 目前，你应该始终初始化你的变量，因为这样做的成本与收益相比是微不足道的。一旦你对语言更加熟悉，可能会有某些情况下你出于优化目的而省略初始化。但这应该始终是有选择性和有意识的。

使用未初始化变量的值可能会导致意想不到的结果。考虑以下简短程序：

```cpp
#include <iostream>

int main()
{
    // 定义一个名为x的整数变量
    int x; // 这个变量是未初始化的，因为我们没有给它赋值

    // 将x的值打印到屏幕上
    std::cout << x << '\n'; // 谁知道我们会得到什么，因为x是未初始化的

    return 0;
}
```

在这种情况下，计算机会为x分配一些未使用的内存。然后它会将该内存位置中的值发送给`std::cout`，后者将打印该值（解释为整数）。但它会打印什么值呢？答案是"谁知道！"，而且每次运行程序时答案可能（也可能不会）改变。当作者在Visual Studio中运行这个程序时，`std::cout`第一次打印了`7177728`，下一次打印了`5277592`。你可以自己编译和运行这个程序（你的计算机不会爆炸）。

> **警告**
>
> 一些编译器，如Visual Studio，在使用调试构建配置时会将内存内容初始化为某个预设值。在使用发布构建配置时不会发生这种情况。因此，如果你想自己运行上面的程序，确保你使用的是发布构建配置（参见[[Chapter 0 - Introduction Getting Started#0.9 Configuring your compiler Build configurations]]，以回顾如何做到这一点）。例如，如果你在Visual Studio的调试配置中运行上面的程序，它会一致地打印-858993460，因为这是Visual Studio在调试配置中初始化内存的值（解释为整数）。

大多数现代编译器会尝试检测变量是否在未被赋值的情况下使用。如果它们能够检测到这一点，通常会发出编译时警告或错误。例如，在Visual Studio上编译上述程序产生了以下警告：

```
c:\VCprojects\test\test.cpp(11) : warning C4700: uninitialized local variable 'x' used
```

如果你的编译器不允许你编译和运行上述程序（例如，因为它将该问题视为错误），这里有一个可能的解决方案来绕过这个问题：

```cpp
#include <iostream>

void doNothing(int&) // 现在不要担心&是什么，我们只是用它来欺骗编译器认为变量x被使用了
{
}

int main()
{
    // 定义一个名为x的整数变量
    int x; // 这个变量是未初始化的

    doNothing(x); // 让编译器认为我们正在给这个变量赋值

    // 将x的值打印到屏幕上（谁知道我们会得到什么，因为x是未初始化的）
    std::cout << x << '\n';

    return 0;
}
```

使用未初始化变量是新手程序员最常犯的错误之一，不幸的是，它也可能是最难调试的错误之一（因为如果未初始化变量恰好被分配到一个包含合理值的内存位置，如0，程序可能仍然运行正常）。

这是"始终初始化你的变量"这一最佳实践的主要原因。
## 未定义行为
使用未初始化变量的值是我们遇到的第一个未定义行为的例子。**未定义行为**（通常缩写为**UB**）是执行C++语言中没有明确定义行为的代码的结果。在这种情况下，C++语言没有任何规则来确定如果你使用一个未被赋予已知值的变量的值会发生什么。因此，如果你真的这样做了，就会导致未定义行为。

实现未定义行为的代码可能表现出以下任何症状：

- 你的程序每次运行都产生不同的结果。
- 你的程序始终产生相同的错误结果。
- 你的程序行为不一致（有时产生正确结果，有时不正确）。
- 你的程序看起来工作正常，但在程序后面产生错误结果。
- 你的程序崩溃，可能立即崩溃，也可能稍后崩溃。
- 你的程序在某些编译器上可以工作，但在其他编译器上不行。
- 你的程序工作正常，直到你更改了一些看似无关的代码。
- 或者，你的代码可能实际上仍然产生正确的行为。

> **作者注**
>
> 未定义行为就像一盒巧克力。你永远不知道你会得到什么！

C++包含许多可能导致未定义行为的情况，因此你必须得小心谨慎。在未来的课程中，每当我们遇到这些情况时，我们都会指出来。注意这些情况出现的地方，并确保你避免它们。

> **规则**
>
> 注意避免所有导致未定义行为的情况，比如使用未初始化的变量。

> **作者注**
>
> 我们从读者那里得到的最常见的评论类型之一是，"你说我不能做X，但我还是这样做了，我的程序能工作！为什么？"
>
> 有两个常见的答案。最常见的答案是你的程序实际上正在表现出未定义行为，但那个未定义行为恰好正在产生你想要的结果...暂时的。明天（或在另一个编译器或机器上）可能就不是这样了。
>
> 另外，有时如果语言要求过于严苛，甚至超出必须的范围的时候，编译器作者可能会采取更自由的实现方式。例如，标准可能说"你必须在Y之前做X"，但编译器作者可能觉得这是不必要的，即使你没有先做X，Y也能工作。这不应该影响正确编写的程序的操作，但可能会导致不正确编写的程序仍然能工作。所以对上述问题的另一个答案是，你的编译器可能只是没有遵循标准！这种情况确实会发生。你可以通过确保关闭编译器扩展来避免大部分这种情况，正如在[[Chapter 0 - Introduction Getting Started#0.10 Configuring your compiler Compiler extensions]]中所描述的那样。
## 实现定义的行为和未指定行为
特定的编译器及其附带的标准库被称为**实现**（因为这些是实际实现C++语言的东西）。在某些情况下，C++语言标准允许实现决定语言的某些方面将如何表现，以便编译器可以为给定平台选择一个有效的行为。由实现定义的行为被称为**实现定义行为**。实现定义行为必须被记录并对给定的实现保持一致。

让我们看一个简单的实现定义行为的例子：

```cpp
#include <iostream>

int main()
{
	std::cout << sizeof(int) << '\n'; // 打印int值占用多少字节的内存

	return 0;
}
```

在大多数平台上，这将产生`4`，但在其他平台上可能会产生`2`。

> **相关内容**
> 
> 我们会在[[Chapter 4 - Fundamental Data Types#4.3 Object sizes and the `sizeof` operator]]中讨论`sizeof()`。

**未指定行为**几乎与实现定义行为相同，因为行为都留给实现来定义，但实现不需要记录该行为。

我们通常想要避免实现定义和未指定行为，因为这意味着我们的程序如果在不同的编译器上编译可能无法按预期工作（或者即使在同一编译器上，如果我们更改影响实现行为的项目设置，也可能不工作）！

> **最佳实践**
>
> 尽可能避免实现定义和未指定行为，因为它们可能导致你的程序在其他实现上出现故障。

> **相关内容**
> 
> 我们在[[Chapter 6 - Operators#6.1 Operator precedence and associativity]]中展示了未指定行为的例子。

## 测验时间

**问题 1**

什么是未初始化变量？为什么应该避免使用它们？

<details>
<summary>查看答案</summary>

未初始化变量是一个未被程序赋予值的变量（通常通过初始化或赋值）。使用存储在未初始化变量中的值将导致未定义行为。
</details>

**问题 2**

什么是未定义行为，如果你做了一些会导致未定义行为的事情，会发生什么？

<details>
<summary>查看答案</summary>

未定义行为是执行语言没有明确定义行为的代码的结果。结果可能是几乎任何事情，包括表现正确的行为。
</details>

# 1.7 Keywords and naming identifiers
# 1.8 Whitespace and basic formatting
# 1.9 Introduction to literals and operators
# 1.10 Introduction to expressions
# 1.11 Developing your first program

# 1.x Chapter 1 summary and quiz
