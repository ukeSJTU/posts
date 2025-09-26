## 8. Working with the staging area and the index file

### 8.1. What’s the index file?

This final step will bring us to where commits happen (although actually creating them is for the next section!)

You probably know that to commit in Git, you first “stage” some changes, using `git add` and `git rm`, and only _then_ do you commit those changes. This intermediate stage between the last and the next commit is called the **staging area**.

It would seem natural to use a commit or tree object to represent the staging area, but Git actually and uses a completely different mechanism, in the form of what it calls the **index file**.

After a commit, the index file is a sort of copy of that commit: it holds the same path/blob association than the corresponding tree. But it also holds extra information about files in the worktree, like their creation/modification time, so `git status` doesn’t often need to actually compare files: it just checks that their modification time is the same as the one stored in the index file, and only if it isn’t does it perform an actual comparison.

You can thus consider the index file as a three-way association list: not only paths with blobs, but also paths with actual filesystem entries.

Another important characteristic of the **index file** is that unlike a tree, it can represent inconsistent states, like a merge conflict, whereas a tree is always a complete, unambiguous representation.

When you commit, what git actually does is turn the index file into a new tree object. To summarize:

1.  When the repository is “clean”, the index file holds the exact same contents as the HEAD commit, plus metadata about the corresponding filesystem entries. For instance, it may contain something like:

    > There’s a file called `src/disp.c` whose contents are blob 797441c76e59e28794458b39b0f1eff4c85f4fa0. The real `src/disp.c` file, in the worktree, was created on 2023-07-15 15:28:29.168572151, and last modified 2023-07-15 15:28:29.1689427709. It is stored on device 65026, inode 8922881.

2.  When you `git add` or `git rm`, the index file is modified accordingly. In the example above, if you modify `src/disp.c`, and `add` your changes, the index file will be updated with a new blob ID (the blob itself will also be created in the process, of course), and the various file metadata will be updated as well so `git status` knows when not to compare file contents.
3.  When you `git commit` those changes, a new tree is produced from the index file, a new commit object is generated with that tree, branches are updated and we’re done.

Note

**A note on words**

The staging area and the index are thus the same thing, but the name “staging area” is more the name of the git user-exposed feature (that could have been implemented otherwise), the abstraction if you will; while “index file” refers specifically to the way this abstract feature is actually implemented in git.

### 8.2. Parsing the index

