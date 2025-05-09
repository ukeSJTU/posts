一下内容整理自本课程的 Lec0-Welcome，可以了解本课程的学习目标等等

本课程为 CS61A，开设于 2024-Fall 学期。网站见：[2024Fall 备份网站](https://insideempire.github.io/CS61A-Website-Archive/)

课本采用：[教材](https://www.composingprograms.com/)

What is This Course About?

- A course about managing complexity
  - Mastering abstraction
  - Techniques for organizing complex programs
- An introduction to programming
  - Full understanding of Python fundamentals
  - Large projects to demonstrate how to manage complexity
  - How computers interpret programming languages
- Different types of languages: Python, Scheme, & SQL

### 前置要求

- 没有正式的编程先决条件，但**强烈建议有编程经验**

### 替代课程选择

- **CS 10**：为无编程经验学生设计的入门课程，为 CS 61A 打基础
- **Data C88C**：基于 CS 61A 但内容较少(只涵盖 3/4 的内容)，为数据科学方向学生设计

## Resources

教材网站：https://www.composingprograms.com/

中文版教材：https://composingprograms.netlify.app/

---

完成了homework01，我感觉难度不大，但是文件里面也有类似下面这样的代码来保证学生实现代码不会破坏整体框架：

```python
def a_plus_abs_b_syntax_check():
    """Check that you didn't change the return statement of a_plus_abs_b.

    >>> # You aren't expected to understand the code of this test.
    >>> import inspect, re
    >>> re.findall(r'^\s*(return .*)', inspect.getsource(a_plus_abs_b), re.M)
    ['return f(a, b)']
    """
    # You don't need to edit this function. It's just here to check your work.
```

还有`ast`来检查的，值得学习：

```python
def two_of_three_syntax_check():
    """Check that your two_of_three code consists of nothing but a return statement.

    >>> # You aren't expected to understand the code of this test.
    >>> import inspect, ast
    >>> [type(x).__name__ for x in ast.parse(inspect.getsource(two_of_three)).body[0].body]
    ['Expr', 'Return']
    """
    # You don't need to edit this function. It's just here to check your work.
```
