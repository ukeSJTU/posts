Loops, Arrays

Assignment 2 Review

Then talks about some frequent issues:
1. The signature of the `main` method cannot be modified.
```java
public static void main(String[] arguments) {
	...
}
```

2. if you declare that the method is not `void`, then it has to return something!
```java
public static int pay(double basePay, int hours) {
	if(basePay < 8.0)  return -1;
	else if (hours > 60) return -1;
	else {
		int salary = 0;
		...
		return salary;
	}
}
```

3. don't create duplicate variables with the same name
```java
public static int pay(double basePay, int hours) {
	int salary = 0; // OK
	...
	int salary = 0; // salary already defined!!
	...
	double salary = 0; // salary already defined!!
}
```

Answer to assignment 2:
```java
class WeeklyPay {
public static void pay(double basePay, int hours) {
if (basePay < 8.0) {
System.out.println("You must be paid at least $8.00/hour");
} else if (hours > 60) {
System.out.println("You can't work more than 60 hours a week");
} else {

int overtimeHours = 0;

if (hours > 40) {

overtimeHours = hours - 40;
hours = 40;
}
double pay = basePay * hours;
pay += overtimeHours * basePay * 1.5;
System.out.println("Pay this employee $" + pay);
}
}
public static void main(String[] arguments) {
pay(7.5, 35);
pay(8.2, 47);
pay(10.0, 73);
}
} 
```

What we have learned so far?
- variables & types
- Operators
- Type conversions & casting
- Methods & parameters
- `if` statement

Today's topics
- Good programming style
- Loops
- Arrays

Good programming style
本节课是Java入门全系列的第三节课，我们会学习到越来越多的复杂语法，代码长度和复杂度都会上升，因此有必要在进一步学习之前，先熟悉好的代码规范，这样后续学习才能更顺畅。
The goal of good style is to make your code more readable by you and by others.

Rule 1: use good(meaningful) names
```java
// 下面三个都不是好的变量名
String a1;
int a2;
double b;

// 下面三个都是好的（有意义的）变量名
String firstName;
String lastName;
int temperature;
```

Rule 2: Use indentation
```java
public static void main (String[] arguments) {
int x = 5;
x = x * x;
if (x > 20) {
System.out.println(x + “ is greater than 20.”);
}
double y = 3.4;
} 
```
vs
```java
public static void main (String[] arguments) {
	int x = 5;
	x = x * x;
	if (x > 20) {
		System.out.println(x + " is greater than 20.");
	}
	double y = 3.4;
} 
```

Rule 3: use whitespaces
Put whitespaces in complex expressions:
```java
// BAD!
double cel=fahr*42.0/(13.0-7.0);

// GOOD!
double cel = fahr * 42.0 / (13.0 - 7.0);
```

Put blank lines to improve readability:
```java
public static void main (String[] arguments) {

	int x = 5;
	x = x * x;
	
	if (x > 20) {
		System.out.println(x + " is > 20.");
	}
	double y = 3.4;
} 
```

Rule 4: Do not duplicate tests
```java
if (basePay < 8.0) {
	...
} else if (hours > 60) {
	...
} else if (basePay >= 8.0 && hours <= 60) {
	...
}
```

The above example code is BAD, the following is better:
```java
if (basePay < 8.0) {
	...
} else if (hours > 60) {
	...
} else {
	...
}
```

Summary of Good programming style:
- Use good names for variables and methods
- Use indentation
- Add whitespaces
- Don't duplicate tests

Loops.
比如说下面这个代码还比较简单：
```java
static void main(String[] args) {
	System.out.println("Rule #1");
	System.out.println("Rule #2");
	System.out.println("Rule #3");
}
```

But what if you want to do it for 200 Rules?

Loop operators allow to loop through a block of code.

There are several loop operators in Java.

the `while` operator
```java
while(CONDITION) {
	STATEMENTS
}
```

example code:
```java
int i = 0;
while(i < 3) {
	System.out.println("Rule #" + i);
	i = i + 1;
}
```

Two things to notice:
- Count carefully
- Make sure that your loop has a chance to finish

The `for` operator
```java
for(initialization;condition;update) {
	statements
}
```

example:
```java
for(int i = 0; i < 3; i = i + 1) {
	System.out.println("Rule #" + i);
}
```

note: `i=i+1` may be replaced by `i++`

Branching Statements
`break` terminates a `for` or `while` loop

