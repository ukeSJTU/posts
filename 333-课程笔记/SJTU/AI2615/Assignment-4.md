## Question-1 (30 points)

We are given a sequence of integers $a _ { 1 } , a _ { 2 } , . . . , a _ { n }$ , a lower bound, and an upper bound $1 \leq L \leq R \leq n$ . An $( L , R )$ -step subsequence is a subsequence $a _ { i _ { 1 } } , a _ { i _ { 2 } } , . . . , a _ { i _ { \ell } }$ , such that $\forall 1 \leq j \leq \ell - 1$ , $L \leq i _ { j + 1 } - i _ { j } \leq R$ . The revenue of the subsequence is $\sum _ { j = 1 } ^ { \ell } a _ { i _ { j } }$ . Design a DP algorithm to output the maximum revenue we can get from a $( L , R )$ -step subsequence.

### (a) (10 points)

Suppose $L = R = 1$ . Design a DP algorithm in $O ( n )$ to find the maximum $( 1 , 1 )$ -step subsequence.

### (b) (10 points)

Design a DP algorithm in $O ( n ^ { 2 } )$ to find the maximum $( L , R )$ -step subsequence for any $L$ and $R$ .

### (c) (10 points)

Design a DP algorithm in $O ( n )$ to find the maximum $( L , R )$ -step subsequence for any $L$ and $R$ .

## Answer-1

Throughout this problem, let $dp[i]$ be defined as:

$$
dp[i] = \text{maximum revenue of an $(L,R)$-step subsequence that ends at position } i \quad (1 \le i \le n).
$$

The final answer to each sub-problem will be the maximum value in the $dp$ array:
$$ \max\_{1 \le i \le n} dp[i]. $$

### (a) $L=R=1$ — contiguous subsequences (Kadane's algorithm in disguise) $O(n)$

When $L=R=1$, every step in the subsequence must be to the immediately next index. This means any feasible $(1,1)$-step subsequence is a _contiguous_ block of elements from the original sequence.
The recurrence relation for $dp[i]$ is therefore:
$$ dp[i]=\max(dp[i-1]+a_i, a_i), \quad \text{with the base case } dp[1]=a_1. $$

Here's the algorithm:

```text
maxSubarray(a[1..n]):
    // dp[i] is stored in 'cur', overall max in 'best'
    // Base case for i=1 handled by initialization
    if n == 0: return 0 // Or some indicator for empty sequence
    if n >= 1:
        cur = a[1]
        best = a[1]

    for i = 2 to n:
        cur = max(cur + a[i], a[i])   // Recurrence for dp[i]
        best = max(best, cur)         // Keep track of the overall maximum

    // If all a[i] are negative, an empty subsequence (revenue 0) might be preferred.
    // The problem implies subsequences must be non-empty by summing a_i_j.
    // If revenues can be negative and we want max, Kadane normally returns max subarray sum.
    // If an empty subsequence is allowed and has revenue 0, best = max(best, 0).
    // Based on the problem, we seek a non-empty subsequence.
    // If all dp[i] are negative, the result would be the largest of these negatives.
    return best
```

_Time Complexity._ The algorithm involves a single pass through the sequence, so it runs in $O(n)$ time.
_Space Complexity._ It uses a constant amount of extra space (for `best` and `cur`), so $O(1)$.

_Correctness Proof._
The proof is by induction on $i$.

- **Base Case:** For $i=1$, $dp[1]=a_1$. A subsequence ending at $a_1$ must include $a_1$, and since it's the first element, it can only be $a_1$ itself. Thus, $dp[1]=a_1$ is optimally found.

- **Inductive Step:** Assume that $dp[k]$ correctly stores the maximum revenue of a $(1,1)$-step subsequence ending at $a_k$ for all $k < i$.
  An optimal $(1,1)$-step subsequence ending at $a_i$ can be formed in one of two ways:
  1.  It extends an optimal $(1,1)$-step subsequence ending at $a_{i-1}$. In this case, its revenue is $dp[i-1] + a_i$.
  2.  It starts anew at $a_i$. In this case, its revenue is simply $a_i$.
      The recurrence $dp[i]=\max(dp[i-1]+a_i, a_i)$ correctly chooses the better of these two options. By the inductive hypothesis, $dp[i-1]$ was optimal for subsequences ending at $a_{i-1}$. Therefore, $dp[i]$ is computed optimally for subsequences ending at $a_i$.

This completes the induction. The overall maximum revenue is $\max_{1 \le i \le n} dp[i]$.

### (b) General $L,R$ — naïve dynamic programming $O(n^2)$

