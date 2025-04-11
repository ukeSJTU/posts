# SQLBolt - Learn SQL - SQL Lesson 2: Queries with constraints (Pt. 1) / SQLBolt - 学习 SQL - SQL 课程 2：带约束的查询（第 1 部分）

SQL Lesson 2: Queries with constraints (Pt. 1)

SQL 课程 2：带约束的查询（第 1 部分）

Now we know how to select for specific columns of data from a table, but if you had a table with a hundred million rows of data, reading through all the rows would be inefficient and perhaps even impossible.

现在我们知道如何从表中选择特定的数据列，但如果你有一个包含一亿行数据的表，读取所有行将是低效的，甚至可能是不可能的。

In order to filter certain results from being returned, we need to use a `WHERE` clause in the query. The clause is applied to each row of data by checking specific column values to determine whether it should be included in the results or not.

为了过滤掉某些返回的结果，我们需要在查询中使用 `WHERE` 子句。该子句通过检查特定列值来应用于每一行数据，以确定是否应将其包含在结果中。

Select query with constraints

带约束的 SELECT 查询

```sql
SELECT column, another_column, …
FROM mytable
WHERE condition
    AND/OR another_condition
    AND/OR …;
```

More complex clauses can be constructed by joining numerous `AND` or `OR` logical keywords (ie. num_wheels >= 4 AND doors <= 2). And below are some useful operators that you can use for numerical data (ie. integer or floating point):

可以通过连接多个 `AND` 或 `OR` 逻辑关键字来构建更复杂的子句（例如 num_wheels >= 4 AND doors <= 2）。以下是一些可用于数值数据（例如整数或浮点数）的有用运算符：

| Operator            | Condition                                            | SQL Example                   |
| ------------------- | ---------------------------------------------------- | ----------------------------- |
| =, !=, <, <=, >, >= | Standard numerical operators                         | col_name != 4                 |
| BETWEEN … AND …     | Number is within range of two values (inclusive)     | col_name BETWEEN 1.5 AND 10.5 |
| NOT BETWEEN … AND … | Number is not within range of two values (inclusive) | col_name NOT BETWEEN 1 AND 10 |
| IN (…)              | Number exists in a list                              | col_name IN (2, 4, 6)         |
| NOT IN (…)          | Number does not exist in a list                      | col_name NOT IN (1, 3, 5)     |

In addition to making the results more manageable to understand, writing clauses to constrain the set of rows returned also allows the query to run faster due to the reduction in unnecessary data being returned.

除了使结果更易于理解之外，编写约束返回行集的子句还可以减少不必要的数据返回，从而使查询运行更快。

> Did you know?
>
> As you might have noticed by now, SQL doesn't _require_ you to write the keywords all capitalized, but as a convention, it helps people distinguish SQL keywords from column and tables names, and makes the query easier to read.
>
> 你知道吗？
>
> 正如你现在可能已经注意到的，SQL 并不 _要求_ 你将关键字全部大写，但作为一种惯例，它帮助人们区分 SQL 关键字与列名和表名，并使查询更容易阅读。
