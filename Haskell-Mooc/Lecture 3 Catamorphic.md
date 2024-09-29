- Lists, lists, lists
- Functionality
- A bit about types

## 3.1 终于进入函数式编程

现在，我们已经掌握了列表和多态性，终于可以开始学习函数式编程了。

在 Haskell 中，函数是一种值，就像数字或列表一样。函数可以作为参数传递给其他函数。以下是一个简单的例子。函数 `applyTo1` 接受一个类型为 `Int -> Int` 的函数，将其应用于数字 `1`，并返回结果。

``` haskell
applyTo1 :: (Int -> Int) -> Int
applyTo1 f = f 1
```

定义一个简单的类型为 `Int -> Int` 的函数，看看 `applyTo1` 是如何运作的：

``` haskell
addThree :: Int -> Int
addThree x = x + 3
```

``` haskell
applyTo1 addThree
  ==> addThree 1
  ==> 1 + 3
  ==> 4
```

让我们回到 `applyTo1` 的类型注解：

``` haskell
applyTo1 :: (Int -> Int) -> Int
```

括号是必需的，因为类型 `Int -> Int -> Int` 表示一个接受两个 `Int` 参数的函数。稍后我们会详细讨论这个问题。

让我们看一个稍微复杂一点的例子。这次我们将实现一个多态函数 `doTwice`。注意它可以与不同类型的值和函数一起使用：

``` haskell
doTwice :: (a -> a) -> a -> a
doTwice f x = f (f x)
```

``` haskell
doTwice addThree 1
  ==> addThree (addThree 1)
  ==> 7
doTwice tail "abcd"
  ==> tail (tail "abcd")
  ==> "cd"
```

``` haskell
makeCool :: String -> String
makeCool str = "WOW " ++ str ++ "!"
```

``` haskell
doTwice makeCool "Haskell"
  ==> "WOW WOW Haskell!!"
```
### 3.1.1 列表上的函数式编程

这有点无聊。幸运的是，有许多有用的列表函数可以将函数作为参数。顺便说一句，接受函数作为参数（或返回函数）的函数通常被称为**高阶函数(higher-order functions)**。

最著名的这些用于列表处理的高阶函数是 `map`。它通过将给定函数应用于列表的所有元素来生成一个新列表。

``` haskell
map :: (a -> b) -> [a] -> [b]
```

``` haskell
map addThree [1,2,3]
  ==> [4,5,6]
```

`map` 的“搭档”是 `filter`。`filter` 不会转换列表的所有元素，而是删除一些元素并保留其他元素。换句话说，`filter` 从列表中选择满足条件的元素。

``` haskell
filter :: (a -> Bool) -> [a] -> [a]
```

下面是一个示例：从列表中选择正数：

``` haskell
positive :: Int -> Bool
positive x = x>0
```

``` haskell
filter positive [0,1,-1,3,-3]
  ==> [1,3]
```

注意 `map` 和 `filter` 的类型签名（类型注解）都是多态的。它们可以用于所有类型的列表。`map` 的类型签名（类型注解）甚至使用了两个类型参数！以下是使用 `map` 和 `filter` 进行类型推断的一些示例：

``` haskell
onlyPositive xs = filter positive xs
mapBooleans f = map f [False,True]
```
 
``` haskell
Prelude> :t onlyPositive
onlyPositive :: [Int] -> [Int]
Prelude> :t mapBooleans
mapBooleans :: (Bool -> b) -> [b]
Prelude> :t mapBooleans not
mapBooleans not :: [Bool]
```

再说一件事：还记得构造器只是函数吗？这意味着你可以将它们作为参数传递给其他函数！

``` haskell
wrapJust xs = map Just xs
```

``` haskell
Prelude> :t wrapJust
wrapJust :: [a] -> [Maybe a]
Prelude> wrapJust [1,2,3]
[Just 1,Just 2,Just 3]
```
### 3.1.2 列表上的函数式编程示例

在 `1` 和 `n` 之间有多少个“回文数”？

``` haskell
-- 判断一个字符串是否为回文
palindrome :: String -> Bool
palindrome str = str == reverse str

-- palindromes n 获取从 1 到 n 的所有数字，将它们转换为字符串，并仅保留回文
palindromes :: Int -> [String]
palindromes n = filter palindrome (map show [1..n])
```

``` haskell
palindrome "1331" ==> True
palindromes 150 ==>
  ["1","2","3","4","5","6","7","8","9",
   "11","22","33","44","55","66","77","88","99",
   "101","111","121","131","141"]
length (palindromes 9999) ==> 198
```

一个字符串中有多少单词以 “a” 开头？这需要使用 `Data.List` 模块中的 `words` 函数来将字符串分割成单词。

``` haskell
countAWords :: String -> Int
countAWords string = length (filter startsWithA (words string))
  where startsWithA s = head s == 'a'
```

``` haskell
countAWords "does anyone want an apple?"
  ==> 3
```

