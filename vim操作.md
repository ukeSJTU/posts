h 左
j 下
k 上
l 有

0 行首
$ 行尾

w word
e end

i 进入插入模式，用户可以正常编辑文本 insert

a 在光标后进入插入模式 append
A 在行尾后进入插入模式 append

% 当光标处于一个括号上时，跳转到与之匹配的括号

x 删除光标上的字符
r char 用 char 替代光标上字符 replace
R 连续替换多个字符，换句话说替换后可以继续替换后面的字符

u 撤销上一步操作 undo
U 撤销上一次对一行的操作

d motion 删除内容 delete 
dd 删除整行（并且内容存入 vim 的寄存器）
dw dnw de d$

p 复制？光标后（如果整行删除，则在光标下方新添加一行） paste

c motion 删除光标后面的内容并且进入 insert 模式 change?
cw ce c$ 


G 跳转到最后一行 goto
gg 跳转到第一行
ctrl+G 显示光标所在行位置和文件信息
345G 跳转到第345行（注意大写）


/foobar 在文件中从光标向后查询 foobar
?foobar 在文件中从光标前查询 foobar
n 移动光标到下一个（如果是?向前查询则是上一个）侯选项 next
ctrl + o 上一个候选项
ctrl + i 会跳转到较新的位置（没看懂什么意思 ｜ 不确定是否需要大写）

:s/old/new 只改变光标所在行的第一个匹配串
:s/old/new/g 替换全行的匹配（old -> new）global

:#,#s/old/new/g   替换两行之间出现的每个匹配串，其中 #,# 代表的是替换操作的若干行中首尾两行的行号。

:%s/old/new/g     则是替换整个文件中的每个匹配串。
:%s/old/new/gc    会找到整个文件中的每个匹配串，并且对每个匹配串提示是否进行替换。

:s/old/new/c 只改变光标所在行的第一个匹配串并且提示是否进行替换。 confirm

: 让用户进入命令模式
:! 执行外部 shell 命令（vimtutor举的例子是ls/dir，我好像不能执行cd，）（!允许用户执行shell命令，而不仅仅是vim命令）

v 让用户进入可视模式并选择文本 visual

v motion :w filename 按v进入可视模式，motion操作（例如hjkl）选择并自动高亮被选择的文本，然后按下 `:`，应当看到左下角`:'<,>'`，然后输入w代表write 空格后面是 文件名。这会把选中的文本写入到filename这个文件中去。

:r filename 读取filename文件中内容并且导入到光标所在位置 read
:r !ls 可以读取在shell中执行ls的结果并导入到光标所在位置

o 在光标下方打开新的一行，并进入插入模式 open?不确定
O 在光标上方打开新的一行，并进入插入模式

y 复制被选中的内容
yw y3e
p 粘贴

:set ic 搜索时忽略大小写 ignore case
:set hlsearch 搜索结果高亮（在回车键入搜索pattern后）
:set incsearch 渐进式高亮（一个一个字符随着用户键入pattern高亮）
:set noic 搜索时大小写严格
:set nohlsearch 关闭搜索结果高亮
:set noincsearch 关闭渐进式高亮

:set xxx 可以设置 xxx 选项。
:set noxxx 相当于关闭 xxx 选项。

'ic' 'ignorecase'       查找时忽略字母大小写
'is' 'incsearch'        查找短语时显示部分匹配
'hls' 'hlsearch'        高亮显示所有的匹配短语

选项名可以用完整版本，也可以用缩略版本。
     
/ignore\c 在此次搜索时忽略大小写



以上内容从 vimtutor 整理而得，这是可以上手 vim 编辑器最基本的命令操作。

以下内容则是根据 pratical vim edition2 书中提炼而出

# Part1 Modes
vim 中有个概念叫做 modes 模式，在不同模式下按同一个键效果不一样。比如normal modes按下x是删除当前光标所在的字符，而在insert modes下则是输入x字符
## chapter 2 normal mode
在normal mode下，许多命令都可以通过在前面添加一个数字来重复运行，例如w是移动到下一个单词首字母，那么5w就是向后5个单词。

### tip7 pause with Your Brush Off the Page
为什么我们需要normal mode？作者举例：正如画家也并不总是在画画，他们也需要时间构图，调色等，程序员也并不总是在写程序，更多时候你可能是在阅读代码，思考下面该写什么，甚至哪怕当你开始写代码了你也不一定要进入insert mode，你完全可以从别的地方复制/重构/删除代码。

### tip8 chunk your undos
在别的文本编辑器中，undo指令（一般是ctrl+z）会撤销对于最后输入/更改的单词/赐福。但是在vim中，我们可以控制undo命令的颗粒度。

我认为想要理解undo的颗粒度，换句话说undo命令会revert最近的一次修改，但是一次修改指的是什么？这包括从normal，visual，command-line三种模式下触发的命令，也包括在insert模式下插入的text内容，例如 i{insert some text}<\Esc> 就是一次change。

