# Exercise / 练习

In this exercise, you'll need to create a new table for us to insert some new rows into.

在这个练习中，你需要创建一个新表，以便我们插入一些新行。

```sql
SELECT * FROM database;
```

Exercise 16 — Tasks / 练习 16 — 任务

1.  Create a new table named `Database` with the following columns:

    – `Name` A string (text) describing the name of the database  
    – `Version` A number (floating point) of the latest version of this database  
    – `Download_count` An integer count of the number of times this database was downloaded

    This table has no constraints.

    1. 创建一个名为 `Database` 的新表，包含以下列：

       – `Name` 一个描述数据库名称的字符串（文本）  
       – `Version` 数据库最新版本的数字（浮点数）  
       – `Download_count` 数据库被下载次数的整数计数

       该表没有约束条件。

---

# Answer / 答案

```sql
CREATE TABLE Database (
    Name TEXT,
    Version FLOAT,
    Download_count INTEGER
);
```
