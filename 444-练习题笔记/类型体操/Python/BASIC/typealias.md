## Problem

```python
"""
TODO:

Create a new type called Vector, which is a list of float.
"""

```

## Testcase

```python
def foo(v: Vector):
    ...


foo([1.1, 2])
foo(1)  # expect-type-error
foo(["1"])  # expect-type-error
```

## Solution

```python
"""
TODO:

Create a new type called Vector, which is a list of float.
"""

from typing import TypeAlias

Vector: TypeAlias = list[int | float]

```

## Note

官方文档：[3.13文档](https://docs.python.org/3/library/typing.html#typing.TypeAlias)
