# posts

## Scripts

`.scripts/`文件夹包含了一些自动的脚本，可以通过`make link`命令来创建符号链接，`make check`检查脚本是否存在。

1. `prepare-commit-msg`:自动生成一个`vault bakcup: {{%Y-%m-%d %H:%M:%S}}`格式的提交信息。
2. `pre-commit`:在提交之前利用`prettier`格式化 markdown 文件。
3. `pre-push`:让用户手动选择哪些 commit 需要 squash。
