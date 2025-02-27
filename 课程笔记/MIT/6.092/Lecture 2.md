More types, Methods, Conditionals
Outline:
- Lecture 1 Review
- More types
- Methods
- Conditionals

<下面这里就是lecture 1的回顾>应该根据lecture1的标题heading设置关联。

主要回顾了types, variables, operators.

然后展示了gravityCalculator作业的答案代码。

```java
public class GravityCalculator {
    public static void main(String[] args) {
    double gravity = -9.81;
    double initialVelocity = 0.0;
    double fallingTime = 10.0;
    double initialPosition = 0.0;
    double finalPosition = .5 * gravity * fallingTime *
    fallingTime;
    
    finalPosition = finalPosition +
    
    initialVelocity * fallingTime;
    finalPosition = finalPosition + initialPosition;
    System.out.println("An object's position after " +
    fallingTime + " seconds is " +
    finalPosition + "m.");
    }  
}
```

这里提到了： finalPosition = finalPosition + initialVelocity * fallingTime; finalPosition = finalPosition + initialPosition; OR finalPosition += initialVelocity * fallingTime; finalPosition += initialPosition;

有两种写法。

Q&A环节。然后开始新的lecture2内容。

More Types.

Division: division operates differently on integers and on doubles.

```java
double a = 5.0 / 2.0; // a = 2.5
int b = 4 / 2; // b = 2
int c = 5 / 2; // c = 2
double d = 5 / 2; // d = 2.0
```

Order of Operations:
Precedence like math, left to right. Right hand side of `=` evaluated first.

parenthesis increase precedence.

```java
double x = 3 / 2 + 1; // x = 2.0
double y = 3 / (2 + 1); // y = 1.0 
```

Mismatched Types
Java verifies that types always match:
```java
String five = 5; // This ERRORS!!!
```

可能需要补充具体报错信息。

Conversion by casting
```java
int a = 2; // a = 2

double
a = 2; // a = 2.0 (Implicit)

int a = 18.7; // ERROR

int a = (int)18.7; // a = 18

double a = 2/3; // a = 0.0
double a = (double)2/3; // a = 0.6666…
```

我感觉这个`double a = 2/3; // a = 0.0`可以稍微再解释一下：我们前面提到`=`右侧先计算，2和3都是integer,所以计算结果是0，然后给double类型的变量a赋值，也就是casting conversion, 因此最终a是0.0。

Methods
```java
public static void main(String[] arguments) {
	System.out.println("hi");
}
```
根据上面这个Snippet简单介绍method的构成部分。不需要过多的涉及class的相关概念，因为到现在这个lecture2还没有学到class。

可以通过下面的语法添加一个method：
```java
public static void NAME() {
	STATEMENTS
}
```

to call a method: 
```java
NAME();
```

example code：
```java
class NewLine {
    public static void newLine() {
        System.out.println("");
    }

    public static void threeLines() {
        newLine();
        newLine();
        newLine();
    }

    public static void main(String[] args) {
        System.out.println("Line 1");
        threeLines();
        System.out.println("Line 2");
    }
}
```

Parameters
```java
public static void NAME(TYPE NAME) {
	STATEMENTS
}
```

To call the method with params:
```java
NAME(EXPRESSION);
```

example code:
```java
class Square {
    public static void printSquare(int x) {
        System.out.println(x*x);
    }

    public static void main(String[] args) {
        int value  = 2;
        printSquare(value);
        printSquare(3);
        printSquare(value * 2);
    }
}
```

但是下面这个代码中两个对于`printSquare`方法的调用就都是错的，可以自己想一想为什么是错的
```java
class Square2 {
    public static void printSquare(int x) {
        System.out.println(x*x);
    }

    public static void main(String[] args) {
        printSquare("hello");
        printSquare(5.5);
    }
}
```

TODO：这里用折叠的样子补充上面这个问题的答案。

然后PPT上：
```java
class Square3 {
    public static void printSquare(double x) {
        System.out.println(x*x);
    }

    public static void main(String[] args) {
        printSquare(5);
    }
}
```
仍然在问What's wrong？TODO: 这里我就有些不懂，类型确实不匹配，但是仍然可以转换，程序运行不会报错。

Multiple parameters:
```java
public static void NAME(TYPE NAME, TYPE NAME) {
	STATEMENTS
}
```

to call
```java
NAME(arg1, arg2);
```

example code:
```java
public class Multiply {
    public static void times(double a, double b) {
        System.out.println(a*b);
    }

    public static void main(String[] args) {
        times(2, 2);
        times(3, 4);
    }
}
```

Return values
```java
public static TYPE NAME() {
	STATEMENTS
	return EXPRESSION;
}
```

`void` means "no type".

再看一下`Square3`的例子，和下面的`Square4`的例子，对比地看。
```java
class Square4 {
    public static double square(double x) {
        return x*x;
    }

    public static void main(String[] args) {
        System.out.println(square((5)));
        System.out.println(square(2));
    }
}
```


