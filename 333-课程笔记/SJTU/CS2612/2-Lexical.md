## 词法分析

词法分析是编译器前端的第一步，它的主要任务是将源代码的字符串切分为一个一个的**标记（token）**。

我们在[[1-Intro]]里面设计的While+DB（带有Dereference和Built-in Functions）语言有以下几类标记：

- 运算符： `+ - * / % < <= == != >= > ! && ||`
- 赋值符号：`=`
- 间隔符： `( ) { } ;`
- 自然数： `0 1 2 ...`
- 变量名： `a0 __x ...`
- 保留字： `var if then else while do`
- 内置函数名： `malloc read_char read_int write_char write_int`

根据不同标记承担的语法功能是否相同，可以将标记分为若干类。事实上，在上述列举的标记除了所有自然数分为一类，所有变量名分为一类之外，其他每个标记应当单独分为一类。

例如，C语言的标记了分类(`lang.h`)：

```c
enum token_class {
	// 运 算 符
	TOK_OR = 1, TOK_AND , TOK_NOT ,
	TOK_LT , TOK_LE , TOK_GT , TOK_GE , TOK_EQ , TOK_NE ,
	TOK_PLUS , TOK_MINUS , TOK_MUL , TOK_DIV , TOK_MOD ,
	// 赋 值 符 号
	TOK_ASGNOP ,
	// 间 隔 符 号
	TOK_LEFT_BRACE , TOK_RIGHT_BRACE ,
	TOK_LEFT_PAREN , TOK_RIGHT_PAREN ,
	TOK_SEMICOL ,
	// 自 然 数
	TOK_NAT ,
	// 变 量 名
	TOK_IDENT ,
	// 保 留 字
	TOK_VAR , TOK_IF , TOK_THEN , TOK_ELSE , TOK_WHILE , TOK_DO ,
	// 内 置 函 数 名
	TOK_MALLOC , TOK_RI , TOK_RC , TOK_WI , TOK_WC
};
```

其中`TOK_NAT`和`TOK_IDENT`这两个TOKEN需要额外存储他们的值，可以利用C语言里面的`union`语法：

```c
union token_value {
	unsigned int n;
	char * i;
	void * none;
}
```

如果标记是`TOK_NAT`那么就用n来记录对应表示的无符号整数值，如果标记是`TOK_IDENT`那么就用`i`来记录对应的字符串地址。其他情况下不存储额外信息。

## 正则表达式

正则表达式是用于描述字符串集合的一种语言。

### 语法结构

正则表达式的语法结构定义如下：

```text
r ::= c | ε | r|r | rr | r*
```

**优先级**：`*(重复)` > 连接 > `|(并集)`

### 五种基本意思

1. **单个字符**：匹配单个字符
2. **空字符串**：用 `ε` 表示
3. **连接**：两个字符串的连接
4. **并集**：两类字符串的并集（用 `|` 表示）
5. **重复**：重复出现一类字符串0次、1次或多次（用 `*` 表示）

### 基本示例

- `(a|b)c`：表达的字符串有 `ac`、`bc`
- `(a|b)*`：表达的字符串有**空串**、`a`、`b`、`ab`、`aaaaa`、`babbb` 等
- `ab*`：表达的字符串有 `a`、`ab`、`abb`、`abbb`、`abbbb` 等
- `(ab)*`：表达的字符串有**空串**、`ab`、`abab` 等

### 常见简写符号

| 简写       | 含义         | 示例                             |
| ---------- | ------------ | -------------------------------- |
| `[a-cA-C]` | 字符集合     | 表示 `a\|b\|c\|A\|B\|C`          |
| `r?`       | 可选字符串   | `r\|空串`                        |
| `"abc"`    | 字符串字面量 | 表示字符串 `abc`                 |
| `r+`       | 重复至少一次 | 如 `a+` 表示 `a`、`aa`、`aaa` 等 |

### 实用正则表达式

#### 自然数常量

```
"0" | [1-9][0-9]*
```

#### 标识符（不排除保留字、内置函数名）

```
[_a-zA-Z][_a-zA-Z0-9]*
```

TODO: 我感觉这里可以补充做题技巧

## Flex 词法分析工具

**输入（.l 文件）**：基于正则表达式的词法分析规则

**输出（.c 文件）**：用 C 语言实现的词法分析器

## 有限状态自动机

**有限状态自动机**（Finite Automaton, FA）是一个非常简单的机器，只有一个任务：**识别字符串**。这个机器包含几个核心部分：

- **状态集 (States)**：机器内部可以处于的几种不同状态。你可以把它们想象成图中的节点（圆圈）。
- **起始状态 (Start State)**：机器开机时默认进入的第一个状态 。
- **终止状态 (Final States)**：一组特殊的状态。如果机器读完整个字符串后，正好停在了某个终止状态里，那么这个字符串就被“接受”了（也就是口令正确）。在图里，终止状态通常用双层圆圈表示。
- **状态转移规则 (Transitions)**：连接不同状态的箭头，箭头上标有符号（通常是字符）。它告诉机器：当你处于某个状态，并且读到一个特定的字符时，你应该转移到哪个新状态。

