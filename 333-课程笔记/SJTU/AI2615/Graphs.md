Todays' Goal:

- Learn DFS.
- Learn applications of DFS.
  - Connected Components
  - Cycle Check
  - Topological Order
  - Strongly Connected Components
- Learn to form a nice property of graphs.
  - Strongly Connected Components
- Learn to analyze the correctness of graph algorithms.

# Basic Graph Algorithms

Depth First Search and Its Applications

## What is Graphs?

```mermaid
graph LR
    A[Vertex 1] -- Edge 1 -- B[Vertex 2]
    B -- Edge 2 -- C[Vertex 3]
    C -- Edge 3 -- D[Vertex 4]
    D -- Edge 4 -- A
```

## Large Graphs in Real World

Facebook friends

Airlines

## We can have directions!

vertex / arcs 的概念

In a directed graph

- Arc (u, v) means we can only go from u to v.
  ▪ In an undirected graph
- Edge (u, v) means we can go from u to v or go from v to u.
  ▪ Undirected graph & directed graph
- Undirected graph is a SPECIAL directed graph
- edge (u, v) → arc (u, v) & (v, u)
  ▪ How many arcs at most in an undirected graph?
- 𝐺 𝑉, 𝐸
- 0 ≤ 𝐸 ≤ 𝑉 𝑉 − 1 = 𝑂( 𝑉 2)

## How to store a graph?

- Adjacency matrix
- Adjacency list

让我深入讨论图的存储方式这个话题：

### 图的存储方法深入探讨 [6]

#### 1. 邻接矩阵（Adjacency Matrix）[7]

```
存储结构：V × V的二维数组
A[i][j] = 1 表示存在边(i,j)
A[i][j] = 0 表示不存在边(i,j)
```

**深入分析：**

1. 优势：

   - 查询两点间是否有边的时间复杂度为 O(1)
   - 适合稠密图（边数接近顶点数平方）
   - 实现简单，易于理解和修改
   - 方便进行矩阵运算（如求最短路径的 Floyd 算法）

2. 劣势：
   - 空间复杂度固定为 O(|V|²)，对于稀疏图来说浪费空间
   - 添加/删除顶点的操作代价高，需要重构矩阵
   - 遍历所有边的时间复杂度为 O(|V|²)，即使实际边数很少

#### 2. 邻接表（Adjacency List）[8][9]

```
存储结构：数组+链表
adj[u]存储顶点u的所有邻接点
每个邻接点包含顶点信息和指向下一个邻接点的指针
```

**深入分析：**

1. 优势：

   - 空间效率高，只需要 O(|V|+|E|)空间
   - 容易遍历顶点的所有邻接点
   - 适合稀疏图（边数远小于顶点数平方）
   - 添加边的操作简单高效

2. 劣势：
   - 查询两点间是否有边需要 O(degree(v))时间
   - 删除边操作较复杂
   - 需要额外的指针开销

---

Todays's Topic: Depth-First Search

## basic Graph Properties

### Reachability

- Can we go from u to v?
- Is v the friend of the friend of the friend ……. of u?
- Can we travel from city u to v?

如果 v 在 u 的 Adjacent list 里面，那么 v 是可达的

进一步，如果 v 是可达的，那么 v 的所有邻接点也是可达的。

回到刚刚的问题上：问题的输入是 adjacent list 记录的 graph G 以及一个 vertex u。想要输出的是 u 的所有可达的 vertex。

我们考虑一个简单的算法：

从 u 出发，如果 v 是在 u 里面的 adjacent list 里面，那么 v 是可达的。然后继续从 v 继续 explore。

但是这个问题就是碰到环的结构就会死循环了。

```mermaid
graph LR
    A[1] -- B[2]
    B -- C[3]
    C -- D[4]
    D -- A
    style A fill:#f9f,stroke:#333,stroke-width:2px
```

