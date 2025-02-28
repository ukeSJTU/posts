Access Control, Class Scope, Packages, Java API

Review

先看下面这段代码：

```java
public class Counter {
    int myCount = 0;
    static int ourCount = 0;

	void increment() {
		myCount++;
		ourCount++;
	}

    public static void main(String[] args) {
        Counter counter1 = new Counter();
        Counter counter2 = new Counter();
        counter1.increment();
        counter1.increment();
        counter2.increment();
        System.out.println("Counter 1: " + counter1.myCount + " " + counter1.ourCount);
        System.out.println("Counter 2: " + counter2.myCount + " " + counter2.ourCount);
    }
}
```

先想想这段代码什么是Fields，什么是Counter类的Methods，然后不运行代码预测代码会输出什么。

```java
int myCount = 0;
static int ourCount = 0;
```

methods:

```java
void increment() {
	myCount++;
	ourCount++;
}
```

答案：

```plaintext
Counter 1: 2 3
Counter 2: 1 3
```

如果你做对了那你可以直接跳转到这一节课要学的内容：Access Control；如果你做的不对，可以看下面一步一步的分析：

注意到class Counter有两个field，一个是static的outCount，另一个是non-static的myCount。确认了这一点让我们按照顺序在大脑里模拟代码的运行：

main是程序的入口，程序从这里开始执行：

```java
Counter counter1 = new Counter();
```

| Class Counter | Object counter1 |
| ------------- | --------------- |
| ourCount = 0 | myCount = 0 |

```java
Counter counter1 = new Counter();
Counter counter2 = new Counter();
```

| Class Counter | Object counter1 | Object counter2 |
| ------------- | --------------- | --------------- |
| ourCount = 0 | myCount = 0 | myCount = 0 |

```java
Counter counter1 = new Counter();
Counter counter2 = new Counter();
counter1.increment();
```

| Class Counter | Object counter1 | Object counter2 |
| ------------- | --------------- | --------------- |
| ourCount = 1 | myCount = 1 | myCount = 0 |

```java
Counter counter1 = new Counter();
Counter counter2 = new Counter();
counter1.increment();
counter1.increment();
```

| Class Counter | Object counter1 | Object counter2 |
| ------------- | --------------- | --------------- |
| ourCount = 2 | myCount = 2 | myCount = 0 |

```java
Counter counter1 = new Counter();
Counter counter2 = new Counter();
counter1.increment();
counter1.increment();
counter2.increment();
```

| Class Counter | Object counter1 | Object counter2 |
| ------------- | --------------- | --------------- |
| ourCount = 3 | myCount = 2 | myCount = 1 |

因此输出就会是：

```plaintext
Counter 1: 2 3
Counter 2: 1 3
```

---

Access Control

先来看个例子：
```java
public class CreditCard {
    String cardNumber;
    double expenses;

    void charge(double amount) {
        expenses = expenses + amount;
    }

    String getCardNUmber(String password) {
        if (password.equals("SECRET!3*!")) {
            return cardNumber;
        }

        return "jerkface";
    }
}
```

上面的代码看似没有问题，但是如果有人要做坏事，我们用下面的代码模拟：
```java
public class Malicious {
    public static void main(String[] args) {
        maliciousMethod(new CreditCard());
    }

    static void maliciousMethod(CreditCard card) {
        card.expenses = 0;
        System.out.println(card.cardNumber);
    }
}
```

你会发现“坏人”居然可以直接直接修改卡里面的expenses

我们需要一种语法机制来保护类内部的methods/fields。

Public vs Private:
- Public: others can use this.
- Private: only the class can use this.

public/private applies to any **field** or **method**.

还是上面这段代码：
```java
public class CreditCard {
    String cardNumber;
    double expenses;

    void charge(double amount) {
        expenses = expenses + amount;
    }

    String getCardNUmber(String password) {
        if (password.equals("SECRET!3*!")) {
            return cardNumber;
        }

        return "jerkface";
    }
}
```

我们添加access control后如下：
```java
public class CreditCard {
    private String cardNumber;
    private double expenses;

    public void charge(double amount) {
        expenses = expenses + amount;
    }

    public String getCardNUmber(String password) {
        if (password.equals("SECRET!3*!")) {
            return cardNumber;
        }

        return "jerkface";
    }
}
```

这个时候maliciousMethod就没有办法起作用了：
```plaintext
The field Creditcard.expenses is not visible
The field Creditcard.cardNumber is not visible
```

Why Access Control
- Protect private information(sorta)
- Clarify how others should use your class
- Keep implementation separate from interface

---

Class Scope




______________________________________________________________________

Packages

- Each class belongs to a package
- Classes in the same package serve a similar purpose
- Packages are just directories
- Classes in other packages need to be imported

defining packages:
```java
package path.to.package.foo;

class Foo {
	...
}
```

Using Packages:
```java
import path.to.package.foo.Foo;
import path.to.package.foo.*;
```

Example code:

```java
package parenttools;

public class BabyFood {

}
```

```java
package parenttools;

public class Baby {

}
```

```java
package adult;

import parenttools.Baby;
import parenttools.BabyFood;

public class Parent {
	public static void main(String[] args) {
		Baby baby = new Baby();
		baby.feed(new BabyFood());
	}
}
```

