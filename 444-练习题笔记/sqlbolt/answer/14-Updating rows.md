# Exercise / 练习

It looks like some of the information in our **Movies** database might be incorrect, so go ahead and fix them through the exercises below.

看起来我们的 **Movies** 数据库中的一些信息可能不正确，请通过下面的练习来修复它们。

Table: movies

| id  | title               | director       | year | length_minutes |
| --- | ------------------- | -------------- | ---- | -------------- |
| 1   | Toy Story           | John Lasseter  | 1995 | 81             |
| 2   | A Bug's Life        | El Directore   | 1998 | 95             |
| 3   | Toy Story 2         | John Lasseter  | 1899 | 93             |
| 4   | Monsters, Inc.      | Pete Docter    | 2001 | 92             |
| 5   | Finding Nemo        | Andrew Stanton | 2003 | 107            |
| 6   | The Incredibles     | Brad Bird      | 2004 | 116            |
| 7   | Cars                | John Lasseter  | 2006 | 117            |
| 8   | Ratatouille         | Brad Bird      | 2007 | 115            |
| 9   | WALL-E              | Andrew Stanton | 2008 | 104            |
| 10  | Up                  | Pete Docter    | 2009 | 101            |
| 11  | Toy Story 8         | El Directore   | 2010 | 103            |
| 12  | Cars 2              | John Lasseter  | 2011 | 120            |
| 13  | Brave               | Brenda Chapman | 2012 | 102            |
| 14  | Monsters University | Dan Scanlon    | 2013 | 110            |

```sql
SELECT * FROM movies;
```

Exercise 14 — Tasks / 练习 14 — 任务

1.  The director for A Bug's Life is incorrect, it was actually directed by **John Lasseter**
    1. 《虫虫危机》的导演不正确，实际上是由 **John Lasseter** 导演的
2.  The year that Toy Story 2 was released is incorrect, it was actually released in **1999** 2. 《玩具总动员 2》的发行年份不正确，实际上是在 **1999** 年发行的
3.  Both the title and director for Toy Story 8 is incorrect! The title should be "Toy Story 3" and it was directed by **Lee Unkrich** 3. 《玩具总动员 8》的标题和导演都不正确！标题应该是 "Toy Story 3"，并且是由 **Lee Unkrich** 导演的

---

# Answer / 答案

```sql
UPDATE movies SET director = "John Lasseter" WHERE title="A Bug's Life";
UPDATE movies SET year=1999 WHERE title="Toy Story 2";
UPDATE movies SET title="Toy Story 3", director="Lee Unkrich" WHERE title="Toy Story 8";
```
