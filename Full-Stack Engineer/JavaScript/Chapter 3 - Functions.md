我觉得在 javascript 中 可以看成有三种写法定义函数：

第一种：

函数可以看做是一种绑定，只不过绑定的值是一个函数而不是我们前面看到过的数。

``` javascript
const square = function(x) {
	return x * x;
};

console.log(square(12));
// -> 144
```

const 函数名 = function(参数列表) { 函数体 };

请注意，花括号最后有一个分号。这是因为整体是个 const 语句。

函数可以接受参数或者不需要参数，可以有返回值也可以没有。

``` javascript
const makeNoise = function() {
  console.log("Pling!");
};

makeNoise();
// → Pling!

const roundTo = function(n, step) {
  let remainder = n % step;
  return n - remainder + (remainder < step / 2 ? 0 : step);
};

console.log(roundTo(23, 10));
// → 20
```

第二种：
和python等高级语言更为类似：

``` javascript
function square(x) {
	return x * x;
}
```

函数后面不需要分号。

像这样定义函数的话，它的作用域稍微有一点不同，但也更符合我们的直觉：
``` javascript
console.log("The future says: ", future());

function future() {
	return "You'll never have flying cars.";
}
```


函数声明不是常规的自上而下控制流的一部分。更准确地说，它们被移动到其作用域 scope 的顶部，并且可以被该作用域 scope 内的所有代码使用。

第三种：箭头函数

箭头函数使用 `=>` 而不是 `fucntion`关键字。

``` javascript
const roundTo = (n, step) => {
	let remainder = n % step;
	return n - remainder + (remainder < step / 2 ? 0 : step);
};
```

箭头位于参数列表后面，后面是函数体。它表达的是“这个输入（参数）产生这个结果（主体）”。

还有一些特殊情况的变体：

- 没有参数，参数列表就是一个空括号：
``` javascript
const horn = () => {
	console.log("Toot!");
};
```

- 函数题是单个表达式，可以不用写大括号和return关键字：
- 只有一个参数，可以省略参数列表的小括号：
``` javascript
const square = x => x * x;
```


以上就是在javascript中函数的三种写法。关于函数调用还有一点和别的语言不太一样的地方：

JavaScript 对于可以传递给函数的参数数量有着极其广泛的考虑。如果传递太多，多余的将被忽略。如果传递的参数太少，则缺失的参数将被分配值`undefined`。

``` javascript
function square(x) { return x * x; }
console.log(square(4, true, "hedgehog"));
// -> 16
```

这样显而易见带来的缺点是，你会在不知情的情况下向函数传递错误数量的参数。但是好处是这会更加灵活，并且让你利用这一特性，用不同数量的参数调用同一个函数：

``` javascript
function minus(a, b) {
  if (b === undefined) return -a;
  else return a - b;
}

console.log(minus(10));
// → -10
console.log(minus(10, 5));
// → 5
```

当然你也可以像别的高级语言一样，制定参数默认值：
``` javascript
function roundTo(n, step = 1) {
  let remainder = n % step;
  return n - remainder + (remainder < step / 2 ? 0 : step);
};
```


下面可以介绍调用堆栈的概念，解释函数运行。

然后是函数闭包的概念：closure：
``` javascript
function wrapValue(n) {
  let local = n;
  return () => local;
}

let wrap1 = wrapValue(1);
let wrap2 = wrapValue(2);
console.log(wrap1());
// → 1
console.log(wrap2());
// → 2
```
