# Exercise / 练习

The database needs to be cleaned up a little bit, so try and delete a few rows in the tasks below.

数据库需要稍微清理一下，请在下面的任务中尝试删除几行数据。

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

Exercise 15 — Tasks / 练习 15 — 任务

1.  This database is getting too big, lets remove all movies that were released **before** 2005.
    1. 这个数据库变得太大了，让我们删除所有在 **2005 年之前** 发行的电影。
2.  Andrew Stanton has also left the studio, so please remove all movies directed by him. 2. Andrew Stanton 也离开了工作室，请删除所有由他导演的电影。

---

# Answer / 答案

```sql
DELETE FROM movies WHERE year<2005;
DELETE FROM movies WHERE director="Andrew Stanton";
```