如果你是编程初学者，下面的概念可能稍微有一些迷惑，你可以按照
Variable Scope:

Variables live in the block `{}` where they are defined. **scope**

method parameters are like defining a new variable in the method.

```java
public class SquareChange {
    public static void printSqaure(int x) {
        System.out.println("printSqaure x = "+x);
        x =x*x;
        System.out.println("printSquare x = "+ x);
    }

    public static void main(String[] args) {
        int x  = 5;
        System.out.println("main x = "+x);
        printSqaure(x);
        System.out.println("main x = "+x);
    }
}
```
用一段文字结合上面的代码讲解Scope到底该怎么理解。

另一个example code：
```java
class Scope {
    public static void main(String[] args) {
        int x = 5;
        if(x == 5) {
            int x =6;
            int y = 72;
            System.out.println("x = " + x + " y = " + y);
        }
        System.out.println("x = " + x + " y = " + y);
    }
}
```

这个代码无法正确执行。需要补充原因解释。

Methods: Building Blocks
- Big programs are built out of small methods
- Methods can be individually developed
- User of method does not need to know how it works
- In CS, this is called "abstraction"

Mathematical Functions
```java
Math.sin(x)
Math.cos(Math.PI / 2)
Math.pow(2, 3)
Math.log(Math.log(x+y))
```

Conditionals
if statement
```java
if(CONDITION) {
	STATEMENTS
}
```

example code
```java
class Condition {
    public static void test(int x) {
        if(x > 5) {
            System.out.println(x + " is > 5");
        }
    }
    public static void main(String[] args) {
        test(6);
        test(5);    
        test(4);
    }
}
```

Comparison operators
```
x > y: x is greater than y
x < y: x is less than y
x >= y: x is greater than or equal to x
x <= y: x is less than or equal to y
x == y: x equals y
```
Notice that: `==` means equality, `=` means assignment.

Boolean operators
`&&`: logical AND
`||`: logical OR

```java
if(x>6) {
	if(x<9) {
		...
	}
}
```

is equivalent to:
```java
if(x>6 && x<9) {
	...
}
```

else statement
```java
if(CONDITION) {
	STATEMENTS
} else {
	STATEMENTS
}
```

example code:
```java
class Condition2 {
    public static void test(int x) {
        if(x > 5) {
            System.out.println(x + " is > 5");
        } else {
            System.out.println(x + " is not > 5");
        }
    }
    public static void main(String[] args) {
        test(6);
        test(5);    
        test(4);
    }
}
```

else if statement
```java
if (CONDITION) {
	STATEMENTS
} else if(CONDITION) {
	STATEMENTS
} else if (CONTIDION) {
	STATEMENTS
} else {
	STATEMENTS
}
```

example code:
```java
class Condition3 {
    public static void test(int x) {
        if (x > 5) {
            System.out.println(x + " is > 5");
        } else if (x == 5) {
            System.out.println(x + " squals 5");
        } else {
            System.out.println(x + " is < 5");
        }
    }

    public static void main(String[] args) {
        test(6);
        test(5);
        test(4);
    }
}
```

Q&A: just leave an empty section here for now.

Assignment: FooCorporation
Foo Corporation needs a program to calculate how much to pay their hourly employees. The US Department of Labor

requires that employees get paid time and a half for any hours over 40 that they work in a single week. For example, if an

employee works 45 hours, they get 5 hours of overtime, at 1.5 times their base pay. The State of Massachusetts requires

that hourly employees be paid at least $8.00 an hour. Foo Corp requires that an employee not work more than 60 hours in

a week.

An employee gets paid (hours worked) × (base pay), for each hour up to 40 hours.

For every hour over 40, they get overtime = (base pay) × 1.5.

The base pay must not be less than the minimum wage ($8.00 an hour). If it is, print an error.

If the number of hours is greater than 60, print an error message.

Create a new class called FooCorporation.

Write a method that takes the base pay and hours worked as parameters, and prints the total pay or an error. Write a main

method that calls this method for each of these employees:

**Base Pay Hours Worked**

Employee 1 $7.50 35

Employee 2 $8.20 47

Employee 3 $10.00 73

Submit your FooCorporation.java file via Stellar.

Do _not_ try to write the entire program in one go. It is much easier to write a small piece and test it, then write another

small piece and test it. For example, start by writing just a skeleton of your method and your main program. Then add the

code to do the normal salary computation, without any special rules. Then add each additional rule, one at a time. You

should test your program with simple test inputs to check that you handle each case.

Good luck!

Below is some supplementary
Conversion by method
`int` to `sSTring`
```java
String five = 5; // EERROR!
String five = Integer.toString(5); // OK!
String five = "" + 5; // five="5"
```

`String` to `int`
```java
int foo = "18"; // ERROR!
int foo = Integer.parseInt("18"); // OK!
```

Comparison operators
Do NOT call `==` on doubles! EVER!
```java
double a = Math.cos(Math.PI / 2);
double b = 0.0;
```

`a==b` will return FALSE.T