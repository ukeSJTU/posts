# Exercise / 练习

In this exercise, you are going to be working with a new table which stores fictional data about **Employees** in the film studio and their assigned office **Buildings**. Some of the buildings are new, so they don't have any employees in them yet, but we need to find some information about them regardless.

在本练习中，你将使用一个新表，该表存储了关于电影工作室的 **Employees** 及其分配的办公 **Buildings** 的虚构数据。有些建筑物是新的，所以还没有员工在其中，但我们仍然需要找到关于它们的一些信息。

Since our browser SQL database is somewhat limited, only the `LEFT JOIN` is supported in the exercise below.

由于我们的浏览器 SQL 数据库有些限制，在下面的练习中仅支持 `LEFT JOIN`。

Table: buildings (Read-only)

| building_name | capacity |
| ------------- | -------- |
| 1e            | 24       |
| 1w            | 32       |
| 2e            | 16       |
| 2w            | 20       |

Table: employees (Read-only)

| role     | name       | building | years_employed |
| -------- | ---------- | -------- | -------------- |
| Engineer | Becky A.   | 1e       | 4              |
| Engineer | Dan B.     | 1e       | 2              |
| Engineer | Sharon F.  | 1e       | 6              |
| Engineer | Dan M.     | 1e       | 4              |
| Engineer | Malcom S.  | 1e       | 1              |
| Artist   | Tylar S.   | 2w       | 2              |
| Artist   | Sherman D. | 2w       | 8              |
| Artist   | Jakob J.   | 2w       | 6              |
| Artist   | Lillia A.  | 2w       | 7              |
| Artist   | Brandon J. | 2w       | 7              |
| Manager  | Scott K.   | 1e       | 9              |
| Manager  | Shirlee M. | 1e       | 3              |
| Manager  | Daria O.   | 2w       | 6              |

```sql
SELECT * FROM employees;
```

Exercise 7 — Tasks / 练习 7 — 任务

1.  Find the list of all buildings that have employees
2.  Find the list of all buildings and their capacity
3.  List all buildings and the distinct employee roles in each building (including empty buildings)

4.  找到有员工的所有建筑物列表
5.  找到所有建筑物及其容量的列表
6.  列出所有建筑物及其每个建筑物中的不同员工角色（包括空建筑物）

---

# Answer / 答案

```sql
SELECT DISTINCT building FROM employees;
SELECT * FROM buildings;
SELECT DISTINCT building_name, role FROM buildings LEFT JOIN employees ON building_name = building;
```
