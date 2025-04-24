# Cheatsheet 2: 图算法 (Graphs)

## 1. 图的基本概念 (Graph Basics)

- **图 (Graph)**: 由顶点 (Vertex) 集合 $V$ 和边 (Edge) 集合 $E$ 组成，记为 $G=(V, E)$。
- **有向图 (Directed Graph)**: 边有方向，称为弧 (Arc)。$(u, v)$ 表示从 $u$ 到 $v$ 的弧。
- **无向图 (Undirected Graph)**: 边无方向。边 $(u, v)$ 等价于 $(v, u)$。可视为特殊的有向图，每条无向边对应两条方向相反的弧。
- **图的存储 (Storage)**:
  - **邻接矩阵 (Adjacency Matrix)**: 用 $|V| \times |V|$ 的矩阵表示， $A[i,j]=1$ 表示存在边 $(i,j)$。空间复杂度 $O(|V|^2)$。
  - **邻接表 (Adjacency List)**: 为每个顶点 $u$ 维护一个链表，存储其所有邻接顶点。空间复杂度 $O(|V|+|E|)$。

## 2. 图遍历算法 (Graph Traversal)

### 2.1 深度优先搜索 (Depth-First Search - DFS)

- **思想**: 尽可能深地探索图的分支。当一个顶点的所有邻接点都被访问过后，回溯到上一个顶点继续探索。
- **算法框架**:

  ```
  marked = array of false
  function explore(v):
      marked[v] = true
      for each edge (v, u): // 对于有向图是 (v, u) in E
          if not marked[u]:
              explore(u)

  function dfs(G):
      for each v in V:
          if not marked[v]:
              explore(v)
              // 可在此处处理新的连通分量/SCC
  ```

  (注意：PPT 中无向图伪代码 `for each (u,v) in E` 可能需要理解为遍历 v 的邻接边)

- **DFS 树**: DFS 过程中经过的边构成的树 (或森林)。
  - **边分类 (有向图)**:
    - 树边 (Tree edge): DFS 树中的边。
    - 前向边 (Forward edge): 从祖先节点指向后代节点 (非树边)。
    - 后向边 (Back edge): 从后代节点指向祖先节点。**指示存在环路**。
    - 交叉边 (Cross edge): 不属于以上三类，通常连接不同子树的边。
  - **边分类 (无向图)**: 只有树边和后向边。
- **时间复杂度**: $O(|V|+|E|)$。每个顶点和每条边最多访问常数次。
- **应用**:
  - **可达性 (Reachability)**: `explore(u)` 找到所有 $u$ 可达的顶点。
  - **连通分量 (Connected Components - CC, 无向图)**: 每次调用 `dfs(G)` 中的 `explore` 会访问一个完整的连通分量。
  - **环路检测 (Cycle Detection)**:
    - 无向图: 当 DFS 遇到一个已访问过但非父节点的邻居时，存在环路 (即存在后向边)。
    - 有向图: 当 DFS 遇到一个正在访问栈中的祖先节点时，存在环路 (即存在后向边)。
  - **拓扑排序 (Topological Sorting, DAG)**: 见下节。
  - **强连通分量 (Strongly Connected Components - SCC, 有向图)**: 见下节。

### 2.2 广度优先搜索 (Breadth-First Search - BFS)

- **思想**: 从源点 $s$ 出发，逐层探索图。先访问距离 $s$ 为 1 的所有顶点，然后是距离为 2 的，依此类推。
- **算法框架**: 通常使用队列实现。

  ```
  marked = array of false
  dist = array of infinity
  queue = new Queue()

  marked[s] = true
  dist[s] = 0
  queue.enqueue(s)

  while queue is not empty:
      u = queue.dequeue()
      for each edge (u, v): // 对于有向图是 (u, v) in E
          if not marked[v]:
              marked[v] = true
              dist[v] = dist[u] + 1
              queue.enqueue(v)
  ```

- **BFS 树**: BFS 过程中发现新顶点时经过的边构成的树。
- **性质**: BFS 树的层级等于节点到源点 $s$ 的最短路径长度 (在无权图中)。
- **时间复杂度**: $O(|V|+|E|)$。
- **应用**:
  - **无权图最短路径 (Shortest Path in Unweighted Graphs)**: BFS 找到的路径即为最短路径。