`Data.List` 中的 `tails` 函数返回列表的所有后缀（“尾部”）。我们可以使用 `tails` 进行许多字符串处理任务。以下是 `tails` 的工作方式：

``` haskell
tails "echo"
  ==> ["echo","cho","ho","o",""]
```

下面是一个例子，我们找出在字符串中给定字符之后出现的所有字符。首先，我们使用 `tails`、`map` 和 `take` 获取所有指定长度的子字符串：

``` haskell
substringsOfLength :: Int -> String -> [String]
substringsOfLength n string = map shorten (tails string)
  where shorten s = take n s
```

``` haskell
substringsOfLength 3 "hello"
  ==> ["hel","ell","llo","lo","o",""]
```

末尾会留下一些较短的子字符串（你能看出为什么吗？），但它们目前对于我们的目的来说没问题。现在我们有了 `substringsOfLength`，可以实现函数 `whatFollows c k s`，它找到字符 `c` 在字符串 `s` 中的所有出现位置，并输出这些出现位置之后的 `k` 个字符。

``` haskell
whatFollows :: Char -> Int -> String -> [String]
whatFollows c k string = map tail (filter match (substringsOfLength (k+1) string))
  where match sub = take 1 sub == [c]
```

``` haskell
whatFollows 'a' 2 "abracadabra"
  ==> ["br","ca","da","br",""]
```
## 3.2 部分应用(Partial Application)

在使用高阶函数时，你可能会定义许多小的辅助函数，比如之前例子中的 `addThree` 或 `shorten`。从长远来看，这可能会有些繁琐，但幸运的是，Haskell 的函数行为有点特殊……

让我们在 GHCi 中尝试下面代码：

``` haskell
Prelude> add a b = a+b
Prelude> add 1 5
6
Prelude> addThree = add 3
Prelude> addThree 2
5
```

我们定义了一个接受两个参数的函数 `add`，但只给了它一个参数。可这并没有导致类型错误，而是产生了一个新函数。这个新函数存储（或记住）了已提供的参数，等待另一个参数，然后将两个参数都交给 `add`。

``` haskell
Prelude> map addThree [1,2,3]
[4,5,6]
Prelude> map (add 3) [1,2,3]
[4,5,6]
```

这里我们看到甚至不需要为 `add 3` 返回的函数命名。我们可以在需要一个接受一个参数的函数的地方使用它。

这种现象被称为**部分应用(partial application)**。在 Haskell 中，所有的函数都可以这样使用。让我们仔细看看。以下是一个接受多个参数的函数：

``` haskell
between :: Integer -> Integer -> Integer -> Bool
between lo high x = x < high && x > lo
```

``` haskell
Prelude> between 3 7 5
True
Prelude> between 3 6 8
False
```

我们可以像对 `add` 所做的那样，给 `between` 更少的参数并获得新函数：

``` haskell
Prelude> (between 1 5) 2
True
Prelude> let f = between 1 5 in f 2
True
Prelude> map (between 1 3) [1,2,3]
[False,True,False]
```

看看部分应用 `between` 的类型。它们表现得很有规律，随着值被添加到表达式中，参数逐个从类型中消失。

``` haskell
Prelude> :t between
between :: Integer -> Integer -> Integer -> Bool
Prelude> :t between 1
between 1 :: Integer -> Integer -> Bool
Prelude> :t between 1 2
between 1 2 :: Integer -> Bool
Prelude> :t between 1 2 3
between 1 2 3 :: Bool
```

实际上，当我们编写类型 `Integer -> Integer -> Integer -> Bool` 时，它表示 `Integer -> (Integer -> (Integer -> Bool))`。也就是说，多参数函数只是一个返回函数的函数。同样，像 `between 1 2 3` 这样的表达式等同于 `((between 1) 2) 3`，因此将多个参数传递给函数是通过多次单参数调用实现的。以这种方式表示多参数函数被称为**柯里化**（源自逻辑学家 Haskell Curry）。柯里化使部分应用成为可能。

这是另一个使用 `map` 进行部分应用的例子：

``` haskell
map (drop 1) ["Hello","World!"]
  ==> ["ello","orld!"]
```

除了普通函数，部分应用也适用于运算符。对于运算符，你可以选择应用左侧或右侧参数。（部分应用的运算符也称为**区间 sections**或**运算符区间 operator sections**）。例如：

``` haskell
Prelude> map (*2) [1,2,3]
[2,4,6]
Prelude> map (2*) [1,2,3]
[2,4,6]
Prelude> map (1/) [1,2,3,4,5]
[1.0,0.5,0.3333333333333333,0.25,0.2]
```
## 3.3 前缀和中缀表示法

普通的 Haskell 函数使用**前缀表示法(prefix notation)**，这只是一个表示函数名位于参数之前的说法。相比之下，运算符使用**中缀表示法(infix notation)** —— 函数名位于参数之间。

可以通过给运算符添加括号将其转换为前缀函数。例如：

