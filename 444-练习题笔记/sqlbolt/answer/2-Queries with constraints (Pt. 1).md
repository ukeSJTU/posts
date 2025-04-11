# Exercise / 练习

Using the right constraints, find the information we need from the **Movies** table for each task below.

使用正确的约束条件，从 **Movies** 表中找到我们为以下每个任务所需的信息。

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

Exercise 2 — Tasks / 练习 2 — 任务

1.  Find the movie with a row `id` of 6
2.  Find the movies released in the `year`s between 2000 and 2010
3.  Find the movies **not** released in the `year`s between 2000 and 2010
4.  Find the first 5 Pixar movies and their release `year`

5.  找到行 `id` 为 6 的电影
6.  找到在 2000 年至 2010 年之间上映的电影
7.  找到 **未** 在 2000 年至 2010 年之间上映的电影
8.  找到前 5 部 Pixar 电影及其上映 `year`

---

# Answer / 答案

```sql
SELECT * FROM movies WHERE id = 6;
SELECT * FROM movies WHERE year BETWEEN 2000 AND 2010;
SELECT * FROM movies WHERE year NOT BETWEEN 2000 AND 2010;
SELECT title, year FROM movies WHERE year <= 2003;
```
