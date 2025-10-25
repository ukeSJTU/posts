表达式指称语义

什么是语义 semantics？描述程序的行为是什么

我们先从SimpleWhile整数类型表达式开始

描述表达式的行为？表达式在不同程序状态上不同的求值结果

e的行为，就是e的denotation

方括号e是一个函数，从state程序状态到整数的函数；而程序状态集合就是var_name到整数的映射。表达式e在程序状态s上的求值结果。

程序状态集合

# 表达式指称语义

# 1 Simple While 整数类型表达式的指称语义

[cite_start]在极简的Simple While语言中，整数类型表达式中只有整数常量、变量、加法、减法与乘法运算。 [cite: 3]

```txt
EI :: = N | V | EI + EI | EI - EI | EI * EI
```

[cite_start]我们约定其中整数变量的值、整数运算的结果都是没有范围限制的。 [cite: 5] [cite_start]基于这一约定，我们可以如下定义程序状态集合： [cite: 5]

```txt
state  $\triangleq$  var_name  $\rightarrow \mathbb{Z}$
```

[cite_start][cite: 6]

[cite_start]进一步，整数类型表达式 $e$ 的行为可以被定义为 $e$ 在每个程序状态上的值。 [cite: 7]

[cite_start]$\llbracket e\rrbracket$ : state $\rightarrow \mathbb{Z}$ 是一个程序状态到整数的函数； [cite: 8]

[cite_start]$\llbracket e\rrbracket (s)$ 表示表达式 $e$ 在程序状态 $s$ 上的求值结果。 [cite: 9]

[cite_start]基于这一设定，可以写出下面的具体定义： [cite: 10]

- [cite_start]$\llbracket n\rrbracket (s) = n$ [cite: 11]
- [cite_start]$\llbracket x\rrbracket (s) = s(x)$ [cite: 13]
- [cite_start]$\llbracket e_1 + e_2\rrbracket (s) = \llbracket e_1\rrbracket (s) + \llbracket e_2\rrbracket (s)$ [cite: 14]
- [cite_start]$\llbracket e_1 - e_2\rrbracket (s) = \llbracket e_1\rrbracket (s) - \llbracket e_2\rrbracket (s)$ [cite: 15]
- [cite_start]$\llbracket e_1 * e_2\rrbracket(s) = \llbracket e_1\rrbracket(s) * \llbracket e_2\rrbracket(s)$ [cite: 16]

[cite_start]其中 $s \in \mathrm{state}$ 。 [cite: 17]

[cite_start]上面这些式子可以写成下面这些 Coq 代码。 [cite: 18]

```coq
Definition state: Type := var_name -> Z.
```

[cite_start][cite: 19]

```coq
Fixpoint eval_expr_int (e: expr_int) (s: state): Z := match e with
| EConst n => n
| EVar X => s X
| EAdd e1 e2 => eval_expr_int e1 s + eval_expr_int e2 s
| ESub e1 e2 => eval_expr_int e1 s - eval_expr_int e2 s
| EMul e1 e2 => eval_expr_int e1 s * eval_expr_int e2 s
end.
```

[cite_start][cite: 20, 21, 22, 23, 24, 25]

## 2 定义有符号 64 位运算的表达式语义

[cite_start]在表达式的指称语义中表示表达式求值错误（有符号64位整数的运算越界的情况）这一概念，数学上有两种常见方案。 [cite: 28] [cite_start]其一是将求值结果由“整数”改为“整数或求值失败”。 [cite: 29]

- [cite_start]原指称语义： [cite: 30]

  $$
  \forall e. \quad \llbracket e \rrbracket: \mathrm {state} \to \mathbb {Z}
  $$

  [cite_start][cite: 31]

- [cite_start]新指称语义： [cite: 32]

  $$
  \forall e. \quad \llbracket e \rrbracket: \operatorname {state} \to \mathbb {Z} \cup \{\epsilon \}
  $$

  [cite_start][cite: 33]

- [cite_start]程序状态： [cite: 34]

  $$
  \mathrm {state} \triangleq \operatorname {var} _ {\mathrm {name}} \rightarrow \mathbb {Z}
  $$

  [cite_start][cite: 35]

  $$
  s \in \text {state} \quad \text {合 法 当 且 仅 当} \quad \forall x. - 2 ^ {6 3} \leqslant s (x) \leqslant 2 ^ {6 3} - 1
  $$

  [cite_start][cite: 36]

