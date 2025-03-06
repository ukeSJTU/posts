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
	1. Look for `punchFace()`  in the GrandWizard class
	2. It's not there! Does GrandWizard have a parent?
	3. Look for `punchFace()` in Wizard class
	4. It's not there! Does Wizard have a parent?
	5. Look for `punchFace()` in Dude class
	6. Found it! Call `punchFace()`
	7. Deduct hp from dude1
- What Java does when it sees: `((Dude)grandWizard1).sayName();`
	1. Cast to `Dude` tells Java to start looking in `Dude`
	2. Look for `sayName()` in Dude class
	3. Found it! Call `sayName()`

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
``` java
public class MyException extends Exception {
	// ... code ...
}
```
- Or use existing exceptions: [java中的异常](https://rymden.nu/exceptions.html)

Warn 

---

I/O

---


Assignment