```java
for(int i = 0; i < 100; i++) {
	if(i==50)
		break;
	System.out.println("Rule #" + i);
}
```

描述一下上面运行的结果。

`continue` skips the current iteration of a loop and proceeds directly to the next iteration.
```java
for(int i=0; i<100; i++) {
	if(i==50) 
		continue;
	System.out.println("Rule #" + i);
}
```

Embedded loops
```java
for (int i = 0; i < 3; i++) { 
	for (int j = 2; j < 4; j++) { 
		System.out.println (i + " " + j); 
	} 
}
```

Scope of the variable defined in the initialization: respective `for` block.

Arrays
an array is an indexed list of values.
You can make an array of any type but all elements of an array must have the same type.

TODO: need to add an ASCII art to illustrate the structure of an array.

The index of an array starts at zero and ends at `legnth-1`

Example:
```java
int[] values = new int[5];
values[0] = 12; // CORRECT
values[4] = 12; // CORRECT
values[5] = 12; // WRONG!! compiles but throws an Exception at run-time
```

An array is defined using `TYPE []`.

Arrays are just another type.
```java
int[] values; // array of int
int[][] values; // int[] is a type
```

To create an array of a given size, use the operator `new`:
```java
int[] values = new int[5];
```

or you may use a variable to specify the size:
```java
int size=12;
int[] values = new int[size];
```

Array initialization
curly braces can be used to init an array. It can **ONLY** be used when you declare the variable.

```java
int[] values = { 12, 24, -23, 47 };
```

Now a simple quiz: is there an error in this code?
```java
int[] values = {1, 2.5, 3, 3.5, 4};
```
TODO: make an answer and explain why.

Accessing Arrays
To access the elements of an array, use the `[]` operator:
`values[index]`

Example: 
```java
int[] values = { 12, 24, -23, 47 };
values[3] = 18;  // {12, 24, -23, 18}
int x = values[1] + 3;
```

The `length` variable
Each array has a `length` variable built-in that contains the length of the array.
```java
int[] values = new int[12];
int size = values.length; // 12

int[] values2 = {1,2,3,4,5};
int size2 = values2.length; // 5
```

Side note: String arrays
```java
public static void main(String[] arguments) {
	System.out.println(arguments.length);
	System.out.println(arguments[0]);
	System.out.println(arguments[1]);
}
```

这里应该稍微补充一点点。直接执行上面这个代码会发现`arguments.length`就是`0`。自然后面的就会报错。

Combining Loops and Arrays
Looping through an array
Example 1:
```java
int[] values = new int[5];

for(int i=0; i<values.length; i++) {
	values[i] = i;
	int y = values[i] * values[i];
	System.out.println(y);
}
```

Example 2:
```java
int[] values = new int[5];
int i = 0;
while(i < values.length) {
	values[i] = i;
	int y = values[i] * values[i];
	System.out.println(y);
	i++;
}
```

Summary for today
1. Programming Style
2. Loops
3. Arrays

Assignment 3
A group of MIT friends decide to run the Boston Marathon. Their names and times (in minutes) are below: Name Time (minutes) Elena 341 Thomas 273 Hamilton 278 Suzie 329 Phil 445 Matt 402 Alex 388 Emma 275 John 243 James 334 Jane 412 Emily 393 Daniel 299 Neda 343 Aaron 317 Kate 265 

Problem:
Find the fastest runner. Print the name and his/her time (in minutes). Optional: Find the second fastest runner. Print the name and his/her time (in minutes). Write a method that takes as input an array of integers and returns the index corresponding to the person with the lowest time. Run this method on the array of times. Print out the name and time corresponding to the returned index. Write a second method to find the second-best runner. The second method should use the first method to determine the best runner, and then loop through all values to find the second-best (second lowest) time. Here is a program skeleton to get started: 
```java
class Marathon {
    public static void main(String[] arguments) {
        String[] names = { "Elena", "Thomas", "Hamilton", "Suzie", "Phil", "Matt", "Alex", "Emma", "John", "James",
                "Jane", "Emily", "Daniel", "Neda", "Aaron", "Kate" };
        int[] times = { 341, 273, 278, 329, 445, 402, 388, 275, 243, 334, 412, 393, 299, 343, 317, 265 };
        for (int i = 0; i < names.length; i++) {
            System.out.println(names[i] + ": " + times[i]);
        }
    }
}
```
