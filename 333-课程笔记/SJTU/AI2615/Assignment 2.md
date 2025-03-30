## Question 1 (20 points)

Please prove the Super Plan of the Strongly Connected Component Algorithm presented in the lecture is correct.

### Answer 1

To prove the Super Plan of the Strongly Connected Component Algorithm is correct, I need to show why, after removing a head SCC from $G^R$, we can simply select the vertex with the highest original finish time in the remaining graph without rerunning DFS.

Let me establish what we need to prove:

**Main Claim:** If $SCC_1$ can reach $SCC_2$ in the original graph $G$, then the maximum finish time of vertices in $SCC_1$ is greater than or equal to the maximum finish time of vertices in $SCC_2$.

$$\text{If } SCC_1 \text{ can reach } SCC_2 \text{ in } G, \text{ then } \max_{u \in SCC_1} finish\_time(u) \geq \max_{v \in SCC_2} finish\_time(v)$$

**Proof:**
During the initial DFS on graph $G$, there are two possible scenarios:

**Case 1:** During DFS, we explore $SCC_2$ from $SCC_1$.
Let $v$ be the first vertex visited in $SCC_1$. When we start exploring from $v$, we will reach vertices in $SCC_2$ (since $SCC_1$ can reach $SCC_2$). By DFS properties, $v$ will only finish after all reachable vertices have finished, including all vertices in $SCC_2$. Therefore:
$$finish\_time(v) > finish\_time(u) \text{ for all } u \in SCC_2$$

**Case 2:** During DFS, we never explore $SCC_2$ from $SCC_1$.
This can only happen if all vertices in $SCC_2$ were completely processed before any vertex in $SCC_1$ was visited. Therefore, for the first vertex $v$ visited in $SCC_1$:
$$start\_time(v) > finish\_time(u) \text{ for all } u \in SCC_2$$

Since $finish\_time(v) > start\_time(v)$, we have:
$$finish\_time(v) > finish\_time(u) \text{ for all } u \in SCC_2$$

Therefore, in both cases, the lemma holds: if $SCC_1$ can reach $SCC_2$ in $G$, then $\max_{u \in SCC_1} finish\_time(u) \geq \max_{v \in SCC_2} finish\_time(v)$.

This proves that in the reversed graph $G^R$, after removing a head SCC (which corresponds to a sink SCC in $G$), the vertex with the highest finish time in the remaining graph will always be in the next head SCC of $G^R$, validating the correctness of the Super Plan.

## Question 2 (20 points)

Given a directed graph $G = (V, E)$ on which each edge $(u, v) \in E$ has a weight $p(u, v)$ in range $[0, 1]$, that represents the reliability. We can view each edge as a channel, and $p(u, v)$ is the probability that the channel from $u$ to $v$ will not fail. We assume all these probabilities are independent. Give an efficient algorithm to find the most reliable path from two given vertices $s$ and $t$. (A path fails if any edge on the path fails. The most reliable path means the path with the lowest failure probability.)

### Answer 2

To find the most reliable path from vertex s to vertex t in a directed graph where each edge has a reliability probability, we need to maximize the overall reliability of the path.

**Algorithm:**

1. Transform the reliability problem into a shortest path problem:

   - For each edge (u,v) with reliability $p(u,v)$, assign weight $w(u,v) = -\ln(p(u,v))$
   - Create a new graph $G' = (V, E')$ using these weights

2. Run Dijkstra's algorithm on $G'$ to find the shortest path from s to t

3. Return this path as the most reliable path

**Correctness:**
For a path consisting of edges $e_1, e_2, ..., e_k$, the total reliability is:
$$\prod_{i=1}^{k} p(e_i)$$

To maximize this product, we can take the natural logarithm (which is monotonically increasing):
$$\max \sum_{i=1}^{k} \ln(p(e_i))$$

Since $p(e) \in [0,1]$, $\ln(p(e)) \leq 0$, we can equivalently minimize:
$$\min \sum_{i=1}^{k} -\ln(p(e_i))$$

This is precisely a shortest path problem with weights $w(u,v) = -\ln(p(u,v))$.

**Time complexity:**

- Graph transformation: $O(|E|)$
- Dijkstra's algorithm using Fibonacci Heap: $O(|E| + |V|log|V|)$
- Overall time complexity: $O(|E| + |V|log|V|)$

## Question 3 (30 points)

Let $G = (V, E)$ be an undirected connected graph. Let $T$ be a depth-first search tree of $G$. Suppose that we orient the edges of $G$ as follows: For each tree edge, the direction is from the parent to the child; for every non-tree (back) edge, the direction is from the descendant to the ancestor. Let $G'$ denote the resulting directed graph.

