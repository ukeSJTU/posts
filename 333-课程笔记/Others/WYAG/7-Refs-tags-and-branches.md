## 7. Refs, tags and branches

### 7.1. What a ref is, and the show-ref command

As of now, the only way we can refer to objects is by their full hexadecimal identifier. In git, we actually rarely see those, except to talk about a specific commit. But in general, we’re talking about HEAD, about some branch called names like `main` or `feature/more-bombs`, and so on. This is handled by a simple mechanism called references.

Git references, or refs, are probably the most simple type of things git holds. They live in subdirectories of `.git/refs`, and are text files containing a hexadecimal representation of an object’s hash, encoded in ASCII. They’re actually as simple as this:

6071c08bcb4757d8c89a30d9755d2466cef8c1de

Refs can also refer to another reference, and thus only indirectly to an object, in which case they look like this:

ref: refs/remotes/origin/master

Note

**Direct and indirect references**

From now on, I will call a reference of the form `ref: path/to/other/ref` an **indirect** reference, and a ref with a SHA-1 object ID a **direct reference**.

This section will describe the uses of refs. For now, all that matter is this:

- they’re text files, in the `.git/refs` hierarchy;
- they hold the SHA-1 identifier of an object, or a reference to another reference, ultimately to a SHA-1 (no loops!)

To work with refs, we’re first going to need a simple recursive solver that will take a ref name, follow eventual recursive references (refs whose content begin with `ref:`, as exemplified above) and return a SHA-1 identifier:

def ref_resolve(repo, ref):
path = repo_file(repo, ref)

    # Sometimes, an indirect reference may be broken.  This is normal
    # in one specific case: we're looking for HEAD on a new repository
    # with no commits.  In that case, .git/HEAD points to "ref:
    # refs/heads/main", but .git/refs/heads/main doesn't exist yet
    # (since there's no commit for it to refer to).
    if not os.path.isfile(path):
        return None

    with open(path, 'r') as fp:
        data = fp.read()[:-1]
        # Drop final \n ^^^^^
    if data.startswith("ref: "):
        return ref_resolve(repo, data[5:])
    else:
        return data

Let’s create two small functions, and implement the `show-ref` command — it just lists all references in a repository. First, a stupid recursive function to collect refs and return them as a dict:

def ref_list(repo, path=None):
if not path:
path = repo_dir(repo, "refs")
ret = dict() # Git shows refs sorted. To do the same, we sort the output of # listdir
for f in sorted(os.listdir(path)):
can = os.path.join(path, f)
if os.path.isdir(can):
ret[f] = ref_list(repo, can)
else:
ret[f] = ref_resolve(repo, can)

    return ret

And, as usual, a subparser, a bridge, and a (recursive) worker function:

argsp = argsubparsers.add_parser("show-ref", help="List references.")

def cmd_show_ref(args):
repo = repo_find()
refs = ref_list(repo)
show_ref(repo, refs, prefix="refs")

def show_ref(repo, refs, with_hash=True, prefix=""):
if prefix:
prefix = prefix + '/'
for k, v in refs.items():
if type(v) == str and with_hash:
print (f"{v} {prefix}{k}")
elif type(v) == str:
print (f"{prefix}{k}")
else:
show_ref(repo, v, with_hash=with_hash, prefix=f"{prefix}{k}")

### 7.2. Tags as references

The most simple use of refs is tags. A tag is just a user-defined name for an object, often a commit. A very common use of tags is identifying software releases: You’ve just merged the last commit of, say, version 12.78.52 of your program, so your most recent commit (let’s call it `6071c08`) _is_ your version 12.78.52. To make this association explicit, all you have to do is:

git tag v12.78.52 6071c08

# the object hash ^here^^ is optional and defaults to HEAD.

This creates a new tag, called `v12.78.52`, pointing at `6071c08`. Tagging is like aliasing: a tag introduces a new way to refer to an existing object. After the tag is created, the name `v12.78.52` refers to `6071c08`. For example, these two commands are now perfectly equivalent:

git checkout v12.78.52
git checkout 6071c08

Note

Versions are a common use of tags, but like almost everything in Git, tags have no predefined semantics: they mean whatever you want them to mean, and can point to whichever object you want, you can even tag _blobs_!

### 7.3. Lightweight tags and tag objects, and parsing the latter

You’ve probably guessed already that tags are actually refs. They live in the `.git/refs/tags/` hierarchy. The only point worth noting is that they come in two flavors: lightweight tags and tags objects.

“Lightweight” tags

are just regular refs to a commit, a tree or a blob.

Tag objects

are regular refs pointing to an object of type `tag`. Unlike lightweight tags, tag objects have an author, a date, an optional PGP signature and an optional annotation. Their format is the same as a commit object.

We don’t even need to implement tag objects, we can reuse `GitCommit` and just change the `fmt` field:

class GitTag(GitCommit):
fmt = b'tag'