``` haskell
(+) 1 2 ==> 1 + 2 ==> 3
```

这在需要将运算符作为参数传递给另一个函数时特别有用。

例如，`zipWith` 函数接受两个列表和一个二元函数，并使用该函数合并列表。我们可以使用 `zipWith (+)` 来对两个列表逐个元素求和：

``` haskell
Prelude> :t zipWith
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
Prelude> zipWith (+) [0,2,5] [1,3,3]
[1,5,8]
```

如果没有将运算符转换为函数的能力，我们就必须使用辅助函数，比如上面的 `add`。

请注意，省略括号会导致类型错误：

``` haskell
Prelude> zipWith + [0,2,5,3] [1,3,3]

<interactive>:1:11: error:
    • Couldn't match expected type ‘[Integer]
                                    -> (a -> b -> c) -> [a] -> [b] -> [c]’
                  with actual type ‘[Integer]’
    • The function ‘[0, 2, 5, 3]’ is applied to one argument,
      but its type ‘[Integer]’ has none
      In the second argument of ‘(+)’, namely ‘[0, 2, 5, 3] [1, 3, 3]’
      In the expression: zipWith + [0, 2, 5, 3] [1, 3, 3]
    • Relevant bindings include
        it :: (a -> b -> c) -> [a] -> [b] -> [c]
          (bound at <interactive>:1:1)
```

这个看起来很奇怪的错误的原因是 GHCi 被弄糊涂了，认为我们在尝试将 `zipWith` 与 `[0, 2, 5, 3] [1, 3, 3]` 相加。逻辑上，它推断出 `[0, 2, 5, 3]` 必须是一个函数，因为它被应用于 `[1, 3, 3]`（记住函数绑定比运算符更紧密）。

不幸的是，错误消息有时会显得晦涩，因为编译器无法总是知道错误的“真正”原因（在这种情况下是省略了括号）。奇怪的错误消息令人沮丧，但只有程序员知道代码的初衷是什么。

Haskell 的另一个很好的特性是可以将一个二元函数当作中缀运算符来使用，只需用反引号（\`）将它括起来。例如：

``` haskell
6 `div` 2 ==> div 6 2 ==> 3
(+1) `map` [1,2,3] ==> map (+1) [1,2,3] ==> [2,3,4]
```
## 3.4 Lambda 表达式

函数式编程工具箱中我们需要的最后一个工具是 λ（lambda）。Lambda 表达式是**匿名函数(anonymous)**。考虑这样一种情况：你只需要一次性使用一个函数，例如在如下表达式中：

``` haskell
let big x = x>7 in filter big [1,10,100]
```

Lambda 表达式允许我们直接写出这个函数，而不需要为辅助函数定义一个名字（如 `big`）：

``` haskell
filter (\x -> x>7) [1,10,100]
```

下面是一些在 GHCi 中的示例：

``` haskell
Prelude> (\x -> x*x) 3
9
Prelude> (\x -> reverse x == x) "ABBA"
True
Prelude> filter (\x -> reverse x == x) ["ABBA","ACDC","otto","lothar","anna"]
["ABBA","otto","anna"]
Prelude> (\x y -> x^2+y^2) 2 3           -- 多个参数
13
```

Haskell 中的 lambda 语法有点令人惊讶。反斜杠（`\`）代表希腊字母 λ（lambda）。Haskell 表达式 `\x -> x + 1` 是对数学符号 λx. x + 1 的一种模仿。其他编程语言使用类似 `x => x + 1`（JavaScript）或 `lambda x: x + 1`（Python）的语法。

**注意！** 你从不**必须**使用 lambda 表达式。你总是可以使用 `let` 或 `where` 来定义函数。

顺便说一下，lambda 表达式是非常强大的构造，在其自身领域有着深厚的理论，称为[λ演算](https://en.wikipedia.org/wiki/Lambda_calculus)。有些人甚至认为，像 Haskell 这样的纯函数式编程语言是 λ演算的类型扩展，增加了额外的语法。
## 3.5 附注：`.` 和 `$` 运算符

Haskell 代码中最常见的两个运算符可能就是 `.` 和 `$`。它们在编写使用高阶函数的代码时非常有用。首先，`.` 运算符是**函数组合**运算符。它的类型为：

``` haskell
(.) :: (b -> c) -> (a -> b) -> a -> c
```

它的作用是：

``` haskell
(f.g) x ==> f (g x)
```

你可以使用函数组合来构建函数，而不需要提及任何参数。例如：

``` haskell
double x = 2 * x
quadruple = double . double  -- 计算 2 * (2 * x) == 4 * x
f = quadruple . (+1)         -- 计算 4 * (x + 1)
g = (+1) . quadruple         -- 计算 4 * x + 1
third = head . tail . tail   -- 获取列表的第三个元素
```

我们还可以用 `.` 重新实现 `doTwice`。注意我们可以只将 `doTwice` 应用于一个函数，或者应用于一个函数和一个值。

``` haskell
doTwice :: (a -> a) -> a -> a
doTwice f = f . f
```

``` haskell
let ttail = doTwice tail
in ttail [1,2,3,4]
  ==> [3,4]

