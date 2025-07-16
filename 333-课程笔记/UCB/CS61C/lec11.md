## Agenda

- Intro
  - Binary Prefixes
  - Memory Hierarchy
- Intro to Caches
- Fully Associative (FA) Caches
- Matrix Multiply Example
- Eviction Policy
- Write-Back / Write-Through Caches
- Analyzing Caches

## Intro

### Binary Prefixes

在计算机科学中，存储容量的单位常常会引起混淆。传统的SI（国际单位制）前缀如Kilo (K), Mega (M), Giga (G) 是基于10的幂次的。

- $1 \text{ Kilobyte (KB)} = 10^3 = 1,000$ 字节
- $1 \text{ Megabyte (MB)} = 10^6 = 1,000,000$ 字节

然而，在计算机的实际应用中，我们通常使用2的幂次来计量，例如 $2^{10} = 1024$。这导致了SI单位和实际二进制单位之间的差异。硬盘制造商和电信行业通常使用SI单位，这就是为什么一个标称1TB的硬盘在操作系统中显示的容量会小一些。

为了解决这个混淆，国际电工委员会（IEC）引入了一套新的二进制前缀 ：

| 二进制前缀 | 缩写 | 因子     |
| :--------- | :--- | :------- |
| kibi       | Ki   | $2^{10}$ |
| mebi       | Mi   | $2^{20}$ |
| gibi       | Gi   | $2^{30}$ |
| tebi       | Ti   | $2^{40}$ |
| pebi       | Pi   | $2^{50}$ |
| exbi       | Ei   | $2^{60}$ |
| zebi       | Zi   | $2^{70}$ |
| yobi       | Yi   | $2^{80}$ |

现在，SI前缀应严格用于10的幂次，而IEC前缀用于2的幂次。

为了方便计算，我们需要记住 $2^{10}$ 到 $2^{80}$ 对应的IEC前缀，以及 $2^0$ 到 $2^9$ 的具体数值。例如，$2^{XY}$ 可以近似看作 $2^Y \times (\text{对应X的IEC前缀})$。比如 $2^{34}$ 就是 $2^4 \times 2^{30} = 16 \text{ gibi}$。

### Memory Hierarchy

本课程的核心之一是优化计算机硬件性能。今天我们关注内存访问的优化。

**硬件设计面临的挑战** ：

- **并行性**: 硬件中所有操作（如电信号传输）都是同时发生的。
- **误差范围**: 制造差异导致元器件行为有别，设计必须容错。
- **固定性**: 硬件一旦制成便无法轻易修改，必须足够通用。
- **物理限制**: 存在各种物理极限。

一个关键的挑战是**处理器速度与内存访问时间的差距**。根据摩尔定律，技术呈指数级提升，但不同组件的提升速度不同。CPU性能每年增长约55%，而DRAM内存性能每年仅增长7%。这导致了巨大的性能鸿沟：在1980年，CPU执行一条指令的时间约等于一次DRAM访问时间；而到了2020年，CPU在一次DRAM访问的时间内可以执行约1000条指令。缓慢的内存访问已成为性能瓶颈。

**存储层次结构**
为了应对这个问题，计算机系统设计了存储层次结构。我们可以用一个**图书馆的比喻**来理解 ：

- **CPU** 是你的**书桌**，你只能在这里完成工作。
- **主存 (DRAM)** 是**校园图书馆**，包含了你需要的所有信息。
- **磁盘 (Disk)** 是**洛杉矶的图书馆**。

访问图书馆（主存）很慢，因为需要查找和往返时间。图书馆越大，速度越慢。同理，存储器容量越大，访问速度越慢。

不同类型的存储器特性如下：

- **主存 (DRAM)**: 访问延迟约10ns，价格约$3/GiB。数据是易失的（断电即失），且需要动态刷新。
- **缓存 (SRAM)**: 静态（无需刷新），速度更快（约0.5ns），但更贵，密度更低。
- **磁盘/固态硬盘 (SSD/HDD)**: 非易失性存储。SSD访问约40-100μs，HDD则需要5-10ms，速度慢得多。

