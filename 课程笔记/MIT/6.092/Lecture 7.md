Banner Image Description: _A refined visual of Java core features: inheritance represented as a family tree or connected class boxes, an exception symbolized by an exclamation mark inside a broken block, and a simple document icon with an arrow denoting file input/output._

---

Inheritance, exceptions, file I/O

Review of Chapter 6

Interfaces? Interfaces!

- It's a contract!
- If you must implement **ALL** the methods
- All fields are `final`, which means that it cannot be changed.

```java
public interface ICar {
	boolean isCar = true;

	int getNumWheels();
}
```

我们定义一个`class BigRig`并且实现上面这个`ICar`接口：

```java
class BigRig implements ICar {
	int getNumWheels() {
		return 18;
	}
}
```

TODO: 然后就是回顾Lecture 6的assignment，等我完成后再补充。

---

Inheritance

假设我们现在想要编写一款游戏，游戏里面有一个基础角色`Dude`

```java
public class Dude {
	public String name;
	public int hp = 100;
	public int mp = 0;

	public void sayNmae() {
		System.out.println(name);
	}
	public void punchFace(Dude target) {
		target.hp -= 10;
	}
}
```

随后我们又想创建一个新的角色类别：巫师wizard

```java
public class Wizard {
	// ...
}
```

你会发现Wizard does and has everything a Dude does and has

我们当然可以直接复制粘贴Dude的实现代码，但是有没有更好的解决办法。我们可以用继承：

Buy Inheritance!
下面的这个代码我们称Wizard 是 Dude的一个subclass 子类

```java
public class Wizard extends Dude {

}
```

通过上面的这个代码，我们就可以创建一个Wizard对象：wizard1

- Wizard can use everything the Dude has
- Wizard can do everything Dude can do!
- You can use a Wizard like a Dude too
  需要注意的是这个everything: except for **private** fields and methods

```java
wizard1.hp += 1;
wizard1.punchFace(dude1);
dude1.punchFace(wizard1);
```

TODO: 上面的三个知识点最好和下面的三行代码有更好的对应关系

Now augment a Wizard

```java
public class Wizard extends Dude {
	ArrayList<Spell> spells;
	public class cast(String spell) {
		// cool stuff here
		mp -= 10;
	}
}
```

Inheriting from inherited classes
是的，我们还可以接着继承并创建新的子类：
What about a Grand Wizard?

```java
public class GrandWizard extends Wizard {
	public void sayName() {
		System.out.println("Grand wizard" + name);
	}
}

grandWizard1.name = "Flash";
grandWizard1.sayName();
((Dude)grandWizard1).sayName();
```

TODO: 这里需要补充小问题，让读者思考上面代码的输出结果。可以提示`(Dude)`这个是Lecture 6里面学过的cast用法。

How does Java do that?

- What Java does when it sees: `grandWizard1.punchFace(dude1);`
  1.  Look for `punchFace()` in the GrandWizard class
  2.  It's not there! Does GrandWizard have a parent?
  3.  Look for `punchFace()` in Wizard class
  4.  It's not there! Does Wizard have a parent?
  5.  Look for `punchFace()` in Dude class
  6.  Found it! Call `punchFace()`
  7.  Deduct hp from dude1
- What Java does when it sees: `((Dude)grandWizard1).sayName();`
  1.  Cast to `Dude` tells Java to start looking in `Dude`
  2.  Look for `sayName()` in Dude class
  3.  Found it! Call `sayName()`

What's going on?
我们先编写了一个类叫做Dude，然后继承它并创建了Subclass of Dude: Wizard, Thief, Elf等等。随后我们还可以继承Wizard class得到Subclass of Wizard: Grand Wizard

TODO：上面这个可以补充一个图片/ASCII-style art说明

一个类只能继承一个类
读者可以先简单思考一下为什么

接着用上面的的例子来说明。Thief和Elf都继承Dude这个类。如果这个时候创建一个Bad Elf类同时继承了Thief和Elf，这是不可行的。因为假如Thief和Elf都实现了一个method：`public void sneakUp()`然后我们对Bad Elf的一个对象实例调用`sneakUp()`最终会调用Thief还是Elf的`sneakUp()`方法呢？Java没有办法确定。因此Java中一个类只能继承一个类。

Inheritance Summary

- class A extends B {} means that A is a subclass of B
- A has all the fields and methods that B has
- A can add it's own fields and methods
- A can only have 1 parent
- A can replace a parent's methods by re-implementing it
- If A doesn't implement something, Java searches ancestors

So much more to lean: 下面是一些补充的学习资料链接

