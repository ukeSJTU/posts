 - 更多关于递归的知识
 - 守卫(Guards)
 - 更多类型：列表(`Lists`)， `Maybe`， `Either`
 - 多态(Polymorphism)
# 2.1 Recursion and Helper Functions 递归和辅助函数

很多时候你可能需要一些辅助变量(helper variables)来帮助你在递归的过程中记录数据。你可以通过定义一个带有更多参数的辅助函数(helper function)。你可以把辅助函数的参数类比为你会在一个循环当中更新的变量。

下面例子展示了你会如何将 Java 或者 Python 中的循环转换成 Haskell 中的一个递归辅助函数。

Java:
``` Java
public String repeatString(int n, String str) {
    String result = "";
    while (n>0) {
        result = result+str;
        n = n-1;
    }
    return result;
}
```

Python:
``` python
def repeatString(n, str):
    result = ""
    while n>0:
        result = result+str
        n = n-1
    return result
```

Haskell:
``` haskell
repeatString n str = repeatHelper n str ""

repeatHelper n str result = if (n==0)
                            then result
                            else repeatHelper (n-1) str (result++str)
```

``` haskell
Prelude> repeatString 3 "ABC"
"ABCABCABC"
```

你可能觉得上面的 Java 和 Python 代码看起来有点奇怪，这是因为我们用了`while`循环而不是`for`循环。前者转换成 Haskell 代码更加直观一些。

如果用模式匹配而不是`if`，上面的代码会看起来更简介一些：

``` haskell
repeatString n str = repeatHelper n str ""

repeatHelper 0 _   result = result
repeatHelper n str result = repeatHelper (n-1) str (result++str)
```

下面这个例子（高效地计算斐波那契数列）中使用了更多变量：

Java:
``` Java
public int fibonacci(int n) {
    int a = 0;
    int b = 1;
    while (n>1) {
        int c = a+b;
        a=b;
        b=c;
        n--;
    }
    return b;
}
```

Python:
``` Python
def fibonacci(n):
    a = 0
    b = 1
    while n>1:
        c = a+b
        a = b
        b = c
        n = n-1
    return b
```

Haskell:
``` haskell
-- fibonacci numbers, fast version
fibonacci :: Integer -> Integer
fibonacci n = fibonacci' 0 1 n

fibonacci' :: Integer -> Integer -> Integer -> Integer
fibonacci' a b 1 = b
fibonacci' a b n = fibonacci' b (a+b) (n-1)
```

给自己一点时间研究上面的程序。可以关注一下 Haskell 递归和（其他语言中的）循环看起来很像。

旁注：Haskell 程序一般用一撇(`'`)来表示这是一个辅助函数，例如上面求斐波那契数列的辅助函数`fibonacci'`。和数学一样，`foo'`读作`foo prime`。

我前面提到这样写的斐波那契函数更高效，你能看出来为什么吗？答案是它递归调用次数更少。表达式`fibonacci' _ _ n`会调用`fibonacci _ _ (n-1)`一次，也就是说我们只需要`n`步就可以计算出`fibonacci' _ _ n`。

像这种在函数最后一步是用不同参数调用自己的递归函数我们称作**尾递归(tail recursion)**。正如你前面看到的一样，尾递归和循环是对等的。这也是为什么尾递归一般都很高效：编译器识别到尾递归的时候它会自动生成循环操作对应的机器码。
# 2.2 Guards 守卫表达式

在我们开始研究新的数据类型之前，让我们再学习一个 Haskell 语法。

`if then else`这个结构有时候用起来很麻烦，特别是你有很多种情况需要考虑的时候。Haskell 提供了一个更方便的概念：**条件定义(conditional definition)** 或者**守卫定义(guarded definition)**。你可能觉得这个和模式匹配有一点像因为你都可以写多个方程，但是守卫定义让你能够用任意代码决定到底要使用哪个方程。守卫定义看起来像这样：

