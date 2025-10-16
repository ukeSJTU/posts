# 程序语言语法的 Coq 定义

## 简单Coq证明与定义

可以写数学定义和数学证明

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
