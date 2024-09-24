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
# 1.6 Expressions and Types 表达式和类型
就像我们在上面的 GHCi 示例中看到的那样，_expressions_ 和 _types_ 是 Haskell 的生计。事实上，Haskell 程序中的几乎所有内容都是一个表达式。特别是，没有像 Python、Java 或 C 那样的 _statements_。

一个表达式有一个值 (value) 和一个类型 (type)。我们用这种方式来写表达式及其类型：`expression :: type`。下面是一些例子：

| 表达式            | 类型       | 值        |
| -------------- | -------- | -------- |
| `True`         | `Bool`   | `True`   |
| `not True`     | `Bool`   | `False`  |
| `"as" ++ "df"` | `[Char]` | `"asdf"` |
## 1.6.1 表达式的语法
表达式是由函数和参数构成的。在 Haskell 中，你可以通过将参数直接放在函数名后面来调用（或者说"应用"）一个函数。这里没有特殊的函数调用语法，比如其他语言中常见的圆括号。

|Haskell|Python, Java or C|
|---|---|
|`f 1`|`f(1)`|
|`f 1 2`|`f(1,2)`|

你可以使用圆括号来 _组合_（group）表达式（这点和数学以及其他编程语言类似）。

| Haskell       | Python, Java or C |
| ------------- | ----------------- |
| `g h f 1`     | `g(h,f,1)`        |
| `g h (f 1)`   | `g(h,f(1))`       |
| `g (h f 1)`   | `g(h(f,1))`       |
| `g (h (f 1))` | `g(h(f(1)))`      |

一些函数名由特殊字符组成，它们被用作运算符：这些运算符会放在参数之间，而不是参数之前。函数调用的优先级高于运算符，这类似于乘法优先级高于加法。

|Haskell|Python, Java or C|
|---|---|
|`a + b`|`a + b`|
|`f a + g b`|`f(a) + g(b)`|
|`f (a + g b)`|`f(a+g(b))`|

在 Haskell 中，函数应用是**左结合的**。也就是说，`f g x y` 实际上等同于 `(((f g) x) y)`。我们稍后会详细讨论这个话题。现在，你可以简单地理解为 `f g x y` 是将函数 `f` 应用于参数 `g`、`x` 和 `y`。

## 1.6.2 类型的语法
下面我为你介绍一些 Haskell 的基本类型，帮助你入门。

| 类型                    | Literals                        | 使用                          |                             |
| --------------------- | ------------------------------- | --------------------------- | --------------------------- |
| `Int`                 | `1`, `2`, `-3`                  | Number type (signed, 64bit) | `+`, `-`, `*`, `div`, `mod` |
| `Integer`             | `1`, `-2`, `900000000000000000` | Unbounded number type       | `+`, `-`, `*`, `div`, `mod` |
| `Double`              | `0.1`, `1.2e5`                  | Floating point numbers      | `+`, `-`, `*`, `/`, `sqrt`  |
| `Bool`                | `True`, `False`                 | Truth values                | `&&`, `\|`, `not`           |
| `String` aka `[Char]` | `"abcd"`, `""`                  | Strings of characters       | `reverse`, `++`             |

你可能已经注意到，`Haskell` 中的类型名称都以大写字母开头。一些值（如 `True`）也以大写字母开头，但变量和函数名则以小写字母开头（如 `reverse`、`not`、`x`）。我们会在第二讲中详细讨论大写字母的含义。

函数类型使用 `->` 语法来表示：

- 单参数函数：`参数类型 -> 返回类型`
- 双参数函数：`参数1类型 -> 参数2类型 -> 返回类型`
- 三参数函数：`参数1类型 -> 参数2类型 -> 参数3类型 -> 返回类型`

这种写法看起来有点奇怪，对吧？别担心，我们稍后会详细解释这种表示方法。
## 1.6.3 可能误导性的类型
有时候，你在 GHCi 中看到的类型可能会与你预想的有些不同。这里有两种常见的情况：

1. 当你看到类型 `Num a => a` 时，现在你可以简单理解为"任何数字类型"。在 Haskell 中，数字字面量是_多态的_（overloaded），这意味着它们可以被解释为任何数字类型（比如 `Int` 或 `Double`）。我们会在后面讨论_类型类_（type classes）时详细解释 `Num a` 的实际含义。

``` haskell
Prelude> :t 1+1
1+1 :: Num a => a
```

