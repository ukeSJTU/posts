本篇文章主要记录在实际使用过程中对vscode的设置，插件，以及一些使用技巧。

# 新建嵌套文件（夹）
第一个，新建文件的时候如果文件名包含`/`，则会自动帮你新建文件夹以及文件。例如在工作区根目录下选择新建文件，文件名`foo/bar.cpp`，回车确认。会得到一个新的文件夹`foo`以及里面一个文件`bar.cpp`:

``` plaintext
.
└── foo
    └── bar.cpp
```

# 打开terminal
快捷键：`ctrl+j`或者`command+j`


# vscode welcome page
我本来想要自定义welcome page但是好像截止1.96.0还没有这种功能，但是找到个更有用的设置：
"workbench.startupEditor": "readme" 这样每次打开一个项目文件就会直接看到README的预览，很类似github。

参考链接：[stackoverflow答案](https://stackoverflow.com/questions/66741296/customize-visual-studio-code-landing-page)

# vscode 自动切换深色/浅色主题
打开下面这个设置
```json
"window.autoDetectColorScheme": true
```
然后分别设置默认的深色/浅色主题就可以了，我这里安装了`monokai`的插件：
```json
"workbench.preferredDarkColorTheme": "Monokai Pro""workbench.preferredLightColorTheme": "Monokai Pro Light (Filter Sun)"
```

# 复制相对路径保持linux风格
也就是在windows平台上当我们从file explorer中复制文件相对路径的时候，我们希望分隔符默认和linux/macOS一样是`/`而不是`\`
```json
"explorer.copyRelativePathSeparator": "/"
```
# ?
