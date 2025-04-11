# Exercise / 练习

For this exercise, we are going to work with our **Employees** table. Notice how the rows in this table have shared data, which will give us an opportunity to use aggregate functions to summarize some high-level metrics about the teams. Go ahead and give it a shot.

在本练习中，我们将使用我们的 **Employees** 表。注意这个表中的行有共享数据，这将给我们一个机会使用聚合函数来总结团队的一些高级指标。去试试吧。

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

Exercise 10 — Tasks / 练习 10 — 任务

1.  Find the longest time that an employee has been at the studio
2.  For each role, find the average number of years employed by employees in that role
3.  Find the total number of employee years worked in each building

4.  找到员工在工作室工作时间最长的时间
5.  对于每个角色，找到该角色员工的平均工作年数
6.  找到每个建筑物中员工工作的总年数

---

# Answer / 答案

```sql
SELECT MAX(years_employed) FROM employees;
SELECT AVG(years_employed) AS avg_years_employed, role FROM employees GROUP BY role;
SELECT SUM(years_employed) AS sum_years_employed, building FROM employees GROUP BY building;
```
