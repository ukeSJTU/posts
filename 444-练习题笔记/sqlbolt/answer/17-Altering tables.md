# Exercise / 练习

Our exercises use an implementation that only support adding new columns, so give that a try below.

我们的练习使用一种只支持添加新列的实现方式，请在下面尝试一下。

Table: movies

| id  | title               | director       | year | length_minutes |
| --- | ------------------- | -------------- | ---- | -------------- |
| 1   | Toy Story           | John Lasseter  | 1995 | 81             |
| 2   | A Bug's Life        | John Lasseter  | 1998 | 95             |
| 3   | Toy Story 2         | John Lasseter  | 1999 | 93             |
| 4   | Monsters, Inc.      | Pete Docter    | 2001 | 92             |
| 5   | Finding Nemo        | Andrew Stanton | 2003 | 107            |
| 6   | The Incredibles     | Brad Bird      | 2004 | 116            |
| 7   | Cars                | John Lasseter  | 2006 | 117            |
| 8   | Ratatouille         | Brad Bird      | 2007 | 115            |
| 9   | WALL-E              | Andrew Stanton | 2008 | 104            |
| 10  | Up                  | Pete Docter    | 2009 | 101            |
| 11  | Toy Story 3         | Lee Unkrich    | 2010 | 103            |
| 12  | Cars 2              | John Lasseter  | 2011 | 120            |
| 13  | Brave               | Brenda Chapman | 2012 | 102            |
| 14  | Monsters University | Dan Scanlon    | 2013 | 110            |

```sql
SELECT * FROM movies;
```

Exercise 17 — Tasks / 练习 17 — 任务

1.  Add a column named **Aspect_ratio** with a **FLOAT** data type to store the aspect-ratio each movie was released in.
    1. 添加一个名为 **Aspect_ratio** 的列，数据类型为 **FLOAT**，用于存储每部电影发行的宽高比。
2.  Add another column named **Language** with a **TEXT** data type to store the language that the movie was released in. Ensure that the default for this language is **English**. 2. 添加另一个名为 **Language** 的列，数据类型为 **TEXT**，用于存储电影发行的语言。确保该语言的默认值为 **English**。

---

# Answer / 答案

```sql
ALTER TABLE movies ADD Aspect_ratio FLOAT;
ALTER TABLE movies ADD Language TEXT DEFAULT "English";
```
