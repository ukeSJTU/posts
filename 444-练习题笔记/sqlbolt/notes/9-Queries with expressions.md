# SQLBolt - Learn SQL - SQL Lesson 9: Queries with expressions / SQLBolt - 学习 SQL - SQL 课程 9：使用表达式的查询

SQL Lesson 9: Queries with expressions

SQL 课程 9：使用表达式的查询

In addition to querying and referencing raw column data with SQL, you can also use _expressions_ to write more complex logic on column values in a query. These expressions can use mathematical and string functions along with basic arithmetic to transform values when the query is executed, as shown in this physics example.

除了使用 SQL 查询和引用原始列数据外，你还可以使用 _表达式_ 在查询中对列值编写更复杂的逻辑。这些表达式可以使用数学和字符串函数以及基本算术来转换值，在查询执行时，如这个物理示例所示。

Example query with expressions

使用表达式的示例查询

```sql
SELECT particle_speed / 2.0 AS half_particle_speed
FROM physics_data
WHERE ABS(particle_position) * 10.0 > 500;
```

Each database has its own supported set of mathematical, string, and date functions that can be used in a query, which you can find in their own respective docs.

每个数据库都有自己支持的一组数学、字符串和日期函数，可在查询中使用，你可以在它们各自的文档中找到这些函数。

The use of expressions can save time and extra post-processing of the result data, but can also make the query harder to read, so we recommend that when expressions are used in the `SELECT` part of the query, that they are also given a descriptive _alias_ using the `AS` keyword.

使用表达式可以节省时间和结果数据的额外后处理，但也可能使查询更难阅读，因此我们建议当在查询的 `SELECT` 部分使用表达式时，也使用 `AS` 关键字为它们提供描述性的 _别名_。

Select query with expression aliases

使用表达式别名的 SELECT 查询

```sql
SELECT col_expression AS expr_description, …
FROM mytable;
```

In addition to expressions, regular columns and even tables can also have aliases to make them easier to reference in the output and as a part of simplifying more complex queries.

除了表达式外，常规列甚至表也可以有别名，以便在输出中更容易引用，并作为简化更复杂查询的一部分。

Example query with both column and table name aliases

同时具有列和表名别名的示例查询

```sql
SELECT column AS better_column_name, …
FROM a_long_widgets_table_name AS mywidgets
INNER JOIN widget_sales
  ON mywidgets.id = widget_sales.widget_id;
```
