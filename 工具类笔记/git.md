文件路径中如果含有中文字符，运行`git status`显示ANSI转义字符（也就是`\xxx`的格式）

```bash
> git status
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   "\350\257\276\347\250\213\347\254\224\350\256\260/SJTU/CS3611/\347\254\2542\347\253\240 \345\272\224\347\224\250\345\261\202.md"

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        CTF/
        "Lumiere\345\215\232\345\256\242\347\263\273\347\273\237/"
        Nand2Tetris/
        "\346\257\217\345\244\251\344\270\200\344\270\252linux\345\221\275\344\273\244/\345\221\275\344\273\244\345\210\206\347\261\273.md"
        "\350\257\276\347\250\213\347\254\224\350\256\260/SJTU/ICE2601/"

no changes added to commit (use "git add" and/or "git commit -a")
```

可以通过以下办法解决：

```bash
git config --global core.quotepath false
```

- `core.quotepath` 选项默认是 `true`，Git 会使用 ANSI 转义序列来显示非 ASCII 字符（即路径中的中文会被转义成 \XXX\XXX）。

- 设置 `false` 后，Git 会直接显示原始的 UTF-8 字符串。

---