``` haskell
f x y z
  | condition1 = something
  | condition2 = other
  | otherwise  = somethingother
```

**条件(condition)** 可以是任何表达式只要它的类型是`Bool`。按照顺序，第一个计算出结果是`True`的条件被选中，Haskell 会执行它对应的方程。最后的`otherwise`算是`True`的一个别名，它被用做默认情况（当以上所有条件都没有满足的时候，就会执行`otherwise`）。

## 2.2.1 举例
下面是一些使用`Guards`的示例代码。`describe`函数“描述”输入的数。务必注意要将`"Two"`放在`"Even"`前面，否则你可以自己试一下当输入`2`的时候会发生什么。

``` haskell
describe :: Int -> String
describe n
  | n==2      = "Two"
  | even n    = "Even"
  | n==3      = "Three"
  | n>100     = "Big!!"
  | otherwise = "The number "++show n
```

下面这个则是用守卫表达式(Guard)求阶乘的函数。可以看到这与模式匹配的区别在于，这个针对负整数的输入不会陷入死循环。

``` haskell
factorial n
  | n<0       = -1
  | n==0      = 1
  | otherwise = n * factorial (n-1)
```

你甚至还可以像下面这个简单的猜年龄游戏一样，将模式匹配和守卫表达式结合在一起：

``` haskell
guessAge :: String -> Int -> String
guessAge "Griselda" age
    | age < 47 = "Too low!"
    | age > 47 = "Too high!"
    | otherwise = "Correct!"
guessAge "Hansel" age
    | age < 12 = "Too low!"
    | age > 12 = "Too high!"
    | otherwise = "Correct!"
guessAge name age = "Wrong name!"
```

``` haskell
Prelude> guessAge "Griselda" 30
"Too low!"
Prelude> guessAge "Griselda" 60
"Too high!"
Prelude> guessAge "Griselda" 47
"Correct!"
Prelude> guessAge "Bob" 30
"Wrong name!"
Prelude> guessAge "Hansel" 10
"Too low!"
```
# 2.3 列表(`Lists`)
到目前为止，我们一直在处理单一的值，比如数字或布尔值。字符串包含多个字符，但在某种意义上，字符串仍然只是一条信息。为了能够进行实际编程，我们需要处理可变数量的项目。为此，我们需要数据结构。

Haskell 中的基本数据结构是**列表(Lists)** 。列表用于存储相同类型的多个值。换句话说，Haskell列表是同质的(homogeneous)。列表字面量的长这样：

``` haskell
[0,3,4,1+1]
```

列表类型写作`[Element]`，其中`Element`指的就是列表中元素的类型。下面是一些更多的列表表达式和他们的类型：

``` haskell
[True,True,False] :: [Bool]
["Moi","Hei"] :: [String]
[] :: [a]                   -- more about this later
[[1,2],[3,4]] :: [[Int]]    -- a list of lists
[1..7] :: [Int]             -- range syntax, value [1,2,3,4,5,6,7]
```

Haskell 中的列表是通过**单链表(singly-linked list)** 实现的。我们会在以后再详细研究。
## 2.3.1 列表操作

Haskell 标准库自带许多可以在列表上进行操作的函数。下面是最常用的几个，以及他们的类型。如果你不理解什么是`[a]`，你可以暂时理解成“任意的列表”，我们过一会儿再研究这个。

``` haskell
head :: [a] -> a            -- returns the first element
last :: [a] -> a            -- returns the last element
tail :: [a] -> [a]          -- returns everything except the first element
init :: [a] -> [a]          -- returns everything except the last element
take :: Int -> [a] -> [a]   -- returns the n first elements
drop :: Int -> [a] -> [a]   -- returns everything except the n first elements
(++) :: [a] -> [a] -> [a]   -- lists are catenated with the ++ operator
(!!) :: [a] -> Int -> a     -- lists are indexed with the !! operator
reverse :: [a] -> [a]       -- reverse a list
null :: [a] -> Bool         -- is this list empty?
length :: [a] -> Int        -- the length of a list
```

