# SQLBolt - Learn SQL - SQL Lesson 14: Updating rows / SQLBolt - 学习 SQL - SQL 课程 14：更新行

SQL Lesson 14: Updating rows

SQL 课程 14：更新行

In addition to adding new data, a common task is to update existing data, which can be done using an `UPDATE` statement. Similar to the `INSERT` statement, you have to specify exactly which table, columns, and rows to update. In addition, the data you are updating has to match the data type of the columns in the table schema.

除了添加新数据外，另一个常见任务是更新现有数据，这可以通过 `UPDATE` 语句完成。与 `INSERT` 语句类似，你必须准确指定要更新的表、列和行。此外，你更新的数据必须与表模式中列的数据类型匹配。

Update statement with values

带有值的 UPDATE 语句

```sql
UPDATE mytable
SET column = value_or_expr,
    other_column = another_value_or_expr,
    …
WHERE condition;
```

The statement works by taking multiple column/value pairs, and applying those changes to each and every row that satisfies the constraint in the `WHERE` clause.

该语句通过获取多个列/值对，并将这些更改应用于满足 `WHERE` 子句中约束条件的每一行。

## Taking care / 小心操作

Most people working with SQL **will** make mistakes updating data at one point or another. Whether it's updating the wrong set of rows in a production database, or accidentally leaving out the `WHERE` clause (which causes the update to apply to _all_ rows), you need to be extra careful when constructing `UPDATE` statements.

大多数使用 SQL 的人在某个时候 **都会** 在更新数据时犯错。无论是在生产数据库中更新了错误的行集，还是意外地遗漏了 `WHERE` 子句（这会导致更新应用于 _所有_ 行），在构建 `UPDATE` 语句时都需要格外小心。

One helpful tip is to always write the constraint first and test it in a `SELECT` query to make sure you are updating the right rows, and only then writing the column/value pairs to update.

一个有用的提示是始终先编写约束条件，并在 `SELECT` 查询中测试它，以确保你更新的是正确的行，然后才编写要更新的列/值对。