这个层次结构由不同层级的软件和硬件管理 ：

- **寄存器 vs 内存**: 由编译器管理。
- **缓存 vs 主存**: 由缓存控制器硬件管理。
- **主存 vs 磁盘**: 由操作系统（虚拟内存）和硬件（TLB）共同管理。

## Intro to Caches

为了解决CPU与主存的速度差异，一种方法是Hyperthreading，也就是在等待内存返回数据的时候，切换上下文线运行其它程序，在Intel中这个技术叫做hyperthreading。但是这个需要专门的硬件来加速，而且发生在OS层面，不会加速单独的某个任务。

另一种方法是Prefetching，这种方法不在本课程讨论范围内，简单说它是基于软件实现的，比较灵活但是受限。

第三种方法就是Caching了。

我们引入了**缓存 (Cache)**。缓存是一个位于CPU和主存之间，更小、更快的存储层，通常与CPU集成在同一芯片上。它保存了主存中数据的一个子集副本。一般我们用`$`这个符号来代表缓存。

> The cache is a copy of a subset of main memory.

L1缓存通常集成在CPU缓存上:

- 分为L1i(instruction)和L1d(data)
- IMEM和DMEM are the two caches on the **CPU datapath** (后面还有更多介绍)

L2缓存位于integrated circuit上，通常adjacent to CPU

### Locality

缓存之所以有效，是利用了程序的**局部性原理 (Locality)** ：

- **时间局部性 (Temporal Locality)**: 如果一个数据项被访问，那么它在不久的将来很可能被再次访问。例如，在循环中反复使用同一个变量。
- **空间局部性 (Spatial Locality)**: 如果一个内存位置被引用，那么它附近的内存位置也很可能在不久后被引用。例如，顺序访问数组元素。

### Blocks

为了利用空间局部性，缓存不是一次只取一个字，而是以**块 (Block)** 为单位进行数据传输。内存被划分为固定大小的块（大小为2的幂次）。一个内存地址可以被分解为两部分：

- **标签 (Tag)**: 标识是哪个内存块。
- **偏移 (Offset)**: 标识数据在块内的具体位置。

例如，对于大小为 $4096 (2^{12})$ 字节的块：

- Block 0 对应`0x0000 0000` to `0x0000 0FFF`
- Block 1 对应`0x0000 1000` to `0x0000 1FFF`
- Block `0xABCDE` 对应 `0xABCD E000` to `0xABCD EFFF`

地址`0xDEADBEEF`的块标签是`0xDEADB`，块内偏移是`0xEEF`。

### Memory Hierarchy Basis - 总结

- Caches are an intermediate memory level between fastest and most expensive memory (registers) and the slower components (DRAM)
  - DRAM can be considered a "cache" for disk in a way
- Cache contains copies of data in memory that are being used.
- Memory contains copies of data on disk that are being used.
- Caches work on the principles of temporal and spatial locality.
  - Temporal locality (locality in time): If we use it now, chances re we'll want to use it again soon.
  - Spatial locality (locality in space): If we use a piece of memory, chances are we'll use the neighboring pieces soon.

### Hierarchy

根据上面的总结，我们可以看出来计算机的存储结构

- registers << memory
  - By compiler or assembly level programmer
- cache << main memory
  - By the cache controller hardware
- main memory << disks (secondary storage)
  - By the OS (virtual memory)
  - Virtual to physical address mapping assisted by the hardware ('translation lookaside buffer' or TLB)
  - By the programmer (files)

## Fully Associative (FA) Caches

全相联缓存是最灵活的一种缓存结构。它的特点是，**任何一个内存块都可以被存放到缓存中的任何一个位置**。

当出现memory access的**工作流程**：

