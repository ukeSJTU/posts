# 1.1 About the Course 关于这门课程
这是一门使用 Haskell 编程语言的函数式编程在线课程。您可以按照自己的节奏学习。所有材料和练习都是公开的。

本课程面向希望学习函数式编程的初学者，但也适合具有函数式编程经验并特别想学习 `Haskell` 的人。该课程假定没有先前的知识，但事先至少了解一种编程语言会使课程更容易。

练习包括了解如何使用命令行，以及 Git 版本控制系统的基本用法。

这是由两部分组成的课程的第 1 部分。第 1 部分介绍了 `Haskell` 语法和功能的基础知识。您将学习递归、高阶函数、代数数据类型和一些 Haskell 的高级功能。但是，第 1 部分将坚持使用纯函数式编程，没有副作用。`I/O` 和 `Monad` 将在第 2 部分中介绍。

本课程分为 8 个讲座。它们的大小大致相同，但有些讲座的材料比其他讲座多。每组讲座以 10-30 个关于讲座主题的小型编程练习结束。
# 1.2 Read These 阅读这些
本课程使用的材料和补充内容：
- [The course pages](https://haskell.mooc.fi/)
- The course [channel on Telegram](https://t.me/haskell_mooc_fi)
- The course [repository on Github](https://github.com/moocfi/haskell-mooc) contains the exercises and this material
- Additional resources
    - [A Gentle Introduction to Haskell](https://www.haskell.org/tutorial/) - an older and shorter tutorial, but still worth reading
    - [Learn You a Haskell for Great Good!](http://learnyouahaskell.com/chapters) – a nice free introduction to Haskell
    - [The Haskell School of Expression](https://www.cs.yale.edu/homes/hudak/SOE/index.htm) - slightly older but still relevant introduction to functional programming
    - [Haskell Programming from First Principles](https://haskellbook.com/) - $59 e-book on Haskell, slow and long
    - The IRC channel `#haskell` on [libera.chat](https://libera.chat/) is a nice place for beginners

# 1.3 Haskell 语言简介
Haskell 是

- **函数式的 Functional**：程序的基本构建单位是函数。一个函数可以返回另一个函数或者将函数作为参数。另外，Haskell 中唯一的循环结构是递归。
- **纯粹的 Pure**：Haskell 函数是纯粹的，也就是说它们没有副作用。副作用指的是类似读取文件，输出文本或者改变全局变量。函数的所有输入都应该在它的参数当中，而它的所有输出都应该在它的返回值当中。这个听起来很严格，但是这会让理解程序更简单，也能让编译器做出更多优化。
- **Lazy** - 仅在需要时评估值。这使得使用无限数据结构成为可能，也使纯程序更加高效。
- **强类型 Strongly typed** - 每个 Haskell 值和表达式都有一个类型。编译器在编译时检查类型，并保证在运行时不会发生类型错误。这意味着没有 AttributeErrors (python)、ClassCastExceptions (Java) 或 segmentation faults (C)。Haskell 类型系统非常强大，可以帮助您设计更好的程序。
- **类型推断 Type inferred** - 除了检查类型外，编译器还可以推断大多数程序的类型。这使得使用强类型语言变得更加容易。事实上，大多数 Haskell 函数都可以完全在没有类型的情况下编写。但是，程序员仍然可以为函数和值提供类型注释，以便更轻松地查找类型错误。类型注释还使读取程序更容易。
- **垃圾回收 Garbage-collected** - 就像现在大多数高级语言一样，Haskell 通过垃圾回收实现了自动内存管理。这意味着程序员无需担心分配或释放内存，语言运行时会自动处理所有这些内存。
- **编译型 Compiled** - 尽管我们在本课程中主要通过交互式 GHCi 环境使用 Haskell，但 Haskell 是一种编译型语言。Haskell 程序可以编译成非常高效的二进制文件，而 GHC 编译器非常擅长将功能代码优化为高性能机器代码。

在本课程中，你将了解这些术语在实践中的含义。如果其中一些现在听起来很抽象，请不要担心。

另请参阅：[Haskell Wiki 关于函数式编程的](https://wiki.haskell.org/Functional_programming)页面。
## 1.3.1 Features 特性
在开始正式学习之前，我们可以先看看 Haskell 中有趣的语法特性：

**高阶函数 Higher-order functions** – 函数可以将函数作为参数：

``` haskell
map length ["abc","abcdef"]
```

这会产生结果 `[3,6]`.

**匿名函数（又名 lambda）Anonymous functions aka lambdas** – 你可以定义一次性使用的辅助函数，而无需为其命名：
``` haskell
filter (\x -> length x > 1) ["abc","d","ef"]
```

这会产生结果 `["abc","ef"]`.

**部分应用 Partial application** – 你可以通过仅向另一个函数提供它需要的一些参数来定义新函数。例如，这会将列表中的所有元素乘以 3：

``` haskell
map (*3) [1,2,3]
```

**代数数据类型 Algebraic datatypes** – 一种用于定义可以包含多种不同的数据类型的语法：

``` haskell
data Shape = Point | Rectangle Double Double | Circle Double
```

现在，类型 `Shape` 可以具有 `Point`、`Rectangle 3 6` 和 `Circle 5` 等值

**模式匹配 Pattern matching** – 根据与数据定义对应的不同情况来定义不同函数：

``` haskell
area Point = 0
area (Rectangle width height) = width * height
area (Circle radius) = 2 * pi * radius
```

**列表 Lists** – 与许多语言不同，Haskell 具有简洁的内置列表语法。可以使用_列表推导_式从其他列表构建列表。下面是一个代码段，它从名字和姓氏的一组选项中生成偶数长度的名称：

``` haskell
[whole | first <- ["Eva", "Mike"],
         last <- ["Smith", "Wood", "Odd"],
         let whole = first ++ last,
         even (length whole)]
```

这将生成这样的一个列表 `["EvaSmith","EvaOdd","MikeWood"]`。多亏了 Haskell 的 lazy 特性，我们甚至可以创建所谓的 _无限列表_：

``` haskell
primes = [ n | n <- [2..] , all (\k -> n `mod` k /= 0) [2..n `div` 2] ]
```

然后可以通过计算来获得前十个素数

``` haskell
take 10 primes
```

其计算结果为 `[2,3,5,7,11,13,17,19,23,29]`.

**参数化类型 Parameterized types** – 您可以定义由其他类型参数化的类型。例如，`[Int]` 是 `Int`的列表，`[Bool]` 是布尔值的列表。您可以定义适用于各种列表的类型化函数，例如 `reverse` 函数的类型为 `[a] -> [a]`，这意味着它接受包含任何类型 `a` 的列表，并返回相同类型的列表。

**类型类 Type classes** – 这是另一种形式的多态性，你可以根据参数的类型为函数提供不同的实现。例如，`Show` 类型类定义了可以将各种类型的值转换为字符串的函数 `show`。`Num` 类型类定义算术运算符（如 `+`），这些运算符适用于所有数字类型（`Int`、`Double`、`Complex` 等）。
## 1.3.2 History 一些历史
Haskell 的简要时间表：

- 1930 年代：Lambda 演算
- 1950 年代至 1970 年代：Lisp、模式匹配、方案、ML
- 1978 John Backus：[编程能否从 von Neumann 风格中解放出来？](https://dl.acm.org/doi/pdf/10.1145/359576.359579)
- 1987 年，决定统一纯函数式语言领域
- 1990 年 Haskell 1.0
- 1991 年 Haskell 1.1 （let 语法， sections）
- 1992 年 Haskell 1.2，GHC
- 1996 Haskell 1.3（Monads、do 语法、类型系统改进）
- 1999 Haskell 98
- 2000 年代：GHC 发展，对语言进行了许多扩展
- 2009 年 Haskell 2010 标准
- 2010 年代：GHC 开发、Haskell 平台、Haskell Stack

“haskel”这个词在希伯来语中是智慧的意思，但 Haskell 编程语言的名称来自逻辑学家 Haskell Curry。Haskell 这个名字来自古挪威语单词 áss（上帝）和 ketil（头盔）。
## 1.3.3 Uses of Haskell Haskell的用途
以下是一些用 Haskell 编写的软件项目示例。

- [Darcs](https://en.wikipedia.org/wiki/Darcs) 分布式版本控制系统
- [Facebook 的 Sigma 垃圾邮件预防工具](https://engineering.fb.com/security/fighting-spam-with-haskell/)
- [PureScript](https://www.purescript.org/) 和 [Elm](https://elm-lang.org/) 编程语言的实现是用 Haskell 编写的
- 用于在不同文档格式之间进行转换的 [Pandoc](https://pandoc.org/) 工具 – 它也用于制作此课程材料
- 为 PostgreSQL 数据库公开 HTTP REST API 的 [PostgREST](https://postgrest.org/) 服务器
- [Galois](https://galois.com/) 和 [Well-Typed](https://well-typed.com/) 等功能咨询公司在 Haskell 为客户开发关键系统方面有着悠久的历史

See The Haskell Wiki and this blog post for more!
有关更多信息，请参阅 [Haskell Wiki](https://wiki.haskell.org/Haskell_in_industry)和[此博客文章](https://serokell.io/blog/top-software-written-in-haskell)！
# 1.4 Running Haskell 运行 Haskell
获取 Haskell 最简单的方法是安装 `stack` 工具，参见 [https://haskellstack.org](https://haskellstack.org/)。本课程中的练习旨在与 Stack 配合使用，因此您现在应该使用它。

顺便说一句，如果你对 Stack 是什么感兴趣，以及它与其他 Haskell 工具（如 Cabal 和 GHC）的关系，[请在此处或此处阅读更多内容](https://www.quora.com/What-is-the-difference-between-Cabal-and-Stack-in-Haskell-projects-Which-one-do-you-recommend-and-why)。我们将在课程的第 2 部分中再讲解 Haskell 包并解释具体如何使用它们。

目前，安装 Stack 后，只需运行 `stack ghci` 即可获得交互式 Haskell 环境。

**注意！** GHC 8.10.7 有一个 GHCi 错误，导致在基于 ARM 的系统上无法编辑行。解决方法是使用 `TERM=dumb stack ghci`。[更多信息在这里](https://gitlab.haskell.org/ghc/ghc/-/issues/20022)。
# 1.5 Let's Start! 让我们开始吧！
GHCi 是交互式 Haskell 解释器，例如这样：

``` haskell
$ stack ghci
GHCi, version 9.2.8: https://www.haskell.org/ghc/  :? for help
Prelude> 1+1
2
Prelude> "asdf"
"asdf"
Prelude> reverse "asdf"
"fdsa"
Prelude> :type "asdf"
"asdf" :: [Char]
Prelude> tail "asdf"
"sdf"
Prelude> :type tail "asdf"
tail "asdf" :: [Char]
Prelude> :type tail
tail :: [a] -> [a]
Prelude> :quit
Leaving GHCi.
```

顺便说一下，第一次运行 `stack ghci` 时，它会下载 GHC 和一些库，所以如果您看到一些输出并且需要等待一段时间才能获得 `Prelude>`提示。

让我们来看看这个。如果您还不明白，请不要担心，这只是表达式和​​类型的第一次接触。

``` haskell
Prelude> 1+1
2
```
> TODO: 这里我看到的是ghci>, 不知道为什么 [stackoverflow解答](https://stackoverflow.com/questions/35167627/ghci-vs-prelude-command-prompt-in-haskell)

`Prelude>` 是 GHCi 提示符。它表明我们可以使用 Haskell 基础库中名为 Prelude 的函数。我们计算 1 加 1，结果是 2。

``` haskell
Prelude> "asdf"
"asdf"
```

这里我们计算一个字符串文字，结果是相同的字符串。

``` haskell
Prelude> reverse "asdf"
"fdsa"
```

我们通过将函数 `reverse` 应用于值 `"asdf"` 来反转字符串。

``` haskell
Prelude> :type "asdf"
"asdf" :: [Char]
```

> TODO: 这里我的结果是 String？？？莫非和我看到的是ghci>有关？

除了计算表达式之外，我们还可以使用GHCi 命令—— `:type` （缩写为 `:t`）询问其类型。 `"asdf"` 的类型是字符列表（字符串）。以 `:` 开头的命令是 GHCi 用户交互界面的一部分，而不是 Haskell 语言的一部分。

``` haskell
Prelude> tail "asdf"
"sdf"
Prelude> :t tail "asdf"
tail "asdf" :: [Char]
```

`tail` 函数适用于列表并返回除列表的第一个元素之外的所有元素。在这里我们看到 `tail` 应用于 `"asdf"`。我们还检查表达式的类型，它是一个字符列表，正如预期的那样。

``` haskell
Prelude> :t tail
tail :: [a] -> [a]
```

最后，这是 `tail` 函数的类型。它接受任何类型的列表作为参数，并返回相同类型的列表。

``` haskell
Prelude> :quit
Leaving GHCi.
```

你可以通过`:quit`命令退出 GHCi。
# 1.6 Expressions and Types
Just like we saw in the GHCi example above, _expressions_ and _types_ are the bread and butter of Haskell. In fact, almost everything in a Haskell program is an expression. In particular, there are no _statements_ like in Python, Java or C.

An expression has a _value_ and a _type_. We write an expression and its type like this: `expression :: type`. Here are some examples:

|Expression|Type|Value|
|---|---|---|
|`True`|`Bool`|`True`|
|`not True`|`Bool`|`False`|
|`"as" ++ "df"`|`[Char]`|`"asdf"`|
## 1.6.1 Syntax of Expressions
Expressions consist of functions _applied_ to arguments. Functions are _applied_ (i.e. called) by placing the arguments after the name of the function – there is no special syntax for a function call.

|Haskell|Python, Java or C|
|---|---|
|`f 1`|`f(1)`|
|`f 1 2`|`f(1,2)`|

Parentheses can be used to _group_ expressions (just like in math and other languages).

| Haskell       | Python, Java or C |
| ------------- | ----------------- |
| `g h f 1`     | `g(h,f,1)`        |
| `g h (f 1)`   | `g(h,f(1))`       |
| `g (h f 1)`   | `g(h(f,1))`       |
| `g (h (f 1))` | `g(h(f(1)))`      |
Some function names are made special characters and they are used as operators: between their arguments instead of before them. Function calls _bind tighter_ than operators, just like multiplication binds tighter than addition.

|Haskell|Python, Java or C|
|---|---|
|`a + b`|`a + b`|
|`f a + g b`|`f(a) + g(b)`|
|`f (a + g b)`|`f(a+g(b))`|

PS. in Haskell, function application _associates left_, that is, `f g x y` is actually the same as `(((f g) x) y)`. We’ll get back to this topic later. For now you can just think that `f g x y` is `f` applied to the arguments `g`, `x` and `y`.
## 1.6.2 Syntax of Types
Here are some basic types of Haskell to get you started.

|Type|Literals|Use|Operations|
|---|---|---|---|
|`Int`|`1`, `2`, `-3`|Number type (signed, 64bit)|`+`, `-`, `*`, `div`, `mod`|
|`Integer`|`1`, `-2`, `900000000000000000`|Unbounded number type|`+`, `-`, `*`, `div`, `mod`|
|`Double`|`0.1`, `1.2e5`|Floating point numbers|`+`, `-`, `*`, `/`, `sqrt`|
|`Bool`|`True`, `False`|Truth values|`&&`, `\|`, `not`|
|`String` aka `[Char]`|`"abcd"`, `""`|Strings of characters|`reverse`, `++`|

As you can see, the names of types in Haskell start with a capital letter. Some values like `True` also start with a capital letter, but variables and functions start with a lower case letter (`reverse`, `not`, `x`). We’ll get back to the meaning of capital letters in Lecture 2.

Function types are written using the `->` syntax:

- A function of one argument: `argumentType -> returnType`
- … of two arguments: `argument1Type -> argument2Type -> returnType`
- … of three arguments: `argument1Type -> argument2Type -> argument3Type -> returnType`

Looks a bit weird, right? We’ll get back to this as well.
## 1.6.3 Note About Misleading Types
Sometimes, the types you see in GHCi are a bit different than what you’d assume. Here are two common cases.

``` haskell
Prelude> :t 1+1
1+1 :: Num a => a
```

For now, you should read the type `Num a => a` as “any number type”. In Haskell, number literals are _overloaded_ which means that they can be interpreted as any number type (e.g. `Int` or `Double`). We’ll get back to what `Num a` actually means when we talk about _type classes_ later.

``` haskell
Prelude> :t "asdf"
"asdf" :: [Char]
```

The type `String` is just an alias for the type `[Char]` which means “list of characters”. We’ll get back to lists on the next lecture! In any case, you can use `String` and `[Char]` interchangeably, but GHCi will mostly use `[Char]` when describing types to you.
# 1.7 The Structure of a Haskell Program
下面是一个简单的Haskell程序，它进行一些数学运算并打印一些值。
``` haskell
module Gold where

-- The golden ratio
phi :: Double
phi = (sqrt 5 + 1) / 2

polynomial :: Double -> Double
polynomial x = x^2 - x - 1

f x = polynomial (polynomial x)

main = do
  print (polynomial phi)
  print (f phi)
```

如果你把上面的内容放进`Gold.hs`这个文件中，然后用`stack runhaskell Gold.hs`来运行，你应该看到输出结果：
```
0.0
-1.0
```

让我们来逐行看一下这个程序。
``` haskell
module Gold where
```
There is one Haskell _module_ per source file. A module consists of _definitions_.

``` haskell
-- The golden ratio
```
这个是注释。注释并不是真正程序的一部分，而是给阅读程序的人看的文字。

```
phi :: Double
phi = (sqrt 5 + 1) / 2
```

This is a definition of the constant `phi`, with an accompanying _type annotation_ (also known as a _type signature_) `phi :: Double`. The type annotation means that `phi` has type `Double`. The line with a equals sign (`=`) is called an _equation_. The left hand side of the `=` is the expression we are defining, and the right hand side of the `=` is the definition.

普遍来说，定义（一个函数或者常量）包括可选的type annotation和一个或多个_equations_。

```
polynomial :: Double -> Double
polynomial x = x^2 - x - 1
```

This is the definition of a function called `polynomial`. It has a type annotation and an equation. Note how an equation for a function differs from the equation of a constant by the presence of a parameter `x` left of the `=` sign. Note also that `^` is the power operator in Haskell, not bitwise xor like in many other languages.

```
f x = polynomial (polynomial x)
```

This is the definition of a function called `f`. Note the lack of type annotation. What is the type of `f`?

```
main = do
  print (polynomial phi)
  print (f phi)
```

This is a description of what happens when you run the program. It uses do-syntax and the IO Monad. We’ll get back to those in part 2 of the course.
# 1.8 Working with Examples
When you see an example definition like this

```
polynomial :: Double -> Double
polynomial x = x^2 - x - 1
```

you should usually play around with it. Start by running it. There are a couple of ways to do this.

If a definition fits on one line, you can just define it in GHCi:

```
Prelude> polynomial x = x^2 - x - 1
Prelude> polynomial 3.0
5.0
```

For a multi-line definition, you can either use `;` to separate lines, or use the special `:{ :}` syntax to paste a block of code into GHCi:

```
Prelude> :{
Prelude| polynomial :: Double -> Double
Prelude| polynomial x = x^2 - x - 1
Prelude| :}
Prelude> polynomial 3.0
5.0
```

Finally, you can paste the code into a new or existing `.hs` file, and then `:load` it into GHCi. If the file has already been loaded, you can also use `:reload`.

```
-- first copy and paste the definition into Example.hs, then run GHCi
Prelude> :load Example.hs
[1 of 1] Compiling Main             ( Example.hs, interpreted )
Ok, one module loaded.
*Main> polynomial 3.0
5.0
-- now you can edit the definition
*Main> :reload
[1 of 1] Compiling Main             ( Example.hs, interpreted )
Ok, one module loaded.
*Main> polynomial 3
3.0
```

After you’ve run the example, try modifying it, or making another function that is similar but different. You learn programming by programming, not by reading!
## 1.8.1 Dealing with Errors
考虑到Haskell是一个typed language，你可能很快就会遇到类型错误。例如下面这样：
```
Prelude> "string" ++ True

<interactive>:1:13: error:
    • Couldn't match expected type ‘[Char]’ with actual type ‘Bool’
    • In the second argument of ‘(++)’, namely ‘True’
      In the expression: "string" ++ True
      In an equation for ‘it’: it = "string" ++ True
```

这是最常见的一种类型错误，"Couldn't match expected type"。尽管这个错误看起来又长又吓人，但是如果你仔细阅读它还是很简单的。
- The first line of the error message, `<interactive>:1:13: error:` tells us that the error occurred in GHCi. If we had loaded a file, we might instead get something like `Sandbox.hs:3:17: error:`, where `Sandbox.hs` is the name of the file, `3` is the line number and `17` is the number of a character in the line.
    
- The line `• Couldn't match expected type ‘[Char]’ with actual type ‘Bool’` tells us that the immediate cause for the error is that there was an expression of type `Bool`, when GHCi was expecting to find an expression of type `[Char]`“. The location of this error was indicated in the first line of the error message. Note that the expected type is not always right. Giving type annotations by hand can help debugging typing errors.
    
- The line `• In the second argument of ‘(++)’, namely ‘True’` tells that the expression that had the wrong type was the second argument of the operator `(++)`. We’ll learn later why it’s surrounded by parentheses.
    
- The full expression with the error was `"string" ++ True`. As mentioned above, `String` is a type alias for `[Char]`, the type of character lists. The first argument to `++` was a list of characters, and since `++` can only combine two lists of the same type, the second argument should’ve been of type `[Char]` too.
    
- The line `In an equation for ‘it’: it = "string" ++ True` says that the expression occurred in the definition of the variable `it`, which is a default variable name that GHCi uses for standalone expressions. If we had a line `x = "string" ++ True` in a file, or a declaration `let x = "string" ++ True` in GHCi, GHCi would print `In an equation for ‘x’: x = "string" ++ True` instead.
    

还有别的类型错误。
```
Prelude> True + 1

<interactive>:6:1: error:
    • No instance for (Num Bool) arising from a use of ‘+’
    • In the expression: True + 1
      In an equation for ‘it’: it = True + 1
```

This is the kind of error you get when you try to use a numeric function like `+` on something that’s not a number.

The hardest error to track down is usually this:

```
Prelude> True +

<interactive>:10:7: error:
    parse error (possibly incorrect indentation or mismatched brackets)
```

There are many ways to cause it. Probably you’re missing some characters somewhere. We’ll get back to indentation later in this lecture.
## 1.8.2 Arithmetic
There’s one thing in Haskell arithmetic that often trips up beginners, and that’s division.

In Haskell there are two division functions, the `/` operator and the `div` function. The `div` function does integer division:

``` haskell
Prelude> 7 `div` 2
3
```

The `/` operator performs the usual division:

``` haskell
Prelude> 7.0 / 2.0
3.5
```

However, you can only use `div` on whole number types like `Int` and `Integer`, and you can only use `/` on decimal types like `Double`. Here’s an example of what happens if you try to mix them up:

``` haskell
halve :: Int -> Int
halve x = x / 2
```

``` haskell
error:
    • No instance for (Fractional Int) arising from a use of ‘/’
    • In the expression: x / 2
      In an equation for ‘halve’: halve x = x / 2
```

Just try to keep this in mind for now. We’ll get back to the difference between `/` and `div`, and what `Num` and `Fractional` mean when talking about type classes.

> TODO: 这个是我在后面的1.10做练习遇到的：
> ``` haskell
module Collatz where

-- one step of the Collatz sequence
step :: Integer -> Integer
step x = if even x then down else up
  where down = div x 2
        up = 3*x+1
> ```
> 这里面有一个div x 2，也可以写成x `div` 2这到底有什么区别？

# 1.9 How Do I Get Anything Done?
So far you’ve seen some arithmetic, reversing a string and so on. How does one write actual programs in Haskell? Many of the usual programming constructs like loops, statements and assignment are missing from Haskell. Next, we’ll go through the basic building blocks of Haskell programs:

- Conditionals
- Local definitions
- Pattern matching
- Recursion
## 1.9.1 Conditionals
在别的语言中，`if`是一个statement。它没有一个值，它只会按照条件执行别的statements。

但是在haskell中，`if`是一个expression。它有一个值。它能够有条件地在另外两个expressions中选择。你可以认为它对应着C或者Java中的`?:`操作符。

``` Java
int price = product.equals("milk") ? 1 : 2;
```
Python中的conditional expressions就和haskell中的if很类似：
``` python
price = 1 if product == "milk" else 2
```
而Haskell中你可以这样写：
``` haskell
price = if product == "milk" then 1 else 2
```
Because Haskell’s `if` _returns_ a value, you **always** need an `else`!
> TODO: 思考一下，如果没有else，是不是可以设定为None，还是Haskell中并没有none这个value？
### 1.9.1.1 Functions Returning `Bool`
In order to write if expressions, you need to know how to get values of type `Bool`. The most common way is comparisons. The usual `==`, `<`, `<=`, `>` and `>=` operators work in Haskell. You can do ordered comparisons (`<`, `>`) on all sorts of numbers, and equality comparisons (`==`) on almost anything:
``` haskell
Prelude> "foo" == "bar"
False
Prelude> 5.0 <= 7.2
True
Prelude> 1 == 1
True
```

One oddity of Haskell is that the not-equals operator is written `/=` instead of the usual `!=`:

``` haskell
Prelude> 2 /= 3
True
Prelude> "bike" /= "bike"
False
```

Remember that in addition to these comparisons, you can get `Bool` values out of other `Bool` values by using the `&&` (“and”) and `||` (“or”) operators, and the `not` function.
### 1.9.1.2 Examples
``` haskell
checkPassword password = if password == "swordfish"
						 then "You're in."
						 else "ACCESS DENIED!"
```

```
absoluteValue n = if n < 0 then -n else n
```

```
login user password = if user == "unicorn73"
                      then if password == "f4bulous!"
                           then "unicorn73 logged in"
                           else "wrong password"
                      else "unknown user"
```
## 1.9.2 Local Definitions
Haskell 有两种不同的办法创建local定义：let-in和where
`where` adds local definitions to a definition:

``` haskell
circleArea :: Double -> Double
circleArea r = pi * rsquare
    where pi = 3.1415926
          rsquare = r * r
```

`let...in` is an expression:

``` haskell
circleArea r = let pi = 3.1415926
                   rsquare = r * r
               in pi * rsquare
```
  
Local definitions can also be functions:

``` haskell
circleArea r = pi * square r
    where pi = 3.1415926
          square x = x * x
```

``` haskell
circleArea r = let pi = 3.1415926
                   square x = x * x
               in pi * square r
```

We’ll get back to the differences between `let` and `where`, but mostly you can use which ever you like.
## A Word About Immutability
Even though things like `pi` above are often called _variables_, I’ve chosen to call them _definitions_ here. This is because unlike variables in Python or Java, the values of these definitions can’t be changed. Haskell variables aren’t boxes into which you can put new values, Haskell variables name a value (or rather, an expression) and that’s it.

We’ll talk about immutability again later on this course, but for now it’s enough to know that things like this don’t work.

``` haskell
increment x = let x = x+1
              in x
```

This is just an infinite loop, because it tries to define a new variable `x` with the property `x = x+1`. Thus when evaluating `x`, Haskell just keeps computing `1+1+1+1+...` indefinitely.

``` haskell
compute x = let a = x+1
                a = a*2
            in a
```

```
error:
    Conflicting definitions for ‘a’
    Bound at: <interactive>:14:17
              <interactive>:15:17
```

Here we get a straightforward error when we’re trying to “update” the value of `a`.

As a remark, local definitions can _shadow_ the names of variables defined elsewhere. Shadowing is not a side-effect. Instead, shadowing creates a new variable within a more restricted scope that uses the same name as some variable in the outer scope. For example, all of the functions `f`, `g`, and `h` below are legal:

``` haskell
x :: Int
x = 5

f :: Int -> Int
f x = 2 * x

g :: Int -> Int
g y = x where x = 6

h :: Int -> Int
h x = x where x = 3
```

If we apply them to the global constant `x`, we see the effects of shadowing:

``` haskell
f 1 ==> 2
g 1 ==> 6
h 1 ==> 3

f x ==> 10
g x ==> 6
h x ==> 3
```

It is best to always choose new names for local variables, so that shadowing never happens. That way, the reader of the code will understand where the variables that are used in an expression come from. Note that in the following example, `f` and `g` don’t shadow each others’ arguments:

``` haskell
f :: Int -> Int
f x = 2 * x + 1

g :: Int -> Int
g x = x - 2
```
## 1.9.4 Pattern Matching
A definition (of a function) can consist of multiple _equations_. The equations are matched in order against the arguments until a suitable one is found. This is called _pattern matching_.

Pattern matching in Haskell is very powerful, and we’ll keep learning new things about it along this course, but here are a couple of first examples:
``` haskell
greet :: String -> String -> String
greet "Finland" name = "Hei, " ++ name
greet "Italy"   name = "Ciao, " ++ name
greet "England" name = "How do you do, " ++ name
greet _         name = "Hello, " ++ name
```

The function `greet` generates a greeting given a country and a name (both `String`s). It has special cases for three countries, and a default case. This is how it works:

``` haskell
Prelude> greet "Finland" "Pekka"
"Hei, Pekka"
Prelude> greet "England" "Bob"
"How do you do, Bob"
Prelude> greet "Italy" "Maria"
"Ciao, Maria"
Prelude> greet "Greenland" "Jan"
"Hello, Jan"
```

The special pattern `_` matches anything. It’s usually used for default cases. Because patterns are matched in order, it’s important to (_usually_) put the `_` case last. Consider:

``` haskell
brokenGreet _         name = "Hello, " ++ name
brokenGreet "Finland" name = "Hei, " ++ name
```
Now the first case gets selected for all inputs.

``` haskell
Prelude> brokenGreet "Finland" "Varpu"
"Hello, Varpu"
Prelude> brokenGreet "Sweden" "Ole"
"Hello, Ole"
```

GHC even gives you a warning about this code:

```
<interactive>:1:1: warning: [-Woverlapping-patterns]
    Pattern match is redundant
    In an equation for ‘brokenGreet’: brokenGreet "Finland" name = ...
```

Some more examples follow. But first let’s introduce the standard library function `show` that can turn (almost!) anything into a string:

``` haskell
Prelude> show True
"True"
Prelude> show 3
"3"
```

So, here’s an example of a function with pattern matching and a default case that actually uses the value (instead of just ignoring it with `_`):

``` haskell
describe :: Integer -> String
describe 0 = "zero"
describe 1 = "one"
describe 2 = "an even prime"
describe n = "the number " ++ show n
```

This is how it works:

``` haskell
Prelude> describe 0
"zero"
Prelude> describe 2
"an even prime"
Prelude> describe 7
"the number 7"
```

You can even pattern match on multiple arguments. Again, the equations are tried in order. Here’s a reimplementation of the `login` function from earlier:

``` haskell
login :: String -> String -> String
login "unicorn73" "f4bulous!" = "unicorn73 logged in"
login "unicorn73" _           = "wrong password"
login _           _           = "unknown user"
```
## 1.9.5 Recursion
In Haskell, all sorts of loops are implemented with recursion. 函数调用的效率都很高所以你不必担心性能问题。（我们会在后面再讨论性能）。

Learning how to do simple things with recursion in Haskell will help you use recursion on more complex problems later. Recursion is also often a useful way for thinking about solving harder problems.

Here’s our first recursive function which computes the factorial. In mathematics, factorial is the product of _n_ first positive integers and is written as _n!_. The definition of factorial is

> _n! = n * (n-1) * … * 1_

For example, _4! = 4*3*2*1 = 24_. Well anyway, here’s the Haskell implementation of factorial:
``` haskell
factorial :: Int -> Int
factorial 1 = 1
factorial n = n * factorial (n-1)
```

This is how it works. We use `==>` to mean “evaluates to”.

``` haskell
factorial 3
  ==> 3 * factorial (3-1)
  ==> 3 * factorial 2
  ==> 3 * 2 * factorial 1
  ==> 3 * 2 * 1
  ==> 6
```

What happens when you evaluate `factorial (-1)`?

Here’s another example:

``` haskell
-- compute the sum 1^2+2^2+3^2+...+n^2
squareSum 0 = 0
squareSum n = n^2 + squareSum (n-1)
```

  
A function can call itself recursively multiple times. As an example let’s consider the _Fibonacci sequence_ from mathematics. The Fibonacci sequence is a sequence of integers with the following definition.

> The sequence starts with 1, 1. To get the next element of the sequence, sum the previous two elements of the sequence.

The first elements of the Fibonacci sequence are 1, 1, 2, 3, 5, 8, 13 and so on. Here’s a function `fibonacci` which computes the `n`th element in the Fibonacci sequence. Note how it mirrors the mathematical definition.

``` haskell
-- Fibonacci numbers, slow version
fibonacci 1 = 1
fibonacci 2 = 1
fibonacci n = fibonacci (n-2) + fibonacci (n-1)
```

Here’s how `fibonacci 5` evaluates:

``` haskell
fibonacci 5
  ==> fibonacci 3                 + fibonacci 4
  ==> (fibonacci 1 + fibonacci 2) + fibonacci 4
  ==> (    1       +       1    ) + fibonacci 4
  ==> (    1       +       1    ) + (fibonacci 2 + fibonacci 3)
  ==> (    1       +       1    ) + (fibonacci 2 + (fibonacci 1 + fibonacci 2))
  ==> (    1       +       1    ) + (    1       + (    1       +     1      ))
  ==> 5
```
# 1.10 All Together Now!
Finally, here’s a complete Haskell module that uses ifs, pattern matching, local defintions and recursion. The module is interested in the [_Collatz conjecture_](https://en.wikipedia.org/wiki/Collatz_conjecture), a famous open problem in mathematics. It asks:

> Does the Collatz sequence eventually reach 1 for all positive integer initial values?

The Collatz sequence is defined by taking any number as a starting value, and then repeatedly performing the following operation:

- if the number is even, divide it by two
- if the number is odd, triple it and add one

As an example, the Collatz sequence for 3 is: 3, 10, 5, 16, 8, 4, 2, 1, 4, 2, 1, 4, 2, 1 … As you can see, once the number reaches 1, it gets caught in a loop.
# 1.10 A Word About Indentation
The previous examples have been fancily indented. In Haskell indentation matters, a bit like in Python. The complete set of rules for indentation is hard to describe, but you should get along fine with these rules of thumb:

1. Things that are grouped together start from the same column
2. If an expression (or equation) has to be split on to many lines, increase indentation

While you can get away with using tabs, it is highly recommended to use spaces for all indenting.

Some examples are in order.

These all are ok:
``` haskell
i x = let y = x+x+x+x+x+x in div y 5

-- let and in are grouped together, an expression is split
j x = let y = x+x+x
              +x+x+x
      in div y 5

-- the definitions of a and b are grouped together
k = a + b
  where a = 1
        b = 1

l = a + b
  where
    a = 1
    b = 1
```

These are not ok:
``` haskell
-- indentation not increased even though expression split on many lines
i x = let y = x+x+x+x+x+x
in div y 5

-- indentation not increased even though expression is split
j x = let y = x+x+x
      +x+x+x
      in div y 5

-- grouped things are not aligned
k = a + b
  where a = 1
      b = 1

-- grouped things are not aligned
l = a + b
  where
    a = 1
     b = 1

-- where is part of the equation, so indentation needs to increase
l = a + b
where
  a = 1
  b = 1
```

If you make a mistake with the indentation, you’ll typically get a parse error like this:

```
Indent.hs:2:1: error: parse error on input ‘where’
```

The error includes the line number, so just go over that line again. If you can’t seem to get indentation to work, try putting everything on just one long line at first.
# 1.12 Quiz
在每一个lecture的最后部分，你都会找到这样的一个quiz。这些quiz并不记分，它们仅仅是帮助你检查自己是否理解了chapter的内容。
CCACAAA
What is the Haskell equivalent of the C/Java/Python expression `combine(prettify(lawn),construct(house,concrete))`?

1. `combine prettify (lawn) construct (house concerete)`
2. `combine (prettify lawn (counstruct house concrete))`
3. `combine (prettify lawn) (construct house concrete)`

What is the C/Java/Python equivalent of the Haskell expression `send metric (double population + increase)`?

1. `send(metric(double(population+increase)))`
2. `send(metric(double(population)+increase))`
3. `send(metric,double(population)+increase)`
4. `send(metric,double(population+increase))`

Which one of the following claims is true in Haskell?

1. Every value has a type
2. Every type has a value
3. Every statement has a type

Which one of the following claims is true in Haskell?

1. It’s impossible to reuse the name of a variable
2. It’s possible to reassign a value to a variable
3. An `if` always requires both `then` and `else`

What does the function `f x = if even (x + 1) then x + 1 else f (x - 1)` do?

1. Maps every value `x` to the least even number greater than or equal to `x`
2. Maps every value `x` to the greatest even number less than or equal to `x`
3. Maps every value to itself

Why is `3 * "F00"` not valid Haskell?

1. `3` and `"F00"` have different types
2. All numeric values need a decimal point
3. `"F00"` needs the prefix “0x”

Why does ``7.0 `div` 2`` give an error?

1. Because `div` is not defined for the type `Double`
2. Because `div` is not defined for the type `Int`
3. Because `` `...` `` is used for delimiting strings.

# 1.13 Working on the Exercises
The course materials, including exercises, are available in a Git repository on GitHub at [https://github.com/moocfi/haskell-mooc](https://github.com/moocfi/haskell-mooc). If you’re not familiar with Git, see [GitHub’s instructions on cloning a repository](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository).

Once you’ve cloned the `haskell-mooc` repository, go into the `exercises` directory. To download and build dependencies needed for running the exercise tests (such as the correct version of GHC and various libraries), run following command in your terminal:

```
$ stack build
```

Do note that the dependencies are multiple gigabytes and it will take a while for the command to finish.

**Note!** Here are some fixes for common problems with `stack build`:

- If you get an error like `While building package zlib-0.6.2.3`, you need to install the zlib library headers. The right command for Ubuntu is `sudo apt install zlib1g-dev`.
- If you get an error like `Downloading lts-18.18 build plan ... RedownloadInvalidResponse`, your version of stack is too old. Run `stack upgrade` to get a newer one.

There are primarily two types of files in the `exercises` directory: exercise sets named `SetNX.hs` and accompanying test program for the exercises named `SetNXTest.hs`. Both are Haskell source files, but only the exercise file should to be edited when solving the exercises. Instructions to all individual exercises are embedded in the exercise file as comments.

Use the tests file to check your answers. For example when you have solved some of the exercises in `Set1.hs`, run the following command:
``` bash
$ stack runhaskell Set1Test.hs
```

The output of the tests looks something like this:
```
===== EXERCISE 1
+++++ Pass
===== EXERCISE 2
+++++ Pass
===== EXERCISE 3
*** Failed! Falsified (after 2 tests and 1 shrink):
quadruple 1
  Expected: 4
  Was: 2

----- Fail
===== EXERCISE 4
+++++ Pass
===== EXERCISE 5
+++++ Pass
===== EXERCISE 6
+++++ Pass
===== EXERCISE 7
+++++ Pass
===== EXERCISE 8
+++++ Pass
===== EXERCISE 9
+++++ Pass
===== EXERCISE 10
+++++ Pass
===== EXERCISE 11
+++++ Pass
===== EXERCISE 12
+++++ Pass
===== EXERCISE 13
+++++ Pass
===== EXERCISE 14
+++++ Pass
===== EXERCISE 15
+++++ Pass
===== EXERCISE 16
+++++ Pass
===== EXERCISE 17
+++++ Pass
===== EXERCISE 18
+++++ Pass
===== EXERCISE 19
+++++ Pass
===== TOTAL
1101111111111111111
18 / 19
```

In the example above, I’ve made a mistake in exercise 3.

To make debugging faster and more straightforward, I can load my exercise file in GHCi, which allows me to evaluate any top-level function manually. For instance I can verify the above mistake by:
 ```
$ stack ghci Set1.hs
GHCi, version 9.2.8: https://www.haskell.org/ghc/  :? for help
[1 of 2] Compiling Mooc.Todo        ( Mooc/Todo.hs, interpreted )
[2 of 2] Compiling Set1             ( Set1.hs, interpreted )
Ok, two modules loaded.
*Set1> quadruple 1
2
```

Once you’re done with an exercise set, you can turn it in on the [Submit page](https://haskell.mooc.fi/submit.php) on the course pages. After that you can see the results of your submission on the [Results page](https://haskell.mooc.fi/results.php) and your total score on the [My status page](https://haskell.mooc.fi/status.php).

**Note!** You may turn in an exercise set as many times as you want.

**Note!** If you don’t want to use Stack or can’t get it working, you should also be able to run the tests with [Cabal](https://www.haskell.org/cabal/download.html) like this:

```
$ cabal v2-build
$ cabal v2-exec runhaskell Set1Test.hs
```
## 1.13.1 Model Solutions

Once you’ve successfully completed all the exercises in a set, you can view the model solutions on the [My status page](https://haskell.mooc.fi/status). It’s useful to glance at the model solutions, they might show you a technique you’ve missed!

> TODO Set1.hs中的第一个Ex1，产生疑问Int和Integer有什么区别？
# 1.14 Exercises

- [Set1](https://github.com/moocfi/haskell-mooc/blob/master/exercises/Set1.hs)
