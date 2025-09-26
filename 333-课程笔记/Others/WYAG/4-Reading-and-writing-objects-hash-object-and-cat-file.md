## 4. Reading and writing objects: hash-object and cat-file

### 4.1. What are objects?

Now that we have repositories, putting things inside them is in order. Also, repositories are boring, and writing a Git implementation shouldn’t be just a matter of writing a bunch of `mkdir`. Let’s talk about **objects**, and let’s implement `git hash-object` and `git cat-file`.

Maybe you don’t know these two commands — they’re not exactly part of an everyday git toolbox, and they’re actually quite low-level (“plumbing”, in git parlance). What they do is actually very simple: `hash-object` converts an existing file into a git object, and `cat-file` prints an existing git object to the standard output.

Now, **what actually is a Git object?** At its core, Git is a “content-addressed filesystem”. That means that unlike regular filesystems, where the name of a file is arbitrary and unrelated to that file’s contents, the names of files as stored by Git are mathematically derived from their contents. This has a very important implication: if a single byte of, say, a text file, changes, its internal name will change, too. To put it simply: you don’t _modify_ a file in git, you create a new file in a different location. Objects are just that: **files in the git repository, whose paths are determined by their contents**.

Warning

**Git is not (really) a key-value store**

Some documentation, including the excellent [Pro Git](https://git-scm.com/book/id/v2/Git-Internals-Git-Objects), call Git a “key-value store”. This is not incorrect, but may be misleading. Regular filesystems are actually closer to a key-value store than Git is. Because it computes keys from data, Git could rather be called a _value-value store_.

Git uses objects to store quite a lot of things: first and foremost, the actual files it keeps in version control — source code, for example. Commit are objects, too, as well as tags. With a few notable exceptions (which we’ll see later!), almost everything, in Git, is stored as an object.

The path where git stores a given object is computed by calculating the [SHA-1](https://en.wikipedia.org/wiki/SHA-1) [hash](https://en.wikipedia.org/wiki/Cryptographic_hash_function) of its contents. More precisely, Git renders the hash as a lowercase hexadecimal string, and splits it in two parts: the first two characters, and the rest. It uses the first part as a directory name, the rest as the file name (this is because most filesystems hate having too many files in a single directory and would slow down to a crawl. Git’s method creates 256 possible intermediate directories, hence dividing the average number of files per directory by 256)

Note

**What is a hash function?**

SHA-1 is what we call a “hash function”. Simply put, a hash function is a kind of unidirectional mathematical function: it is easy to compute the hash of a value, but there’s no way to compute back which value produced a hash.

A very simple example of a hash function is the classical `len` (or `strlen`) function, which returns the length of a string. It’s really easy to compute the length of a string, and the length of a given string will never change (unless the string itself changes, of course!) but it’s impossible to retrieve the original string, given only its length. _Cryptographic_ hash functions are a much more complex version of the same, with the added property that computing an input meant to produce a given hash is hard enough to be practically impossible. (To produce an input `i` with `strlen(i) == 12`, you just type twelve random characters. With algorithms such as SHA-1. it would take much, much longer — long enough to be practically impossible[1](#fn.1)).

Before we start implementing the object storage system, we must understand their exact storage format. An object starts with a header that specifies its type: `blob`, `commit`, `tag` or `tree` (more on that in a second). This header is followed by an ASCII space (0x20), then the size of the object in bytes as an ASCII number, then null (0x00) (the null byte), then the contents of the object. The first 48 bytes of a commit object in Wyag’s repo look like this:

00000000 63 6f 6d 6d 69 74 20 31 30 38 36 00 74 72 65 65 |commit 1086.tree|
00000010 20 32 39 66 66 31 36 63 39 63 31 34 65 32 36 35 | 29ff16c9c14e265|
00000020 32 62 32 32 66 38 62 37 38 62 62 30 38 61 35 61 |2b22f8b78bb08a5a|

In the first line, we see the type header, a space (`0x20`), the size in ASCII (1086) and the null separator `0x00`. The last four bytes on the first line are the beginning of that object’s contents, the word “tree” — we’ll discuss that further when we’ll talk about commits.

The objects (headers and contents) are stored compressed with `zlib`.

### 4.2. A generic object object

Objects can be of multiple types, but they all share the same storage/retrieval mechanism and the same general header format. Before we dive into the details of various types of objects, we need to abstract over these common features. The easiest way is to create a generic `GitObject` with two unimplemented methods: `serialize()` and `deserialize()`, and a default `init()` to create a new, empty object if needed (sorry pythonistas, this isn’t very nice design but it’s probably easier to read than superconstructors). Our `__init__` either loads the object from the provided data, or calls the subclass-provided `init()` to create a new, empty object.

Later, we’ll subclass this generic class, actually implementing these functions for each object format.

class GitObject (object):

    def __init__(self, data=None):
        if data != None:
            self.deserialize(data)
        else:
            self.init()

    def serialize(self, repo):
        """This function MUST be implemented by subclasses.

It must read the object's contents from self.data, a byte string, and
do whatever it takes to convert it into a meaningful representation.
What exactly that means depend on each subclass.

        """
        raise Exception("Unimplemented!")

    def deserialize(self, data):
        raise Exception("Unimplemented!")

    def init(self):
        pass # Just do nothing. This is a reasonable default!

### 4.3. Reading objects

To read an object, we need to know its SHA-1 hash. We then compute its path from this hash (with the formula explained above: first two characters, then a directory delimiter `/`, then the remaining part) and look it up inside of the “objects” directory in the gitdir. That is, the path to `e673d1b7eaa0aa01b5bc2442d570a765bdaae751` is `.git/objects/e6/73d1b7eaa0aa01b5bc2442d570a765bdaae751`.

We then read that file as a binary file, and decompress it using `zlib`.

From the decompressed data, we extract the two header components: the object type and its size. From the type, we determine the actual class to use. We convert the size to a Python integer, and check if it matches.

When all is done, we just call the correct constructor for that object’s format.

def object_read(repo, sha):
"""Read object sha from Git repository repo. Return a
GitObject whose exact type depends on the object."""

    path = repo_file(repo, "objects", sha[0:2], sha[2:])

    if not os.path.isfile(path):
        return None

    with open (path, "rb") as f:
        raw = zlib.decompress(f.read())

        # Read object type
        x = raw.find(b' ')
        fmt = raw[0:x]

        # Read and validate object size
        y = raw.find(b'\x00', x)
        size = int(raw[x:y].decode("ascii"))
        if size != len(raw)-y-1:
            raise Exception(f"Malformed object {sha}: bad length")

        # Pick constructor
        match fmt:
            case b'commit' : c=GitCommit
            case b'tree'   : c=GitTree
            case b'tag'    : c=GitTag
            case b'blob'   : c=GitBlob
            case _:
                raise Exception(f"Unknown type {fmt.decode("ascii")} for object {sha}")

        # Call constructor and return object
        return c(raw[y+1:])

### 4.4. Writing objects

Writing an object is reading it in reverse: we compute the hash, insert the header, zlib-compress everything and write the result in the correct location. This really shouldn’t require much explanation, just notice that the hash is computed **after** the header is added (so it’s the hash of the object itself, uncompressed, not just its contents)

def object_write(obj, repo=None): # Serialize object data
data = obj.serialize() # Add header
result = obj.fmt + b' ' + str(len(data)).encode() + b'\x00' + data # Compute hash
sha = hashlib.sha1(result).hexdigest()

    if repo:
        # Compute path
        path=repo_file(repo, "objects", sha[0:2], sha[2:], mkdir=True)

        if not os.path.exists(path):
            with open(path, 'wb') as f:
                # Compress and write
                f.write(zlib.compress(result))
    return sha

### 4.5. Working with blobs

We said earlier that the type header could be one of four: `blob`, `commit`, `tag` and `tree` — so git has four object types.

Blobs are the simplest of those four types, because they have no actual format. Blobs are user data: the content of every file you put in git (`main.c`, `logo.png`, `README.md`) is stored as a blob. That makes them easy to manipulate, because they have no actual syntax or constraints beyond the basic object storage mechanism: they’re just unspecified data. Creating a `GitBlob` class is thus trivial, the `serialize` and `deserialize` functions just have to store and return their input unmodified.

class GitBlob(GitObject):
fmt=b'blob'

    def serialize(self):
        return self.blobdata

    def deserialize(self, data):
        self.blobdata = data

### 4.6. The cat-file command

We can now create `wyag cat-file`. `git cat-file` simply prints the raw contents of an object to stdout, uncompressed and without the git header. In a clone of [wyag’s source repository](https://github.com/thblt/write-yourself-a-git), `git cat-file blob e0695f14a412c29e252c998c81de1dde59658e4a` will show a version of the README.

Our simplified version will just take those two positional arguments: a type and an object identifier:

wyag cat-file TYPE OBJECT

The subparser is very simple:

argsp = argsubparsers.add_parser("cat-file",
help="Provide content of repository objects")

argsp.add_argument("type",
metavar="type",
choices=["blob", "commit", "tag", "tree"],
help="Specify the type")

argsp.add_argument("object",
metavar="object",
help="The object to display")

And we can implement the functions, which just call into existing code we wrote earlier:

def cmd_cat_file(args):
repo = repo_find()
cat_file(repo, args.object, fmt=args.type.encode())

def cat_file(repo, obj, fmt=None):
obj = object_read(repo, object_find(repo, obj, fmt=fmt))
sys.stdout.buffer.write(obj.serialize())

This function calls an `object_find` function we haven’t introduced yet. For now, it’s just going to return one of its arguments unmodified, like this:

def object_find(repo, name, fmt=None, follow=True):
return name

The reason for this strange small function is that Git has a _lot_ of ways to refer to objects: full hash, short hash, tags… `object_find()` will be our name resolution function. We’ll only implement it [later](#object_find), so this is just a temporary placeholder. This means that until we implement the real thing, the only way we can refer to an object will be by its full hash.

### 4.7. The hash-object command

We will want to put our _own_ data in our repositories, though. `hash-object` is basically the opposite of `cat-file`: it reads a file, computes its hash as an object, either storing it in the repository (if the -w flag is passed) or just printing its hash.

The syntax of `wyag hash-object` is a simplification of `git hash-object`:

wyag hash-object [-w] [-t TYPE] FILE

Which converts to:

```python
argsp = argsubparsers.add_parser(
    "hash-object",
    help="Compute object ID and optionally creates a blob from a file")

argsp.add_argument("-t",
                   metavar="type",
                   dest="type",
                   choices=["blob", "commit", "tag", "tree"],
                   default="blob",
                   help="Specify the type")

argsp.add_argument("-w",
                   dest="write",
                   action="store_true",
                   help="Actually write the object into the database")

argsp.add_argument("path",
                   help="Read object from <file>")

The actual implementation is very simple. As usual, we create a small bridge function:

def cmd_hash_object(args):
    if args.write:
        repo = repo_find()
    else:
        repo = None

    with open(args.path, "rb") as fd:
        sha = object_hash(fd, args.type.encode(), repo)
        print(sha)

The actual implementation is also trivial. The `repo` argument is optional, and the object isn’t written if it is `None` (this is handled in `object_write()`, above):

def object_hash(fd, fmt, repo=None):
    """ Hash object, writing it to repo if provided."""
    data = fd.read()

    # Choose constructor according to fmt argument
    match fmt:
        case b'commit' : obj=GitCommit(data)
        case b'tree'   : obj=GitTree(data)
        case b'tag'    : obj=GitTag(data)
        case b'blob'   : obj=GitBlob(data)
        case _: raise Exception(f"Unknown type {fmt}!")

    return object_write(obj, repo)
```

### 4.8. Aside: what about packfiles?

What we’ve just implemented is called “loose objects”. Git has a second object storage mechanism called packfiles. Packfiles are much more efficient, but also much more complex, than loose objects. Simply put, a packfile is a compilation of loose objects (like a `tar`) but some are stored as deltas (as a transformation of another object). Packfiles are way too complex to be supported by wyag.

The packfile is stored in `.git/objects/pack/`. It has a `.pack` extension, and is accompanied by an index file of the same name with the `.idx` extension. Should you want to convert a packfile to loose objects format (to play with `wyag` on an existing repo, for example), here’s the solution.

First, _move_ the packfile outside the gitdir (just copying it won’t work).

mv .git/objects/pack/pack-d9ef004d4ca729287f12aaaacf36fee39baa7c9d.pack .

You can ignore the `.idx`. Then, from the worktree, just `cat` it and pipe the result to `git unpack-objects`:

cat pack-d9ef004d4ca729287f12aaaacf36fee39baa7c9d.pack | git unpack-objects