1.  **检查缓存**: 当需要访问内存时，首先检查所需数据块是否已在缓存中。如果存在直接返回
2.  **缓存命中 (Cache Hit)**: 如果数据块在缓存中，并且其**有效位 (Valid Bit)**为1，则为命中。直接从缓存中读取数据。有效位用于区分缓存中的有效数据和初始的无效（垃圾）数据。
3.  **缓存未命中 (Cache Miss)**: 如果数据不在缓存中或有效位为0，则为未命中。此时需要从主存中加载整个数据块到缓存的一个空闲位置。
4.  **驱逐 (Eviction)**: 如果缓存已满，需要根据**驱逐策略**选择一个现有的块替换掉，为新块腾出空间。我们后面会讨论具体的eviction policy

我们通过下面这个例子来展示一下具体流程，这里假设

a cache with 4 byte blocks and 4 blocks storage, and let's assume that we're working with a system that uses 10-bit addresses

> 注意：之所以说10-bit addr，是因为每个block存储4 byte的数据，也就是需要2-bit来作为offset。那么还有8-bit就是tag了

| Tag           | Valid | Data                  |
| ------------- | ----- | --------------------- |
| `0b1001 1001` | 0     | `0xDE 0xAD 0xBE 0xEF` |
| `0b1011 0011` | 0     | `0x01 0x23 0x45 0x67` |
| `0b0110 1011` | 1     | `0xAB 0xAD 0xCA 0xFE` |
| `0b1111 0000` | 1     | `0xAC 0xDE 0xFF 0x61` |

想要访问`0x3C1`，流程是：

- `0x3C1 == 0b11 1100 0001`，根据tag-offset，应该看作`0b1111 0000 01`
- 发现tag部分`0b1111 0000`缓存命中，并且对应的valid-bit是1，也就是有效，因此根据offset计算出是Data中的1st byte，也就是`0xDE`

想要访问`0x266`，流程是：

- `0x266 == 0b10 0110 0110 == 0b1001 1001 10`
- tag有对应的缓存，但是valid-bit是0，所以数据不在缓存中
- 需要从内存中重新获取数据

**术语**：

- **冷缓存 (Cold Cache)**: 缓存中没有有效数据，例如刚启动或者从一次上下文切换中恢复。
- **热缓存 (Hot Cache)**: 缓存中有大量有效数据，并且命中率很高。

### Cache TIming

直接访问内存和带有缓存的访问内存相比较而言：

- 检查缓存中是否有我们需要的数据这一步会消耗一些时间
- 但是如果缓存中有我们要的数据，就能节省很多时间。The hotter the cache, the more likely we save runtime.
  而考虑到cache缓存是硬件的一部分，我们所有的程序都必须用缓存
- 也因此，如果我们的缓存效率不够高，就会导致运行速度变慢
- 假如所有的操作都是随机内存访问 random memory access，我们的速度反倒会下降。
- 我们利用缓存效率提升的原因是因为我们不总是在随机内存访问

在实际过程中，缓存命中大概是10 cycles，如果缓存未命中则需要100-1000 cycles。

### Matrix Multiply Example

这里我们用矩阵乘法作为例子，给定两个矩阵A和B，计算矩阵C。

假设：

- Elements are 4 bytes，But only the bottom byte will be shown in the cache for space
- Block size is 16 bytes (one row of this matrix)
- Matrix A stored at 0x1000
- Matrix B stored at 0x2000
- Matrix C stored at 0x3000
- No other memory used

$$
A=\begin{bmatrix}
1 & 2 & 3 & 4 \\
5 & 6 & 7 & 8 \\
9 & 10 & 11 & 12 \\
13 & 14 & 15 & 16
\end{bmatrix}
,B=\begin{bmatrix}
17 & 18 & 19 & 20 \\
21 & 22 & 23 & 24 \\
25 & 26 & 27 & 28 \\
29 & 30 & 31 & 32
\end{bmatrix}
$$

#### Step 0 - 缓存冷启动

最一开始缓存的数据是随机的，并且所有valid-bit 都是0，例如：

| Tag     | Valid | Data                  |
| ------- | ----- | --------------------- |
| `0x100` | 0     | `0xBF 0x16 0x88 0x2B` |
| `0x733` | 0     | `0x3B 0x18 0xF1 0xB3` |
| `0x156` | 0     | `0xE6 0x57 0x49 0xEE` |
| `0x4E9` | 0     | `0xB5 0x81 0x67 0x3F` |