- [cite_start]$\llbracket n\rrbracket (s) = n$ ，若 $-2^{63}\leqslant n\leqslant 2^{63} - 1$ [cite: 37]
- [cite_start]$\llbracket n\rrbracket (s) = \epsilon$ ，若 $-2^{63}\leqslant n\leqslant 2^{63} - 1$ 不成立 [cite: 39]
- [cite_start]$\llbracket x\rrbracket(s) = s(x)$ [cite: 40]
- [cite_start]若 $\llbracket e_1\rrbracket (s)\neq \epsilon ,\llbracket e_2\rrbracket (s)\neq \epsilon$ 并且 $-2^{63}\leqslant \llbracket e_1\rrbracket (s) + \llbracket e_2\rrbracket (s)\leqslant 2^{63} - 1$ [cite: 41]
  $$
  \llbracket e _ {1} + e _ {2} \rrbracket (s) = \llbracket e _ {1} \rrbracket (s) + \llbracket e _ {2} \rrbracket (s)
  $$
  [cite_start][cite: 42]
- [cite_start]若否 [cite: 43]
  $$
  \llbracket e _ {1} + e _ {2} \rrbracket (s) = \epsilon
  $$
  [cite_start][cite: 44]
- [cite_start]$\llbracket e_1 - e_2\rrbracket (s) = \dots$ [cite: 45]
- [cite_start]$\llbracket e_1*e_2\rrbracket (s) = \dots$ [cite: 46]

## 3 变量初始化与表达式语义

- [cite_start]$s \in \text{state}$ 当且仅当 $s$ 是这样的一个二元组 $s = (s_{\text{status}}, s_{\text{value}})$ ，其中 [cite: 48]
  [cite_start]$s _ {\text {status}}: \operatorname {var} \_ \text {name} \rightarrow \{I, U \},$ [cite: 49, 50]
  [cite_start]$s _ {\text {value}}: \operatorname {var} \_ \text {name} \rightarrow \mathbb {Z} \cup \{\epsilon \}$ [cite: 51]

- [cite_start]$s \in \text{state}$ 是一个合法状态当且仅当 [cite: 52]

  $$
  \forall x. s _ {\text {status}} (x) = \mathrm {I} \Rightarrow - 2 ^ {6 3} \leqslant s _ {\text {value}} (x) \leqslant 2 ^ {6 3} - 1
  $$

  [cite_start][cite: 54]

  $$
  \forall x. s _ {\text {status}} (x) = \mathrm {U} \Rightarrow s _ {\text {value}} (x) = \mathrm {U}
  $$

  [cite_start][cite: 54]

- [cite_start]$\llbracket e\rrbracket$ : state $\rightarrow \mathbb{Z}\cup \{\epsilon \}$ [cite: 53]

## 4 行为等价

[cite_start]基于整数类型表达式的语义定义eval_expr_int，我们可以定义整数类型表达式之间的行为等价（亦称语义等价）：两个表达式e1与e2是等价的当且仅当它们在任何程序状态上的求值结果都相同。 [cite: 57, 58]

$$
e _ {1} \equiv e _ {2} \quad \text {iff.} \quad \forall s. \quad \llbracket e _ {1} \rrbracket (s) = \llbracket e _ {2} \rrbracket (s)
$$

[cite_start][cite: 59]

[cite_start]这一定义写到 Coq 中便是下面这个整数类型表达式之间的二元关系。 [cite: 60]

```coq
Definition iequiv (e1 e2: expr_int): Prop :=
    forall s, [[e1]]s = [[e2]]s.
```

[cite_start][cite: 61, 62]

[cite_start]之后我们将在 Coq 中用 e1 ~ e2 表示 iequiv e1 e2。 [cite: 63]

习题1. [cite_start]请证明下面 Simple While 中整数类型表达式的行为等价。 [cite: 64]

```coq
Lemma plus_plus_assoc:
    forall a b c: expr_int,
    [[a + (b + c)]] ~= [[a + b + c]].
(* 请在此处填入你的证明，以 [Qed]_结束。*)
```

[cite_start][cite: 65, 66, 67, 68]

```coq
Lemma plus_minus_assoc:
    forall a b c: expr_int,
    [[a + (b - c)]] ~= [[a + b - c]].
(* 请在此处填入你的证明，以 [Qed]_结束。*)
```

[cite_start][cite: 69, 70, 71, 72, 73]

```coq
Lemma minus_plus_assoc:
    forall a b c: expr_int,
    [[a - (b + c)]] ~= [[a - b - c]].
(* 请在此处填入你的证明，以 [Qed]_结束。*)
```

[cite_start][cite: 74, 75, 76, 77, 78]

```coq
Lemma minus_minus_assoc:
    forall a b c: expr_int,
    [[a - (b - c)]] ~= [[a - b + c]].
(* 请在此处填入你的证明，以 [Qed]_结束。*)
```

[cite_start][cite: 79, 80, 81, 82, 83, 84]

## 5 行为等价的性质

[cite_start]整数类型表达式之间的行为等价符合下面几条重要的代数性质。 [cite: 86]

```coq
#[export] Instance iequiv_refl: Reflexive iequiv.
```