(a) (5 points) Give an example to show that $G'$ is not strongly connected.

(b) (5 points) Prove that if $G'$ is strongly connected, then $G$ satisfies the property that removing any single edge from $G$ will still give a connected graph.

(c) (5 points) Prove that if $G$ satisfies the property that removing any single edge from $G$ will still give a connected graph, then $G'$ must be strongly connected

(d) (15 points) Give an efficient algorithm to find all edges in a given undirected graph such that removing any one of them will make the graph no longer connected.

### Answer 3

(a) Let's consider a simple example of a graph $G$ with two vertices $a$ and $b$ connected by a single edge. When we perform DFS on this graph, the tree edge will be oriented from one vertex to the other, say $a \rightarrow b$. Since there are no back edges, the resulting directed graph $G'$ only has this single directed edge. This is clearly not strongly connected because there is no path from $b$ back to $a$.

(b) We will prove this by contradiction. Suppose $G'$ is strongly connected, but there exists an edge $e \in G$ such that removing $e$ from $G$ makes the graph disconnected.

When $e$ is removed, $G$ is split into two disconnected components, let's call them $G_1$ and $G_2$. This means $e$ is the only edge connecting vertices in $G_1$ to vertices in $G_2$.

In the directed graph $G'$, the edge $e$ can only have one direction, either from $G_1$ to $G_2$ or from $G_2$ to $G_1$. In either case, after the orientation, there would be no directed path from one component back to the other:

- If $e$ is directed from $G_1$ to $G_2$, then no vertex in $G_2$ can reach any vertex in $G_1$.
- If $e$ is directed from $G_2$ to $G_1$, then no vertex in $G_1$ can reach any vertex in $G_2$.

This contradicts our assumption that $G'$ is strongly connected. Therefore, if $G'$ is strongly connected, removing any single edge from $G$ must still result in a connected graph.

(c) We'll prove that if removing any single edge from $G$ keeps the graph connected, then $G'$ must be strongly connected.

First, we show that each node is strongly connected with its parent in the DFS tree:

- Consider any tree edge $(s,t)$ where $s$ is the parent of $t$
- By our assumption, removing $(s,t)$ keeps $G$ connected
- This means there must exist some other path between the subtree rooted at $t$ and the rest of the graph
- This other path must involve a back edge from some descendant $v$ of $t$ to some ancestor $u$ of $s$
- In $G'$, this gives us a directed path from $t$ to $s$: $t \rightarrow \ldots \rightarrow v \rightarrow u \rightarrow \ldots \rightarrow s$
- The tree edges already provide a path from $s$ to $t$

Since each node is strongly connected with its parent, and the parent is strongly connected with its parent, every node is strongly connected with the root by transitivity. Therefore, any two nodes $x$ and $y$ are strongly connected because there's a path from $x$ to the root and from the root to $y$.

Thus, $G'$ is strongly connected.

(d) An efficient algorithm to find all bridge edges (edges whose removal disconnects the graph):

```plaintext
Algorithm FindBridges(G):
    1. Perform DFS on G to:
       - Build the DFS tree
       - Compute discovery time (d[v]) and low value (low[v]) for each vertex v
       - low[v] is the earliest discovery time reachable from v using tree edges and at most one back edge

    2. For each tree edge (u,v) where u is the parent of v:
       - If low[v] > d[u], then (u,v) is a bridge

    3. Return all bridges found
```

**Correctness:**

An edge $(u,v)$ is a bridge if and only if there is no back edge from the subtree rooted at $v$ that reaches an ancestor of $u$. The low value low[v] represents the earliest discovery time reachable from the subtree rooted at $v$. If low[v] > d[u], it means the subtree rooted at $v$ cannot reach any ancestor of $u$ through back edges, making $(u,v)$ a bridge.

**Time Complexity:**

$O(|V| + |E|)$ for a single DFS traversal of the graph.

This algorithm efficiently identifies all edges whose removal would disconnect the graph.

## Question 4 (30 points)

Given a directed graph $G(V, E)$ where each vertex can be viewed as a port. Consider that you are a salesman, and you plan to travel the graph. Whenever you reach a port $v$, it earns you a profit of $p_v$ dollars, and it costs you $c_{uv}$ if you travel from $u$ to $v$. For any directed cycle in the graph, we can define a profit-to-cost ratio to be $r(C) = \frac{\sum_{(u,v)\in C} p_v}{\sum_{(u,v)\in C} c_{uv}}$.

