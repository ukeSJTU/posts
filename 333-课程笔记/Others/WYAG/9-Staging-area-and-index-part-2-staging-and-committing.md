## 9. Staging area and index, part 2: staging and committing

OK. Let’s create commits.

We have _almost_ everything we need for that, except for three last things:

1. We need commands to modify the index, so our commits aren’t just a copy of their parent. Those commands are `add` and `rm`.
2. These commands need to write the modified index back, since we commit _from the index_.
3. And obviously, we’ll need the `commit` function and its associated `wyag commit` command.

### 9.1. Writing the index

We’ll start by writing the index. Roughly, we’re just serializing everything back to binary. This is a bit tedious, but the code should be straightforward. I’m leaving the gory details for the comments, but it’s really just `index_read` in reverse — refer to it if needed, and the `GitIndexEntry` class.

def index_write(repo, index):
with open(repo_file(repo, "index"), "wb") as f:

        # HEADER

        # Write the magic bytes.
        f.write(b"DIRC")
        # Write version number.
        f.write(index.version.to_bytes(4, "big"))
        # Write the number of entries.
        f.write(len(index.entries).to_bytes(4, "big"))

        # ENTRIES

        idx = 0
        for e in index.entries:
            f.write(e.ctime[0].to_bytes(4, "big"))
            f.write(e.ctime[1].to_bytes(4, "big"))
            f.write(e.mtime[0].to_bytes(4, "big"))
            f.write(e.mtime[1].to_bytes(4, "big"))
            f.write(e.dev.to_bytes(4, "big"))
            f.write(e.ino.to_bytes(4, "big"))

            # Mode
            mode = (e.mode_type << 12) | e.mode_perms
            f.write(mode.to_bytes(4, "big"))

            f.write(e.uid.to_bytes(4, "big"))
            f.write(e.gid.to_bytes(4, "big"))

            f.write(e.fsize.to_bytes(4, "big"))
            # @FIXME Convert back to int.
            f.write(int(e.sha, 16).to_bytes(20, "big"))

            flag_assume_valid = 0x1 << 15 if e.flag_assume_valid else 0

            name_bytes = e.name.encode("utf8")
            bytes_len = len(name_bytes)
            if bytes_len >= 0xFFF:
                name_length = 0xFFF
            else:
                name_length = bytes_len

            # We merge back three pieces of data (two flags and the
            # length of the name) on the same two bytes.
            f.write((flag_assume_valid | e.flag_stage | name_length).to_bytes(2, "big"))

            # Write back the name, and a final 0x00.
            f.write(name_bytes)
            f.write((0).to_bytes(1, "big"))

            idx += 62 + len(name_bytes) + 1

            # Add padding if necessary.
            if idx % 8 != 0:
                pad = 8 - (idx % 8)
                f.write((0).to_bytes(pad, "big"))
                idx += pad

### 9.2. The rm command

The easiest change we can do to an index is to remove an entry from it, which mean that the next commit **won’t include** this file. This is what the `git rm` command does.

Danger

`git rm` is **destructive**, and so is `wyag rm`. The command not only modifies the index, it also removes file(s) from the worktree. Unlike git, `wyag rm` doesn’t care if the file it removes isn’t saved. Proceed with caution.

`rm` takes a single argument, a list of paths to remove:

argsp = argsubparsers.add_parser("rm", help="Remove files from the working tree and the index.")
argsp.add_argument("path", nargs="+", help="Files to remove")

def cmd_rm(args):
repo = repo_find()
rm(repo, args.path)

The `rm` function is a bit long, but it’s very simple. It takes a repository and a list of paths, reads that repository index, and removes entries in the index that match this list. The optional arguments control whether the function should actually delete the files, and whether it should abort if some paths aren’t present on the index (both those arguments are for the use of `add`, they’re not exposed in the `wyag rm` command).

def rm(repo, paths, delete=True, skip_missing=False): # Find and read the index
index = index_read(repo)

    worktree = repo.worktree + os.sep

    # Make paths absolute
    abspaths = set()
    for path in paths:
        abspath = os.path.abspath(path)
        if abspath.startswith(worktree):
            abspaths.add(abspath)
        else:
            raise Exception(f"Cannot remove paths outside of worktree: {paths}")

    # The list of entries to *keep*, which we will write back to the
    # index.
    kept_entries = list()
    # The list of removed paths, which we'll use after index update
    # to physically remove the actual paths from the filesystem.
    remove = list()

    # Now iterate over the list of entries, and remove those whose
    # paths we find in abspaths.  Preserve the others in kept_entries.
    for e in index.entries:
        full_path = os.path.join(repo.worktree, e.name)

        if full_path in abspaths:
            remove.append(full_path)
            abspaths.remove(full_path)
        else:
            kept_entries.append(e) # Preserve entry

    # If abspaths is empty, it means some paths weren't in the index.
    if len(abspaths) > 0 and not skip_missing:
        raise Exception(f"Cannot remove paths not in the index: {abspaths}")

    # Physically delete paths from filesystem.
    if delete:
        for path in remove:
            os.unlink(path)

    # Update the list of entries in the index, and write it back.
    index.entries = kept_entries
    index_write(repo, index)