[cite_start][cite: 87]

```coq
#[export] Instance iequiv_symm: Symmetric iequiv.
```

[cite_start][cite: 88]

```coq
#[export] Instance iequiv_trans: Transitive iequiv.
```

[cite_start][cite: 89]

```coq
#[export] Instance iequiv_equiv: Equivalence iequiv.
```

[cite_start][cite: 90]

```coq
#[export] Instance EAdd_iequiv_morphism:
    Proper (iequiv ==> iequiv ==> iequiv) EAdd.
```

[cite_start][cite: 92]

```coq
#[export] Instance ESub_iequiv_morphism:
    Proper (iequiv ==> iequiv ==> iequiv) ESub.
```

[cite_start][cite: 93]

```coq
#[export] Instance EMul_iequiv_morphism:
    Proper (iequiv ==> iequiv ==> iequiv) EMul.
```

[cite_start][cite: 94]

## 6 利用高阶函数定义指称语义

[cite_start]先定义三个算术运算符对应的语义算子： [cite: 96]

```coq
Definition add_sem (D1 D2: state -> Z) (s: state): Z := D1 s + D2 s.
```

[cite_start][cite: 97]

```coq
Definition sub_sem (D1 D2: state -> Z) (s: state): Z := D1 s - D2 s.
```

[cite_start][cite: 98, 99, 100]

```coq
Definition mul_sem (D1 D2: state -> Z) (s: state): Z := D1 s * D2 s.
```

[cite_start][cite: 101]

[cite_start]这意味着整数类型表达式的语义满足下面性质： [cite: 102]

- [cite_start]$\llbracket e_1 + e_2\rrbracket = \mathrm{add\_sem}(\llbracket e_1\rrbracket ,\llbracket e_2\rrbracket)$ [cite: 103]
- [cite_start]$\llbracket e_1 - e_2\rrbracket = \mathrm{sub\_sem}(\llbracket e_1\rrbracket ,\llbracket e_2\rrbracket)$ [cite: 104]
- [cite_start]$\llbracket e_1 * e_2\rrbracket = \mathrm{mul\_sem}(\llbracket e_1\rrbracket, \llbracket e_2\rrbracket)$ [cite: 105]

[cite_start]基于上面这三个用高阶函数定义的语义算子，可以重新定义整数类型表达式的指称语义。 [cite: 106]

```coq
Definition const_sem (n: Z): state -> Z := fun s => n.
```

[cite_start][cite: 107, 108]

```coq
Definition var_sem (X: var_name): state -> Z := fun s => s X.
```

[cite_start][cite: 109, 110]

```coq
Fixpoint eval_expr_int (e: expr_int): state -> Z := match e with
| EConst n =>
    const_sem n
| EVar X =>
    var_sem X
| EAdd e1 e2 =>
    add_sem (eval_expr_int e1) (eval_expr_int e2)
| ESub e1 e2 =>
    sub_sem (eval_expr_int e1) (eval_expr_int e2)
| EMul e1 e2 =>
    mul_sem (eval_expr_int e1) (eval_expr_int e2)
end.
```

[cite_start][cite: 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123]

[cite_start]可以证明，前面定义的三个语义函数都能保持函数相等。 [cite: 125]

```coq
#[export] Instance add_sem_congr:
    Proper (func_equiv ==> func_equiv ==> func_equiv) add_sem.
```

[cite_start][cite: 126, 127, 128, 129, 130]

```coq
#[export] Instance sub_sem_congr:
    Proper (func_equiv ==>
        func_equiv ==>
            func_equiv) sub_sem.
```

[cite_start][cite: 131, 132, 133, 134, 135, 136, 137]

```coq
#[export] Instance mul_sem_congr:
    Proper (func_equiv ==>
        func_equiv ==>
            func_equiv) mul_sem.
```

[cite_start][cite: 138, 139, 140, 141, 142, 143]

[cite_start]同时，我们也可以用函数相等来定义表达式行为等价和并利用函数相等的代数性质来证明行为等价的代数性质。 [cite: 144]

```coq
Definition iequiv (e1 e2: expr_int): Prop := ([[e1]] == [[e2]])%func.
```

[cite_start][cite: 145, 146]

```coq
#[export] Instance iequiv_equiv: Equivalence iequiv.
```

[cite_start][cite: 147]

```coq
#[export] Instance EAdd_congr:
    Proper (iequiv ==> iequiv ==> iequiv) EAdd.
```

[cite_start][cite: 148, 149]

```coq
#[export] Instance ESub_congr:
    Proper (iequiv ==> iequiv ==> iequiv) ESub.
```

[cite_start][cite: 150, 151]

```coq
#[export] Instance EMul_congr:
    Proper (iequiv ==> iequiv ==> iequiv) EMul.
```

[cite_start][cite: 152, 153]
