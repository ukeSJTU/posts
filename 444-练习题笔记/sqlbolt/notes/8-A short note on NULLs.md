# SQLBolt - Learn SQL - SQL Lesson 8: A short note on NULLs / SQLBolt - 学习 SQL - SQL 课程 8：关于 NULL 的简短说明

SQL Lesson 8: A short note on NULLs

SQL 课程 8：关于 NULL 的简短说明

As promised in the last lesson, we are going to quickly talk about `NULL` values in an SQL database. It's always good to reduce the possibility of `NULL` values in databases because they require special attention when constructing queries, constraints (certain functions behave differently with null values) and when processing the results.

正如上一课所承诺的，我们将简要讨论 SQL 数据库中的 `NULL` 值。减少数据库中 `NULL` 值的可能性总是好的，因为在构建查询、约束条件（某些函数对 null 值的处理方式不同）以及处理结果时，它们需要特别注意。

An alternative to `NULL` values in your database is to have _data-type appropriate default values_, like 0 for numerical data, empty strings for text data, etc. But if your database needs to store incomplete data, then `NULL` values can be appropriate if the default values will skew later analysis (for example, when taking averages of numerical data).

数据库中 `NULL` 值的替代方案是使用 _数据类型适当的默认值_，例如数值数据的 0，文本数据的空字符串等。但如果你的数据库需要存储不完整的数据，那么如果默认值会影响后续分析（例如，在计算数值数据的平均值时），`NULL` 值可能是合适的。

Sometimes, it's also not possible to avoid `NULL` values, as we saw in the last lesson when outer-joining two tables with asymmetric data. In these cases, you can test a column for `NULL` values in a `WHERE` clause by using either the `IS NULL` or `IS NOT NULL` constraint.

有时候，也无法避免 `NULL` 值，正如我们在上一课中看到的那样，当使用外部连接两个具有不对称数据的表时。在这些情况下，你可以在 `WHERE` 子句中使用 `IS NULL` 或 `IS NOT NULL` 约束来测试列是否存在 `NULL` 值。

Select query with constraints on NULL values

对 NULL 值有约束的 SELECT 查询

```sql
SELECT column, another_column, …
FROM mytable
WHERE column IS/IS NOT NULL
AND/OR another_condition
AND/OR …;
```
