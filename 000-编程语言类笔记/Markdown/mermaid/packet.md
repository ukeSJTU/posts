https://mermaid.js.org/syntax/packet.html

可以用来展示network packets分包的结构与内容

基本语法：

````markdown
```mermaid
packet-beta
title <Title String>
<Range>: <Field Description>
start: "Block name" %% Single-bit block
start-end: "Block name" %% Multi-bit blocks
```
````

标题也可以：

````markdown
```mermaid
---
title: "Title String"
---
packet-beta
```
````

可配置选项：

https://mermaid.js.org/config/schema-docs/config-defs-packet-diagram-config.html

````markdown
```mermaid
---
config:
  packet:
    ...: ...
---
```
````

| Property                                                                                                  | Type      | Required | Nullable       | Defined by                                                                                                                                                                                                                    | Default |
| --------------------------------------------------------------------------------------------------------- | --------- | -------- | -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------- |
| [rowHeight](https://mermaid.js.org/config/schema-docs/config-defs-packet-diagram-config.html#rowheight)   | `number`  | Optional | cannot be null | [Mermaid Config](https://mermaid.js.org/config/schema-docs/config-defs-packet-diagram-config-properties-rowheight.html "https://mermaid.js.org/schemas/config.schema.json#/$defs/PacketDiagramConfig/properties/rowHeight")   | 32      |
| [bitWidth](https://mermaid.js.org/config/schema-docs/config-defs-packet-diagram-config.html#bitwidth)     | `number`  | Optional | cannot be null | [Mermaid Config](https://mermaid.js.org/config/schema-docs/config-defs-packet-diagram-config-properties-bitwidth.html "https://mermaid.js.org/schemas/config.schema.json#/$defs/PacketDiagramConfig/properties/bitWidth")     | 32      |
| [bitsPerRow](https://mermaid.js.org/config/schema-docs/config-defs-packet-diagram-config.html#bitsperrow) | `number`  | Optional | cannot be null | [Mermaid Config](https://mermaid.js.org/config/schema-docs/config-defs-packet-diagram-config-properties-bitsperrow.html "https://mermaid.js.org/schemas/config.schema.json#/$defs/PacketDiagramConfig/properties/bitsPerRow") | 32      |
| [showBits](https://mermaid.js.org/config/schema-docs/config-defs-packet-diagram-config.html#showbits)     | `boolean` | Optional | cannot be null | [Mermaid Config](https://mermaid.js.org/config/schema-docs/config-defs-packet-diagram-config-properties-showbits.html "https://mermaid.js.org/schemas/config.schema.json#/$defs/PacketDiagramConfig/properties/showBits")     | `true`  |
| [paddingX](https://mermaid.js.org/config/schema-docs/config-defs-packet-diagram-config.html#paddingx)     | `number`  | Optional | cannot be null | [Mermaid Config](https://mermaid.js.org/config/schema-docs/config-defs-packet-diagram-config-properties-paddingx.html "https://mermaid.js.org/schemas/config.schema.json#/$defs/PacketDiagramConfig/properties/paddingX")     | 5       |
| [paddingY](https://mermaid.js.org/config/schema-docs/config-defs-packet-diagram-config.html#paddingy)     | `number`  | Optional | cannot be null | [Mermaid Config](https://mermaid.js.org/config/schema-docs/config-defs-packet-diagram-config-properties-paddingy.html "https://mermaid.js.org/schemas/config.schema.json#/$defs/PacketDiagramConfig/properties/paddingY")     | 5       |

- rowHeight可以控制每一行的高度
- bitWidth控制宽度
- bitsPerRow每一行多少个bits，默认是32
- showBits控制是否要显示开始的bit位和结束的bit位
- paddingX和paddingY分别控制单元格横向和纵向之间的间距。