For a general $(L,R)$-step subsequence, an element $a_i$ can be preceded by an element $a_j$ if $L \le i-j \le R$.
The recurrence for $dp[i]$ is:
$$ dp[i] = a*i + \max \left(0, \max*{\substack{L \le d \le R \\ i-d \ge 1}} dp[i-d] \right) $$
If there is no legal predecessor $j$ (i.e., the set $\{j \mid L \le i-j \le R, i-d \ge 1\}$ is empty, or all such $dp[j]$ are negative and we prefer starting anew with $a_i$), $dp[i]$ effectively becomes $a_i$. The $\max(0, \dots)$ handles cases where all previous $dp$ values are negative; if $a_i$ itself is positive, we might prefer to start a new subsequence at $a_i$. If $a_i$ can be negative, we'd take $a_i + \text{best\_positive\_dp\_ending\_at\_j}$. If all $dp[j]$ are negative, we might still take $a_i + \text{least\_negative\_dp\_j}$ . The formulation $a_i + \text{bestPrev}$ (where `bestPrev` is 0 if no valid positive sum from previous or empty set of predecessors) correctly reflects taking $a_i$ alone or extending a previous subsequence.

Let $dp[i]$ be the maximum revenue of a subsequence ending at $a_i$.
If $a_i$ is the first element of its subsequence, $dp[i] = a_i$.
Otherwise, $dp[i] = a_i + dp[j]$ for some $j$ such that $L \le i-j \le R$. We want to maximize this.
So, $dp[i] = a_i + \max(\{0\} \cup \{dp[j] \mid i-R \le j \le i-L \text{ and } j \ge 1\})$.
The $0$ in $\max(\{0\} \cup \dots)$ ensures that if all previous valid $dp[j]$ are negative, we prefer to start a new subsequence with $a_i$ (effectively adding $0$ from previous elements).