(doTwice tail) [1,2,3,4] ==> [3,4]

doTwice tail [1,2,3,4] ==> [3,4]
```

通常，函数组合并非用于定义新函数，而是为了避免定义辅助函数。例如，看看这两个表达式之间的区别：

``` haskell
let notEmpty x = not (null x)
in filter notEmpty [[1,2,3],[],[4]]
  ==> [[1,2,3],[4]]
```

``` haskell
filter (not . null) [[1,2,3],[],[4]]
  ==> [[1,2,3],[4]]
```

另一个运算符 `$` 比较微妙。让我们看看它的类型。

``` haskell
($) :: (a -> b) -> a -> b
```

它接受一个类型为 `a -> b` 的函数和一个类型为 `a` 的值，返回一个类型为 `b` 的值。换句话说，它是一个函数应用运算符。表达式 `f $ x` 与 `f x` 是一样的。这看起来似乎没什么用，但 `$` 运算符可以用来消除括号！这些表达式是等价的：

``` haskell
head (reverse "abcd")
head $ reverse "abcd"
```

当它用于消除一对括号时可能不那么引人注目，但与 `.` 一起使用可以消除很多括号！例如，我们把下面这个代码：

``` haskell
reverse (map head (map reverse (["Haskell","pro"] ++ ["dodo","lyric"])))
```

重写成：

``` haskell
(reverse . map head . map reverse) (["Haskell","pro"] ++ ["dodo","lyric"])
```

然后再进一步改写为：

``` haskell
reverse . map head . map reverse $ ["Haskell","pro"] ++ ["dodo","lyric"]
```

有时，运算符 `.` 和 `$` 本身也可以用作函数。例如，可以使用 `map` 和 `$` 的区间将一个函数列表应用于一个参数：

``` haskell
map ($"string") [reverse, take 2, drop 2]
  ==> [reverse $ "string", take 2 $ "string", drop 2 $ "string"]
  ==> [reverse "string", take 2 "string", drop 2 "string"]
  ==> ["gnirts", "st", "ring"]
```

如果这看起来很复杂，不用担心。在你对它们感到熟悉之前，不需要在自己的代码中使用 `.` 和 `$`。然而，在阅读 Haskell 示例和网络上的代码时，你会遇到这两个运算符，因此了解它们是有益的。[这篇文章](https://typeclasses.com/featured/dollar) 也可能对你有所帮助。
## 3.6 示例：重写 `whatFollows` 函数

现在，让我们使用刚才看到的工具重写之前的 `whatFollows` 示例。以下是原始版本：

``` haskell
substringsOfLength :: Int -> String -> [String]
substringsOfLength n string = map shorten (tails string)
  where shorten s = take n s

whatFollows :: Char -> Int -> String -> [String]
whatFollows c k string = map tail (filter match (substringsOfLength (k+1) string))
  where match sub = take 1 sub == [c]
```

首先，我们去掉辅助函数 `substringsOfLength`，将所有代码移到 `whatFollows` 中：

``` haskell
whatFollows c k string = map tail (filter match (map shorten (tails string)))
  where shorten s = take (k+1) s
        match sub = take 1 sub == [c]
```

现在，我们使用部分应用来代替定义 `shorten`：

``` haskell
whatFollows c k string = map tail (filter match (map (take (k+1)) (tails string)))
  where match sub = take 1 sub == [c]
```

接下来使用 `.` 和 `$` 消除一些括号：

``` haskell
whatFollows c k string = map tail . filter match . map (take (k+1)) $ tails string
  where match sub = take 1 sub == [c]
```

我们还可以用 lambda 表达式替换 `match`：

``` haskell
whatFollows c k string = map tail . filter (\sub -> take 1 sub == [c]) . map (take (k+1)) $ tails string
```

最后，我们可以不提及 `string` 参数，因为我们可以将 `whatFollows` 表达为 `map`、`filter`、`map` 和 `tails` 的组合：

``` haskell
whatFollows c k = map tail . filter (\sub -> take 1 sub == [c]) . map (take (k+1)) . tails
```

我们甚至可以更进一步，通过运算符区间重写 lambda：

``` haskell
    \sub -> take 1 sub == [c]
