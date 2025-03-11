## Problem

```python
"""
TODO:

foo should accept a list argument, whose elements are string.
"""


def foo(x):
    pass


```

## Testcase

```plaintext
foo(["foo", "bar"])
foo(["foo", 1])  # expect-type-error

```

## Solution

```python
"""
TODO:

foo should accept a list argument, whose elements are string.
"""


def foo(x: list[str]):
    pass


```

## Note

可以用[List](https://docs.python.org/3/library/typing.html#typing.List)(Python 3.9版本开始被废弃)或者内置的`list`来解决这个问题。

> Note that to annotate arguments, it is preferred to use an abstract collection type such as [`Sequence`](https://docs.python.org/3/library/collections.abc.html#collections.abc.Sequence "collections.abc.Sequence") or [`Iterable`](https://docs.python.org/3/library/collections.abc.html#collections.abc.Iterable "collections.abc.Iterable") rather than to use [`list`](https://docs.python.org/3/library/stdtypes.html#list "list") or `typing.List`.

`Sequence`和`list`的关系就像[[dict#Note]]里面提到的`Mapping`和`dict`的关系。

### 利用 `Sequence` 的写法

```python
"""
TODO:

foo 应接受一个列表参数，元素为整数。
"""
from collections.abc import Sequence

def foo(x: Sequence[int]):
    pass
```

### `Sequence` vs `list`

#### 遵循依赖倒置原则

依赖于抽象而非具体实现。使用抽象类型（如 `Sequence`）而非具体实现（如 `list`）使代码更加灵活。

#### `Sequence` 有更好的兼容性和灵活性

`Sequence` 是一个抽象基类，表示所有类似列表的对象，不仅仅是 `list`。使用 `Sequence` 意味着你的函数可以接受：

- 普通的 `list`
- `tuple`
- `str`（字符串是字符的序列）
- `bytes`
- `range` 对象
- `array.array`
- 任何其他实现了序列协议的自定义类

"实现了序列协议的自定义类"指的是任何实现了 Python 序列协议（Sequence Protocol）的自定义类。序列协议要求实现的核心方法：

- `__getitem__(self, index)`: 允许使用 `obj[index]` 语法
- `__len__(self)`: 返回序列中项目的数量

下面是个自定义序列类的例子：

```python
from typing import TypeVar, Generic, Sequence, Iterator, Any

T = TypeVar('T')

class ReadOnlyList(Generic[T]):
    """一个只读的列表类，实现了序列协议"""

    def __init__(self, data: list[T]):
        self._data = list(data)  # 创建一个副本

    def __getitem__(self, index: int) -> T:
        """实现 obj[index] 语法"""
        return self._data[index]

    def __len__(self) -> int:
        """实现 len(obj) 函数"""
        return len(self._data)

    def __iter__(self) -> Iterator[T]:
        """实现 for item in obj 语法"""
        return iter(self._data)

def sum_numbers(numbers: Sequence[int]) -> int:
    """计算序列中所有数字的和"""
    return sum(numbers)

# 使用我们的自定义类
read_only_numbers = ReadOnlyList([1, 2, 3, 4, 5])
result = sum_numbers(read_only_numbers)  # 可以正常工作，因为 ReadOnlyList 实现了序列协议
```

#### 明确表达意图

使用 `Sequence` 表明你只需要一个"可读的序列对象"，而不一定需要 `list` 的所有特性（如可变性）。如果你真的需要可变序列，可以使用 `MutableSequence`。

#### 什么时候用 `list` 而不是 `Sequence`?

在下面这些情况下，使用 `list` 可能更合适：

1. **返回值类型**：如果你的函数明确返回一个 `list` 对象，使用 `list` 作为返回类型注解更准确。
2. **需要特定方法**：如果你的函数需要使用 `list` 特有的方法（如 `append()`、`sort()`等），则应使用 `list` 或 `MutableSequence`。

### `Iterable` 与 `Sequence` 的区别

`Iterable` 是更宽泛的概念，表示任何可以迭代的对象：

- `Iterable` 只保证可以用 `for` 循环遍历，不保证可以索引或知道长度
- `Sequence` 是 `Iterable` 的子类型，额外保证可以通过索引访问元素和获取长度

```python
from collections.abc import Iterable, Sequence

def process_iterable(items: Iterable[str]) -> None:
    """处理任何可迭代的字符串集合"""
    for item in items:  # 只使用迭代功能
        print(item)

def process_sequence(items: Sequence[str]) -> None:
    """处理序列类型的字符串集合"""
    print(f"总数: {len(items)}")  # 使用长度
    print(f"第一项: {items[0]}")  # 使用索引
    for i, item in enumerate(items):  # 使用迭代
        print(f"{i}: {item}")
```

### 内置的 `list`

`list` 不仅可以用来创建列表对象，还可以作为类型注解使用。值得注意的是，想要用类似 `list[ElementType]` 这样的语法添加注释必须得是 **Python 3.9+**，而如果是 **Python 3.7-3.8** 的话，必须 `from typing import List`。

官方文档：[builtins.list官方文档](https://docs.python.org/3.12/library/stdtypes.html#list)

#### 类型注解

使用 `list` 作类型注解需要注意 Python 版本兼容性：

- **Python 3.9+**: 可以直接使用 `list[ElementType]` 语法
- **Python 3.7-3.8**: 需要从 `typing` 模块导入 `List`，使用 `List[ElementType]`

##### 基本类型注解

```python
def process_names(names: list[str]) -> None:
    """处理名字列表"""
    for name in names:
        print(f"你好，{name}!")

# 使用示例
students = ["张三", "李四", "王五"]
process_names(students)
```

##### 复杂类型注解

```python
def process_matrix(matrix: list[list[float]]) -> float:
    """处理二维浮点数矩阵，返回所有元素的平均值"""
    total = 0.0
    count = 0

    for row in matrix:
        for value in row:
            total += value
            count += 1

    return total / count if count > 0 else 0.0

# 使用示例
data = [
    [1.0, 2.5, 3.7],
    [4.2, 5.0, 6.1],
    [7.8, 8.3, 9.9]
]
average = process_matrix(data)
```

### 常见序列操作比较

| 操作                      | `list` | `Sequence` | `Iterable` |
| ------------------------- | ------ | ---------- | ---------- |
| 索引访问 `x[i]`           | ✅     | ✅         | ❌         |
| 切片 `x[i:j]`             | ✅     | ✅         | ❌         |
| 获取长度 `len(x)`         | ✅     | ✅         | ❌         |
| 迭代 `for i in x`         | ✅     | ✅         | ✅         |
| 添加元素 `x.append(item)` | ✅     | ❌         | ❌         |
| 排序 `x.sort()`           | ✅     | ❌         | ❌         |
| 检查包含 `item in x`      | ✅     | ✅         | ✅         |

### 常见用例

```python
from collections.abc import Iterable, Sequence
from typing import TypeVar, cast

T = TypeVar('T')

def process_any_iterable(data: Iterable[T]) -> list[T]:
    """处理任何可迭代对象，返回处理后的列表"""
    return [item for item in data]  # 只需要迭代功能

def process_sequence(data: Sequence[T]) -> list[T]:
    """处理序列，可以使用索引和长度"""
    result = []
    for i in range(len(data)):  # 使用长度
        if i % 2 == 0:  # 只处理偶数索引
            result.append(data[i])  # 使用索引访问
    return result

def process_list(data: list[T]) -> list[T]:
    """处理列表，可以使用列表特有的方法"""
    result = list(data)  # 创建副本
    result.sort()  # 使用列表特有方法
    result.append(cast(T, "---分隔符---"))  # 添加元素
    return result
```
