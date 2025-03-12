## Problem

```python
"""
TODO:

Make sure `my_list` cannot be re-assigned to.
"""


my_list = []

```

## Testcase

```python
my_list.append(1)
my_list = [] # expect-type-error
my_list = "something else" # expect-type-error

```

## Solution

```python
"""
TODO:

Make sure `my_list` cannot be re-assigned to.
"""
from typing import Final

my_list: Final = []

```

## Note

`typing.Final` 是 Python 类型提示系统中的一个特殊构造，用于向类型检查器指示某个名称是"最终的"（不可重新赋值）。

官方参考文档：

- [3.12版本](https://docs.python.org/3.12/library/typing.html#typing.Final)
- [3.13版本](https://docs.python.org/3.13/library/typing.html#typing.Final)

这个`Final`文档内容比较少，可以直接看官方文档。但是让我先解释一下为什么`my_list.append(1)`是合法的。

`typing.Final` 只限制了**变量名称的重新赋值**，而不限制对可变对象内容的修改。换句话说，`Final` 保护的是**引用**而非**对象内容**：

- 它防止变量被重新绑定到另一个对象
- 它不会使对象变为不可变（immutable）
- 对于可变对象（如列表、字典等），其内容仍然可以被修改

如果你希望内容也不可变，应该使用不可变数据类型（如元组）或第三方不可变数据结构。

总结提炼官方文档内容如下：

### 主要功能

- 标记为 `Final` 的变量不能在任何作用域中被重新赋值
- 在类作用域中声明的 `Final` 名称不能在子类中被覆盖
- **注意**：这只是类型检查时的约束，Python 运行时不会检查或强制执行这些规则

### 使用示例

```python
MAX_SIZE: Final = 9000
MAX_SIZE += 1  # 类型检查器会报错
```

这里声明 `MAX_SIZE` 为最终值，类型检查器会捕获到任何尝试修改它的操作。

```python
class Connection:
    TIMEOUT: Final[int] = 10

class FastConnector(Connection):
    TIMEOUT = 1  # 类型检查器会报错
```

在这个例子中，父类 `Connection` 将 `TIMEOUT` 声明为 `Final`，所以子类 `FastConnector` 不允许覆盖这个值。

### 实际应用

- 用于定义真正的常量
- 防止子类意外覆盖不应被修改的类属性
- 提高代码的可维护性和安全性

### `Final`和`ClassVar`的嵌套

> Changed in version 3.13: [`Final`](https://docs.python.org/3.13/library/typing.html#typing.Final "typing.Final") can now be nested in [`ClassVar`](https://docs.python.org/3.13/library/typing.html#typing.ClassVar "typing.ClassVar") and vice versa.

Python 3.13 版本中的一项变化：现在可以将 `Final` 和 `ClassVar` 相互嵌套使用。

[[class-var]]
