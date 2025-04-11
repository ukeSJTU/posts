# SQLBolt - Learn SQL - SQL Lesson 3: Queries with constraints (Pt. 2) / SQLBolt - 学习 SQL - SQL 课程 3：带约束的查询（第 2 部分）

SQL Lesson 3: Queries with constraints (Pt. 2)

SQL 课程 3：带约束的查询（第 2 部分）

When writing `WHERE` clauses with columns containing text data, SQL supports a number of useful operators to do things like case-insensitive string comparison and wildcard pattern matching. We show a few common text-data specific operators below:

在编写包含文本数据的列的 `WHERE` 子句时，SQL 支持许多有用的运算符，可以进行不区分大小写的字符串比较和通配符模式匹配。我们在下面展示了一些常见的特定于文本数据的运算符：

| Operator     | Condition                                                                                             | Example                                                            |
| ------------ | ----------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------ |
| =            | Case sensitive exact string comparison (notice the single equals)                                     | col_name = "abc"                                                   |
| != or <>     | Case sensitive exact string inequality comparison                                                     | col_name != "abcd"                                                 |
| LIKE         | Case insensitive exact string comparison                                                              | col_name LIKE "ABC"                                                |
| NOT LIKE     | Case insensitive exact string inequality comparison                                                   | col_name NOT LIKE "ABCD"                                           |
| %            | Used anywhere in a string to match a sequence of zero or more characters (only with LIKE or NOT LIKE) | col_name LIKE "%AT%" (matches "AT", "ATTIC", "CAT" or even "BATS") |
| `_`          | Used anywhere in a string to match a single character (only with LIKE or NOT LIKE)                    | col_name LIKE "AN\*" (matches "AND", but not "AN")                 |
| IN (...)     | String exists in a list                                                                               | col_name IN ("A", "B", "C")                                        |
| NOT IN (...) | String does not exist in a list                                                                       | col_name NOT IN ("D", "E", "F")                                    |

> Did you know?
>
> All strings must be quoted so that the query parser can distinguish words in the string from SQL keywords.
>
> 你知道吗？
>
> 所有字符串都必须加引号，以便查询解析器能够区分字符串中的单词与 SQL 关键字。

We should note that while most database implementations are quite efficient when using these operators, full-text search is best left to dedicated libraries like [Apache Lucene](http://lucene.apache.org/ "Apache Lucene") or [Sphinx](http://sphinxsearch.com/ "Sphinx Search"). These libraries are designed specifically to do full text search, and as a result are more efficient and can support a wider variety of search features including internationalization and advanced queries.

我们应该注意到，虽然大多数数据库实现使用这些运算符时效率很高，但全文搜索最好留给专门的库，如 [Apache Lucene](http://lucene.apache.org/ "Apache Lucene") 或 [Sphinx](http://sphinxsearch.com/ "Sphinx Search")。这些库专门设计用于全文搜索，因此效率更高，并且可以支持更广泛的搜索功能，包括国际化和高级查询。
