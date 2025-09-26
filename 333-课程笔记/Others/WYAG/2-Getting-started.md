## 2. Getting started

You’re going to need Python 3.10 or higher, along with your favorite text editor. We won’t need third party packages or virtualenvs, or anything besides a regular Python interpreter: everything we need is in Python’s standard library.

We’ll split the code into two files:

- An executable, called `wyag`;
- A Python library, called `libwyag.py`;

Now, every software project starts with a boatload of boilerplate, so let’s get this over with.

We’ll begin by creating the (very short) executable. Create a new file called `wyag` in your text editor, and copy the following few lines:

#!/usr/bin/env python3

import libwyag
libwyag.main()

Then make it executable:

$ chmod +x wyag

You’re done!

Now for the library. it must be called `libwyag.py`, and be in the same directory as the `wyag` executable. Begin by opening the empty `libwyag.py` in your text editor.

We’re first going to need a bunch of imports (just copy each import, or merge them all in a single line)

- Git is a CLI application, so we’ll need something to parse command-line arguments. Python provides a cool module called [argparse](https://docs.python.org/3/library/argparse.html) that can do 99% of the job for us.

  import argparse

- Git uses a configuration file format that is basically Microsoft’s INI format. The [configparser](https://docs.python.org/3/library/configparser.html) module can read and write these files.

  import configparser

- We’ll be doing some date/time manipulation:

  from datetime import datetime

- We’ll need, just once, to read the users/group database on Unix (`grp` is for groups, `pwd` for users). This is because git saves the numerical owner/group ID of files, and we’ll want to display that nicely (as text):

  import grp, pwd

- To support `.gitignore`, we’ll need to match filenames against patterns like \*.txt. Filename matching is in… `fnmatch`:

  from fnmatch import fnmatch

- Git uses the SHA-1 function quite extensively. In Python, it’s in [hashlib](https://docs.python.org/3/library/hashlib.html).

  import hashlib

- Just one function from [math](https://docs.python.org/3/library/math.html):

  from math import ceil

- [os](https://docs.python.org/3/library/os.html) and [os.path](https://docs.python.org/3/library/os.path.html) provide some nice filesystem abstraction routines.

  import os

- we use _just a bit_ of regular expressions:

  import re

- We also need [sys](https://docs.python.org/3/library/sys.html) to access the actual command-line arguments (in `sys.argv`):

  import sys

- Git compresses everything using zlib. Python [has that](https://docs.python.org/3/library/zlib.html), too:

  import zlib

Imports are done. We’ll be working with command-line arguments a lot. Python provides a simple yet reasonably powerful parsing library, `argparse`. It’s a nice library, but its interface may not be the most intuitive ever; if need, refer to its [documentation](https://docs.python.org/3/library/argparse.html).

argparser = argparse.ArgumentParser(description="The stupidest content tracker")

We’ll need to handle subcommands (as in git: `init`, `commit`, etc.) In argparse slang, these are called “subparsers”. At this point we only need to declare that our CLI will use some, and that all invocation will actually _require_ one — you don’t just call `git`, you call `git COMMAND`.

argsubparsers = argparser.add_subparsers(title="Commands", dest="command")
argsubparsers.required = True

The `dest="command"` argument states that the name of the chosen subparser will be returned as a string in a field called `command`. So we just need to read this string and call the correct function accordingly. By convention, I’ll call these functions “bridges functions” and prefix their names by `cmd_`. Bridge functions take the parsed arguments as their unique parameter, and are responsible for processing and validating them before executing the actual command.

def main(argv=sys.argv[1:]):
args = argparser.parse*args(argv)
match args.command:
case "add" : cmd_add(args)
case "cat-file" : cmd_cat_file(args)
case "check-ignore" : cmd_check_ignore(args)
case "checkout" : cmd_checkout(args)
case "commit" : cmd_commit(args)
case "hash-object" : cmd_hash_object(args)
case "init" : cmd_init(args)
case "log" : cmd_log(args)
case "ls-files" : cmd_ls_files(args)
case "ls-tree" : cmd_ls_tree(args)
case "rev-parse" : cmd_rev_parse(args)
case "rm" : cmd_rm(args)
case "show-ref" : cmd_show_ref(args)
case "status" : cmd_status(args)
case "tag" : cmd_tag(args)
case * : print("Bad command.")