2. 类型 `String` 实际上只是 `[Char]` 类型的别名，`[Char]` 表示"字符列表"。我们会在下一讲详细讨论列表！无论如何，你可以互换使用 `String` 和 `[Char]`，但 GHCi 在描述类型时通常会使用 `[Char]`。

``` haskell
Prelude> :t "asdf"
"asdf" :: [Char]
```

# 1.7 Haskell 程序的结构
这是一个简单的 Haskell 程序，它进行一些算术运算并打印一些值。

``` haskell
module Gold where

-- The golden ratio 黄金比例
phi :: Double
phi = (sqrt 5 + 1) / 2

polynomial :: Double -> Double
polynomial x = x^2 - x - 1

f x = polynomial (polynomial x)

main = do
  print (polynomial phi)
  print (f phi)
```

如果你将这段代码保存在名为 `Gold.hs` 的文件中，并使用类似 `stack runhaskell Gold.hs` 的命令运行它，你应该会看到以下输出：

```
0.0
-1.0
```

让我们逐步解析这个文件。

``` haskell
module Gold where
```

每个 Haskell 源文件对应一个模块。一个模块由多个定义组成。

``` haskell
-- The golden ratio 黄金比例
```

这是一个注释。注释不是程序的实际部分，而是为程序的人类读者提供的说明文本。

``` haskell
phi :: Double
phi = (sqrt 5 + 1) / 2
```

这是常量 `phi` 的定义，附带类型注解（也称为类型签名）`phi :: Double`。类型注解表示 `phi` 的类型是 `Double`。带有等号（=）的行称为方程(equation)。等号左边是我们正在定义的表达式，右边是定义。

一般来说，一个定义（函数或常量）由一个可选的类型注解和一个或多个方程组成。

``` haskell
polynomial :: Double -> Double
polynomial x = x^2 - x - 1
```

这是名为 `polynomial` 的函数的定义。它有一个类型注解和一个方程。注意函数的方程与常量的方程的区别：在等号左侧有参数 `x`。还要注意，在 Haskell 中，`^` 是幂运算符，而不是像许多其他语言中的按位异或。

``` haskell
f x = polynomial (polynomial x)
```

这是名为 `f` 的函数的定义。注意这里没有类型注解。你能推断出 `f` 的类型吗？

``` haskell
main = do
  print (polynomial phi)
  print (f phi)
```

这描述了运行程序时会发生什么。它使用了 do 语法和 IO Monad。我们会在课程的第二部分详细讨论这些概念。
# 1.8 使用示例

当你看到像这样的定义时：

``` haskell
polynomial :: Double -> Double
polynomial x = x^2 - x - 1
```

你通常应该尝试使用它。首先运行它。有几种方法可以做到这一点。

1. 如果定义只有一行，你可以直接在 GHCi 中定义它：

``` haskell
Prelude> polynomial x = x^2 - x - 1
Prelude> polynomial 3.0
5.0
```

2. 对于多行定义，你可以使用 ; 分隔行，或使用特殊的 :{ :} 语法将代码块粘贴到 GHCi 中：

``` haskell
Prelude> :{
Prelude| polynomial :: Double -> Double
Prelude| polynomial x = x^2 - x - 1
Prelude| :}
Prelude> polynomial 3.0
5.0
```

3. 最后，你可以将代码粘贴到新的或现有的 .hs 文件中，然后使用 :load 将其加载到 GHCi 中。如果文件已经加载，你也可以使用 :reload。

``` haskell
-- 首先将定义复制并粘贴到 Example.hs 中，然后运行 GHCi
Prelude> :load Example.hs
[1 of 1] Compiling Main             ( Example.hs, interpreted )
Ok, one module loaded.
*Main> polynomial 3.0
5.0

-- 现在你可以编辑定义
*Main> :reload
[1 of 1] Compiling Main             ( Example.hs, interpreted )
Ok, one module loaded.
*Main> polynomial 3
3.0
```

运行示例后，尝试修改它，或创建一个相似但不同的函数。你需要通过编程来学习编程，而不是通过阅读！
## 1.8.1 处理错误

由于 Haskell 是一种类型化语言，你可能很快就会遇到类型错误。以下是 GHCi 会话中的错误示例：
``` plaintext
Prelude> "string" ++ True

<interactive>:1:13: error:
    • Couldn't match expected type ‘[Char]’ with actual type ‘Bool’
    • In the second argument of ‘(++)’, namely ‘True’
      In the expression: "string" ++ True
      In an equation for ‘it’: it = "string" ++ True
```

