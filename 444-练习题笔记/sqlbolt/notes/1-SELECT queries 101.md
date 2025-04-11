# SQLBolt - Learn SQL - SQL Lesson 1: SELECT queries 101 / SQLBolt - 学习 SQL - SQL 课程 1：SELECT 查询基础

SQL Lesson 1: SELECT queries 101

SQL 课程 1：SELECT 查询基础

To retrieve data from a SQL database, we need to write `SELECT` statements, which are often colloquially refered to as _queries_. A query in itself is just a statement which declares what data we are looking for, where to find it in the database, and optionally, how to transform it before it is returned. It has a specific syntax though, which is what we are going to learn in the following exercises.

要从 SQL 数据库中检索数据，我们需要编写 `SELECT` 语句，这些语句通常被口语化地称为 _查询_。查询本身只是一个声明，说明我们要查找的数据是什么，在数据库中哪里可以找到它，以及可选地，在返回之前如何转换它。不过，它有特定的语法，这正是我们在接下来的练习中要学习的。

As we mentioned in the introduction, you can think of a table in SQL as a type of an entity (ie. Dogs), and each row in that table as a specific _instance_ of that type (ie. A pug, a beagle, a different colored pug, etc). This means that the columns would then represent the common properties shared by all instances of that entity (ie. Color of fur, length of tail, etc).

正如我们在介绍中所提到的，你可以将 SQL 中的表视为一种实体（例如狗），该表中的每一行是该类型的一个具体 _实例_（例如一只哈巴狗，一只比格犬，一只不同颜色的哈巴狗等）。这意味着列将代表该实体的所有实例所共享的共同属性（例如毛色，尾巴长度等）。

And given a table of data, the most basic query we could write would be one that selects for a couple columns (properties) of the table with all the rows (instances).

Select query for a specific columns

特定列的 SELECT 查询

```sql
SELECT column, another_column, …
FROM mytable;
```

The result of this query will be a two-dimensional set of rows and columns, effectively a copy of the table, but only with the columns that we requested.

此查询的结果将是一个二维的行和列集合，实际上是表的一个副本，但仅包含我们请求的列。

If we want to retrieve absolutely all the columns of data from a table, we can then use the asterisk (`*`) shorthand in place of listing all the column names individually.

如果我们想从表中检索所有列的数据，我们可以使用星号（`*`）作为简写，代替逐一列出所有列名。

Select query for all columns

所有列的 SELECT 查询

```sql
SELECT *
FROM mytable;
```

This query, in particular, is really useful because it's a simple way to inspect a table by dumping all the data at once.

这个查询特别有用，因为它是一种简单的方法，可以通过一次性转储所有数据来检查表。
