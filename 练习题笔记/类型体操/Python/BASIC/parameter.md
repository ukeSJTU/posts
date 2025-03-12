## Problem

```python
"""
TODO:

foo should accept an integer argument.
"""


def foo(x):
    pass


```

## Testcase

```plaintext
foo(10)

foo("10") # expect-type-error
```

## Solution

```python
"""
TODO:

foo should accept an integer argument.
"""


def foo(x: int):
    pass


```

## Note

Python中类型提示（type hints）的语法是：

```python
def foo(x: <T>):
	pass
```
