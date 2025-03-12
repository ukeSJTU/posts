## Problem

```python
"""
TODO:

foo can accept an integer argument, None or no argument at all.
"""


def foo(x):
    pass


```

## Testcase

```python
foo(10)
foo(None)
foo()

foo("10") # expect-type-error

```

## Solution

```python
"""
TODO:

foo can accept an integer argument, None or no argument at all.
"""


def foo(x: int | None = None):
    pass


```

## Note

这道题目主要是提示三个概念：

1. 联合类型可以通过`|`运算符来实现，例如`<Type1> | <Type2>`，这个我们前面在[[kwargs#Pipe vs `Union`]]中也提到了;
2. `None`可以直接被用来进行类型注解；
3. 类型注解不能让一个参数“可选”，而是应该通过默认值来实现。
