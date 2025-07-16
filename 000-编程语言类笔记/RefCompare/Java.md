# Java Language Reference Comparison

```java
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello Java");
    }
}
```

## Learn the Basics

### Basic Syntax

### Lifecycle of a Program

### Data Types

### Variables and Scopes

### Type Casting

### Strings and Methods

### Math Operations

### Arrays

### Conditionals

### Loops

### Basics of OOP

## Basics of OOP

### Classes and Objects

### Attributes and Methods

TODO: below copied from https://jenkov.com/tutorials/java/fields.html#static-and-non-static-fields

A Java field is declared using the following syntax:

```plaintext
[access_modifier] [static] [final] type name [= initial value] ;
```

### Access Specifiers

Access specifiers (or access modifiers) in Java are keywords that control the visibility or accessibility of classes, methods, constructors, and other members. They determine from where these members can be accessed. Java provides four access specifiers: `private`, `default` (no keyword), `protected`, and `public`, each offering a different level of access control.

> "access modifier" is the official term for `private`, `protected` and `public` used in the [Java language specification](http://java.sun.com/docs/books/jls/third_edition/html/j3TOC.html).
> Quoted from [stackoverflow](https://stackoverflow.com/questions/2238730/what-is-the-difference-between-access-specifiers-and-access-modifiers)

Java has four different access modifiers:

- `private`
- default (package)
- `protected`
- `public`

Each of the Java access modifiers can be applied to:

|              | `private` | `default` | `protected` | `public` |
| ------------ | --------- | --------- | ----------- | -------- |
| Class        | N         | Y         | N           | Y        |
| Nested Class | Y         | Y         | Y           | Y        |
| Constructor  | Y         | Y         | Y           | Y        |
| Method       | Y         | Y         | Y           | Y        |
| Field        | Y         | Y         | Y           | Y        |

class的访问可见性是“第一道大门”，**类的可见性是前提条件**。无论你把类内部的字段、方法、构造器声明为多么开放的访问级别（如public），如果类本身对外部包不可见，那么这些声明都没有实际意义。这也可以看出来为什么类只有`default`和`public`这两种访问控制。

类似的，对于interfaces，Java interfaces are meant to specify fields and methods that are publicly available in classes that implement the interfaces. Therefore you cannot use the `private` and `protected` access modifiers in interfaces. **Fields and methods in interfaces are implicitly declared `public` if you leave out an access modifier**, so you cannot use the default access modifier either (no access modifier).

> **注意：** 接口本身的访问控制和class比较接近，上面这段文本是在讨论interface里面的fields和methods。

最后一点需要注意的是：继承的时候，访问控制只能保持不变或者扩大，不能缩小。

下面具体看一下四种访问控制符：

#### `private` access modifier

If a method a variable is marked as `private`, then only code inside the same class can access the variable, or call the method.

TODO: what about the nested classes?

However, class cannot be marked with `private` because it becomes useless since no other code can use that 'private' class.

就需要 accessor methods 来向外部提供对于内部 private fields 的访问，也就是getter和setter。

#### `default` access modifier

#### `protected` access modifier

#### `public` access modifier

### `static` Keyword

The *static* keyword means that a member – like a field or method – belongs to the class itself, rather than to any specific instance of that class. **As a result, we can access static members without the need to create an instance of an object.**

大概可以总结为以下几种用法：

#### `static` fields

A static field belongs to the class. Thus, no matter how many objects you create of that class, there will only exist one field located in the class, and the value of that field is the same, no matter from which object it is accessed.

#### `static` methods

#### `static` code block

#### `static` nested class

The main reasons for using *static* inner classes in our code are:

- grouping classes intended for use in only one place increases encapsulation.
- to bring the code closer to the only place that will use it. This increases readability, and the code is more maintainable.
- if a nested class doesn’t require any access to its enclosing class instance members, it’s better to declare it as *static*. This way, we won’t couple it to the outer class, and they won’t require any heap or stack memory.

```java
public class OuterClass {

    // 1. 外部类的私有静态变量
    private static String STATIC_OUTER_FIELD = "这是外部类的静态变量 (I am a static field)";

    // 2. 外部类的实例变量
    private String instanceOuterField = "这是外部类的实例变量 (I am an instance field)";

    // 3. 外部类的静态方法
    private static void staticOuterMethod() {
        System.out.println("外部类的静态方法被调用 (Static outer method called)");
    }

    // 4. 外部类的实例方法
    public void instanceOuterMethod() {
        System.out.println("外部类的实例方法被调用 (Instance outer method called)");
    }


    // 定义一个静态嵌套类
    public static class StaticNestedClass {

        public void accessOuterMembers() {
            System.out.println("--- 从静态内部类内部访问 ---");

            // ✅ 成功: 访问外部类的静态变量 (即使是 private)
            System.out.println("成功访问: " + STATIC_OUTER_FIELD);

            // ✅ 成功: 调用外部类的静态方法 (即使是 private)
            System.out.print("成功调用: ");
            staticOuterMethod();


            // ❌ 错误: 尝试访问外部类的实例变量
            // 下面这行代码会导致编译错误:
            // Non-static field 'instanceOuterField' cannot be referenced from a static context
            // System.out.println(instanceOuterField);

            // ❌ 错误: 尝试调用外部类的实例方法
            // 下面这行代码同样会导致编译错误
            // instanceOuterMethod();

            System.out.println("--------------------------");
        }
    }


    public static void main(String[] args) {
        // 创建静态嵌套类的实例，注意语法，不需要外部类的实例
        OuterClass.StaticNestedClass nestedObject = new OuterClass.StaticNestedClass();

        // 调用它的方法
        nestedObject.accessOuterMembers();
    }
}
```

### `final` Keyword

- When applied to a variable, it makes the variable's value constant after initialization.
- When applied to a method, it prevents the method from being overridden in a subclass.
- When applied to a class, it prevents the class from being subclassed (inherited).

#### `final` variables

**Variables marked as *final* can’t be reassigned.** Once a *final* variable is initialized, it can’t be altered.

##### primitive variables

##### reference variables

##### fields

##### parameters

#### `final` methods

#### `final` classes

**Classes marked as *final* can’t be extended.** 仅仅意味着不能被继承，但是类实例的内部仍然可以被修改。

####

### Nested Classes

### Packages

## More about OOP

### Encapsulation

### Abstraction

### Object Lifecycle

### Pass by Value / Pass by Reference

### Inheritance

### Method Overloading / Overriding

### Interfaces

### Static vs Dynamic Binding

### Initializer Block

### Method Chaining

### Enums

### Record

## Exception Handling

## Lambda Expressions

## Annotations

## Modules

## Optionals

## Dependency Injection

## I/O Operations

## File Operators

## Collections

### Array vs ArrayList

### Set

### Map

### Queue

### Dequeue

### Stack

### Iterator

### Generic Collections

## Concurrency

### Threads

### Virtual Threads

### Java Memory Model

### `volatile` keyword

## Regular Expressions

## Networking

## Date and Time

## Cryptography

## Functional Programming

### Higher Order Functions

### Functional Interfaces

### Functional Composition

### Stream API

## Build Tools

### Maven

### Gradle

### Bazel

## Web Frameworks

### Spring (Spring Boot)

### Quarkus

### Javalin

### Play Framework

## Database Access

### JDBC

### EBean

### Hibernate

### Spring Data JPA

## Logging Frameworks

### Logback

### Log4j2

### SLF4J

### TinyLog

## Testing

### JUnit

### TestNG

### REST Assured

### JMeter

### Cucumber-JVM

### Mocking -> Mockito
