# Lecture 2: 图像分类与线性分类器 (Image Classification with Linear Classifiers)

> (Slide 1)

本节课主题是**图像分类**，重点介绍**线性分类器**这种方法，并与 K-最近邻方法进行对比。

**本讲主要内容 (Today):**

> (Slide 6)

- 图像分类任务 (The image classification task)
- 两种基础的数据驱动图像分类方法 (Two basic data-driven approaches to image classification)
  - K-最近邻 (K-nearest neighbor, KNN)
  - 线性分类器 (Linear classifier)

## 图像分类：计算机视觉的核心任务

> (Slides 6-19)

图像分类是计算机视觉中的一个核心任务。

**目标：** 给定一张输入的图片，从一个预先给定的标签集合（例如：{狗、猫、卡车、飞机,...}）中，选出最合适的标签。

**核心挑战：语义鸿沟 (Semantic Gap)**

> (Slide 8)

我们人类能自然地理解图像的**语义**（这是一只猫），但计算机看到的是表示像素值的**数字矩阵**（例如，一个 800x600 的彩色图像是一个 $800 \times 600 \times 3$ 的 0-255 整数张量）。

> **语义鸿沟**指的就是：人类理解的、富有意义的**语义**和计算机看到的、冰冷的**像素值**之间存在的巨大差距。如何跨越这个鸿沟，让计算机理解像素背后的含义，是图像分类乃至整个计算机视觉的关键难题。

**图像分类面临的具体挑战：**

> (Slides 9-15)

仅仅比较像素值来进行分类是非常困难的，因为存在各种变化：

- **视角变化 (Viewpoint variation):** 同一个物体，从不同角度拍摄，像素值会发生巨大变化。
- **光照条件 (Illumination):** 光线的强弱、方向会显著影响图像的像素值。
- **背景混淆 (Background Clutter):** 目标物体可能和背景很相似，或者背景非常杂乱。
- **遮挡 (Occlusion):** 目标物体可能被部分遮挡。
- **形变 (Deformation):** 同一类物体可能有不同的形态和姿态（例如猫可以蜷缩、站立）。
- **类内差异 (Intraclass variation):** 同一个类别内部也存在巨大差异（例如各种品种、颜色、大小的猫）。
- **上下文 (Context):** 有时物体的识别需要依赖其所处的环境或上下文。

**TODO：** 这一页 PPT 上有一个 IMAGENET 的插图，我觉得应该需要补充拓展 IMAGENET 相关的内容。
**补充说明：** ImageNet 是一个大规模的、人工标注的图像数据库，包含超过 1400 万张图片和超过 2 万个类别（基于 WordNet 结构）。它对推动计算机视觉研究（特别是深度学习模型的训练和基准测试）起到了至关重要的作用。一年一度的 ImageNet 大规模视觉识别挑战赛 (ILSVRC) 更是极大地促进了图像分类、目标检测等领域的发展。许多著名的深度学习架构（如 AlexNet, VGG, ResNet）都是在 ImageNet 上进行训练和验证的。(Slide 16)

**传统方法的局限性：**

> (Slides 17-18)

试图通过硬编码规则（例如，检测边缘、角点，然后组合）来编写一个通用的 `classify_image` 函数是非常困难的，因为无法穷举和描述现实世界中物体可能出现的所有视觉变化。

```python
def classify_image(image):
    # Some magic here?
    return class_label
```

**现代方法：数据驱动 (Data-Driven Approach)**

> (Slide 19)

核心思想：

1.  **收集数据集:** 收集一个包含大量带有**标签**的图像的数据集。
2.  **训练分类器:** 使用机器学习算法，让模型从数据中**学习**如何区分不同类别。
    ```python
    def train(images, labels):
        # Machine learning!
        return model
    ```
3.  **评估分类器:** 使用训练好的模型在新图像（测试集）上进行**预测**和评估。
    ```python
    def predict(model, test_images):
        # Use model to predict labels
        return test_labels
    ```

## K-最近邻分类器 (K-Nearest Neighbor Classifier)

