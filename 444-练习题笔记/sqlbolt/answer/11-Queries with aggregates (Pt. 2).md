# Exercise / 练习

For this exercise, you are going to dive deeper into **Employee** data at the film studio. Think about the different clauses you want to apply for each task.

在本练习中，你将深入探讨电影工作室的 **Employee** 数据。考虑你想为每个任务应用的不同子句。

Table: employees

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

Exercise 11 — Tasks / 练习 11 — 任务

1.  Find the number of Artists in the studio (without a **HAVING** clause)
2.  Find the number of Employees of each role in the studio
3.  Find the total number of years employed by all Engineers

4.  找到工作室中 Artists 的数量（不使用 **HAVING** 子句）
5.  找到工作室中每个角色的 Employees 数量
6.  找到所有 Engineers 的总工作年数

---

# Answer / 答案

```sql
SELECT COUNT(name) AS cnt FROM employees WHERE role="Artist";
SELECT COUNT(name) AS cnt, role FROM employees GROUP BY role;
SELECT SUM(years_employed) AS sum_year FROM employees WHERE role="Engineer";
-- OR
SELECT role, SUM(years_employed)
FROM employees
GROUP BY role
HAVING role = "Engineer";
```
