# SQLBolt - Learn SQL - SQL Lesson 6: Multi-table queries with JOINs / SQLBolt - 学习 SQL - SQL 课程 6：使用 JOIN 的多表查询

SQL Lesson 6: Multi-table queries with JOINs

SQL 课程 6：使用 JOIN 的多表查询

Up to now, we've been working with a single table, but entity data in the real world is often broken down into pieces and stored across multiple orthogonal tables using a process known as _normalization_[\[1\]](http://en.wikipedia.org/wiki/Database_normalization "Database normalization").

到目前为止，我们一直在使用单个表，但现实世界中的实体数据通常被分解成多个部分，并使用一种称为 _规范化_ 的过程存储在多个正交表中[\[1\]](http://en.wikipedia.org/wiki/Database_normalization "Database normalization")。

## Database normalization / 数据库规范化

Database normalization is useful because it minimizes duplicate data in any single table, and allows for data in the database to grow independently of each other (ie. Types of car engines can grow independent of each type of car). As a trade-off, queries get slightly more complex since they have to be able to find data from different parts of the database, and performance issues can arise when working with many large tables.

数据库规范化很有用，因为它可以最大限度地减少单个表中的重复数据，并允许数据库中的数据彼此独立增长（例如，汽车引擎类型可以独立于每种汽车类型增长）。作为权衡，查询会变得稍微复杂，因为它们必须能够从数据库的不同部分查找数据，并且在处理许多大表时可能会出现性能问题。

In order to answer questions about an entity that has data spanning multiple tables in a normalized database, we need to learn how to write a query that can combine all that data and pull out exactly the information we need.

为了回答关于在规范化数据库中跨多个表的数据实体的问题，我们需要学习如何编写一个查询，将所有这些数据结合起来，并准确提取我们需要的信息。

## Multi-table queries with JOINs / 使用 JOIN 的多表查询

Tables that share information about a single entity need to have a _primary key_ that identifies that entity _uniquely_ across the database. One common primary key type is an auto-incrementing integer (because they are space efficient), but it can also be a string, hashed value, so long as it is unique.

共享单个实体信息的表需要有一个 _主键_，该主键在数据库中 _唯一_ 标识该实体。一种常见的主键类型是自增整数（因为它们空间效率高），但也可以是字符串、哈希值，只要它是唯一的即可。

Using the `JOIN` clause in a query, we can combine row data across two separate tables using this unique key. The first of the joins that we will introduce is the `INNER JOIN`.

在查询中使用 `JOIN` 子句，我们可以使用这个唯一键跨两个单独的表组合行数据。我们将介绍的第一个连接类型是 `INNER JOIN`。

Select query with INNER JOIN on multiple tables

在多个表上使用 INNER JOIN 的 SELECT 查询

```sql
SELECT column, another_table_column, …
FROM mytable
INNER JOIN another_table
    ON mytable.id = another_table.id
WHERE condition(s)
ORDER BY column, … ASC/DESC
LIMIT num_limit OFFSET num_offset;
```

The `INNER JOIN` is a process that matches rows from the first table and the second table which have the same key (as defined by the `ON` constraint) to create a result row with the combined columns from both tables. After the tables are joined, the other clauses we learned previously are then applied.

`INNER JOIN` 是一个过程，它匹配第一个表和第二个表中具有相同键（由 `ON` 约束定义）的行，以创建包含两个表组合列的结果行。表连接后，我们之前学习的其他子句将被应用。

> Did you know?
>
> You might see queries where the `INNER JOIN` is written simply as a `JOIN`. These two are equivalent, but we will continue to refer to these joins as inner-joins because they make the query easier to read once you start using other types of joins, which will be introduced in the following lesson.
>
> 你知道吗？
>
> 你可能会看到一些查询中 `INNER JOIN` 简写为 `JOIN`。这两者是等价的，但我们将继续称这些连接为 inner-joins，因为一旦你开始使用其他类型的连接（将在接下来的课程中介绍），它们会使查询更容易阅读。