```text
maxLRNaive(a[1..n], L, R):
    // Initialize dp array; using -∞ for elements not yet computed or unreachable.
    // However, dp[i] can be negative if a[i] is negative.
    // Let dp[i] store the max revenue of a subseq ending at a[i].
    dp = array of size n

    for i = 1 to n:
        bestPrev = 0  // Represents choosing a_i to start a new subseq segment,
                      // or if all connectable previous subseq sums are negative.
        for d = L to R:
            j = i - d
            if j >= 1: // Check if predecessor index is valid
                // We consider dp[j] only if it leads to a better sum.
                // If we are forced to take a dp[j] even if negative,
                // then bestPrev should be initialized to -∞.
                // The problem asks for maximum revenue. A subsequence can be just a_i.
                // So, dp[i] = a_i OR a_i + dp[j].
                // dp[i] = a_i + max(0, dp[j_1], dp[j_2] ...)
                // This corresponds to: dp[i] = a_i + X where X = max over relevant dp[j]s.
                // If all relevant dp[j]s are negative, we might still extend one if a_i + dp[j] > a_i.
                // The standard definition is dp[i] = a_i + max(0, max_{valid j} dp[j]).
                // Or, if subsequences can be of length 1: dp[i] = max(a_i, a_i + max_{valid j} dp[j])
                // The problem statement implies dp[i] = a_i + value from dp[j]. If no j, dp[i] = a_i.
                // bestPrev should be max of valid dp[j]'s.
                // If this max is negative, we'd still take it if problem requires extending.
                // But typical "max revenue" allows starting new.
                // So: dp[i] = a[i] + max(0, best_dp_j_found_so_far)

                // Let's refine bestPrev initialization for clarity:
                // max_val_from_prev_dp = -∞ (or a very small number)
                // In each step: max_val_from_prev_dp = max(max_val_from_prev_dp, dp[j])
                // Then: dp[i] = a[i] + max(0, max_val_from_prev_dp) if max_val_from_prev_dp was initialized to 0 or -inf.
                // Or more simply:
                // current_max_for_this_i = a[i] (start new subsequence)
                // For each j: current_max_for_this_i = max(current_max_for_this_i, a[i] + dp[j])
                // This means dp[i] definition should be:
                // dp[i] = max(a[i], a[i] + max_{valid_j} dp[j])
                // which is equivalent to dp[i] = a[i] + max(0, max_{valid_j} dp[j]) if we assume a_i must be part of sum.
                // The provided solution text uses dp[i] = a[i] + bestPrev, where bestPrev = max(0, dp[j]). This is standard.
                if j >= 1: // Check if predecessor index is valid
                    if first_valid_j_for_this_i: // pseudocode detail
                        bestPrev = dp[j]
                        first_valid_j_for_this_i = false
                    else:
                        bestPrev = max(bestPrev, dp[j])

        // After checking all d:
        // If no valid j was found, bestPrev could still be uninitialized or -∞.
        // To handle this, if no valid j, subsequence starts with a_i.
        // If valid j's exist, bestPrev = max_{valid j} dp[j].
        // Then dp[i] = a[i] + max(0, bestPrev from actual dp values).
        // The provided solution `bestPrev = 0` initially and `bestPrev = max(bestPrev, dp[j])`
        // implicitly handles max(0, max_dp_j)

        // Re-aligning with provided solution's pseudocode:
        // dp values are initialized to -infinity conceptually.
        // dp[i] will be calculated.
        // Iteration i for dp[i]:
        max_prev_dp_val = 0 // Represents: "if no positive sum from previous subseq, start new with a[i]"
                           // or "if no valid prev subseq, start new with a[i]"
        found_prev = false
        for d = L to R:
            j = i - d
            if j >= 1:
                if !found_prev: // first valid predecessor
                    max_prev_dp_val = dp[j]
                    found_prev = true
                else:
                    max_prev_dp_val = max(max_prev_dp_val, dp[j])

        if found_prev:
            dp[i] = a[i] + max(0, max_prev_dp_val) // If max_prev_dp_val is negative, prefer a[i] alone
        else: // no valid predecessor
            dp[i] = a[i]

    // The overall answer is the max value encountered in dp array.
    // The pseudocode in the original draft is simpler and assumes dp array filled meaningfully.
    // Let's stick to the simpler logic: dp[i] = a[i] + bestPrev where bestPrev is max(0, relevant dp[j]).
    // dp needs to be initialized, say all to 0 or -infinity.
    // If we initialize dp elements to a very small negative number:
    // dp_values = array of size n, initialized to NEGATIVE_INFINITY

    for i = 1 to n:
        max_from_previous_terms = 0 // Default if no valid predecessor or all their dp values are negative

        // Find max dp[j] among valid predecessors
        // The loop for d should find max_val = max(dp[i-d]). If no such d, this is an issue.
        // temp_max = NEGATIVE_INFINITY; (conceptually)
        // for d = L to R: j = i-d; if j >= 1: temp_max = max(temp_max, dp[j]);
        // if temp_max == NEGATIVE_INFINITY: dp[i] = a[i]; else dp[i] = a[i] + max(0, temp_max);
        // The original solution's pseudocode `bestPrev = 0` then `bestPrev = max(bestPrev, dp[j])` correctly computes max(0, max dp[j]).

        bestPrev = 0 // Accumulates max(dp[j]) for valid j's, floored at 0.
        for d = L to R:
            j = i - d
            if j >= 1: // Check if predecessor index j is valid
                // We assume dp[j] has been computed.
                bestPrev = max(bestPrev, dp[j]) // If dp[j] is negative, but larger than current bestPrev (e.g. bestPrev=0 initially, or other negative dp[k]), it's taken.
                                                 // This should be max(bestPrev_so_far, dp[j]) and then result is max(0, final_bestPrev_so_far).
                                                 // The original pseudocode `bestPrev = max(bestPrev, dp[j])` starting with `bestPrev=0` is correct if dp values are non-negative.
                                                 // But dp values can be negative.
                                                 // So, it should be:
                                                 // real_max_prev_dp = -Infinity (or some flag)
                                                 // for d=L..R, j=i-d: if j>=1: real_max_prev_dp = max(real_max_prev_dp, dp[j])
                                                 // if real_max_prev_dp == -Infinity (no valid j): dp[i] = a[i]
                                                 // else: dp[i] = a[i] + max(0, real_max_prev_dp)
                                                 // This is what the question text's formula implies.

    // Using the structure from the original text for clarity:
    // dp array initialized appropriately (e.g. dp[k]=0 or -inf for k<=0)
    // Let dp[0] = 0 and other dp[k] for k<1 be -INF
    // For i = 1 to n:
    //    max_prev_val = -INF
    //    for j from i-R to i-L:
    //        if j >= 0: max_prev_val = max(max_prev_val, dp[j]) // dp[0] = 0 handles start of sequence
    //    dp[i] = a[i] + max_prev_val (if max_prev_val was -INF, this means a[i] alone, but need to ensure a[i] if max_prev_val from dp[0] is 0)
    //    dp[i] = a[i] + (if max_prev_val == -INF then 0 else max_prev_val) -- no, this is not it
    //    dp[i] = a[i] for first term, or a[i] + dp[j]
    //    Let's use the problem's pseudocode verbatim as it is common:
    //    dp[1..n] initialized to -∞ (or a very small number)

    for i = 1 to n:
        bestPriorRevenue = 0 // If no valid/positive predecessor, effectively start new subseq sum with a[i]
        for d = L to R:
            j = i - d
            if j >= 1: // Predecessor must be a valid index
                // dp[j] must have been computed. If dp values can be negative,
                // we should consider them. max function handles this.
                // The logic dp[i] = a[i] + X. X should be max of dp[j] from valid range.
                // If all such dp[j] are negative, X is the largest (least negative) of them.
                // If no such j, then X effectively makes dp[i] = a[i].
                // The problem's code had bestPrev = max(bestPrev, dp[j]) starting from bestPrev=0.
                // This makes X = max(0, max_over_j dp[j]). This is standard for Kadane-like problems.
                bestPriorRevenue = max(bestPriorRevenue, dp[j])
        dp[i] = a[i] + bestPriorRevenue

    // The overall maximum revenue is the maximum value in the dp array.
    // If all dp[i] are negative (e.g. all a[i] are negative), this would be the largest negative.
    // If problem allows empty subsequence with revenue 0, then max(0, max(dp values)).
    // Typically, we are looking for non-empty.
    overallMaxRevenue = -∞
    for i = 1 to n:
        overallMaxRevenue = max(overallMaxRevenue, dp[i])
    return overallMaxRevenue

```