0 Misses / 0 Hits

#### Step 1 - Access `A[0]`

按照前面的假设，`A[0]=0x100`，缓存未命中，从内存加载数据，最终缓存结构：

| Tag     | Valid | Data                  |
| ------- | ----- | --------------------- |
| `0x100` | 1     | `0x01 0x02 0x03 0x04` |
| `0x733` | 0     | `0x3B 0x18 0xF1 0xB3` |
| `0x156` | 0     | `0xE6 0x57 0x49 0xEE` |
| `0x4E9` | 0     | `0xB5 0x81 0x67 0x3F` |

1 Misses / 0 Hits

#### Step 2 - Access `B[0]`

按照前面的假设，`B[0]=0x200`，缓存未命中，从内存加载数据，最终缓存结构：

| Tag     | Valid | Data                  |
| ------- | ----- | --------------------- |
| `0x100` | 1     | `0x01 0x02 0x03 0x04` |
| `0x200` | 1     | `0x11 0x12 0x13 0x14` |
| `0x156` | 0     | `0xE6 0x57 0x49 0xEE` |
| `0x4E9` | 0     | `0xB5 0x81 0x67 0x3F` |

2 Misses / 0 Hits

#### Step 3 - Access `A[1]` and `B[4]`

> 注意行列对应的内存数组下标关系，B要访问第二行第一个元素，也就是数组第5个元素，下标为4

访问`A[1]=0x1004` Hit 直接返回`0x02`

访问`B[4]=0x2010` Miss

| Tag     | Valid | Data                  |
| ------- | ----- | --------------------- |
| `0x100` | 1     | `0x01 0x02 0x03 0x04` |
| `0x200` | 1     | `0x11 0x12 0x13 0x14` |
| `0x201` | 1     | `0x15 0x16 0x17 0x18` |
| `0x4E9` | 0     | `0xB5 0x81 0x67 0x3F` |

3 Misses / 1 Hit

#### Step 4 - Access `A[2]` and `B[8]`

访问`A[2]=0x1008` Hit 直接返回`0x03`

访问`B[8]=0x2020` Miss

| Tag     | Valid | Data                  |
| ------- | ----- | --------------------- |
| `0x100` | 1     | `0x01 0x02 0x03 0x04` |
| `0x200` | 1     | `0x11 0x12 0x13 0x14` |
| `0x201` | 1     | `0x15 0x16 0x17 0x18` |
| `0x202` | 1     | `0x19 0x1A 0x1B 0x1C` |

4 Misses / 2 Hits

#### Step 5 - Access `A[3]` and `B[12]`

访问`A[3]=0x100C` Hit 直接返回`0x04`

访问`B[12]=0x2030` Miss

但这个时候的问题出现了，缓存已经满了，我们该evict哪一个block来为新的数据提供空间呢？这就需要eviction policy缓存策略了。

## Eviction Policy

### Common Eviction Policies

当缓存已满时，必须选择一个块来驱逐。理想的策略是驱逐最不可能被再次使用的数据。常见策略有：

- **LRU (Least Recently Used)**: 驱逐最久未被使用的块。这个策略利用了时间局部性，效果很好，但硬件实现复杂。
- **MRU (Most Recently Used)**: 驱逐最近被使用的块。
- **FIFO (First-In, First-Out)**: 驱逐最早进入缓存的块。
- **LIFO (Last-In, First-Out)**: 驱逐最新进入缓存的块。
  - FIFO和LIFO策略虽然都忽略了部分访问历史信息（FIFO忽略首次访问后的访问顺序，LIFO忽略末次访问前的访问顺序），但它们能够在硬件开销较小的前提下，有效近似LRU和MRU策略的性能。
- **Random**: 随机选择一个块进行驱逐。实现简单，性能尚可。

假设采用LRU缓存策略，让我们继续刚刚的矩阵乘法的例子：

### Matrix Multiply Example with LRU

#### Step 0 - 缓存冷启动

