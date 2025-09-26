## 6. Reading commit data: checkout

It’s all well that commits hold a lot more than files and directories in a given state, but that doesn’t make them really useful. It’s probably time to start implementing tree objects as well, so we’ll be able to checkout commits into the work tree.

### 6.1. What’s in a tree?

Informally, a tree describes the content of the work tree, that it, it associates blobs to paths. It’s an array of three-element tuples made of a file mode, a path (relative to the worktree) and a SHA-1. A typical tree contents may look like this:

Mode

SHA-1

Path
`100644`

`894a44cc066a027465cd26d634948d56d13af9af`

`.gitignore`
`100644`

`94a9ed024d3859793618152ea559a168bbcbb5e2`

`LICENSE`
`100644`

`bab489c4f4600a38ce6dbfd652b90383a4aa3e45`

`README.md`
`100644`

`6d208e47659a2a10f5f8640e0155d9276a2130a9`

`src`
`040000`

`e7445b03aea61ec801b20d6ab62f076208b7d097`

`tests`
`040000`

`d5ec863f17f3a2e92aa8f6b66ac18f7b09fd1b38`

`main.c`
Mode is just the file’s [mode](https://en.wikipedia.org/wiki/File_system_permissions), path is its location. The SHA-1 refers to either a blob or another tree object. If a blob, the path is a file, if a tree, it’s directory. To instantiate this tree in the filesystem, we would begin by loading the object associated to the first path (`.gitignore`) and check its type. Since it’s a blob, we’ll just create a file called `.gitignore` with this blob’s contents; and same for `LICENSE` and `README.md`. But the object associated with `src` is not a blob, but another tree: we’ll create the directory `src` and repeat the same operation in that directory with the new tree.

Warning

**A path is a single filesystem entry**

The path identifies exactly one file or directory. Not two, not three. If you have five levels of nested directories, even if four are empty save the next directory, you’re going to need five tree objects recursively referring to one another. You cannot take the shortcut of putting a full path in a single tree entry, like `dir1/dir2/dir3/dir4/dir5`.

### 6.2. Parsing trees

Unlike tags and commits, tree objects are binary objects, but their format is actually quite simple. A tree is the concatenation of records of the format:

[mode] space [path] 0x00 [sha-1]

- `[mode]` is up to six bytes and is an octal representation of a file **mode**, stored in ASCII. For example, 100644 is encoded with byte values 49 (ASCII –1–), 48 (ASCII –0–), 48, 54, 52, 52. The first two digits encode the file type (file, directory, symlink or submodule), the last four the permissions.
- It’s followed by 0x20, an ASCII **space**;
- Followed by the null-terminated (0x00) **path**;
- Followed by the object’s **SHA-1** in binary encoding, on 20 bytes.

The parser is going to be quite simple. First, create a tiny object wrapper for a single record (a leaf, a single path):

class GitTreeLeaf (object):
def **init**(self, mode, path, sha):
self.mode = mode
self.path = path
self.sha = sha

Because a tree object is just the repetition of the same fundamental data structure, we write the parser in two functions. First, a parser to extract a single record, which returns parsed data and the position it reached in input data:

def tree_parse_one(raw, start=0): # Find the space terminator of the mode
x = raw.find(b' ', start)
assert x-start == 5 or x-start==6

    # Read the mode
    mode = raw[start:x]
    if len(mode) == 5:
        # Normalize to six bytes.
        mode = b"0" + mode

    # Find the NULL terminator of the path
    y = raw.find(b'\x00', x)
    # and read the path
    path = raw[x+1:y]

    # Read the SHA…
    raw_sha = int.from_bytes(raw[y+1:y+21], "big")
    # and convert it into an hex string, padded to 40 chars
    # with zeros if needed.
    sha = format(raw_sha, "040x")
    return y+21, GitTreeLeaf(mode, path.decode("utf8"), sha)

And the –real– parser which just calls the previous one in a loop, until input data is exhausted.

def tree_parse(raw):
pos = 0
max = len(raw)
ret = list()
while pos < max:
pos, data = tree_parse_one(raw, pos)
ret.append(data)

    return ret

We’ll finally need a serializer to write trees back. Because we may have added or modified entries, we need to sort them again. Consistently sorting matters, because we need to respect git’s [identity rules](#org239f993), which says that no two equivalent object can have a different hash — but differently sorted trees with the same contents _would_ be equivalent (describing the same directory structure), and still numerically distinct (different SHA-1 identifiers). Incorrectly sorted trees are invalid, but _git doesn’t enforce that_. I created some invalid trees by accident writing wyag, and all I got was weird bugs in `git status` (specifically, `status` would report an actually clean worktree as fully modified). We don’t want that.

The ordering function is quite simple, with an unexpected twist. are Entries sorted by name, alphabetically, _but_ directories (that is, tree entries) are sorted with a final `/` added. It matters, because it means that if `whatever` names a regular file, it will sort _before_ `whatever.c`, but if `whatever` is a dir, it will sort _after_, as `whatever/`. (I’m not sure why git does that. If you’re curious, see the function `base_name_compare` in `tree.c` in the git source)

# Notice this isn't a comparison function, but a conversion function.

# Python's default sort doesn't accept a custom comparison function,

# like in most languages, but a `key` arguments that returns a new

# value, which is compared using the default rules. So we just return

# the leaf name, with an extra / if it's a directory.

def tree_leaf_sort_key(leaf):
if leaf.mode.startswith(b"10"):
return leaf.path
else:
return leaf.path + "/"

Then the serializer itself. This one is very simple: we sort the items using our newly created function as a transformer, then write them in order.

def tree_serialize(obj):
obj.items.sort(key=tree_leaf_sort_key)
ret = b''
for i in obj.items:
ret += i.mode
ret += b' '
ret += i.path.encode("utf8")
ret += b'\x00'
sha = int(i.sha, 16)
ret += sha.to_bytes(20, byteorder="big")
return ret

And now we just have to combine all that into a class:

class GitTree(GitObject):
fmt=b'tree'

    def deserialize(self, data):
        self.items = tree_parse(data)

    def serialize(self):
        return tree_serialize(self)

    def init(self):
        self.items = list()

### 6.3. Showing trees: ls-tree

While we’re at it, let’s add the `ls-tree` command to wyag. It’s so easy there’s no reason not to. `git ls-tree [-r] TREE` simply prints the contents of a tree, recursively with the `-r` flag. In recursive mode, it doesn’t show subtrees, just final objects with their full paths.

argsp = argsubparsers.add_parser("ls-tree", help="Pretty-print a tree object.")
argsp.add_argument("-r",
dest="recursive",
action="store_true",
help="Recurse into sub-trees")

argsp.add_argument("tree",
help="A tree-ish object.")

def cmd_ls_tree(args):
repo = repo_find()
ls_tree(repo, args.tree, args.recursive)

def ls_tree(repo, ref, recursive=None, prefix=""):
sha = object_find(repo, ref, fmt=b"tree")
obj = object_read(repo, sha)
for item in obj.items:
if len(item.mode) == 5:
type = item.mode[0:1]
else:
type = item.mode[0:2]

        match type: # Determine the type.
            case b'04': type = "tree"
            case b'10': type = "blob" # A regular file.
            case b'12': type = "blob" # A symlink. Blob contents is link target.
            case b'16': type = "commit" # A submodule
            case _: raise Exception(f"Weird tree leaf mode {item.mode}")

        if not (recursive and type=='tree'): # This is a leaf
            print(f"{ '0' * (6 - len(item.mode)) + item.mode.decode("ascii")} {type} {item.sha}\t{os.path.join(prefix, item.path)}")
        else: # This is a branch, recurse
            ls_tree(repo, item.sha, recursive, os.path.join(prefix, item.path))

### 6.4. The checkout command

`git checkout` simply instantiates a commit in the worktree. We’re going to oversimplify the actual git command to make our implementation clear and understandable. We’re also going to add a few safeguards. Here’s how our version of checkout will work:

- It will take two arguments: a commit, and a directory. Git checkout only needs a commit.
- It will then instantiate the tree in the directory, **if and only if the directory is empty**. Git is full of safeguards to avoid deleting data, which would be too complicated and unsafe to try to reproduce in wyag. Since the point of wyag is to demonstrate git, not to produce a working implementation, this limitation is acceptable.

Let’s get started. As usual, we need a subparser:

argsp = argsubparsers.add_parser("checkout", help="Checkout a commit inside of a directory.")

argsp.add_argument("commit",
help="The commit or tree to checkout.")

argsp.add_argument("path",
help="The EMPTY directory to checkout on.")

A wrapper function:

def cmd_checkout(args):
repo = repo_find()

    obj = object_read(repo, object_find(repo, args.commit))

    # If the object is a commit, we grab its tree
    if obj.fmt == b'commit':
        obj = object_read(repo, obj.kvlm[b'tree'].decode("ascii"))

    # Verify that path is an empty directory
    if os.path.exists(args.path):
        if not os.path.isdir(args.path):
            raise Exception(f"Not a directory {args.path}!")
        if os.listdir(args.path):
            raise Exception(f"Not empty {args.path}!")
    else:
        os.makedirs(args.path)

    tree_checkout(repo, obj, os.path.realpath(args.path))

And a function to do the actual work:

def tree_checkout(repo, tree, path):
for item in tree.items:
obj = object_read(repo, item.sha)
dest = os.path.join(path, item.path)

        if obj.fmt == b'tree':
            os.mkdir(dest)
            tree_checkout(repo, obj, dest)
        elif obj.fmt == b'blob':
            # @TODO Support symlinks (identified by mode 12****)
            with open(dest, 'wb') as f:
                f.write(obj.blobdata)
