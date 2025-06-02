## Question-1 (25 points)

**Common System of Distinct Representatives** Given a ground set $U = \{ 1 , \ldots , n \}$ and a collection of $k$ subsets $\mathcal { A } = \{ A _ { 1 } , \ldots , A _ { k } \}$ , a system of distinct representatives of $\mathcal { A }$ is a "representative" collection $T$ of distinct elements from the sets in $\mathcal { A }$ . Specifically, we have $| T | = k$ , and the $k$ distinct elements in $T$ can be ordered as $u _ { 1 } , \ldots , u _ { k }$ such that $u _ { i } \in A _ { i }$ for each $i = 1 , \ldots , k$ . For example, $\{ A _ { 1 } = \{ 2 , 8 \} , A _ { 2 } = \{ 8 \} , A _ { 3 } = \{ 4 , 5 \} , A _ { 4 } = \{ 2 , 4 , 8 \} \}$ has a system of distinct representatives $\{ 2 , 4 , 5 , 8 \}$ where $2 \in A _ { 1 } , 4 \in A _ { 4 } , 5 \in A _ { 3 } , 8 \in A _ { 2 }$ , while $\{ A _ { 1 } = \{ 2 , 8 \} , A _ { 2 } = \{ 8 \} , A _ { 3 } = \{ 4 , 8 \} , A _ { 4 } = \{ 2 , 4 , 8 \} \}$ does not have a system of distinct representatives.

### (a) (10 points)

Design a polynomial time algorithm to decide if $\mathcal { A }$ has a system of distinct representatives.

### (b) (15 points)

Given a ground set $U = \{ 1 , \ldots , n \}$ and two collections of $k$ subsets $\mathcal { A } = \{ A _ { 1 } , \ldots , A _ { k } \}$ and $\mathcal { B } = \{ B _ { 1 } , \ldots , B _ { k } \}$ , a common system of distinct representatives is a collection $T$ of $k$ elements that is a system of distinct representatives of both $\mathcal { A }$ and $\mathcal { B }$ . Design a polynomial-time algorithm to decide if $\mathcal { A }$ and $\mathcal { B }$ have a common system of distinct representatives.

For each part, prove the correctness of your algorithm and analyze its time complexity.

## Answer-1

### (a) Polynomial algorithm for **one** collection

#### Idea

View every subset as a left–hand vertex and every ground-set element as a right-hand vertex of a bipartite graph

$$G_A=(\;L=\{A_1,\dots ,A_k\},\;R=U,\;E=\{(A_i,u)\mid u\in A_i\}\;).$$

A system of distinct representatives (SDR) is exactly a **perfect matching** that saturates the $k$ left vertices.  
By Hall's Theorem such a matching exists iff for every left vertex subset  
$X\subseteq L,\;|\;N_G(X)|\ge |X|$.

Hence the problem is the classical **bipartite perfect-matching** problem.

#### Algorithm

```
Build the bipartite graph G_A.
Run Hopcroft–Karp (or any poly-time maximum-matching algo).
If the matching size = k
	"YES, SDR exists".
Else
	"NO".
```

#### Correctness proof

\*If the algorithm outputs **YES\***: it has found a size-$k$ matching; naming the matched element of $A_i$ by $u_i$ gives a set $T=\{u_1,\dots ,u_k\}$ that is an SDR by definition.

\*If the algorithm outputs **NO\***: the maximum matching has size $<k$, so by Kőnig–Egérváry theorem Hall's condition fails, and no SDR exists. Thus the algorithm's answer is correct.

#### Running time

Hopcroft–Karp runs in

$$O\!\Bigl(\sqrt{|L|}\,|E|\Bigr)=O\!\left(\sqrt{k}\sum_{i=1}^{k}\!|A_i|\right)\le O\!\bigl(\sqrt{k}\,kn\bigr)$$

which is polynomial in $k$ and $n$.

---

### (b) Polynomial algorithm for **two** collections

We now have two families

$$
\mathcal A=\{A_1,\dots ,A_k\},\qquad
\mathcal B=\{B_1,\dots ,B_k\}.
$$

A **common** SDR is a $k$-element set $T\subseteq U$ that can be matched to $\mathcal A$ **and** (possibly with a different ordering) matched to $\mathcal B$.

#### Matroid viewpoint

For any family of subsets $\mathcal F=\{F_1,\dots ,F_k\}$, the class

$$
\mathcal I_{\mathcal F}\;=\;\Bigl\{\,S\subseteq U \;\Bigm|\;
S \text{ can be matched injectively into } \mathcal F\Bigr\}
$$