> 注意：最后两个操作符 (`null` and `length`) 实际上具有更通用的类型，但在这里我假装它们只能用于列表。

我们还可以用我们熟悉的`==`运算符来比较两个lists是否相等。

你还记不记得我们最一开始在 GHCi 交互中遇到的：

``` haskell
Prelude> :t "asdf"
"asdf" :: [Char]
```

这说明`String`仅仅是`[Char]`的另一种写法，换句话说，字符串就是一个列表，列表的元素都是字符。再更进一步讲，我们上面所有对于列表的操作都可以用在字符串上。

This means that `String` is just an alias for `[Char]`, which means string is a list of characters. This means you can use all list operations on strings!

有一些列表操作需要你从`Data.List`模块中倒入，比如`sort`函数（排序函数）。你可以用`import Data.List`来导入。像这样：

``` haskell
Prelude> import Data.List
Prelude Data.List> sort [1,0,5,3]
[0,1,3,5]
```

可以观察到你导入的模块的名字出现在 GHCi 提示符(`>`)左侧。
## 2.3.2 举例

这里有一些处理列表的示例。在这种情况下，我不再向你展示 GHCi 的输出，而是用 ==> 来表示一个表达式的计算结果。

根据**下标(index)** 从列表中取值：

``` haskell
[7,10,4,5] !! 2
  ==> 4
```

用`take` 和 `drop`定义一个舍弃列表第三、第四个元素的函数：

``` haskell
f xs = take 2 xs ++ drop 4 xs
```

``` haskell
f [1,2,3,4,5,6]  ==>  [1,2,5,6]
f [1,2,3]        ==>  [1,2]
```

通过取列表第一个元素并拼接到剩余元素的后面来实现旋转列表的效果：

``` haskell
g xs = tail xs ++ [head xs]
```

``` haskell
g [1,2,3]      ==>  [2,3,1]
g (g [1,2,3])  ==>  [3,1,2]
```

下面这个例子是`Range`的语法：

``` haskell
reverse [1..4] ==> [4,3,2,1]
```
# 2.4 关于不可变性(Immutability)的简要说明

因为 Haskell 是纯粹的，这意味着函数不能**改变(mutate)** 它们的输入。改变(mutation)是一种副作用，而 Haskell 函数只能通过返回值输出。这意味着 Haskell 的列表函数总是返回一个新的列表（，而不是在你作为参数的列表上直接修改）。实际上：

``` haskell
Prelude> list = [1,2,3,4]
Prelude> reverse list
[4,3,2,1]
Prelude> list
[1,2,3,4]
Prelude> drop 2 list
[3,4]
Prelude> list
[1,2,3,4]
```

这看起来可能非常低效，但实际上它既可以高效又相当有用。我们将在以后回到 Haskell 数据结构的工作原理。
# 2.5 关于类型推断和多态性(Polymorphism)

那么，像 `head :: [a] -> a` 这样的类型是什么意思呢？这意味着给定一个包含任意类型 `a` 元素的列表，返回值将会是相同的类型 `a`。

在这个类型中，`a` 是一个类型变量。类型变量是以小写字母开头的类型，例如 `a`、`b`、`thisIsATypeVariable`。类型变量表示一种尚未确定的类型，换句话说，它可以是任何类型。通过类型推断（也称为**统一 (unification)** ）的过程，类型变量可以转变为具体类型（例如 `Bool`）。

让我们来看一些例子。如果我们将 `head` 应用到一个布尔值列表上，类型推断将比较 `head` 的参数类型 `[a]` 和实际参数的类型 `[Bool]`，并推断出 `a` 必须是 `Bool`。换句话说，这种情况下`head` 的返回类型也将是 `Bool`。

``` haskell
head :: [a] -> a
head [True,False] :: Bool
```

