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

---

这是一个很好的要求。为了彻底理解正则表达式（RegExp）如何转化为非确定性有限状态自动机（NFA），再转化为确定性有限状态自动机（DFA）的全过程，我们需要一个具体的例子来进行可视化和步骤分解。

我们选取一个经典的正则表达式作为例子：**$R = a^*a$**。这个表达式描述的是所有非空且全部由字符 'a' 组成的字符串集合，例如 "a", "aa", "aaa" 等。

### 阶段一：将正则表达式 $a^*a$ 转化为 NFA

根据教材中介绍的算法，任何复杂的正则表达式都可以通过归纳法，利用基本规则（字符、$\epsilon$）和组合规则（连接、或、重复）构造出只有一个起点和一个终点的 NFA。

$a^_a$ 是 $R_1 \cdot R_2$ 的形式，其中 $R_1 = a^_$， $R_2 = a$。

#### 步骤 1.1: 基础构建 NFA($a$)

对于单个字符 $a$，我们构建一个最简单的 NFA，包含一个起始状态 $S_4$ 和一个终止状态 $S_5$（这里我们用 $S_4, S_5$ 来预留 $S_0, S_1, S_2, S_3$ 用于 $a^*$ 的内部结构）：

$$ (S_4) \xrightarrow{a} (S_5) $$

#### 步骤 1.2: 构建 NFA($a^*$)

$a^*$ 表示 $a$ 重复 0 次或多次。根据 Kleene Closure 的构造规则：

1. **新建起点 $S_0$ 和终点 $S_3$。**
2. $S_0 \xrightarrow{\epsilon} S_3$ (代表 0 次重复)。
3. $S_0 \xrightarrow{\epsilon} S_1$ (进入 $a$ 的 NFA 内部)。
4. $S_1 \xrightarrow{a} S_2$ (读取字符 $a$)。
5. $S_2 \xrightarrow{\epsilon} S_1$ (循环回 $S_1$ 实现重复)。
6. $S_2 \xrightarrow{\epsilon} S_3$ (结束重复)。

#### 步骤 1.3: 连接 NFA($a^_$) 和 NFA($a$) 得到 NFA($a^_a$)

$a^_a$ 是 $a^_$ 后面紧跟 $a$ 的连接。我们使用 $\epsilon$-边将 $a^*$ 的终点 $S_3$ 连接到 $a$ 的起点 $S_4$。最终的终点为 $a$ 的终点 $S_5$。

| NFA 状态  | 描述                                    |
| :-------- | :-------------------------------------- |
| **$S_0$** | **NFA($a^*a$) 的起始状态。**            |
| $S_1$     | $a^*$ 内部开始状态。                    |
| $S_2$     | $a^*$ 内部结束状态。                    |
| $S_3$     | $a^*$ 的终点（但不是整个 NFA 的终点）。 |
| $S_4$     | 最终 'a' 的起始状态。                   |
| **$S_5$** | **NFA($a^*a$) 的最终接受状态。**        |

**NFA($a^*a$) 的结构 (状态 0 到 5):**

| 边 (来源 $\to$ 目标) | 标签       | 说明                            |
| :------------------- | :--------- | :------------------------------ |
| $S_0 \to S_3$        | $\epsilon$ | $a^*$ 的 0 次重复，跳过内部循环 |
| $S_0 \to S_1$        | $\epsilon$ | 进入 $a^*$ 内部循环             |
| $S_1 \to S_2$        | $a$        | 读取一个 'a'                    |
| $S_2 \to S_1$        | $\epsilon$ | 循环重复 $a$                    |
| $S_2 \to S_3$        | $\epsilon$ | 结束 $a^*$ 内部重复             |
| $S_3 \to S_4$        | $\epsilon$ | 连接 $a^*$ 和最后的 $a$         |
| $S_4 \to S_5$        | $a$        | 读取最后的 'a'                  |

**(NFA 图示描述)**

$S_0$ 是起始状态，**$S_5$ 是终结状态**。

1. **$\epsilon$-转移:** $S_0 \to S_1$, $S_0 \to S_3$, $S_2 \to S_1$, $S_2 \to S_3$, $S_3 \to S_4$.
2. **'a'-转移:** $S_1 \to S_2$, $S_4 \to S_5$.

---

### 阶段二：将 NFA 转化为 DFA (子集构造法)

DFA 的每个状态都是 NFA 状态的一个**集合**。我们使用 **$\epsilon$-闭包（closure）**和 **DFA 边（DFAedge）**的概念来进行转换。

