# AP Computer Science Java Subset

The AP Java subset outlines the Java features that may appear on the AP Computer Science A Exam. It is not intended as a complete prescription for computer science courses and will need supplementation to address all topics in a typical introductory curriculum.

This appendix describes the Java subset students should understand for the AP Computer Science A Exam. The subset was selected to:

1. Enable test designers to formulate meaningful questions
2. Help students with test preparation
3. Enable instructors to follow various approaches in their courses

The subset was intentionally kept small, omitting language constructs and library features that don't add significant functionality. It gives instructors flexibility in how they use Java in their courses.

## Language Features and Testable Topics

### Comments

**Tested:**

- `/* */`, `//`, and `/** */`

**Not tested but potentially relevant:**

- Javadoc `@param` and `@return` comment tags
- Javadoc tool

### Primitive Types

**Tested:**

- `int`
- `double`
- `boolean`

**Not tested but potentially relevant:**

- `char`, `byte`, `short`, `long`, `float`

### Operators

**Tested:**

- Arithmetic: `+`, `−`, `*`, `/`, `%`
- Increment/Decrement: `++`, `−−`
- Assignment: `=`, `+=`, `−=`, `*=`, `/=`, `%=`
- Relational: `==`, `!=`, `<`, `<=`, `>`, `>=`
- Logical: `!`, `&&`, `||`
- Numeric casts: `(int)`, `(double)`
- String concatenation: `+`

**Not tested but potentially relevant:**

- `&`, `|`, `^`
- `(char)`, `(float)`
- `StringBuilder`
- Shift: `<<`, `>>`, `>>>`
- Bitwise: `~`, `&`, `|`, `^`
- Conditional: `?:`

### Object Comparison

**Tested:**

- Object identity (`==`, `!=`) vs. object equality (`equals`)
- `String` `compareTo`

**Not tested but potentially relevant:**

- `Comparable`

### Escape Sequences

**Tested:**

- `\"`, `\\`, `\n` inside strings

**Not tested but potentially relevant:**

- `\'`, `\t`, `\unnnn`

### Input / Output

**Tested:**

- `System.out.print`
- `System.out.println`

**Not tested but potentially relevant:**

- `Scanner`, `System.in`
- `System.out`, `System.err`
- Stream input/output
- GUI input/output
- Parsing input: `Integer.parseInt`, `Double.parseDouble`
- Formatting output: `System.out.printf`

### Exceptions

**Tested:**

- `ArithmeticException`
- `NullPointerException`
- `IndexOutOfBoundsException`
- `ArrayIndexOutOfBoundsException`
- `IllegalArgumentException`

**Not tested but potentially relevant:**

- `try`/`catch`/`finally`
- `throw`, `throws`
- `assert`

### Arrays

**Tested:**

- 1-dimensional arrays
- 2-dimensional rectangular arrays
- Initializer list: `{ … }`
- Row-major order of 2-dimensional array elements

**Not tested but potentially relevant:**

- `new type[]{ … }`
- Ragged arrays (non-rectangular)
- Arrays with 3 or more dimensions

### Control Statements

**Tested:**

- `if`, `if/else`
- `while`, `for`
- Enhanced for (for-each)
- `return`

**Not tested but potentially relevant:**

- `switch`
- `break`, `continue`
- `do-while`

### Variables

**Tested:**

- Parameter variables
- Local variables
- Private instance variables: visibility (`private`)
- Static (class) variables: visibility (`public`, `private`), `final`

**Not tested but potentially relevant:**

- `final` parameter variables
- `final` local variables
- `final` instance variables

### Methods

**Tested:**

- Visibility (`public`, `private`)
- Static, non-static
- Method signatures
- Overloading, overriding
- Parameter passing

**Not tested but potentially relevant:**

- Visibility (`protected`)
- `public static void main(String[] args)`
- Command line arguments
- Variable number of parameters
- `final`

### Constructors

**Tested:**

- `super()`, `super(args)`

**Not tested but potentially relevant:**

- Default initialization of instance variables
- Initialization blocks
- `this(args)`

### Classes

**Tested:**

- `new`
- Visibility (`public`)
- Accessor methods
- Modifier (mutator) methods
- Design/create/modify class
- Create subclass of a superclass (abstract, non-abstract)
- Create class that implements an interface

**Not tested but potentially relevant:**

- `final`
- Visibility (`private`, `protected`)
- Nested classes
- Inner classes
- Enumerations

### Interfaces

**Tested:**

- Design/create/modify an interface

**Not tested but potentially relevant:**

- N/A

### Inheritance

**Tested:**

- Understand inheritance hierarchies
- Design/create/modify subclasses
- Design/create/modify classes that implement interfaces

**Not tested but potentially relevant:**

- N/A

### Packages

**Tested:**

- `import packageName.className`

**Not tested but potentially relevant:**

- `import packageName.*`
- Static import
- `package packageName`
- Class path

