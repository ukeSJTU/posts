Types, variables, Operators

Goal is to learn enough Java to do something useful.

Examples: 
- Simulate a natural/engineering process.
- Manipulate PDFs
- Draw pretty graphics

The computer can be thought as composed of three main parts: memory, CPU and IO devices.

The CPU receives instructions: `z=x+y` needs to read location x, read location y, add and write to location z.

programming languages:
- easier to understand than CPU instructions
- needs translation before CPU to understand it

JAVA:
- Most popular
- Runs on. a virtual machine called JVM
- More complex than some others: python
- Simpler than others: C++

Compiling Java:
source code(.java) --javac--> Byte Code(.class) ----> java

First program:
```java
class Hello {
  public static void main(String[] args) {
    // System execution begins here
    System.out.println("Hello world.");
  }
}
```

The above should be saved to which file? How to run and see the result?

Program structure:
```java
class CLASSNAME {
    public static void main(String[] arguments) {
	    STATEMENTS
    }
}

```

Output:

System.out.println(some String) outputs to the console Example: System.out.println(“output”);

Second Program

```java
class Hello2 {
  public static void main(String[] arguments) {
    System.out.println("Hello world.");  // Print once
    System.out.println("Line number 2"); // Again!
  }
}
```

types
kinds of values that can be stored and manipulated.

boolean: Truth value true of false
int Integer: 0,1 -47
double Real number: 3.14, 1.0, -2.1
String text "hello" "example"

variables:
named location that stores a value of one particular type.

Form: TYPE NAME;
String foo;

Assignment:
Use = to give variables a value.

Example: 
String foo;
foo="IAP 6.092";

can combine: `double badPi=3.14;` or `boolean isJanuary=true;`

operators: symbols that perform simple computations
assignment: `=`
addition: `+`
subtraction: `-`
multiplication: `*`
division: `/`

Operators have orders which follows standard math rules:
1. parentheses
2. multiplication and division
3. addition and subtraction

```java
class DoMath {
    public static void main(String[] arguments) {
        double score=1.0+2.0*3.0;
        System.out.println(score);
        score=score/2.0;
        System.out.println(score);
    }
}
```

```java
public class DoMath2 {
    public static void main(String[] arguments) {
        double score=1.0+2.0*3.0;
        System.out.println(score);
        double copy=score;
        copy=copy/2.0;
        System.out.println(copy);
        System.out.println(score);
    }
}
```

String concatenation(`+`)
```java
String text = "hello" + " world";
text = text + " number " + 5;
// text = "hello world number 5"
```

Assignment: GravityCalculator
Compute the position of a falling object:
$$ x(t)=0.5\times at^2+v_{i}t+x_{i}$$

NOTE: code and explanation for assignments should be found at another dedicated git repo. This line should also be removed upon publication.