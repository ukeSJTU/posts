# SQLBolt - Learn SQL - SQL Lesson 4: Filtering and sorting Query results / SQLBolt - 学习 SQL - SQL 课程 4：过滤和排序查询结果

SQL Lesson 4: Filtering and sorting Query results

SQL 课程 4：过滤和排序查询结果

Even though the data in a database may be unique, the results of any particular query may not be – take our Movies table for example, many different movies can be released the same year. In such cases, SQL provides a convenient way to discard rows that have a duplicate column value by using the `DISTINCT` keyword.

尽管数据库中的数据可能是唯一的，但任何特定查询的结果可能并非如此——以我们的 Movies 表为例，许多不同的电影可能在同一年上映。在这种情况下，SQL 提供了一种方便的方法，通过使用 `DISTINCT` 关键字来丢弃具有重复列值的行。

Select query with unique results

具有唯一结果的 SELECT 查询

```sql
SELECT DISTINCT column, another_column, …
FROM mytable
WHERE condition(s);
```

Since the `DISTINCT` keyword will blindly remove duplicate rows, we will learn in a future lesson how to discard duplicates based on specific columns using grouping and the `GROUP BY` clause.

由于 `DISTINCT` 关键字会盲目地删除重复行，我们将在未来的课程中学习如何使用分组和 `GROUP BY` 子句基于特定列丢弃重复项。

## Ordering results / 排序结果

Unlike our neatly ordered table in the last few lessons, most data in real databases are added in no particular column order. As a result, it can be difficult to read through and understand the results of a query as the size of a table increases to thousands or even millions rows.

与前几课中整齐有序的表不同，真实数据库中的大多数数据没有特定的列顺序添加。因此，随着表的大小增加到数千甚至数百万行，阅读和理解查询结果可能会变得困难。

To help with this, SQL provides a way to sort your results by a given column in ascending or descending order using the `ORDER BY` clause.

为了帮助解决这个问题，SQL 提供了一种方法，使用 `ORDER BY` 子句按给定列以升序或降序对结果进行排序。

Select query with ordered results

具有排序结果的 SELECT 查询

```sql
SELECT column, another_column, …
FROM mytable
WHERE condition(s)
ORDER BY column ASC/DESC;
```

When an `ORDER BY` clause is specified, each row is sorted alpha-numerically based on the specified column's value. In some databases, you can also specify a collation to better sort data containing international text.

当指定了 `ORDER BY` 子句时，每一行都会根据指定列的值按字母数字顺序排序。在某些数据库中，你还可以指定一个排序规则，以更好地排序包含国际文本的数据。

## Limiting results to a subset / 限制结果为子集

Another clause which is commonly used with the `ORDER BY` clause are the `LIMIT` and `OFFSET` clauses, which are a useful optimization to indicate to the database the subset of the results you care about.  
The `LIMIT` will reduce the number of rows to return, and the optional `OFFSET` will specify where to begin counting the number rows from.

另一个常与 `ORDER BY` 子句一起使用的子句是 `LIMIT` 和 `OFFSET` 子句，这是一种有用的优化方法，用于向数据库指示你关心的结果子集。  
`LIMIT` 将减少返回的行数，而可选的 `OFFSET` 将指定从哪里开始计算行数。

Select query with limited rows

具有限制行数的 SELECT 查询

```sql
SELECT column, another_column, …
FROM mytable
WHERE condition(s)
ORDER BY column ASC/DESC
LIMIT num_limit OFFSET num_offset;
```

If you think about websites like Reddit or Pinterest, the front page is a list of links sorted by popularity and time, and each subsequent page can be represented by sets of links at different offsets in the database. Using these clauses, the database can then execute queries faster and more efficiently by processing and returning only the requested content.

如果你想想像 Reddit 或 Pinterest 这样的网站，首页是按受欢迎程度和时间排序的链接列表，后续每一页都可以表示为数据库中不同偏移量的链接集。使用这些子句，数据库可以通过仅处理和返回请求的内容来更快、更高效地执行查询。

> Did you know?
>
> If you are curious about when the `LIMIT` and `OFFSET` are applied relative to the other parts of a query, they are generally done last after the other clauses have been applied. We'll touch more on this in [Lesson 12: Order of execution](/lesson/select_queries_order_of_execution) after introducting a few more parts of the query.
>
> 你知道吗？
>
> 如果你好奇 `LIMIT` 和 `OFFSET` 相对于查询的其他部分何时应用，它们通常在其他子句应用之后最后执行。我们将在介绍查询的更多部分后，在[第 12 课：执行顺序](/lesson/select_queries_order_of_execution)中进一步讨论这一点。
