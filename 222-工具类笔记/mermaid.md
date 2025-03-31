# Mermaid 笔记

mermaid 官网：https://mermaid.js.org/
mermaid 在线编辑器：https://mermaid.live/

下面的笔记是对 Mermaid 语法的整理，涵盖了 Mermaid 的基本概念、图表类型、语法结构和常见用法。主要参考的就是官网的文档部分：https://mermaid.js.org/intro/

## 0 语法框架和 Configuration

https://mermaid.js.org/intro/syntax-reference.html

### Syntax Structure

all Diagrams definitions begin with a declaration of the diagram type, followed by the definitions of the diagram and its contents. This declaration notifies the parser which kind of diagram the code is supposed to generate.

### Diagram Breaking

有一些词会让 parser 没有办法解析图表，下面这些词会让 parser 认为是图表的结束：

| Diagram Breakers                                                       | Reason                                                             | Solution                                          |
| ---------------------------------------------------------------------- | ------------------------------------------------------------------ | ------------------------------------------------- |
| Comments [%%{``}%%](https://github.com/mermaid-js/mermaid/issues/1968) | Similar to Directives confuses the renderer.                       | In comments using %%, avoid using "{}".           |
| Flow-Charts 'end'                                                      | The word "End" can cause Flowcharts and Sequence diagrams to break | Wrap them in quotation marks to prevent breakage. |
| Nodes inside Nodes                                                     | Mermaid gets confused with nested shapes                           | wrap them in quotation marks to prevent breaking  |

### Configuration

可以设置一些配置项来影响图表的渲染效果，下面是一些常用的配置项：

暂时跳过

## 1 Diagram Syntax

正如我们前面说到的，mermaid 的基本语法结构就是第一行先声明这个图标的类型，然后后面一行一行描述这个图表里面的元素。换句话说，从第二行开始的内容是受制于第一行声明的图表类型的。因此我们后面的笔记就是按照图标类型依次介绍。这个和官网的 doc 保持一致。

### Flowchart

流程图 Flowcharts are composed of nodes (geometric shapes) and edges (arrows or lines).

TODO: 这里补充一个尽可能多的用到下面这些内容的 flowchart 图

#### Direction

Possible FlowChart orientations are:

- TB - Top to bottom
- TD - Top-down/ same as top to bottom
- BT - Bottom to top
- RL - Right to left
- LR - Left to right

#### Node

默认的节点像下面这个样子：

```mermaid
---
title: Node
---
flowchart LR
    id

```

实际上完整的 Node 几个部分是这样的：

```plaintext
<node_id>["<node_label>"]:::<class_name>
```

##### text

会显示 node_label，如果没有的话就会显示 node_id

node_label 除了下面几种情况以外可以不用双引号：

1. Unicode 字符

```mermaid
flowchart LR
    id["This ❤ Unicode"]
```

2. markdown 格式文本

```mermaid
flowchart LR
    markdown["`This **is** _Markdown_`"]
    newLines["`Line1
    Line 2
    Line 3`"]
    markdown --> newLines
```

##### Shape

下面是最常见的几种 Node Shape：

```plaintext
flowchart LR
    id1(This is the text in the box)
```

```mermaid
flowchart LR
    id1(This is the text in the box)
```

---

v11.3.0 引入了下面这种语法来更好的声明 node shape

```mermaid
flowchart TD
    A@{ shape: flip-tri, label: "Manual file" }
```

---

v11.3.0 还引入了下面两种特殊的 Node：

1. Icon Shape

https://mermaid.js.org/syntax/flowchart.html#icon-shape

```mermaid
flowchart TD
    A@{ icon: "fa:user", form: "square", label: "User Icon", pos: "t", h: 48 }
```

2. Image Shape

https://mermaid.js.org/syntax/flowchart.html#image-shape

```mermaid
flowchart TD
    A@{ img: "https://picsum.photos/200", label: "Image Label", pos: "t", w: 60, h: 60, constraint: "off" }
```

#### Link

Nodes can be connected with links/edges. It is possible to have different types of links or attach a text string to a link.

```plaintext
flowchart LR
    A-- This is the text! ---B
```

```mermaid
flowchart LR
    A-- This is the text! ---B
```

##### Length

Each node in the flowchart is ultimately assigned to a rank in the rendered graph, i.e. to a vertical or horizontal level (depending on the flowchart orientation), based on the nodes to which it is linked. By default, links can span any number of ranks, but you can ask for any link to be longer than the others by adding extra dashes in the link definition.

```plaintext
flowchart TD
    A[Start] --> B{Is it?}
    B -->|Yes| C[OK]
    C --> D[Rethink]
    D --> B
    B ---->|No| E[End]
```

```mermaid
flowchart TD
    A[Start] --> B{Is it?}
    B -->|Yes| C[OK]
    C --> D[Rethink]
    D --> B
    B ---->|No| E[End]
```

如果想要延长连接线的长度，可以在连接线中添加额外的连字符。下面是一些常见的连接线长度：

| Length            | 1    | 2     | 3      |
| ----------------- | ---- | ----- | ------ |
| Normal            | ---  | ----  | -----  |
| Normal with arrow | -->  | --->  | ---->  |
| Thick             | ===  | ====  | =====  |
| Thick with arrow  | ==>  | ===>  | ====>  |
| Dotted            | -.-  | -..-  | -...-  |
| Dotted with arrow | -.-> | -..-> | -...-> |

#### Subgraph

#### 其他

> [!WARNING]
> 如果您在流程图节点中使用单词 "end"，请将整个单词或任意字母大写（例如，"End" 或 "END"），或应用此解决方法。在全小写字母中输入 "end" 将破坏流程图。

> [!WARNING]
> 如果您在连接流程图节点时使用字母 "o" 或 "x" 作为第一个字母，请在字母前添加空格或将字母大写（例如，"dev--- ops"，"dev---Ops"）。
>
> 输入 "A---oB" 将创建一个圆形边缘。
>
> 输入 "A---xB" 将创建一个交叉边缘。
