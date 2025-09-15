Write Yourself a Git

A git repository is made of two things: a “work tree”, where the files meant to be in version control live, and a “git directory”, where Git stores its own data. In most cases, the worktree is a regular directory and the git directory is a child directory of the worktree, called `.git`.

这段话解释了Git仓库的基本结构，包含两个核心组成部分：

## Git仓库的两个组成部分：

### 1. **工作树（Work Tree）**

- 这是存放你实际编辑和操作文件的地方
- 包含了所有需要进行版本控制的文件
- 就是你平时看到和修改的项目文件夹

### 2. **Git目录（Git Directory）**

- 这是Git存储自己数据的地方
- 包含了版本历史、分支信息、配置等Git的内部数据
- 通常是一个名为`.git`的隐藏文件夹

## 典型的结构：

```
我的项目/              ← 工作树（Work Tree）
├── src/
├── README.md
├── package.json
└── .git/             ← Git目录（Git Directory）
    ├── objects/
    ├── refs/
    ├── config
    └── ...
```

简单来说，**工作树**是你看得见、能编辑的文件，**Git目录**是Git在幕后管理版本控制信息的地方。大多数情况下，`.git`文件夹就在你的项目根目录下。

---

> Git supports *much more* cases (bare repo, separated gitdir, etc) but we won’t need them: we’ll stick to the basic approach of `worktree/.git`. Our repository object will then just hold two paths: the worktree and the gitdir.

---

GitRepository类

- .git/objects/: **对象存储库**。Git 的核心所在。你提交的每个文件、每个目录结构、每个提交记录，都会被压缩成一个“对象”存储在这里。
- .git/refs/: **引用存储库**。它存储了指向特定提交对象的“指针”。
  - refs/heads/: 存放分支的引用。例如，refs/heads/master 文件会包含 master 分支最新一次提交的 SHA-1 哈希值。
  - refs/tags/: 存放标签的引用。
- .git/HEAD: 一个特殊的文件，它通常指向你当前所在的分支。初始内容是 ref: refs/heads/master，表示 HEAD 指向 master 分支。
- .git/config: 仓库级别的配置文件。
- .git/description: 仓库的描述文件，主要给 GitWeb 等工具使用。
