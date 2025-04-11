# SQLBolt - Learn SQL - SQL Lesson 11: Queries with aggregates (Pt. 2) / SQLBolt - 学习 SQL - SQL 课程 11：使用聚合函数的查询（第 2 部分）

SQL Lesson 11: Queries with aggregates (Pt. 2)

SQL 课程 11：使用聚合函数的查询（第 2 部分）

Our queries are getting fairly complex, but we have nearly introduced all the important parts of a `SELECT` query. One thing that you might have noticed is that if the `GROUP BY` clause is executed after the `WHERE` clause (which filters the rows which are to be grouped), then how exactly do we filter the grouped rows?

我们的查询变得相当复杂，但我们几乎已经介绍了 `SELECT` 查询的所有重要部分。你可能已经注意到的一件事是，如果 `GROUP BY` 子句在 `WHERE` 子句（用于过滤要分组的行）之后执行，那么我们究竟如何过滤分组后的行呢？

Luckily, SQL allows us to do this by adding an additional `HAVING` clause which is used specifically with the `GROUP BY` clause to allow us to filter grouped rows from the result set.

幸运的是，SQL 允许我们通过添加一个额外的 `HAVING` 子句来做到这一点，该子句专门与 `GROUP BY` 子句一起使用，使我们能够从结果集中过滤分组的行。

Select query with HAVING constraint

带有 HAVING 约束的 SELECT 查询

```sql
SELECT group_by_column, AGG_FUNC(column_expression) AS aggregate_result_alias, …
FROM mytable
WHERE condition
GROUP BY column
HAVING group_condition;
```

The `HAVING` clause constraints are written the same way as the `WHERE` clause constraints, and are applied to the grouped rows. With our examples, this might not seem like a particularly useful construct, but if you imagine data with millions of rows with different properties, being able to apply additional constraints is often necessary to quickly make sense of the data.

`HAVING` 子句的约束条件与 `WHERE` 子句的约束条件编写方式相同，并应用于分组的行。在我们的示例中，这可能看起来不是一个特别有用的结构，但如果你想象有数百万行具有不同属性的数据，能够应用额外的约束条件通常是快速理解数据的必要条件。

> Did you know?
>
> If you aren't using the `GROUP BY` clause, a simple `WHERE` clause will suffice.
>
> 你知道吗？
>
> 如果你不使用 `GROUP BY` 子句，一个简单的 `WHERE` 子句就足够了。