> (Slides 20-48)

KNN 是一种简单的非参数化数据驱动方法。

**核心思想：**

- **`train` (训练):** 简单地**记住**所有训练数据（图像和标签）。时间复杂度 $O(1)$。(Slide 21)
- **`predict` (预测):** 对新的测试图片，找到训练集中**最相似**的 $K$ 张图片（邻居），然后根据这 $K$ 个邻居的标签进行**多数投票**，将得票最多的标签作为预测结果。(Slides 21, 30)

**距离度量 (Distance Metric):** 如何衡量图像间的“相似性”？

> (Slides 22-23, 31-33)

- **L1 距离 (Manhattan Distance):** 计算对应像素值之差的**绝对值和**。 $d_{1}(I_{1},I_{2})=\sum_{p}|I_{1}^{p}-I_{2}^{p}|$。(Slide 23)

  - **TODO：** 这里 PPT 上原本有一个 $4 \times 4$ 的例子来展示 L1 计算，这里需要补充一个。
    **补充 L1 计算示例 (基于 Slide 23):**
    假设有两张 2x2 的单通道图片 $I_1$ 和 $I_2$：
    $I_1 = \begin{pmatrix} 56 & 32 \\ 90 & 23 \end{pmatrix}$ ， $I_2 = \begin{pmatrix} 10 & 20 \\ 8 & 10 \end{pmatrix}$
    它们的 L1 距离计算如下：
    $d_1(I_1, I_2) = |56-10| + |32-20| + |90-8| + |23-10|$
    $= 46 + 12 + 82 + 13 = 153$

- **L2 距离 (Euclidean Distance):** 计算对应像素值之差的**平方和的平方根**。$d_{2}(I_{1},I_{2})=\sqrt{\sum_{p}(I_{1}^{p}-I_{2}^{p})^{2}}$。(Slide 31)
- L1 和 L2 对坐标轴和数值差异的敏感度不同，选择哪种会影响结果。(Slides 31-33)

**KNN Python 代码示例 (基于 L1 距离):**

> (Slides 24-26)

```python
import numpy as np

class NearestNeighbor:
    def __init__(self):
        pass

    def train(self, X, y):
        """ X is N x D where each row is an example. Y is 1-dimension of size N """
        # the nearest neighbor classifier simply remembers all the training data
        self.Xtr = X
        self.ytr = y

    def predict(self, X):
        """ X is M x D where each row is an example we wish to predict label for """
        num_test = X.shape[0]
        # lets make sure that the output type matches the input type
        Ypred = np.zeros(num_test, dtype = self.ytr.dtype)

        # loop over all test rows
        for i in range(num_test):
            # find the nearest training image to the i'th test image
            # using the L1 distance (sum of absolute value differences)
            distances = np.sum(np.abs(self.Xtr - X[i,:]), axis = 1)
            min_index = np.argmin(distances) # get the index with smallest distance
            Ypred[i] = self.ytr[min_index] # predict the label of the nearest example

        return Ypred
```

**KNN 的优缺点:**

> (Slides 27, 47)

- **优点:** 实现简单，易于理解。训练非常快 ($O(1)$)。
- **缺点:** 预测慢 ($O(N)$，需要与所有训练样本比较)。对高维数据效果差（维度灾难）。存储开销大（需要存储所有训练数据）。直接在像素上使用效果差。

