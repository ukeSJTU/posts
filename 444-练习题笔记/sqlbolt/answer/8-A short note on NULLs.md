# Exercise / 练习

This exercise will be a sort of review of the last few lessons. We're using the same **Employees** and **Buildings** table from the last lesson, but we've hired a few more people, who haven't yet been assigned a building.

本练习将是对前几课的一种复习。我们使用与上一课相同的 **Employees** 和 **Buildings** 表，但我们又雇佣了一些人，他们尚未被分配到建筑物。

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
| Engineer | Yancy I.   |          | 0              |
| Artist   | Oliver P.  |          | 0              |

```sql
SELECT * FROM employees;
```

Exercise 8 — Tasks / 练习 8 — 任务

1.  Find the name and role of all employees who have not been assigned to a building
2.  Find the names of the buildings that hold no employees

3.  找到所有未被分配到建筑物的员工的姓名和角色
4.  找到没有员工的建筑物的名称

---

# Answer / 答案

```sql
SELECT name, role FROM employees WHERE building IS NULL;
SELECT DISTINCT building_name
FROM buildings
  LEFT JOIN employees
    ON building_name = building
WHERE role IS NULL;
```
