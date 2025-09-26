## 5. Reading commit history: log

### 5.1. Parsing commits

Now that we can read and write objects, we should consider commits. A commit object (uncompressed, without headers) looks like this:

tree 29ff16c9c14e2652b22f8b78bb08a5a07930c147
parent 206941306e8a8af65b66eaaaea388a7ae24d49a0
author Thibault Polge <thibault@thb.lt> 1527025023 +0200
committer Thibault Polge <thibault@thb.lt> 1527025044 +0200
gpgsig -----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEExwXquOM8bWb4Q2zVGxM2FxoLkGQFAlsEjZQACgkQGxM2FxoL
kGQdcBAAqPP+ln4nGDd2gETXjvOpOxLzIMEw4A9gU6CzWzm+oB8mEIKyaH0UFIPh
rNUZ1j7/ZGFNeBDtT55LPdPIQw4KKlcf6kC8MPWP3qSu3xHqx12C5zyai2duFZUU
wqOt9iCFCscFQYqKs3xsHI+ncQb+PGjVZA8+jPw7nrPIkeSXQV2aZb1E68wa2YIL
3eYgTUKz34cB6tAq9YwHnZpyPx8UJCZGkshpJmgtZ3mCbtQaO17LoihnqPn4UOMr
V75R/7FjSuPLS8NaZF4wfi52btXMSxO/u7GuoJkzJscP3p4qtwe6Rl9dc1XC8P7k
NIbGZ5Yg5cEPcfmhgXFOhQZkD0yxcJqBUcoFpnp2vu5XJl2E5I/quIyVxUXi6O6c
/obspcvace4wy8uO0bdVhc4nJ+Rla4InVSJaUaBeiHTW8kReSFYyMmDCzLjGIu1q
doU61OM3Zv1ptsLu3gUE6GU27iWYj2RWN3e3HE4Sbd89IFwLXNdSuM0ifDLZk7AQ
WBhRhipCCgZhkj9g2NEk7jRVslti1NdN5zoQLaJNqSwO1MtxTmJ15Ksk3QP6kfLB
Q52UWybBzpaP9HEd4XnR+HuQ4k2K0ns2KgNImsNvIyFwbpMUyUWLMPimaV1DWUXo
5SBjDB/V/W2JBFR+XKHFJeFwYhj7DD/ocsGr4ZMx/lgc8rjIBkI=
=lgTX
-----END PGP SIGNATURE-----

Create first draft

