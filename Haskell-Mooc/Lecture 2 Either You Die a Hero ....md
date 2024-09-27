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
# 2.6 The `Maybe` Type
In addition to the list type, Haskell has other parameterized types too. Let’s look at a very common and useful one: the `Maybe` type.

Sometimes an operation doesn’t have a valid return value (E.g. division by zero.). We have a couple of options in this situation. We can use an error value, like `-1`. This is a bit ugly, not always possible. We can throw an exception. This is impure. In some other languages we would return a special null value that exists in (almost) all types. However Haskell does not have a null.

The solution Haskell offers us instead is to change our return type to a `Maybe` type. This is pure, safe and neat. The type `Maybe a` has two _constructors_: `Nothing` and `Just`. `Nothing` is just a constant, but `Just` takes a parameter. More concretely:

|Type|Values|
|---|---|
|`Maybe Bool`|`Nothing`, `Just False`, `Just True`|
|`Maybe Int`|`Nothing`, `Just 0`, `Just 1`, …|
|`Maybe [Int]`|`Nothing`, `Just []`, `Just [1,1337]`, …|

You can think of `Maybe a` as being a bit like `[a]` except there can only be 0 or 1 elements, not more. Alternatively, you can think of `Maybe a` introducing a null value to the type `a`. If you’re familiar with Java, `Maybe Integer` is the Haskell equivalent of Java’s `Optional<Integer>`.

You can create `Maybe` values by either specifying `Nothing` or `Just someOtherValue`:
``` haskell
Prelude> :t Nothing
Nothing :: Maybe a
Prelude> Just "a camel"
Just "a camel"
Prelude> :t Just "a camel"
Just "a camel" :: Maybe [Char]   -- the same as Maybe String
Prelude> Just True
Just True
Prelude> :t Just True
Just True :: Maybe Bool
```

``` haskell
-- given a password, return (Just username) if login succeeds, Nothing otherwise
login :: String -> Maybe String
login "f4bulous!" = Just "unicorn73"
login "swordfish" = Just "megahacker"
login _           = Nothing
```

You use a `Maybe` value by pattern matching on it. Usually you define patterns for the `Nothing` and `Just something` cases. Some examples:
``` haskell
-- Multiply an Int with a Maybe Int. Nothing is treated as no multiplication at all.
perhapsMultiply :: Int -> Maybe Int -> Int
perhapsMultiply i Nothing = i
perhapsMultiply i (Just j) = i*j   -- Note how j denotes the value inside the Just
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
# 2.7 Sidenote: Constructors
如上所示，我们可以对 Maybe 的构造函数进行模式匹配：Just 和 Nothing。稍后我们会回到构造函数的含义。现在只需注意，构造函数是以大写字母开头的特殊值，可以进行模式匹配。

我们已经看到的其他构造函数包括 Bool 的构造函数——True 和 False。我们将在下一节课中介绍列表类型的构造函数。

构造函数可以像 Haskell 值一样使用。像 Nothing 和 False 这样的构造函数没有参数，实际上就是常量。像 Just 这样的构造函数接受一个参数，表现得像函数。它们甚至具有函数类型！

> TODO 没看懂什么意思。

``` haskell
Prelude> :t Just
Just :: a -> Maybe a
```
# 2.8 The `Either` Type
Sometimes it would be nice if you could add an error message or something to `Nothing`. That’s why we have the `Either` type. The `Either` type takes two type arguments. The type `Either a b` has two constructors: `Left` and `Right`. Both take an argument, `Left` an argument of type `a` and `Right` an argument of type `b`.

|Type|Values|
|---|---|
|`Either Int Bool`|`Left 0`, `Left 1`, `Right False`, `Right True`, …|
|`Either String [Int]`|`Left "asdf"`, `Right [0,1,2]`, …|
|`Either Integer Integer`|`Left 0`, `Right 0`, `Left 1`, `Right 1`, …|

Here’s a simple example: a `readInt` function that only knows a couple of numbers and returns a descriptive error for the rest. Note the Haskell convention of using `Left` for errors and `Right` for success.

``` haskell
readInt :: String -> Either String Int
readInt "0" = Right 0
readInt "1" = Right 1
readInt s = Left ("Unsupported string: " ++ s)
```
> Sidenote: `Either` 的构造函数被称为 `Left` 和 `Right`，因为它们分别指代 Either 的左侧和右侧类型参数。注意在 `Either a b` 中，`a` 是左侧参数，`b` 是右侧参数。因此，`Left` 包含类型为 `a` 的值，而 `Right` 则包含类型为 `b` 的值。使用 `Right` 表示成功的惯例可能仅仅是因为 right 也意味着正确。并无冒犯左撇子之意。

Here’s another example: pattern matching an `Either`. Just like with `Maybe`, there are two patterns for an `Either`, one for each constructor.

``` haskell
iWantAString :: Either Int String -> String
iWantAString (Right str)   = str
iWantAString (Left number) = show number
```

As you recall, Haskell lists can only contain elements of the same type. You can’t have a value like `[1,"foo",2]`. However, you can use a type like `Either` to represent lists that can contain two different types of values. For example we could track the number of people on a lecture, with a possibility of adding an explanation if a value is missing:

``` haskell
lectureParticipants :: [Either String Int]
lectureParticipants = [Right 10, Right 13, Left "easter vacation", Right 17, Left "lecturer was sick", Right 3]
```
# 2.9 The `case-of` Expression
我们已经在函数参数中看到了模式匹配，但在表达式中也可以进行模式匹配。它看起来是这样的：
``` haskell
case <value> of <pattern> -> <expression>
				<pattern> -> <expression>