=== \sub -> (==[c]) (take 1 sub)
=== \sub -> (==[c]) ((take 1) sub)
=== \sub -> ((==[c]) . (take 1)) sub
=== ((==[c]) . (take 1))
=== ((==[c]) . take 1)
```

现在我们剩下的是：

``` haskell
whatFollows c k = map tail . filter ((==[c]) . take 1) . map (take (k+1)) . tails
```

这是一种比较极端的函数版本，但在适当的情况下，使用这些技巧可以使代码更易读。
## 3.7 More Functional List Wrangling Examples

Here are some more examples of functional programming with lists. Let’s start by introducing a couple of new list functions:

```
takeWhile :: (a -> Bool) -> [a] -> [a]   -- take elements from a list as long as they satisfy a predicate
dropWhile :: (a -> Bool) -> [a] -> [a]   -- drop elements from a list as long as they satisfy a predicate
```

```
takeWhile even [2,4,1,2,3]   ==> [2,4]
dropWhile even [2,4,1,2,3]   ==> [1,2,3]
```

There’s also the function `elem`, which can be used to check if a list contains an element:

```
elem 3 [1,2,3]   ==> True
elem 4 [1,2,3]   ==> False
```

Using these, we can implement a function `findSubstring` that finds the earliest and longest substring in a string that consist only of the given characters.

```
findSubstring :: String -> String -> String
findSubstring chars = takeWhile (\x -> elem x chars)
                      . dropWhile (\x -> not $ elem x chars)
```

```
findSubstring "a" "bbaabaaaab"              ==> "aa"
findSubstring "abcd" "xxxyyyzabaaxxabcd"    ==> "abaa"
```

The function `zipWith` lets you combine two lists element-by-element:

```
zipWith :: (a -> b -> c) -> [a] -> [b] -> [c]
```

```
zipWith (++) ["John","Mary"] ["Smith","Cooper"]
  ==> ["JohnSmith","MaryCooper"]
zipWith take [4,3] ["Hello","Warden"]
  ==> ["Hell","War"]
```

Sometimes with higher-order functions it’s useful to have a function that does nothing. The function `id :: a -> a` is the identity function and just returns its argument.

```
id 3 ==> 3
map id [1,2,3] ==> [1,2,3]
```

This seems a bit useless, but you can use it for example with `filter` or `dropWhile`:

```
filter id [True,False,True,True]  ==>  [True,True,True]
dropWhile id [True,True,False,True,False]  ==>  [False,True,False]
```

Another very simple but sometimes crucial function is the constant function, `const :: a -> b -> a`. It always returns its first argument:

```
const 3 True ==> 3
const 3 0    ==> 3
```

When partially applied it can be used when you need a function that always returns the same value:

```
map (const 5) [1,2,3,4] ==> [5,5,5,5]
filter (const True) [1,2,3,4] ==> [1,2,3,4]
```

## 3.8 Lists and Recursion

Here’s a new operator, `:`

```
Prelude> 1:[]
[1]
Prelude> 1:[2,3]
[1,2,3]
Prelude> tail (1:[2,3])
[2,3]
Prelude> head (1:[2,3])
1
Prelude> :t (:)
(:) :: a -> [a] -> [a]
```

The `:` operator builds a list out of a head and a tail. In other words, `x : xs` is the same as `[x] ++ xs`. Why do we need an operator for this?

Actually, `:` is the _constructor_ for lists: it returns a new linked list node. The other list constructor is `[]`, the empty list. All lists are built using `:` and `[]`. The familiar `[x,y,z]` syntax is actually just a nicer way to write `x:y:z:[]`, or even more explicitly, `x:(y:(z:[]))`. In fact `(++)` is defined in terms of `:` and recursion in the standard library.

Here’s a picture of how `[1,2,3]` is structured in memory:

![](https://haskell.mooc.fi/img/list123.svg)

### 3.8.1 Building a List

Using `:` we can define recursive functions that build lists. For example here’s a function that builds lists like `[3,2,1]`:

```
descend 0 = []
descend n = n : descend (n-1)
```

```
descend 4 ==> [4,3,2,1]
```

Here’s a function that builds a list by iterating a function `n` times:

```
iterate f 0 x = [x]
iterate f n x = x : iterate f (n-1) (f x)
```

```
iterate (*2) 4 3 ==> [3,6,12,24,48]

let xs = "terve"
in iterate tail (length xs) xs
  ==> ["terve","erve","rve","ve","e",""]
```

Here’s a more complicated example: splitting a string into pieces at a given character:

```
split :: Char -> String -> [String]
split c [] = []
split c xs = start : split c (drop 1 rest)
  where start = takeWhile (/=c) xs
        rest = dropWhile (/=c) xs
```

```
split 'x' "fooxxbarxquux"   ==>   ["foo","","bar","quu"]
```

### 3.8.2 Pattern Matching for Lists

Last lecture, it was said that constructors are things that can be pattern matched on. Above, it was divulged that the constructors for the list type are `:` and `[]`. We can put one and one together and guess that we can pattern match on `:` and `[]`. This is true! Here’s how you can define your own versions of `head` and `tail` using pattern matching:

```
myhead :: [Int] -> Int
myhead [] = -1
myhead (first:rest) = first

