# Exercise

In this exercise, you'll need to create a new table for us to insert some new rows into.

```sql
SELECT * FROM database;
```

Exercise 16 — Tasks

1.  Create a new table named `Database` with the following columns:

    – `Name` A string (text) describing the name of the database  
    – `Version` A number (floating point) of the latest version of this database  
    – `Download_count` An integer count of the number of times this database was downloaded

    This table has no constraints.

---

# Answer

```sql
CREATE TABLE Database (
    Name TEXT,
    Version FLOAT,
    Download_count INTEGER
);
```