函数 `tail` 接受一个列表，并返回同一类型的列表。如果我们将 `tail` 应用到布尔值列表上，返回值也将是布尔值列表。

``` haskell
tail :: [a] -> [a]
tail [True,False] :: [Bool]
```

如果类型不匹配，我们会得到一个类型错误。考虑运算符 `++`，它接受两个相同类型的列表，从其类型 `[a] -> [a] -> [a]` 可以看出。如果我们尝试将 `++` 应用到一个布尔值列表和一个字符列表上，我们将得到一个错误。在 GHCi 中会发生以下情况：

``` haskell
Prelude> [True,False] ++ "Moi"

<interactive>:1:16:
    Couldn't match expected type `Bool' against inferred type `Char'
      Expected type: [Bool]
      Inferred type: [Char]
    In the second argument of `(++)', namely `"Moi"'
    In the expression: [True, False] ++ "Moi"
```

类型推断非常强大。它使用简单的统一过程(unification)为几乎任何 Haskell 表达式推断类型。考虑这两个函数：

``` haskell
f xs ys = [head xs, head ys]
g zs = f "Moi" zs
```

我们可以在 GHCi 中询问它们的类型，会发现类型推断已经确定 `f` 的两个参数必须具有相同类型，因为它们的头元素(head)被放入同一个列表中。

``` haskell
Prelude> :t f
f :: [a] -> [a] -> [a]
```

函数 `g` 将 `f` 的一个参数固定为字符串（即 `[Char]`），因此它得到了一个更窄的类型。类型推断已决定 `g` 的参数 `zs` 也必须是 `[Char]`，否则 `f` 的类型就无法与对 `f` 的调用匹配。

``` haskell
Prelude> :t g
g :: [Char] -> [Char]
```
## 2.5.1 附注: 一些术语

在像 `[Char]` 这样的类型中，我们称 `Char` 为类型参数。像列表类型这样需要类型参数的类型称为**参数化类型(`parameterized type`)** 。

像 `head` 这样的函数可以与许多不同类型的参数一起使用，这种特性称为**多态性(polymorphism)** 。`head` 函数被称为多态的。多态性有许多形式，而这种使用类型变量的 Haskell 形式称为**参数多态性(parametric polymorphism)** 。
## 2.5.2 附注: 类型注释

由于 Haskell 具有类型推断，因此您不需要提供任何类型注解。然而，尽管类型注解不是必需的，但添加它们有多个理由：

由于 Haskell 具有类型推断，你不需要提供任何类型注释。然而，即使类型注释不是必需的，添加它们有许多好处：
-  作为文档
- 作为编译器检查的断言：帮助你发现错误
- 你可以使用类型注释为函数提供比 Haskell 推断出的更窄的类型

一个好的经验法则是，为顶级定义提供类型注释。
# 2.6 `Maybe`类型

除了列表(`List`)，Haskell 还有其他参数化类型。让我们先看最常用也是最有用的一个：`Maybe`类型。

当我们编写程序的时候，有的操作不一定会有有效的返回值（例如：除数为零）。我们可以采取不同策略：
- 返回一个提前约定的错误码，比如说`-1`，但是这会让程序不够直观而且并不总是可靠；
- 抛出异常，但这是不纯粹的(impure)。但 Haskell 应该是纯粹的(pure)；
- 像其他很多语言中返回一个特殊的空值，比如`null`，但是 Haskell 中并没有这样的空值。

Haskell 提供了一个另外的解决措施，那就是`Maybe`类型。这种方式纯粹、安全且简洁。`Maybe a` 类型有两个**构造器(constructor)**：`Nothing` 和 `Just`。`Nothing` 只是一个常量，而 `Just` 则需要一个参数。更具体地说：

| 类型            | 值                                        |
| ------------- | ---------------------------------------- |
| `Maybe Bool`  | `Nothing`, `Just False`, `Just True`     |
| `Maybe Int`   | `Nothing`, `Just 0`, `Just 1`, …         |
| `Maybe [Int]` | `Nothing`, `Just []`, `Just [1,1337]`, … |

你可以将 `Maybe a` 看作有点类似于 `[a]`，但它只能包含 0 或 1 个元素，不能更多。或者，你也可以将 `Maybe a` 理解为给类型 `a` 引入了一个空值。如果你熟悉 Java，那么 `Maybe Integer` 就相当于 Java 中的 `Optional<Integer>`。

你可以用`Nothing`或者`Just 某个值`来构造`Maybe`类型的值：

``` haskell
Prelude> :t Nothing
Nothing :: Maybe a
Prelude> Just "a camel"
Just "a camel"
Prelude> :t Just "a camel"
Just "a camel" :: Maybe [Char]   -- 等同于 Maybe String
Prelude> Just True
Just True
Prelude> :t Just True
Just True :: Maybe Bool
```

``` haskell
-- 输入密码，如果成功登陆，返回 Just "用户名"，否则返回 Nothing
login :: String -> Maybe String
login "f4bulous!" = Just "unicorn73"
login "swordfish" = Just "megahacker"
login _           = Nothing
```

你可以通过对 `Maybe` 值进行模式匹配来使用它。通常，你需要为 `Nothing` 和 `Just something` 两种情况定义模式。下面是一些例子：

``` haskell
-- 将一个 Int 与一个 Maybe Int 相乘。Nothing 被视为不进行任何乘法运算。
perhapsMultiply :: Int -> Maybe Int -> Int
perhapsMultiply i Nothing = i
perhapsMultiply i (Just j) = i*j   -- 注意这里 j 表示 Just 中包含的值
```

``` haskell
Prelude> perhapsMultiply 3 Nothing
3
Prelude> perhapsMultiply 3 (Just 2)
6
```

``` haskell
intOrZero :: Maybe Int -> Int
intOrZero Nothing = 0
intOrZero (Just i) = i

