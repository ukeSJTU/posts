# ns-3

## ToC

01-Getting Started: 包括安装，编译，运行 ns-3 的例子
02-Conveptual Overview: 了解 ns-3 中的概念，通过一个实力程序学习 ns-3 的基本内容，如何查看 ns-3 的文档等等。
03-Tweaking：logging/cli/tracing
04-Building Topologies: xxx
05-Tracing: xxx
06-Data Collection: xxx

> ns-3 是一个网络模拟软件，在安装完成后，我们需要编写脚本来配置模拟的环境以及测试参数等等。这个脚本可以是 C++或者 Python，可能有少部分功能是仅 C++的，所以如果为了保证各个平台均可用，后续脚本最好用 C++编写；如果为了方便，想用 python 也可以。

按照 ns-3 官方文档：Due to an upstream limitation with Cppyy, Python bindings do not work on macOS machines with Apple silicon (M1 and M2 processors). 但是我这里尝试了一下发现是(m2)可以用 Python 的，所以如果你想要用 python，那你就需要添加`--enable-python-bindings`这个选项，然后像下面这个样子创建一个本地的虚拟环境。当然如果你不需要 python 就不需要这一步。

python:

```bash

```

如果你和我一样用 vscode+pylance，你会发现 vscode 提示 Cannotresolve module ns。这是因为 ns-3 的 python 绑定是在运行时通过 cppyy 动态生成的，而 pylance 静态分析的话是无法找到的。我们可以通过给.vscode/settings.json 添加下面的内容来让 vscode 找到这个 ns 模块（但是没有办法提供语法高亮或者 auto completion）

```json
"python.defaultInterpreterPath": "/Volumes/External/ns-3-dev/.venv/bin/python",
  "python.envFile": "${workspaceFolder}/.env",
  "terminal.integrated.env.osx": {
    "PYTHONPATH": "/Volumes/External/ns-3-dev/build/bindings/python:${env:PYTHONPATH}",
    "LD_LIBRARY_PATH": "/Volumes/External/ns-3-dev/build/lib:${env:LD_LIBRARY_PATH}"
  },
```

然后在项目根目录下添加`.env`文件，内容：

```plaintext
PYTHONPATH=/Volumes/External/ns-3-dev/build/bindings/python:${PYTHONPATH}
LD_LIBRARY_PATH=/Volumes/External/ns-3-dev/build/lib:${LD_LIBRARY_PATH}
```

TODO:以上配置应该隐藏掉真实目录
