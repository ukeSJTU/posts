
# Knowledge Point 知识点

## html
### `data-*` attribute

这里可以看一下 [mdn的文档](https://developer.mozilla.org/zh-CN/docs/Learn/HTML/Howto/Use_data_attributes):

语法非常简单。所有在元素上以`data-`开头的属性为数据属性。比如说你有一篇文章，而你又想要存储一些不需要显示在浏览器上的额外信息。请使用 data 属性：

``` html
<article
  id="electriccars"
  data-columns="3"
  data-index-number="12314"
  data-parent="cars">
  ...
</article>
```
#### 用`javascript`访问

在外部使用[JavaScript](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript)去访问这些属性的值同样非常简单。你可以使用[`getAttribute()`](https://developer.mozilla.org/zh-CN/docs/Web/API/Element/getAttribute "getAttribute()")配合它们完整的 HTML 名称去读取它们，但标准定义了一个更简单的方法：[`DOMStringMap`](https://developer.mozilla.org/zh-CN/docs/Web/API/DOMStringMap)你可以使用[`dataset`](https://developer.mozilla.org/zh-CN/docs/Web/API/HTMLElement/dataset "dataset")读取到数据。

为了使用`dataset`对象去获取到数据属性，需要获取属性名中`data-`之后的部分 (要注意的是破折号连接的名称需要改写为骆驼拼写法 (如"index-number"转换为"indexNumber"))。

``` js
var article = document.querySelector("#electriccars");

article.dataset.columns; // "3"
article.dataset.indexNumber; // "12314"
article.dataset.parent; // "cars"
```

> [!tip] 注意
> 
> 不要在 data attribute 里储存需要显示及访问的内容，因为一些其他的技术可能访问不到它们。另外爬虫不能将 data attribute 的值编入索引中。

每一个属性都是一个可读写的字符串。在上面的例子中，`article.dataset.columns = 5`.将会调整属性的值为 5。

为了支持 IE10 及以下的版本，你必须使用 [`getAttribute()`](https://developer.mozilla.org/zh-CN/docs/Web/API/Element/getAttribute "getAttribute()") 来访问:
``` js
var article = document.querySelector("#electriccars");

article.getAttributeNames(); // ['id', 'data-columns', 'data-index-number', 'data-parent']

article.getAttribute("data-index-number"); // "12314"
```

#### 用`css`访问

注意，data 设定为 HTML 属性，他们同样能被[CSS](https://developer.mozilla.org/zh-CN/docs/Web/CSS)访问。比如你可以通过[generated content](https://developer.mozilla.org/zh-CN/docs/Web/CSS/content)使用函数[`attr()`](https://developer.mozilla.org/zh-CN/docs/Web/CSS/attr)来显示 data-parent 的内容：

``` css
article::before {
  content: attr(data-parent);
}
```

你也同样可以在 CSS 中使用[属性选择器](https://developer.mozilla.org/zh-CN/docs/Web/CSS/Attribute_selectors)根据 data 来改变样式：

``` css
article[data-columns="3"] {
  width: 400px;
}
article[data-columns="4"] {
  width: 600px;
}
```

你可以在这个[JSBin](https://jsbin.com/ujiday/2/edit) 里看到全部演示。

Data 属性同样可以存储不断变化的信息，比如游戏的得分。使用 CSS 选择器与 JavaScript 去访问可以让你得到花俏的效果，这里你并不需要用常规的编写方案来编写代码。有关使用生成内容和 CSS 转换（[JSBin 示例](https://jsbin.com/atawaz/3/edit)）的示例，请参阅此[视频](https://www.youtube.com/watch?v=On_WyUB1gOk)。

数据值是字符串。必须在选择器中引用数值才能使样式生效。

### `<kbd>` 元素

可以参考 [mdn文档](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/kbd)：

**`<kbd>`** 元素表示一段内联文本，表示来自键盘、语音输入或任何其他文本输入设备的文本用户输入。浏览器默认等宽字体显示`<kbd>`，但这并不是 HTML 标准的一部分，并且用户自定义 css 可以覆盖这一行为。

你可以像这样使用`<kbd>`：
``` html
<p>Please press <kbd>Ctrl</kbd> + <kbd>Shift</kbd> + <kbd>R</kbd> to re-render an MDN page.</p>
```

其他元素可以结合使用`<kbd>`来表示更具体的场景：
- 将一个`<kbd>`元素嵌套在另一个`<kbd>`元素中表示实际的键或其他输入单元作为较大输入的一部分。请参阅下面的 [在输入中表示击键](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/kbd#representing_keystrokes_within_an_input)。
- 将`<kbd>`元素嵌套在[`<samp>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/samp)表示系统已回显给用户的输入。有关示例，请参阅下面的 [Echoed input](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/kbd#echoed_input)。
- 另一方面，将`<samp>`元素嵌套在`<kbd>`表示基于系统提供的文本的输入，例如菜单和菜单项的名称，或屏幕上显示的按钮的名称。请参阅下面的 [表示屏幕输入选项下](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/kbd#representing_onscreen_input_options)的示例。

`<kbd>`可以与 [`<samp>`](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/samp)嵌套，以表示基于视觉提示的各种形式的输入或输出。例如这样：
``` html
<p>I was trying to boot my computer, but I got this hilarious message:</p>

<p>
  <samp>Keyboard not found <br />Press F1 to continue</samp>
</p>

```

`<kbd>`可以嵌套，例如这样：
``` html
<p>
  Type the following in the Run dialog: <kbd>cmd</kbd><br />Then click the OK
  button.
</p>

<p>Save the document by pressing <kbd>Ctrl</kbd> + <kbd>S</kbd></p>
```

> [!note] 注意：
> 
> 你不一定需要最外层的`<kbd>`。换句话说，将其简化为仅 `<kbd>Ctrl</kbd>+<kbd>N</kbd>` 将是完全有效的。
> 
> 但是，根据你的样式表，你可能会发现进行这种嵌套很有用。

``` css
kbd > kbd {
  border-radius: 3px;
  padding: 1px 2px 0;
  border: 1px solid black;
}
```

### `<audio>`元素
参考[mdn文档](https://developer.mozilla.org/zh-CN/docs/Web/HTML/Element/audio).

## css
### `transition`和`transform`属性
这两个属性在创建平滑的动画和视觉效果方面非常有用。让我们逐一探讨:

1. Transition 属性

transition属性允许您定义元素在不同状态之间变化的方式。它可以使属性变化更加平滑,而不是突然发生。

主要参数:
- transition-property: 指定要过渡的CSS属性(例如width, color等)
- transition-duration: 过渡效果持续的时间
- transition-timing-function: 过渡效果的速度曲线
- transition-delay: 过渡开始前的延迟时间

简写语法:
```css
transition: property duration timing-function delay;
```

示例:
```css
.box {
  width: 100px;
  transition: width 2s ease-in-out;
}
.box:hover {
  width: 300px;
}
```

具体来看：

1. property（过渡属性）:
   - 可以是任何可动画的CSS属性，例如：
     - width, height, max-width, max-height
     - color, background-color
     - opacity
     - transform
     - left, top, right, bottom（对于定位元素）
     - margin, padding
     - font-size
     - border-width
   - 特殊值：
     - all：应用于所有可动画属性
     - none：不应用过渡效果

2. duration（持续时间）:
   - 以秒(s)或毫秒(ms)为单位
   - 例如：0.5s, 500ms, 2s 等

3. timing-function（时间函数）:
   - ease：默认值，慢开始，然后变快，然后慢结束
   - linear：匀速
   - ease-in：慢开始
   - ease-out：慢结束
   - ease-in-out：慢开始和慢结束
   - cubic-bezier(n,n,n,n)：自定义贝塞尔曲线
   - steps(n, start|end)：步进函数

4. delay（延迟）:
   - 以秒(s)或毫秒(ms)为单位
   - 指定过渡效果开始前的等待时间

示例扩展：

```css
.box {
  width: 100px;
  height: 100px;
  background-color: blue;
  transition: width 2s ease-in-out,
              height 2s ease 0.5s,
              background-color 1s linear;
}

.box:hover {
  width: 300px;
  height: 200px;
  background-color: red;
}
```

在这个扩展示例中：
- width会在2秒内过渡，使用ease-in-out曲线
- height会在2秒内过渡，使用ease曲线，并有0.5秒的延迟
- background-color会在1秒内线性过渡

你还可以使用逗号分隔多个过渡效果，每个效果可以有不同的持续时间、时间函数和延迟。

此外，你也可以使用`transition-property`, `transition-duration`, `transition-timing-function`, 和 `transition-delay`分别设置这些值，而不是使用简写形式。

例如：
```css
.box {
  transition-property: width, height, background-color;
  transition-duration: 2s, 2s, 1s;
  transition-timing-function: ease-in-out, ease, linear;
  transition-delay: 0s, 0.5s, 0s;
}
```

这提供了更细粒度的控制，特别是当你想为不同属性设置不同的过渡参数时。

2. Transform 属性

transform属性允许您修改元素的位置、大小、旋转等,而不影响文档流。

常用的transform函数:
- translate(): 移动元素
- scale(): 缩放元素
- rotate(): 旋转元素
- skew(): 倾斜元素

示例:
```css
.box {
  transform: translate(50px, 20px) rotate(45deg) scale(1.5);
}
```

结合使用:
transition和transform经常一起使用,创建平滑的动画效果。

示例:
```css
.box {
  width: 100px;
  height: 100px;
  background-color: blue;
  transition: transform 0.3s ease-in-out;
}
.box:hover {
  transform: scale(1.2) rotate(45deg);
}
```

这个例子中,当鼠标悬停在元素上时,它会平滑地放大并旋转。

### `text-transform`属性

text-transform属性主要用途:

1. 改变文本的大小写
2. 控制文本的显示方式，但不改变原始HTML内容

text-transform的可能值:

1. none
   - 默认值
   - 文本以原始形式显示,不做任何转换

2. capitalize
   - 将每个单词的首字母转换为大写
   - 其他字母保持不变

3. uppercase
   - 将所有字母转换为大写

4. lowercase
   - 将所有字母转换为小写

5. full-width
   - 将所有字符转换为全角形式（主要用于东亚文字排版）

示例:

```css
.normal {
  text-transform: none;
}

.capitalize {
  text-transform: capitalize;
}

.uppercase {
  text-transform: uppercase;
}

.lowercase {
  text-transform: lowercase;
}

.full-width {
  text-transform: full-width;
}
```

HTML:

```html
<p class="normal">This is normal text.</p>
<p class="capitalize">this is capitalized text.</p>
<p class="uppercase">this is uppercase text.</p>
<p class="lowercase">THIS IS LOWERCASE TEXT.</p>
<p class="full-width">This is full-width text.</p>
```

结果:
- This is normal text.
- This Is Capitalized Text.
- THIS IS UPPERCASE TEXT.
- this is lowercase text.
- Ｔｈｉｓ ｉｓ ｆｕｌｌ-ｗｉｄｔｈ ｔｅｘｔ.

注意事项:

1. capitalize只会将每个单词的第一个字母大写,而不是每个字母。

2. text-transform不会改变原始文本内容,只改变显示方式。这意味着如果你复制转换后的文本,你会得到原始文本。

3. 对于某些语言（如德语）,text-transform可能不会正确处理特殊字符。例如,"ß"在大写时应该变成"SS",但text-transform可能无法正确处理这种情况。

4. full-width主要用于东亚文字排版,将半角字符转换为全角字符,使其占用相同的宽度。

5. text-transform可以与其他文本相关的CSS属性（如font-weight, font-style等）结合使用,以获得更丰富的文本样式效果。
## javascript

### `forEach`的用法
`forEach`是`JavaScript`数组的一个内置方法,用于遍历数组中的每个元素并对其执行指定的操作。它是一种简洁、易读的遍历数组的方式。

基本语法:

```javascript
array.forEach(callback(currentValue [, index [, array]])[, thisArg])
```

参数解释:
1. `callback`: 为数组中每个元素执行的函数,可以接收三个参数:
   - `currentValue`: 数组中正在处理的当前元素
   - `index` (可选): 数组中正在处理的当前元素的索引
   - `array` (可选): `forEach`方法正在操作的数组

2. `thisArg` (可选): 执行`callback`函数时使用的`this`值

在我们的代码中：

```javascript
const keys = Array.from(document.querySelectorAll('.key'));
keys.forEach(key => key.addEventListener('transitionend', removeTransition));
```

这段代码的作用是:

1. 选择所有`class`为`'key'`的元素,并将其转换为数组
2. 对数组中的每个元素(即每个`key`)执行一个函数
3. 这个函数为每个key添加一个`'transitionend'`事件监听器,当过渡结束时调用`removeTransition`函数

`forEach`的其他使用示例:

1. 基本用法:
```javascript
const numbers = [1, 2, 3, 4, 5];
numbers.forEach(number => console.log(number));
// 输出: 1 2 3 4 5
```

2. 使用索引:
```javascript
const fruits = ['apple', 'banana', 'cherry'];
fruits.forEach((fruit, index) => {
    console.log(`${index}: ${fruit}`);
});
// 输出:
// 0: apple
// 1: banana
// 2: cherry
```

3. 修改原数组:
```javascript
const numbers = [1, 2, 3, 4, 5];
numbers.forEach((number, index, array) => {
    array[index] = number * 2;
});
console.log(numbers); // 输出: [2, 4, 6, 8, 10]
```

# 最终代码

`index.html`文件：
``` js
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>JS Drum Kit</title>
  <link rel="stylesheet" href="style.css">
  <link rel="icon" href="https://fav.farm/✅" />
</head>

<body>
  <div class="keys">
    <div data-key="65" class="key">
      <kbd>A</kbd>
      <span class="sound">clap</span>
    </div>
    <div data-key="83" class="key">
      <kbd>S</kbd>
      <span class="sound">hihat</span>
    </div>
    <div data-key="68" class="key">
      <kbd>D</kbd>
      <span class="sound">kick</span>
    </div>
    <div data-key="70" class="key">
      <kbd>F</kbd>
      <span class="sound">openhat</span>
    </div>
    <div data-key="71" class="key">
      <kbd>G</kbd>
      <span class="sound">boom</span>
    </div>
    <div data-key="72" class="key">
      <kbd>H</kbd>
      <span class="sound">ride</span>
    </div>
    <div data-key="74" class="key">
      <kbd>J</kbd>
      <span class="sound">snare</span>
    </div>
    <div data-key="75" class="key">
      <kbd>K</kbd>
      <span class="sound">tom</span>
    </div>
    <div data-key="76" class="key">
      <kbd>L</kbd>
      <span class="sound">tink</span>
    </div>
  </div>

  <audio data-key="65" src="sounds/clap.wav"></audio>
  <audio data-key="83" src="sounds/hihat.wav"></audio>
  <audio data-key="68" src="sounds/kick.wav"></audio>
  <audio data-key="70" src="sounds/openhat.wav"></audio>
  <audio data-key="71" src="sounds/boom.wav"></audio>
  <audio data-key="72" src="sounds/ride.wav"></audio>
  <audio data-key="74" src="sounds/snare.wav"></audio>
  <audio data-key="75" src="sounds/tom.wav"></audio>
  <audio data-key="76" src="sounds/tink.wav"></audio>

<script>
  function removeTransition(e) {
    if (e.propertyName !== 'transform') return;
    e.target.classList.remove('playing');
  }

  function playSound(e) {
    const audio = document.querySelector(`audio[data-key="${e.keyCode}"]`);
    const key = document.querySelector(`div[data-key="${e.keyCode}"]`);
    if (!audio) return;

    key.classList.add('playing');
    audio.currentTime = 0;
    audio.play();
  }

  const keys = Array.from(document.querySelectorAll('.key'));
  keys.forEach(key => key.addEventListener('transitionend', removeTransition));
  window.addEventListener('keydown', playSound);
</script>


</body>
</html>

```

`style.css`文件：
``` css
html {
  font-size: 10px;
  background: url('./background.jpg') bottom center;
  background-size: cover;
}

body,html {
  margin: 0;
  padding: 0;
  font-family: sans-serif;
}

.keys {
  display: flex;
  flex: 1;
  min-height: 100vh;
  align-items: center;
  justify-content: center;
}

.key {
  border: .4rem solid black;
  border-radius: .5rem;
  margin: 1rem;
  font-size: 1.5rem;
  padding: 1rem .5rem;
  transition: all .07s ease;
  width: 10rem;
  text-align: center;
  color: white;
  background: rgba(0,0,0,0.4);
  text-shadow: 0 0 .5rem black;
}

.playing {
  transform: scale(1.1);
  border-color: #ffc600;
  box-shadow: 0 0 1rem #ffc600;
}

kbd {
  display: block;
  font-size: 4rem;
}

.sound {
  font-size: 1.2rem;
  text-transform: uppercase;
  letter-spacing: .1rem;
  color: #ffc600;
}

```