And now we support tags.

### 7.4. The tag command

Let’s add the `tag` command. In Git, it does two things: it creates a new tag or list existing tags (by default). So you can invoke it with:

git tag # List all tags
git tag NAME [OBJECT] # create a new _lightweight_ tag NAME, pointing # at HEAD (default) or OBJECT
git tag -a NAME [OBJECT] # create a new tag _object_ NAME, pointing at # HEAD (default) or OBJECT

This translates to argparse as follows. Notice we ignore the mutual exclusion between `--list` and `[-a] name [object]`, which seems too complicated for argparse.

argsp = argsubparsers.add_parser(
"tag",
help="List and create tags")

argsp.add_argument("-a",
action="store_true",
dest="create_tag_object",
help="Whether to create a tag object")

argsp.add_argument("name",
nargs="?",
help="The new tag's name")

argsp.add_argument("object",
default="HEAD",
nargs="?",
help="The object the new tag will point to")

The `cmd_tag` function will dispatch behavior (list or create) depending on whether or not `name` is provided.

def cmd_tag(args):
repo = repo_find()

    if args.name:
        tag_create(repo,
                   args.name,
                   args.object,
                   create_tag_object = args.create_tag_object)
    else:
        refs = ref_list(repo)
        show_ref(repo, refs["tags"], with_hash=False)

And we just need one more function to actually create the tag:

def tag_create(repo, name, ref, create_tag_object=False): # get the GitObject from the object reference
sha = object_find(repo, ref)

    if create_tag_object:
        # create tag object (commit)
        tag = GitTag()
        tag.kvlm = dict()
        tag.kvlm[b'object'] = sha.encode()
        tag.kvlm[b'type'] = b'commit'
        tag.kvlm[b'tag'] = name.encode()
        # Feel free to let the user give their name!
        # Notice you can fix this after commit, read on!
        tag.kvlm[b'tagger'] = b'Wyag [<wyag@example.com>](mailto:wyag%40example.com)'
        # …and a tag message!
        tag.kvlm[None] = b"A tag generated by wyag, which won't let you customize the message!\n"
        tag_sha = object_write(tag, repo)
        # create reference
        ref_create(repo, "tags/" + name, tag_sha)
    else:
        # create lightweight tag (ref)
        ref_create(repo, "tags/" + name, sha)

def ref_create(repo, ref_name, sha):
with open(repo_file(repo, "refs/" + ref_name), 'w') as fp:
fp.write(sha + "\n")

### 7.5. What’s a branch?

Tags are done. Now for another big chunk: branches.

It’s time to address the elephant in the room: like most Git users, wyag still doesn’t have any idea what a branch is. It currently treats a repository as a bunch of disorganized objects, some of them commits, and has no representation whatsoever of the fact that commits are grouped in branches, and that at every point in time there’s a commit that’s `HEAD`, _ie_, the **head** commit (or “tip”) of the **active** branch.

So, what’s a branch? The answer is actually surprisingly simple, but it may also end up being simply surprising: **a branch is a reference to a commit**. You could even say that a branch is a kind of a name for a commit. In this regard, a branch is exactly the same thing as a tag. Tags are refs that live in `.git/refs/tags`, branches are refs that live in `.git/refs/heads`.

There are, of course, differences between a branch and a tag:

1.  Branches are references to a _commit_, tags can refer to any object;
2.  Most importantly, the branch ref is updated at each commit. This means that whenever you commit, Git actually does this:
    1.  a new commit object is created, with the current branch’s (commit!) ID as its parent;
    2.  the commit object is hashed and stored;
    3.  the branch ref is updated to refer to the new commit’s hash.

That’s all.

But what about the **current** branch? It’s actually even easier. It’s a ref file outside of the `refs` hierarchy, in `.git/HEAD`, which is an **indirect** ref (that is, it is of the form `ref: path/to/other/ref`, and not a simple hash).

Note

**Detached HEAD**

When you just checkout a random commit, git will warn you it’s in “detached HEAD state”. This means you’re not on any branch anymore. In this case, `.git/HEAD` is a **direct** reference: it contains a SHA-1.

### 7.6. Referring to objects: the `object_find` function

#### 7.6.1. Resolving names

