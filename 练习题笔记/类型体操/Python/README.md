本系列为Python类型挑战系列的解答。挑战网址链接：[https://python-type-challenges.zeabur.app/]

也可以GitHub下载源码本地部署：[https://github.com/laike9m/Python-Type-Challenges]

TODO: 什么是静态类型检查，什么是运行时类型判断

有些题目存在多解的情况。

## 学习路线

我自己做题的时候发现这个网站上的题目是按照题目名字的字母顺序排列的，如果你想通过练习做题来学习Python的类型的话，我建议你按照下面的顺序开始这个挑战，尽可能减少出现做前面的题目需要后面的知识点的情况。

### 基础阶段（BASIC）：

```mermaid
graph TD

    A1["变量(variable)"] --> A2(["函数"])
    A2 --> A3["函数参数(parameter)"]
    A2 --> A4["返回值(return)"]
    A3 & A4 --> A5(["基础类型概念"])
    A5 --> A6["Any类型(Any)"]
    A5 --> A7["可选类型(Optional)"]

    A6 & A7 -->A8["联合类型(Union)"]

    A8 --> A9(["容器类型"])
    A9 --> A10["列表(list)"]
    A9 --> A11["字典(dict)"]
    A9 --> A12["元组(tuple)"]

    A10 & A11 & A12 --> A13["关键字参数(kwargs)"]
    A13 --> A14(["类型别名和常量"])
    A14 --> A15["常量(Final)"]
    A14 --> A16["类型别名(typealias)"]

```

### 进阶阶段（INTERMEDIATE）

```mermaid
graph TD
    B1["self类型(self)"] --> B2(["类相关"])
    B2 --> B3["类变量(class-var)"]
    B2 --> B4["实例变量(instance-var)"]

    B3 & B4 --> B5["可调用对象(callable)"]

    B5 --> B6(["泛型系列"])
    B6 --> B7["基础泛型(generic)"]
    B6 --> B8["进阶泛型(generic2)"]
    B6 --> B9["高级泛型(generic3)"]

    B7 & B8 & B9 --> B10(["字面量类型"])
    B10 --> B11["Literal类型"]
    B10 --> B12["LiteralString类型"]

    B11 & B12 --> B13(["类型化字典"])
    B13 --> B14["基础TD(typed-dict)"]
    B13 --> B15["进阶TD(typed-dict2)"]
    B13 --> B16["高级TD(typed-dict3)"]

    B14 & B15 & B16 --> B17["装饰器基础"]
    B17 --> B18["异步类型(await)"]

```

### 高级阶段 (ADVANCED)

```mermaid
graph TD
    C1["协议(Protocol)"] --> C2(["类型系统"])
    C2 --> C3["类型(type)"]
    C2 --> C4["类型守卫(typeguard)"]

    C3 & C4 --> C5["高级装饰器(decorator)"]
    C5 --> C6["描述符(descriptor)"]

    C6 --> C7(["函数相关"])
    C7 --> C8["生成器类型(generator)"]
    C7 --> C9["函数重载(overload)"]
    C7 --> C10["参数规范(paramspec)"]

    C8 & C9 & C10 --> C11["泛型类(generic-class)"]
    C11 --> C12["递归类型(recursive)"]

```

### 专家阶段 (EXTREME)

```mermaid
graph TD
    D1["型变(variance)"] --> D2["构造函数类型(constructor)"]
    D2 --> D3["自类型转换(self-casting)"]
    D3 --> D4["类型拼接(concatenate)"]
```
