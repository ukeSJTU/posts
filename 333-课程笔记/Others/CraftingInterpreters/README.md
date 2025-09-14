## ToC

### I. WELCOME

1. Introduction
2. A Map of the Territory
3. The Lox Language

### II. A TREE-WALK INTERPRETER

4. Scanning
5. Representing Code
6. Parsing Expressions
7. Evaluating Expressions
8. Statements and State
9. Control Flow
10. Functions
11. Resolving and Binding
12. Classes
13. Inheritance

### III. A BYTECODE VIRTUAL MACHINE

14. Chunks of Bytecode
15. A Virtual Machine
16. Scanning on Demand
17. Compiling Expressions
18. Types of Values
19. Strings
20. Hash Tables
21. Global Variables
22. Local Variables
23. Jumping Back and Forth
24. Calls and Functions
25. Closures
26. Garbage Collection
27. Classes and Instances
28. Methods and Initializers
29. Superclasses
30. Optimization

---

## 课程评价

第一部分jlox in Java，最经典最纯粹的解释器，源代码-》词法分析-〉语法分析-》直接便利AST并求值。没有编译步骤，类似于同声传译。

第二部分clox in C，字节码虚拟机 Bytecode Virtual Machine。是混合模型，现代解释器CPython， Ruby MRI更常用的实现方式。编译，编译器前端负责将源代码lox编译成一种专门设计的、紧凑的中间指令集——字节码Bytecode。解释，一个虚拟机VM来解释执行这些字节码，VM本质上是一个针对字节码的、高度优化的解释器。
