# Exercise

For this exercise, we are going to work with our **Employees** table. Notice how the rows in this table have shared data, which will give us an opportunity to use aggregate functions to summarize some high-level metrics about the teams. Go ahead and give it a shot.

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

Exercise 10 — Tasks

1.  Find the longest time that an employee has been at the studio
2.  For each role, find the average number of years employed by employees in that role
3.  Find the total number of employee years worked in each building

---

# Answer

```sql
SELECT MAX(years_employed) FROM employees;
SELECT AVG(years_employed) AS avg_years_employed, role FROM employees GROUP BY role;
SELECT SUM(years_employed) AS sum_years_employed, building FROM employees GROUP BY building;
```