The index file is by far the most complicated piece of data a Git repository can hold. Its complete documentation can be found in Git source tree or rendered [on the git website](https://git-scm.com/docs/index-format). It’s made of three parts:

- An header with the format version number and the number of entries the index holds;
- A series of entries, sorted, each representing a file; padded to multiple of 8 bytes.
- A series of optional extensions, which we’ll ignore.

The first thing we need to represent is a single entry. It actually holds quite a lot of stuff, I’m leaving the details in comments. It’s worth observing that an entry stores **both** the SHA-1 of the associated blob in the object store _and_ a ton of metadata about the actual file on the actual filesystem. Again, this is because `git/wyag status` will need to determine which files in the index were modified: it is much more efficient to begin by checking the last-modified timestamp and comparing it with a known values, before comparing actual files.

```python
class GitIndexEntry (object):
    def __init__(self, ctime=None, mtime=None, dev=None, ino=None,
                 mode_type=None, mode_perms=None, uid=None, gid=None,
                 fsize=None, sha=None, flag_assume_valid=None,
                 flag_stage=None, name=None):
        # The last time a file's metadata changed.  This is a pair
        # (timestamp in seconds, nanoseconds)
        self.ctime = ctime
        # The last time a file's data changed.  This is a pair
        # (timestamp in seconds, nanoseconds)
        self.mtime = mtime
        # The ID of device containing this file
        self.dev = dev
        # The file's inode number
        self.ino = ino
        # The object type, either b1000 (regular), b1010 (symlink),
        # b1110 (gitlink).
        self.mode_type = mode_type
        # The object permissions, an integer.
        self.mode_perms = mode_perms
        # User ID of owner
        self.uid = uid
        # Group ID of ownner
        self.gid = gid
        # Size of this object, in bytes
        self.fsize = fsize
        # The object's SHA
        self.sha = sha
        self.flag_assume_valid = flag_assume_valid
        self.flag_stage = flag_stage
        # Name of the object (full path this time!)
        self.name = name
```

The index file is a binary file, likely for performance reasons. The format is reasonably simple, though. It begins with a header with the `DIRC` magic bytes, a version number and the total number of entries in that index file. We create the `GitIndex` class to hold them:

```python
class GitIndex (object):
    version = None
    entries = []
    # ext = None
    # sha = None

    def __init__(self, version=2, entries=None):
        if not entries:
            entries = list()

        self.version = version
        self.entries = entries
```

And a parser to read index files into those objects. After reading the 12-bytes header, we just parse entries in the order they appear. An entry begins with a set of fixed-length data, followed by a variable-length name.

The code is quite straightforward, but as it’s reading a binary format, it feels more messy than what we did so far. We use the `int.from_bytes(bytes, endianness)` a lot to read raw bytes into an integer, and just a few bitwise operations to separate data that share the same byte.

(This format was probably designed so index files could just be `mmapp()`ed to memory, and read directly as C structs, with an index built in O(n) time in most cases. This kind of approach tends to produce more elegant code in C than in Python…)

```python
def index_read(repo):
    index_file = repo_file(repo, "index")

    # New repositories have no index!
    if not os.path.exists(index_file):
        return GitIndex()

    with open(index_file, 'rb') as f:
        raw = f.read()

    header = raw[:12]
    signature = header[:4]
    assert signature == b"DIRC" # Stands for "DirCache"
    version = int.from_bytes(header[4:8], "big")
    assert version == 2, "wyag only supports index file version 2"
    count = int.from_bytes(header[8:12], "big")

    entries = list()

    content = raw[12:]
    idx = 0
    for i in range(0, count):
        # Read creation time, as a unix timestamp (seconds since
        # 1970-01-01 00:00:00, the "epoch")
        ctime_s =  int.from_bytes(content[idx: idx+4], "big")
        # Read creation time, as nanoseconds after that timestamps,
        # for extra precision.
        ctime_ns = int.from_bytes(content[idx+4: idx+8], "big")
        # Same for modification time: first seconds from epoch.
        mtime_s = int.from_bytes(content[idx+8: idx+12], "big")
        # Then extra nanoseconds
        mtime_ns = int.from_bytes(content[idx+12: idx+16], "big")
        # Device ID
        dev = int.from_bytes(content[idx+16: idx+20], "big")
        # Inode
        ino = int.from_bytes(content[idx+20: idx+24], "big")
        # Ignored.
        unused = int.from_bytes(content[idx+24: idx+26], "big")
        assert 0 == unused
        mode = int.from_bytes(content[idx+26: idx+28], "big")
        mode_type = mode >> 12
        assert mode_type in [0b1000, 0b1010, 0b1110]
        mode_perms = mode & 0b0000000111111111
        # User ID
        uid = int.from_bytes(content[idx+28: idx+32], "big")
        # Group ID
        gid = int.from_bytes(content[idx+32: idx+36], "big")
        # Size
        fsize = int.from_bytes(content[idx+36: idx+40], "big")
        # SHA (object ID).  We'll store it as a lowercase hex string
        # for consistency.
        sha = format(int.from_bytes(content[idx+40: idx+60], "big"), "040x")
        # Flags we're going to ignore
        flags = int.from_bytes(content[idx+60: idx+62], "big")
        # Parse flags
        flag_assume_valid = (flags & 0b1000000000000000) != 0
        flag_extended = (flags & 0b0100000000000000) != 0
        assert not flag_extended
        flag_stage =  flags & 0b0011000000000000
        # Length of the name.  This is stored on 12 bits, some max
        # value is 0xFFF, 4095.  Since names can occasionally go
        # beyond that length, git treats 0xFFF as meaning at least
        # 0xFFF, and looks for the final 0x00 to find the end of the
        # name --- at a small, and probably very rare, performance
        # cost.
        name_length = flags & 0b0000111111111111

        # We've read 62 bytes so far.
        idx += 62

        if name_length < 0xFFF:
            assert content[idx + name_length] == 0x00
            raw_name = content[idx:idx+name_length]
            idx += name_length + 1
        else:
            print(f"Notice: Name is 0x{name_length:X} bytes long.")
            # This probably wasn't tested enough.  It works with a
            # path of exactly 0xFFF bytes.  Any extra bytes broke
            # something between git, my shell and my filesystem.
            null_idx = content.find(b'\x00', idx + 0xFFF)
            raw_name = content[idx: null_idx]
            idx = null_idx + 1

        # Just parse the name as utf8.
        name = raw_name.decode("utf8")

        # Data is padded on multiples of eight bytes for pointer
        # alignment, so we skip as many bytes as we need for the next
        # read to start at the right position.

        idx = 8 * ceil(idx / 8)

        # And we add this entry to our list.
        entries.append(GitIndexEntry(ctime=(ctime_s, ctime_ns),
                                     mtime=(mtime_s,  mtime_ns),
                                     dev=dev,
                                     ino=ino,
                                     mode_type=mode_type,
                                     mode_perms=mode_perms,
                                     uid=uid,
                                     gid=gid,
                                     fsize=fsize,
                                     sha=sha,
                                     flag_assume_valid=flag_assume_valid,
                                     flag_stage=flag_stage,
                                     name=name))

    return GitIndex(version=version, entries=entries)
```

### 8.3. The ls-files command

`git ls-files` displays the names of files in the staging area, with, as usual, a ton of options. Our `ls-files` will be much simpler, _but_ we’ll add a `--verbose` option that doesn’t exist in git, just so we can display every single bit of info in the index file.

```python
argsp = argsubparsers.add_parser("ls-files", help = "List all the stage files")
argsp.add_argument("--verbose", action="store_true", help="Show everything.")
```

```python
def cmd_ls_files(args):
    repo = repo_find()
    index = index_read(repo)
    if args.verbose:
        print(f"Index file format v{index.version}, containing {len(index.entries)} entries.")

    for e in index.entries:
        print(e.name)
        if args.verbose:
            entry_type = { 0b1000: "regular file",
                           0b1010: "symlink",
                           0b1110: "git link" }[e.mode_type]
            print(f"  {entry_type} with perms: {e.mode_perms:o}")
            print(f"  on blob: {e.sha}")
            print(f"  created: {datetime.fromtimestamp(e.ctime[0])}.{e.ctime[1]}, modified: {datetime.fromtimestamp(e.mtime[0])}.{e.mtime[1]}")
            print(f"  device: {e.dev}, inode: {e.ino}")
            print(f"  user: {pwd.getpwuid(e.uid).pw_name} ({e.uid})  group: {grp.getgrgid(e.gid).gr_name} ({e.gid})")
            print(f"  flags: stage={e.flag_stage} assume_valid={e.flag_assume_valid}")
```

If you run ls-files, you’ll notice that on a “clean” worktree (an unmodified checkout of `HEAD`), it lists all files on `HEAD`. Again, the index is not a _delta_ (a set of differences) from the `HEAD` commit, but starts as a copy of it, in a different format.

### 8.4. A detour: the check-ignore command

We want to write `status`, but `status` needs to know about ignore rules, that are stored in the various `.gitignore` files. So we first need to add some rudimentary support for ignore files in `wyag`. We’ll expose this support as the `check-ignore` command, which takes a list of paths and outputs back those of those paths that should be ignored.

Again, the command parser is trivial:

```python
argsp = argsubparsers.add_parser("check-ignore", help = "Check path(s) against ignore rules.")
argsp.add_argument("path", nargs="+", help="Paths to check")
```

And the function is just as simple:

```python
def cmd_check_ignore(args):
    repo = repo_find()
    rules = gitignore_read(repo)
    for path in args.path:
        if check_ignore(rules, path):
            print(path)
```

But of course, most of the function we call don’t exist yet in wyag. We’ll begin by writing a reader for rules in ignore files, `gitignore_read()`. The syntax of those rules is quite simple: each line in an ignore file is an exclusion pattern, so files that match this pattern are ignored by `status`, `add -A` and so on. There are three special cases, though:

1.  Lines that begin with an exclamation mark `!` _negate_ the pattern (files that match this pattern are _included_, even they were ignored by an earlier pattern)
2.  Lines that begin with a dash `#` are comments, and are skipped.
3.  A backslash `\` at the beginning treats `!` and `#` as literal characters.

First, a parser for a single pattern. This parser returns a pair: the pattern itself, and a boolean to indicate if files matching the pattern _should_ be excluded (`True`) or included (`False`). In other words, `False` if the pattern did start with `!`, `True` otherwise.

```python
def gitignore_parse1(raw):
    raw = raw.strip() # Remove leading/trailing spaces

    if not raw or raw[0] == "#":
        return None
    elif raw[0] == "!":
        return (raw[1:], False)
    elif raw[0] == "\\":
        return (raw[1:], True)
    else:
        return (raw, True)
```

Parsing a file is just collecting all rules in that file. Notice this function doesn’t parse _files_, but just lists of lines: that’s because we’ll need to read rules from git blobs as well, and not just regular files.

```python
def gitignore_parse(lines):
    ret = list()

    for line in lines:
        parsed = gitignore_parse1(line)
        if parsed:
            ret.append(parsed)

    return ret
```

Last thing we need to do is collect the various ignore files. They come in two kinds:

- Some of these files **live in the index**: they’re the various `gitignore` files. Emphasis on the plural; although there often is only one such file, at the root, there can be one in each directory, and it applies to this directory and its subdirectories. I’ll call those **scoped**, because they only apply to paths under their directory.
- The others live **outside the index**. They’re the global ignore file (usually in `~/.config/git/ignore`) and the repository-specific `.git/info/exclude`. I call those **absolute**, because they apply everywhere, but at a lower priority.

Again, a class to hold that: a list of absolute rules, a dict (hashmap) of relative rules. The keys to this hashmap are **directories**, relative to the root of a worktree.

```python
class GitIgnore(object):
    absolute = None
    scoped = None

    def __init__(self, absolute, scoped):
        self.absolute = absolute
        self.scoped = scoped
```

And finally our function to collect all gitignore rules in a repository, and return a `GitIgnore` object. Notice how it reads scoped files from the index, and not the worktree: only _staged_ `.gitignore` files matter (also remember: HEAD is _already_ staged — the staging area is a copy, not a delta).

```python
def gitignore_read(repo):
    ret = GitIgnore(absolute=list(), scoped=dict())

    # Read local configuration in .git/info/exclude
    repo_file = os.path.join(repo.gitdir, "info/exclude")
    if os.path.exists(repo_file):
        with open(repo_file, "r") as f:
            ret.absolute.append(gitignore_parse(f.readlines()))

    # Global configuration
    if "XDG_CONFIG_HOME" in os.environ:
        config_home = os.environ["XDG_CONFIG_HOME"]
    else:
        config_home = os.path.expanduser("~/.config")
    global_file = os.path.join(config_home, "git/ignore")

    if os.path.exists(global_file):
        with open(global_file, "r") as f:
            ret.absolute.append(gitignore_parse(f.readlines()))

    # .gitignore files in the index
    index = index_read(repo)

    for entry in index.entries:
        if entry.name == ".gitignore" or entry.name.endswith("/.gitignore"):
            dir_name = os.path.dirname(entry.name)
            contents = object_read(repo, entry.sha)
            lines = contents.blobdata.decode("utf8").splitlines()
            ret.scoped[dir_name] = gitignore_parse(lines)
    return ret
```

We’re almost there. To tie everything together, we need the `check_ignore` function that matches a path, relative to the root of a worktree, against a set of rules. This is how this function will work:

- It will first try to match this path against the **scoped** rules. It will do this from the deepest parent of the path to the farthest. That is, if the path is `src/support/w32/legacy/sound.c~`, it will first look for rules in `src/support/w32/legacy/.gitignore`, then `src/support/w32/.gitignore`, `src/support/.gitignore`, and so on up to simply `.gitignore"` at the root.
- If nothing matches, it will continue with the **absolute** rules.

We write three small support functions. One to match a path against a set of rules, and return the result of the last matching rule. Notice how it’s not a real boolean functions, since it has **three** possible return values: `True`, `False` but also `None`. It returns `None` if nothing matched, so the caller knows it should continue trying with more general ignore files (eg, go one directory level up).

```python
def check_ignore1(rules, path):
    result = None
    for (pattern, value) in rules:
        if fnmatch(path, pattern):
            result = value
    return result
```

A function to match against the dictionary of **scoped** rules (the various `.gitignore` files). It just starts at the path’s directory then moves up to the parent directory, recursively, until it has tested root. Notice that this function (and the next two as well), never breaks **inside** a given `.gitignore` file. Even if a rule matches, they keep going through the file, because another rule there may negate reverse the effect (rules are processed in order, so if you want to exclude `*.c` but not `generator.c`, the general rule must come before the specific one). But as soon as at least one rule matched in a file, we drop the remaining files, because a more general file never cancels the effect of a more specific one (this is why `check_ignore1` is ternary and not boolean)

```python
def check_ignore_scoped(rules, path):
    parent = os.path.dirname(path)
    while True:
        if parent in rules:
            result = check_ignore1(rules[parent], path)
            if result != None:
                return result
        if parent == "":
            break
        parent = os.path.dirname(parent)
    return None
```

A much simpler function to match against the list of absolute rules. Notice that the order we push those rules to the list matters (we _did_ read the repository rules before the global ones!)

```python
def check_ignore_absolute(rules, path):
    parent = os.path.dirname(path)
    for ruleset in rules:
        result = check_ignore1(ruleset, path)
        if result != None:
            return result
    return False # This is a reasonable default at this point.
```

And finally, a function to bind them all.

```python
def check_ignore(rules, path):
    if os.path.isabs(path):
        raise Exception("This function requires path to be relative to the repository's root")

    result = check_ignore_scoped(rules.scoped, path)
    if result != None:
        return result

    return check_ignore_absolute(rules.absolute, path)
```

You can now call `wyag check-ignore`. On its own source tree:

```plaintext
$ wyag check-ignore hello.el hello.elc hello.html wyag.zip wyag.tar
hello.elc
hello.html
wyag.zip
```

Warning

**This is only an approximation**

This isn’t a perfect reimplementation. In particular, excluding whole directories with a rule that’s only the directory name (eg `__pycache__`) won’t work, because `fnmatch` would want the pattern as `__pycache__/**`. If you really want to play with ignore rules, [this may be a good starting point](https://github.com/mherrmann/gitignore_parser).

### 8.5. The status command

`status` is more complex than `ls-files`, because it needs to compare the index with both HEAD _and_ the actual filesystem. You call `git status` to know which files were added, removed or modified since the last commit, and which of these changes are actually staged, and will make it to the next commit. So `status` actually compares the `HEAD` with the staging area, and the staging area with the worktree. This is what its output looks like:

```plaintext
On branch master

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   write-yourself-a-git.org

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   write-yourself-a-git.org

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	org-html-themes/
	wl-copy
```

We’ll implement `status` in three parts: first the active branch or “detached HEAD”, then the difference between the index and the worktree (“Changes not staged for commit”), then the difference between HEAD and the index (“Changes to be committed” and “Untracked files”).

The public interface is dead simple, our status will take no argument:

```python
argsp = argsubparsers.add_parser("status", help = "Show the working tree status.")
```

And the bridge function just calls the three component functions in order:

```python
def cmd_status(_):
    repo = repo_find()
    index = index_read(repo)

    cmd_status_branch(repo)
    cmd_status_head_index(repo, index)
    print()
    cmd_status_index_worktree(repo, index)
```

#### 8.5.1. Finding the active branch

First we need to know if we’re on a branch, and if so which one. We do this by just looking at `.git/HEAD`. It should contain either an hexadecimal ID (a ref to a commit, in detached HEAD state), or an indirect reference to something in `refs/heads/`: the active branch. We either return its name, or `False`.

```python
def branch_get_active(repo):
    with open(repo_file(repo, "HEAD"), "r") as f:
        head = f.read()

    if head.startswith("ref: refs/heads/"):
        return(head[16:-1])
    else:
        return False
```

Based on this, we can write the first of the three `cmd_status_*` functions the bridge calls. This one prints the name of the active branch, or the hash of the detached HEAD:

```python
def cmd_status_branch(repo):
    branch = branch_get_active(repo)
    if branch:
        print(f"On branch {branch}.")
    else:
        print(f"HEAD detached at {object_find(repo, 'HEAD')}")
```

#### 8.5.2. Finding changes between HEAD and index

The second block of the status output is the “changes to be committed”, that is, how the staging area differs from HEAD. To do this, we’re going first to read the `HEAD` tree, and flatten it as a single dict (hashmap) with full paths as keys, so it’s closer to the (flat) index associating paths to blobs. Then we’ll just compare them and output their differences.

First, a function to convert a tree (recursive, remember) to a (flat) dict. And since trees are recursive, so the function itself is, again — sorry about that :)

```python
def tree_to_dict(repo, ref, prefix=""):
    ret = dict()
    tree_sha = object_find(repo, ref, fmt=b"tree")
    tree = object_read(repo, tree_sha)

    for leaf in tree.items:
        full_path = os.path.join(prefix, leaf.path)

        # We read the object to extract its type (this is uselessly
        # expensive: we could just open it as a file and read the
        # first few bytes)
        is_subtree = leaf.mode.startswith(b'04')

        # Depending on the type, we either store the path (if it's a
        # blob, so a regular file), or recurse (if it's another tree,
        # so a subdir)
        if is_subtree:
            ret.update(tree_to_dict(repo, leaf.sha, full_path))
        else:
            ret[full_path] = leaf.sha
    return ret
```

And the command itself:

```python
def cmd_status_head_index(repo, index):
    print("Changes to be committed:")

    head = tree_to_dict(repo, "HEAD")
    for entry in index.entries:
        if entry.name in head:
            if head[entry.name] != entry.sha:
                print("  modified:", entry.name)
            del head[entry.name] # Delete the key
        else:
            print("  added:   ", entry.name)

    # Keys still in HEAD are files that we haven't met in the index,
    # and thus have been deleted.
    for entry in head.keys():
        print("  deleted: ", entry)
```

#### 8.5.3. Finding changes between index and worktree

````python
def cmd_status_index_worktree(repo, index):
    print("Changes not staged for commit:")

    ignore = gitignore_read(repo)

    gitdir_prefix = repo.gitdir + os.path.sep

    all_files = list()

    # We begin by walking the filesystem
    for (root, _, files) in os.walk(repo.worktree, True):
        if root==repo.gitdir or root.startswith(gitdir_prefix):
            continue
        for f in files:
            full_path = os.path.join(root, f)
            rel_path = os.path.relpath(full_path, repo.worktree)
            all_files.append(rel_path)

    # We now traverse the index, and compare real files with the cached
    # versions.

    for entry in index.entries:
        full_path = os.path.join(repo.worktree, entry.name)

        # That file *name* is in the index

        if not os.path.exists(full_path):
            print("  deleted: ", entry.name)
        else:
            stat = os.stat(full_path)

            # Compare metadata
            ctime_ns = entry.ctime[0] * 10**9 + entry.ctime[1]
            mtime_ns = entry.mtime[0] * 10**9 + entry.mtime[1]
            if (stat.st_ctime_ns != ctime_ns) or (stat.st_mtime_ns != mtime_ns):
                # If different, deep compare.
                # @FIXME This *will* crash on symlinks to dir.
                with open(full_path, "rb") as fd:
                    new_sha = object_hash(fd, b"blob", None)
                    # If the hashes are the same, the files are actually the same.
                    same = entry.sha == new_sha

                    if not same:
                        print("  modified:", entry.name)

        if entry.name in all_files:
            all_files.remove(entry.name)

    print()
    print("Untracked files:")

    for f in all_files:
        # @TODO If a full directory is untracked, we should display
        # its name without its contents.
        if not check_ignore(ignore, f):
            print(" ", f)

Our status function is done. It should output something like:

```plaintext
$ wyag status
On branch main.

Changes to be committed:
  added:    src/main.c

Changes not staged for commit:
  modified: build.py
  deleted:  README.org

Untracked files:
  src/cli.c
````

The real `status` is a lot smarter: it can detect renames, for example, where ours cannot. Another significant difference worth mentioning is that `git status` actually _writes_ the index back if a file metadata was modified, but not its content. You can see it with our special ls-files:

```plaintext
$ wyag ls-files --verbose
Index file format v2, containing 1 entries.
file
  regular file with perms: 644
  on blob: f2f279981ce01b095c42ee7162aadf60185c8f67
  created: 2023-07-18 18:26:15.771460869, modified: 2023-07-18 18:26:15.771460869
  ...
$ touch file
$ git status > /dev/null
$ wyag ls-files --verbose
Index file format v2, containing 1 entries.
file
  regular file with perms: 644
  on blob: f2f279981ce01b095c42ee7162aadf60185c8f67
  created: 2023-07-18 18:26:41.421743098, modified: 2023-07-18 18:26:41.421743098
  ...

Notice how both timestamps, from the _index file_, were updated by `git status` to reflect the changes in the real file’s metadata.
```