```

As an example let’s rewrite the `describe` example from the first lecture using `case`:

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

A more interesting example is when the value we’re pattern matching on is not a function argument. For example:

``` haskell
-- parse country code into country name, returns Nothing if code not recognized
parseCountry :: String -> Maybe String
parseCountry "FI" = Just "Finland"
parseCountry "SE" = Just "Sweden"
parseCountry _ = Nothing

flyTo :: String -> String
flyTo countryCode = case parseCountry countryCode of Just country -> "You're flying to " ++ country
                                                     Nothing -> "You're not flying anywhere"
```

``` haskell
Prelude> flyTo "FI"
"You're flying to Finland"
Prelude> flyTo "DE"
"You're not flying anywhere"
```

We could write the `flyTo` function using a helper function for pattern matching instead of using the case-of expression:

``` haskell
flyTo :: String -> String
flyTo countryCode = handleResult (parseCountry countryCode)
  where handleResult (Just country) = "You're flying to " ++ country
        handleResult Nothing        = "You're not flying anywhere"
```

In fact, a case-of expression can always be replaced with a helper function. Here’s one more example, written in both ways:

``` haskell
-- given a sentence, decide whether it is a statement, question or exclamation
sentenceType :: String -> String
sentenceType sentence = case last sentence of '.' -> "statement"
                                              '?' -> "question"
                                              '!' -> "exclamation"
                                              _   -> "not a sentence"
```

``` haskell
-- same function, helper function instead of case-of
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
## 2.9.1 When to Use Case Expressions
你可能会问，为什么还需要另一种模式匹配语法。好吧，`case` 表达式相较于方程式有一些优势，我们接下来会讨论这些。

首先，也许最重要的是，`case` 表达式使我们能够对函数输出进行模式匹配。我们可能想要为工作（懒惰的）Haskellers 写一些清晨的激励信息：
``` haskell
motivate :: String -> String
motivate "Monday"    = "Have a nice week at work!"
motivate "Tuesday"   = "You're one day closer to weekend!"
motivate "Wednesday" = "3 more day(s) until the weekend!"
motivate "Thursday"  = "2 more day(s) until the weekend!"
motivate "Friday"    = "1 more day(s) until the weekend!"
motivate _           = "Relax! You don't need to work today!"
```

Using a `case` expression we can run a helper function against the argument and pattern match on the result:

``` haskell
motivate :: String -> String
motivate day = case distanceToSunday day of
  6 -> "Have a nice week at work!"
  5 -> "You're one day closer to weekend!"
  n -> if n > 1
       then show (n - 1) ++ " more day(s) until the weekend!"
       else "Relax! You don't need to work today!"
```

By the way, there’s also a third way, guards:

``` haskell
motivate :: String -> String
motivate day
  | n == 6 = "Have a nice week at work!"
  | n == 5 = "You're one day closer to weekend!"
  | n > 1 = show (n - 1) ++ " more day(s) until the weekend!"
  | otherwise = "Relax! You don't need to work today!"
  where n = distanceToSunday day
```

