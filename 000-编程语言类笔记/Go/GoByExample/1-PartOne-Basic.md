## Hello World

Our first program will print the classic “hello world” message. Here’s the full source code.

To run the program, put the code in hello-world.go and use go run.

Sometimes we’ll want to build our programs into binaries. We can do this using go build.

We can then execute the built binary directly.

## Values

Go has various value types including strings, integers, floats, booleans, etc. Here are a few basic examples.

## Variables

In Go, variables are explicitly declared and used by the compiler to e.g. check type-correctness of function calls.

## Constants

Go supports constants of character, string, boolean, and numeric values.

## For

`for` is Go's only looping construct. Here are some basic types of for loops.

## If/Else

Branching with `if` and `else` in Go is straight-forward.

There is no [ternary if](https://en.wikipedia.org/wiki/Ternary_conditional_operator) in Go, so you’ll need to use a full if statement even for basic conditions.

## Switch

_Switch_ statements express conditionals across many branches.

## Arrays

In Go, an _array_ is a numbered sequence of elements of a specific length. In typical Go code, [[slices]] are much more common; arrays are useful in some special scenarios.

## Slices

_Slices_ are an important data type in Go, giving a more powerful interface to sequences than arrays.

Check out this [great blog post](https://go.dev/blog/slices-intro) by the Go team for more details on the design and implementation of slices in Go.

## Maps

_Maps_ are Go’s built-in [associative data type](https://en.wikipedia.org/wiki/Associative_array) (sometimes called _hashes_ or _dicts_ in other languages).

## Functions

_Functions_ are central in Go. We’ll learn about functions with a few different examples.

There are several other features to Go functions. One is multiple return values, which we’ll look at next.

## Multiple Return Values

Go has built-in support for _multiple return values._ This feature is used often in idiomatic Go, for example to return both result and error values from a function.

## Variadic Functions

_[Variadic functions](https://en.wikipedia.org/wiki/Variadic_function)_ can be called with any number of trailing arguments. For example, `fmt.Printl`n is a common variadic function.

## Closures

Go supports [anonymous functions](https://en.wikipedia.org/wiki/Anonymous_function), which can form [closures](<https://en.wikipedia.org/wiki/Closure_(computer_science)>). Anonymous functions are useful when you want to define a function inline without having to name it.

## Recursion

Go supports [recursive functions](<https://en.wikipedia.org/wiki/Recursion_(computer_science)>). Here’s a classic example.

## Range over Built-in Types

_range_ iterates over elements in a variety of built-in data structures. Let’s see how to use range with some of the data structures we’ve already learned.

## Pointers

Go supports [pointers](<https://en.wikipedia.org/wiki/Pointer_(computer_programming)>), allowing you to pass references to values and records within your program.

## Strings and Runes

A Go string is a read-only slice of bytes. The language and the standard library treat strings specially - as containers of text encoded in [UTF-8](https://en.wikipedia.org/wiki/UTF-8). In other languages, strings are made of “characters”. In Go, the concept of a character is called a rune - it’s an integer that represents a Unicode code point. [This Go blog post](https://go.dev/blog/strings) is a good introduction to the topic.

## Structs

Go’s _structs_ are typed collections of fields. They’re useful for grouping data together to form records.

## Methods

Go supports _methods_ defined on struct types.

## Interfaces

_Interfaces_ are named collections of method signatures.

Additional: To understand how Go’s interfaces work under the hood, check out this [blog post](https://research.swtch.com/interfaces).

## Enums

_Enumerated types_ (enums) are a special case of [sum types](https://en.wikipedia.org/wiki/Algebraic_data_type). An enum is a type that has a fixed number of possible values, each with a distinct name. Go doesn’t have an enum type as a distinct language feature, but enums are simple to implement using existing language idioms.

## Struct Embedding

Go supports _embedding_ of structs and interfaces to express a more seamless composition of types. This is not to be confused with [//go:embed](https://gobyexample.com/embed-directive) which is a go directive introduced in Go version 1.16+ to embed files and folders into the application binary.

## Generics

Starting with version 1.18, Go has added support for _generics,_ also known as _type parameters._

## Range over Iterators

Starting with version 1.23, Go has added support for [iterators](https://go.dev/blog/range-functions), which lets us range over pretty much anything!

## Errors

In Go it’s idiomatic to communicate errors via an explicit, separate return value. This contrasts with the exceptions used in languages like Java and Ruby and the overloaded single result / error value sometimes used in C. Go’s approach makes it easy to see which functions return errors and to handle them using the same language constructs employed for other, non-error tasks.

See the documentation of the [errors package](https://pkg.go.dev/errors) and [this blog post](https://go.dev/blog/go1.13-errors) for additional details.

## Custom Errors

It’s possible to use custom types as `errors` by implementing the `Error()` method on them. Here’s a variant on the example above that uses a custom type to explicitly represent an argument error.
