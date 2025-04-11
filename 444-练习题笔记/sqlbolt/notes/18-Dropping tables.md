# SQLBolt - Learn SQL - SQL Lesson 18: Dropping tables / SQLBolt - 学习 SQL - SQL 课程 18：删除表

SQL Lesson 18: Dropping tables

SQL 课程 18：删除表

In some rare cases, you may want to remove an entire table including all of its data and metadata, and to do so, you can use the `DROP TABLE` statement, which differs from the `DELETE` statement in that it also removes the table schema from the database entirely.

在一些罕见的情况下，你可能想要删除整个表，包括其所有数据和元数据，为此，你可以使用 `DROP TABLE` 语句，它与 `DELETE` 语句的不同之处在于它还会从数据库中完全删除表模式。

Drop table statement

DROP TABLE 语句

```sql
DROP TABLE IF EXISTS mytable;
```

Like the `CREATE TABLE` statement, the database may throw an error if the specified table does not exist, and to suppress that error, you can use the `IF EXISTS` clause.

与 `CREATE TABLE` 语句类似，如果指定的表不存在，数据库可能会抛出错误，为了抑制该错误，你可以使用 `IF EXISTS` 子句。

In addition, if you have another table that is dependent on columns in table you are removing (for example, with a `FOREIGN KEY` dependency) then you will have to either update all dependent tables first to remove the dependent rows or to remove those tables entirely.

此外，如果你有另一个表依赖于你要删除的表中的列（例如，具有 `FOREIGN KEY` 依赖关系），那么你必须先更新所有依赖表以删除依赖行，或者完全删除这些表。