Remember when we’ve created [the stupid `object_find` function](#orgdffd24d) that would take four arguments, return the second unmodified and ignore the other three? It’s time to replace it by something more useful. We’re going to implement a small, but usable, subset of the actual Git name resolution algorithm. The new `object_find()` will work in two steps: first, given a name, it will return a complete sha-1 hash. For example, with `HEAD`, it will return the hash of the head commit of the current branch, etc. More precisely, this name resolution function will work like this:

- If `name` is `HEAD`, it will just resolve `.git/HEAD`;
- If `name` is a full hash, this hash is returned unmodified.
- If `name` looks like a short hash, it will collect objects whose full hash begin with this short hash.
- At last, it will resolve tags and branches matching name.

Notice how the last two steps _collect_ values: the first two are absolute references, so we can safely return a result. But short hashes or branch names can be ambiguous, we want to enumerate all possible meanings of the name and raise an error if we’ve found more than 1.

**Short hashes**

For convenience, Git allows to refer to hashes by a prefix of their name. For example, `5bd254aa973646fa16f66d702a5826ea14a3eb45` can be referred to as `5bd254`. This is called a “short hash”.

def object_resolve(repo, name):
"""Resolve name to an object hash in repo.

This function is aware of:

- the HEAD literal
  - short and long hashes
  - tags
  - branches
  - remote branches"""
    candidates = list()
    hashRE = re.compile(r"^[0-9A-Fa-f]{4,40}$")

  # Empty string? Abort.

  if not name.strip():
  return None

  # Head is nonambiguous

  if name == "HEAD":
  return [ ref_resolve(repo, "HEAD") ]

  # If it's a hex string, try for a hash.

  if hashRE.match(name): # This may be a hash, either small or full. 4 seems to be the # minimal length for git to consider something a short hash. # This limit is documented in man git-rev-parse
  name = name.lower()
  prefix = name[0:2]
  path = repo_dir(repo, "objects", prefix, mkdir=False)
  if path:
  rem = name[2:]
  for f in os.listdir(path):
  if f.startswith(rem): # Notice a string startswith() itself, so this # works for full hashes.
  candidates.append(prefix + f)

  # Try for references.

  as_tag = ref_resolve(repo, "refs/tags/" + name)
  if as_tag: # Did we find a tag?
  candidates.append(as_tag)

  as_branch = ref_resolve(repo, "refs/heads/" + name)
  if as_branch: # Did we find a branch?
  candidates.append(as_branch)

  as_remote_branch = ref_resolve(repo, "refs/remotes/" + name)
  if as_remote_branch: # Did we find a remote branch?
  candidates.append(as_remote_branch)

  return candidates

The second step is to follow the object we found to an object of the required type, if a type argument was provided. Since we only need to handle trivial cases, this is a very simple iterative process:

- If we have a tag and `fmt` is anything else, we follow the tag.
- If we have a commit and `fmt` is tree, we return this commit’s tree object
- In all other situations, we bail out: nothing else makes sense.

(The process is iterative because it may take an undefined number of steps, since tags themselves can be tagged)

def object_find(repo, name, fmt=None, follow=True):
sha = object_resolve(repo, name)

    if not sha:
        raise Exception(f"No such reference {name}.")

    if len(sha) > 1:
        raise Exception("Ambiguous reference {name}: Candidates are:\n - " + '\n - '.join(sha)).

    sha = sha[0]

    if not fmt:
        return sha

    while True:
        obj = object_read(repo, sha)
        #     ^^^^^^^^^^^ < this is a bit agressive: we're reading
        # the full object just to get its type.  And we're doing
        # that in a loop, albeit normally short.  Don't expect
        # high performance here.

        if obj.fmt == fmt:
            return sha

        if not follow:
            return None

        # Follow tags
        if obj.fmt == b'tag':
            sha = obj.kvlm[b'object'].decode("ascii")
        elif obj.fmt == b'commit' and fmt == b'tree':
            sha = obj.kvlm[b'tree'].decode("ascii")
        else:
            return None

With the new `object_find()`, the CLI wyag becomes a bit more usable. You can now do things like:

$ wyag checkout v3.11 # A tag
$ wyag checkout feature/explosions # A branch
$ wyag ls-tree -r HEAD # The active branch or commit. There's also a # follow here: HEAD is actually a commit.
$ wyag cat-file blob e0695f # A short hash
$ wyag cat-file tree master # A branch, as a tree (another "follow")

#### 7.6.2. The rev-parse command

Let’s implement `wyag rev-parse`. The `git rev-parse` commands does a lot, but one of its use cases, the one we’re going to clone, is solving references. For the purpose of further testing the “follow” feature of `object_find`, we’ll add an optional `wyag-type` argument to its interface.

argsp = argsubparsers.add_parser(
"rev-parse",
help="Parse revision (or other objects) identifiers")

argsp.add_argument("--wyag-type",
metavar="type",
dest="type",
choices=["blob", "commit", "tag", "tree"],
default=None,
help="Specify the expected type")

argsp.add_argument("name",
help="The name to parse")

The bridge does all the job:

def cmd_rev_parse(args):
if args.type:
fmt = args.type.encode()
else:
fmt = None

    repo = repo_find()

    print (object_find(repo, args.name, fmt, follow=True))

And it works:

$ wyag rev-parse --wyag-type commit HEAD
6c22393f5e3830d15395fd8d2f8b0cf8eb40dd58
$ wyag rev-parse --wyag-type tree HEAD
11d33fad71dbac72840aff1447e0d080c7484361
$ wyag rev-parse --wyag-type tag HEAD
None
