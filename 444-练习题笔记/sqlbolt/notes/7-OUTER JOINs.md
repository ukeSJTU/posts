# SQLBolt - Learn SQL - SQL Lesson 7: OUTER JOINs / SQLBolt - 学习 SQL - SQL 课程 7：OUTER JOINs

SQL Lesson 7: OUTER JOINs

SQL 课程 7：OUTER JOINs

Depending on how you want to analyze the data, the `INNER JOIN` we used last lesson might not be sufficient because the resulting table only contains data that belongs in both of the tables.

根据你希望如何分析数据，我们上节课使用的 `INNER JOIN` 可能不够充分，因为结果表只包含同时属于两个表的数据。

If the two tables have asymmetric data, which can easily happen when data is entered in different stages, then we would have to use a `LEFT JOIN`, `RIGHT JOIN` or `FULL JOIN` instead to ensure that the data you need is not left out of the results.

如果两个表具有不对称的数据，这在数据分阶段输入时很容易发生，那么我们就必须使用 `LEFT JOIN`、`RIGHT JOIN` 或 `FULL JOIN` 来确保你需要的数据不会被排除在结果之外。

Select query with LEFT/RIGHT/FULL JOINs on multiple tables

在多个表上使用 LEFT/RIGHT/FULL JOIN 的 SELECT 查询

```sql
SELECT column, another_column, …
FROM mytable INNER/LEFT/RIGHT/FULL JOIN another_table
    ON mytable.id = another_table.matching_id
WHERE condition(s)
ORDER BY column, … ASC/DESC
LIMIT num_limit OFFSET num_offset;
```

Like the `INNER JOIN` these three new joins have to specify which column to join the data on.  
When joining table A to table B, a `LEFT JOIN` simply includes rows from A regardless of whether a matching row is found in B. The `RIGHT JOIN` is the same, but reversed, keeping rows in B regardless of whether a match is found in A. Finally, a `FULL JOIN` simply means that rows from both tables are kept, regardless of whether a matching row exists in the other table.

像 `INNER JOIN` 一样，这三个新的连接必须指定连接数据的列。  
当连接表 A 到表 B 时，`LEFT JOIN` 简单地包括来自 A 的行，无论在 B 中是否找到匹配的行。`RIGHT JOIN` 也是一样，但方向相反，无论在 A 中是否找到匹配，都保留 B 中的行。最后，`FULL JOIN` 简单地意味着保留两个表中的行，无论另一表中是否存在匹配的行。

When using any of these new joins, you will likely have to write additional logic to deal with `NULL`s in the result and constraints (more on this in the next lesson).

在使用这些新连接中的任何一个时，你可能需要编写额外的逻辑来处理结果中的 `NULL` 值和约束条件（更多内容将在下一课中介绍）。

> Did you know?
>
> You might see queries with these joins written as `LEFT OUTER JOIN`, `RIGHT OUTER JOIN`, or `FULL OUTER JOIN`, but the `OUTER` keyword is really kept for SQL-92 compatibility and these queries are simply equivalent to `LEFT JOIN`, `RIGHT JOIN`, and `FULL JOIN` respectively.
>
> 你知道吗？
>
> 你可能会看到这些连接被写成 `LEFT OUTER JOIN`、`RIGHT OUTER JOIN` 或 `FULL OUTER JOIN` 的查询，但 `OUTER` 关键字实际上是为了与 SQL-92 兼容而保留的，这些查询分别与 `LEFT JOIN`、`RIGHT JOIN` 和 `FULL JOIN` 等价。