至于多久需要退出一次insert mode就见仁见智了，这纯粹是个人喜好问题。例如当你在insert mode下输入写完一行内容你想要换行，有的人会esc先退出到normal mode下再按o开启新的一行，有的人则直接CR回车。

值得注意的是，在insert mode下如果你用方向键控制光标移动，这会另外新建一个undo chunk。

### tip9 compose repeatable changes
vim 针对重复的操作做了大量优化，例如 `.` 可以重复执行上一次操作。那么为了能够最大限度的利用这一特性，我们需要着重考虑我们如何构成可重复的编辑/改变 changes。

下面举了一个例子：
初始文本内容是 The end is nigh, 光标位于最后一个h上面，假设我们想要删除最后一个单词：nigh 该怎么做？

方法一：db
db **d**elete to the **b**eginning of the word, 但是这个产生的结果是 The end is h, 我们需要再按下x来删除残余的h字符
3步

方法二：dw
先按b将光标移到nigh单词首字母上，然后dw命令删除整个单词。
3步

方法三：daw
d + aw：delete a word
这里的aw是一个text object，后续在 tip52和53再详细讨论。目前只知道它和前面的dw db中的w/b不太一样，它们是motion。
3步

上面的三种方法用同样的按键数实现了相同的效果，那么有没有区别呢？有的，回到最一开始我们说我们要最大限度的利用vim的重复操作便捷性，我们考虑重复上一操作： `.`

对于方法一而言，. 命令会重复执行x
对于方法二而言，. 命令会重复执行dw，但是我们仍然需要b来调整光标位置
对于方法三而言，. 命令会重复执行daw，相当于一个按键执行三个按键，非常好！

### tip10 use count to do simple arithmetics
在vim的normal-mode中，有很多命令可以通过在前面增加count来重复执行命令制定次数，例如3j是乡下移动三行，等等。

vim中还有一对很有趣的命令：当光标位于一个数字上时，ctrl-a会+1， ctrl-x会-1.两者结合在一起：光标位于数字9上，在normal mode下输入5ctrl-x会得到4（9-5=4）。

值得注意的是 vim 是对数整体处理的，而不是一个一个数字的计算，例如文本中有一个123，光标位于2上，按下99ctrl-a，结果会是123-99=24

但如果光标根本不在数字上呢？根据文档，:h ctrl-a, vim会向后找到第一个数字并进行处理。作者提供了一个例子，我简化一下：
初始文本（这是一段css，光标位于第一个字符上）

``` css
.blog { background-position: 0px 0px }
```

想要改成：
``` css
.blog { background-position: 0px 0px }
.news { background-position: -180px 0px }
```

很显然，整个修改过程应该要分成三步：先复制粘贴行，然后修改blog->news，最后数字0改成-180.

第一步很简单：yyp 就可以，光标移动到了第二行第一个字符上`.`。
第二步：cW.news Esc. c


### tip12 combine and conquer
这一节的核心要点在于：`{operator}+{motion}={action}`。常用的`operator`如下：

| 按键   | 效果                                                |
| ---- | ------------------------------------------------- |
| `c`  | change                                            |
| `d`  | 删除                                                |
| `y`  | yank                                              |
| `g~` | 切换大小写                                             |
| `gu` | 小写                                                |
| `gU` | 大写                                                |
| `>`  | 向右移动                                              |
| `<`  | 向左移动                                              |
| `=`  | autoindent                                        |
| `!`  | Filter {motion} lines through an external program |

motion 就是要将前面的 operator操作用到什么上：
比如`3w`就是后面三个单词，`ap`是段落，等等。
`$ 0 hjkl aw ap`

你现在可以充分自由组合这些，例如：`gUap` 让当前段落全部大写。

还有一点值得注意：在 vim 中，重复按 `{operator}` 相当于motion对象 就是当前行。例如`yy`或者`dd`分别是复制/删除当前行。但是请注意：将当前行全部小写是`guu`而不是`gugu`，原因见下：

上面的 `{operator}` 中有三个都是 `g` 开头的，你可以把它们理解为 namespace 这样的概念。vim 除了自带的这些operator之外还支持自定义operator，我们后面就会看到，但是键盘上按键数量，所以为了能让用户使用更多 operator， g 相当于告诉vim这是拓展的按键，后面的u不代表undo，而是和g结合起来，作用是小写某些（由`{motion}`决定）字符。

vim 还允许你自定义 operator 和 motion，你可以通过 `:h :map-operator` 和 `:h omap-info` 查看文档。

那么在你按下 operator 之后，按下 motion 之前 vim 在干什么呢？实际上，vim 还有一种模式：operator-pending mode。在这个状态下，它一直等待你按下 motion 以执行操作，当然你也可与你按esc取消这次操作。值得注意的是，我们前面提到的`gu`这些命令，g不会进入 operator-pending mode, 毕竟g本身并不是operator，只有和别的例如u组合在一起才有意义。

