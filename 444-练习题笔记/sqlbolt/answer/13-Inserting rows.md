# Exercise / 练习

In this exercise, we are going to play studio executive and add a few movies to the **Movies** to our portfolio. In this table, the **Id** is an auto-incrementing integer, so you can try inserting a row with only the other columns defined.

在本练习中，我们将扮演工作室执行官的角色，向 **Movies** 表中添加几部电影到我们的作品集。在这个表中，**Id** 是一个自增的整数，所以你可以尝试只定义其他列来插入一行。

Since the following lessons will modify the database, you'll have to manually run each query once they are ready to go.

由于接下来的课程将修改数据库，一旦准备好，你需要手动运行每个查询。

Table: movies (Read-only)

| id  | title        | director      | year | length_minutes |
| --- | ------------ | ------------- | ---- | -------------- |
| 1   | Toy Story    | John Lasseter | 1995 | 81             |
| 2   | A Bug's Life | John Lasseter | 1998 | 95             |
| 3   | Toy Story 2  | John Lasseter | 1999 | 93             |

Table: boxoffice (Read-only)

| movie_id | rating | domestic_sales | international_sales |
| -------- | ------ | -------------- | ------------------- |
| 3        | 7.9    | 245852179      | 239163000           |
| 1        | 8.3    | 191796233      | 170162503           |
| 2        | 7.2    | 162798565      | 200600000           |

```sql
SELECT * FROM movies;
```

Exercise 13 — Tasks / 练习 13 — 任务

1.  Add the studio's new production, **Toy Story 4** to the list of movies (you can use any director)
2.  Toy Story 4 has been released to critical acclaim! It had a rating of **8.7**, and made **340 million domestically** and **270 million internationally**. Add the record to the `BoxOffice` table.

3.  将工作室的新作品 **Toy Story 4** 添加到电影列表中（你可以使用任何导演）
4.  Toy Story 4 上映后广受好评！它的评分是 **8.7**，国内票房 **3.4 亿**，国际票房 **2.7 亿**。将记录添加到 `BoxOffice` 表中。

---

# Answer / 答案

```sql
INSERT INTO movies VALUES (4, "Toy Story 4", "Josh Cooley", 2019, 100);
INSERT INTO boxoffice VALUES (4, 8.7, 340000000, 270000000);
```