最一开始缓存的数据是随机的，并且所有valid-bit 都是0。这里和之前都一样，但是我们添加新的一列LRU来记录which block accessed first，lower number = more recent for today，例如：

| Tag     | Valid | LRU | Data                  |
| ------- | ----- | --- | --------------------- |
| `0x100` | 0     | 0   | `0xBF 0x16 0x88 0x2B` |
| `0x733` | 0     | 0   | `0x3B 0x18 0xF1 0xB3` |
| `0x156` | 0     | 0   | `0xE6 0x57 0x49 0xEE` |
| `0x4E9` | 0     | 0   | `0xB5 0x81 0x67 0x3F` |

#### Step 1 - Access `A[0]`

按照前面的假设，`A[0]=0x100`，缓存未命中，从内存加载数据，最终缓存结构：

| Tag     | Valid | LRU | Data                  |
| ------- | ----- | --- | --------------------- |
| `0x100` | 1     | 1   | `0x01 0x02 0x03 0x04` |
| `0x733` | 0     | 0   | `0x3B 0x18 0xF1 0xB3` |
| `0x156` | 0     | 0   | `0xE6 0x57 0x49 0xEE` |
| `0x4E9` | 0     | 0   | `0xB5 0x81 0x67 0x3F` |

1 Misses / 0 Hits

#### Step 2 - Access `B[0]`

按照前面的假设，`B[0]=0x200`，缓存未命中，从内存加载数据，最终缓存结构：

| Tag     | Valid | LRU | Data                  |
| ------- | ----- | --- | --------------------- |
| `0x100` | 1     | 2   | `0x01 0x02 0x03 0x04` |
| `0x200` | 1     | 1   | `0x11 0x12 0x13 0x14` |
| `0x156` | 0     | 0   | `0xE6 0x57 0x49 0xEE` |
| `0x4E9` | 0     | 0   | `0xB5 0x81 0x67 0x3F` |

2 Misses / 0 Hits

#### Step 3 - Access `A[1]` and `B[4]`

访问`A[1]=0x1004` Hit 直接返回`0x02`

访问`B[4]=0x2010` Miss

| Tag     | Valid | LRU | Data                  |
| ------- | ----- | --- | --------------------- |
| `0x100` | 1     | 2   | `0x01 0x02 0x03 0x04` |
| `0x200` | 1     | 3   | `0x11 0x12 0x13 0x14` |
| `0x201` | 1     | 1   | `0x15 0x16 0x17 0x18` |
| `0x4E9` | 0     | 0   | `0xB5 0x81 0x67 0x3F` |

3 Misses / 1 Hit

#### Step 4 - Access `A[2]` and `B[8]` and `A[3]`

访问`A[2]=0x1008` Hit 直接返回`0x03`

访问`B[8]=0x2020` Miss

访问`A[3]=0x100C` Hit 直接返回`0x04`

| Tag     | Valid | LRU | Data                  |
| ------- | ----- | --- | --------------------- |
| `0x100` | 1     | 2   | `0x01 0x02 0x03 0x04` |
| `0x200` | 1     | 4   | `0x11 0x12 0x13 0x14` |
| `0x201` | 1     | 3   | `0x15 0x16 0x17 0x18` |
| `0x202` | 1     | 1   | `0x19 0x1A 0x1B 0x1C` |

4 Misses / 2 Hits

#### Step 5 - Access `B[12]`

访问`B[12]=0x2030` Miss

但这个时候的问题出现了，缓存已经满了，我们该evict哪一个block来为新的数据提供空间呢？

LRU evict the least recently used block, 也就是这里的`0x200`

| Tag     | Valid | LRU | Data                  |
| ------- | ----- | --- | --------------------- |
| `0x100` | 1     | 3   | `0x01 0x02 0x03 0x04` |
| `0x203` | 1     | 1   | `0x1D 0x1E 0x1F 0x20` |
| `0x201` | 1     | 4   | `0x15 0x16 0x17 0x18` |
| `0x202` | 1     | 2   | `0x19 0x1A 0x1B 0x1C` |