As a salesman, you want to design an algorithm to find the best cycle to travel with the largest profit-to-cost ratio. Let $r^*$ be the maximum profit-to-cost ratio in the graph. Given a desired accuracy $\epsilon > 0$, design an efficient algorithm to output a good-enough cycle, where $r(C) \geq r^* - \epsilon$. Justify the correctness and analyze the running time in terms of $|V|$, $|E|$, $\epsilon$, and $R = \max_{(u,v)\in E}(p_v/c_{uv})$.

### Answer 4

In this problem, we need to find a cycle in a directed graph that maximizes the profit-to-cost ratio, defined as:

$$r(C) = \frac{\sum_{(u,v)\in C} p_v}{\sum_{(u,v)\in C} c_{uv}}$$

Instead of finding the exact optimal cycle with ratio $r^*$, we need to find a cycle with ratio at least $r^* - \epsilon$ for a given $\epsilon > 0$.

## Key Insight

For any fixed ratio $r$, we can determine whether there exists a cycle with ratio greater than $r$ by checking for a cycle with positive weight in a modified graph where each edge $(u,v)$ is assigned weight $w_{uv} = p_v - r \cdot c_{uv}$.

To see why this works, consider a cycle $C$. It has ratio greater than $r$ if:

$$\frac{\sum_{(u,v)\in C} p_v}{\sum_{(u,v)\in C} c_{uv}} > r$$

Rearranging:

$$\sum_{(u,v)\in C} p_v > r \cdot \sum_{(u,v)\in C} c_{uv}$$

$$\sum_{(u,v)\in C} (p_v - r \cdot c_{uv}) > 0$$

So the cycle has a positive total weight in the modified graph.

We'll use binary search to find the maximum ratio $r$ such that there exists a cycle with ratio greater than $r$:

```plaintext
FindBestProfitCostCycle(G, ε):
    low = 0
    high = R  // R = max_{(u,v)∈E}(p_v/c_{uv})
    best_cycle = null

    while high - low > ε:
        mid = (low + high) / 2

        // Assign weights w_{uv} = p_v - mid·c_{uv}
        for each edge (u,v) in E:
            w[u,v] = p_v - mid·c_{uv}

        // Check for a positive cycle using Bellman-Ford (with negated weights)
        cycle = FindPositiveCycle(G, w)

        if cycle exists:
            low = mid
            best_cycle = cycle
        else:
            high = mid

    return best_cycle
```

The `FindPositiveCycle` function can be implemented using the Bellman-Ford algorithm to detect negative cycles with negated weights:

```plaintext
FindPositiveCycle(G, w):
    // Negate weights
    for each edge (u,v) in E:
        w'[u,v] = -w[u,v]

    // Run Bellman-Ford
    for each vertex v in V:
        d[v] = 0

    pred = {} // Predecessor map

    // |V|-1 relaxations
    for i = 1 to |V|-1:
        for each edge (u,v) in E:
            if d[u] + w'[u,v] < d[v]:
                d[v] = d[u] + w'[u,v]
                pred[v] = u

    // Check for negative cycle
    for each edge (u,v) in E:
        if d[u] + w'[u,v] < d[v]:
            // Negative cycle exists, extract it
            return ExtractCycle(u, v, pred)

    return null  // No cycle found
```

**Correctness：**

The binary search maintains the invariant that:

- There's no cycle with ratio greater than high
- There's a cycle with ratio at least low

When the binary search terminates, $high - low ≤ \epsilon$, and we've found a cycle with ratio at least low. Since $high ≤ r^*$ (the optimal ratio), we have $low ≥ r^* - \epsilon$, which means our cycle has ratio at least $r^* - \epsilon$.

**Time Complexity：**

- Binary search takes $O(\log(\frac{R}{\epsilon}))$ iterations.
- Each iteration involves running Bellman-Ford, which takes $O(|V| \cdot |E|)$ time.
- Therefore, the overall time complexity is $O(|V| \cdot |E| \cdot \log(\frac{R}{\epsilon}))$.

## Question 5

How long does it take you to finish the assignment (including thinking and discussing)? Give a score (1,2,3,4,5) to the difficulty. Do you have any collaborators? Write down their names here.

### Answer 5

It took me at least 10 hours to finish the assignment, including:

- 2h to review the lecture notes and understand the concepts
- 6h to come up with solutions
- 2h to write this markdown file

I would rate the difficulty of this assignment as 5 out of 5.