And we can now delete files with `wyag rm`.

### 9.3. The add command

Adding is just a bit more complex than removing, but nothing we don’t already know. Staging a file to a three-steps operation:

1. We begin by removing the existing index entry, if there’s one, without removing the file itself (this is why the `rm` function we just wrote has those optional arguments).
2. We then hash the file into a glob object,
3. create its entry,
4. And of course, finally write the modified index back.

First, the interface. Nothing surprising, `wyag add PATH ...` where PATH is one or more file(s) to stage. The bridge is as boring as can be.

argsp = argsubparsers.add_parser("add", help = "Add files contents to the index.")
argsp.add_argument("path", nargs="+", help="Files to add")

def cmd_add(args):
repo = repo_find()
add(repo, args.path)

The main difference with `rm` is that `add` needs to create an index entry. This isn’t hard: we just `stat()` the file and copy the metadata in the index’s field (`stat()` returns those metadata the index stores: creation/modification time, and so on)

def add(repo, paths, delete=True, skip_missing=False):

    # First remove all paths from the index, if they exist.
    rm (repo, paths, delete=False, skip_missing=True)

    worktree = repo.worktree + os.sep

    # Convert the paths to pairs: (absolute, relative_to_worktree).
    # Also delete them from the index if they're present.
    clean_paths = set()
    for path in paths:
        abspath = os.path.abspath(path)
        if not (abspath.startswith(worktree) and os.path.isfile(abspath)):
            raise Exception(f"Not a file, or outside the worktree: {paths}")
        relpath = os.path.relpath(abspath, repo.worktree)
        clean_paths.add((abspath,  relpath))

    # Find and read the index.  It was modified by rm.  (This isn't
    # optimal, good enough for wyag!)
    #
    # @FIXME, though: we could just move the index through
    # commands instead of reading and writing it over again.
    index = index_read(repo)

    for (abspath, relpath) in clean_paths:
        with open(abspath, "rb") as fd:
            sha = object_hash(fd, b"blob", repo)

            stat = os.stat(abspath)

            ctime_s = int(stat.st_ctime)
            ctime_ns = stat.st_ctime_ns % 10**9
            mtime_s = int(stat.st_mtime)
            mtime_ns = stat.st_mtime_ns % 10**9

            entry = GitIndexEntry(ctime=(ctime_s, ctime_ns), mtime=(mtime_s, mtime_ns), dev=stat.st_dev, ino=stat.st_ino,
                                  mode_type=0b1000, mode_perms=0o644, uid=stat.st_uid, gid=stat.st_gid,
                                  fsize=stat.st_size, sha=sha, flag_assume_valid=False,
                                  flag_stage=False, name=relpath)
            index.entries.append(entry)

    # Write the index back
    index_write(repo, index)

### 9.4. The commit command

Now that we have modified the index, so actually _staged changes_, we only need to turn those changes into a commit. That’s what `commit` does.

argsp = argsubparsers.add_parser("commit", help="Record changes to the repository.")

argsp.add_argument("-m",
metavar="message",
dest="message",
help="Message to associate with this commit.")

To do so, we first need to convert the index into a tree object, generate and store the corresponding commit object, and update the HEAD branch to the new commit (remember: a branch is just a ref to a commit).

Before we get to the interesting details, we will need to read git’s config to get the name of the user, which we’ll use as the author and committer. We’ll use the same `configparser` library we’ve used to read repo’s config.

def gitconfig_read():
xdg_config_home = os.environ["XDG_CONFIG_HOME"] if "XDG_CONFIG_HOME" in os.environ else "~/.config"
configfiles = [
os.path.expanduser(os.path.join(xdg_config_home, "git/config")),
os.path.expanduser("~/.gitconfig")
]

    config = configparser.ConfigParser()
    config.read(configfiles)
    return config

And just a simple function to grab, and format, the user identity:

def gitconfig_user_get(config):
if "user" in config:
if "name" in config["user"] and "email" in config["user"]:
return f"{config['user']['name']} <{config['user']['email']}>"
return None

