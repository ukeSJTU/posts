## Question-1 (25 points)

We have $n$ homework assignments with weights $w_1, \ldots, w_n \in \mathbb{Z}^+$. Each homework assignment $i$ requires $w_i$ units of time to finish, and it will give you $w_i$ points as reward. Suppose the semester starts at time $0$ and ends at time $T$ (for some $T \in \mathbb{Z}^+$). Suppose all the homework assignments are released at the beginning of the semester. Each homework assignment $i$ needs to be completed before the end of the semester in order to receive the $w_i$ points reward. Ideally, you would like to complete all the homework assignments in the time interval $[0, T]$, but this is impossible if $\sum_{i=1}^n w_i > T$. Therefore, your objective is to choose a subset of homework assignments that maximizes the reward.

Consider the following greedy algorithm.

1. initialize $S \leftarrow \emptyset$;
2. let $\Gamma(S)$ be the set of homework assignments $i$ satisfying 1) $i \notin S$ and 2) the weight of $S \cup \{i\}$ does not exceed $T$; find the homework assignment in $\Gamma(S)$ with the largest weight and include it to $S$;
3. keep doing the second step until $\Gamma(S) = \emptyset$;
4. return $S$.

Suppose each $w_i$ is an integer power of 2. That is, for each i, there exists $k_i \in \mathbb{Z}_{\geq 0}$ such that $w_i = 2^{k_i}$. Prove that the greedy algorithm correctly outputs S with the maximum reward.

## Answer-1

Let $S_G = {g_1, g_2, \dots, g_m}$ be the solution obtained by the greedy algorithm, where the indices are arranged in the order the assignments were selected. Let $S^* = {s_1, s_2, ..., s_k}$ be any optimal solution. Assume weights in each set are arranged in non-increasing order: $w_{g_1} \geq w_{g_2} \geq ... \geq w_{g_m}$ and $w_{s_1} \geq w_{s_2} \geq ... \geq w_{s_k}$.

The question claims that the greedy solution $S_G$ maximizes the total reward among all feasible solutions. In other words, the greedy solution $S_G$ has the same total value as any optimal solution $S^*$.

Let's prove by contradiction. Suppose that $S_G$ is not optimal, i.e., $\sum_{i \in S^*} w_i > \sum_{i \in S_G} w_i$. Let $j$ be the smallest index such that $g_j \neq s_j$. Since the greedy algorithm always selects the largest available weight, we must have $w_{g_j} \geq w_{s_j}$.

Consider the set $S^j = {s_1, s_2, ..., s_{j-1}, g_j, s_{j+1}, ..., s_k}$. Since $w_{g_j} \geq w_{s_j}$, we have $\sum_{i \in S^j} w_i \geq \sum{i \in S^} w_i$. If $S^_j$ is feasible, this contradicts the optimality of $S^*$.

But could $S^*_j$ be infeasible? Let's examine this case.

If $S^*j$ is infeasible, then $\sum{i=1}^{j-1} w_{s_i} + w_{g_j} + \sum_{i=j+1}^{k} w_{s_i} > T$.

However, the greedy algorithm selected $g_j$ after selecting ${g_1, g_2, ..., g_{j-1}}$, which means:
$\sum_{i=1}^{j-1} w_{g_i} + w_{g_j} \leq T$

Since ${g_1, g_2, ..., g_{j-1}} = {s_1, s_2, ..., s_{j-1}}$ (by our choice of $j$), we have:
$\sum_{i=1}^{j-1} w_{s_i} + w_{g_j} \leq T$

Therefore, if $S^*j$ is infeasible, it must be that $\sum{i=j+1}^{k} w_{s_i} > 0$.

## Question-2 (5 bonus points)

Consider the same problem in Question 1. In this question, we no longer assume that each $w_i$ is an integer power of 2. Can you prove that the greedy algorithm can be approximately optimal? (Recall the makespan minimization problem in the lecture.)

## Answer-2

## Question-3 (25 points)

Consider only using path compression in the union-find set without union by rank. I.e., we union two sets arbitrarily. Can we show that the amortized running time is O(log n)? In particular, please prove the total running time of any m find operations and n − 1 union operations is at most O((n + m) log n).

## Answer-3

## Question-4 (50 points)

In the class, we learned Kruskal's algorithm to find a minimum spanning tree (MST). The strategy is simple and intuitive: pick the best legal edge in each step. The philosophy here is that local optimal choices will yield a global optimal. In this problem, we will try to understand to what extent this simple strategy works. To this end, we study a more abstract algorithmic problem of which MST is a special case.

Consider a pair $M = (U, I)$ where U is a finite set and $I \subseteq \{0, 1\}^U$ is a collection of subsets of U. We say M is a _matroid_ if it satisfies

- **(hereditary property)** $I$ is nonempty and for every $A \in I$ and $B \subseteq A$, it holds that $B \in I$.
- **(exchange property)** For any $A, B \in I$ with $|A| < |B|$, there exists some $x \in B \setminus A$ such that $A \cup \{x\} \in I$.

Each set $A \in I$ is called an independent set.

### (a) (10 points)

Let $M = (U, I)$ be a matroid. Prove that maximal independent sets are of the same size. (A set $A \in I$ is called maximal if there is no $B \in I$ such that $A \subsetneq B$.)

### (b) (10 points)

Let $G = (V, E)$ be a simple undirected graph. Let $M = (E, S)$ where $S = \{F \subseteq E | F \text{ does not contain a cycle}\}$. Prove that M is a matroid. What are the maximal sets of this matroid?

### (c) (10 points)

Let $M = (U, I)$ be a matroid. We associate each element $x \in U$ with a nonnegative weight w(x). For every set of elements $S \subseteq U$, the weight of S is defined as $w(S) = \sum_{x\in S} w(x)$. Now we want to find a maximal independent set with maximum weight. Consider the following greedy algorithm.

Algorithm 1 Find a maximal independent set with maximum weight
Input: A matroid $M = (U, I)$ and a weight function $w : U \rightarrow \mathbb{R}_{\geq 0}$.
Output: A maximal independent set $S \in I$ with maximum w(S).
1: $S \leftarrow \emptyset$
2: Sort U into decreasing order by weight w
3: for $x \in U$ in decreasing order of w:
4: if $S \cup \{x\} \in I$:
5: $S \leftarrow S \cup \{x\}$
6: endif
7: endfor
8: return S

Now we consider the first element $x$ the algorithm added to $S$. Prove that there must be a maximal independent set $S' \in I$ with maximum weight containing $x$.

### (d) (10 points)

Prove that the greedy algorithm returns a maximal independent set with maximum weight. (Hint: Can you see that Algorithm 1 is just a generalization of Kruskal's algorithm?)

### (e) (10 points)

Let $U \subseteq \mathbb{R}^n$ be a finite collection of $n$-dimensional vectors. Assume $m = |U|$ and we associate each vector $x \in U$ with a positive weight $w(x)$. For any set of vectors $S \subseteq U$, the weight of $S$ is defined as $w(S) = \sum_{x\in S} w(x)$. Design an efficient algorithm to find a set of vectors $S \subseteq U$ with maximum weight and all vectors in $S$ are linearly independent.

## Answer-4

### (a)

### (b)

### (c)

### (d)

### (e)

## Question-5

How long does it take you to finish the assignment (including thinking and discussing)? Give a score (1,2,3,4,5) to the difficulty. Do you have any collaborators? Write down their names here.

## Answer-5
