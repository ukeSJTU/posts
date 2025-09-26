## 3. Creating repositories: init

Obviously, the first Git command in chronological _and_ logical order is `git init`, so we’ll begin by creating `wyag init`. To achieve this, we’re going to first need some very basic repository abstraction.

### 3.1. The Repository object

We’ll obviously need some abstraction for a repository: almost every time we run a git command, we’re trying to do something to a repository, to create it, read from it or modify it.

A git repository is made of two things: a “work tree”, where the files meant to be in version control live, and a “git directory”, where Git stores its own data. In most cases, the worktree is a regular directory and the git directory is a child directory of the worktree, called `.git`.

Git supports _much more_ cases (bare repo, separated gitdir, etc) but we won’t need them: we’ll stick to the basic approach of `worktree/.git`. Our repository object will then just hold two paths: the worktree and the gitdir.

To create a new `Repository` object, we only need to make a few checks:

- We must verify that the directory exists, and contains a subdirectory called `.git`.
- We then read its configuration in `.git/config` (it’s just an INI file) and check that `core.repositoryformatversion` is 0. More on that field in a moment.

Our constructor takes an optional `force` argument which disables all checks. That’s because the `repo_create()` function which we’ll create later will use a `Repository` object to _create_ the repo. So we need a way to create such objects even from (still) invalid filesystem locations.

```python
class GitRepository (object):
    """A git repository"""

    worktree = None
    gitdir = None
    conf = None

    def __init__(self, path, force=False):
        self.worktree = path
        self.gitdir = os.path.join(path, ".git")

        if not (force or os.path.isdir(self.gitdir)):
            raise Exception(f"Not a Git repository {path}")

        # Read configuration file in .git/config
        self.conf = configparser.ConfigParser()
        cf = repo_file(self, "config")

        if cf and os.path.exists(cf):
            self.conf.read([cf])
        elif not force:
            raise Exception("Configuration file missing")

        if not force:
            vers = int(self.conf.get("core", "repositoryformatversion"))
            if vers != 0:
                raise Exception("Unsupported repositoryformatversion: {vers}")
```

We’re going to be manipulating **lots** of paths in repositories. We may as well create a few utility functions to compute those paths and create missing directory structures if needed. First, just a general path building function:

```python
def repo_path(repo, *path):
    """Compute path under repo's gitdir."""
    return os.path.join(repo.gitdir, *path)
```

(A note on Python syntax: the star on the `*path` makes the function variadic, so it can be called with multiple path components as separate arguments. For example, `repo_path(repo, "objects", "df", "4ec9fc2ad990cb9da906a95a6eda6627d7b7b0")` is a valid call. The function receives `path` as a list)

The next two functions, `repo_file()` and `repo_dir()`, return and optionally create a path to a file or a directory, respectively. The difference between them is that the file version only creates directories up to the last component.

```python
def repo_file(repo, *path, mkdir=False):
    """Same as repo_path, but create dirname(*path) if absent.  For
example, repo_file(r, "refs", "remotes", "origin", "HEAD") will create
.git/refs/remotes/origin."""

    if repo_dir(repo, *path[:-1], mkdir=mkdir):
        return repo_path(repo, *path)
```

```python
def repo_dir(repo, *path, mkdir=False):
    """Same as repo_path, but mkdir *path if absent if mkdir."""

    path = repo_path(repo, *path)

    if os.path.exists(path):
        if (os.path.isdir(path)):
            return path
        else:
            raise Exception(f"Not a directory {path}")

    if mkdir:
        os.makedirs(path)
        return path
    else:
        return None
```

(Second and last note on syntax: because the star in `*path` makes the functions variadic, the `mkdir` argument must be passed explicitly by name. For example, `repo_file(repo, "objects", mkdir=True)`.)

To **create** a new repository, we start with a directory (which we create if doesn’t already exist) and create the **git directory** inside (which must not exist already, or be empty). That directory is called `.git` (the leading period makes it “hidden” on Unix systems), and contains:

- `.git/objects/` : the object store, which we’ll introduce [in the next section](#objects).
- `.git/refs/` the reference store, which we’ll discuss [a bit later](#cmd-show-ref). It contains two subdirectories, `heads` and `tags`.
- `.git/HEAD`, a reference to the current HEAD (more on that later!)
- `.git/config`, the repository’s configuration file.
- `.git/description`, holds a free-form description of this repository’s contents, for humans, and is rarely used.

```python
def repo_create(path):
    """Create a new repository at path."""

    repo = GitRepository(path, True)

    # First, we make sure the path either doesn't exist or is an
    # empty dir.

    if os.path.exists(repo.worktree):
        if not os.path.isdir(repo.worktree):
            raise Exception (f"{path} is not a directory!")
        if os.path.exists(repo.gitdir) and os.listdir(repo.gitdir):
            raise Exception (f"{path} is not empty!")
    else:
        os.makedirs(repo.worktree)

    assert repo_dir(repo, "branches", mkdir=True)
    assert repo_dir(repo, "objects", mkdir=True)
    assert repo_dir(repo, "refs", "tags", mkdir=True)
    assert repo_dir(repo, "refs", "heads", mkdir=True)

    # .git/description
    with open(repo_file(repo, "description"), "w") as f:
        f.write("Unnamed repository; edit this file 'description' to name the repository.\n")

    # .git/HEAD
    with open(repo_file(repo, "HEAD"), "w") as f:
        f.write("ref: refs/heads/master\n")

    with open(repo_file(repo, "config"), "w") as f:
        config = repo_default_config()
        config.write(f)

    return repo
```

The configuration file is very simple, it’s a [INI](https://en.wikipedia.org/wiki/INI_file)-like file with a single section (`[core]`) and three fields:

- `repositoryformatversion = 0`: the version of the gitdir format. 0 means the initial format, 1 the same with extensions. If > 1, git will panic; wyag will only accept 0.
- `filemode = false`: disable tracking of file modes (permissions) changes in the work tree.
- `bare = false`: indicates that this repository has a worktree. Git supports an optional `worktree` key which indicates the location of the worktree, if not `..`; wyag doesn’t.

We create this file using Python’s `configparser` lib:

```python
def repo_default_config():
    ret = configparser.ConfigParser()

    ret.add_section("core")
    ret.set("core", "repositoryformatversion", "0")
    ret.set("core", "filemode", "false")
    ret.set("core", "bare", "false")

    return ret
```

### 3.2. The init command

Now that we have code to read and create repositories, let’s make this code usable from the command line by creating the `wyag init` command. `wyag init` behaves just like `git init` — with much less customizability, of course. The syntax of `wyag init` is going to be:

```
wyag init [path]
```

We already have the complete repository creation logic. To create the command, we’re only going to need two more things:

1.  We need to create an argparse subparser to handle our command’s argument.

    ```python
    argsp = argsubparsers.add_parser("init", help="Initialize a new, empty repository.")
    ```

    In the case of `init`, there’s a single, optional, positional argument: the path where to init the repo. It defaults to `.`, the current directory:

    ```python
    argsp.add_argument("path",
                       metavar="directory",
                       nargs="?",
                       default=".",
                       help="Where to create the repository.")
    ```

2.  We also need a “bridge” function that will read argument values from the object returned by argparse and call the actual function with correct values.

    ```python
    def cmd_init(args):
        repo_create(args.path)
    ```

And we’re done! If you’ve followed these steps, you should now be able to `wyag init` a git repository anywhere:

```
$ wyag init test
```

(The `wyag` executable won’t usually be in your `$PATH`: you’ll want to call it by its full name, eg `~/projects/wyag/wyag init .`)

### 3.3. The repo_find() function

While we’re implementing repositories, we’re going to need a function to find the root of the current repository. We’ll use it a lot, since almost all Git functions work on an existing repository (except `init`, of course!). Sometimes that root is the current directory, but it may also be a parent: your repository’s root may be in `~/Documents/MyProject`, but you may currently be working in `~/Documents/MyProject/src/tui/frames/mainview/`. The `repo_find()` function we’ll now create will look for that root, starting at the current directory and recursing back to `/`. To identify a path as a repository, it will check for the presence of a `.git` directory.

```python
def repo_find(path=".", required=True):
    path = os.path.realpath(path)

    if os.path.isdir(os.path.join(path, ".git")):
        return GitRepository(path)

    # If we haven't returned, recurse in parent, if w
    parent = os.path.realpath(os.path.join(path, ".."))

    if parent == path:
        # Bottom case
        # os.path.join("/", "..") == "/":
        # If parent==path, then path is root.
        if required:
            raise Exception("No git directory.")
        else:
            return None

    # Recursive case
    return repo_find(parent, required)
```

And we’re done with repositories!