Now for the interesting part. We first need to build a tree from the index. This isn’t hard, but notice that while the index is flat (it stores full paths for the whole worktree), a tree is a recursive structure: it lists files, or other trees. To “unflatten” the index into a tree, we’re going to:

1.  Build a dictionary (hashmap) of directories. Keys are full paths from worktree root (like `assets/sprites/monsters/`), values are list of `GitIndexEntry` — files in the directory. At this point, our dictionary only contains _files_: directories are only its keys.
2.  Traverse this list, going bottom-up, that is, from the deepest directories up to root (depth doesn’t really matter: we just want to see each directory _before_ its parent. To do that, we just sort them by _full_ path length, from longest to shortest — parents are obviously always shorter). As an example, imagine we start at `assets/sprites/monsters/`
3.  At each directory, we build a tree with its contents, say `cacodemon.png`, `imp.png` and `baron-of-hell.png`.
4.  We write the new tree to the repository.
5.  We then add this tree to this directory’s parent. Meaning that at this point, `assets/sprites/` now contains our new tree object’s SHA-1 id under the name `monsters`.
6.  And we iterate over the next directory, let’s say `assets/sprites/keys` where we find `red.png`, `blue.png` and `yellow.png`, create a tree, store the tree, add the tree’s SHA-1 under the name `keys` under `assets/sprites/`, and so on.

And since trees are recursive? So the last tree we’ll build, which is necessarily the one for root (since its key’s length is 0), will ultimately refer to all others, and thus will be only one we’ll need. We’ll simply return its SHA-1, and be done.

Since this may seem a bit complex, let’s work this example in full details — feel free to skip. At the beginning, the dictionary we built from the index looks like this:

contents["assets/sprites/monsters"] =
[ cacodemon.png : GitIndexEntry
, imp.png : GitIndexEntry
, baron-of-hell.png : GitIndexEntry ]
contents["assets/sprites/keys"] =
[ red.png : GitIndexEntry
, blue.png : GitIndexEntry
, yellow.png : GitIndexEntry ]
contents["assets/sprites/"] =
[ hero.png : GitIndexEntry ]
contents["assets/"] = [] # No files in here
contents[""] = # Root!
[ README: GitIndexEntry ]

We iterate over it, by order of descending key length. The first key we meet is the longest, so `assets/sprites/monsters`. We build a new tree object from its contents, which associates the three file names (`cacodemon.png`, `imp.png`, `baron-of-hell.png`) with their corresponding blobs (A tree leaf stores _less_ data than the index — just path, mode and blob. So converting entries that way is easy)

Notice we don’t need to concern ourselves with storing the **contents** of those files: `wyag add` did create the corresponding blobs as needed. We need to store the _trees_ we create to the object store, but we can assume the blobs are there already.

Let’s say that our new tree hashes, made from the index entries that lived directly in `assets/sprites/monsters`, hashes down to `426f894781bc3c38f1d26f8fd2c7f38ab8d21763`. We **modify our dictionary** to add that new tree object to the directory’s parent, like this, so what remains to traverse now looks like this:

contents["assets/sprites/keys"] = # <- unmodified.
[ red.png : GitIndexEntry
, blue.png : GitIndexEntry
, yellow.png : GitIndexEntry ]
contents["assets/sprites/"] =
[ hero.png : GitIndexEntry
, monsters : Tree 426f894781bc3c38f1d26f8fd2c7f38ab8d21763 ] <- look here
contents["assets/"] = [] # empty
contents[""] = # Root!
[ README: GitIndexEntry ]

We do the same for the next longest key, `assets/sprites/keys`, producing a tree of hash `b42788e087b1e94a0e69dcb7a4a243eaab802bb2`, so:

contents["assets/sprites/"] =
[ hero.png : GitIndexEntry
, monsters : Tree 426f894781bc3c38f1d26f8fd2c7f38ab8d21763
, keys : Tree b42788e087b1e94a0e69dcb7a4a243eaab802bb2 ]
contents["assets/"] = [] # empty
contents[""] = # Root!
[ README: GitIndexEntry ]

We then generate tree `6364113557ed681d775ccbd3c90895ed276956a2` from assets/sprites, which now contains our two trees and `hero.png`.

contents["assets/"] = [
sprites: Tree 6364113557ed681d775ccbd3c90895ed276956a2 ]
contents[""] = # Root!
[ README: GitIndexEntry ]

Assets in turn becomes tree `4d35513cb6d2a816bc00505be926624440ebbddd`, so:

contents[""] = # Root!
[ README: GitIndexEntry,
assets: 4d35513cb6d2a816bc00505be926624440ebbddd]