## 3. 拓扑排序 (Topological Sorting)

- **问题**: 对一个**有向无环图 (Directed Acyclic Graph - DAG)** 进行线性排序，使得对于图中任意弧 $(u, v)$， $u$ 都排在 $v$ 的前面。
- **前提**: 只有 DAG 才有拓扑排序。若图中存在环路，则无法进行拓扑排序。
- **算法 1 (基于出度/入度)** (PPT 中描述的是找 tail 即出度为 0 的点):
  1.  计算所有顶点的入度 (或出度)。
  2.  将所有入度为 0 (或出度为 0) 的顶点入队 (或栈)。
  3.  当队列 (或栈) 不为空时：
      - 出队 (或出栈) 一个顶点 $u$，加入拓扑序列。
      - 对于 $u$ 的每个邻居 $v$，将 $v$ 的入度减 1。若 $v$ 的入度变为 0，则将 $v$ 入队。
  4.  若最终拓扑序列顶点数小于 $|V|$，则说明图中存在环路。
  - **复杂度**: 找 tail (出度为 0) 的方法在 PPT 中分析为 $O(V^2)$，但用 Kahn 算法 (基于入度) 可以做到 $O(|V|+|E|)$。
- **算法 2 (基于 DFS)**:
  1.  对图进行 DFS，计算每个顶点的**完成时间 (finish time)**。
  2.  将顶点按完成时间**降序**排列，即得到一个拓扑序列。
  - **正确性**: 在 DAG 中，对于任意弧 $(u, v)$，必有 $finish(u) > finish(v)$。因为 DFS 访问到 $u$ 时：
    - 若 $v$ 未访问，则 $v$ 会在 $u$ 的 DFS 子树中完成， $finish(v) < finish(u)$。
    - 若 $v$ 正在访问 (灰色)，则存在后向边，与 DAG 矛盾。
    - 若 $v$ 已完成，则 $finish(v)$ 已经确定且小于 $u$ 的完成时间 $finish(u)$。
  - **复杂度**: DFS 需要 $O(|V|+|E|)$。

## 4. 强连通分量 (Strongly Connected Components - SCC)

- **定义**: 在有向图 $G=(V, E)$ 中，一个顶点子集 $C \subseteq V$ 是一个强连通分量，如果对于 $C$ 中任意两个顶点 $u, v$，存在从 $u$ 到 $v$ 的路径，也存在从 $v$ 到 $u$ 的路径，并且 $C$ 是满足此条件的最大顶点子集。
- **性质**:
  - 所有 SCC 构成图 $G$ 的顶点集 $V$ 的一个**划分 (Partition)**。
  - **SCC 图 (Component Graph)**: 将每个 SCC 看作一个超级节点，若原图中存在从 SCC $C_i$ 中某点到 SCC $C_j$ 中某点的弧，则在 SCC 图中画一条从 $C_i$ 到 $C_j$ 的弧。SCC 图是一个 **DAG**。
- **Kosaraju 算法 (双 DFS)**:
  1.  计算图 $G$ 的反图 $G^R$ (所有弧反向)。
  2.  在 $G^R$ 上运行 DFS，计算所有顶点的完成时间 $finish(v)$。
  3.  按照顶点在 $G^R$ 上的完成时间**降序**，对原图 $G$ 进行 DFS。
  4.  在第二步 DFS (对 G) 中，每次从尚未访问的顶点开始 `explore` 所访问到的顶点集合，构成一个 SCC。
  - **正确性关键**: 在 $G^R$ 上具有最晚完成时间的顶点 $v$ 必定属于 $G$ 中的一个 "源 SCC" (Source SCC)，即在 SCC 图中没有入边的 SCC。第二次在 $G$ 上从 $v$ 开始 DFS，恰好能访问完 $v$ 所在的整个 SCC，而不会访问到其他 SCC。然后移除这个 SCC，继续找剩余图中完成时间最晚的顶点，它属于剩余图中的源 SCC，依此类推。
  - **时间复杂度**: 两次 DFS 都是 $O(|V|+|E|)$，总复杂度 $O(|V|+|E|)$。
- **Tarjan 算法** (基于 DFS 树和 low-link 值，未在 Slides 中详细展开)。