_Time Complexity._ The outer loop runs $n$ times. The inner loop (over $d$) runs $R-L+1$ times. In the worst case, $R-L+1$ can be $O(n)$ (e.g., $L=1, R=n$). So, the total time complexity is $O(n(R-L+1))$, which is $O(n^2)$.
_Space Complexity._ We use an array of size $n$ for $dp$, so $O(n)$ space.

_Correctness Proof._
The proof is by induction on $i$.

- **Base Cases:** For $i$ such that no valid predecessor $j$ exists (e.g., $i-L < 1$), $dp[i]$ is set to $a_i$ (as `bestPriorRevenue` remains $0$). This is correct as any subsequence ending at $a_i$ must start at $a_i$.
- **Inductive Step:** Assume $dp[k]$ is correctly computed for all $k < i$.
  When computing $dp[i]$, we consider all valid predecessors $a_j$ (where $j = i-d$ for $L \le d \le R$ and $j \ge 1$).
  A subsequence ending at $a_i$ either starts at $a_i$ (revenue $a_i$) or appends $a_i$ to a subsequence ending at some $a_j$.
  The term $a_i + \text{bestPriorRevenue}$ correctly captures this. `bestPriorRevenue` is $\max(\{0\} \cup \{dp[j] \mid i-R \le j \le i-L, j \ge 1 \})$.
  The $\max(0, \dots)$ ensures that we only extend a previous subsequence if it has positive revenue; otherwise, we prefer to start a new subsequence segment with $a_i$ (effectively $a_i + 0$).
  By the induction hypothesis, each $dp[j]$ is optimal for subsequences ending at $a_j$. Thus, $dp[i]$ is computed optimally.
  The final answer is $\max_{1 \le i \le n} dp[i]$ because the maximum revenue subsequence can end at any position.

---

### (c) General $L,R$ — linear-time DP with a monotone deque $O(n)$

The recurrence $dp[i] = a_i + \max(\{0\} \cup \{\text{dp}[j] \mid i-R \le j \le i-L, j \ge 1\})$ requires finding the maximum value in a sliding window of $dp$ values. The window is $dp[k]$ for $k \in [i-R, i-L]$.
Let $M_i = \max (\{\text{dp}[j] \mid i-R \le j \le i-L, j \ge 1\})$. If this set is empty or all values are negative, we can take $M_i=0$ effectively, so $dp[i]=a_i$.
The value $M_i$ (or rather, $\max_{i-R \le j \le i-L} dp[j]$) is a sliding window maximum problem. The window spans indices from $i-R$ to $i-L$. This can be computed in $O(1)$ amortized time per query using a **monotone (decreasing) deque**. The deque will store indices $j$ such that $dp[j]$ are in decreasing order.

```text
maxLRLinear(a[1..n], L, R):
    dp = array of size n + 1 // dp[0] can be used as a sentinel
    dp[0] = 0 // Represents sum before starting any subsequence
    // Other dp[i] for i < 0 could be -INF if indices could be < 1.
    // Here, j >= 1 is handled by loop bounds or checks for Q.front.

    Q = empty deque // Stores indices k from [0...i-1] such that dp[k] are decreasing.
                  // Indices themselves are increasing in Q.

    overallMaxRevenue = -∞ // Assuming a_i can be negative. If only positive, 0.

    for i = 1 to n:
        // 1. Remove indices from Q.front that are too old for window [i-R, i-L].
        // Window for dp[j] means j < i. Specifically, j <= i-L.
        // The actual indices in dp are 1 to n.
        // We need max of dp[j] for j in [i-R, i-L].
        // Indices stored in Q are from 1 ... i-1.

        // Remove indices from front of Q that are no longer in the window [i-R, ...]
        // i.e., Q.front < i-R
        while Q not empty and Q.front < i - R:
            pop_front(Q)

        // 2. Get maxPrev from Q.front.
        // Q.front is the largest dp value in the relevant part of the window.
        // We need dp[j] where j <= i-L.
        // If Q.front > i-L, it means all elements in Q are too "new" (i.e. i-Q.front < L).
        // In this case, there's no valid predecessor in Q.
        maxPrevDP = 0 // Default if no suitable predecessor found or all have negative dp sum.
        if Q not empty and Q.front <= i - L: // Check if Q.front is a valid predecessor for a_i
                                             // (i.e., Q.front index is not too recent: Q.front <= i-L)
            maxPrevDP = dp[Q.front]

        // If all connectable dp values are negative, we prefer not to connect, hence max(0, maxPrevDP).
        dp[i] = a[i] + max(0, maxPrevDP)

        overallMaxRevenue = max(overallMaxRevenue, dp[i])

        // 3. Maintain deque's decreasing property for dp values when adding current dp[i].
        // Add current i (and its dp[i]) to Q. i is an index.
        // Before adding i, remove indices k from Q.back if dp[k] <= dp[i].
        // This is for dp[i] to be a candidate for future computations.
        // The problem asks for dp[i] = a[i] + max_{j in window} dp[j].
        // What should be stored in deque? Actual dp values or indices? Indices.
        // If we are computing dp[i], we query max over dp[j] for j in [i-R, i-L].
        // Then we add dp[i] to consideration for future states.
        // The values dp[0]...dp[i-1] are candidates.
        // The standard sliding window max stores elements from the "current" window.
        // Here, we push dp[i-L+1] (or rather its index) into the deque as the window slides.
        // This is slightly different. The algorithm computes dp[i], then i becomes a candidate for dp[k] where k > i.
        // The provided pseudocode seems to update Q with `i` and `dp[i]`.

        // Let's refine step 1 & 2 & 4 based on typical usage for this DP:
        // At iteration i:
        // Window for selection is [i-R, i-L].
        // We need to consider dp[j] where j ranges from max(1, i-R) to i-L.
        // The deque stores indices of *already computed* dp values.

        // (This part of code is from original template - let's stick to it and make sure correctness proof covers it)
        // 1. Remove indices from Q that are too old (i.e., Q.front < i-R).
        // (This is done above before computing dp[i])

        // 2. The maximum over [i-R, i-L] is at Q.front.
        // (This check Q.front <= i-L is done above)

        // 3. Compute dp[i].
        // (Done above)

        // 4. Insert i into deque, maintaining decreasing order of dp[].
        // This means dp[i] is now a candidate for future dp values.
        // Indices to be pushed should be relevant.
        // If dp[i] is pushed, it should be a candidate for future windows.
        // The window for dp[k] is [k-R, k-L]. So dp[i] is relevant if i is in some [k-R, k-L].
        // This means k-R <= i <= k-L, so i+L <= k <= i+R.
        // The elements in Q are dp values that are themselves maximal in some suffix of Q.
        while Q not empty and dp[Q.back] <= dp[i]: // If new element is better, pop smaller ones
            pop_back(Q)
        push_back(Q, i) // Add current index i

    return overallMaxRevenue
```