这是最常见的类型错误，"无法匹配预期类型"。即使错误看起来很长很可怕，但如果你仔细阅读，它其实很简单。

- 错误消息的第一行 `<interactive>:1:13: error:` 告诉我们错误发生在 GHCi 中。如果我们加载了一个文件，我们可能会看到类似 `Sandbox.hs:3:17: error:` 的内容，其中 `Sandbox.hs` 是文件名，`3` 是行号，`17` 是该行中的字符编号。

- `Couldn't match expected type '[Char]' with actual type 'Bool'` 这一行告诉我们，错误的直接原因是有一个 Bool 类型的表达式，而 GHCi 期望找到一个 `[Char]` 类型的表达式。这个错误的位置在错误消息的第一行中指出。注意，预期类型并不总是正确的。手动给出类型注解可以帮助调试类型错误。

- `In the second argument of '(++)', namely 'True'` 这一行告诉我们，类型错误的表达式是运算符 (++) 的第二个参数。我们稍后会了解为什么它被括号包围。

- 完整的错误表达式是 "string" ++ True。如前所述，`String` 是 `[Char]`（字符列表类型）的类型别名。++ 的第一个参数是一个字符列表，由于 ++ 只能组合两个相同类型的列表，第二个参数也应该是 `[Char]` 类型。

- `In an equation for 'it': it = "string" ++ True` 这一行说明该表达式出现在变量 it 的定义中，it 是 GHCi 用于独立表达式的默认变量名。如果我们在文件中有 `x = "string" ++ True` 这样的行，或在 GHCi 中有 `let x = "string" ++ True` 这样的声明，GHCi 会打印 `In an equation for 'x': x = "string" ++ True`。
    
还有其他类型的错误。

``` plaintext
Prelude> True + 1

<interactive>:6:1: error:
    • No instance for (Num Bool) arising from a use of ‘+’
    • In the expression: True + 1
      In an equation for ‘it’: it = True + 1
```

当你试图在非数字上使用数字函数（如 +）时，会出现这种错误。

最难追踪的错误通常是这个：

``` plaintext
Prelude> True +

<interactive>:10:7: error:
    parse error (possibly incorrect indentation or mismatched brackets)
```

有很多方式可能导致这个错误。可能是某处缺少了一些字符。我们稍后会在本讲中讨论缩进。
## 1.8.2 算术
Haskell 算术中有一件事经常让初学者感到困惑，那就是除法。

在 Haskell 中有两个除法函数，/ 运算符和 div 函数。div 函数进行整数除法：

``` haskell
Prelude> 7 `div` 2
3
```

/ 运算符执行通常的除法：

``` haskell
Prelude> 7.0 / 2.0
3.5
```

然而，你只能在整数类型（如 Int 和 Integer）上使用 div，只能在小数类型（如 Double）上使用 /。以下是尝试混用它们时会发生的情况：

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

现在只需记住这一点。我们稍后会在讨论类型类时回到 / 和 div 的区别，以及 Num 和 Fractional 的含义。

# 1.9 如何实际编写程序？
到目前为止，你已经见过一些算术运算、字符串反转等操作。那么，如何在Haskell中编写实际的程序呢？Haskell中缺少了许多常见的编程结构，如循环、语句和赋值。接下来，我们将介绍Haskell程序的基本构建块：

- 条件语句
- 局部定义
- 模式匹配
- 递归
## 1.9.1 条件语句
在其他语言中，`if` 通常是一个语句。它没有返回值，只是条件性地执行其他语句。

而在Haskell中，`if` 是一个表达式。它有一个值，用于在两个表达式之间进行选择。它类似于C或Java中的 `?:` 运算符。

``` Java
int price = product.equals("milk") ? 1 : 2;
```

Python的条件表达式与Haskell的`if`非常接近：

``` python
price = 1 if product == "milk" else 2
```

这是同样的例子在Haskell中的样子：

``` haskell
price = if product == "milk" then 1 else 2
```

因为Haskell的`if`返回一个值，所以你总是需要一个`else`！
### 1.9.1.1 返回`Bool`的函数
为了编写`if`表达式，你需要知道如何获得`Bool`类型的值。最常见的方式是比较。通常的`==`、`<`、`<=`、`>`和`>=`运算符在Haskell中都可以使用。你可以对各种数字进行有序比较（`<`，`>`），对几乎任何东西进行相等比较（`==`）：

``` haskell
Prelude> "foo" == "bar"
False
Prelude> 5.0 <= 7.2
True
Prelude> 1 == 1
True
```

