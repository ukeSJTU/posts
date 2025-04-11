# SQLBolt - Learn SQL - SQL Lesson 10: Queries with aggregates (Pt. 1) / SQLBolt - 学习 SQL - SQL 课程 10：使用聚合函数的查询（第 1 部分）

SQL Lesson 10: Queries with aggregates (Pt. 1)

SQL 课程 10：使用聚合函数的查询（第 1 部分）

In addition to the simple expressions that we introduced last lesson, SQL also supports the use of aggregate expressions (or functions) that allow you to summarize information about a group of rows of data. With the Pixar database that you've been using, aggregate functions can be used to answer questions like, "How many movies has Pixar produced?", or "What is the highest grossing Pixar film each year?".

除了我们在上一课介绍的简单表达式外，SQL 还支持使用聚合表达式（或函数），这些表达式允许你总结一组数据行的信息。使用你一直在使用的 Pixar 数据库，聚合函数可以用来回答像“Pixar 制作了多少部电影？”或“每年票房最高的 Pixar 电影是哪一部？”这样的问题。

Select query with aggregate functions over all rows

对所有行使用聚合函数的 SELECT 查询

```sql
SELECT AGG_FUNC(column_or_expression) AS aggregate_description, …
FROM mytable
WHERE constraint_expression;
```

Without a specified grouping, each aggregate function is going to run on the whole set of result rows and return a single value. And like normal expressions, giving your aggregate functions an alias ensures that the results will be easier to read and process.

在没有指定分组的情况下，每个聚合函数将在整个结果行集上运行并返回单个值。就像普通表达式一样，为你的聚合函数指定一个别名可以确保结果更容易阅读和处理。

## Common aggregate functions / 常见的聚合函数

Here are some common aggregate functions that we are going to use in our examples:

以下是我们将在示例中使用的一些常见聚合函数：

| Function                         | Description                                                                                                                                                                                     |
| -------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **COUNT**(\*), **COUNT**(column) | A common function used to counts the number of rows in the group if no column name is specified. Otherwise, count the number of rows in the group with non-NULL values in the specified column. |
| **MIN**(column)                  | Finds the smallest numerical value in the specified column for all rows in the group.                                                                                                           |
| **MAX**(column)                  | Finds the largest numerical value in the specified column for all rows in the group.                                                                                                            |
| **AVG**(column)                  | Finds the average numerical value in the specified column for all rows in the group.                                                                                                            |
| **SUM**(column)                  | Finds the sum of all numerical values in the specified column for the rows in the group.                                                                                                        |

Docs: [MySQL](https://dev.mysql.com/doc/refman/5.6/en/group-by-functions.html "MySQL Aggregate Functions"), [Postgres](http://www.postgresql.org/docs/9.4/static/functions-aggregate.html "Postgres Aggregate Functions"), [SQLite](http://www.sqlite.org/lang_aggfunc.html "SQLite Aggregate Functions"), [Microsoft SQL Server](https://msdn.microsoft.com/en-us/library/ms173454.aspx "Microsoft SQL Server Aggregate Functions")

## Grouped aggregate functions / 分组聚合函数

In addition to aggregating across all the rows, you can instead apply the aggregate functions to individual groups of data within that group (ie. box office sales for Comedies vs Action movies).  
This would then create as many results as there are unique groups defined as by the `GROUP BY` clause.

除了对所有行进行聚合外，你还可以将聚合函数应用于该组内的各个数据组（例如，喜剧片与动作片的票房销售）。  
这将创建与 `GROUP BY` 子句定义的唯一组一样多的结果。

Select query with aggregate functions over groups

对组使用聚合函数的 SELECT 查询

`SELECT AGG_FUNC(_column_or_expression_) AS aggregate_description, … FROM mytable WHERE _constraint_expression_ **GROUP BY column**;`

The `GROUP BY` clause works by grouping rows that have the same value in the column specified.

`GROUP BY` 子句通过对指定列中具有相同值的行进行分组来工作。
