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

Finite State Automa

### NFA

### DFA

## 正则表达式转化为NFA

## NFA转换为DFA