## 5. 最短路径 (Shortest Path)

### 5.1 无权图最短路径 (Unweighted Shortest Path)

- **问题**: 找到从源点 $s$ 到图中所有其他顶点的最短路径 (边数最少)。
- **算法**: BFS。
- **正确性**: BFS 按层级扩展，第 $k$ 层访问到的顶点，其到 $s$ 的最短距离恰好为 $k$。
- **时间复杂度**: $O(|V|+|E|)$。

### 5.2 Dijkstra 算法 (非负权边)

- **问题**: 在边权**非负**的图中，找到从源点 $s$ 到所有其他顶点的最短路径 (路径权重之和最小)。
- **思想**: 贪心策略。维护一个已确定最短路径的顶点集合 $T$。每次从未在 $T$ 中的顶点里，选择一个当前估计距离 (`tdist`) 最小的顶点 $v$，将其加入 $T$，并更新 $v$ 的邻居的估计距离 (`tdist`)。
- **算法框架**:

  ```
  T = {} // 已确定最短路径的顶点集合
  tdist = array of infinity // 估计距离
  pre = array of null // 前驱节点
  tdist[s] = 0
  PriorityQueue pq // 存储 (tdist[v], v)，按 tdist 排序

  pq.insert((0, s))

  while pq is not empty:
      (d, u) = pq.extract_min()
      if u in T: continue
      T.add(u)

      for each edge (u, v) with weight w(u,v):
          if tdist[u] + w(u,v) < tdist[v]:
              tdist[v] = tdist[u] + w(u,v)
              pre[v] = u
              pq.decrease_key((tdist[v], v)) // 或 pq.insert((tdist[v], v))
  ```

- **正确性**: (基于归纳法和反证法证明) 当一个顶点 $v$ 被选出并加入 $T$ 时，其当前的 `tdist[v]` 就是 $s$ 到 $v$ 的真实最短路径 $dist(s, v)$。关键在于边权非负，保证了从 $T$ 外部绕回 $T$ 内部再到 $v$ 的路径不会比直接到 $v$ 的路径更短 (注意：PPT 中详细讨论了负权边导致证明失效的情况)。
- **时间复杂度**:
  - 使用数组实现优先队列: $O(|V|^2 + |E|)$。
  - 使用二叉堆 (Binary Heap): $O(|E| \log |V|)$。PopMin $O(\log V)$, UpdateKey (DecreaseKey) $O(\log V)$。$|V|$ 次 PopMin, 最多 $|E|$ 次 UpdateKey。
  - 使用斐波那契堆 (Fibonacci Heap): $O(|E| + |V| \log |V|)$。PopMin $O(\log V)$ (摊销), UpdateKey (DecreaseKey) $O(1)$ (摊销)。

### 5.3 Bellman-Ford 算法 (允许负权边，检测负环)

- **问题**: 在允许负权边的图中，找到从源点 $s$ 到所有其他顶点的最短路径，并能检测图中是否存在从 $s$ 可达的**负环 (Negative Cycle)**。
- **思想**: 动态规划思想。迭代地松弛 (Relax) 图中所有的边。经过 $k$ 轮松弛，可以找到所有最多包含 $k$ 条边的最短路径。
- **算法框架**:

  ```
  dist = array of infinity
  pre = array of null
  dist[s] = 0

  // Relax edges |V|-1 times
  for i from 1 to |V|-1:
      for each edge (u, v) with weight w(u,v):
          if dist[u] + w(u,v) < dist[v]:
              dist[v] = dist[u] + w(u,v)
              pre[v] = u

  // Check for negative cycles
  for each edge (u, v) with weight w(u,v):
      if dist[u] + w(u,v) < dist[v]:
          // Negative cycle detected
          report negative cycle
  ```

- **正确性**:
  - 若图中无负环，则任意两点间的最短路径最多包含 $|V|-1$ 条边。因此，经过 $|V|-1$ 轮松弛后，`dist[v]` 必定收敛到 $s$ 到 $v$ 的最短路径值。
  - 若经过 $|V|-1$ 轮松弛后，仍存在边 $(u, v)$ 可以被松弛 (即 `dist[u] + w(u,v) < dist[v]`)，则说明图中存在从 $s$ 可达的负环。