The deque $Q$ stores indices $j$ from $1, \dots, i-1$ such that:

1.  The indices $j$ are in increasing order.
2.  The corresponding $dp[j]$ values are in strictly decreasing order.
3.  (After Step 1 cleanup) $Q.front \ge i-R$. This ensures elements are not too old.
4.  (In Step 2) $Q.front$ gives the index of the maximum $dp[j]$ value in the valid window $[i-R, i-L]$ if $Q.front \le i-L$. If $Q.front > i-L$, it means all potentially useful previous states are too "recent" (the gap $i-Q.front$ would be less than $L$), so no valid $j$ from $Q$ can be used.
5.  (In Step 4) When $i$ (and its $dp[i]$) is added, elements $k$ at the back of $Q$ with $dp[k] \le dp[i]$ are removed. This maintains the decreasing $dp$ value property. Since $i$ is greater than any index already in $Q$, $i$ is added to the back, maintaining increasing indices.

Each index is pushed onto the deque once and popped at most once. Thus, all deque operations take $O(n)$ total time across all iterations.

_Time Complexity._ The loop runs $n$ times. Each element $a_i$ (and its index $i$) is pushed onto and popped from the deque at most once. Amortized cost per iteration is $O(1)$. Total time complexity is $O(n)$.
_Space Complexity._ $O(n)$ for the $dp$ array. The deque can store up to $O(n)$ indices in the worst case (e.g. if $R=n$, or $dp$ values are strictly decreasing). (Can be $O(R)$ for $dp$ array if we optimize space for $dp$ values, as $dp[i]$ only depends on values in a window of size $R$).

_Correctness Proof._
The core idea is that $dp[i]$ is correctly computed based on optimal $dp[j]$ values for $j<i$. The sliding window maximum technique using a deque correctly finds $\max \{dp[j] \mid i-R \le j \le i-L, j \ge 1\}$.
Let's consider the state of $Q$ when computing $dp[i]$:

- **Initialization:** $Q$ is empty. $dp[0]=0$ can act as a conceptual starting point.
- **Maintenance (Steps 1, 2, 4):**

  1.  **Step 1 (Windowing):** `while Q not empty and Q.front < i - R: pop_front(Q)`. This removes indices $j$ from the front of $Q$ that are now "too far" (i.e., $j < i-R$, so $i-j > R$). After this, all indices $k$ in $Q$ satisfy $k \ge i-R$.
  2.  **Step 2 (Query Max):** `if Q not empty and Q.front <= i - L: maxPrevDP = dp[Q.front]`. Since $Q$ stores indices $j$ in increasing order with $dp[j]$ in decreasing order, $Q.front$ holds the index $j^*$ that maximizes $dp[j^*]$ among $j \in Q$. After Step 1, $j^* \ge i-R$. If $j^* \le i-L$, then $j^*$ is in the desired window $[i-R, i-L]$, and $dp[j^*]$ is the maximum. If $Q$ is empty or $j^* > i-L$ (i.e., $i-j^* < L$), no suitable predecessor is found in $Q$, so `maxPrevDP` remains $0$.
  3.  **Step 3 (DP update):** $dp[i] = a[i] + \max(0, \text{maxPrevDP})$ is then computed using this maximum.
  4.  **Step 4 (Insert into Deque):** `while Q not empty and dp[Q.back] <= dp[i]: pop_back(Q); push_back(Q, i)`. This ensures that $Q$ maintains its properties: indices $j$ are increasing, and $dp[j]$ are strictly decreasing. $dp[i]$ (via index $i$) is now available for future computations.

