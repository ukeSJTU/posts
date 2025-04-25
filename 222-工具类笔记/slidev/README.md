# Sli.dev

Slidev 是一个用于创建演示文稿的工具，它允许你使用 Markdown 语法来编写内容，并通过预设的模板和主题来生成美观的演示文稿。Slidev 提供了丰富的功能，包括代码高亮、数学公式、图表绘制等，使得创建演示文稿变得更加简单和高效。

[文档链接](https://sli.dev/)

[中文版文档](https://cn.sli.dev/)

下面开始笔记

---

怎么用 slidev？

基础使用直接看官方的 getting started 内容。

---

为什么用 slidev？

我觉得可以看一下官方的 features 列表，看看有什么特殊的地方。

https://sli.dev/features/

---

`slidev`命令的使用

https://sli.dev/guide/#basic-commands

https://sli.dev/builtin/cli#dev

https://sli.dev/builtin/cli

然后产生的文件结构放在这里：https://sli.dev/custom/#directory-structure; https://sli.dev/custom/directory-structure

---

vscode 编辑器等等插件设置

https://sli.dev/guide/#editor

---

## Syntax Guide

我觉得这里面最好就讲解 slidev 里面可以放些什么东西，因此我觉得直接把 animations 也放进来，和 components 简单介绍，然后连接到下面。

https://sli.dev/guide/syntax

下面的标题要和 sli.dev 里面的内容对应，但是要更具体

### Slide Separators

```md
---
```

### Frontmatter & Headmatter

TODO：这里网页版文档只简单介绍。我想要直接在这里完整介绍

链接内容：https://sli.dev/custom/

### Code Blocks

我觉得这里 一种是传统的通过三个 backticks 插入。

另一种是`<<< @/<paths/to/file.ext>[#region-identifier]{shikistyle}`这个样子

然后展开 shiki 的设置等等

### Latex

### TODO

等等

---

## Configurations

https://sli.dev/custom/

当然还要配置各种子内容，例如 highlighter 或者 katex 等等

themes：https://sli.dev/guide/theme-addon#use-theme
https://sli.dev/guide/write-theme

addons: https://sli.dev/guide/theme-addon#use-addon
https://sli.dev/guide/write-addon

layouts: https://sli.dev/guide/layout
https://sli.dev/guide/write-layout

---

## Global Context

https://sli.dev/guide/global-context

---

## Export & Hosting

https://sli.dev/guide/exporting

https://sli.dev/guide/hosting

---

## Components

基础使用：https://sli.dev/guide/component

内置的 Built-in：https://sli.dev/builtin/components

---

## Animations

https://sli.dev/guide/animations
