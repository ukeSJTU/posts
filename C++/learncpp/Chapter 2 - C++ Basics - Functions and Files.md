# 2.1 Introduction to functions

2.1 函数入门

In the last chapter, we defined a function as a collection of statements that execute sequentially. While that is certainly true, that definition doesn’t provide much insight into why functions are useful. Let’s update our definition: A function is a reusable sequence of statements designed to do a particular job.

You already know that every executable program must have a function named main() (which is where the program starts execution when it is run). However, as programs start to get longer and longer, putting all the code inside the main() function becomes increasingly hard to manage. Functions provide a way for us to split our programs into small, modular chunks that are easier to organize, test, and use. Most programs use many functions. The C++ standard library comes with plenty of already-written functions for you to use -- however, it’s just as common to write your own. Functions that you write yourself are called user-defined functions.

Consider a case that might occur in real life: you’re reading a book, when you remember you need to make a phone call. You put a bookmark in your book, make the phone call, and when you are done with the phone call, you return to the place you bookmarked and continue your book precisely where you left off.

C++ programs can work the same way (and borrow some of the same nomenclature). A program will be executing statements sequentially inside one function when it encounters a function call. A function call tells the CPU to interrupt the current function and execute another function. The CPU essentially “puts a bookmark” at the current point of execution, executes the function named in the function call, and then returns to the point it bookmarked and resumes execution.

Nomenclature

The function initiating the function call is the caller, and the function being called (executed) is the callee. A function call is also sometimes called an invocation, with the caller invoking the callee.

# 2.2 Function return values (value-returning functions)

# 2.3 Void functions (non-value returning functions)

# 2.4 Introduction to function parameters and arguments

# 2.5 Introduction to local scope

# 2.6 Why functions are useful, and how to use them effectively

# 2.7 Forward declarations and definitions

# 2.8 Programs with multiple code files

# 2.9 Naming collisions and an introduction to namespaces

# 2.10 Introduction to the preprocessor

# 2.11 Header files

# 2.12 Header guards

# 2.13 How to design your first programs

# 2.x Chapter 2 summary and quiz
