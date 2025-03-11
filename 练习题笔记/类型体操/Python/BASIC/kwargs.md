## Problem

```python
"""
TODO:

`foo` takes keyword arguments of type integer or string.
"""


def foo(**kwargs):
    ...


```

## Testcase

```plaintext
foo(a=1, b="2")
foo(a=[1]) # expect-type-error

```

## Solution

```python
"""
TODO:

`foo` takes keyword arguments of type integer or string.
"""


def foo(**kwargs: int | str):
    ...


```

## Note

### `**kwargs: <T>`注解

`**kwargs: 类型` - 这种注解方式表示所有关键字参数的值必须符合指定的类型。

```python
# file: kwargs_typing_demo.py
from typing import get_type_hints

def process_config(**kwargs: int | str):
    """处理配置参数，只接受整数或字符串类型的值"""
    print("类型提示:", get_type_hints(process_config))

    print("\n接收到的参数:")
    for key, value in kwargs.items():
        print(f"  {key}: {value} (类型: {type(value).__name__})")

# 正确用法示例
print("=== 正确用法 ===")
process_config(
    timeout=30,           # 整数
    host="localhost",     # 字符串
    port=8080,            # 整数
    username="admin"      # 字符串
)

# 以下代码在运行时不会出错，但会被 mypy 等类型检查工具标记为错误
print("\n=== 类型错误（运行时不会检查，但静态类型检查会发现） ===")
process_config(
    settings={"debug": True},  # 字典类型 - 违反类型约束
    enabled=True,              # 布尔类型 - 违反类型约束
    rates=[1.2, 3.4]           # 列表类型 - 违反类型约束
)

# 演示如何使用 mypy 检查
print("\n=== 如何使用 mypy 检查 ===")
print("在命令行运行: mypy kwargs_typing_demo.py")
print("mypy 将会指出第二个调用中的类型错误")
```

### `|` vs `Union`

| Python 版本       | 联合类型语法             | 示例代码                                         |
| ----------------- | ------------------------ | ------------------------------------------------ |
| Python 3.10+      | `int                     | str`                                             |
| Python 3.9 及更早 | `typing.Union[int, str]` | `def foo(**kwargs: typing.Union[int, str]): ...` |

如果要考虑对旧版本的兼容性，可以这样写：

```python
import sys
if sys.version_info >= (3, 10):
    # Python 3.10+
    IntOrStr = int | str
else:
    # 旧版本 Python
    from typing import Union
    IntOrStr = Union[int, str]

def foo(**kwargs: IntOrStr):
	...
```