The format is a simplified version of mail messages, as specified in [RFC 2822](https://www.ietf.org/rfc/rfc2822.txt). It begins with a series of key-value pairs, with space as the key/value separator, and ends with the commit message, that may span over multiple lines. Values may continue over multiple lines, subsequent lines start with a space which the parser must drop (like the `gpgsig` field above, which spans over 16 lines).

Let’s have a look at those fields:

- `tree` is a reference to a tree object, a type of object that we’ll see just next. A tree maps blobs IDs to filesystem locations, and describes a state of the work tree. Put simply, it is the actual content of the commit: file contents, and where they go.
- `parent` is a reference to the parent of this commit. It may be repeated: merge commits, for example, have multiple parents. It may also be absent: the very first commit in a repository obviously doesn’t have a parent.
- `author` and `committer` are separate, because the author of a commit is not necessarily the person who can commit it (This may not be obvious for GitHub users, but a lot of projects do Git through e-mail)
- `gpgsig` is the PGP signature of this object.

We’ll start by writing a simple parser for the format. The code is obvious. The name of the function we’re about to create, `kvlm_parse()`, may be confusing: it isn’t called `commit_parse()` because tags have the very same format, so we’ll use it for both objects types. I use KVLM to mean “Key-Value List with Message”.

def kvlm_parse(raw, start=0, dct=None):
if not dct:
dct = dict() # You CANNOT declare the argument as dct=dict() or all call to # the functions will endlessly grow the same dict.

    # This function is recursive: it reads a key/value pair, then call
    # itself back with the new position.  So we first need to know
    # where we are: at a keyword, or already in the messageQ

    # We search for the next space and the next newline.
    spc = raw.find(b' ', start)
    nl = raw.find(b'\n', start)

    # If space appears before newline, we have a keyword.  Otherwise,
    # it's the final message, which we just read to the end of the file.

    # Base case
    # =========
    # If newline appears first (or there's no space at all, in which
    # case find returns -1), we assume a blank line.  A blank line
    # means the remainder of the data is the message.  We store it in
    # the dictionary, with None as the key, and return.
    if (spc < 0) or (nl < spc):
        assert nl == start
        dct[None] = raw[start+1:]
        return dct

    # Recursive case
    # ==============
    # we read a key-value pair and recurse for the next.
    key = raw[start:spc]

    # Find the end of the value.  Continuation lines begin with a
    # space, so we loop until we find a "\n" not followed by a space.
    end = start
    while True:
        end = raw.find(b'\n', end+1)
        if raw[end+1] != ord(' '): break

    # Grab the value
    # Also, drop the leading space on continuation lines
    value = raw[spc+1:end].replace(b'\n ', b'\n')

    # Don't overwrite existing data contents
    if key in dct:
        if type(dct[key]) == list:
            dct[key].append(value)
        else:
            dct[key] = [ dct[key], value ]
    else:
        dct[key]=value

    return kvlm_parse(raw, start=end+1, dct=dct)

Note

**Object identity rules**

We use dictionaries (HashMaps) to store key/value associations, but we rely on a specific feature of Python dictionaries: **they preserve insertion order**. It means that when we’ll write back an object, we’ll iterate over the dictionary and get the fields back in the exact order they were added. This matters, because Git has **two strong rules about object identity**:

1.  The first rule is that **the same name will always refer to the same object**. We’ve seen this one already, it’s just a consequence of the fact that an object’s name is a hash of its contents.
2.  The second rule is subtly different: **the same object will always be referred by the same name**. This means that there shouldn’t be two equivalent objects under different names. This is why fields order matter: by modifying the _order_ fields appear in a given commit, eg by putting the `tree` after the `parent`, we’d modify the SHA-1 hash of the commit, and we’d create two equivalent, but numerically distinct, commit objects.

For example, when comparing trees, git will assume that two trees with different names _are_ different — this is why we’ll have to make sure elements of the tree objects are properly sorted, so we don’t produce distinct but equivalent trees.

We’re also going to need to write similar objects, so let’s add a `kvlm_serialize()` function to our toolkit. This is very simple: we write all fields first, then a newline, the message, and a final newline.

def kvlm_serialize(kvlm):
ret = b''

    # Output fields
    for k in kvlm.keys():
        # Skip the message itself
        if k == None: continue
        val = kvlm[k]
        # Normalize to a list
        if type(val) != list:
            val = [ val ]

        for v in val:
            ret += k + b' ' + (v.replace(b'\n', b'\n ')).replace(b'\n ', b'\n') + b'\n'

    # Append message
    ret += b'\n' + kvlm[None]

    return ret

### 5.2. The Commit object

Now we have the parser, we can create the `GitCommit` class:

class GitCommit(GitObject):
fmt=b'commit'

    def deserialize(self, data):
        self.kvlm = kvlm_parse(data)

    def serialize(self):
        return kvlm_serialize(self.kvlm)

    def init(self):
        self.kvlm = dict()

### 5.3. The log command

We’ll implement a much, much simpler version of `log` than what Git provides. Most importantly, we won’t deal with representing the log _at all_. Instead, we’ll dump Graphviz data and let the user use `dot` to render the actual log. (If you don’t know how to use Graphviz, just paste the raw output into [this site](https://dreampuf.github.io/GraphvizOnline/). If the link is dead, lookup “graphviz online” in your favorite search engine)

argsp = argsubparsers.add_parser("log", help="Display history of a given commit.")
argsp.add_argument("commit",
default="HEAD",
nargs="?",
help="Commit to start at.")

def cmd_log(args):
repo = repo_find()

    print("digraph wyaglog{")
    print("  node[shape=rect]")
    log_graphviz(repo, object_find(repo, args.commit), set())
    print("}")

def log_graphviz(repo, sha, seen):

    if sha in seen:
        return
    seen.add(sha)

    commit = object_read(repo, sha)
    message = commit.kvlm[None].decode("utf8").strip()
    message = message.replace("\", "\\\\")
    message = message.replace("\"", "\\\"")

    if "\n" in message: # Keep only the first line
        message = message[:message.index("\n")]

    print(f"  c_{sha} [label=\"{sha[0:7]}: {message}\"")
    assert commit.fmt==b'commit'

    if not b'parent' in commit.kvlm.keys():
        # Base case: the initial commit.
        return

    parents = commit.kvlm[b'parent']

    if type(parents) != list:
        parents = [ parents ]

    for p in parents:
        p = p.decode("ascii")
        print (f"  c_{sha} -> c_{p};")
        log_graphviz(repo, p, seen)

You can now use our log command like this:

wyag log e03158242ecab460f31b0d6ae1642880577ccbe8 > log.dot
dot -O -Tpdf log.dot

### 5.4. Anatomy of a commit

You may have noticed a few things right now.

First and foremost, we’ve been playing with commits, browsing and walking through commit objects, building a graph of commit history, without ever touching a single file in the worktree or a blob. We’ve done a lot with commits _without considering their contents_. This is important: work tree contents are just one part of a commit. But a commit is made of everything it holds: its contents, its authors, **also its parents**. If you remember that the ID (the SHA-1 hash) of a commit is computed from the whole commit object, you’ll understand what it means that commits are immutable: if you change the author, the parent commit or a single file, you’ve actually created a new, different object. Each and every commit is bound to its place and its relationship to the whole repository up to the very first commit. To put it otherwise, a given commit ID not only identifies some file contents, but it also binds the commit to its whole history and to the whole repository.

It’s also worth noting that from the point of view of a commit, time somehow runs backwards: we’re used to considering the history of a project from its humble beginnings as an evening distraction, starting with a few lines of code, some initial commits, and progressing to its present state (millions of lines of code, dozens of contributors, whatever). But each commit is completely unaware of its future, it’s only linked to the past. Commits have “memory”, but no premonition.

So what makes a commit? To sum it up:

- A tree object, which we’ll discuss now, that is, the contents of a worktree, files and directories;
- Zero, one or more parents;
- An author identity (name and email), and a timestamp;
- A committer identity (name and email), and a timestamp;
- An optional PGP signature
- A message;

All this hashed together in a unique SHA-1 identifier.

Note

**Wait, does that make Git a blockchain?**

Because of cryptocurrencies, blockchains are all the hype these days. And yes, _in a way_, Git is a blockchain: it’s a sequence of blocks (commits) tied together by cryptographic means in a way that guarantee that each single element is associated to the whole history of the structure. Don’t take the comparison too seriously, though: we don’t need a GitCoin. Really, we don’t.
