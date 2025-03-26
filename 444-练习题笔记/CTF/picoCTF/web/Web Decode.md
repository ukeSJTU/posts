本体主要考察：

1. inspector的使用
2. base64编码解码

进入场景后先打开控制台element元素板块。我们可以在这里面审查DOM树。在index.html文件中没有看到什么有用的信息，但是页面内容提示我们继续浏览看看别的，注意到上方导航栏还有about和contact两个页面。分别点进去，contact页面上还是没什么有用的信息，但是在about页面上我们看到：

```xml
/html/body/section[1]:
<section class="about" notify_true="cGljb0NURnt3ZWJfc3VjYzNzc2Z1bGx5X2QzYzBkZWRfMDdiOTFjNzl9">
   <h1>
    Try inspecting the page!! You might find it there
   </h1>
   <!-- .about-container -->
  </section>
```

这个notify_true的内容很像我们要提交的flag内容，但是开头不太对。

再看看题目名字是 web decode 换句话说这个字符串可能是被编码过的，于是尝试用base64解码：

```python
import base64

encoded_str = "cGljb0NURnt3ZWJfc3VjYzNzc2Z1bGx5X2QzYzBkZWRfMDdiOTFjNzl9"
decoded_bytes = base64.b64decode(encoded_str)
decoded_str = decoded_bytes.decode('utf-8')

print(decoded_str)
```

如果上面python程序不太好记得话可以用linux命令行：

**编码：**

```bash
echo -n 'your_string' | base64
```

**解码：**

```bash
echo -n 'encoded_string' | base64 --decode
```

得到正确结果：

> [!tip]- 答案：
>
> ```plaintext
> picoCTF{web_succ3ssfully_d3c0ded_07b91c79}
> ```

关于base64编码以及其他编码方式补充内容：
[wikipedia-base64](https://zh.wikipedia.org/zh-cn/Base64)

### 其他常见编码方式

1. **Hex编码**：将每个字节表示为两个十六进制字符。
2. **URL编码**：用于在URL中表示特殊字符，通常用百分号（%）后跟两个十六进制数字。
3. **ASCII/Unicode编码**：将字符转换为对应的数字值。
4. **ROT13**：一种简单的字母替换加密，常用于简单的文本混淆。

### 确定编码方式

1. **观察特征**：

   - Base64通常以`=`结尾，字符集为A-Z, a-z, 0-9, +, /。
   - Hex编码仅使用0-9和A-F。
   - URL编码使用百分号。

2. **尝试解码**：使用工具或脚本尝试不同的解码方式。
3. **上下文线索**：根据字符串的使用场景或周围的文本线索，推测可能的编码方式。

对于不熟悉的编码，逐一尝试解码，并查看解码后的输出是否合理。

在命令行中，你可以使用以下工具进行编解码：

### URL编码

**编码：**

```bash
echo -n 'your_string' | jq -sRr @uri
```

**解码：**

```bash
echo -n 'encoded_string' | python3 -c "import sys, urllib.parse as ul; print(ul.unquote(sys.stdin.read().strip()))"
```

### Hex编码

**编码：**

```bash
echo -n 'your_string' | xxd -p
```

**解码：**

```bash
echo -n 'hex_string' | xxd -r -p
```