- **时间复杂度**: $|V|-1$ 轮迭代，每轮检查所有 $|E|$ 条边。复杂度 $O(|V| \cdot |E|)$。

## 6. 最小生成树 (Minimum Spanning Tree - MST) (出现在 Greedy 部分，但与图密切相关)

- **问题**: 给定一个连通的、无向的、带权图 $G=(V, E)$，找到一个边的子集 $T \subseteq E$，使得 $T$ 连接所有顶点 $V$ 且 $T$ 中不含环 (即 $T$ 是一棵生成树)，并且 $T$ 中所有边的权重之和最小。
- **关键定义**: P-MST (Partial MST): 一个边的子集，如果它是某个完整 MST 的一部分，则称其为 P-MST。
- **Prim 算法**:
  - **思想**: 类似 Dijkstra。从任意顶点 $s$ 开始，维护一个已在 MST 中的顶点集合 $S$。每次从未在 $S$ 中的顶点里，选择一个与 $S$ 中顶点相连且边权最小的顶点 $v$，将其加入 $S$，并将连接 $v$ 和 $S$ 的那条最小权边加入 MST。
  - **正确性 (Cut Property / Prim's Growing Idea)**: 假设当前已构建的树 $T$ 是某个 MST $T^*$ 的一部分 (P-MST)。考虑连接 $T$ 中顶点和 $T$ 外顶点的所有边 (构成一个割 Cut)，选择其中权重最小的边 $(u, v)$ (设 $u \in T, v \notin T$)。如果 $(u, v)$ 不在 $T^*$ 中，则 $T^*$ 中必定存在另一条边 $(x, y)$ 跨越该割 ($x \in T, y \notin T$) 并且在 $T^*$ 中构成了 $v$ 到 $T$ 的路径。用 $(u, v)$ 替换 $T^*$ 中的 $(x, y)$ (或路径上权重不小于 $(u,v)$ 的边)，可以得到一棵权重不大于 $T^*$ 的生成树。由于 $T^*$ 是 MST，新树也必须是 MST，且包含 $(u, v)$。因此，加入 $(u, v)$ 后得到的 $T \cup \{(u, v)\}$ 仍是某个 MST 的一部分 (P-MST)。
  - **实现与复杂度**: 类似 Dijkstra。使用优先队列维护未在 $S$ 中的顶点到 $S$ 的最小边权。
    - 二叉堆: $O(|E| \log |V|)$。
    - 斐波那契堆: $O(|E| + |V| \log |V|)$。
- **Kruskal 算法**:
  - **思想**: 按边的权重从小到大依次考虑所有边。如果一条边连接了两个当前不属于同一连通分量的顶点，则将该边加入 MST。
  - **正确性 (Cycle Property / Kruskal's Growing Idea)**: 考虑权重最小的边 $(u, v)$。如果 $u, v$ 在加入该边前已连通，则加入 $(u, v)$ 会形成环，不应加入。如果 $u, v$ 不连通，假设 $(u, v)$ 不在某个 MST $T^*$ 中，则 $T^*$ 中必定存在一条 $u$ 到 $v$ 的路径，该路径上至少有一条边 $(x, y)$ 的权重不小于 $(u, v)$ (否则 $T^*$ 不是 MST)。用 $(u, v)$ 替换 $(x, y)$ 可得一棵权重不大于 $T^*$ 的生成树，因此 $(u, v)$ 必须可以加入 MST。
  - **实现与复杂度**:
    - 需要对边进行排序: $O(|E| \log |E|) = O(|E| \log |V|)$。
    - 需要高效判断两个顶点是否已连通，并合并连通分量：使用 **并查集 (Union-Find Set)** 数据结构。
    - 并查集操作：`find` (查找代表元) 和 `union` (合并集合)。
    - 优化：按秩合并 (Union by Rank) + 路径压缩 (Path Compression)。
    - 摊销复杂度 (Amortized Analysis): `find` 操作摊销代价接近常数，记为 $O(\alpha(n))$ 或 $O(\log^* n)$ (PPT 中分析得到 $O(\log^* n)$)。`union` 操作 $O(1)$。
    - 总复杂度主要由排序决定: $O(|E| \log |V|)$。