- [java-sun](http://java.sun.com/docs/books/tutorial/java/IandI/subclasses.html)
- [cogeco](http://home.cogeco.ca/~ve3ll/jatutor5.htm)
- [wikipedia](https://en.wikipedia.org/wiki/Inheritance_(computer_science)
- [google](https://www.google.com/)

TODO: 上面的链接可能需要更新/调整

---

Exceptions

Examples of Exceptions:

- `NullPointerException`
- `ArrayindexOutOfBoundsException`
- `ClassCastException`
- `RuntimeException`

TODO: 应该为上面的四种常见Exception补充示例代码以及示例输出

What is an "Exception"?
Event that occurs when something "unexpected" happens, for example:

- `null.someMethod();`
- `(new int[1])[1] = 0;`
- `int i = "string";`
  TODO: 上面的三个代码应该稍微解释一下所谓的unexpected体现在哪里。

Why use an Exception?

- To tell the code using your method that something went wrong
  例如：

```java
public class RuntimeException {
    public static void main(String[] args) {
        int array[] = new int[4];
        System.out.println(array[5]);
    }
}
```

Running the program above would trigger the exception:

```plaintext
Exception in thread "main"
	java.lang.ArrayIndexOutOfBoundsException: Index 6 out of bounds for length 5
        at RuntimeException.main(RuntimeException.java:5)
```

- Debugging and understanding control flow

How do exceptions "happen"?
Java doesn't know what to do, so it:

- Creates an Exception object
- Includes some useful information
- "throws" the Exception

You can create and throw Exceptions too，例如下面这样

Public class Exception

- `Exception` is a class
- Just inherit from it!

```java
public class MyException extends Exception {
	// ... code ...
}
```

- Or use existing exceptions: [java中的异常](https://rymden.nu/exceptions.html)

Warn Java about the Exception

```java
public Object get(int index) throws
	ArrayOutOfBoundsException {
		if(index < 0 || index >= size())
			throw new ArrayOutOfBoundsException(""+index);
}
```

TODO: 上面的程序需要调整？

- `throws` tells Java that `get` may throw the ArrayOutOfBoundsException
- `throw` actually throws the Exception

Catching an Exception
Java now expects code that calls `get` to deal with the exception by

- Catching it
- Rethrowing it

Catching it
What it does

- `try` to run some code that may throw an exception
- Tell Java what to do if it sees the exception(`catch`)

```java
try {
	get(-1);
} catch (ArrayOutOfBoundsException err) {
	System.out.println("oh dear!");
}
```

Rethrowing it

- Maybe you don't want to deal with the Exception
- Tell Java that your method throws it too

```java
void doBad() throws ArrayOutOfBoundsException {
	get(-1);
}
```

TODO：下面补充一下这个Rethrowing it的机制，可以考虑ASCII art
先执行main函数，main函数去调用doBad函数，doBad函数调用get(-1)，此时触发ArrayOutOfBoundsException异常。然后一直向上返回，直到最终达到main函数也没有被捕获（catch），就彻底终止程序。

What if no one catches it?

If you run:

```java
public static void main(String[] args) throws Exception {
	doBad();
}
```

Java will print that error message you see:

```plaintext
Exception in thread "main"
java.lang.ArrayIndexOutOfBoundsException: -1
	at YourClass.get(YourClass.java:50)
	at YourClass.doBad(YourClass.java:11)
	at YourClass.main(YourClass.java:10)
```

More Info?

- [java官方文档](http://java.sun.com/docs/books/tutorial/essential/exceptions)
- [wikipedia维基百科](https://en.wikipedia.org/wiki/Exception)

---

I/O

We've seen output

```java
System.out.println("some string");
```

那么Java怎么接受用户的输入呢？

先看看The Full Picture来了解Java中和处理输入相关的部分：

Hard drive以及Network等等输入进来变成一串01的二进制。这个是InputStream

然后转换成'O', 'k', 'a' 'y'等等，这一步是InputStreamReader

最后转换成"Okay awesome cool\n"等等，这一步是BufferedReader

InputStream

- InputStream is a stream of bytes: Read one byte after another using `read()`
- A byte is just a number
  - Data on your hard drive is stored in bytes
  - Bytes can be interpreted as characters, numbers ...

```java
InoutStream stream = System.in;
```

InputStreamReader

- Reader is class for character streams: Read one character after another using `read()`
- InputStreamReader takes an InputStream and converts bytes to characters
- Still inconvenient: Can only read a character at a time

```java
new InputStreamReader(stream);
```

BufferedReader

- BufferedReader buffers a character stream so you can read line by line

`String readLine()`

```java
new BufferedReader(new InputStreamReader(System.in));
```

User Input

```java
InputStreamReader ir = new InputStreamReader(System.in);
BufferedReader br = new BufferedReader(ir);

br.readLine();
```

FileReader

- FileReader takes a text file:

  - Converts it into a character stream
  - FileReader("PATH TO FILE");

- Use this + BufferedReader to read files

```java
FileReader fr = new FileReader("readme.txt");
BufferedReader br = new BufferedReader(fr);
```

```java
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class ReadFile {
    public static void main(String[] args) throws IOException {
        // Path names are relative to project directory (Eclipse Quirk)
        FileReader fr = new FileReader("readme.txt");
        BufferedReader br = new BufferedReader(fr);
        String line = null;
        while ((line = br.readLine()) != null) {
            System.out.println(line);
        }
        br.close();
    }
}
```

TODO: 这里没有懂为什么要IOException？

More about I/O:
[java官方文档](http://java.sun.com/docs/books/tutorial/essential/io/)

---

Assignment
Assignment 7: Magic Squares
A magic square of order `n` is an arrangement of `n*n` numbers, usually distinct integers, in a square, such that the `n` numbers in all rows, all columns, and both diagonals sum to the same constant. (see Wikipedia: [Magic Square](https://en.wikipedia.org/wiki/Magic_square))

Checking the row values
We give you two text files: Mercury.txt and Luna.txt. For each file: open the file, and check that all rows indeed sum to the same constant.

Hints
Copy both text files to the root directory of your project. This is the directory that contains the src folder. Alternative:
Use absolute paths to the files (c:\somedir\Mercury.txt on Windows or /Users/myuser/Mercury.txt on Mac)
You will need to handle or rethrow IOException
Read the files line by line as explained during the lecture today.
Use ... = myLine.split("\t"); to break apart each line at the tab character, producing an array of String (String[]),
each containing one value. Consult the Java API reference for String.split).
Finally, use ... = Integer.valueOf(substring); to transform each string value into an integer value.

TODO: 这里提到了`valueOf`我想知道和`parseInt`的区别是什么。

Optional Part: Column / Diagonal Values
Optionally, try to check that the columns and the diagonal also sum to the same constant. This is slightly trickier!