is a **transversal matroid** (also called a _rank-$k$ matroid_).  
Independence oracle for $\mathcal I_{\mathcal F}$:  
given $S\subseteq U$, build the bipartite graph $(\{F_i\},S)$ and ask whether there is a matching of size $|S|$ (using algorithm from part (a)).

Define

$$
M_A=\bigl(U,\mathcal I_{\mathcal A}\bigr),\qquad
M_B=\bigl(U,\mathcal I_{\mathcal B}\bigr).
$$

_Goal:_ find a common independent set of size $k$ in $M_A\cap M_B$.

Finding a largest common independent set of two matroids is the classic **matroid-intersection** problem, solvable in polynomial time (Edmonds' algorithm, 1965).

#### Algorithm (high-level)

1. Construct the two independence oracles described above.
2. Run Edmonds' augmenting-path algorithm for matroid intersection to obtain a maximum common independent set $T\subseteq U$.
3. If $|T|=k$ output **YES** and (optionally) recover two perfect matchings showing that $T$ is an SDR for both families (each is obtained by running part (a) on $T$ + its family).  
   Otherwise output **NO**.

#### Correctness proof

Edmonds' algorithm returns a maximum-size set that is independent in both matroids.  
• If its size is $k$ then $T$ is independent in $M_A$, so $T$ can be matched to $\mathcal A$; likewise to $\mathcal B$. Thus $T$ is a common SDR.  
• If its size is $<k$ no larger common independent set exists, hence no common SDR exists.  
Therefore the algorithm is correct.

#### Running-time analysis

For ground set size $n$ and target rank $k$ Edmonds' algorithm runs in

$$O\bigl(k\,(T_\text{oracle}) + k^2n\bigr),$$

where $T_\text{oracle}$ is the time for one oracle call.  
Each oracle call is a matching test on at most $k$ left vertices and $\le n$ right vertices, cost

$$T_\text{oracle}=O\!\bigl(\sqrt{k}\,kn\bigr)$$

from part (a).  
Hence the whole procedure is

$$O\!\bigl(k\cdot\sqrt{k}\,kn + k^2n\bigr)=O\!\bigl(k^{2.5}n\bigr),$$

still polynomial in $k,n$.

---

#### Where the two matchings come from (optional detail)

After we have obtained the common set $T$ of size $k$,

- run Hopcroft–Karp on $G_A$ restricted to right vertices $T$ to get a bijection $T\leftrightarrow \mathcal A$;
- run Hopcroft–Karp on $G_B$ restricted to $T$ to get a bijection $T\leftrightarrow \mathcal B$.

Because $T$ was independent in each matroid, both matchings exist, completing the explicit construction of the common SDR.

## Question-2 (35 points)

Consider solving a maximum flow problem $(G = ( V , E ) , s , t , c)$ by using the **Dinic Algorithm**. In this problem, we assume that the capacities for all edges are 1: $c ( e ) = 1$ for each $e \in E$ .

(Notice: There is no pair of anti-parallel edges: for each pair of vertices $u , v \in V$ , we cannot have both $( u , v ) \in E$ and $( v , u ) \in E$ . Every vertex is reachable from $s$ .)

### (a) (15 points)

Prove the algorithm runs in $O ( | E | ^ { 3 / 2 } )$ time.

### (b) (10 points)

Let $f$ be the flow after $2 | V | ^ { 2 / 3 }$ iterations of the algorithm. Let $D _ { i }$ be the set of vertices at a distance $i$ from $s$ in the residual network $G ^ { f }$ . Prove that there exists $i$ such that $| D _ { i } \cup D _ { i + 1 } | \le | V | ^ { 1 / 3 }$ .

### (c) (10 points)

Analyze the time complexity by using both $| V |$ and $| E |$ .

## Answer-2

### (a) Proving an $O(|E|^{3/2})$ running time when all capacities are $1$

1.  Cost of one phase  
    In Dinic every phase  
    (i) builds the level graph in $O(|E|)$,  
    (ii) finds a **blocking flow**.  
    With unit capacities the depth-first “send-one-unit-and-delete-the-edge’’ DFS visits every edge **at most once**, so a blocking flow is found in another $O(|E|)$.  
    Therefore one phase is $O(|E|)$.

2.  How many phases?  
    Denote by $\ell_k$ the length of the shortest $s\!-\!t$ path **after** the $k$-th phase.  
    These distances never decrease: $\ell_0\le\ell_1\le\cdots$.

• After $ \sqrt{|E|}$ phases we must have $\ell_{\sqrt{|E|}}\ge\sqrt{|E|}$:  
 otherwise the same short path would be present in every phase, and since each phase saturates at least one edge of that path, the path would contain $>\!|E|$ distinct edges – impossible.

• Residual flow still left after the first $\sqrt{|E|}$ phases  
 Every remaining augmenting path now has length at least $\sqrt{|E|}$.  
 Paths are edge-disjoint (unit capacities), hence their number is

$$
\le\frac{|E|}{\sqrt{|E|}}=\sqrt{|E|}.
$$

So the yet-unrouted value is $\le\sqrt{|E|}$.

• Each subsequent phase routes **at least one** unit (if any exists), therefore
another $\sqrt{|E|}$ phases are enough to finish.

Total number of phases $\le 2\sqrt{|E|}=O(\sqrt{|E|})$.

3.  Total time  
    $O(|E|)$ per phase × $O(\sqrt{|E|})$ phases = $O(|E|^{3/2})$.

---

### (b) A “narrow” level in at most $2|V|^{2/3}$ phases

Let the algorithm run for $2|V|^{2/3}$ phases and let $f$ be the current flow.
For every level $i$ put  
$D_i=\{\,v\mid\text{dist}_{G^f}(s,v)=i\,\}$.

Assume for contradiction that  
$|D_i|\!+\!|D_{i+1}| > |V|^{1/3}$ for **all** $i$.

Sum the inequalities for $i=0,2,4,\dots$ up to the level of $t$:

$\displaystyle
|V|
=\sum_i |D_i|
\;\;>\;\;
\frac{\text{dist}_{G^f}(s,t)}{2}\;|V|^{1/3}.
$

Hence  
$\text{dist}_{G^f}(s,t) < 2|V|^{2/3}.$

But in Dinic every phase either terminates the algorithm or strictly increases
$\text{dist}(s,t)$, so after $2|V|^{2/3}$ phases we would have  
$\text{dist}(s,t)\ge 2|V|^{2/3}$ – a contradiction.

Therefore some index $i$ satisfies  
${|D_i\cup D_{i+1}|\le |V|^{1/3}}$.

---

### (c) Time bound in terms of both $|V|$ and $|E|$

1.  Up to $|V|^{2/3}$ “early” phases  
    If the algorithm finishes within these phases, total time is  
    $O(|V|^{2/3}\,|E|)$ – done.

2.  Otherwise, build the cut of capacity $|V|^{2/3}$  
    Apply part (b) after the first $|V|^{2/3}$ phases.  
    Take the level index $i$ with $|D_i\cup D_{i+1}|\le |V|^{1/3}$ and define the cut

$$
L=\bigcup_{j\le i}D_j,\qquad R=V\setminus L.
$$

Every edge of this cut goes from level $i$ to $i+1$, so its **number** is
at most $|D_i|\,|D_{i+1}|\le |V|^{2/3}$.  
 Because capacities are $1$, the cut capacity is $\le |V|^{2/3}$.
By max-flow min-cut, **at most** $|V|^{2/3}$ additional units of flow remain.

3.  At most another $|V|^{2/3}$ phases are needed  
    Each later phase augments by at least $1$, so the algorithm finishes after at most  
    $|V|^{2/3}$ further phases.

4.  Final complexity  
    Total phases $<2|V|^{2/3}$, each costing $O(|E|)$  
    ⇒ $O(|E|\,|V|^{2/3})$.

Hence Dinic with unit capacities runs in ${O\!\bigl(|E|^{3/2}\bigr)}$ or, more generally, ${O\!\bigl(|E|\,|V|^{2/3}\bigr)}$ – whichever is smaller.

## Question-3 (40 points)

In this question, we will prove König-Egerváry Theorem, which states that, in any bipartite graph, the size of the maximum matching equals the size of the minimum vertex cover. Let $G = ( V , E )$ be a bipartite graph.

### (a) (8 points)

Explain that the following is an LP-relaxation for the maximum matching problem.

$$
\begin{array} { l } { \displaystyle \mathrm { maximize } \sum _ { e \in E } x _ { e } } \\ { \displaystyle \mathrm { subject \ to } \sum _ { e : e = ( u , v ) } x _ { e } \leq 1 } \\ { \displaystyle x _ { e } \geq 0 } \end{array}
$$

### (b) (8 points)

Write down the dual of the above linear program, and justify that the dual program is an LP-relaxation to the minimum vertex cover problem.

### (c) (8 points)

Show by induction that the incident matrix of a bipartite graph is totally unimodular. (Given an undirected graph $G = ( V , E )$ , the incident matrix $A$ is a $| V | \times | E |$ zero-one matrix where $a _ { i j } = 1$ if and only if the $i$ -th vertex and the $j$ -th edge are incidents.)

### (d) (8 points)

Use results in (a), (b), and (c) to prove König-Egerváry Theorem.

### (e) (8 points)

Give a counterexample to show that the claim in König-Egerváry Theorem fails if the graph is not bipartite.

## Answer-3

### (a) Why this LP is a relaxation of Maximum Matching

For every edge $e\in E$ introduce a variable $x_e$.

$$
\begin{array}{l}
{\mathrm{maximize} \sum_{e \in E} x_{e}} \\
{\mathrm{subject\ to} \sum_{e : e = (u,v)} x_{e} \leq 1 \quad \forall v \in V} \\
{x_{e} \geq 0 \quad \forall e \in E}
\end{array}
$$

• In an integral solution we may force $x_e\in\{0,1\}$; then $x_e=1$ means that $e$ is chosen for the matching.

• The constraint for each vertex $v$ says that at most one incident edge can be chosen, exactly the definition of a matching.

Because we dropped the integrality requirement this program “relaxes’’ the combinatorial problem; any matching corresponds to a feasible LP solution with the same objective value, but not necessarily vice versa.

---

### (b) Dual program and its relation to Minimum Vertex Cover

Write the primal in standard form and place one dual variable $y_v$ for each vertex-constraint:

$$
\begin{array}{l}
{\mathrm{minimize} \sum_{v \in V} y_{v}} \\
{\mathrm{subject\ to} \quad y_{u} + y_{v} \geq 1 \quad \forall (u,v) \in E} \\
{y_{v} \geq 0 \quad \forall v \in V}
\end{array}
$$

Interpretation when $y_v$ is restricted to $\{0,1\}$: $y_v=1$ means $v$ is put into the vertex cover.  
For every edge $(u,v)$ the inequality $y_u+y_v\ge1$ forces at least one endpoint into the cover.  
Thus the 0-1 versions of the dual variables encode vertex covers and the objective counts their size.  
Again, dropping integrality turns it into an LP relaxation of the minimum vertex-cover problem.

---

### (c) The incidence matrix of a bipartite graph is totally unimodular

Incidence matrix $A$ : rows = vertices, columns = edges, entry $a_{ve}=1$ iff $v$ is an endpoint of $e$.

We prove by induction on $k$ that every square sub-matrix of size $k\times k$ has determinant in $\{-1,0,1\}$.

Base case $k=1$ is immediate: any $1\times1$ sub-matrix is either $[0]$ or $[1]$.

Induction step.  
Take any $(k+1)\times(k+1)$ sub-matrix $T$.

1. If some column of $T$ is all zeros, $\det(T)=0$.

2. If a column contains exactly one $1$, expand the determinant along this column. The cofactor is a $k\times k$ sub-matrix whose determinant is, by induction, in $\{-1,0,1\}$, so $\det(T)\in\{-1,0,1\}$.

3. Otherwise every column contains exactly two $1$’s.  
   Because $G$ is bipartite we can split the rows of $T$ into parts $R_1$ and $R_2$ (left set / right set of the bipartition) so that each column has one $1$ in $R_1$ and one $1$ in $R_2$.  
   Add all rows of $R_1$ and subtract all rows of $R_2$; the resulting vector is the zero vector, hence the rows are linearly dependent, giving $\det(T)=0$.

Thus all square sub-matrices have determinant $0$, $1$ or $-1$, i.e. $A$ is totally unimodular.

---

### (d) Deriving König-Egerváry from (a)–(c)

• In both primal and dual LPs the coefficient matrices are exactly $A$ and $A^T$.  
 Because $A$ is totally unimodular and the right-hand sides are integral, **every basic optimal solution is integral** (property of TU matrices).

• Moreover, values larger than $1$ can never be optimal: in the primal, decreasing an $x_e>1$ by $1$ keeps feasibility and improves the objective, contradicting optimality; the same for dual with $y_v>1$.

Hence there exist optimal solutions with

$x_e^\ast \in \{0,1\}$ (maximum matching)

$y_v^\ast \in \{0,1\}$ (minimum vertex cover).

• LP duality guarantees equal objective values:

$\sum_{e\in E} x_e^\ast \;=\; \sum_{v\in V} y_v^\ast$.

Therefore the size of a maximum matching equals the size of a minimum vertex cover in any bipartite graph—this is exactly König-Egerváry Theorem.

---

### (e) What goes wrong in a non-bipartite graph

Consider the triangle $K_3$ with vertices $\{a,b,c\}$.

• Maximum matching: only one edge can be picked, so size $1$.  
• Vertex cover: at least two vertices are needed to cover all three edges, so the minimum cover has size $2$.

Hence matching size $\neq$ cover size, showing the theorem fails when the graph is not bipartite.

## Question-4

How long does it take you to finish the assignment (including thinking and discussing)? Give a score (1,2,3,4,5) to the difficulty. Do you have any collaborators? Write down their names here.