Haskell的一个特点是不等于运算符写作`/=`而不是通常的`!=`：

``` haskell
Prelude> 2 /= 3
True
Prelude> "bike" /= "bike"
False
```

记住，除了这些比较之外，你还可以通过使用`&&`（"与"）和`||`（"或"）运算符，以及`not`函数来获得`Bool`值。
### 1.9.1.2 例子
``` haskell
checkPassword password = if password == "swordfish"
						 then "You're in."
						 else "ACCESS DENIED!"
```

``` haskell
absoluteValue n = if n < 0 then -n else n
```

``` haskell
login user password = if user == "unicorn73"
                      then if password == "f4bulous!"
                           then "unicorn73 logged in"
                           else "wrong password"
                      else "unknown user"
```
## 1.9.2 局部定义
Haskell有两种不同的方式来创建局部定义：`let...in`和`where`。

`where`为定义添加局部定义：

``` haskell
circleArea :: Double -> Double
circleArea r = pi * rsquare
    where pi = 3.1415926
          rsquare = r * r
```

`let...in`是一个表达式：

``` haskell
circleArea r = let pi = 3.1415926
                   rsquare = r * r
               in pi * rsquare
```
  
局部定义也可以是函数：

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

我们稍后会回到`let`和`where`的区别，但大多数情况下你可以使用你喜欢的任何一个。
## 1.9.3 关于不可变性

尽管像上面的`pi`这样的东西通常被称为变量，但我在这里选择称它们为定义。这是因为与Python或Java中的变量不同，这些定义的值是不能改变的。Haskell变量不是你可以放入新值的盒子，Haskell变量命名一个值（或者更确切地说，一个表达式），仅此而已。

我们稍后会在本课程中再次讨论不可变性，但现在只需要知道像这样的东西是不起作用的：

``` haskell
increment x = let x = x+1
              in x
```

这只是一个无限循环，因为它试图定义一个新的变量`x`，其属性为`x = x+1`。因此，在计算`x`时，Haskell只是不断地计算`1+1+1+1+...`无限地继续下去。

``` haskell
compute x = let a = x+1
                a = a*2
            in a
```

``` plaintext
error:
    Conflicting definitions for ‘a’
    Bound at: <interactive>:14:17
              <interactive>:15:17
```

这里我们在试图"更新"`a`的值时报错。

解释一下，局部定义可以**遮蔽**(shadow)在其他地方定义的变量的名称。遮蔽不是一个副作用。相反，遮蔽在更受限的作用域内创建一个新变量，该变量使用与外部作用域中某个变量相同的名称。例如，下面的函数`f`、`g`和`h`都是合法的：

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

如果我们将它们应用于全局常量`x`，我们会看到遮蔽的效果：

``` haskell
f 1 ==> 2
g 1 ==> 6
h 1 ==> 3

f x ==> 10
g x ==> 6
h x ==> 3
```

最好总是为局部变量选择新的名称，这样就永远不会发生遮蔽。这样，代码的读者就会理解表达式中使用的变量来自哪里。注意在下面的例子中，`f`和`g`并不遮蔽彼此的参数：

``` haskell
f :: Int -> Int
f x = 2 * x + 1

g :: Int -> Int
g x = x - 2
```
## 1.9.4 模式匹配
一个（函数的）定义可以由多个等式组成。这些等式按顺序与参数匹配，直到找到一个合适的。这被称为模式匹配。

Haskell中的模式匹配非常强大，我们将在本课程中不断学习关于它的新知识，但这里有几个初步的例子：
``` haskell
greet :: String -> String -> String
greet "Finland" name = "Hei, " ++ name
greet "Italy"   name = "Ciao, " ++ name
greet "England" name = "How do you do, " ++ name
greet _         name = "Hello, " ++ name
```

`greet`函数根据给定的国家和名字（都是`String`类型）生成一个问候语。它有三个国家的特殊情况，和一个默认情况。它是这样工作的：

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

特殊模式`_`可以匹配任何东西。它通常用于默认情况。因为模式是按顺序匹配的，所以（通常）将`_`情况放在最后很重要。否则像下面这种情况：

``` haskell
brokenGreet _         name = "Hello, " ++ name
brokenGreet "Finland" name = "Hei, " ++ name
```

现在第一种情况会被选中用于处理所有输入。

``` haskell
Prelude> brokenGreet "Finland" "Varpu"
"Hello, Varpu"
Prelude> brokenGreet "Sweden" "Ole"
"Hello, Ole"
```

GHC甚至会给你一个关于这段代码的警告：