safeHead :: [a] -> Maybe a
safeHead xs = if null xs then Nothing else Just (head xs)

headOrZero :: [Int] -> Int
headOrZero xs = intOrZero (safeHead xs)
```
``` haskell
headOrZero []  ==> intOrZero (safeHead [])  ==> intOrZero Nothing  ==> 0
headOrZero [1] ==> intOrZero (safeHead [1]) ==> intOrZero (Just 1) ==> 1
```
# 2.7 附注：构造器(Constructors)

如上所示，我们可以对 `Maybe` 的构造器进行模式匹配：`Just` 和 `Nothing`。稍后我们会详细讨论构造器的含义。现在你只需要知道，构造器是以大写字母开头的特殊值，你可以对它们进行模式匹配。

我们已经看到的其他构造器包括 `Bool` 的构造器 —— `True` 和 `False`。在下一节中，我们将介绍列表类型的构造器。

构造器可以像 Haskell 中的值一样使用。像 `Nothing` 和 `False` 这样的构造器不带任何参数，它们只是常量。像 `Just` 这样带参数的构造器则表现得像函数。它们甚至有函数类型！

``` haskell
Prelude> :t Just
Just :: a -> Maybe a
```
# 2.8 `Either` 类型

有时，我们希望能在 `Nothing` 中添加一条错误信息或其他内容。这就是我们拥有 `Either` 类型的原因。`Either` 类型需要两个类型参数。类型 `Either a b` 有两个**构造器(constructors)**：`Left` 和 `Right`。它们都需要一个参数，`Left` 需要一个类型为 `a` 的参数，而 `Right` 需要一个类型为 `b` 的参数。

| 类型                  | 值                                        |
|-----------------------|--------------------------------------------|
| `Either Int Bool`     | `Left 0`、`Left 1`、`Right False`、`Right True` 等。 |
| `Either String [Int]` | `Left "asdf"`、`Right [0,1,2]` 等。         |
| `Either Integer Integer` | `Left 0`、`Right 0`、`Left 1`、`Right 1` 等。 |

下面是一个简单的例子：一个只认识少量数字的 `readInt` 函数，而如果输入其他数字就返回一条描述错误的信息。请注意 Haskell 中的约定，使用 `Left` 表示错误，`Right` 表示成功。

```haskell
readInt :: String -> Either String Int
readInt "0" = Right 0
readInt "1" = Right 1
readInt s = Left ("Unsupported string: " ++ s)
```

**附注**：`Either` 的构造器被称为 `Left` 和 `Right` 是因为它们对应于 `Either` 的左右类型参数。注意在 `Either a b` 中，`a` 是左侧参数，`b` 是右侧参数。因此，`Left` 包含类型为 `a` 的值，`Right` 包含类型为 `b` 的值。将 `Right` 用于表示成功，可能是因为 "right" 也有 "正确" 的意思。这里没有冒犯左撇子群体的意思。

这里是另一个例子：对 `Either` 进行模式匹配。与 `Maybe` 类似，`Either` 有两个模式，每个构造器对应一个模式。

```haskell
iWantAString :: Either Int String -> String
iWantAString (Right str)   = str
iWantAString (Left number) = show number
```

我们前面提到，Haskell 列表只能包含相同类型的元素。你不能有类似 `[1, "foo", 2]` 这样的值。然而，你可以使用像 `Either` 这样的类型来表示包含两种不同类型值的列表。例如，我们可以记录讲座中的人数，并在缺少值时添加解释：

```haskell
lectureParticipants :: [Either String Int]
lectureParticipants = [Right 10, Right 13, Left "easter vacation", Right 17, Left "lecturer was sick", Right 3]
```

# 2.9 `case-of` 表达式

我们已经看到了函数参数中的模式匹配，但还有一种方法可以在表达式中进行模式匹配，格式如下：

``` haskell
case <value> of <pattern> -> <expression>
				<pattern> -> <expression>
