《图解设计模式》

# UML

我感觉得先基本了解一下 UML

http://www.omg.org/spec/uml/

## Class Diagram

类图

```java
abstract class ParentClass {
	int field1;
	static char field2;
	abstract void methodA();
	double methodB() {
		// ...
	}
}

class ChildClass extends ParentClass {
	void methodA() {
		// ...
	}
	static void methodC() {
		// ...
	}
}
```

```mermaid
classDiagram
    class ParentClass {
        <<Abstract>>
        +int field1
        +char field2$
        +methodA()* void
        +methodB() double
    }

    class ChildClass {
        +methodA() void
        +methodC()$ void
    }

    ParentClass <|-- ChildClass
```
