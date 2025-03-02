Design, Debugging, Interfaces

Review on Homework 5.

TODO: 等做好第五章作业再添加这一部分。

---

Good program design

What is a good program?
- Correct / no errors
- Easy to understand
- Easy to modify / extend
- Good performance(speed)

Consistency
- Writing code in a consistent way makes it easier to write and understand
- Programming "style" guides: define rules about how to do things
- Java has some widely accepted "standard" style guidelines

Naming:
- Variables: Nouns, lowercase first letter, capitals separating words: x/shape/highScore/fileName
- Methods: Verbs, lowercase first letter: getSize()/draw()/drawWithColor()
- Classes: Nouns, uppercase first letter: Shape/WebPage/EmailAddress

Good Class Design
Good classes: easy to understand and use
- Make fields and methods private by default
- Only make methods public if you need to
- If you need access to a field, create a method:
```java
public int getBar() { return bar; }
```

---

Debugging

The process of finding and correcting an error in a program

Debugging is also a fundamental skill in programming.

Step 1: Don't make mistakes
Don't introduce errors in the first place

- Reuse: find existing code that does what you want
- Design: think before you code
- best Practices: Recommended procedures/techniques to avoid common problems.

Design: Pseudocode
A high-level, understandable description of what a program is supposed to do

Don't worry about the details, worry about the structure

Pseudocode: Interval Testing
Example: Is a number within the interval `[x, y)`?

```plaintext
If number < x return false
If number > y return false
return true
```

Design
- Visual design for objects, or how a program works
- Don't worry about specific notation, just do something that makes sense for you
- Scrap paper is useful

TODO: 这里需要补充pdf上面P20的截图

Step 2: Find Mistakes Early
Easier to fix errors the earlier you find them
- Test your design
- Tools: detect potential errors
- Test your implementation
- Check your work: assertions

Testing: Important Inputs
Want to check all "paths" through the program. Think about one example for each "path"

Example:
Is a number within the interval `[x, y)`?
正如我们前面提到的，测试案例需要
- Below the lower bound
- Equal to the lower bound
- Within the interval
- Equal to the upper bound
- Above the upper bound

What if lower bound `>` upper bound?

What if lower bound `==` upper bound?

Again Pseudocode: Interval Testing
Example: Is a number within the interval `[x, y)`?

```plaintext
If number < x return false
If number > y return false
return true
```

If you think about: is 5 in the interval `[x, y)`?

You would change the pseudocode to:
```plaintext
If number < x return false
If number >= y return false
return true
```

Tools: Eclipse Warnings
Warnings: may not be a mistake, but it likely is

Suggestion: always fix all warnings

Extra checks: FindBugs and related tools
Unit testing: JUnit makes testing easier

Assertions:
Verify that code does that what you expect

If true: nothing happens
If false: program crashes with error
Disabled by default(enable with `-ea`)
```java
assert difference >= 0;
```



---


Interfaces

---

