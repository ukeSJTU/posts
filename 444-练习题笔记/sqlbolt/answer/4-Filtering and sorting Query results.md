# Exercise

There are a few concepts in this lesson, but all are pretty straight-forward to apply. To spice things up, we've gone and scrambled the **Movies** table for you in the exercise to better mimic what kind of data you might see in real life. Try and use the necessary keywords and clauses introduced above in your queries.

Table: movies

| id  | title               | director       | year | length_minutes |
| --- | ------------------- | -------------- | ---- | -------------- |
| 1   | Up                  | Pete Docter    | 2009 | 101            |
| 2   | Cars 2              | John Lasseter  | 2011 | 120            |
| 3   | Toy Story 2         | John Lasseter  | 1999 | 93             |
| 4   | Toy Story           | John Lasseter  | 1995 | 81             |
| 5   | Finding Nemo        | Andrew Stanton | 2003 | 107            |
| 6   | A Bug's Life        | John Lasseter  | 1998 | 95             |
| 7   | Brave               | Brenda Chapman | 2012 | 102            |
| 8   | The Incredibles     | Brad Bird      | 2004 | 116            |
| 9   | WALL-E              | Andrew Stanton | 2008 | 104            |
| 10  | Monsters University | Dan Scanlon    | 2013 | 110            |
| 11  | Monsters, Inc.      | Pete Docter    | 2001 | 92             |
| 12  | Cars                | John Lasseter  | 2006 | 117            |
| 13  | Toy Story 3         | Lee Unkrich    | 2010 | 103            |
| 14  | Ratatouille         | Brad Bird      | 2007 | 115            |

```sql
SELECT * FROM movies;
```

Exercise 4 — Tasks

1.  List all directors of Pixar movies (alphabetically), without duplicates
2.  List the last four Pixar movies released (ordered from most recent to least)
3.  List the **first** five Pixar movies sorted alphabetically
4.  List the **next** five Pixar movies sorted alphabetically

---

# Answer

```sql
SELECT DISTINCT director FROM movies ORDER BY director ASC;
SELECT * FROM movies ORDER BY year DESC LIMIT 4;
SELECT * FROM movies ORDER BY title ASC LIMIT 5 OFFSET 0;
SELECT * FROM movies ORDER BY title ASC LIMIT 5 OFFSET 5;
```