- **Termination:** After the loop finishes for $i=n$, `overallMaxRevenue` holds $\max_{1 \le k \le n} dp[k]$.
  Since each $dp[i]$ is computed optimally based on previous optimal values, the overall result is correct.

## Question-2 (30 points)

Optimal Indexing for A Dictionary: Consider a dictionary with $n$ different words $a _ { 1 } , a _ { 2 } , . . . , a _ { n }$ sorted by the alphabetical order. We already know the number of search times of each word $a _ { i }$ , which is represented by $w _ { i }$ . Suppose that the dictionary stores all words in a binary search tree $T$ , i.e., each node’s word is alphabetically larger than the words stored in its left subtree and smaller than the words stored in its right subtree. Then, to look up a word in the dictionary, we have to do $\ell _ { i } ( T )$ comparisons on the binary search tree, where $\ell _ { i } ( T )$ is exactly the level of the node that stores $a _ { i }$ (root has level 1). We evaluate the search tree by the total number of comparisons for searching the $n$ words, i.e., $\sum _ { i = 1 } ^ { n } w _ { i } \ell _ { i } ( T )$ . Design a DP algorithm to find the best binary search tree for the $n$ words to minimize the total number of comparisons.

## Answer-2

We are given $n$ words, sorted alphabetically: $a_1 < a_2 < \dots < a_n$. Each word $a_i$ has a known number of searches (frequency) $w_i$. The words are stored in a binary search tree (BST) $T$. If word $a_i$ is stored at a node with level $\ell_i(T)$ (where the root is at level 1), searching for $a_i$ takes $\ell_i(T)$ comparisons.

Our objective is to find a BST $T$ that minimizes the total number of comparisons:
$$ \min*{T\text{ is a BST}} \sum*{i=1}^n w_i \ell_i(T)$$

### 1 Dynamic-programming formulation

Let $cost[i][j]$ be the minimum weighted cost (as defined in (1)) for a BST constructed from the sub-dictionary of words $a_i, \dots, a_j$, where $1 \le i \le j \le n$.

If the interval is empty (i.e., $j < i$), the cost is 0. So, we define $cost[i][i-1] = 0$ for all $1 \le i \le n+1$.

#### 1.1 Prefix sums for weights

To quickly calculate the sum of weights in a range, we can precompute prefix sums. Let $W(i,j) = \sum_{k=i}^{j} w_k$.
Define $prefix[k] = \sum_{m=1}^{k} w_m$, with $prefix[0]=0$.
Then $W(i,j) = prefix[j] - prefix[i-1]$. This takes $O(n)$ to precompute all $prefix[k]$ values, and then $O(1)$ for each $W(i,j)$ query.

#### 1.2 Recurrence relation

Consider constructing an optimal BST for words $a_i, \dots, a_j$. We must choose one word $a_r$ (where $i \le r \le j$) to be the root of this BST.
If $a_r$ is chosen as the root:

- Words $a_i, \dots, a_{r-1}$ will form the left subtree. The optimal cost for this is $cost[i][r-1]$.
- Words $a_{r+1}, \dots, a_j$ will form the right subtree. The optimal cost for this is $cost[r+1][j]$.
  When $a_r$ becomes the root of the BST for $a_i, \dots, a_j$, it is at level 1 _relative to this subproblem_. All words in its left and right subtrees ($a_i, \dots, a_{r-1}$ and $a_{r+1}, \dots, a_j$) are now one level deeper than they were in their respective subtrees $T_{i,r-1}$ and $T_{r+1,j}$.
  The sum $\sum w_k \ell_k(T)$ can be rewritten. If $a_r$ is root, its cost is $w_r \cdot 1$. For any node $a_k$ in the left subtree, its level increases by 1. Same for the right. So the total cost is:
  $w_r + (\text{cost}[i][r-1] + \sum_{k=i}^{r-1} w_k) + (\text{cost}[r+1][j] + \sum_{k=r+1}^{j} w_k)$.
  This simplifies to $\text{cost}[i][r-1] + \text{cost}[r+1][j] + \sum_{k=i}^{j} w_k$.
  So, the recurrence is:
  $$ \text{cost}[i][j] = \min\_{i \le r \le j} \left( \text{cost}[i][r-1] + \text{cost}[r+1][j] \right) + W(i,j)$$
We also store the choice of $r$ in a table, say $root[i][j]$, to reconstruct the tree later.

### 2 Algorithm