#### 步骤 2.1: 计算起始状态的 $\epsilon$-闭包

$\epsilon$-闭包 $\text{closure}(S)$ 是指从状态集合 $S$ 出发，仅通过 $\epsilon$-边可以到达的所有 NFA 状态的集合。

**DFA 状态 $D_A$ (起始状态):**

$D_A = \text{closure}({S_0})$

1. 从 $S_0$ 出发：可达 $S_0, S_1, S_3$。
2. 从 $S_1$ 出发：无可消字符 $\epsilon$ 边。
3. 从 $S_3$ 出发：可达 $S_4$。
4. 从 $S_4$ 出发：无可消字符 $\epsilon$ 边。

$$ D_A = {S_0, S_1, S_3, S_4} $$

#### 步骤 2.2: 探索 $D_A$ 的转移

我们考虑输入字符 $\Sigma = {a}$。

**a) 读入字符 'a':**

我们首先找到 $D_A$ 中所有状态在读取 'a' 之后能到达的 NFA 状态集合 $T'$。

| NFA 状态 $s \in D_A$ | $\text{edge}(s, 'a')$ |
| :------------------- | :-------------------- |
| $S_0$                | $\emptyset$           |
| $S_1$                | ${S_2}$               |
| $S_3$                | $\emptyset$           |
| $S_4$                | ${S_5}$               |
| **$T'$**             | **${S_2, S_5}$**      |

接下来，计算 $T'$ 的 $\epsilon$-闭包，得到新的 DFA 状态 $D_B$:

$$ D_B = \text{closure}({S_2, S_5}) $$

1. $S_5$：终点，无 $\epsilon$ 出边。
2. $S_2$：可达 $S_1, S_3$。
3. $S_1$：无可消字符 $\epsilon$ 边。
4. $S_3$：可达 $S_4$。

$$ D_B = {S_1, S_2, S_3, S_4, S_5} $$

由于 $D_B$ 包含 NFA 终结状态 $S_5$，因此 **$D_B$ 是一个 DFA 终结状态**。

**转移 $D_A \xrightarrow{a} D_B$**

#### 步骤 2.3: 探索 $D_B$ 的转移

**b) 读入字符 'a':**

找到 $D_B$ 中所有状态在读取 'a' 之后能到达的 NFA 状态集合 $T'$:

| NFA 状态 $s \in D_B$ | $\text{edge}(s, 'a')$ |
| :------------------- | :-------------------- |
| $S_1$                | ${S_2}$               |
| $S_2$                | $\emptyset$           |
| $S_3$                | $\emptyset$           |
| $S_4$                | ${S_5}$               |
| $S_5$                | $\emptyset$           |
| **$T'$**             | **${S_2, S_5}$**      |

计算 $T'$ 的 $\epsilon$-闭包，得到的新 DFA 状态就是 $D_B$:

$$ D_B = \text{closure}({S_2, S_5}) = {S_1, S_2, S_3, S_4, S_5} $$

**转移 $D_B \xrightarrow{a} D_B$ (自循环)**

#### 步骤 2.4: 最终 DFA 总结

我们只找到了两个可达的 DFA 状态 $D_A$ 和 $D_B$（以及一个隐含的死状态 $D_{Dead}$，即 $\text{closure}(\emptyset)$）。

| DFA 状态          | 对应 NFA 状态集合           | 是否为终结状态 | 转移 ('a') | 转移 (其他字符) |
| :---------------- | :-------------------------- | :------------- | :--------- | :-------------- |
| **$D_A$ (Start)** | ${S_0, S_1, S_3, S_4}$      | 否             | $D_B$      | $D_{Dead}$      |
| **$D_B$ (Final)** | ${S_1, S_2, S_3, S_4, S_5}$ | 是             | $D_B$      | $D_{Dead}$      |

**DFA 结构描述:**

- **起点 $D_A$** 接受 'a' 转移到终结状态 $D_B$。
- **状态 $D_B$** 接受 'a' 自循环回到 $D_B$。
- **状态 $D_A$** 和 **$D_B$** 接受任何其他字符（$\ne a$）都转移到一个不可接受的死状态 $D_{Dead}$（未显示）。

这个 DFA 精确地接受所有长度 $\ge 1$ 的 $a$ 串，与正则表达式 $a^*a$ 所定义的语言一致。

> **提示：** 在实际的词法分析器实现中（如 Flex），这个 DFA 会被编码成一个转移表。分析器从 $D_A$ 开始，根据输入的字符在表中查找下一个状态。如果到达一个终结状态（如 $D_B$），就表示找到了一个合法的标记。