```mermaid
graph LR
    A[1] -- B[2]
    B -- C[3]
    C -- D[4]
    D -- A
    style A fill:#f9f,stroke:#333,stroke-width:2px
    style B fill:#f9f,stroke:#333,stroke-width:2px
    linkStyle 0 stroke:red,stroke-width:2px
```

```mermaid
graph LR
    A[1] -- B[2]
    B -- C[3]
    C -- D[4]
    D -- A
    style A fill:#f9f,stroke:#333,stroke-width:2px
    style B fill:#f9f,stroke:#333,stroke-width:2px
    style C fill:#f9f,stroke:#333,stroke-width:2px
    linkStyle 0 stroke:red,stroke-width:2px
    linkStyle 1 stroke:red,stroke-width:2px
```

```mermaid
graph LR
    A[1] -- B[2]
    B -- C[3]
    C -- D[4]
    D -- A
    style A fill:#f9f,stroke:#333,stroke-width:2px
    style B fill:#f9f,stroke:#333,stroke-width:2px
    style C fill:#f9f,stroke:#333,stroke-width:2px
    style D fill:#f9f,stroke:#333,stroke-width:2px
    linkStyle 0 stroke:red,stroke-width:2px
    linkStyle 1 stroke:red,stroke-width:2px
    linkStyle 2 stroke:red,stroke-width:2px
```

解决办法就是当我们到达一个点的时候，先把这个点标记为 visited。然后在 explore 的时候，如果发现这个点已经被访问过了，那么就说明有环了。

由此，我们修改一下算法：

```plaintext
Function explore(v)
    mark v as visited
    for each neighbor u of v
        if u is not visited
            explore(u)
```

### Connected Components

- Undirected version
- A maximal subgraph that each two vertices are reachable.
- A group of people who know each others
- Directed version?

## BFS and Dijkstra

### BFS

#### 基础概念

What is path? Under directed grph

What is distance?

#### 算法设计

BFS 算法的分析

#### 时间复杂度计算

时间复杂度计算

#### 变种：求最短路径

那么如果想知道谁是最短路径？不影响复杂度，利用`pre`数组记录。

#### DFS vs BFS

|     | DFS |
| --- | --- |
|     |     |
|     |     |
|     |     |

### Dijkstra

如果边上有权重怎么办？基于 BFS 的思路拓展。

#### 基础概念

这里解释之前的概念，但是有权重。

那么带权最短路径是？

#### 能不能用 BFS 的类似思路？

简单的证明是：最终生成的仍然是 shortest path tree

如果从 inductive 的角度证明：
先定义 SPT，shortest path tree
对于任意点 v，按照 SPT 中 s 到 v 的路径走一定是最短路径

是不是一定能加进去是不确定的，尽管 sbv 这个路径是目前看起来最小的，但是仍然有可能存在另一个点 x 使得 sxv 的路径更短。所以，换句话说，只要我们规定添加的规则是每次只添加当前可添加的点里面的距离最近的那个点，就可以避免这个问题。

但是我个人觉得上面这个的前提是权重非负。换句话说，可以想像：s 是起点，这个时候有两个点 x1，x2。s 到 x1 是距离 10，到 x2 是 2.按照上面的规则应该先添加 x2.这个前提是 x1 到
x2 的路径可能存在，但是即使存在也应该非负。如果可以为负数，那么 x1 到 x2 的权重是-9，这个是 s-x1-x2 的路径最短为 1.这个也应该就是为什么后面我们还要选析 negative weights 的最短路径算法。

#### 算法伪代码

#### 时间复杂度分析

先分析：得到结论是 V+E

但是具体的总时间复杂度取决于实现的数据结构：

如果用数组：……

如果用堆：还有各种各样的堆。

| Heap type     | Pop Min | Insert | Update Key | Merge |
| ------------- | ------- | ------ | ---------- | ----- |
| Binary Heap   |         |        |            |       |
| d-nary Heap   |         |        |            |       |
| Binomial Heap |         |        |            |       |
| Fibonacci     |         |        |            |       |

我们下面还会学习这个 FIbonacci-Heap

先复习一下 Binary Heap

```

```