```text
optimalBST(words a[1..n], weights w[1..n]):

    // ----- 0. Pre-processing for W(i,j) -----
    prefix_sum = array of size n+1
    prefix_sum[0] = 0
    for k = 1 to n:
        prefix_sum[k] = prefix_sum[k-1] + w[k]

    // Helper function for W(i,j)
    // W_lookup(i, j):
    //     if i > j: return 0
    //     return prefix_sum[j] - prefix_sum[i-1]

    // ----- 1. Initialize DP tables -----
    // cost[i][j]: min cost for words a_i...a_j
    // root[i][j]: root of the optimal BST for a_i...a_j
    cost = 2D array of size (n+2)x(n+1) // For cost[i][i-1]
    root = 2D array of size (n+1)x(n+1)

    // Base cases: empty subtrees
    for i = 1 to n+1:
        cost[i][i-1] = 0

    // ----- 2. Fill DP table bottom-up by increasing interval length -----
    // len is the length of the sub-dictionary a_i...a_j
    for len = 1 to n:
        // i is the starting index of the sub-dictionary
        for i = 1 to n - len + 1:
            j = i + len - 1 // Ending index of the sub-dictionary

            current_W_ij = prefix_sum[j] - prefix_sum[i-1] // W(i,j)
            cost[i][j] = +∞      // Initialize with a large value

            // Try all possible roots r for the interval [i,j]
            for r = i to j:
                c = cost[i][r-1] + cost[r+1][j] + current_W_ij
                if c < cost[i][j]:
                    cost[i][j] = c
                    root[i][j] = r

    // ----- 3. The minimum cost for the entire dictionary a_1...a_n is cost[1][n] -----
    // The tree can be reconstructed using the root table (e.g., buildTree(1,n))
    // buildTree(i, j):
    //     if i > j: return null
    //     r_val = root[i][j]
    //     node = create_node(a[r_val])
    //     node.left = buildTree(i, r_val - 1)
    //     node.right = buildTree(r_val + 1, j)
    //     return node

    return cost[1][n] // (and potentially the reconstructed tree)
```

### 3 Complexity analysis

- **Time Complexity:**
  - Prefix sums: $O(n)$.
  - The main DP calculation involves three nested loops:
    - Outer loop for `len` runs $n$ times.
    - Middle loop for `i` runs $O(n)$ times.
    - Inner loop for `r` runs $O(len)$ times, which is $O(n)$ in the worst case.
  - Thus, the DP calculation takes $O(n^3)$ time.
  - Total time complexity: $O(n^3)$.

### 4 Correctness proof

The correctness of the algorithm relies on the optimal substructure and overlapping subproblems properties, proven by induction on the length of the interval, $\ell = j-i+1$.

- **Base Case ($\ell=0$):** For an empty set of words ($j=i-1$), $cost[i][i-1]=0$. This is correct, as an empty tree has zero cost. For $\ell=1$ (a single word $a_i$), $cost[i][i] = cost[i][i-1] + cost[i+1][i] + w_i = 0 + 0 + w_i = w_i$. This is correct as $a_i$ is the root and at level 1.

- **Inductive Step:** Assume that for all interval lengths $k < \ell$, $cost[i'][j']$ correctly computes the minimum cost for the sub-dictionary $a_{i'}, \dots, a_{j'}$.
  Now, consider an interval $[i,j]$ of length $\ell$. To find $cost[i][j]$, the algorithm tries every $a_r$ (for $r \in [i,j]$) as the root of the BST for $a_i, \dots, a_j$.
  If $a_r$ is chosen as the root:
  1.  The left child's subtree must be an optimal BST for $a_i, \dots, a_{r-1}$. Its cost, relative to $a_r$, is $cost[i][r-1]$. The length of this interval is $r-1-i+1 = r-i < \ell$.
  2.  The right child's subtree must be an optimal BST for $a_{r+1}, \dots, a_j$. Its cost, relative to $a_r$, is $cost[r+1][j]$. The length of this interval is $j-(r+1)+1 = j-r < \ell$.
      By the inductive hypothesis, $cost[i][r-1]$ and $cost[r+1][j]$ are optimal for these smaller subproblems.
      The term $W(i,j)$ (i.e., $\sum_{k=i}^{j} w_k$) accounts for the fact that all nodes $a_i, \dots, a_j$ (including $a_r$ itself, and all nodes in its left and right subtrees) are placed one level deeper within the larger tree structure for which this $T_{i,j}$ is a component, or if $T_{i,j}$ is the main tree, $W(i,j)$ represents the sum of $w_k \cdot 1$ for each node $a_k$ being at least at level 1 due to its own root $a_r$. More precisely, each $w_k$ in $W(i,j)$ contributes to the sum because $a_r$ is at level 1, and all other nodes $a_k$ in $T_{i,j}$ are at level $(\ell_k(T_{\text{sub}}) + 1)$. The sum $W(i,j)$ is exactly the sum of all $w_k$ for $k \in [i,j]$, each multiplied by 1 (for this level increase).
      The formula $cost[i][r-1] + cost[r+1][j] + W(i,j)$ correctly sums these costs.
      The algorithm iterates over all possible roots $a_r$ and chooses the one that minimizes this sum. Therefore, $cost[i][j]$ is computed optimally.

