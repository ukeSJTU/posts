
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


## javascript


# 最终代码

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