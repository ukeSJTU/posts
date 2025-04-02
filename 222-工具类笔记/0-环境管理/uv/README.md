---
tags: ["python"]
---

```bash
tldr uv

uv

A fast Python package and project manager.
Some subcommands such as `tool` and `python` have their own usage documentation.
More information: <https://docs.astral.sh/uv/reference/cli>.

- Create a new Python project in the current directory:
    uv init

- Create a new Python project at the specified path:
    uv init path/to/directory

- Add a new dependency to the project:
    uv add package

- Remove a dependency from the project:
    uv remove package

- Run a script in the project's environment:
    uv run path/to/script.py

- Run a command in the project's environment:
    uv run command

- Update a project's environment from `pyproject.toml`:
    uv sync

- Create a lock file for the project's dependencies:
    uv lock

```

installation:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

Or on windows

```pwsh
powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
```

可以通过`--help`来获取帮助：

```bash
uv --help
uv init --help
```

也可以`help`子命令来察看更加详细的帮助：这个会尝试用`less`或者`more`

```bash
uv help
uv help init
```

---

Guides overview
Check out one of the core guides to get started:

Installing Python versions
Running scripts and declaring dependencies
Running and installing applications as tools
Creating and working on projects
Building and publishing packages
Integrate uv with other software, e.g., Docker, GitHub, PyTorch, and more

---

Concepts overview
Read the concept documents to learn more about uv's features:

Projects
Tools
Python versions
Resolution
Caching