## chapter 3 insert mode
对于很多初学者而言，也正如我们前面提到的各种快捷键/命令，想要执行复制/删除等等操作总是需要退出到 normal mode 下才可以用。这就有时候让人感觉很麻烦。在本chapter中，实际上你在 insert mode 下，也可以通过某些按键轻松做到。

在本章，你还会学到如何在vim中方便地输入不在键盘上的键。

replace mode 是 insert mode 的一种特殊情况，前面我们提到，当你按下`r`的时候，再按下某个字符，就会将当前字符替换成后者。中间经过的一个模式就是replace mode。我们还会学习 insert normal mode 这一子模式（sub-mode），它允许我们触发一个normal mode下的命令但不会进入 insert mode。（TODO 不知道是否翻译正确：原文：We’ll also meet Insert Normal mode, a sub- mode that lets us fire a single Normal mode command before dropping us back into Insert mode.）

我们还会深度讨论自动补全（autocompletion）。

### tip13 在insert模式下立即作出修改
在 insert 模式下输入的时候，打错字是很常有的情况。例如下面，当你输入完后，你发现你把`main`拼写成`mian`。

``` plaintext
int mian
```

如果你什么都不懂，你大概率会是这个流程：`<Esc>`退出insert mode，移动光标到单词开头，然后`dw`删除这个单词，再`i`进入insert mode，最后重新输入正确拼写的单词：`main`。当然`cw`也是可以的。可是无论怎样，这样的流程总是包含：`insert -> normal -> insert`模式的切换。有没有更方便的操作呢？


| 按键          | 作用       |
| ----------- | -------- |
| `backspace` | 向前删除一个字符 |
| `<ctrl - h` | 向前删除一个字符 |
| `<ctrl - w` | 向前删除一个单词 |
| `<ctrl - u` | 向前删除到行首  |

> [!tip] 提示：
> 上面这些命令不仅仅可以在 vim （insert mode）中使用，你也可以在vim的command mode下甚至是shell环境中使用。

### tip14 返回 normal mode
初学者可能会使用 `<Esc>` 从 insert 退出到 normal mode中。但很快你会发现这并不方便，`<Esc>`这个键离我们的常用打字区域太远了。于是有些人会修改键盘键位映射，将`Capslock`键映射成`<Esc>`键，这样当你按下`Capslock`的时候，vim会从insert mode退出到normal mode下。

> **重新映射`<Capslock>`键**
> 
> 我们知道jk在normal mode下分别是将光标向下移动或者向上移动一行。但如果你不小心按到了`<Capslock>`键，相当于你输入了J或者K，前者会将当前行和下一行拼接在一起，后者会查看当前光标所在的单词的说明页（manpage）。这可能会在不经意间打乱你的文本，所以有些人会将`<Capslock>`映射到别的键，最常见的就是`<Esc>`(我们前面提到的)或者`<Ctrl>`键。
> 
> 一般来说，这个映射是发生在操作系统层面的，也就是说你最好google搜索如何在**你的**操作系统上映射键。并且因为这个重新映射是发生在操作系统层面的，这意味着你所有的键盘使用都是被重新映射过的，而不仅仅是在vim中。

实际上你还有些别的方法：vim内置了`ctrl-[`来起到相同的作用。有些人会配置快捷键`jj`或者`jk`来快速退出。

但这些都避免不了一个问题：有的时候我在insert mode下想要执行一个normal mode中的命令，但是执行完以后我希望接着编辑文本，如果退出了insert mode我仍然需要按i重新进入insert mode下，甚至可能还需要调整光标所在位置，vim特意为此设置了一个子模式：insert normal mode模式。


| 按键         | 效果                   |
| ---------- | -------------------- |
| `<Esc>`    | 切换到 normal 模式        |
| `<ctrl-[>` | 切换到 normal 模式        |
| `<ctrl-o>` | 切换到 insert normal 模式 |

insert normal mode是normal mode的一个特殊情况。它允许我们在这个模式下触发一次normal mode中的命令，然后就会自动回到 insert mode 下，允许我们继续编辑。例如，`zz`命令可以将当前行移动到屏幕正中间，所以当你想要写着写着想要看看下方是什么内容的时候可以组合按键：`<ctrl-o>zz`。

TODO 也许应该有个更好的标题：paste from a register without leaving insert mode
### tip15 在不离开insert模式的前提下从寄存器粘贴
我们之前学习的vim 中的yank和put操作都是在normal mode下进行的，但如果我们想要在insert mode下进行put操作该怎么办呢？

我们来看一个具体情景：
``` plaintext
Practical Vim, by Drew Neil
Read Drew Neil's
```

期望的最终结果是：
``` plaintext
Practical Vim, by Drew Neil
Read Drew Neil's Practical Vim
```

操作步骤：
- `yt,`
- `jA<Space>`
- `Ctrl-r0`
- `.<Esc>`