mytail :: [Int] -> [Int]
mytail [] = []
mytail (first:rest) = rest
```

You can _nest_ patterns. That is, you can pattern match more than one element from the start of a list. In this example, we use the pattern `(a:b:_)` which is the same as `(a:(b:_))`:

```
sumFirstTwo :: [Integer] -> Integer
-- this equation gets used for lists of length at least two
sumFirstTwo (a:b:_) = a+b
-- this equation gets used for all other lists (i.e. lists of length 0 or 1)
sumFirstTwo _       = 0
```

```
sumFirstTwo [1]      ==> 0
sumFirstTwo [1,2]    ==> 3
sumFirstTwo [1,2,4]  ==> 3
```

Here’s an example that uses many different list patterns:

```
describeList :: [Int] -> String
describeList []         = "an empty list"
describeList (x:[])     = "a list with one element"
describeList (x:y:[])   = "a list with two elements"
describeList (x:y:z:xs) = "a list with at least three elements"
```

```
describeList [1,3]        ==> "a list with two elements"
describeList [1,2,3,4,5]  ==> "a list with at least three elements"
```

List patterns that end with `:[]` can be typed out as list literals. That is, just like `[1,2,3]` is the same value as `1:2:3:[]`, the pattern `[x,y]` is the same as the pattern `x:y:[]`. Let’s rewrite that previous example.

```
describeList :: [Int] -> String
describeList []         = "an empty list"
describeList [x]        = "a list with exactly one element"
describeList [x,y]      = "a list with exactly two elements"
describeList (x:y:z:xs) = "a list with at least three elements"
```

Another way we can nest patterns is pattern matching on the head while pattern matching on a list. For example this function checks if a list starts with `0`:

```
startsWithZero :: [Integer] -> Bool
startsWithZero (0:xs) = True
startsWithZero (x:xs) = False
startsWithZero []     = False
```

### 3.8.3 Consuming a List

Using pattern matching and recursion, we can recursively process a whole list. Here’s how you sum all the numbers in a list:

```
sumNumbers :: [Int] -> Int
sumNumbers [] = 0
sumNumbers (x:xs) = x + sumNumbers xs
```

Here’s how you compute the largest number in a list, this time using a helper function.

```
myMaximum :: [Int] -> Int
myMaximum [] = 0       -- actually this should be some sort of error...
myMaximum (x:xs) = go x xs
  where go biggest [] = biggest
        go biggest (x:xs) = go (max biggest x) xs
```

**Note!**, “`go`” is just a cute name for the helper function here. It’s not special syntax.

It’s often convenient to use nested patterns while consuming a list. Here’s an example that counts how many `Nothing` values occur in a list of `Maybe`s:

```
countNothings :: [Maybe a] -> Int
countNothings [] = 0
countNothings (Nothing : xs) = 1 + countNothings xs
countNothings (Just _  : xs) = countNothings xs
```

```
countNothings [Nothing,Just 1,Nothing]  ==>  2
```

### 3.8.4 Building and Consuming a List

Now that we can build and consume lists, let’s do both of them at the same time. This function doubles all elements in a list.

```
doubleList :: [Int] -> [Int]
doubleList [] = []
doubleList (x:xs) = 2*x : doubleList xs
```

It evaluates like this:

```
doubleList [1,2,3]
=== doubleList (1:(2:(3:[])))
==> 2*1 : doubleList (2:(3:[]))
==> 2*1 : (2*2 : doubleList (3:[]))
==> 2*1 : (2*2 : (2*3 : doubleList []))
==> 2*1 : (2*2 : (2*3 : []))
=== [2*1, 2*2, 2*3]
==> [2,4,6]
```

Once you know pattern matching for lists, it’s straightforward to define `map` and `filter`. Actually, let’s just look at the GHC standard library implementations. [Here’s map](https://hackage.haskell.org/package/base-4.16.4.0/docs/src/GHC.Base.html#map):

```
map :: (a -> b) -> [a] -> [b]
map _ []     = []
map f (x:xs) = f x : map f xs
```

and [here’s filter](https://hackage.haskell.org/package/base-4.16.4.0/docs/src/GHC.List.html#filter):

```
filter :: (a -> Bool) -> [a] -> [a]
filter _pred []    = []
filter pred (x:xs)
  | pred x         = x : filter pred xs
  | otherwise      = filter pred xs
```

(**Note!** Naming the argument `_pred` is a way to tell the reader of the code that this argument is unused. It could have been just `_` as well.)

### 3.8.5 Tail Recursion and Lists

When a recursive function evaluates to a new call to that same function with different arguments, it is called _tail-recursive_. (The recursive call is said to be in _tail position_.) This is the type of recursion that corresponds to an imperative loop. We’ve already seen many examples of tail-recursive functions, but we haven’t really contrasted the two ways for writing the same function. This is `sumNumbers` from earlier in this lecture:

```
-- Not tail recursive!
sumNumbers :: [Int] -> Int
sumNumbers [] = 0
sumNumbers (x:xs) = x + sumNumbers xs
```

In the second equation the function `+` is at the top level, i.e. in tail position. The recursive call to `sumNumbers` is an argument of `+`. This is `sumNumbers` written using a tail recursive helper function:

```
-- Tail recursive version
sumNumbers :: [Int] -> Int
sumNumbers xs = go 0 xs
  where go sum [] = sum
        go sum (x:xs) = go (sum+x) xs