TODO: 这里需要更具体，包括每个文件名字，文件位置关系，如何运行等等的一个小Demo，上面的代码对于初学者可能理解有难度。

Why Packages?
- Combine similar functionality
	- `org.boston.libraries.Library`
	- `org.boston.libraries.Book`
- Separate similar names
	- `shopping.List`
	- `packing.List`

Special Packages:
All classes can "see" classes in the same package, so no import needed.

All classes "see" classes in java.lang

Example: `java.lang.String`; `java.lang.System`


---

Java API

Java includes lots of packages/classes.

you should reuse classes to avoid extra work. 你可以在这个网站看到Java23的所有的[API文档](https://docs.oracle.com/en/java/javase/23/)，原本课程pdf给的链接是指向Java6的[网址](http://java.sun.com/javase/6/docs/api/)

下面从java api里面选一些内容讲解，重在体会感受使用别人已经写好的API带来的便捷之处：

Create the array bigger than you need. Track the next "available" slot. 
这个问题其实在assignment 4中，实现`addBook`方法的时候应该有所感受。

```java
Book[] books = new Book[10];
int nextIndex = 0;

books[nextIndex] = b;
nextIndex = nextIndex + 1;
```

上面可能就是你的写法，但是如果图书馆要存储的书越来越多怎么办？不断地添加书肯定会有一次添加书的时候nextIndex超过了10，也就是说books存不下了。

Java除了最基本的Array，还有一个叫做ArrayList的数据结构。

Arraylist is a Modifiable list, which is inetrnally implemented with arrays.

Features:
- Get/put items by index
- Add items
- Delete items
- Loop over all items

上面的代码经过我们用`ArrayList`可以改写成：
```java
// Book[] books = new Book[10];
// nextIndex = 0;
ArrayList<Book> books = new ArrayList<Book>();

// books[nextIndex] = b;
// nextIndex = nextIndex + 1;
books.add(b);
```

TODO: 我觉得这个`<Book>`的范型语法对于初学者可能需要进一步的解释

```java
import java.util.ArrayList;

public class ArrayListExample {
    public static void main(String[] args) {
        ArrayList<String> strings = new ArrayList<String>();
        strings.add("Evan");
        strings.add("Eugene");
        strings.add("Adam");

        System.out.println(strings.size());
        System.out.println(strings.get(0));
        System.out.println(strings.get(1));

        strings.set(0, "Goodbye");
        strings.remove(1);

        for (int i = 0; i < strings.size(); i++) {
            System.out.println(strings.get(i));
        }

        for (String s : strings) {
            System.out.println(s);
        }
    }
}
```

运行结果：
```java
3
Evan
Eugene
Goodbye
Adam
Goodbye
Adam
```

Sets:
sets are like ArrayList, but:
- Only one copy of each object, and
- No array index

Features:
- Add objects to the set
- Remove objects from the set
- Is an object in the set?

TreeSet: Sorted (lowest to highest)
HashSet: Unordered (pseudo-random)

```java
import java.util.TreeSet;

class SetExample {
    public static void main(String[] args) {
        TreeSet<String> strings = new TreeSet<String>();

        strings.add("Evan");
        strings.add("Eugene");
        strings.add("Adam");

        System.out.println(strings.size());
        System.out.println(strings.first());
        System.out.println(strings.last());

        strings.remove("Eugene");

        for (String s : strings) {
            System.out.println(s);
        }
    }
}
```

输出结果：
```plaintext
3
Adam
Evan
Adam
Evan
```

Maps:
Stores a (key, value) pair of objects
Look up the key, get back the value

Example: Address Book, Map from names to email addresses

TreeMap: Sorted(lowest to highest)
HashMap: Unordered(pseudo-random)

```java
import java.util.HashMap;
import java.util.Map;

public class MapExample {
    public static void main(String[] args) {
        HashMap<String, String> strings = new HashMap<String, String>();
        strings.put("Evan", "email1@mit.edu");
        strings.put("Eugene", "email2@mit.edu");
        strings.put("Adam", "email3@mit.edu");

        System.out.println(strings.size());
        strings.remove(("Evan"));
        System.out.println(strings.get("Eugene"));

        for (String s : strings.keySet()) {
            System.out.println(s);
        }

        for (String s : strings.values()) {
            System.out.println(s);
        }

        for (Map.Entry<String, String> pairs : strings.entrySet()) {
            System.out.println(pairs);
        }

    }
}
```

Warnings
Using treeSet/TreeMap? Read about Comparable interface
Using HashSet/HashMap? Read about equals, hashCode methods

Note: his only matters for classes you build, not for java built-in types.

---

Assignment

In the last assignment you learned how to create your own simple objects. One of the advantages of building software using objects is that it makes it relatively easy to use software components that other people have built. In this assignment, you will use the Java's built-in graphics and containers, combined with a simple framework that we provide.

Requirements (in brief)
- Add three different shapes to the initial window we provide.
- Add three instances of the `BouncingBox` class to your window, moving in different directories. Use an `ArrayList` to hold them.

Setup
1. (Optional) Create a new project i Eclipse, with whatever name you want.
2. Create three classes: `SimpleDraw`, `BouncngBox`, and `DrawGraphics`. Coy and paste the code for these classes from below.