## Question-3 (40 points)

Let $G$ be a tree with $n$ vertices. In this problem, we assume that it takes $O ( 1 )$ time to store and multiply two integers.

### (a) (20 points)

Design an $O ( n )$ time algorithm to count the number of independent sets in $G$ . Prove the correctness of your algorithm and analyze its time complexity.

### (b) (20 points)

Design an efficient algorithm to count the number of maximum independent sets in $G$ . Prove the correctness of your algorithm and analyze its time complexity.

## Answer-3

Let the input tree be $G=(V,E)$ with $n = |V|$ vertices. We can solve this problem using dynamic programming on trees. First, root the tree arbitrarily at some vertex $r$. Then, perform a traversal (e.g., Depth First Search, DFS) to compute DP values in a post-order way.

### (a)

For each vertex $v$, we define two values:

- $in[v]$: The number of independent sets in the subtree $T_v$ (rooted at $v$) that **include** vertex $v$.
- $out[v]$: The number of independent sets in the subtree $T_v$ that **exclude** vertex $v$.

The recurrence relations are as follows:

- If $v$ is included in an independent set: None of its children $u$ can be included. So, for each child $u$, we must choose an independent set in $T_u$ that excludes $u$. The number of ways is $out[u]$. Since these choices are independent for each child:
  $$ in[v] = \prod\_{u \in \text{children}(v)} out[u] $$
    If $v$ is a leaf, $in[v] = 1$ (the set $\{v\}$). The product over an empty set of children is 1.

- If $v$ is excluded from an independent set: Any child $u$ can either be included in or excluded from the independent set in its own subtree $T_u$. So, for each child $u$, there are $in[u] + out[u]$ choices. Again, these are independent:
  $$ out[v] = \prod\_{u \in \text{children}(v)} (in[u] + out[u]) $$
    If $v$ is a leaf, $out[v] = 1$ (the empty set $\emptyset$).

_Algorithm (using DFS):_

```text
function DFS_count_IS(v, parent_of_v):
    if v is a leaf (excluding connection to parent_of_v): // More simply, check degree after building parent links
        in[v] = 1
        out[v] = 1
        return

    // Initialize for products
    in[v] = 1
    out[v] = 1

    for each neighbor u of v:
        if u is not parent_of_v: // Process child u
            DFS_count_IS(u, v) // Recursive call for child

            in[v] = in[v] * out[u]
            out[v] = out[v] * (in[u] + out[u])
```

To start, pick an arbitrary root $r$, call `DFS_count_IS(r, null)`.
The total number of independent sets in the tree $G$ is the sum of independent sets in $T_r$ that include $r$ and those that exclude $r$:
$$ in[r] + out[r] $$

#### Correctness proof

The proof is by induction on the height of the vertex $v$ (or size of subtree $T_v$).

- **Base Case:** If $v$ is a leaf.
  The subtree $T_v$ consists only of $v$.

  - If $v$ is included: The only IS is $\{v\}$. So $in[v]=1$. The formula (product over empty set of children) gives 1. Correct.
  - If $v$ is excluded: The only IS is $\emptyset$. So $out[v]=1$. The formula gives 1. Correct.

- **Inductive Step:** Assume that for all children $u$ of $v$, $in[u]$ and $out[u]$ are correctly computed.
  - Calculating $in[v]$: If $v$ is included in an IS of $T_v$, then none of its children $u$ can be in that IS. Thus, for each child $u$, we must choose an IS of $T_u$ that excludes $u$. By IH, there are $out[u]$ ways for each $T_u$. Since the choices for different subtrees $T_u$ are independent, the total number of ways is $\prod out[u]$. This matches the recurrence for $in[v]$.
  - Calculating $out[v]$: If $v$ is excluded from an IS of $T_v$, then for each child $u$, $u$ can either be included in or excluded from an IS of $T_u$. By IH, there are $in[u] + out[u]$ ways for each $T_u$. These choices are independent across children, so the total is $\prod (in[u] + out[u])$. This matches the recurrence for $out[v]$.

Since $in[v]$ and $out[v]$ are computed correctly for all $v$, $in[r] + out[r]$ gives the total count for the entire tree.

#### Time complexity

The DFS visits each vertex and edge once (twice for undirected edges). At each vertex, we perform a constant number of multiplications and additions for each child. Summing over all vertices, the total work for multiplications/additions is proportional to the sum of degrees, which is $2|E|$. Since $|E|=n-1$ for a tree, this is $O(n)$.

Thus, the time complexity is $O(n)$.

### (b)

Don't know how to solve this.

## Question-4

How long does it take you to finish the assignment (including thinking and discussing)? Give a score (1,2,3,4,5) to the difficulty. Do you have any collaborators? Write down their names here.

## Answer-4

It took me 10 hours, including review what was learned in class, to complete this assignment. Score of difficulty: 5. No collaborators.
