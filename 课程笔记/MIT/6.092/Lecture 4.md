Classes and Objects

Solution to assignment 3.

```java
class Marathon {
    public static int getMinIndex(int[] values) {
        int minValue = Integer.MAX_VALUE;
        int minIndex = -1;

        for (int i = 0; i < values.length; i++) {
            if (values[i] < minValue) {
                minValue = values[i];
                minIndex = i;
            }
        }
        return minIndex;
    }

    public static int getSecondMinIndex(int[] values) {
        int secondIdx = -1;
        int minIdx = getMinIndex(values);

        for (int i = 0; i < values.length; i++) {
            if (i == minIdx)
                continue;
            if (secondIdx == -1 || values[i] < values[secondIdx])
                secondIdx = i;
        }

        return secondIdx;
    }

    public static void main(String[] arguments) {
        String[] names = { "Elena", "Thomas", "Hamilton", "Suzie", "Phil", "Matt", "Alex", "Emma", "John", "James",
                "Jane", "Emily", "Daniel", "Neda", "Aaron", "Kate" };
        int[] times = { 341, 273, 278, 329, 445, 402, 388, 275, 243, 334, 412, 393, 299, 343, 317, 265 };
        for (int i = 0; i < names.length; i++) {
            System.out.println(names[i] + ": " + times[i]);
        }
        int minIdx = getMinIndex(times);
        int secondMinIdx = getSecondMinIndex(times);
        System.out.println("The fastest runner is " + names[minIdx] + " whose time is " + times[minIdx]);
        System.out.println(
                "The second fastest runner is " + names[secondMinIdx] + " whose time is " + times[secondMinIdx]);
    }
}
=
```


Q&A也就是复习环节：
先是一些常见的问题：
Popular Issues 1:
要区分Array Index vs Array Value
```java
int[] values = {99, 100, 101};
System.out.println(values[0]);  // 99
System.out.println(values[1]);  // 100
System.out.println(values[2]);  // 101
```

99, 100, 101就是values，他们分别对应的index是0, 1, 2

Popular Issues 2:
Curly braces `{...}` after `if/else`,`for/while`

```java
for (int i = 0; i < 5; i++)
	System.out.println(“Hi”);
	System.out.println(“Bye”);
```

请你先阅读代码，猜测程序会输出什么然后运行，看看和你预想的一不一样。

TODO：给一个输出的结果，然后讲解为什么是这样的输出（5个Hi，1个Bye）。

Popular Issue 3

Popular Issue 4

Popular Issue 5
Defining a method inside a method

```java
public static void main(String[] arguments) {
	public static void foobar() {
		...
	}
}
```

Should be better written as:
```java
public static void main(String[] arguments) {
	...
}

public static void foobar() {
	...
}
```

TODO: 是不是最好将它放在method外面去，不要嵌套的定义？

Debugging Notes 1
Use System.out.println throughout your code to see what it's doing.

```java
for ( int i=0; i< vals.length; i++) {
if ( vals[i] < minVal) {
System.out.println(“cur min: ” + minVal);
System.out.println(“new min: ” + vals[i]);
minVal = vals[i];
}

}
```
Debugging Notes 2
多利用现代编辑器的自动化format功能。


Today's Topics:
- Object oriented programming
- Defining Classes
- Using Classes
- References vs Values
- Static types and methods

Object oriented programming
Represent the real world.

Baby

Baby: Name, Sex, Weight, Decibels and `# poops so far`

Objects group together:
- Primitives: int, double, char, etc...
- Objects: String, etc...

Baby:
String name
boolean isMale
double weight
double decibels
int numPoops

Why use classes?
Why not just primitives?
```java
// little baby Alex:
String nameAlex;
double weightAlex;

// little baby David
String nameDavid;
double weightDavid;
```

The code would become terrible if we have another baby called David:
```java
// little baby Alex:
String nameAlex;
double weightAlex;

// little baby David
String nameDavid;
double weightDavid;

// another little baby David
String nameDavid2;
double weightDavid2;
```

And code becomes much more messier if there are 500 babies or more.

用class的一个好处就显示出来了。我们设计一个Baby类，这个Baby类有一些属性：name，weight，sex等等。然后Alex，David都是Baby类的什么？

实际上，class 还能够带来更多的好处。封装成Nursery，一个Nursery可以有好多个Baby对象。你甚至可以给Nursery添加多个Nurse对象。

还可以多增加一个ER（emergency room），和上面的Nursery一起封装成Hospital类（？）

TODO：上面这一段文本一定需要适当调整文字表述，给初学者逐步详细地说明并解释为什么需要类这个概念。