注意到我们现在已经有很多miss，特别是这一步evict 0x200里面还包含像`0x2004`这样的没有使用的数据，继续进行下去，最终会产生60 bits and 68 misses。这个问题可以通过在运行乘法代码前先将B转置来解决

下一步我们该写入`C[0] = 0x3000`了，仍然Miss，从内存读取。问题是如何在我们写入数据的时候，因为缓存是最快的，所以写入会把数据直接写到缓存中，这个时候缓存和主存的数据就不一致了。那么我们如何保持缓存和主存的一致呢？

## Write-Back / Write-Through Caches

### Write Policy

- Write-through 写直通
  - When a write occurs, update the data both in the cache and in main memory
  - Slows down writes a lot, since we need to write to main memory every time
- Write-back 写回
  - When a write occurs, only update the data in the cache
  - Purposefully let main memory go "stale", and rely on the caches as the main source of truth
  - When we later evict the block, write all changes to main memory at the same time
  - Needs a "dirty" bit to signify that the block has to be written to memory
  - Also means we need to be careful that we don't access main memory before we write back our data 后续lec12有更多相关内容
  - Much faster than write-through, and also extends computer lifespan, since RAM tends to degrade with each write.

下面让我们利用write-back cache再次模拟矩阵乘法，这一次我们还转置了矩阵B：

### Matrix Multiply Example with Write-Back

$$
A=\begin{bmatrix}
1 & 2 & 3 & 4 \\
5 & 6 & 7 & 8 \\
9 & 10 & 11 & 12 \\
13 & 14 & 15 & 16
\end{bmatrix}
,B^T=\begin{bmatrix}
17 & 21 & 25 & 29 \\
18 & 22 & 26 & 30 \\
19 & 23 & 27 & 31 \\
20 & 24 & 28 & 32
\end{bmatrix}
$$

#### Step 0 - 缓存冷启动

请注意，这里多了一个Dirty字段

| Tag     | Valid | Dirty | LRU | Data                  |
| ------- | ----- | ----- | --- | --------------------- |
| `0x100` | 0     | 0     | 0   | `0xBF 0x16 0x88 0x2B` |
| `0x733` | 0     | 0     | 0   | `0x3B 0x18 0xF1 0xB3` |
| `0x156` | 0     | 0     | 0   | `0xE6 0x57 0x49 0xEE` |
| `0x4E9` | 0     | 0     | 0   | `0xB5 0x81 0x67 0x3F` |

0 Misses / 0 Hits

#### Step 1 - `A[0]` and `Bt[0]`

| Tag     | Valid | Dirty | LRU | Data                  |
| ------- | ----- | ----- | --- | --------------------- |
| `0x100` | 1     | 0     | 2   | `0x01 0x02 0x03 0x04` |
| `0x200` | 1     | 0     | 1   | `0x11 0x15 0x19 0x1D` |
| `0x156` | 0     | 0     | 0   | `0xE6 0x57 0x49 0xEE` |
| `0x4E9` | 0     | 0     | 0   | `0xB5 0x81 0x67 0x3F` |

2 Misses / 0 Hits

#### Step 2 `A/Bt[1-3]`

因为我们对B进行了转置，因此命中率提高了很多

| Tag     | Valid | Dirty | LRU | Data                  |
| ------- | ----- | ----- | --- | --------------------- |
| `0x100` | 1     | 0     | 2   | `0x01 0x02 0x03 0x04` |
| `0x200` | 1     | 0     | 1   | `0x11 0x15 0x19 0x1D` |
| `0x156` | 0     | 0     | 0   | `0xE6 0x57 0x49 0xEE` |
| `0x4E9` | 0     | 0     | 0   | `0xB5 0x81 0x67 0x3F` |

2 Misses / 6 Hits

#### Step 3- Write to `C[0]`

其中`C[0]`的内存地址是`0x3000`，计算结果是`0xFA`。这一次缓存未命中，我们执行write-back策略，记得要设置Dirty bit