We make a tree from that last key (with the `README` blob and the `assets` subtree), it hashes to `9352e52ff58fa9bf5a750f090af64c09fa6a3d93`. That’s our return value: the tree whose contents are the same as the index’s.

Here’s the actual function:

def tree_from_index(repo, index):
contents = dict()
contents[""] = list()

    # Enumerate entries, and turn them into a dictionary where keys
    # are directories, and values are lists of directory contents.
    for entry in index.entries:
        dirname = os.path.dirname(entry.name)

        # We create all dictonary entries up to root (" ").  We need
        # them *all*, because even if a directory holds no files it
        # will contain at least a tree.
        key = dirname
        while key != "":
            if not key in contents:
                contents[key] = list()
            key = os.path.dirname(key)

        # For now, simply store the entry in the list.
        contents[dirname].append(entry)

    # Get keys (= directories) and sort them by length, descending.
    # This means that we'll always encounter a given path before its
    # parent, which is all we need, since for each directory D we'll
    # need to modify its parent P to add D's tree.
    sorted_paths = sorted(contents.keys(), key=len, reverse=True)

    # This variable will store the current tree's SHA-1.  After we're
    # done iterating over our dict, it will contain the hash for the
    # root tree.
    sha = None

    # We ge through the sorted list of paths (dict keys)
    for path in sorted_paths:
        # Prepare a new, empty tree object
        tree = GitTree()

        # Add each entry to our new tree, in turn
        for entry in contents[path]:
            # An entry can be a normal GitIndexEntry read from the
            # index, or a tree we've created.
            if isinstance(entry, GitIndexEntry): # Regular entry (a file)

                # We transcode the mode: the entry stores it as integers,
                # we need an octal ASCII representation for the tree.
                leaf_mode = f"{entry.mode_type:02o}{entry.mode_perms:04o}".encode("ascii")
                leaf = GitTreeLeaf(mode = leaf_mode, path=os.path.basename(entry.name), sha=entry.sha)
            else: # Tree.  We've stored it as a pair: (basename, SHA)
                leaf = GitTreeLeaf(mode = b"040000", path=entry[0], sha=entry[1])

            tree.items.append(leaf)

        # Write the new tree object to the store.
        sha = object_write(tree, repo)

        # Add the new tree hash to the current dictionary's parent, as
        # a pair (basename, SHA)
        parent = os.path.dirname(path)
        base = os.path.basename(path) # The name without the path, eg main.go for src/main.go
        contents[parent].append((base, sha))

    return sha

This was the hard part; I hope it’s clear enough. From this, creating the commit object and updating HEAD will be way easier. Just remember that what this function _does_ is built and store as many tree objects as needed to represent the index, and return the root tree’s SHA-1.

The function to create a commit object is simple enough, it just takes some arguments: the hash of the tree, the hash of the parent commit, the author’s identity (a string), the timestamp and timezone delta, and the message:

```python
def commit_create(repo, tree, parent, author, timestamp, message):
    commit = GitCommit() # Create the new commit object.
    commit.kvlm[b"tree"] = tree.encode("ascii")
    if parent:
        commit.kvlm[b"parent"] = parent.encode("ascii")

    # Trim message and add a trailing \n
    message = message.strip() + "\n"
    # Format timezone
    offset = int(timestamp.astimezone().utcoffset().total_seconds())
    hours = offset // 3600
    minutes = (offset % 3600) // 60
    tz = "{:02}{:02}".format("+" if offset > 0 else "-", hours, minutes)

    author = author + timestamp.strftime(" %s ") + tz

    commit.kvlm[b"author"] = author.encode("utf8")
    commit.kvlm[b"committer"] = author.encode("utf8")
    commit.kvlm[None] = message.encode("utf8")

    return object_write(commit, repo)
```

All what remains to write is `cmd_commit`, the bridge function to the `wyag commit` command:

def cmd_commit(args):
repo = repo_find()
index = index_read(repo) # Create trees, grab back SHA for the root tree.
tree = tree_from_index(repo, index)

    # Create the commit object itself
    commit = commit_create(repo,
                           tree,
                           object_find(repo, "HEAD"),
                           gitconfig_user_get(gitconfig_read()),
                           datetime.now(),
                           args.message)

    # Update HEAD so our commit is now the tip of the active branch.
    active_branch = branch_get_active(repo)
    if active_branch: # If we're on a branch, we update refs/heads/BRANCH
        with open(repo_file(repo, os.path.join("refs/heads", active_branch)), "w") as fd:
            fd.write(commit + "\n")
    else: # Otherwise, we update HEAD itself.
        with open(repo_file(repo, "HEAD"), "w") as fd:
            fd.write("\n")

And we’re done!

```

```
