# SQLBolt - Learn SQL - SQL Lesson 17: Altering tables / SQLBolt - 学习 SQL - SQL 课程 17：更改表

SQL Lesson 17: Altering tables

SQL 课程 17：更改表

As your data changes over time, SQL provides a way for you to update your corresponding tables and database schemas by using the `ALTER TABLE` statement to add, remove, or modify columns and table constraints.

随着数据随时间变化，SQL 提供了一种方法，让你使用 `ALTER TABLE` 语句来更新相应的表和数据库模式，通过添加、删除或修改列和表约束。

## Adding columns / 添加列

The syntax for adding a new column is similar to the syntax when creating new rows in the `CREATE TABLE` statement. You need to specify the data type of the column along with any potential table constraints and default values to be applied to both existing _and_ new rows. In some databases like MySQL, you can even specify where to insert the new column using the `FIRST` or `AFTER` clauses, though this is not a standard feature.

添加新列的语法与在 `CREATE TABLE` 语句中创建新行时的语法类似。你需要指定列的数据类型以及任何可能的表约束和默认值，这些默认值将应用于现有行 _和_ 新行。在某些数据库如 MySQL 中，你甚至可以使用 `FIRST` 或 `AFTER` 子句指定插入新列的位置，尽管这不是标准功能。

Altering table to add new column(s)

更改表以添加新列

```sql
ALTER TABLE mytable
ADD column DataType OptionalTableConstraint
    DEFAULT default_value;
```

## Removing columns / 删除列

Dropping columns is as easy as specifying the column to drop, however, some databases (including SQLite) don't support this feature. Instead you may have to create a new table and migrate the data over.

删除列就像指定要删除的列一样简单，然而，一些数据库（包括 SQLite）不支持此功能。相反，你可能需要创建一个新表并将数据迁移过去。

Altering table to remove column(s)

更改表以删除列

```sql
ALTER TABLE mytable
DROP column_to_be_deleted;
```

## Renaming the table / 重命名表

If you need to rename the table itself, you can also do that using the `RENAME TO` clause of the statement.

如果你需要重命名表本身，也可以使用语句的 `RENAME TO` 子句来完成。

Altering table name

更改表名

```sql
ALTER TABLE mytable
RENAME TO new_table_name;
```

## Other changes / 其他更改

Each database implementation supports different methods of altering their tables, so it's always best to consult your database docs before proceeding: [MySQL](https://dev.mysql.com/doc/refman/5.6/en/alter-table.html "MySQL Alter Table"), [Postgres](http://www.postgresql.org/docs/9.4/static/sql-altertable.html "Postgres Alter Table"), [SQLite](https://www.sqlite.org/lang_altertable.html "SQLite Alter Table"), [Microsoft SQL Server](https://msdn.microsoft.com/en-us/library/ms190273.aspx "Microsoft SQL Server Alter Table").

每个数据库实现支持不同的更改表的方法，因此在继续之前最好查阅你的数据库文档：[MySQL](https://dev.mysql.com/doc/refman/5.6/en/alter-table.html "MySQL Alter Table"), [Postgres](http://www.postgresql.org/docs/9.4/static/sql-altertable.html "Postgres Alter Table"), [SQLite](https://www.sqlite.org/lang_altertable.html "SQLite Alter Table"), [Microsoft SQL Server](https://msdn.microsoft.com/en-us/library/ms190273.aspx "Microsoft SQL Server Alter Table")。