```

例如，让我们用 `case` 重写第一节课中的 `describe` 例子：

``` haskell
describe :: Integer -> String
describe 0 = "zero"
describe 1 = "one"
describe 2 = "an even prime"
describe n = "the number " ++ show n
```

``` haskell
describe :: Integer -> String
describe n = case n of 0 -> "zero"
                       1 -> "one"
                       2 -> "an even prime"
                       n -> "the number " ++ show n
```

一个更有趣的例子是，当我们要进行模式匹配的值不是函数参数时。例如：

``` haskell
-- 将国家代码解析为国家名称，如果代码无法识别则返回 Nothing
parseCountry :: String -> Maybe String
parseCountry "FI" = Just "Finland"
parseCountry "SE" = Just "Sweden"
parseCountry _ = Nothing

flyTo :: String -> String
flyTo countryCode = case parseCountry countryCode of Just country -> "You're flying to " ++ country
                                                     Nothing -> "You're not flying anywhere"
```

运行结果：

``` haskell
Prelude> flyTo "FI"
"You're flying to Finland"
Prelude> flyTo "DE"
"You're not flying anywhere"
```

我们也可以使用一个辅助函数(`handleResult`)替代 `case-of` 表达式来实现 `flyTo`：

``` haskell
flyTo :: String -> String
flyTo countryCode = handleResult (parseCountry countryCode)
  where handleResult (Just country) = "You're flying to " ++ country
        handleResult Nothing        = "You're not flying anywhere"
```

实际上，`case-of` 表达式总是可以用辅助函数替代。下面是另一个例子，分别用两种方式实现：

``` haskell
-- 给定一个句子，判断它是陈述句、疑问句还是感叹句
sentenceType :: String -> String
sentenceType sentence = case last sentence of '.' -> "statement"
                                              '?' -> "question"
                                              '!' -> "exclamation"
                                              _   -> "not a sentence"
```

``` haskell
-- 使用辅助函数而非 case-of
sentenceType sentence = classify (last sentence)
  where classify '.' = "statement"
        classify '?' = "question"
        classify '!' = "exclamation"
        classify _   = "not a sentence"