```

Note the second equation of `go`: it has the recursive call to `go` at the top level, i.e. in tail position. The `+` is now in an argument to `go`.

For a function like `sumNumbers` that produces a single value (a number), it doesn’t really matter which form of recursion you choose. The non-tail-recursive function is easier to read, while the tail-recursive one can be easier to come up with. You can try writing a function both ways. The tail-recursive form might be more efficient, but that depends on many details. We’ll talk more about Haskell performance in part 2 of this course.

However, when you’re returning a list there is a big difference between these two forms. Consider the function `doubleList` from earlier. Here it is again, implemented first directly, and then via a tail-recursive helper function.

```
-- Not tail recursive!
doubleList :: [Int] -> [Int]
doubleList [] = []
doubleList (x:xs) = 2*x : doubleList xs
```

```
-- Tail recursive version
doubleList :: [Int] -> [Int]
doubleList xs = go [] xs
    where go result [] = result
          go result (x:xs) = go (result++[2*x]) xs
```

Here the direct version is much more efficient. The `(:)` operator works in constant time, whereas the `(++)` operator needs to walk the whole list, needing linear time. Thus the direct version uses linear time (_O(n)_) with respect to the length of the list, while the tail-recursive version is quadratic (_O(n²)_)!

One might be tempted to fix this by using `(:)` in the tail-recursive version, but then the list would get generated in the reverse order. This could be fixed with an application of `reverse`, but that would make the resulting function quite complicated.

There is another reason to prefer the direct version: laziness. We’ll get back to laziness in part 2 of the course, but for now it’s enough for you to know that **the direct way of generating a list is simpler, more efficient and more idiomatic**. You should try to practice it in the exercises. Check out the standard library implementations of `map` and `filter` above, even they produce the list directly without tail recursion!

## 3.9 Something Fun: List Comprehensions

Haskell has _list comprehensions_, a nice syntax for defining lists that combines the power of `map` and `filter`. You might be familiar with Python’s list comprehensions already. Haskell’s work pretty much the same way, but their syntax is a bit different.

Mapping:

```
[2*i | i<-[1,2,3]]
  ==> [2,4,6]
```

Filtering:

```
[i | i <- [1..7], even i]
  ==> [2,4,6]
```

In general, these two forms are equivalent:

```
[f x | x <- lis, p x]
map f (filter p lis)
```

List comprehensions can do even more. You can iterate over multiple lists:

```
[ first ++ " " ++ last | first <- ["John", "Mary"], last <- ["Smith","Cooper"] ]
  ==> ["John Smith","John Cooper","Mary Smith","Mary Cooper"]
```

You can make local definitions:

```
[ reversed | word <- ["this","is","a","string"], let reversed = reverse word ]
  ==> ["siht","si","a","gnirts"]
```

You can even do pattern matching in list comprehensions!

```
firstLetters string = [ char | (char:_) <- words string ]
```

```
firstLetters "Hello World!"
  ==> "HW"
```

## 3.10 Something Fun: Custom Operators

In Haskell an _operator_ is anything built from the characters `!#$%&*+./<=>?@\^|-~`. Operators can be defined just like functions (note the slightly different type annotation):

```
(<+>) :: [Int] -> [Int] -> [Int]
xs <+> ys = zipWith (+) xs ys
```

```
(+++) :: String -> String -> String
a +++ b = a ++ " " ++ b
```

## 3.11 Something Useful: Typed Holes

Sometimes when writing Haskell it can be tricky to find expressions that have the right type. Luckily, the compiler can help you here! A feature called _Typed Holes_ lets you leave blanks in your code, and the compiler will tell you what type the expression in the blank should have.

Blanks can look like `_` or `_name`. They can be confused with the “anything goes” pattern `_`, but the difference is that a hole occurs on the _right side_ of a `=`, while an anything goes pattern occurs on the _left side_ of a `=`.

Let’s start with a simple example in GHCi:

```
Prelude> filter _hole [True,False]

<interactive>: error:
    • Found hole: _hole :: Bool -> Bool
      Or perhaps ‘_hole’ is mis-spelled, or not in scope
    • In the first argument of ‘filter’, namely ‘_hole’
      In the expression: filter _hole [True, False]
      In an equation for ‘it’: it = filter _hole [True, False]
    • Relevant bindings include
        it :: [Bool] (bound at <interactive>:5:1)
      Valid hole fits include
        not :: Bool -> Bool
          (imported from ‘Prelude’
           (and originally defined in ‘ghc-prim-0.6.1:GHC.Classes’))
        id :: forall a. a -> a
          with id @Bool
          (imported from ‘Prelude’ (and originally defined in ‘GHC.Base’))
```