Defining classes
Class-overview
Below is an example of class definition:
```java
public class Baby {
	String name;
	boolean isMale;
	double weight;
	double decibels;
	int numPoops = 0;

	void poop() {
		numPoops += 1;
		System.out.println("Dear mother, " + "I have pooped. Ready the diaper.")
	}
}
```
class instance:
```java
Baby myBaby = new Baby();
```

Let's declare a baby:
```java
public class Baby {
	// fieds
	
	// methods
}
```
a class is composed of two parts: fields and methods. 我们前面已经讲过methods了，需要简单讲讲fields。

Note:
1. class names are Capitalized
2. 1 class = 1 file
3. having a `main` method means the class can be run

Baby fields:
```java
public class Baby {
	TYPE var_name;
	TYPE var_name = some_value;
}
```
example
```java
public class Baby {
	String name;
	double weight = 5.0;
	boolean isMale;
	int numPoops = 0;
}
```

What about Baby siblings? Think for a second and check the answer below. Note that fields are quite similar to defining a variable with a syntax of  `TYPE var_name = some_value`.

```java
public class Baby {
	String name;
	double weight = 5.0;
	boolean isMale;
	int numPoops = 0;
	Baby[] siblings;
}
```

Ok, let's make this baby!
```java
Baby ourBbay = new Baby();
```

But what about its name? its sex?

Constructors
```java
public class CLASSNAME {
	CLASSNAME() {
	}

	CLASSNAME([ARGUMENTS]) {
	}
}

CLASSNAME obj1 = new CLASSNAME();
CLASSNAME obj2 = new CLASSNAME([ARGUMENTS]);
```

Constructors:
- Constructor name is the name of the class
- No return type - constructor should never return anything
- Constructor is usually used to initialize fields
- All classes need at least one constructor, and if you don't write one, it defaults to:
```java
CLASSNAME() {
}
```

Let's go back to the Baby example to see how to write a constructor:
```java
public class Baby {
	String name;
	boolean isMale;
	Bbay(String myname, boolean maleBaby) {
		name = myname;
		isMale = maleBaby;
	}
}
```

Baby methods
```java
public class Baby {
	String name = "Slim Shady";
	...
	void sayHi() {
		System.out.println("Hi, my name is " + name);
	}
}
```

we could also define some more methods for Baby class:(原本pdf这里第二行是`String weight = 5.0`结合后面来看应该是打错了，应该是`double`)
```java
public class Baby {
	double weight = 5.0;
	...
	void eat(double foodWeight) {
		if(foodWeight >= 0 && foodWeight < weight) {
			weight = weight + foodWeight;
		}
	}
}
```

Now we have a baby class like this:
```java
public class Baby {
	String name;
	double weight = 5.0;
	boolean isMale;
	int numPoops = 0;
	Baby[] siblings;
	
	void sayHi() {...}
	void eat(double foodWeight) {...}
}
```

Using classes:
Classes and Instances
```java
// class Definition
public class Baby {...}

// class Instances
Baby shiloh = new Baby("Shiloh Jolie-Pitt", true);
Baby knox = new Baby("Knox Jolie-Pitt", true);
```

Accessing fields:
syntax:`Object.FIELDNAME`
```java
Baby shiloh = new Baby("Shiloh Jolie-Pitt", true);

System.out.println(shiloh.name);
System.out.println(shiloh.numPoops);
```

Calling Methods:
syntax: `Object.METHODNAME([ARGUMENTS])`

```java
Baby shiloh = new Baby("Shiloh Jolie-Pitt", true);

shiloh.sayHi();
shiloh.eat(1);
```

---

References vs Values
Primitive types are basic java types:
- int, long, double, boolean, char, short, byte, float
- The actual values are stored in the variable

Reference types are arrays and objects
- String, int[], Baby(what we just learned), ...

How java stores primitives
- Variables are like fixed size cups
- Primitives are small enough that they just fix into the cup

But Objects are too big to fit in a variable.
- Stored somewhere else
- Variable stores a number that locates the object

TODO: 上面这个可能需要稍微多一点的文字解释，但是同时需要注意到这个课程面向新手，所以不要太涉及计算机底层知识。

References
the object's location is called a reference. 
`==` compares the references:
```java
Baby shiloh1 = new Baby("Shiloh");
Baby shiloh2 = new Baby("Shiloh");
```
Does `shiloh1 == shiloh2`? Before proceeding think it for yourself. 

the answer is NO. Because TODO文字解释一下。如果能让读者简单构建程序验证一下就更好了。