**快速最近邻:** 存在如 `faiss` ([https://github.com/facebookresearch/faiss](https://github.com/facebookresearch/faiss)) 这样的库用于加速最近邻查找，但这超出了本课程范围。(Slide 28)

**TODO：** 这里幻灯片上插入了几张图片用来演示 KNN 的分类可视化结果，网址：[http://vision.stanford.edu/teaching/cs231n-demos/knn/](http://vision.stanford.edu/teaching/cs231n-demos/knn/)；我也应该需要实验然后在这里插入图片。
**补充说明：** 该在线演示 ([http://vision.stanford.edu/teaching/cs231n-demos/knn/](http://vision.stanford.edu/teaching/cs231n-demos/knn/)) 可以让你直观地看到不同 K 值和距离度量（L1/L2）对分类边界的影响。通常 K 值增大，分类边界会变得更平滑，鲁棒性更好，但可能丢失一些细节。观察这些可视化有助于理解 KNN 的工作方式。(Slide 34)

### 超参数调整 (Hyperparameter Tuning)

> (Slides 35-44)

KNN 中的 **K 值**和**距离度量** (L1/L2) 是**超参数**，需要在训练前设定。

**如何选择超参数？**

> (Slides 36-41)

- **错误方法 1:** 在**训练集**上选择。会导致过拟合（例如 K=1 时训练准确率 100%）。
- **错误方法 2:** 在**测试集**上选择。这是**绝对禁止**的！测试集只能用于最终评估模型泛化能力，不能参与模型选择或参数调整。
- **正确方法 1: 验证集 (Validation Set)**
  1.  将原始训练数据划分为**训练集**和**验证集**。
  2.  用**训练集**训练具有不同超参数的模型。
  3.  在**验证集**上评估这些模型，选择表现最好的超参数。
  4.  （可选）使用选定的超参数，在**全部**原始训练数据上重新训练最终模型。
  5.  最后，在**测试集**上评估最终模型**一次**。
- **正确方法 2: 交叉验证 (Cross-Validation)**
  - 适用于数据集较小的情况。
  - 将训练数据分成 $k$ 折。
  - 轮流使用其中一折作为验证集，其余 $k-1$ 折作为训练集，重复 $k$ 次。
  - 将 $k$ 次的验证结果平均，选择平均性能最好的超参数。
  - 计算成本较高，在深度学习中不太常用。

**TODO：** 上面的想法 1，2，3 都在原本的幻灯片上有配图，用类似进度条（覆盖不同颜色）svg 作图。
**补充说明：** 幻灯片中的图示形象地展示了数据划分：
_ 错误方法 1/2：只显示一个 Train 或 Test 数据块。
_ 正确方法（验证集）：将数据分为 Train / Validation / Test 三块。超参数调优在 Validation 块上进行。 \* 交叉验证：将 Train+Validation 数据块分成多个 Fold，轮流作为 Validation。(Slides 36-41)

**示例数据集：CIFAR-10**

> (Slides 42-43)

- 10 个类别（飞机、汽车、鸟、猫等）。
- 50,000 张训练图片，10,000 张测试图片。
- 32x32 彩色图片。
- 在 CIFAR-10 上直接用像素距离的 KNN 效果不佳。

**TODO：** 下面的实验缺少实际代码，应该在原本的 repo 中找找代码/自己重新实现。
**补充说明：** 在 CIFAR-10 上进行 5 折交叉验证选择 K 值的实验（如 Slide 44 所示）通常会生成一个图表，显示不同 K 值对应的平均验证准确率及其标准差。这需要编写代码加载数据、实现 KNN（包括距离计算、邻居查找、投票）、执行交叉验证循环并记录结果。此类代码通常是课程作业的一部分。结果会显示某个 K 值（例如幻灯片中的 K=7 附近）能达到最佳的验证准确率。(Slide 44)

**像素距离的局限性:**

> (Slides 45-47)

KNN **几乎从不**直接用于原始图像像素。因为像素距离（L1/L2）对图像内容的**感知相似性**不敏感。微小的平移、遮挡、光照或色调变化可能导致巨大的像素距离变化，或者反之，人眼看来差异巨大的图片可能有相似的像素距离。

### KNN 总结

> (Slide 48)

- 图像分类的目标是学习从图像到标签的映射。
- KNN 根据 K 个最近邻的投票进行预测。
- K 和距离度量是需要通过**验证集**选择的超参数。
- **测试集**仅用于最终评估，严禁用于调参。
- KNN **不适用于原始像素**，通常用于提取出的**特征向量**。

---

## 线性分类器 (Linear Classifier)

> (Slides 49-82)

这是构建更复杂模型（如神经网络）的基础。

**参数化方法 (Parametric Approach):**

> (Slide 50)

- 核心思想：定义一个**评分函数** $f(x, W, b)$，它接收输入 $x$（图像像素向量）和**参数** $W, b$（权重和偏置），输出每个类别的得分。
- 目标：学习到最优的参数 $W, b$，使得对于训练数据，正确类别的得分最高。

**线性评分函数:**

> (Slides 51-53)

- 最简单的评分函数： $f(x, W, b) = Wx + b$
  - $x$: 输入图像拉伸成的列向量 (例如 $D \times 1$, D=3072 for CIFAR-10)。
  - $W$: **权重矩阵** (维度 $C \times D$, C 是类别数，例如 10x3072)。
  - $b$: **偏置向量** (维度 $C \times 1$, 例如 10x1)。
- 这个线性函数通过矩阵乘法和向量加法将输入像素映射到 C 个类别的得分。

**与神经网络的关系:**

> (Slides 54-55)

线性层 ($Wx+b$) 是神经网络的基本构建块。深度网络通过堆叠多个线性层（和非线性激活函数）来学习复杂的模式。

**计算示例:**

> (Slide 58)

假设 4 像素图像 $x = [56, 231, 24, 2]^T$, 3 个类别 (猫/狗/船)，给定 $W$ (3x4) 和 $b$ (3x1)，计算 $Wx+b$ 得到每个类别的原始得分，例如 $[-96.8, 437.9, 61.95]^T$（狗得分最高）。

**理解线性分类器:**

> (Slides 59-61)

- **TODO：** 第二三种角度我还没有理解。
  - **代数角度 (Algebraic Viewpoint):** 就是 $Wx+b$ 的计算过程。(Slide 58)
  - **视觉角度 (Visual Viewpoint):** 权重矩阵 $W$ 的**每一行**可以看作是对应类别的**模板 (template)** 或原型。计算 $Wx$ 的过程可以理解为用每个类别的模板与输入图像 $x$ 做**内积 (inner product / dot product)**，衡量模板与图像的匹配程度（得分越高，匹配越好）。偏置 $b$ 调整了得分的基准。Slide 60 展示了 CIFAR-10 训练出的模板，虽然模糊，但大致反映了类别的平均特征。(Slide 60)
  - **几何角度 (Geometric Viewpoint):** 对于每个类别 $k$，方程 $w_k^T x + b_k = \text{constant}$ 定义了 D 维空间中的一个**超平面 (hyperplane)**。线性分类器实际上是用这些超平面作为**决策边界 (decision boundaries)** 来划分特征空间。输入 $x$ 落在哪个区域，就预测为哪个类别。(Slide 61)

**线性分类器的局限性:**

> (Slide 62)

由于只能使用线性决策边界（直线、平面、超平面），线性分类器无法解决非线性可分的问题，例如：

- XOR 问题（数据分布在对角象限）。
- 环形分布。
- 多模态分布（一个类别有多个分离的簇）。

**TODO：** 我记得 tensorflow 有一个简单的在线可视化网站工具，可以用来展示这个。
**补充说明：** TensorFlow Playground ([https://playground.tensorflow.org/](https://playground.tensorflow.org/)) 是一个很好的在线工具。你可以在上面选择简单的二维数据集（例如环形、异或、螺旋形），然后只使用线性特征（X1, X2）和没有隐藏层的网络（这本质上就是一个线性分类器），观察它如何尝试用直线去划分这些非线性数据，从而直观地理解线性分类器的局限性。

**如何找到最优参数 W, b？**

> (Slide 63)

需要两步：

1.  **定义损失函数 (Loss Function):** 量化当前 $W, b$ 在训练数据上的表现有多差。
2.  **优化 (Optimization):** 找到使损失函数最小化的 $W, b$。

**损失函数:**

> (Slides 64-67)

- 衡量模型预测与真实标签之间的差异。
- 对于包含 $N$ 个样本的数据集 $\{(x_i, y_i)\}_{i=1}^N$：
  - 为每个样本 $(x_i, y_i)$ 计算损失 $L_i$。
  - 总损失 $L$ 是所有样本损失的**平均值**:
    $$L = \frac{1}{N} \sum_{i=1}^N L_i$$
- 目标：找到使 $L$ 最小的 $W, b$。
- **TODO：** 上面的数学公式必须要用`$$`inline-math 或者 display-math 处理格式 **(已完成)**

### Softmax 分类器与交叉熵损失 (Softmax Classifier & Cross-Entropy Loss)

> (Slides 68-81)

一种常用的将原始得分转化为概率并计算损失的方法。

**Softmax 函数:**

> (Slides 69-73, 79)

将原始得分向量 $s$ (logits) 转换为概率向量 $p$：
$$p_k = P(y=k | x_i; W, b) = \frac{e^{s_k}}{\sum_j e^{s_j}}$$
其中 $s = f(x_i, W, b)$ 是类别得分向量，$s_k$ 是第 $k$ 类的得分。

- **步骤：**
  1.  **指数化 ($e^{s_k}$):** 保证所有值非负。
  2.  **归一化 (除以总和 $\sum_j e^{s_j}$):** 保证所有概率之和为 1。
- **TODO：** 上面的数学公式必须要用`$$`inline-math 或者 display-math 处理格式；然后添加 demo 图片等等 **(公式已完成)**
  **补充说明：** 幻灯片 (Slides 69-74) 通过一个例子 [3.2, 5.1, -1.7] 展示了这个过程：
  Scores: [3.2, 5.1, -1.7]
  Exponentiate: [$e^{3.2}$, $e^{5.1}$, $e^{-1.7}$] ≈ [24.5, 164.0, 0.18] (Unnormalized probabilities)
  Normalize (divide by sum 188.68): [24.5/188.68, 164.0/188.68, 0.18/188.68] ≈ [0.13, 0.87, 0.00] (Probabilities sum to 1)

**交叉熵损失 (Cross-Entropy Loss):**

> (Slides 74-79)

- 目标：最大化正确类别的预测概率。
- 损失函数定义为**正确类别 $y_i$ 的预测概率的负对数**：
  $$L_i = -\log P(y=y_i | x_i) = -\log \left( \frac{e^{s_{y_i}}}{\sum_j e^{s_j}} \right)$$
- **直观理解：**
  - 如果正确类别的概率 $P(y=y_i|x_i)$ 接近 1，那么 $L_i = -\log(P)$ 接近 0 (损失小)。
  - 如果正确类别的概率接近 0，那么 $L_i = -\log(P)$ 趋向于 $+\infty$ (损失大)。
- 最小化交叉熵损失等价于**最大化对数似然 (Maximizing Log Likelihood)**，这是一种标准的统计估计方法 (Maximum Likelihood Estimation, MLE)。(Slide 75)
- 交叉熵损失也衡量了预测概率分布 $P$ 和真实分布（一个 one-hot 向量，正确类别为 1，其余为 0）之间的差异（具体来说是 KL 散度）。(Slides 76-78)
- **TODO：** 上面的数学公式必须要用`$$`inline-math 或者 display-math 处理格式 **(已完成)**

**Softmax 损失性质:**

> (Slides 80-81)

- **范围:** $[0, +\infty)$。
- **初始化时的损失:** 当 $W$ 很小，所有得分 $s_j \approx 0$ 时，每个类别的概率接近 $1/C$ (C 为类别数)。此时 $L_i \approx -\log(1/C) = \log(C)$。例如，CIFAR-10 (C=10) 的初始损失约为 $\log(10) \approx 2.3$。这可用于调试检查代码是否正确。

---

**后续内容预告:**

> (Slide 82)

到目前为止，我们定义了线性评分函数 $f=Wx+b$ 和 Softmax (交叉熵) 损失函数。接下来需要解决的问题是：

- 如何防止模型过于复杂而在训练数据上**过拟合**？（**正则化 Regularization**）
- 如何**找到**最小化损失函数的 $W$ 和 $b$？（**优化 Optimization**）

这些是后续课程（可能是下一讲）的内容。