```

``` haskell
Prelude> sentenceType "This is Haskell."
"statement"
Prelude> sentenceType "This is Haskell!"
"exclamation"
```
## 2.9.1 何时使用`case`表达式

你可能会问，为什么要有另一种模式匹配的语法呢？ 这是因为 `case` 表达式相较于方程式中使用模式匹配有一些优势，我们接下来将讨论这些优势。

首先，也许也是最重要的，`case` 表达式使我们能够对函数输出进行模式匹配。我们可能想要为工作（懒惰的）Haskellers 写一些早晨的激励语：

``` haskell
motivate :: String -> String
motivate "Monday"    = "Have a nice week at work!"
motivate "Tuesday"   = "You're one day closer to weekend!"
motivate "Wednesday" = "3 more day(s) until the weekend!"
motivate "Thursday"  = "2 more day(s) until the weekend!"
motivate "Friday"    = "1 more day(s) until the weekend!"
motivate _           = "Relax! You don't need to work today!"
```

使用 `case` 表达式，我们可以运行一个辅助函数来处理参数，并对其结果进行模式匹配：

``` haskell
motivate :: String -> String
motivate day = case distanceToSunday day of
  6 -> "Have a nice week at work!"
  5 -> "You're one day closer to weekend!"
  n -> if n > 1
       then show (n - 1) ++ " more day(s) until the weekend!"
       else "Relax! You don't need to work today!"
```

顺便说一下，还有第三种方法，使用守卫(Guards)：

``` haskell
motivate :: String -> String
motivate day
  | n == 6 = "Have a nice week at work!"
  | n == 5 = "You're one day closer to weekend!"
  | n > 1 = show (n - 1) ++ " more day(s) until the weekend!"
  | otherwise = "Relax! You don't need to work today!"
  where n = distanceToSunday day
```

稍后我们将看到如何用方程和 `case` 表达式来定义 `distanceToSunday`。

第二，如果一个辅助函数需要在多种模式(pattern)之间共享，那么方程就不适用。例如：

``` haskell
area :: String -> Double -> Double
area "square" x = square x
area "circle" x = pi * square x
  where square x = x * x
```

这段代码无法编译，因为 `where` 子句仅附加在 `"circle"` 的情况，因此 `square` 辅助函数在 `"square"` 的情况下不可用。而我们可以这样写：

``` haskell
area :: String -> Double -> Double
area shape x = case shape of
  "square" -> square x
  "circle" -> pi * square x
  where square x = x*x
```

第三，在需要多次重复一个（较长的）函数名称时，`case` 表达式可以帮助编写更简洁的代码。正如我们上面看到的那样，我们可能需要一个函数`distanceToSunday`来计算给定日期与周日之间的相差的天数：

``` haskell
distanceToSunday :: String -> Int
distanceToSunday "Monday"    = 6
distanceToSunday "Tuesday"   = 5
distanceToSunday "Wednesday" = 4
distanceToSunday "Thursday"  = 3
distanceToSunday "Friday"    = 2
distanceToSunday "Saturday"  = 1
distanceToSunday "Sunday"    = 0
```

使用 `case` 表达式可以实现更简洁的代码：

``` haskell
distanceToSunday :: String -> Int
distanceToSunday d = case d of
  "Monday"    -> 6
  "Tuesday"   -> 5
  "Wednesday" -> 4
  "Thursday"  -> 3
  "Friday"    -> 2
  "Saturday"  -> 1
  "Sunday"    -> 0
