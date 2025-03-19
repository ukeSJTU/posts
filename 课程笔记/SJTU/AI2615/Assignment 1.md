## Question-1 (15 points)

Prove the following generalization of the master theorem. Given constants $a \geq 1$, $b > 1$, $d \geq 0$, and $w \geq 0$, if

$$
T(n) =
\begin{cases}
1, & \text{for } n < b \\
aT(n/b) + n^d \log^w n, & \text{otherwise}
\end{cases}
$$

we have

$$
T(n) =
\begin{cases}
O(n^d \log^w n), & \text{if } a < b^d \\
O(n^{\log_b a}), & \text{if } a > b^d \\
O(n^d \log^{w+1} n), & \text{if } a = b^d
\end{cases}
$$

## Answer-1

For the recurrence relation:
$$T(n) = aT(n/b) + n^d\log^w n, \text{ for } n \geq b$$

Solving this by iterating the recurrence:

$T(n) = aT(n/b) + n^d\log^w n$ $= a^2T(n/b^2) + an^d(1/b)^d\log^w(n/b) + n^d\log^w n$ $= a^3T(n/b^3) + a^2n^d(1/b^2)^d\log^w(n/b^2) + an^d(1/b)^d\log^w(n/b) + n^d\log^w n$

Continuing this pattern for $k = \log_b n$ iterations (until reaching the base case):

$$T(n) = a^{\log_b n} + \sum_{i=0}^{\log_b n-1} a^i \cdot (n/b^i)^d \cdot \log^w(n/b^i)$$

Note that $a^{\log_b n} = n^{\log_b a}$, and $(n/b^i)^d = n^d/b^{id}$.

$$T(n) = n^{\log_b a} + n^d\sum_{i=0}^{\log_b n-1} \frac{a^i}{b^{id}} \cdot \log^w(n/b^i)$$

For large values of $n$, $\log^w(n/b^i) = O(\log^w n)$ since the logarithm grows very slowly. This gives:

$$T(n) = n^{\log_b a} + n^d\log^w n \sum_{i=0}^{\log_b n-1} \left(\frac{a}{b^d}\right)^i$$

Analyzing this sum for the three cases:

### Case 1: $a < b^d$

When $a < b^d$, the ratio $\frac{a}{b^d} < 1$, so the sum is a convergent geometric series:

$$\sum_{i=0}^{\log_b n-1} \left(\frac{a}{b^d}\right)^i < \sum_{i=0}^{\infty} \left(\frac{a}{b^d}\right)^i = \frac{1}{1-\frac{a}{b^d}} = \frac{b^d}{b^d-a} = O(1)$$

Therefore:
$$T(n) = n^{\log_b a} + O(n^d\log^w n)$$

Since $a < b^d$ implies $\log_b a < d$, $n^{\log_b a} = o(n^d)$, making the second term dominant:
$$T(n) = O(n^d\log^w n)$$

### Case 2: $a > b^d$

When $a > b^d$, the ratio $\frac{a}{b^d} > 1$, so the sum is dominated by its largest term (when $i = \log_b n - 1$):

$$\sum_{i=0}^{\log_b n-1} \left(\frac{a}{b^d}\right)^i = O\left(\left(\frac{a}{b^d}\right)^{\log_b n-1}\right)$$

Calculating:
$$\left(\frac{a}{b^d}\right)^{\log_b n-1} = \left(\frac{a}{b^d}\right)^{\log_b n} \cdot \frac{b^d}{a} = \frac{a^{\log_b n}}{b^{d\log_b n}} \cdot \frac{b^d}{a} = \frac{n^{\log_b a}}{n^d} \cdot \frac{b^d}{a} = O(n^{\log_b a-d})$$

Therefore:
$$T(n) = n^{\log_b a} + O(n^d\log^w n \cdot n^{\log_b a-d}) = n^{\log_b a} + O(n^{\log_b a}\log^w n)$$

Since $a > b^d$ implies $\log_b a > d$, the first term dominates:
$$T(n) = O(n^{\log_b a})$$

### Case 3: $a = b^d$

When $a = b^d$, the ratio $\frac{a}{b^d} = 1$, so the sum equals the number of terms:

$$\sum_{i=0}^{\log_b n-1} \left(\frac{a}{b^d}\right)^i = \sum_{i=0}^{\log_b n-1} 1 = \log_b n = \frac{\log n}{\log b}$$

