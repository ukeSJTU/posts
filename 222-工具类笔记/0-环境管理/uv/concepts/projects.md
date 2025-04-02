# Concepts of Projects in UV

Projects help manage Python code spanning multiple files.

## Understanding project structure and files

原文链接：https://docs.astral.sh/uv/concepts/projects/layout/

uv 管理 project 的核心就是`pyproject.toml`, `.venv/`和`uv.lock`这三个文件。

### The `pyproject.toml`

必须要包含的内容：

```toml
[project]
name = "example"
version = "0.1.0"
```

这里讲的比较少，官方的指导链接：https://packaging.python.org/en/latest/guides/writing-pyproject-toml/

本文后续的[[#Configuring the project for advanced use cases]]也会再讲解更多 project metadata。

考虑到 pyproject.toml 文件并不是独属于 uv，别的环境管理工具也会用到，所以我有整理自己的笔记[[pyproject]]

### The project environment

When working on a project with uv, uv will create a virtual environment as needed. While some uv commands will create a temporary environment (e.g., uv run --isolated), uv also manages a persistent environment with the project and its dependencies in a .venv directory next to the pyproject.toml. It is stored inside the project to make it easy for editors to find — they need the environment to give code completions and type hints. It is not recommended to include the .venv directory in version control; it is automatically excluded from git with an internal .gitignore file.

To run a command in the project environment, use uv run. Alternatively the project environment can be activated as normal for a virtual environment.

When uv run is invoked, it will create the project environment if it does not exist yet or ensure it is up-to-date if it exists. The project environment can also be explicitly created with uv sync. See the locking and syncing documentation for details.

It is not recommended to modify the project environment manually, e.g., with uv pip install. For project dependencies, use uv add to add a package to the environment. For one-off requirements, use uvx or uv run --with.

TODO: 上面这一段话的核心就是说当我们在一个 uv 管理的 python project 里面。uv 还需要一个`.venv`来管理虚拟环境。有的命令会自动创建，比如说`uv add`但是`uv run --isolated`就不会。

### The lockfile

uv.lock is a universal or cross-platform lockfile that captures the packages that would be installed across all possible Python markers such as operating system, architecture, and Python version.

The lockfile is [automatically created and updated](https://docs.astral.sh/uv/concepts/projects/sync/#automatic-lock-and-sync) during uv invocations that use the project environment, i.e., uv sync and uv run. The lockfile may also be explicitly updated using uv lock.

uv.lock is a human-readable TOML file but is managed by uv and should not be edited manually. There is no Python standard for lockfiles at this time, so the format of this file is specific to uv and not usable by other tools.

## Creating new projects

`uv init`创建一个新的 python project。

可以通过`--app/--lib`指定项目类型，`--app`是默认的选项。[App](#applications), [lib](#libraries)

### Target directory

```bash
mkdir project_dir && cd project_dir && uv init

uv init project_dir
```

### Applications

Application projects are suitable for web servers, scripts, and command-line interfaces.

> Prior to v0.6.0, uv created a file named hello.py instead of main.py.

### Packaged applications

Many use-cases require a [package](#project-packaging). For example, if you are creating a command-line interface that will be published to PyPI or if you want to define tests in a dedicated directory.

The --package flag can be used to create a packaged application:

```bash
uv init --package example-pkg
```

```bash
$ tree example-pkg
example-pkg
├── README.md
├── pyproject.toml
└── src
    └── example_pkg
        └── __init__.py
```

A [build system](#build-systems) is defined, so the project will be installed into the environment:

```toml
[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"
```

> The --build-backend option can be used to request an alternative build system.

A [command](#entry-points) definition is included:

```toml
[project.scripts]
example-pkg = "example_pkg:main"
```

can be executed with uv run:

```bash
cd example-pkg
uv run example-pkg
```

### Libraries

`--lib` option

A library provides functions and objects for other projects to consume. Libraries are intended to be built and distributed, e.g., by uploading them to PyPI.

> Using --lib implies --package. Libraries always require a packaged project.

As with a [packaged application](#packaged-applications), a src layout is used. A py.typed marker is included to indicate to consumers that types can be read from the library:

TODO: 不懂这个 py.typed 文件干什么的，默认似乎是空的

```bash
tree example-lib
example-lib
├── README.md
├── pyproject.toml
└── src
    └── example_lib
        ├── __init__.py
        └── py.typed
```

> A src layout is particularly valuable when developing libraries. It ensures that the library is isolated from any python invocations in the project root and that distributed library code is well separated from the rest of the project source.

TODO: 这个我也不知道什么意思，isolate 什么东西。

You can select a different build backend template by using --build-backend with hatchling, flit-core, pdm-backend, setuptools, maturin, or scikit-build-core.

An alternative backend is required if you want to create a [library with extension modules](#projects-with-extension-modules).

自带一个`__init__.py`:

```python
def hello() -> str:
    return "Hello from example-lib!"
```

can import and execute it using uv run:

```bash
cd example-lib
uv run python -c "import example_lib; print(example_lib.hello())"
```

### Projects with extension modules

TODO: 暂时还没有用到，先不管。主要内容就是说如果 python project 要用到其他语言（比如 Rust， C++等等）编写的 modules，就需要用其他的 build-backend，原文链接：https://docs.astral.sh/uv/concepts/projects/init/#projects-with-extension-modules

### Creating a minimal project

`--bare`选项可以只创建`pyproject.toml`文件。

这个好像是比较新版本的 uv 添加的功能。

When --bare is used, additional features can still be used opt-in:

```bash
uv init example --bare --description "Hello world" --author-from git --vcs git --python-pin
```

## Managing project dependencies

### Dependency fields

Dependencies of the project are defined in several fields:

[project.dependencies](#project-dependencies): Published dependencies.
[project.optional-dependencies](#optional-dependencies): Published optional dependencies, or "extras".
[dependency-groups](#dependency-groups): Local dependencies for development.
[tool.uv.sources](#dependency-sources): Alternative sources for dependencies during development.

> The project.dependencies and project.optional-dependencies fields can be used even if project isn't going to be published. dependency-groups are a recently standardized feature and may not be supported by all tools yet.

uv supports modifying the project's dependencies with uv add and uv remove, but dependency metadata can also be updated by editing the pyproject.toml directly.

### Adding dependencies

#### Importing dependencies

### Removing dependencies

### Changing dependencies

### Platform-specific dependencies

### Project dependencies

### Dependency sources

#### Index

#### Git

#### URL

#### Path

#### Workspace member

#### Plaform-specific sources

#### Multiple sources

#### Disabling sources

### Optional dependencies

### Development dependencies

#### Dependency groups

#### Default groups

#### Legacy dev-dependencies

### Build dependencies

### Editable dependencies

### Dependency specifiers (PEP 508)

## Running commands and scripts in a project

## Using lockfiles and syncing the environment

## Configuring the project for advanced use cases

### Entry points

#### Command-line interfaces

#### Graphical user interfaces

#### Plugin entry points

### Build systems

#### Build system options

### Project packaging

## Building distributions to publish a project

## Using workspaces to work on multiple projects at once
