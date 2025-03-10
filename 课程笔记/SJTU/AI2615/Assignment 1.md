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

---

## Question-2 (25 points)

Consider the (randomized) quick sort algorithm, where pivots are chosen uniformly at random. Analyze its expected time complexity.

### (a) (10 points)

Prove its expected time complexity is $O(n^c)$ for some $c < 2$ using a similar method as quick select in the lecture. (You can choose the constant $c$ you want.)

### (b) (5 points)

Consider the $i$-th smallest element $x_i$ and the $j$-th ($j > i$) smallest element $x_j$. Prove that they will be compared in quick sort if and only if $x_i$ or $x_j$ is the "first" appeared pivot among $i$ to $j$.

### (c) (10 points)

Prove its expected time complexity is $O(n \log n)$.

## Answer-2

### (a)

### (b)

### (c)

---

## Question-3 (20 points)

We are given an $n$-vertex **tournament graph** $\vec{G} = (V, A)$, which is a directed version of a complete undirected graph $G = (V, E)$.  
For each undirected edge $e = (u, v) \in E$, we have a corresponding directed arc $(u \to v$ or $v \to u)$ in $A$.

Design an efficient algorithm to find a **directed Hamiltonian path** in $\vec{G}$, which is a path including all vertices in $V$, such as:

$$
u_1 \to u_2 \to u_3 \to \dots \to u_n
$$

### (a) (10 points)

Assume we have a path $P$ of length $k$ and another vertex $u$ not included in $P$.  
Prove that we can always find a feasible location in $P$ to insert $u$.

(_Example: When $P = v_1 \to v_2 \to v_3$, we can insert $u$ into $P$ and change $P$ to $v_1 \to u \to v_2 \to v_3$ if $v_1 \to u$ and $u \to v_2$ are both in $A$._)

### (b) (10 points)

Use **divide and conquer** to find an $O(n \log n)$ algorithm to compute a directed Hamiltonian path.  
Analyze its running time and prove its correctness.

## Answer-3

### (a)

### (b)

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

Suppose $m = 1$ so $A$ is a **1D array**.  
Design a **divide-and-conquer** algorithm for this problem.  
Write a recurrence relation and analyze its running time.

### (b) (10 points)

Suppose $m = n$, making $A$ a **square matrix**.  
Design a **divide-and-conquer** algorithm for this problem.  
Write a recurrence relation and analyze its running time.

### (c) (10 points)

Generalize your algorithm for arbitrary $m$ and $n$.  
Ensure the running time of your algorithm smoothly interpolates between the cases in parts (a) and (b).

## Answer-4

---

## Question-5

### Survey

- How long did it take you to complete this assignment (including thinking and discussion)?
- Rate the difficulty from **1 to 5**.
- Did you have any collaborators?  
  (_If so, please list their names._)

## Answer-5

---
