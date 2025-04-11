# SQLBolt - Learn SQL - SQL Lesson 16: Creating tables / SQLBolt - 学习 SQL - SQL 课程 16：创建表

SQL Lesson 16: Creating tables

SQL 课程 16：创建表

When you have new entities and relationships to store in your database, you can create a new database table using the `CREATE TABLE` statement.

当你有新的实体和关系要存储在数据库中时，可以使用 `CREATE TABLE` 语句创建新的数据库表。

Create table statement w/ optional table constraint and default value

带有可选表约束和默认值的 CREATE TABLE 语句

```sql
CREATE TABLE IF NOT EXISTS mytable (
    column DataType TableConstraint DEFAULT default_value,
    another_column DataType TableConstraint DEFAULT default_value,
    …
);
```

The structure of the new table is defined by its _table schema_, which defines a series of columns. Each column has a name, the type of data allowed in that column, an _optional_ table constraint on values being inserted, and an optional default value.

新表的结构由其 _表模式_ 定义，该模式定义了一系列列。每列有一个名称，允许在该列中的数据类型，插入值的 _可选_ 表约束，以及一个可选的默认值。

If there already exists a table with the same name, the SQL implementation will usually throw an error, so to suppress the error and skip creating a table if one exists, you can use the `IF NOT EXISTS` clause.

如果已经存在同名的表，SQL 实现通常会抛出错误，因此为了抑制错误并在表存在时跳过创建表，你可以使用 `IF NOT EXISTS` 子句。

## Table data types / 表数据类型

Different databases support different data types, but the common types support numeric, string, and other miscellaneous things like dates, booleans, or even binary data. Here are some examples that you might use in real code.

不同的数据库支持不同的数据类型，但常见类型支持数字、字符串和其他杂项内容，如日期、布尔值，甚至二进制数据。以下是你可能在实际代码中使用的一些示例。

| Data type                                            | Description                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| ---------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| `INTEGER`, `BOOLEAN`                                 | The integer datatypes can store whole integer values like the count of a number or an age. In some implementations, the boolean value is just represented as an integer value of just 0 or 1.                                                                                                                                                                                                                                                          |
| `FLOAT`, `DOUBLE`, `REAL`                            | The floating point datatypes can store more precise numerical data like measurements or fractional values. Different types can be used depending on the floating point precision required for that value.                                                                                                                                                                                                                                              |
| `CHARACTER(num_chars)`, `VARCHAR(num_chars)`, `TEXT` | The text based datatypes can store strings and text in all sorts of locales. The distinction between the various types generally amount to underlaying efficiency of the database when working with these columns.<br><br>Both the CHARACTER and VARCHAR (variable character) types are specified with the max number of characters that they can store (longer values may be truncated), so can be more efficient to store and query with big tables. |
| `DATE`, `DATETIME`                                   | SQL can also store date and time stamps to keep track of time series and event data. They can be tricky to work with especially when manipulating data across timezones.                                                                                                                                                                                                                                                                               |
| `BLOB`                                               | Finally, SQL can store binary data in blobs right in the database. These values are often opaque to the database, so you usually have to store them with the right metadata to requery them.                                                                                                                                                                                                                                                           |

Docs: [MySQL](http://dev.mysql.com/doc/refman/5.6/en/data-types.html "MySQL Data Types"), [Postgres](http://www.postgresql.org/docs/9.4/static/datatype.html "Postgres Data Types"), [SQLite](https://www.sqlite.org/datatype3.html "SQLite Data Types"), [Microsoft SQL Server](https://msdn.microsoft.com/en-us/library/ms187752.aspx "Microsoft SQL Server Data Types")

## Table constraints / 表约束

We aren't going to dive too deep into table constraints in this lesson, but each column can have additional table constraints on it which limit what values can be inserted into that column. This is not a comprehensive list, but will show a few common constraints that you might find useful.

我们不会在本课中深入探讨表约束，但每列可以有额外的表约束，限制可以插入该列的值。这不是一个完整的列表，但会展示一些你可能觉得有用的常见约束。

| Constraint           | Description                                                                                                                                                                                                                                                                                                                                                                                    |
| -------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `PRIMARY KEY`        | This means that the values in this column are unique, and each value can be used to identify a single row in this table.                                                                                                                                                                                                                                                                       |
| `AUTOINCREMENT`      | For integer values, this means that the value is automatically filled in and incremented with each row insertion. Not supported in all databases.                                                                                                                                                                                                                                              |
| `UNIQUE`             | This means that the values in this column have to be unique, so you can't insert another row with the same value in this column as another row in the table. Differs from the `PRIMARY KEY` in that it doesn't have to be a key for a row in the table.                                                                                                                                        |
| `NOT NULL`           | This means that the inserted value can not be `NULL`.                                                                                                                                                                                                                                                                                                                                          |
| `CHECK (expression)` | This allows you to run a more complex expression to test whether the values inserted are valid. For example, you can check that values are positive, or greater than a specific size, or start with a certain prefix, etc.                                                                                                                                                                     |
| `FOREIGN KEY`        | This is a consistency check which ensures that each value in this column corresponds to another value in a column in another table.<br><br>For example, if there are two tables, one listing all Employees by ID, and another listing their payroll information, the `FOREIGN KEY` can ensure that every row in the payroll table corresponds to a valid employee in the master Employee list. |

## An example / 示例

Here's an example schema for the _Movies_ table that we've been using in the lessons up to now.

这是我们至今在课程中一直在使用的 _Movies_ 表的示例模式。

Movies table schema

Movies 表模式

```sql
CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title TEXT,
    director TEXT,
    year INTEGER,
    length_minutes INTEGER
);
```
