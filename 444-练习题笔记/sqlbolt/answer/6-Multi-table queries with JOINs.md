# Exercise / 练习

We've added a new table to the Pixar database so that you can try practicing some joins. The **BoxOffice** table stores information about the ratings and sales of each particular Pixar movie, and the _Movie_id_ column in that table corresponds with the _Id_ column in the **Movies** table 1-to-1. Try and solve the tasks below using the `INNER JOIN` introduced above.

我们已经在 Pixar 数据库中添加了一个新表，以便你可以尝试练习一些连接操作。**BoxOffice** 表存储了每部 Pixar 电影的评分和销售信息，该表中的 _Movie_id_ 列与 **Movies** 表中的 _Id_ 列一一对应。尝试使用上面介绍的 `INNER JOIN` 解决下面的任务。

Table: movies (Read-only)

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

Table: boxoffice (Read-only)

| movie_id | rating | domestic_sales | international_sales |
| -------- | ------ | -------------- | ------------------- |
| 5        | 8.2    | 380843261      | 555900000           |
| 14       | 7.4    | 268492764      | 475066843           |
| 8        | 8      | 206445654      | 417277164           |
| 12       | 6.4    | 191452396      | 368400000           |
| 3        | 7.9    | 245852179      | 239163000           |
| 6        | 8      | 261441092      | 370001000           |
| 9        | 8.5    | 223808164      | 297503696           |
| 11       | 8.4    | 415004880      | 648167031           |
| 1        | 8.3    | 191796233      | 170162503           |
| 7        | 7.2    | 244082982      | 217900167           |
| 10       | 8.3    | 293004164      | 438338580           |
| 4        | 8.1    | 289916256      | 272900000           |
| 2        | 7.2    | 162798565      | 200600000           |
| 13       | 7.2    | 237283207      | 301700000           |

```sql
SELECT * FROM movies;
```

Exercise 6 — Tasks / 练习 6 — 任务

1.  Find the domestic and international sales for each movie
2.  Show the sales numbers for each movie that did better internationally rather than domestically
3.  List all the movies by their ratings in descending order

4.  找到每部电影的国内和国际销售数据
5.  显示每部电影在国际市场上表现优于国内市场的销售数据
6.  按评分降序排列所有电影

---

# Answer / 答案

```sql
SELECT title, domestic_sales, international_sales FROM movies JOIN boxoffice ON movies.id=boxoffice.movie_id;
SELECT title, domestic_sales, international_sales FROM movies INNER JOIN boxoffice ON movies.id=boxoffice.movie_id WHERE international_sales>domestic_sales;
SELECT * FROM movies INNER JOIN boxoffice ON movies.id=boxoffice.movie_id ORDER BY rating DESC;
```