``` plaintext
<interactive>:1:1: warning: [-Woverlapping-patterns]
    Pattern match is redundant
    In an equation for ‘brokenGreet’: brokenGreet "Finland" name = ...
```

下面是更多的例子。但首先让我们介绍标准库函数`show`，它可以将（几乎！）任何东西转换为字符串：

``` haskell
Prelude> show True
"True"
Prelude> show 3
"3"
```

所以，这里是一个带有模式匹配和实际使用值的默认情况（而不是用`_`忽略它）的函数例子：

``` haskell
describe :: Integer -> String
describe 0 = "zero"
describe 1 = "one"
describe 2 = "an even prime"
describe n = "the number " ++ show n
```

它的结果像这样：

``` haskell
Prelude> describe 0
"zero"
Prelude> describe 2
"an even prime"
Prelude> describe 7
"the number 7"
```

你甚至可以对多个参数进行模式匹配。同样，等式是按顺序尝试的。这是对前面`login`函数的重新实现：

``` haskell
login :: String -> String -> String
login "unicorn73" "f4bulous!" = "unicorn73 logged in"
login "unicorn73" _           = "wrong password"
login _           _           = "unknown user"
```
## 1.9.5 递归
在Haskell中，所有类型的循环都是用递归实现的。函数调用非常高效，所以你不需要担心性能。（我们稍后会讨论性能）。

学习如何用Haskell中的递归做简单的事情将帮助你在更复杂的问题上使用递归。递归也经常是思考如何解决更难问题的有用方法。

这是我们的第一个递归函数，它计算阶乘。在数学中，阶乘是前n个正整数的乘积，写作n!。阶乘的定义是

`n! = n * (n-1) * … * 1`

例如，`4! = 4 * 3 * 2 * 1 = 24`。总之，这里是阶乘的Haskell实现：
``` haskell
factorial :: Int -> Int
factorial 1 = 1
factorial n = n * factorial (n-1)
```

这是它的工作原理。我们用`==>`表示"求值为"。

``` haskell
factorial 3
  ==> 3 * factorial (3-1)
  ==> 3 * factorial 2
  ==> 3 * 2 * factorial 1
  ==> 3 * 2 * 1
  ==> 6
```

当你计算`factorial (-1)`时会发生什么？

这是另一个例子：

``` haskell
-- compute the sum 1^2+2^2+3^2+...+n^2 计算1^2+2^2+3^2+...+n^2的和
squareSum 0 = 0
squareSum n = n^2 + squareSum (n-1)
```
  
一个函数可以多次递归地调用自己。让我们考虑数学中的斐波那契序列作为例子。斐波那契序列是一个具有以下定义的整数序列。

序列从1, 1开始。要得到序列的下一个元素，将序列的前两个元素相加。

斐波那契序列的前几个元素是1, 1, 2, 3, 5, 8, 13等等。这里有一个`fibonacci`函数，它计算斐波那契序列中的第n个元素。注意它如何反映数学定义。

``` haskell
-- 斐波那契数，慢速版本
fibonacci 1 = 1
fibonacci 2 = 1
fibonacci n = fibonacci (n-2) + fibonacci (n-1)
```

这是`fibonacci 5`如何求值的：

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

注意`fibonacci 3`被计算了两次，`fibonacci 2`被计算了三次。这不是`fibonacci`函数最有效的实现。我们会在下一讲回到这个问题。另一种思考`fibonacci`函数求值的方式是将其可视化为一棵树（我们将`fibonacci`缩写为`fib`）：

![计算结果树形图](https://haskell.mooc.fi/img/Fibonacci-step2.svg)

  
![](https://haskell.mooc.fi/img/Fibonacci-step1.svg)

![](https://haskell.mooc.fi/img/Fibonacci-step2.svg)

![](https://haskell.mooc.fi/img/Fibonacci-step3.svg)

![](https://haskell.mooc.fi/img/Fibonacci-step4.svg)

![](https://haskell.mooc.fi/img/Fibonacci-step5.svg)

![](https://haskell.mooc.fi/img/Fibonacci-step6.svg)

![](https://haskell.mooc.fi/img/Fibonacci-step7.svg)

![？](https://haskell.mooc.fi/img/Fibonacci-step8.svg)


这棵树精确地对应于表达式(1 + 1) + (1 + (1 + 1))。递归经常可以产生链状、树状、嵌套或循环结构和计算。递归是函数式编程的主要技术之一，所以值得花些精力去学习它。

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
