# SQLBolt - Learn SQL - SQL Lesson 12: Order of execution of a Query / SQLBolt - 学习 SQL - SQL 课程 12：查询的执行顺序

SQL Lesson 12: Order of execution of a Query

SQL 课程 12：查询的执行顺序

Now that we have an idea of all the parts of a query, we can now talk about how they all fit together in the context of a complete query.

现在我们已经了解了查询的所有部分，我们可以讨论它们在完整查询的上下文中是如何组合在一起的。

Complete SELECT query

完整的 SELECT 查询

```sql
SELECT DISTINCT column, AGG_FUNC(column_or_expression), …
FROM mytable
    JOIN another_table
      ON mytable.column = another_table.column
    WHERE constraint_expression
    GROUP BY column
    HAVING constraint_expression
    ORDER BY column ASC/DESC
    LIMIT count OFFSET COUNT;
```

Each query begins with finding the data that we need in a database, and then filtering that data down into something that can be processed and understood as quickly as possible. Because each part of the query is executed sequentially, it's important to understand the order of execution so that you know what results are accessible where.

每个查询都始于在数据库中找到我们需要的数据，然后将这些数据过滤成可以尽快处理和理解的内容。因为查询的每个部分都是按顺序执行的，所以了解执行顺序非常重要，这样你就能知道在何处可以访问哪些结果。

## Query order of execution / 查询执行顺序

### 1. `FROM` and `JOIN`s / 1. `FROM` 和 `JOIN`

The `FROM` clause, and subsequent `JOIN`s are first executed to determine the total working set of data that is being queried. This includes subqueries in this clause, and can cause temporary tables to be created under the hood containing all the columns and rows of the tables being joined.

`FROM` 子句以及随后的 `JOIN` 首先被执行，以确定正在查询的完整工作数据集。这包括该子句中的子查询，并且可能会在后台创建临时表，包含被连接表的所有列和行。

### 2. `WHERE` / 2. `WHERE`

Once we have the total working set of data, the first-pass `WHERE` constraints are applied to the individual rows, and rows that do not satisfy the constraint are discarded. Each of the constraints can only access columns directly from the tables requested in the `FROM` clause. Aliases in the `SELECT` part of the query are not accessible in most databases since they may include expressions dependent on parts of the query that have not yet executed.

一旦我们有了完整的工作数据集，第一次通过的 `WHERE` 约束条件被应用于单个行，不满足约束条件的行将被丢弃。每个约束条件只能直接访问 `FROM` 子句中请求的表中的列。在大多数数据库中，查询的 `SELECT` 部分中的别名是不可访问的，因为它们可能包含依赖于尚未执行的查询部分的表达式。

### 3. `GROUP BY` / 3. `GROUP BY`

The remaining rows after the `WHERE` constraints are applied are then grouped based on common values in the column specified in the `GROUP BY` clause. As a result of the grouping, there will only be as many rows as there are unique values in that column. Implicitly, this means that you should only need to use this when you have aggregate functions in your query.

在应用 `WHERE` 约束条件后，剩余的行根据 `GROUP BY` 子句中指定的列中的共同值进行分组。由于分组，结果行数将与该列中的唯一值数量相同。隐含地，这意味着你只需要在查询中有聚合函数时使用它。

### 4. `HAVING` / 4. `HAVING`

If the query has a `GROUP BY` clause, then the constraints in the `HAVING` clause are then applied to the grouped rows, discard the grouped rows that don't satisfy the constraint. Like the `WHERE` clause, aliases are also not accessible from this step in most databases.

如果查询有 `GROUP BY` 子句，那么 `HAVING` 子句中的约束条件将应用于分组的行，丢弃不满足约束条件的分组行。像 `WHERE` 子句一样，在大多数数据库中，别名在此步骤中也是不可访问的。

### 5. `SELECT` / 5. `SELECT`

Any expressions in the `SELECT` part of the query are finally computed.

查询的 `SELECT` 部分中的任何表达式最终被计算。

### 6. `DISTINCT` / 6. `DISTINCT`

Of the remaining rows, rows with duplicate values in the column marked as `DISTINCT` will be discarded.

在剩余的行中，标记为 `DISTINCT` 的列中具有重复值的行将被丢弃。

### 7. `ORDER BY` / 7. `ORDER BY`

If an order is specified by the `ORDER BY` clause, the rows are then sorted by the specified data in either ascending or descending order. Since all the expressions in the `SELECT` part of the query have been computed, you can reference aliases in this clause.

如果 `ORDER BY` 子句指定了顺序，则行将根据指定的数据按升序或降序排序。由于查询的 `SELECT` 部分中的所有表达式都已计算完成，你可以在此子句中引用别名。

### 8. `LIMIT` / `OFFSET` / 8. `LIMIT` / `OFFSET`

Finally, the rows that fall outside the range specified by the `LIMIT` and `OFFSET` are discarded, leaving the final set of rows to be returned from the query.

最后，超出 `LIMIT` 和 `OFFSET` 指定范围的行将被丢弃，留下最终要从查询中返回的行集。

## Conclusion / 结论

Not every query needs to have all the parts we listed above, but a part of why SQL is so flexible is that it allows developers and data analysts to quickly manipulate data without having to write additional code, all just by using the above clauses.

并非每个查询都需要包含我们上面列出的所有部分，但 SQL 如此灵活的部分原因在于它允许开发者和数据分析师快速操作数据，而无需编写额外的代码，只需使用上述子句即可。
