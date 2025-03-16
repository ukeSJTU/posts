## Problem

```python
"""
TODO:

foo should accept a argument that's either a string or integer.
"""


def foo(x):
    pass


```

## Testcase

```python
foo("foo")
foo(1)

foo([])  # expect-type-error
```

## Solution

```python
"""
TODO:

foo should accept a argument that's either a string or integer.
"""
from typing import Union


def foo(x: Union[str, int]) -> None:
    pass

```

或者

```python
def foo(x: str | int) -> None:
    pass
```

## Note

官方文档：[3.13文档](https://docs.python.org/3/library/typing.html#typing.Union)
