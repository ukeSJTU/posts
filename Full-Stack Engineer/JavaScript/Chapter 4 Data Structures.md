本章讨论 objects 和 arrays。

数字、布尔值和字符串是构建数据结构的基本数据类型。不过，许多类型的信息需要多个不同类型组合在一起。object 允许我们对值（包括其他 objects）进行分组，以构建更复杂的结构。

先看数组：
``` js
let listOfNumbers = [2, 3, 5, 7, 11];
console.log(listOfNumbers[0]);
```

属性：
`.length` 获取元素数量
`.[x]` 获取第 `x+1` 个元素

方法：

针对字符串：
`.toUpperCase` 或者 `.toLowerCase`: 转换大小写：
``` js
let doh = "Doh";
console.log(typeof doh.toUpperCase);
// → function
console.log(doh.toUpperCase());
// → DOH
```

`.push` `.pop`:
``` js
let sequence = [1, 2, 3];
sequence.push(4);
sequence.push(5);
console.log(sequence);
// → [1, 2, 3, 4, 5]
console.log(sequence.pop());
// → 5
console.log(sequence);
// → [1, 2, 3, 4]
```

再看对象 object：

_object_ 类型的值是属性的任意集合。创建对象的一种方法是使用大括号作为表达式。
``` js
let day1 = {
  squirrel: false,
  events: ["work", "touched tree", "pizza", "running"]
};
console.log(day1.squirrel);
// → false
console.log(day1.wolf);
// → undefined
day1.wolf = false;
console.log(day1.wolf);
// → false
```

可以使用 `=` 运算符将值分配给属性表达式。如果属性值已经存在，这将替换该属性的值；如果不存在，则在对象上创建一个新属性。

delete 运算符：
``` js
let anObject = {left: 1, right: 2};
console.log(anObject.left);
// → 1
delete anObject.left;
console.log(anObject.left);
// → undefined
console.log("left" in anObject);
// → false
console.log("right" in anObject);
// → true
```

要找出对象具有哪些属性，可以使用 `Object.keys` 函数。给函数一个对象，它将返回一个字符串数组——对象的属性名称：

``` js
console.log(Object.keys({x: 0, y: 0, z: 2}));
// → ["x", "y", "z"]
```

`Object.assign` 函数，可以将一个对象的所有属性复制到另一个对象中：
``` js
let objectA = {a: 1, b: 2};
Object.assign(objectA, {b: 3, c: 4});
console.log(objectA);
// → {a: 1, b: 3, c: 4}
```

注意到 `typeof []`  的结果是 `object`. 数组一个专门用来存储序列化信息的特殊对象object。

## 数组循环

``` js
for (let i = 0; i < JOURNAL.length; i++) {
  let entry = JOURNAL[i];
  // Do something with entry
}
```

``` js
for (let entry of JOURNAL) {
  console.log(`${entry.events.length} events.`);
}
```



## JSON

一种流行的序列化格式称为 _JSON_（发音为“Jason”），它代表 JavaScript 对象表示法。它被广泛用作网络上的数据存储和通信格式，甚至适用于 JavaScript 以外的语言。

JSON 看起来类似于 JavaScript 编写数组和对象的方式，但有一些限制。所有属性名称都必须用双引号括起来，并且只允许简单的数据表达式 - 不允许函数调用、绑定或任何涉及实际计算的内容。 JSON 中不允许有注释。

JavaScript 为我们提供了函数 `JSON.stringify` 和 `JSON.parse` 来将数据与此格式相互转换。第一个接受 JavaScript 值并返回 JSON 编码的字符串。第二个采用这样的字符串并将其转换为它编码的值：

``` js
let string = JSON.stringify({squirrel: false,
                             events: ["weekend"]});
console.log(string);
// → {"squirrel":false,"events":["weekend"]}
console.log(JSON.parse(string).events);
// → ["weekend"]
```