```

这三个优点使得 `case` 表达式成为 Haskeller 工具箱中一个多功能的工具。记住如何使用 `case` 是很值得的。

（用字符串来表示星期几虽然也能达到相同效果，但并非最优的解决方案。如果我们将 `motivate` 应用于 `"monday"`（全小写）或 `"keskiviikko"` 会发生什么呢？在第 5 讲中，我们将学习一种更好的表示星期几的方法。）
# 2.10 总结：模式匹配
可以用作模式(patterns)的内容：

- `Int` 和 `Integer` 常量，例如：`(-1)`、`0`、`1`、`2`、……
- `Bool` 值：`True` 和 `False`
- `Char` 常量：`'a'`、`'b'`
- `String` 常量：`"abc"`、`""`
- `Maybe` 构造器：`Nothing`、`(Just x)`
- `Either` 构造器：`(Left x)`、`(Right y)`
- 特殊的 `_` 模式，表示“任何东西，我不关心”
- 这些模式的组合，例如 `(Just 1)`
- 在接下来的课程中，我们将学习其他模式，例如列表。

可以使用模式(patterns)的地方：

- 使用方程定义函数:

``` haskell
f :: Bool -> Maybe Int -> Int
f False Nothing  = 1
f False _        = 2
f True  (Just i) = i
f True  Nothing  = 0
```

- 在 `case` 表达式中：

``` haskell
case number of 0 -> "zero"
               1 -> "one"
               _ -> "not zero or one"
```

实际上，你真正需要使用模式匹配的场景是获取 `Just`、`Left` 或 `Right` 构造器内的值。下面是两个示例：

``` haskell
-- getElement (Just i) 获取列表中第 i 个元素（从零开始计数），getElement Nothing 获取最后一个元素
getElement :: Maybe Int -> [a] -> a
getElement (Just i) xs = xs !! i
getElement Nothing xs = last xs
```

运行结果：

``` haskell
Prelude> getElement Nothing "hurray!"
'!'
Prelude> getElement (Just 3) [5,6,7,8,9]
8
```

``` haskell
direction :: Either Int Int -> String
direction (Left i) = "you should go left " ++ show i ++ " meters!"
direction (Right i) = "you should go right " ++ show i ++ " meters!"
```

运行结果：

``` haskell
Prelude> direction (Left 3)
"you should go left 3 meters!"
Prelude> direction (Right 5)
"you should go right 5 meters!"
```

到目前为止，我们看到的其他模式匹配用法也可以使用 `==` 运算符来实现。然而，像 `x == Nothing` 这样的表达式并不总是适用。我们将在第 4 讲中讨论类型类时了解其中的原因。
# 2.11 小测

> [!question] Q1. `f x = [x, x]` 返回多少个值？
> 
> A. 零个  
> B. 一个  
> C. 两个  

> [!question] Q2. 为什么表达式 `Nothing 1` 会导致类型错误？
> 
> A. 因为 `Nothing` 不接受任何参数  
> B. 因为 `Nothing` 不返回任何值  
> C. 因为 `Nothing` 是一个构造器  

> [!question] Q3. 函数 `f x y = if x && y then Right x else Left "foo"` 的类型是什么？
> 
> A. `Bool -> Bool -> Either Bool String`  
> B. `String -> String -> Either String String`  
> C. `Bool -> Bool -> Either String Bool`  

> [!question] Q4. 以下哪个函数可能具有类型 `Bool -> Int -> [Bool]`？
> 
> A. `f x y = [0, y]`  
> B. `f x y = [x, True]`  
> C. `f x y = [y, True]`  

> [!question] Q5. 这个函数的类型是什么？`justBoth a b = [Just a, Just b]`
> 
> A. `a -> b -> [Maybe a, Maybe b]`  
> B. `a -> a -> [Just a]`  
> C. `a -> b -> [Maybe a]`  
> D. `a -> a -> [Maybe a]`  

> [!tip]- 答案  
> 1. B  
> 2. A  
> 3. C  
> 4. B  
> 5. D
# 2.12 练习
- [Set2a](https://github.com/moocfi/haskell-mooc/blob/master/exercises/Set2a.hs)
- [Set2b](https://github.com/moocfi/haskell-mooc/blob/master/exercises/Set2b.hs)

