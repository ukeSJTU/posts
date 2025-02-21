`|`**pipe** 管道运算符
```bash
ssh myserver "journalctl | grep 'Disconnected from'" | less
```

`>`输出重定向

```bash
ls > directory_listing.txt
```

`<`输入重定向
```bash
grep "pattern" < file.txt
```