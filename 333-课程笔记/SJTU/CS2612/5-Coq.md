# 程序语言语法的 Coq 定义

Coq 是一个交互式的定理证明工具。在使用 Coq 表达数学命题并进行证明时，你需要遵循特定的指令和结构。

## 简单Coq证明与定义

虽然课程材料中没有将导入（Require Import）和设置作用域（Local Open Scope）作为核心结构，但它们是开始 Coq 工作时必要的步骤，用于引入所需的数学库（如整数运算库 ZArith）和证明策略（如 Psatz，其中包含 `lia` 和 `nia`）

```coq
Require Import Coq.Setoids.Setoid.
Require Import Coq.ZArith.ZArith.
Require Import Coq.micromega.Psatz.
Require Import Coq.Logic.Classical_Prop.
Local Open Scope Z.
```

### 整数算数运算与大小比较

鸡兔同笼问题：

```v
C + R = 35
2 * C + 4 * R = 94
```

```v
Fact chickens_and_rabbits: forall C R: Z,
	C + R = 35 ->
	2 * C + 4 * R = 94 ->
	C = 23.
```

Fact关键字 后面开始陈述命题
forall 对任何整数（Z）的C和R
-> 表示“如果，那么”，换句话说箭头前面的是条件，箭头后面的是结论

> 这里只描述命题，不表示命题真假。所以我们可以用Coq来检查

后面会看到箭头的其他用法

Coq 证明代码

```v
Proof. lia. Qed.
```

```v
Fact age_problem: forall A B: Z,
	A = B * 5 ->

```

lia

nia 但是nia有的时候会失败（我不懂为什么？）
