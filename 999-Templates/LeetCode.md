---
id: 1
title: Two Sum
link: https://leetcode.com/problems/two-sum/
difficulty: Easy
mastered: false
tags:
  - array
  - hash-table
review_dates:
  - 2025-10-17
  - 2025-10-24
---

## 题目描述 (Problem Description)

在这里简述题目要求，或者直接拷贝题目原文。

**示例:**
**输入:** nums = [2,7,11,15], target = 9
**输出:** [0,1]
**解释:** 因为 nums[0] + nums[1] == 9 ，返回 [0, 1] 。

## 首次尝试思路 (My Initial Attempts)

### 第一次尝试 (Attempt 1)

- **我的思路:**
  - 先对数组排序。
  - 然后使用两个指针，一个从头开始（left），一个从尾开始（right）。
  - 计算 `nums[left] + nums[right]` 的和。
  - 如果和小于 target，`left++`。
  - 如果和大于 target，`right--`。
  - 如果和等于 target，就找到了。

- **结果:** 错误 (Wrong Answer)

- **反思与失败原因:**
  - 我完全忽略了题目要求返回的是**原始索引**！排序后，原始的索引信息就丢失了。
  - 这个思路适用于 "Two Sum II - Input array is sorted"，但不适用于这道题。这是一个典型的审题错误。

### 第二次尝试 (Attempt 2)

- **我的思路:**
  - 不排序了，直接用两层 for 循环暴力枚举所有可能的配对。

- **结果:** 通过 (Accepted)，但效率很低。

- **反思与失败原因:**
  - 虽然做出来了，但时间复杂度是 $O(N^2)$。看了一下数据范围，如果 N 很大，这种方法肯定会超时（TLE）。我需要想办法优化查找过程。

## 最优解法分析 (Analysis of Optimal Solution)

- **核心思路 (Hash Table):**
  1.  创建一个哈希表（字典），用来存放 `数值 -> 索引` 的映射。
  2.  遍历数组，对于每个数 `num`，计算它需要的“另一半” `complement = target - num`。
  3.  **先在哈希表中查找 `complement` 是否存在**。
  4.  如果存在，说明找到了，直接返回哈希表中存的索引和当前 `num` 的索引。
  5.  如果不存在，就把当前的 `num` 和它的索引存入哈希表，供后面的元素查找。

- **思路对比 (Comparison with My Attempts):**
  - 我的暴力法慢就慢在“查找另一半”的过程，它需要 $O(N)$ 的时间。
  - 最优解通过哈希表这个数据结构，将“查找另一半”的时间复杂度从 $O(N)$ 革命性地降低到了 $O(1)$。
  - 这是典型的“空间换时间”思想，用一个哈希表的额外空间，换取了巨大的时间效率提升。

- **复杂度分析:**
  - 时间复杂度: $O(N)$
  - 空间复杂度: $O(N)$

## 代码实现 (Implementation)

### Python

```python
def twoSum(self, nums: List[int], target: int) -> List[int]:
    hashmap = {} # val -> index
    for i, n in enumerate(nums):
        diff = target - n
        if diff in hashmap:
            return [hashmap[diff], i]
        hashmap[n] = i
    return
```

### C++

```cpp
#include <vector>
#include <unordered_map>

class Solution {
public:
    std::vector<int> twoSum(std::vector<int>& nums, int target) {
        std::unordered_map<int, int> hashmap; // val -> index
        for (int i = 0; i < nums.size(); ++i) {
            int complement = target - nums[i];
            if (hashmap.count(complement)) {
                return {hashmap[complement], i};
            }
            hashmap[nums[i]] = i;
        }
        return {};
    }
};
```

## 核心要点与易错点 (Key Takeaways & Pitfalls)

- **核心思想:** 利用哈希表近 $O(1)$ 的查找效率，将寻找 `target - x` 的过程从 $O(N)$ 降至 $O(1)$。
- **易错点:**
  1. 注意返回的是**索引**而不是**数值**。
  2. 哈希表中应该存储 `数值 -> 索引` 的映射关系。
  3. 在遍历时，应该是先查找哈希表中是否有匹配的补数，再将当前元素存入。如果顺序反了，对于 `[3, 3]` `target=6` 这样的用例会出错。

## 关联与延申 (Connections & Extensions)

- **题型模板:** 这是典型的 **哈希表查找** 题型，适用于需要快速查找某个元素是否存在或其相关信息的场景。
- **相关题目:**
  - [[15. 3Sum]]
  - [[18. 4Sum]]
  - [[167. Two Sum II - Input array is sorted]] (如果数组有序，可以用双指针法)

## 复盘记录 (Review Log)

### 复盘 1 (2025-10-24)

- **复习情况:** 看到题目后能立刻想到哈希表的思路，但编码时犹豫了一下是先存还是先查。
- **遇到的问题:** 忘记了“先查后放”的细节，在脑海里模拟 `[3,3]` 的例子后才想起来。
- **状态更新:** `status` 保持 `solved`，还没到 `mastered` 的程度。

### 复盘 2 (2025-11-07)

- **复习情况:** 5分钟内独立、无误地写出了哈希表解法。
- **新的领悟:** 可以向面试官解释为什么哈希表是优于排序双指针的解法（因为保留了原始索引）。
- **状态更新:** `status` 修改为 `mastered`。