TODO:

---

Static types and methods

static
it is a keyword, which can be applied to fields and methods
it means that the field/method:
- is defined for the class declaration
- is not unique for each instance

Let's first see an example:
```java
public class Baby {
	static int numBabiesMade = 0;
}

Baby.numBabiesMade = 100;
Baby b1 = new Baby();
Baby b2 = new Baby();
Baby.numBabiesMade = 2;
```

What is `b1.numBabiesMade` and `b2.numBabiesMade`? Multiple choice:
A. 100 100
B. 2 2
C. 2 100
D. 100 2

TODO: correct answer and 需要解释为什么

利用这种static特性，我们可以keep track of the number of babies that have been made.
```java
public class Baby {
	static int numBabiesMade = 0;
	Baby() {
		numBabiesMade += 1;
	}
}
```

你可以分别运行上面这个和下面这个两段代码，比较输出的结果差异，体会static的作用。
```java
public class Baby {
	int numBabiesMade = 0;
	Baby() {
		numBabiesMade += 1;
	}
}
```

static method:

```java
public class Baby {
	static void cry(Baby thebaby) {
		System.out.println((thebaby.name + "cries"));
	}
}
```

OR
```java
public class Baby {
	void cry() {
		System.out.println((thebaby.name + "cries"));
	}
}
```

Static notes:
Non-static methods can reference static methods, but not the other way around. Why?

下面是原本lecture里面给的代码：
```java
public class baby {
	String name = "DMX";
	static void whoami() {
		System.out.println(name);
	}
}
```

读者可以自己利用前面学的static-method相关的知识编写代码进行测试。然后思考并回答上面的问题，下面是我的解释。
In Java, the reason **non-static methods can reference static methods**, but **static methods cannot reference non-static methods** directly, lies in how static and non-static members are tied to instances and the class itself:

  

**1. Non-static methods (Instance methods):**

• Non-static methods belong to **instances** of the class. This means that they require an **object** to be created before they can be called.

• These methods have access to both **instance variables** and **static variables/methods**. This is because non-static methods are tied to a specific instance of the class, and every instance has access to the class-level (static) members.

• A non-static method can reference static methods without any issues because static methods are shared across all instances of the class. The static method does not depend on any particular instance to be called.

  

**2. Static methods:**

• Static methods, on the other hand, belong to the **class itself** rather than to instances of the class. This means that they can be invoked without needing to create an object.

• A static method does not have access to **instance variables** or **instance methods** because it is not tied to any particular instance. Since static methods can be called without an object, there is no guarantee that any instance of the class exists when the static method is invoked.

• Static methods **cannot reference non-static methods directly** because non-static methods require an instance of the class to be called. The static method does not know which instance to refer to, as no instance might exist at the time the static method is called.

  

**Key Point:**

• **Non-static methods** are part of an instance, so they can easily access both instance-level and class-level (static) members.

• **Static methods** are part of the class itself, and they do not have a reference to any instance. Hence, they cannot access non-static members directly, as non-static members depend on specific instances, which static methods do not have.

下面是第二个思考题：why is `main` static?

如果你是初学者，你可以暂时不用完全搞懂这个问题。因为这个实际上涉及到Java程序到底是如何从一个`.java`的源代码文本文件转变成一个电脑执行的程序的。考虑到这个是初学者系列，我想给一个（有点因果倒置）的答案：

我们对上个问题的答案是：被标记为static的method是一个class所有的，而普通的methods，没有static，它是instances所有的methods，换句话说想要调用非static的method就必须先要创建一个instance才能调用。我们再回顾一下之前所有的代码，最外侧都是一个`public class CLASSNAME`的机构，显然我们并没有专门去创建`CLASSNAME`的一个instance但是代码仍然能够运行，这个从侧面反映main作为程序的入口、程序运行的起始点，是必须要static标记的。

---

Assignment 4

The libraries of SmallTownX need a new electronic rental system, and it is up to you to build it. SmallTownX has two libraries. Each library offers many books to rent. Customers can print the list of available books, borrow, and return books.


Problem

We provide two classes, Book and Library, that provide the functionality for the book database. You must implement the missing methods to make these classes work.

Step One: Implement Book

First we need a class to model books. Start by creating a class called Book. Copy and paste the skeleton below. This class defines methods to get the title of a book, find out if it is available, borrow the book, and return the book. However, the skeleton that we provide is missing the implementations of the methods. Fill in the body of the methods with the appropriate code. The main method tests the methods. When you run the program, the output should be:

```plaintext
Title (should be The Da Vinci Code): The Da Vinci Code
Rented? (should be false): false
Rented? (should be true): true
Rented? (should be false): false
```

Hint: Look at the main method to see how the methods are used, then fill in the code for each method.

Step 2: Implement Library

Next we need to build the class that will represent each library, and manage a collection of books. All libraries have the same hours: 9 AM to 5 PM daily. However, they have different addresses and book collections (i.e., arrays of Book objects).

Create a class called Library. Copy and paste the skeleton below. We provide a main method that creates two libraries, then performs some operations on the books. However, all the methods and member variables are missing. You will need to define and implement the missing methods. Read the main method and look at the compile errors to figure out what methods are missing.

Notes:

- Some methods will need to be static methods, and some need to be instance methods.
- Be careful when comparing Strings objects. Use `string1.equals(string2)` for comparing the contents of `string1` and `string2`.
- You should get a small part working at a time. Start by commenting the entire main method, then uncomment it line by line. Run the program, get the first lines working, then uncomment the next line, get that working, etc. You can comment a block of code in Eclipse by selecting the code, then choosing Source → Toggle Comment. Do the same again to uncomment it.
- You must not modify the main method.

The output when you run this program should be similar to the following:
```plaintext
Library hours:
Libraries are open daily from 9am to 5pm.

Library addresses:
10 Main St.
228 Liberty St.

Borrowing The Lord of the Rings:
You successfully borrowed The Lord of the Rings
Sorry, this book is already borrowed.
Sorry, this book is not in our catalog.

Books available in the first library:
The Da Vinci Code
Le Petit Prince
A Tale of Two Cities

Books available in the second library:
No book in catalog

Returning The Lord of the Rings:
You successfully returned The Lord of the Rings

Books available in the first library:
The Da Vinci Code
Le Petit Prince
A Tale of Two Cities
The Lord of the Rings
```

Skeleton code for Book.java:
```java
public class Book {

    String title;
    boolean borrowed;

    // Creates a new Book
    public Book(String bookTitle) {
        // Implement this method
    }

    // Marks the book as rented
    public void borrowed() {
        // Implement this method
    }

    // Marks the book as not rented
    public void returned() {
        // Implement this method
    }

    // Returns true if the book is rented, false otherwise
    public boolean isBorrowed() {
        // Implement this method
    }

    // Returns the title of the book
    public String getTitle() {
        // Implement this method
    }

    public static void main(String[] arguments) {
        // Small test of the Book class
        Book example = new Book("The Da Vinci Code");
        System.out.println("Title (should be The Da Vinci Code): " + example.getTitle());
        System.out.println("Borrowed? (should be false): " + example.isBorrowed());
        example.rented();
        System.out.println("Borrowed? (should be true): " + example.isBorrowed());
        example.returned();
        System.out.println("Borrowed? (should be false): " + example.isBorrowed());
    }
}
```

Skeleton code for `Library.java`
```java
public class Library {
    // Add the missing implementation to this class

    public static void main(String[] args) {
        // Create two libraries
        Library firstLibrary = new Library("10 Main St.");
        Library secondLibrary = new Library("228 Liberty St.");

        // Add four books to the first library
        firstLibrary.addBook(new Book("The Da Vinci Code"));
        firstLibrary.addBook(new Book("Le Petit Prince"));
        firstLibrary.addBook(new Book("A Tale of Two Cities"));
        firstLibrary.addBook(new Book("The Lord of the Rings"));

        // Print opening hours and the addresses
        System.out.println("Library hours:");
        printOpeningHours();
        System.out.println();

        System.out.println("Library addresses:");
        firstLibrary.printAddress();
        secondLibrary.printAddress();
        System.out.println();

        // Try to borrow The Lords of the Rings from both libraries
        System.out.println("Borrowing The Lord of the Rings:");
        firstLibrary.borrowBook("The Lord of the Rings");
        firstLibrary.borrowBook("The Lord of the Rings");
        secondLibrary.borrowBook("The Lord of the Rings");
        System.out.println();

        // Print the titles of all available books from both libraries
        System.out.println("Books available in the first library:");
        firstLibrary.printAvailableBooks();
        System.out.println();
        System.out.println("Books available in the second library:");
        secondLibrary.printAvailableBooks();
        System.out.println();

        // Return The Lords of the Rings to the first library
        System.out.println("Returning The Lord of the Rings:");
        firstLibrary.returnBook("The Lord of the Rings");
        System.out.println();

        // Print the titles of available from the first library
        System.out.println("Books available in the first library:");
        firstLibrary.printAvailableBooks();
    }
} 
```