Therefore:
$$T(n) = n^{\log_b a} + O(n^d\log^w n \cdot \log n) = n^d + O(n^d\log^{w+1} n)$$

Since $a = b^d$ implies $\log_b a = d$, and $\log^{w+1} n$ grows faster than any constant:
$$T(n) = O(n^d\log^{w+1} n)$$

This completes the proof of the generalized master theorem for all three cases.

---

## Question-2 (25 points)

Let us consider the (randomized) quick sort algorithm, where pivots are chosen uniformly at random. How to analyze its expected time complexity.

### (a) (10 points)

Prove its expected time complexity is $O(n^c)$ for some $c < 2$ by using a similar method as quick select in the lecture. (You can choose the constant $c$ you want.)

### (b) (5 points)

Consider the $i$-th smallest element $x_i$ and the $j$-th ($j > i$) smallest element $x_j$. Prove that they will be compared in quick sort if and only if $x_i$ or $x_j$ is the "first" appeared pivot among $i$ to $j$.

### (c) (10 points)

Prove its expected time complexity is $O(n \log n)$.

## Answer-2

### (a)

We prove the time complexity of (randomized) quick sort $E(T(n)) = O(n^{1.5})$ by induction. Assuming that the complexity of merging is $Cn$, we prove $E(T(n)) \leq Bn^{1.5}$, where $C$ is a constant and $B = 100C$.

**Base step:** $n = 1$, $E(T(1)) \leq B$.

**Assumption:** For $k < n$, $E(T(k)) \leq Bk^{1.5}$. Then we are to prove $E(T(n)) \leq Bn^{1.5}$.

**Inductive step:** In each round, with probability $\frac{1}{5}$, the pivot is greater than $\frac{2}{5}$ and less than $\frac{3}{5}$ of the $n$ numbers (good case). In this case, it takes $Cn$ time to process, and both the left ($n_1$ numbers) and right ($n_2$ numbers) sides have at most $\frac{3n}{5}$ numbers, (i.e., we have $n_1 \leq \frac{3n}{5}$ and $n_2 \leq \frac{3n}{5}$). Together with the monotonicity of $Bn^{1.5}$, it indicates:
$$E(T(n)) = E(T(n_1)) + E(T(n_2)) + Cn \leq 2B(\frac{3n}{5})^{1.5} + Cn.$$

And with probability $\frac{4}{5}$, the pivot is less than $\frac{2}{5}$ or greater than $\frac{3}{5}$ of the $n$ numbers (bad case). Assuming that the $n$ numbers are partitioned into $n_3$ and $n_4$ numbers, where $n_3 + n_4 = n$. In this case, it takes $Cn$ time to process. By the convexity of $Bn^{1.5}$, it takes at most $E(T(n_3)) + E(T(n_4)) \leq Bn_3^{1.5} + Bn_4^{1.5} \leq Bn^{1.5}$ time in the following steps. So it means that:

$$E[T(n)] \leq \frac{1}{5}(E(T(n_1) + E(T(n_2)) + Cn) + \frac{4}{5}(E(T(n_3)) + E(T(n_4)) + Cn)$$
$$\leq \frac{1}{5}(2B(\frac{3n}{5})^{1.5} + Cn) + \frac{4}{5}(Bn^{1.5} + Cn)$$
$$= (\frac{2}{5}(\frac{3}{5})^{1.5} + \frac{4}{5})Bn^{1.5} + Cn$$
$$\leq (\frac{2}{5}(\frac{3}{5})^{1.5} + \frac{4}{5})Bn^{1.5} + \frac{1}{100}Bn^{1.5}$$
$$\leq Bn^{1.5}$$

In conclusion, $T(n) = O(n^c)$, where $c = 1.5 < 2$.

### (b)

**Forward direction:**
Suppose $x_i$ and $x_j$ are compared during quicksort. This means one of them must be a pivot when they are compared.

Without loss of generality, assume $x_i$ is chosen as a pivot first. Then $x_i$ will be compared with all other elements in its current subarray, including $x_j$ if $x_j$ is still in the same subarray. For $x_j$ to be in the same subarray as $x_i$ when $x_i$ becomes a pivot, no element from the set $\{x_i, x_{i+1}, ..., x_j\}$ could have been chosen as a pivot earlier (otherwise, $x_i$ and $x_j$ would have been separated into different subarrays). Therefore, $x_i$ must be the first pivot chosen from the set $\{x_i, x_{i+1}, ..., x_j\}$.

Similarly, if $x_j$ is chosen as a pivot first, then $x_j$ must be the first pivot from the set $\{x_i, x_{i+1}, ..., x_j\}$.

**Reverse direction:**
Now suppose either $x_i$ or $x_j$ is the first element chosen as a pivot among $\{x_i, x_{i+1}, ..., x_j\}$.

If $x_i$ is chosen first as a pivot, then at that point, $x_j$ must still be in the same subarray (since no element between $x_i$ and $x_j$ has been chosen as a pivot yet). When $x_i$ is the pivot, it will be compared with all elements in its subarray, including $x_j$. Thus, $x_i$ and $x_j$ will be compared.

Similarly, if $x_j$ is chosen first as a pivot, then $x_i$ must still be in the same subarray, and $x_j$ will be compared with $x_i$ during the partitioning step.

Therefore, $x_i$ and $x_j$ will be compared in quicksort if and only if either $x_i$ or $x_j$ is the first element chosen as a pivot among the elements $\{x_i, x_{i+1}, ..., x_j\}$.

### (c)

The probability of the choice is uniform so that we can have the following expectation equation:

$$T(n) = \sum_{i=1}^{n} \frac{T(i-1) + T(n-i)}{n} + O(n)$$

1. When $n = 1$, it is trivially $O(n \log n)$.

2. Supposing $\forall k \leq n-1$ we have $T(k) = O(k \log k)$, so we can get:

$$T(n) = \sum_{i=1}^{n} \frac{T(i-1) + T(n-i)}{n} + O(n)$$

$$\leq \frac{2}{n} \cdot \sum_{i=0}^{n-1} T(i) + O(n)$$

$$= \frac{2}{n} \cdot \sum_{i=0}^{n-1} O(i \log i) + O(n)$$

$$= \frac{2}{n} \cdot \sum_{i=0}^{n-1} O(i \log n) + O(n)$$

$$= \frac{2}{n} \cdot O\left(\frac{n(n-1)}{2} \log n\right) + O(n)$$

$$= O(n \log n)$$

---

## Question-3 (20 points)

We are given an $n$-vertex **tournament graph** $\vec{G} = (V, A)$, which is a directed version of a complete undirected graph $G = (V, E)$. For each undirected edge $e = (u, v) \in E$, we have a corresponding directed arc $(u \to v$ or $v \to u)$ in $A$. We aim to design an efficient algorithm to find a directed Hamiltonian path in $\vec{G}$, which is a path including all vertices in $V$, such as:

$$
u_1 \to u_2 \to u_3 \to \dots \to u_n
$$

### (a) (10 points)

Assume we have a path $P$ of length $k$ and another vertex $u$ not included in $P$.  
Prove that we can always find a feasible location in $P$ to insert $u$.

(_Example: When $P = v_1 \to v_2 \to v_3$, we can insert $u$ into $P$ and change $P$ to $v_1 \to u \to v_2 \to v_3$ if $v_1 \to u$ and $u \to v_2$ are both in $A$._)

### (b) (10 points)

Use **divide and conquer** to find an $O(n \log n)$ algorithm to compute a directed Hamiltonian path, analyze its running time and prove the correctness.

## Answer-3

### (a)

Let the vertex sequence of path P be $v_0 \to v_1 \to \cdots \to v_k$.

Consider the relationships between vertex u and each vertex in P. In a tournament graph, for any two vertices, there must be exactly one directed edge between them. Therefore, for each vertex $v_i$ in P, either $v_i \to u$ exists or $u \to v_i$ exists, but not both.

Define the sets $S_{in} = \{v_i \in P | v_i \to u\}$ (vertices pointing to u) and $S_{out} = \{v_i \in P | u \to v_i\}$ (vertices u points to).

By the properties of a tournament graph, $|S_{in}| + |S_{out}| = k+1$ and $S_{in} \cap S_{out} = \emptyset$.

Let $i$ be the largest index such that $v_i \to u$ exists.

1. If no such $i$ exists (i.e., u points to all vertices in P), then u can be inserted at the beginning of the path.
2. If $i = k$ (i.e., the last vertex points to u), then u can be added to the end of the path.
3. If $0 \leq i < k$, then we have $v_i \to u$, and by the maximality of $i$, we must have $u \to v_{i+1}$. This means u can be inserted between $v_i$ and $v_{i+1}$.

Therefore, we can always find a position to insert u into path P.

### (b)

```
function FindHamiltonianPath(G = (V, A)):
    // Base case
    if |V| = 1:
        return the single vertex as a path

    // Divide
    Split V into two roughly equal subsets V₁ and V₂

    // Conquer
    P₁ = FindHamiltonianPath(G[V₁])  // Subgraph induced by V₁
    P₂ = FindHamiltonianPath(G[V₂])  // Subgraph induced by V₂

    // Combine
    return MergePaths(P₁, P₂, A)
```

```
function MergePaths(P₁, P₂, A):
    Let a₁ and aₘ be the first and last vertices of P₁
    Let b₁ and bₖ be the first and last vertices of P₂

    // Check six possible connection configurations
    if aₘ → b₁ exists:
        return P₁ followed by P₂
    if bₖ → a₁ exists:
        return P₂ followed by P₁
    if a₁ → b₁ exists:
        Reverse P₁
        return reversed P₁ followed by P₂
    if aₘ → bₖ exists:
        Reverse P₂
        return P₁ followed by reversed P₂
    if b₁ → a₁ exists:
        Reverse P₁
        return P₂ followed by reversed P₁
    if bₖ → aₘ exists:
        Reverse both P₁ and P₂
        return reversed P₂ followed by reversed P₁
```

**Time Complexity Analysis**

- Division step: $O(n)$
- Recursive solutions: $T(n/2) + T(n/2) = 2T(n/2)$
- Merging step: Checking edge existence is $O(1)$, but reversing paths takes $O(n)$ time

The recurrence relation is: $T(n) = 2T(n/2) + O(n)$

By the Master Theorem, the solution to this recurrence is $T(n) = O(n \log n)$.

**Correctness Proof**

1. **Base case**: For a single vertex, the Hamiltonian path is the vertex itself.
2. **Inductive step**: Assume we can find Hamiltonian paths for any tournament graph with fewer than n vertices.
3. **Merging**: In the merging step, we check all possible ways to connect the two paths. In a tournament graph, for any two vertices, there must be a directed edge between them, so at least one of the six configurations will be valid.

The merged path includes all vertices and maintains the directed property, so it is a valid Hamiltonian path.

Thus, we have a divide-and-conquer algorithm with $O(n \log n)$ time complexity to find a directed Hamiltonian path in a tournament graph.

---

## Question-4 (30 points)

Given an $n \times m$ **2-dimensional integer array**  
$A[0, \dots, n-1; 0, \dots, m-1]$,  
where $A[i, j]$ denotes the cell at row $i$ and column $j$, a **local minimum** is a cell $A[i, j]$ such that

- $A[i, j]$ is smaller than each of its four adjacent cells:  
  $A[i-1, j]$, $A[i+1, j]$, $A[i, j-1]$, and $A[i, j+1]$.
- If $A[i, j]$ is on the **boundary**, it only has three adjacent cells.
- If $A[i, j]$ is at the **corner**, it only has two adjacent cells.
- Assume **all values are distinct**.
- Your goal is to find **one** local minimum (not necessarily all of them).

### (a) (10 points)

Suppose $m = 1$ so $A$ is a **1D array**. Design a **divide-and-conquer** algorithm for this problem. Write a recurrence relation and analyze its running time.

### (b) (10 points)

Suppose $m = n$. Design a divide-and-conquer-based algorithm for the problem above. Write a recurrence relation of the algorithm, and analyze its running time.

### (c) (10 points)

Generalize your algorithm such that it works for general $m$ and $n$. The running time of your algorithm should _smoothly_ interpolate between the running times for the first two parts.

## Answer-4

### (a)

When m = 1, we have a 1D array $A[0...n-1]$. I'll design a divide-and-conquer algorithm to find a local minimum:

**Algorithm:**

1. Find the middle element $A[mid]$ where $mid = ⌊(low + high)/2⌋$
2. Check if $A[mid]$ is a local minimum:
   - If $0 < mid < n-1$: Check if $A[mid] < A[mid-1]$ and $A[mid] < A[mid+1]$
   - If $mid = 0$: Check if $A[mid] < A[mid+1]$
   - If $mid = n-1$: Check if $A[mid] < A[mid-1]$
3. If $A[mid]$ is a local minimum, return it
4. Otherwise:
   - If $A[mid-1] < A[mid]$ (and $mid > 0$), recurse on the left half $[low...mid-1]$
   - Otherwise, recurse on the right half $[mid+1...high]$

**Recurrence Relation:**

```
T(n) = T(n/2) + O(1)
```

**Time Complexity Analysis:**
Using the Master Theorem, we have $a = 1, b = 2$, and $f(n) = O(1)$.
Since $f(n) = O(n^log_b(a-ε))$ for any $ε > 0$, the solution is $T(n) = O(log n)$.

**Correctness:**
The key insight is that if $A[mid]$ is not a local minimum, then at least one of its neighbors is smaller, and we can guarantee that a local minimum exists in that direction. This is because values are distinct and if we follow a descending path, we must eventually reach a local minimum (at least at the boundary).

### (b)

For an $n×n$ matrix, I'll design a divide-and-conquer algorithm:

**Algorithm:**

1. Find the middle column $j = ⌊n/2⌋$
2. Find the minimum element $A[i,j]$ in column $j$
3. Check if $A[i,j]$ is a local minimum by comparing with its neighbors
4. If it is, return it
5. Otherwise:
   - If $A[i,j-1] < A[i,j]$, recurse on the left half (columns $0$ to $j-1$)
   - Otherwise (which means $A[i,j+1] < A[i,j]$ since $A[i,j]$ isn't a local minimum), recurse on the right half (columns $j+1$ to $n-1$)

**Recurrence Relation:**
$$T(n,n) = T(n,n/2) + O(n)$$

**Time Complexity Analysis:**
Let's expand the recurrence:

- After 1 division: $T(n,n) = T(n,n/2) + O(n)$
- After 2 divisions: $T(n,n) = T(n,n/4) + O(n) + O(n) = T(n,n/4) + 2·O(n)$
- After $\log(n)$ divisions: $T(n,n) = T(n,1) + \log(n)·O(n) = O(\log n) + O(n \log n) = O(n \log n)$

The time complexity is $O(n \log n)$.

**Correctness:**
When we find the minimum element in the middle column, if it's not a local minimum, then one of its horizontal neighbors must be smaller. By recursing in that direction, we guarantee finding a local minimum because following a path of decreasing values will eventually lead to a local minimum.

### (c)

For the general $n×m$ case, I'll divide along the shorter dimension to achieve the most efficient algorithm:

**Algorithm:**

1. If $\min(n,m) = 1$, use the 1-D algorithm from part (a)
2. Otherwise:
   - If $n ≤ m$: Find the middle row $i = ⌊n/2⌋$, find the minimum element $A[i,j]$ in that row, check if it's a local minimum. If not, recurse on the half with a smaller adjacent element.
   - If $n > m$: Find the middle column $j = ⌊m/2⌋$, find the minimum element $A[i,j]$ in that column, check if it's a local minimum. If not, recurse on the half with a smaller adjacent element.

**Recurrence Relation:**

$$ T(n,m) = \begin{cases} T(n/2,m) + O(m) & \text{if } n ≤ m \text{ and } n > 1 \\ T(n,m/2) + O(n) & \text{if } n > m \text{ and } m > 1 \end{cases} $$
**Time Complexity Analysis:**
This recurrence solves to:
$T(n,m) = O(\max(n,m) · \log(\min(n,m)))$

This smoothly interpolates between our previous results:

- When $m = 1$: $T(n,1) = O(\log n)$
- When $n = m$: $T(n,n) = O(n \log n)$
- When $n > m > 1$: $T(n,m) = O(n \log m)$
- When $m > n > 1$: $T(n,m) = O(m \log n)$

---

## Question-5

How long does it take you to finish the assignment (including thinking and discussion)?Give a score (1,2,3,4,5) to the difficulty. Do you have any collaborators? Please write down their names here.

## Answer-5

It took me 5 hours to complete this assignment and I would rate the difficulty a score of 4.

---
