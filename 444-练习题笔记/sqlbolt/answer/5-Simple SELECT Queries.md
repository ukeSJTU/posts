# Exercise / 练习

In the exercise below, you will be working with a different table. This table instead contains information about a few of the most populous cities of North America[\[1\]](http://en.wikipedia.org/wiki/List_of_North_American_cities_by_population "Wikipedia: North American 
cities by population") including their population and geo-spatial location in the world.

在下面的练习中，你将使用一个不同的表。这个表包含了北美一些人口最多的城市的信息[\[1\]](http://en.wikipedia.org/wiki/List_of_North_American_cities_by_population "Wikipedia: North American cities by population")，包括它们的人口和世界上的地理空间位置。

> Did you know?
>
> Positive latitudes correspond to the northern hemisphere, and positive longitudes correspond to the eastern hemisphere. Since North America is north of the equator and west of the prime meridian, all of the cities in the list have positive latitudes and negative longitudes.
>
> 你知道吗？
>
> 正纬度对应北半球，正经度对应东半球。由于北美位于赤道以北、本初子午线以西，列表中的所有城市都具有正纬度和负经度。

Try and write some queries to find the information requested in the tasks below. You may have to use a different combination of clauses in your query for each task. Once you're done, continue onto the next lesson to learn about queries that span multiple tables.

尝试编写一些查询来找到下面任务中请求的信息。你可能需要在每个任务的查询中使用不同的子句组合。完成后，继续下一课学习跨多个表的查询。

Table: north_american_cities

| city                | country       | population | latitude  | longitude   |
| ------------------- | ------------- | ---------- | --------- | ----------- |
| Guadalajara         | Mexico        | 1500800    | 20.659699 | -103.349609 |
| Toronto             | Canada        | 2795060    | 43.653226 | -79.383184  |
| Houston             | United States | 2195914    | 29.760427 | -95.369803  |
| New York            | United States | 8405837    | 40.712784 | -74.005941  |
| Philadelphia        | United States | 1553165    | 39.952584 | -75.165222  |
| Havana              | Cuba          | 2106146    | 23.05407  | -82.345189  |
| Mexico City         | Mexico        | 8555500    | 19.432608 | -99.133208  |
| Phoenix             | United States | 1513367    | 33.448377 | -112.074037 |
| Los Angeles         | United States | 3884307    | 34.052234 | -118.243685 |
| Ecatepec de Morelos | Mexico        | 1742000    | 19.601841 | -99.050674  |
| Montreal            | Canada        | 1717767    | 45.501689 | -73.567256  |
| Chicago             | United States | 2718782    | 41.878114 | -87.629798  |

```sql
SELECT * FROM north_american_cities;
```

Review 1 — Tasks / 复习 1 — 任务

1.  List all the Canadian cities and their populations
2.  Order all the cities in the United States by their latitude from north to south
3.  List all the cities west of Chicago, ordered from west to east
4.  List the two largest cities in Mexico (by population)
5.  List the third and fourth largest cities (by population) in the United States and their population

6.  列出所有加拿大城市及其人口
7.  按纬度从北到南排列美国的所有城市
8.  列出芝加哥以西的所有城市，按从西到东的顺序排列
9.  列出墨西哥人口最多的两个城市（按人口）
10. 列出美国人口第三和第四大的城市（按人口）及其人口

---

# Answer / 答案

```sql
SELECT city, population FROM north_american_cities WHERE country="Canada";
SELECT city FROM north_american_cities WHERE country="United States" ORDER BY latitude DESC;
SELECT city FROM north_american_cities WHERE longitude<-87.629798 ORDER BY longitude ASC;
SELECT city FROM north_american_cities WHERE country="Mexico" ORDER BY population DESC LIMIT 2;
SELECT city, population FROM north_american_cities WHERE country="United States" ORDER BY population DESC LIMIT 2 OFFSET 2;
```
