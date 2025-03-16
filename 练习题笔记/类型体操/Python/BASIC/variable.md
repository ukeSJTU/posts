## Problem

```python
"""
TODO:

`a` should be an integer.
"""
from typing import Any

a: Any


```

## Testcase

```python
a = 2
a = "1" # expect-type-error
```

## Solution

```python
"""
TODO:

`a` should be an integer.
"""
from typing import Any

a: int


```

## Note

```python
foo: int # no initial value
bar: str = "foobar" # with initial value
```
