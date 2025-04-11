# Exercise / 练习

Here's the definition of a query with a `WHERE` clause again, go ahead and try and write some queries with the operators above to limit the results to the information we need in the tasks below.

这里再次给出带有 `WHERE` 子句的查询定义，请尝试使用上面的运算符编写一些查询，以将结果限制在下面任务中我们所需的信息上。

Select query with constraints

带有约束的 SELECT 查询

```sql
SELECT column, another_column, …
FROM mytable
WHERE condition
    AND/OR another_condition
    AND/OR …;
```

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
| 87  | WALL-G              | Brenda Chapman | 2042 | 97             |

```sql
SELECT * FROM movies;
```

Exercise 3 — Tasks / 练习 3 — 任务

1.  Find all the Toy Story movies
2.  Find all the movies directed by John Lasseter
3.  Find all the movies (and director) not directed by John Lasseter
4.  Find all the WALL-\* movies

5.  找到所有 Toy Story 电影
6.  找到所有由 John Lasseter 导演的电影
7.  找到所有不是由 John Lasseter 导演的电影（及其导演）
8.  找到所有 WALL-\* 电影

---

# Answer / 答案

```sql
SELECT * FROM movies WHERE title LIKE 'Toy Story%';
SELECT * FROM movies WHERE director = 'John Lasseter';
SELECT * FROM movies WHERE director != 'John Lasseter';
SELECT * FROM movies WHERE title LIKE 'WALL-_';
```
