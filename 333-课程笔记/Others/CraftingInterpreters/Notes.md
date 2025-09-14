REPL: Read a line of input, Evaluate it, Print the result, then Loop and do it all over again.

```plaintext
(print (eval (read)))
```

在Scanner这里，处理number literals的话：
Lox设计所有的数字在runtime都是浮点数，例如：

```plaintext
1234
12.34
```

但是不允许：

```plaintext
.1234
1234.
```

去除前者是为了实现方便，后者是因为`1234.sqrt()`会比较棘手。

而关于负数的处理：可以在Scanner里面看到我们是检测大0-9数字才开始处理number literal的，那么负数怎么办呢？

- 我们可以认为是把`-`这个一元运算符作用到正数上面去。这个方法可行，但是考虑`print -123.abs()`，这个因为negation has lower precedence than method calls，所以会输出`-123`。
- 假如我们把`-`当作number的一部分，那么下面的例子：`var n = 123; print -n.abs()`仍然会输出`-123`。
  总之无论怎样处理都会有这种比较奇怪的问题。
