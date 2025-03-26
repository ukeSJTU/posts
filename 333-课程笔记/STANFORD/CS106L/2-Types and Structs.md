Introduces the C++ type system, and how to construct your own types using structs.

## The Type System 类型系统

The **type** of a variable in C++ is the "category" of that variable, or in other words the kind of object that variable represents.

C++ is a statically typed language, meaning that:

- every variable must declare a type in the source code
- that type can't change after it's been declared.

示例代码：

```cpp
int a = 3;
std::string b = "test";

void foo(std::string c) {
	int d = 106;
	d = "hello world"; // 会导致编译错误
}
```

Each variable (`a`, `b`, `d`), parameter (`c`), and function return type (`foo`) is required to specify a type.

### Why static typing?

## Structs

### A motivating example

### Declaring and instantiating structs

### `std::pair`

## Modern Typing

### Type aliases with `using`

### Type deduction with `auto`