The important part of this message is the very first line. This tells you what type Haskell is expecting for the hole.

```
<interactive>: error:
    • Found hole: _hole :: Bool -> Bool
```

The rest of the error message offers some suggestions for the value of `_hole`, for example `id` and `not`.

Let’s look at a longer example, where we try to implement a function that filters a list using a list of booleans:

```
keepElements [5,6,7,8] [True,False,True,False] ==> [5,7]
```

We’ll start with `zip` since we know that pairs up the elements of the two lists nicely. We add a typed hole `_doIt` and call it with the result of `zip` to see what we need to do next.

```
keepElements :: [a] -> [Bool] -> [a]
keepElements xs bs = _doIt (zip xs bs)
```

```
<interactive>: error:
    • Found hole: _doIt :: [(a, Bool)] -> [a]
    ...
```

That looks like something that could be done with `map`. Let’s see what happens:

```
keepElements :: [a] -> [Bool] -> [a]
keepElements xs bs = map _f (zip xs bs)
```

```
<interactive>: error:
    • Found hole: _f :: (a, Bool) -> a
    ...
      Valid hole fits include
        fst :: forall a b. (a, b) -> a
```

Great! GHC reminded us of the function `fst` that grabs the first out of a pair. Are we done now?

```
keepElements :: [a] -> [Bool] -> [a]
keepElements xs bs = map fst (zip xs bs)
```

```
Prelude> keepElements [5,6,7,8] [True,False,True,False]
[5,6,7,8]
```

Oh right, we’ve forgotten to do the filtering part. Let’s try a typed hole again:

```
keepElements :: [a] -> [Bool] -> [a]
keepElements xs bs = map fst (filter _predicate (zip xs bs))
```

```
<interactive>: error:
    • Found hole: _predicate :: (a, Bool) -> Bool
    ...
      Valid hole fits include
        snd :: forall a b. (a, b) -> b
        ...
        ... lots of other suggestions
```

Again GHC has reminded us of a function that seems to do the right thing: just grab the second element out of the tuple. Now our function is finished and works as expected.

```
keepElements :: [a] -> [Bool] -> [a]
keepElements xs bs = map fst (filter snd (zip xs bs))
```

```
Prelude> keepElements [5,6,7,8] [True,False,True,False]
[5,7]
```

**Remember typed holes** when you get stuck with type errors when working on the exercises! Try replacing a function or variable with a typed hole. It might help you figure out what you need.

## 3.12 Quiz

What’s the type of this function? `both p q x = p x && q x`

1. `a -> Bool -> a -> Bool -> a -> Bool`
2. `(a -> Bool) -> (a -> Bool) -> a -> Bool`
3. `(a -> Bool) -> (b -> Bool) -> c -> Bool`

What’s the (most general) type of this function? `applyInOut f g x = f (g (f x))`

1. `(a -> b) -> (b -> a) -> a -> b`
2. `(a -> b) -> (b -> c) -> a -> c`
3. `(a -> a) -> (a -> a) -> a -> a`

Which one of the following functions adds its first argument to the second?

1. `f x x = x + x`
2. `f x = \y -> x + y`
3. `f = \x y -> x + x`

Which one of the following functions does not satisfy `f 1 ==> 1`?

1. `f x = (\y -> y) x`
2. `f x = \y -> y`
3. `f x = (\y -> x) x`

Which one of the following functions is correctly typed?

1. `f x y = not x; f :: (Bool -> Bool) -> Bool`
2. `f x = x ++ "a"; f :: Char -> String`
3. `f x = 'a' : x; f :: String -> String`

How many arguments does `drop 2` take?

1. Zero
2. One
3. Two

What does this function do? `f (_:x:_) = x`

1. Returns the first element of a list
2. Returns an arbitrary element of a list
3. Returns all except the first and last elements of a list
4. Returns the second element of a list

What is the result of `reverse $ take 5 . tail $ "This is a test"`?

1. `"i sih"`
2. `"set a"`
3. A type error

If `f :: a -> b`, then what is the type of `map (.f)`?

1. `[b -> c] -> [a -> c]`
2. `[c -> a] -> [c -> b]`
3. `(b -> c) -> [a -> c]`
4. `[a] -> [b]`

What is the type of the leftmost `id` in `id id`?

1. unspecified
2. `a`
3. `a -> a`
4. `(a -> a) -> (a -> a)`

What is the type of `const const`?

1. unspecified
2. `(c -> a -> b) -> a`
3. `c -> (a -> b -> a)`
4. `a -> b -> c -> a`


### 3.13.1 Common Errors

```
No instance for (Eq a) arising from a use of ‘==’
```

You’ve probably tried to use `x==Nothing` to check if a value is `Nothing`. Use pattern matching instead. The reason for this error is that values of type `Maybe a` can’t be compared because Haskell doesn’t know how to compare values of the polymorphic type `a`. You’ll find more about this in the next lecture. Use pattern matching instead of `==` for now.