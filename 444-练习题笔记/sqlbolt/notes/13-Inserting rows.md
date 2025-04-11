# SQLBolt - Learn SQL - SQL Lesson 13: Inserting rows / SQLBolt - 学习 SQL - SQL 课程 13：插入行

SQL Lesson 13: Inserting rows

SQL 课程 13：插入行

We've spent quite a few lessons on how to query for data in a database, so it's time to start learning a bit about SQL schemas and how to add new data.

我们已经花了好几节课学习如何在数据库中查询数据，现在是时候开始学习一些关于 SQL 模式以及如何添加新数据的内容了。

## What is a Schema? / 什么是模式？

We previously described a table in a database as a two-dimensional set of rows and columns, with the columns being the properties and the rows being instances of the entity in the table. In SQL, the _database schema_ is what describes the structure of each table, and the datatypes that each column of the table can contain.

我们之前将数据库中的表描述为行和列的二维集合，列是属性，行是表中实体的实例。在 SQL 中，_数据库模式_ 描述了每个表的结构，以及表中每列可以包含的数据类型。

> Example: Correlated subquery
>
> For example, in our **Movies** table, the values in the _Year_ column must be an Integer, and the values in the _Title_ column must be a String.
>
> 示例：相关子查询
>
> 例如，在我们的 **Movies** 表中，_Year_ 列中的值必须是整数，而 _Title_ 列中的值必须是字符串。

This fixed structure is what allows a database to be efficient, and consistent despite storing millions or even billions of rows.

这种固定的结构使数据库即使存储数百万甚至数十亿行数据也能保持高效和一致性。

## Inserting new data / 插入新数据

When inserting data into a database, we need to use an `INSERT` statement, which declares which table to write into, the columns of data that we are filling, and one or more rows of data to insert. In general, each row of data you insert should contain values for every corresponding column in the table. You can insert multiple rows at a time by just listing them sequentially.

在向数据库插入数据时，我们需要使用 `INSERT` 语句，该语句声明要写入哪个表，我们要填充的数据列，以及要插入的一行或多行数据。一般来说，你插入的每行数据都应该包含表中每个对应列的值。你可以通过按顺序列出多行数据来一次性插入多行。

Insert statement with values for all columns

为所有列提供值的 INSERT 语句

```sql
INSERT INTO mytable
VALUES (value_or_expr, another_value_or_expr, …),
       (value_or_expr_2, another_value_or_expr_2, …),
       …;
```

In some cases, if you have incomplete data and the table contains columns that support default values, you can insert rows with only the columns of data you have by specifying them explicitly.

在某些情况下，如果你的数据不完整，并且表中包含支持默认值的列，你可以通过明确指定来插入只有你拥有的数据列的行。

Insert statement with specific columns

为特定列提供值的 INSERT 语句

```sql
INSERT INTO mytable
(column, another_column, …)
VALUES (value_or_expr, another_value_or_expr, …),
      (value_or_expr_2, another_value_or_expr_2, …),
      …;
```

In these cases, the number of values need to match the number of columns specified. Despite this being a more verbose statement to write, inserting values this way has the benefit of being forward compatible. For example, if you add a new column to the table with a default value, no hardcoded `INSERT` statements will have to change as a result to accommodate that change.

在这些情况下，值的数量需要与指定的列数匹配。尽管这种方式编写语句更为冗长，但以这种方式插入值具有向前兼容的好处。例如，如果你在表中添加一个具有默认值的新列，结果不需要更改硬编码的 `INSERT` 语句来适应这种变化。

In addition, you can use mathematical and string expressions with the values that you are inserting.  
This can be useful to ensure that all data inserted is formatted a certain way.

此外，你可以在插入的值中使用数学和字符串表达式。  
这可以有助于确保插入的所有数据都以某种方式格式化。

Example Insert statement with expressions

使用表达式的示例 INSERT 语句

```sql
INSERT INTO boxoffice
(movie_id, rating, sales_in_millions)
VALUES (1, 9.9, 283742034 / 1000000);
```
