本篇文章主要记录在实际使用过程中对 vscode 的设置，插件，以及一些使用技巧。

# 新建嵌套文件（夹）

第一个，新建文件的时候如果文件名包含`/`，则会自动帮你新建文件夹以及文件。例如在工作区根目录下选择新建文件，文件名`foo/bar.cpp`，回车确认。会得到一个新的文件夹`foo`以及里面一个文件`bar.cpp`:

```plaintext
.
└── foo
    └── bar.cpp
```

# 打开 terminal

快捷键：`ctrl+j`或者`command+j`

# vscode welcome page

我本来想要自定义 welcome page 但是好像截止 1.96.0 还没有这种功能，但是找到个更有用的设置：
"workbench.startupEditor": "readme" 这样每次打开一个项目文件就会直接看到 README 的预览，很类似 github。

参考链接：[stackoverflow 答案](https://stackoverflow.com/questions/66741296/customize-visual-studio-code-landing-page)

# vscode 自动切换深色/浅色主题

打开下面这个设置

```json
"window.autoDetectColorScheme": true
```

然后分别设置默认的深色/浅色主题就可以了，我这里安装了`monokai`的插件：

```json
"workbench.preferredDarkColorTheme": "Monokai Pro""workbench.preferredLightColorTheme": "Monokai Pro Light (Filter Sun)"
```

# 复制相对路径保持 linux 风格

也就是在 windows 平台上当我们从 file explorer 中复制文件相对路径的时候，我们希望分隔符默认和 linux/macOS 一样是`/`而不是`\`

```json
"explorer.copyRelativePathSeparator": "/"
```

# svg 文件打开直接预览

Go to Settings
Search for: workbench.editorAssociations
Click Add Item:

Key: `*.svg`
Value: `default`

参考[reddit 讨论](https://www.reddit.com/r/vscode/comments/1ibntfy/svg_files_open_as_previews_i_want_them_to_open_as/)
