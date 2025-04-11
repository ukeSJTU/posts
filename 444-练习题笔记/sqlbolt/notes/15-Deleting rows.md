# SQLBolt - Learn SQL - SQL Lesson 15: Deleting rows / SQLBolt - 学习 SQL - SQL 课程 15：删除行

SQL Lesson 15: Deleting rows

SQL 课程 15：删除行

When you need to delete data from a table in the database, you can use a `DELETE` statement, which describes the table to act on, and the rows of the table to delete through the `WHERE` clause.

当你需要从数据库的表中删除数据时，可以使用 `DELETE` 语句，该语句描述要操作的表，以及通过 `WHERE` 子句要删除的表中的行。

Delete statement with condition

带有条件的 DELETE 语句

```sql
DELETE FROM mytable
WHERE condition;
```

If you decide to leave out the `WHERE` constraint, then _all_ rows are removed, which is a quick and easy way to clear out a table completely (if intentional).

如果你决定省略 `WHERE` 约束条件，那么 _所有_ 行都将被删除，这是一种快速且简单的方法来完全清空表（如果是有意的）。

## Taking extra care / 格外小心

Like the `UPDATE` statement from last lesson, it's recommended that you run the constraint in a `SELECT` query first to ensure that you are removing the right rows. Without a proper backup or test database, it is downright easy to irrevocably remove data, so always read your `DELETE` statements twice and execute once.

就像上一课的 `UPDATE` 语句一样，建议你先在 `SELECT` 查询中运行约束条件，以确保你删除的是正确的行。如果没有适当的备份或测试数据库，彻底删除数据是非常容易的，所以始终要仔细阅读你的 `DELETE` 语句两次，然后执行一次。