We’ll see in a moment how we can define `distanceToSunday` using equations and `case` expressions.

Secondly, if a helper function needs to be shared among many patterns, then equations don’t work. For example:

``` haskell
area :: String -> Double -> Double
area "square" x = square x
area "circle" x = pi * square x
  where square x = x * x
```

This won’t compile because a the `where` clause only appends to the `"circle"` case, so the `square` helper function is not available in the `"square"` case. On the other hand, we can write

``` haskell
area :: String -> Double -> Double
area shape x = case shape of
  "square" -> square x
  "circle" -> pi * square x
  where square x = x*x
```

Thirdly, `case` expressions may help to write more concise code in a situation where a (long) function name would have to be repeated multiple times using equations. As we saw above, we might need a function which measures the distance between a given day and Sunday:

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

Using a `case` expression leads into much more concise implementation:

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

These three benefits make the `case` expression a versatile tool in a Haskeller’s toolbox. It’s worth remembering how `case` works.

(Representing weekdays as strings may get the job done, but it’s not the perfect solution. What happens if we apply `motivate` to `"monday"` (with all letters in lower case) or `"keskiviikko"`? In Lecture 5, we will learn a better way to represent things like weekdays.)
# 2.10 Recap: Pattern Matching
Things you can use as patterns:

- `Int` and `Integer` constants like `(-1)`, `0`, `1`, `2`, …
- `Bool` values `True` and `False`
- `Char` constants: `'a'`, `'b'`
- `String` constants: `"abc"`, `""`
- `Maybe` constructors: `Nothing`, `(Just x)`
- `Either` constructors: `(Left x)`, `(Right y)`
- The special `_` pattern which means “anything, I don’t care”
- Combinations of these patterns, like for example `(Just 1)`
- We’ll learn about other patterns, for example lists, in the next lectures.

Places where you can use patterns:
- Defining a function with equations:
``` haskell
f :: Bool -> Maybe Int -> Int
f False Nothing  = 1
f False _        = 2
f True  (Just i) = i
f True  Nothing  = 0
```
- In the `case of` expression:
``` haskell
case number of 0 -> "zero"
               1 -> "one"
               _ -> "not zero or one"
```

The only thing you really _need_ pattern matching for is _getting the value_ inside a `Just`, `Left` or `Right` constructor. Here are two more examples of this:

``` haskell
-- getElement (Just i) gets the ith element (counting from zero) of a list, getElement Nothing gets the last element
getElement :: Maybe Int -> [a] -> a
getElement (Just i) xs = xs !! i
getElement Nothing xs = last xs
```

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

``` haskell
Prelude> direction (Left 3)
"you should go left 3 meters!"
Prelude> direction (Right 5)
"you should go right 5 meters!"
```

Other uses (that we’ve seen so far!) of pattern matching can also be accomplished with the `==` operator. However, things like `x==Nothing` won’t work in all cases. We’ll find out why when we talk about type classes in lecture 4.
# 2.11 Quiz
BACBD
How many values does `f x = [x,x]` return?

1. Zero
2. One
3. Two

Why does the expression `Nothing 1` cause a type error?

1. Because `Nothing` takes no arguments
2. Because `Nothing` returns nothing
3. Because `Nothing` is a constructor

What is the type of the function `f x y = if x && y then Right x else Left "foo"`?

1. `Bool -> Bool -> Either Bool String`
2. `String -> String -> Either String String`
3. `Bool -> Bool -> Either String Bool`

Which of the following functions could have the type `Bool -> Int -> [Bool]`

1. `f x y = [0, y]`
2. `f x y = [x, True]`
3. `f x y = [y, True]`

What is the type of this function? `justBoth a b = [Just a, Just b]`

1. `a -> b -> [Maybe a, Maybe b]`
2. `a -> a -> [Just a]`
3. `a -> b -> [Maybe a]`
4. `a -> a -> [Maybe a]`
# 2.12 Exercises
- [Set2a](https://github.com/moocfi/haskell-mooc/blob/master/exercises/Set2a.hs)
- [Set2b](https://github.com/moocfi/haskell-mooc/blob/master/exercises/Set2b.hs)

