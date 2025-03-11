## Problem
```python
"""
TODO:

foo should accept a dict argument, both keys and values are string.
"""


def foo(x):
    pass


```

## Testcase

```plaintext
foo({"foo": "bar"}) 
foo({"foo": 1})  # expect-type-error

```

## Solution

```python
"""
TODO:

foo should accept a dict argument, both keys and values are string.
"""


def foo(x: dict[str, str]):
    pass


```

## Note

自Python3.9版本已Deprecated的[typing.Dict官方文档](https://docs.python.org/3.12/library/typing.html#typing.Dict)，里面提到：

> Note that to annotate arguments, it is preferred to use an abstract collection type such as [`Mapping`](https://docs.python.org/3.12/library/collections.abc.html#collections.abc.Mapping "collections.abc.Mapping") rather than to use [`dict`](https://docs.python.org/3.12/library/stdtypes.html#dict "dict") or `typing.Dict`.

### 利用`Mapping`的写法

```python
"""
TODO:

foo should accept a dict argument, both keys and values are string.
"""
from typing import Mapping

def foo(x: Mapping[str, str]):
    pass


```

### `Mapping` vs `dict`

#### 遵循依赖倒置原则
"依赖倒置原则"，即依赖于抽象而非具体实现。使用抽象类型（如 `Mapping`）而非具体实现（如 `dict`）可以让你的代码更加灵活。

#### `Mapping`有更好的兼容性和灵活性

`Mapping` 是一个抽象基类，表示所有类似字典的对象，不仅仅是 `dict`。使用 `Mapping` 意味着你的函数可以接受：

- 普通的 `dict`
- `collections.defaultdict`
- `collections.OrderedDict`
- `types.MappingProxyType`
- 任何其他实现了映射协议的自定义类

“实现了映射协议的自定义类”指的是任何实现了 Python 映射协议（Mapping Protocol）的自定义类。在 Python 中，协议是一组方法的集合，实现了这些方法的类被认为遵循该协议。而映射协议要求实现的核心方法：
- `__getitem__(self, key)`: 允许使用 `obj[key]` 语法
- `__iter__(self)`: 允许迭代所有键
- `__len__(self)`: 返回映射中项目的数量

下面是个自定义映射类的例子：
```python
from typing import Iterator, TypeVar, Generic, Dict, Mapping

K = TypeVar('K')
V = TypeVar('V')

class ReadOnlyDict(Generic[K, V]):
    """一个只读的字典类，实现了映射协议"""
    
    def __init__(self, data: Dict[K, V]):
        self._data = dict(data)  # 创建一个副本
    
    def __getitem__(self, key: K) -> V:
        """实现 obj[key] 语法"""
        return self._data[key]
    
    def __iter__(self) -> Iterator[K]:
        """实现 for key in obj 语法"""
        return iter(self._data)
    
    def __len__(self) -> int:
        """实现 len(obj) 函数"""
        return len(self._data)
    
    def items(self):
        """实现 .items() 方法"""
        return self._data.items()
    
    def keys(self):
        """实现 .keys() 方法"""
        return self._data.keys()
    
    def values(self):
        """实现 .values() 方法"""
        return self._data.values()
    
    def get(self, key: K, default=None) -> V:
        """实现 .get() 方法"""
        return self._data.get(key, default)

def print_names(people: Mapping[str, str]) -> None:
    """打印人名和职业"""
    for id, name in people.items():
        print(f"ID: {id}, Name: {name}")

# 使用我们的自定义类
employee_data = ReadOnlyDict({"001": "张三", "002": "李四", "003": "王五"})
print_names(employee_data)  # 可以正常工作，因为 ReadOnlyDict 实现了映射协议
```

#### 明确表达意图

使用 `Mapping` 表明你只需要一个"可读的映射对象"，而不一定需要 `dict` 的所有特性（如可变性）。如果你真的需要可变映射，可以使用 `MutableMapping`。

#### 什么时候用`dict`而不是`Mapping`?

在下面这些情况下，使用`dict`可能更合适：
1. **返回值类型**：如果你的函数明确返回一个 `dict` 对象，使用 `dict` 作为返回类型注解更准确。
2. **需要特定方法**：如果你的函数需要使用 `dict` 特有的方法（如 `update()`、`clear()`等），则应使用 `dict` 或 `MutableMapping`。


### 内置的`dict`

`dict`不仅可以用来创建字典对象，还可以作为类型注解使用。值得注意的是，想要用类似`dict[KeyType, ValueType]`这样的语法添加注释必须得是**Python 3.9+**，而如果是**Python 3.7-3.8**的话，必须`from typing import Dict`。

官方文档：[builtins.dict官方文档](https://docs.python.org/3.12/library/stdtypes.html#dict)。内容提炼如下：

#### 字典对象及相关方法

> A [mapping](https://docs.python.org/3.12/glossary.html#term-mapping) object maps [hashable](https://docs.python.org/3.12/glossary.html#term-hashable) values to arbitrary objects. Mappings are mutable objects. There is currently only one standard mapping type, the _dictionary_.

本系列教程主要聚焦于类型体操，所以就不展开`dict`类型的方法了。

#### 类型注解

使用`dict`作类型注解需要注意Python版本兼容性

- **Python 3.9+**: 可以直接使用 `dict[KeyType, ValueType]` 语法
- **Python 3.7-3.8**: 需要从 `typing` 模块导入 `Dict`，使用 `Dict[KeyType, ValueType]`

##### 基本类型注解

```python
def process_user_data(user_info: dict[str, str]) -> None:
    """处理用户信息，键和值都是字符串"""
    for key, value in user_info.items():
        print(f"{key}: {value}")

# 使用示例
user = {"name": "张三", "email": "zhangsan@example.com", "phone": "12345678901"}
process_user_data(user)
```

##### 复杂类型注解

```python
def analyze_scores(class_scores: dict[str, list[int]]) -> float:
    """分析每个学生的成绩列表，返回平均分"""
    total_score = 0
    total_count = 0
    
    for student, scores in class_scores.items():
        total_score += sum(scores)
        total_count += len(scores)
    
    return total_score / total_count if total_count > 0 else 0

# 使用示例
scores = {
    "张三": [85, 90, 78],
    "李四": [92, 88, 95],
    "王五": [75, 82, 80]
}
average = analyze_scores(scores)
```

##### 嵌套`dict`类型注解

```python
def process_department_data(company_data: dict[str, dict[str, list[str]]]) -> None:
    """处理公司部门数据
    
    参数:
        company_data: 一个字典，键是部门名称，值是另一个字典，
                     内层字典的键是团队名称，值是团队成员列表
    """
    for department, teams in company_data.items():
        print(f"部门: {department}")
        for team, members in teams.items():
            print(f"  团队: {team}")
            for member in members:
                print(f"    成员: {member}")

# 使用示例
company = {
    "技术部": {
        "前端组": ["张三", "李四"],
        "后端组": ["王五", "赵六", "孙七"]
    },
    "市场部": {
        "销售组": ["钱八", "周九"],
        "客服组": ["吴十"]
    }
}
process_department_data(company)
```

