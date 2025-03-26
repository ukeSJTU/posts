## Problem

```python
"""
TODO:

foo should return an integer argument.
"""


def foo():
    return 1


```

## Testcase

```python
from typing import assert_type

assert_type(foo(), int)
assert_type(foo(), str) # expect-type-error

```

## Solution

```python
"""
TODO:

foo should return an integer argument.
"""


def foo() -> int:
    return 1


```

## Note

Python中给返回值添加类型注解的语法是：

```python
def foo() -> <T>:
	pass
```

### `typing.assert_type(val, typ, /)`的用法

> At runtime this does nothing: it returns the first argument unchanged with no checks or side effects, no matter the actual type of the argument.

也就是说`assert_type` 主要用于静态类型检查，运行时不会实际验证类型。

这个功能是Python 3.11版本引入的。

### `assert_type`和`isinstance`的对比

这两个函数有根本性的区别：

#### 1. 执行时机

- **`assert_type`**: 静态类型检查时执行，运行时基本是空操作
- **`isinstance`**: 运行时执行，实际检查对象的类型

#### 2. 类型判断方式

- **`assert_type`**: 基于静态类型系统的类型兼容性规则
- **`isinstance`**: 基于对象的实际类型和继承关系

#### 3. 继承处理

- **`assert_type`**: 遵循静态类型规则，子类实例可以断言为父类类型
- **`isinstance`**: 检查对象是否是特定类或其子类的实例

#### 4. 用途

- **`assert_type`**: 开发时类型验证，帮助静态类型检查器
- **`isinstance`**: 运行时类型检查，用于条件逻辑

例如：

```python
from typing import assert_type

class Parent:
    pass

class Child(Parent):
    pass

# 创建实例
parent = Parent()
child = Child()

# assert_type 示例 (静态检查)
assert_type(child, Child)   # 有效
assert_type(child, Parent)  # 有效 - Child 是 Parent 的子类
# assert_type(parent, Child)  # 无效 - 静态类型检查失败

# isinstance 示例 (运行时检查)
print(isinstance(child, Child))   # True
print(isinstance(child, Parent))  # True - child 是 Parent 的实例
print(isinstance(parent, Child))  # False - parent 不是 Child 的实例

# 动态类型情况
def get_object():
    return Child()  # 返回 Child 实例

obj = get_object()
print(isinstance(obj, Child))  # True - 运行时检查
# 如果没有类型提示，静态类型检查器无法知道 obj 的类型
```

#### 5. 泛型和复杂类型

```python
from typing import List, assert_type

# 对于泛型类型
numbers = [1, 2, 3]
assert_type(numbers, List[int])  # 静态检查泛型参数

# isinstance 不能直接检查泛型参数
print(isinstance(numbers, list))  # True
# print(isinstance(numbers, List[int]))  # 错误 - 运行时不支持泛型参数检查
```
