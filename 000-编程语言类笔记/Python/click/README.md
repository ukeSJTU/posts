# 什么是 click

可以用来创建命令行界面的 Python 库。

# 为什么用 click

## 为什么不用 argparse

argparse 是 Python 自带的命令行解析库，功能强大，但使用起来比较繁琐。click 则是一个更轻量级的库，使用起来更加简单和直观。

官方文档https://click.palletsprojects.com/en/stable/why/#why-not-argparse这样说：

Click is internally based on optparse instead of argparse. This is an implementation detail that a user does not have to be concerned with. Click is not based on argparse because it has some behaviors that make handling arbitrary command line interfaces hard:

argparse has built-in behavior to guess if something is an argument or an option. This becomes a problem when dealing with incomplete command lines; the behaviour becomes unpredictable without full knowledge of a command line. This goes against Click’s ambitions of dispatching to subparsers.

argparse does not support disabling interspersed arguments. Without this feature, it’s not possible to safely implement Click’s nested parsing.

# 内容大纲

我们先简单学习 click 的最基础使用，然后我觉得三个核心概念：

1. commands and groups
2. params-options
3. params-arguments

这三个概念是 click 的核心，掌握了这三个概念，就可以用 click 写出复杂的命令行工具了。

然后 quick start 部分还说了一些 examples 放在最后学习。

# click 基础使用

这一部分基本对应官方文档的 quick-start 部分https://click.palletsprojects.com/en/stable/quickstart/#quickstart

Click is based on declaring commands through decorators.

A function becomes a Click command line tool by decorating it through [`click.command()`](https://click.palletsprojects.com/en/stable/api/#click.command).

```python
import click


@click.command()
def hello():
    click.echo("Hello World!")


if __name__ == "__main__":
    hello()
```

echo 比起 print 可以保证跨平台输出内容一致性。

TODO：看这里：https://click.palletsprojects.com/en/stable/utils/

## Nesting Commands

click 可以通过嵌套命令来组织复杂的命令行工具。

两种写法：

1. 通过 `@click.group()` 装饰器来定义一个命令组，然后在组下定义子命令。

```python
@click.group()
def cli():
    pass

@click.command()
def initdb():
    click.echo('Initialized the database')

@click.command()
def dropdb():
    click.echo('Dropped the database')

cli.add_command(initdb)
cli.add_command(dropdb)
```

或者

```python
@click.group()
def cli():
    pass

@cli.command()
def initdb():
    click.echo('Initialized the database')

@cli.command()
def dropdb():
    click.echo('Dropped the database')

if __name__ == '__main__':
    cli()
```

后者更加简洁。但是前者的好处是可以在一个文件中定义这个 Command，然后在另一个文件里面将它作为 subcommand 添加到 另一个 Command 里面。官网这里https://click.palletsprojects.com/en/stable/quickstart/#registering-commands-later这么说：Instead of using the @group.command() decorator, commands can be decorated with the plain @click.command() decorator and registered with a group later with group.add_command(). This could be used to split commands into multiple Python modules.

## Adding parameters

To add parameters, use the option() and argument() decorators:

```python
@click.command()
@click.option('--count', default=1, help='number of greetings')
@click.argument('name')
def hello(count, name):
    for x in range(count):
        click.echo(f"Hello {name}!")
```

```bash
$ python hello.py --help
Usage: hello.py [OPTIONS] NAME

Options:
  --count INTEGER  number of greetings
  --help           Show this message and exit.
```

## 通过 setuptools 来设置入口

这个留到最后，因为目前可以通过 python 直接运行。后续还要补充 pyproject.toml 的内容。