| Tag     | Valid | Dirty | LRU | Data                  |
| ------- | ----- | ----- | --- | --------------------- |
| `0x100` | 1     | 0     | 3   | `0x01 0x02 0x03 0x04` |
| `0x200` | 1     | 0     | 2   | `0x11 0x15 0x19 0x1D` |
| `0x300` | 1     | 1     | 1   | `0xFA 0x?? 0x?? 0x??` |
| `0x4E9` | 0     | 0     | 0   | `0xB5 0x81 0x67 0x3F` |

3 Misses / 6 Hits

#### Step 4 - Calc and Write `C[1]`

1. `A[0]` Hit
2. `Bt[4]` Miss
3. `A[1]` Hit
4. `Bt[5]` Hit
5. `A[2]` Hit
6. `Bt[6]` Hit
7. `A[3]` Hit
8. `Bt[7]` Hit
9. **Write `C[1]` Hit**

这一个step是8 Hits以及1Miss

| Tag     | Valid | Dirty | LRU | Data                  |
| ------- | ----- | ----- | --- | --------------------- |
| `0x100` | 1     | 0     | 3   | `0x01 0x02 0x03 0x04` |
| `0x200` | 1     | 0     | 4   | `0x11 0x15 0x19 0x1D` |
| `0x300` | 1     | 1     | 1   | `0xFA 0x04 0x?? 0x??` |
| `0x201` | 1     | 0     | 2   | `0x12 0x16 0x1A 0x1E` |

4 Misses / 14 Hits

#### Step 5 - Calc and Write `C[2]`

1. `A[0]` Hit
2. `Bt[8]` Miss, **Evict block `0x200`**
3. `A[1]` Hit
4. `Bt[9]` Hit
5. `A[2]` Hit
6. `Bt[10]` Hit
7. `A[3]` Hit
8. `Bt[11]` Hit
9. **Write `C[2]` Hit**

这一个step是8 Hits以及1Miss

| Tag     | Valid | Dirty | LRU | Data                  |
| ------- | ----- | ----- | --- | --------------------- |
| `0x100` | 1     | 0     | 3   | `0x01 0x02 0x03 0x04` |
| `0x202` | 1     | 0     | 2   | `0x13 0x17 0x1B 0x1F` |
| `0x300` | 1     | 1     | 1   | `0xFA 0x04 0x0E 0x??` |
| `0x201` | 1     | 0     | 4   | `0x12 0x16 0x1A 0x1E` |

4 Misses / 14 Hits

## Analyzing Caches

- The **hit rate** of a cache is the percentage of accesses that result in a hit
- The **miss rate** of a cache is the percentage of accesses that result in a miss
- **Hit time** is how long it takes to check the cache. The **Miss Penalty** is how long it takes to access main memory after a miss.
  - If we get a cache hit, runtime is equal to hit time
  - If we get a cache miss, runtime is equal to **hit time + miss penalty**
  - If we didn't have a cache, we'd always take miss penalty time to access main memory
- Analogy: Hit time = how long to check the bookshelf, Miss penalty = how long to go to the library
- In the previous example, our hit rate was ⅚ = 83.33%, so our miss rate was ⅙ = 16.66%
- The **Average Memory Access Time (or AMAT)** is the average amount of time it takes for one memory access, given a hit rate.

AMAT的计算公式为：
$$AMAT = \text{Hit Time} + (\text{Miss Rate} \times \text{Miss Penalty})$$
**示例计算**:
假设命中时间为10个周期，未命中惩罚为100个周期。

- **命中率**: $5/6$ (即 $83.3\%$ )
- **未命中率**: $1/6$
- **AMAT**: $10 + (\frac{1}{6} \times 100) \approx 10 + 16.67 = 26.67$ 个周期。
- **无缓存时的访问时间**: 100个周期（直接访问主存）。
- **加速比 (Speedup)**: $\frac{\text{无缓存时间}}{\text{AMAT}} = \frac{100}{26.67} \approx 3.75x$。

这表明，一个高命中率的缓存能显著提升系统性能。

我个人感觉可以把Miss看作Hit主存，这样AMAT的计算公式就是$\Sigma \text{HitRate} \times \text{HitTime}$