编译器前端的**词法分析器 (Lexer)** 就是一个有限状态自动机的具体应用 。它从源代码的第一个字符开始，一个一个地向后读。每读一个字符，就根据转移规则从当前状态移动到下一个状态。

举例如下：

![image.png](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/09/20250922211049810.png)

机器从`INIT` 状态开始。

1. 如果读入的第一个字符是字母（比如 'v'、'a'、'r'），它就会转移到右边的那个终止状态。
2. 接下来，如果再读入字母或数字，它会继续停留在那个终止状态（沿着那个环形的箭头自己转移给自己）。
3. 当它读到一个不再是字母或数字的字符时（比如空格或分号），它就停下来。因为它最后停在了一个终止状态里，所以它成功识别出了一个“标识符”类型的标记 (Token)。

有限状态自动机可以根据“从一个状态出发，每个符号可能对应的状态转移规则的数量”分为NFA和DFA。

### NFA

NFA 的全称是 **Nondeterministic Finite Automata**。“非确定性”体现在：

1. **路径不唯一**：从一个状态出发，在读入同一个字符后，可能会有多个可以选择的下一个状态 。
2. **epsilon (ε) 转移**：NFA 可以在不读取任何字符的情况下，直接从一个状态“跳”到另一个状态 。

![image.png](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/09/20250922211504494.png)

注意看 `INIT` 这个起始状态。当它读入字符 `i` 的时候，有一条箭头指向了上面的圆圈，同时还有一条通用的 `A-Za-z` 箭头（`i` 也属于这个范围）指向了下面的圆圈。

这就是“非确定性”：读入一个`i`，在 NFA 模型里，它会同时探索所有可能的路径。只要其中**任何一条**路径最终能走通（即读完字符串后停在了一个终止状态），那么这个字符串就被接受了 。

### DFA

**DFA** 的全称是 **Deterministic Finite Automata**。和 NFA 相比，它的行为是“确定”的，没有任何模棱两可的地方。

DFA 的规则非常严格：

1. **路径唯一**：从任何一个状态出发，对于任意一个输入的字符，最多只有一条对应的转移路径 。绝不会出现 NFA 那样的岔路口。
2. **没有 epsilon (ε) 转移**：DFA 必须实实在在地读取一个字符（按照课件：都是 ascii 码字符。），才能进行状态转移，不允许“免费”移动 。

![image.png](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/09/20250922211801996.png)

### NFA和DFA对比

**NFA (Nondeterministic Finite Automata)**: The first step is to convert the regular expressions that define your tokens into an NFA. A key feature of an NFA is that from a single state, a given input character can lead to multiple possible next states. It can also have "epsilon transitions," where it moves to a new state without consuming an input character. The document shows how to construct an NFA for basic regex operations like concatenation, union, and repetition.

**DFA (Deterministic Finite Automata)**: While an NFA is a good theoretical model, it's not the most efficient for implementation. The next step is to convert the NFA into an equivalent DFA. In a DFA, each state-character pair has at most one unique next state, which makes it faster and simpler to implement in code. The core idea of this conversion is to create DFA states that represent a set of possible states in the NFA.

总的来说，NFA允许多条转移规则， 因此从正则表达式构造起来相对简单、直观，可以先将正则表达式转换成NFA。而DFA更加严格，但实现简单，执行速度快，因为路径是唯一的。

因此，lexer词法分析器都是：正则表达式 -> NFA -> DFA

## 正则表达式转化为NFA

首先是几个非常基础的模式：

`c`的NFA构造：

![image.png](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/09/20250922212445230.png)

`epsilon`的NFA构造：

![image.png](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/09/20250922212458711.png)

其他：
![image.png](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/09/20250922212532681.png)

固定套路：将一个复杂的正则表达式拆解成最基本的单元，为每个单元建立一个迷你 NFA，然后再组合它们。

## NFA转换为DFA

这个转换的核心方法叫做**子集构造法 (Subset Construction)**。核心思想很简单：**DFA 中的每一个状态，都对应 NFA 中一个可能的状态集合** 。

### Step 1 - 确定DFA的起始状态

DFA 的起始状态，是：

1. NFA 的起始状态 (S0)
2. 以及从 S0 出发，只通过 ε 箭头就能到达的所有状态的**集合**。

这个集合被称为 **ε-闭包 (epsilon-closure)**。

### Step 2 - 计算状态A的转移

当我们有了一个DFA状态（它是一个NFA状态的集合，我们称之为A）后，需要为字母表中的每一个符号计算它的转移目标。

计算过程如下：

1. 从状态集合A中的每一个NFA状态出发，找出所有可以通过读取某个符号（例如'x'）到达的目标状态。
2. 将所有这些目标状态收集起来，形成一个新的集合。
3. 计算这个新集合的 **ε-闭包**。这个最终得到的闭包集合就是从状态A出发，读取符号'x'后到达的新DFA状态。
4. 对当前已有的所有DFA状态和所有可能的输入符号，重复以上步骤，直到不再有新的DFA状态产生为止。

### Step n - 确定DFA的终止状态

一个DFA状态被标记为终止状态，当且仅当它所对应的NFA状态集合中，**包含了至少一个**NFA的原始终止状态 。