### Miscellaneous OOP

**Tested:**

- "is-a" and "has-a" relationships
- `null`
- `this`
- `super.method(args)`

**Not tested but potentially relevant:**

- `instanceof`
- `(class)` cast
- `this.var`, `this.method(args)`

### Standard Java Library

**Tested:**

- `Object`
- `Integer`, `Double`
- `String`
- `Math`
- `List<E>`, `ArrayList<E>`

**Not tested but potentially relevant:**

- `clone`
- Autoboxing
- `Collection<E>`
- `Arrays`, `Collections`

## Notes

1. Students are expected to understand the operator precedence rules of the listed operators.

2. The increment/decrement operators `++` and `−−` are part of the AP Java subset. These operators are used only for their side effect, not for their value. That is, the postfix form (for example, `x++`) is always used, and the operators are not used inside other expressions. For example, `arr[x++]` is not used.

3. Students need to understand the "short circuit" evaluation of the `&&` and `||` operators.

4. Students are expected to understand "truncation towards 0" behavior as well as the fact that positive floating-point numbers can be rounded to the nearest integer as `(int)(x + 0.5)`, negative numbers as `(int)(x − 0.5)`.

5. String concatenation `+` is part of the AP Java subset. Students are expected to know that concatenation converts numbers to strings and invokes `toString` on objects.

6. User input is not included in the AP Java subset. There are many possible ways for supplying user input: e.g., by reading from a `Scanner`, reading from a stream (such as a file or a URL), or from a dialog box. There are advantages and disadvantages to the various approaches. The exam does not prescribe any one approach. Instead, if reading input is necessary, it will be indicated in a way similar to the following:

   ```java
   double x = ...; // read user input
   ```

7. Both arrays of primitive types (e.g., `int[]`, `int[][]`) and arrays of objects (e.g., `Student[]`, `Student[][]`) are in the subset.

8. Students need to understand that 2-dimensional arrays are stored as arrays of arrays. For the purposes of the AP CS A Exam, students should assume that 2-dimensional arrays are rectangular (not ragged) and the elements are indexed in row-major order. For example, given the declaration

   ```java
   int[][] m = {{1, 2, 3}, {4, 5, 6}};
   ```

   `m.length` is 2 (the number of rows), `m[0].length` is 3 (the number of columns), `m[r][c]` represents the element at row r and column c, and `m[r]` represents row r (e.g., `m[0]` is of type `int[]` and references the array `{1, 2, 3}`).

   Students are expected to be able to access a row of a 2-dimensional array, assign it to a 1-dimensional array reference, pass it as a parameter, and use loops (including for-each) to traverse the rows. However, students are not expected to analyze or implement code that replaces an entire row in a 2-dimensional array.

9. The `main` method and command-line arguments are not included in the subset. In free-response questions, students are not expected to invoke programs. In the AP Computer Science Labs, program invocation with `main` may occur, but the `main` method will be kept very simple.

10. Students are required to understand when the use of static methods is appropriate. In the exam, static methods are always invoked through a class (explicitly or implicitly), never an object (i.e., `ClassName.staticMethod()` or `staticMethod()`, not `obj.staticMethod()`).

11. If a subclass constructor does not explicitly invoke a superclass constructor, the Java compiler automatically inserts a call to the no-argument constructor of the superclass.

12. Students are expected to implement constructors that initialize all instance variables. Class constants are initialized with an initializer:

    ```java
    public static final int MAX_SCORE = 5;
    ```

    The rules for default initialization (with 0, false or null) are not included in the subset. Initializing instance variables with an initializer is not included in the subset. Initialization blocks are not included in the subset.

13. Students are expected to write interfaces or class declarations when given a general description of the interface or class.

14. Students are expected to extend classes and implement interfaces. Students are also expected to have knowledge of inheritance that includes understanding the concepts of method overriding and polymorphism. Students are expected to implement their own subclasses.

    Students are expected to read the definition of an abstract class and understand that the abstract methods need to be implemented in a subclass. Students are similarly expected to read the definition of an interface and understand that the abstract methods need to be implemented in an implementing class.

15. Students are expected to understand that conversion from a subclass reference to a superclass reference is legal and does not require a cast. Class casts (generally from `Object` to another class) are not included in the AP Java subset. Array type compatibility and casts between array types are not included in the subset.

16. The use of `this` is restricted to passing the implicit parameter in its entirety to another method (e.g., `obj.method(this)`) and to descriptions such as "the implicit parameter this". Students are not required to know the idiom `this.var = var`, where `var` is both the name of an instance variable and a parameter variable.

17. The use of generic collection classes and interfaces is in the AP Java subset, but students need not implement generic classes or methods.

18. Students are expected to know a subset of the constants and methods of the listed Standard Java Library classes and interfaces. Those constants and methods are enumerated in the Java Quick Reference (Appendix B).
