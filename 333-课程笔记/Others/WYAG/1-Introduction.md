## 1. Introduction

Note

Recent changes (January 2025):

- `OrderedDict` have been replaced by regular dicts.
- Most string formatting have been replaced with f-strings.
- Multible bugs fixed in `tag_create`.

This article is an attempt at explaining the [Git version control system](https://git-scm.com/) from the bottom up, that is, starting at the most fundamental level moving up from there. This does not sound too easy, and has been attempted multiple times with questionable success. But there’s an easy way: all it takes to understand Git internals is to reimplement Git from scratch.

No, don’t run.

It’s not a joke, and it’s really not complicated: if you read this article top to bottom and write the code (or just [download it](./wyag.zip) as a ZIP — but you should write the code yourself, really), you’ll end up with a program, called `wyag`, that will implement all the fundamental features of git: `init`, `add`, `rm`, `status`, `commit`, `log`… in a way that is perfectly compatible with `git` itself — compatible enough that the commit finally adding the section on commits was [created by wyag itself, not git](https://github.com/thblt/write-yourself-a-git/commit/ed26daffb400b2be5f30e044c3237d220226d867). And all that in exactly 978 lines of very simple Python code.

But isn’t Git too complex for that? That Git is complex is, in my opinion, a misconception. Git is a large program, with a lot of features, that’s true. But the core of that program is actually extremely simple, and its apparent complexity stems first from the fact it’s often deeply counterintuitive (and [Git is a burrito](https://byorgey.wordpress.com/2009/01/12/abstraction-intuition-and-the-monad-tutorial-fallacy/) blog posts probably don’t help). But maybe what makes Git the most confusing is the extreme simplicity _and_ power of its core model. The combination of core simplicity and powerful applications often makes thing really hard to grasp, because of the mental jump required to derive the variety of applications from the essential simplicity of the fundamental abstraction (monads, anyone?)

Implementing Git will expose its fundamentals in all their naked glory.

**What to expect?** This article will implement and explain in great details (if something is not clear, please [report it](#feedback)!) a very simplified version of Git core commands. I will keep the code simple and to the point, so `wyag` won’t come anywhere near the power of the real git command-line — but what’s missing will be obvious, and trivial to implement by anyone who wants to give it a try. “Upgrading wyag to a full-featured git library and CLI is left as an exercise to the reader”, as they say.

More precisely, we’ll implement:

- `add` ([wyag source](#cmd-add)) [git man page](https://git-scm.com/docs/git-add)
- `cat-file` ([wyag source](#cmd-cat-file)) [git man page](https://git-scm.com/docs/git-cat-file)
- `check-ignore` ([wyag source](#cmd-check-ignore)) [git man page](https://git-scm.com/docs/git-check-ignore)
- `checkout` ([wyag source](#cmd-checkout)) [git man page](https://git-scm.com/docs/git-checkout)
- `commit` ([wyag source](#cmd-commit)) [git man page](https://git-scm.com/docs/git-commit)
- `hash-object` ([wyag source](#cmd-hash-object)) [git man page](https://git-scm.com/docs/git-hash-object)
- `init` ([wyag source](#cmd-init)) [git man page](https://git-scm.com/docs/git-init)
- `log` ([wyag source](#cmd-log)) [git man page](https://git-scm.com/docs/git-log)
- `ls-files` ([wyag source](#cmd-ls-files)) [git man page](https://git-scm.com/docs/git-ls-files)
- `ls-tree` ([wyag source](#cmd-ls-tree)) [git man page](https://git-scm.com/docs/git-ls-tree)
- `rev-parse` ([wyag source](#cmd-rev-parse)) [git man page](https://git-scm.com/docs/git-rev-parse)
- `rm` ([wyag source](#cmd-rm)) [git man page](https://git-scm.com/docs/git-rm)
- `show-ref` ([wyag source](#cmd-show-ref)) [git man page](https://git-scm.com/docs/git-show-ref)
- `status` ([wyag source](#cmd-status)) [git man page](https://git-scm.com/docs/git-status)
- `tag` ([wyag source](#cmd-tag)) [git man page](https://git-scm.com/docs/git-tag)

You’re not going to need to know much to follow this article: just some basic Git (obviously), some basic Python, some basic shell.

- First, I’m only going to assume some level of familiarity with the most basic **git commands** — nothing like an expert level, but if you’ve never used `init`, `add`, `rm`, `commit` or `checkout`, you will be lost.
- Language-wise, wyag will be implemented in **Python**. Again, I won’t use anything too fancy, and Python looks like pseudo-code anyways, so it will be easy to follow (ironically, the most complicated part will be the command-line arguments parsing logic, and you don’t really need to understand that). Yet, if you know programming but have never done any Python, I suggest you find a crash course somewhere in the internet just to get acquainted with the language.
- `wyag` and `git` are terminal programs. I assume you know your way inside a Unix terminal. Again, you don’t need to be a l77t h4x0r, but `cd`, `ls`, `rm`, `tree` and their friends should be in your toolbox.

Warning

**Note for Windows users**

`wyag` should run on any Unix-like system with a Python interpreter, but I have absolutely no idea how it will behave on Windows. The test suite absolutely requires a bash-compatible shell, which I assume the WSL can provide. Also, if you are using WSL, make sure your `wyag` file uses Unix-style line endings ([See this StackOverflow solution if you use VS Code](https://stackoverflow.com/questions/48692741/how-can-i-make-all-line-endings-eols-in-all-files-in-visual-studio-code-unix)). Feedback from Windows users would be appreciated!

Note

\***\*Acknowledgments\*\***

This article benefited from significant contributions from multiple people, and I’m grateful to them all. Special thanks to:

- Github user [tammoippen](https://github.com/tammoippen), who first drafted the `tag_create` function I had simply… forgotten to write (that was [#9](https://github.com/thblt/write-yourself-a-git/issues/9)).
- Github user [hjlarry](https://github.com/hjlarry) fixed multiple issues in [#22](https://github.com/thblt/write-yourself-a-git/pull/22).
- GitHub user [cutebbb](https://github.com/cutebbb) implemented the first version of ls-files in [#32](https://github.com/thblt/write-yourself-a-git/pull/32/), and by doing so finally brought wyag to the wonders of the staging area!
