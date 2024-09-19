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

/ignore\c 在此次搜索时忽略大小写

第六讲第五节

