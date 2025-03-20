# macOS 剪贴板命令：pbcopy 和 pbpaste 详解

根据 man 页面的内容，pbcopy 和 pbpaste 是 macOS 系统提供的命令行工具，用于与系统剪贴板（Pasteboard，也称为 Clipboard）进行交互。这些命令让用户能够在终端和图形界面程序之间方便地共享数据。

## 基本概念

### Pasteboard（剪贴板）系统

macOS 的剪贴板系统称为 Pasteboard，它是一个可以存储多种数据类型的系统级缓冲区。与 Windows 或 Linux 系统类似，但 macOS 的 Pasteboard 有一些独特的特性：

1. **多个剪贴板**：macOS 维护多个独立的剪贴板（pasteboard），包括：

   - `general`：通用剪贴板，这是默认的剪贴板，用于常规的复制粘贴操作
   - `ruler`：用于存储标尺信息
   - `find`：存储查找操作的相关数据
   - `font`：存储字体信息

2. **多种数据类型**：每个剪贴板可以同时包含同一内容的多种表示形式，如：
   - 纯文本（Plain Text）
   - 富文本（Rich Text Format，RTF）
   - 封装的 PostScript（Encapsulated PostScript，EPS）
   - 其他格式（如 HTML、PDF、图像等）

## pbcopy 命令

`pbcopy` 命令用于将数据复制到剪贴板。

### 基本用法

```bash
# 将文本直接复制到剪贴板
echo "Hello World" | pbcopy

# 将文件内容复制到剪贴板
cat file.txt | pbcopy
```

### 参数选项

- `-pboard {general | ruler | find | font}`：指定要使用的剪贴板，默认为 `general`

### 数据类型识别

`pbcopy` 会自动尝试识别输入数据的类型：

- 如果数据以 EPS 文件头开始，则作为 EPS 格式存储
- 如果数据以 RTF 文件头开始，则作为 RTF 格式存储
- 其他情况下，作为纯文本存储

## pbpaste 命令

`pbpaste` 命令用于从剪贴板提取数据并输出到标准输出。

### 基本用法

```bash
# 显示剪贴板内容
pbpaste

# 将剪贴板内容保存到文件
pbpaste > output.txt
```

### 参数选项

- `-pboard {general | ruler | find | font}`：指定要从哪个剪贴板读取数据，默认为 `general`
- `-Prefer {txt | rtf | ps}`：指定优先读取的数据类型
  - `txt`：优先读取纯文本（这是默认行为）
  - `rtf`：优先读取富文本格式
  - `ps`：优先读取 PostScript 格式
  - 注意：`ascii` 是已废弃的选项，但仍然可用，等同于 `txt`

### 数据检索逻辑

`pbpaste` 按照以下顺序检索数据（除非使用 `-Prefer` 选项更改优先级）：

1. 首先查找纯文本数据
2. 如果没有纯文本，则查找 EPS 数据
3. 如果没有 EPS，则查找 RTF 数据
4. 如果以上类型都不存在，则不输出任何内容

## 编码处理

pbcopy 和 pbpaste 使用系统的区域设置（locale）环境变量来确定输入和输出的编码：

- 如果设置了环境变量（如 `LANG=en_US.UTF-8`），则使用指定的编码（如 UTF-8）
- 如果未设置区域变量，则使用标准 C 编码
- macOS 的 Terminal 应用默认使用 UTF-8 编码，并自动设置相应的区域环境变量

## 实用示例

```bash
# 复制当前目录列表到剪贴板
ls -la | pbcopy

# 复制文件内容到剪贴板
cat document.txt | pbcopy

# 将剪贴板内容追加到文件
pbpaste >> document.txt

# 处理剪贴板内容
pbpaste | grep "keyword" | pbcopy

# 查看剪贴板内容的十六进制表示
pbpaste | xxd

# 指定使用 find 剪贴板
echo "search term" | pbcopy -pboard find
pbpaste -pboard find
```

## 限制和注意事项

1. 如 man 页面的 BUGS 部分所述，`pbpaste` 没有办法只获取特定数据类型而忽略其他类型。它总是会在找不到首选类型时尝试其他类型。

2. 这些命令只能访问当前的剪贴板内容，不能访问剪贴板历史记录（因为 macOS 默认不维护剪贴板历史）。

3. 对于非文本数据（如图像），这些命令的处理能力有限。

## 与其他系统的对比

- **Linux**：类似功能通常由 `xclip` 或 `xsel` 提供
- **Windows**：PowerShell 中有 `Get-Clipboard` 和 `Set-Clipboard` cmdlet

## 开发相关

man 页面提到了几个开发参考资源，这些资源对于想要在应用程序中实现剪贴板功能的开发者很有用：

- Cocoa 框架中的 Interapplication Communication 部分
- Carbon 框架中的 Pasteboard Manager Programming Guide 和 Reference

这些资源详细介绍了 macOS 中剪贴板系统的底层实现和编程接口。

通过 pbcopy 和 pbpaste 命令，macOS 为用户提供了一种简单而强大的方式来在命令行和图形界面应用程序之间传输数据，大大提高了工作效率。
