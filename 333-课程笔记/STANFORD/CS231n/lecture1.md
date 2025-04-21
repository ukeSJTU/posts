# Lecture 1: Introduction

本课程学习的内容：

# Lecture 1: Introduction

本课程学习的内容：

![](<https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/04/Screenshot2025-04-10 19.57.08.png>)

![](<https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/04/Screenshot2025-04-10 19.58.48.png>)

还有一些其他的相关知识领域：

- Computer Science (计算机科学)
- Biology (生物学)
- Psychology (心理学)
- Mathematics (数学)
- Physics (物理学)
- Neuroscience (神经科学)

## Brief History

### 生物视觉系统的进化

- 寒武纪大爆发时期(约 5.3-5.4 亿年前)出现了最早的视觉系统
- 各种动物都发展出了自己的视觉系统

### 人造视觉系统的发展

- Camera Obscura（暗箱）是最早的成像设备之一
  - Leonardo da Vinci 在 16 世纪就对其进行了研究
  - Gemma Frisius 在 1545 年进行了相关记录

### 研究历程

#### 1. 早期神经科学基础 (1959)

Hubel 和 Wiesel 的开创性实验 ：

- Simple cells（简单细胞）
  - 对特定旋转和方向的刺激有反应
- Complex cells（复杂细胞）
  - 对光线方向和运动有反应
  - 具有一定的平移不变性

#### 2. 计算机视觉早期发展 (1963)

Larry Roberts 的开创性工作 ：

- 发表《Machine Perception of Three-Dimensional Solids》
- 处理步骤：
  1. 原始图像捕获
  2. 差分处理（边缘检测）
  3. 特征点提取

#### 3. 理论框架形成 (1970s)

David Marr 的视觉表征理论 ：

- Primal Sketch（基本素描）：零交叉、斑点、边缘等
- 2½-D Sketch：局部表面方向和深度
- 3-D Model：三维模型表示

#### 4. 识别方法演进

1. 基于部件的识别 (1970s)

   - 1979 年 Brooks 和 Binford 提出广义圆柱体理论
   - 1973 年 Fischler 和 Elshlager 提出图形结构

2. 基于边缘检测的识别 (1980s)
   - 1986 年 John Canny 提出 Canny 边缘检测器
   - 1987 年 David Lowe 的工作

#### 5. AI 寒冬时期

- AI 研究热情和资金减少
- 专家系统未能实现承诺
- AI 子领域继续发展：
  - 计算机视觉
  - 自然语言处理
  - 机器人学
  - 计算生物学等

#### 6. 认知科学的重要进展

在 AI 发展的同时，认知科学领域也取得了重要突破：

- 1972 年 Biederman 的研究
- 1970 年代 Potter 等人的快速序列视觉呈现(RSVP)研究
- 1996 年 Thorpe 等人发现人类可以在 150ms 内完成视觉识别
- 1997-1998 年 Kanwisher 等人研究物体和场景识别的神经相关性

#### 7. 机器学习时代 (1990s-2000s)

1. 1997 年 Normalized Cuts

   - Shi 和 Malik 提出
   - 基于图像分割的识别方法

2. 1999 年 SIFT 特征

   - David Lowe 提出
   - 成为计算机视觉领域的里程碑算法

3. 2001 年 Viola-Jones 人脸检测
   - 机器学习在视觉领域的首次成功应用
   - 实现了实时人脸检测

#### 8. 数据集革命

1. 2004 年 Caltech101 数据集
2. 2007 年 PASCAL 视觉对象挑战赛
3. 2009 年 ImageNet 数据集
   - 1000 个物体类别
   - 超过 140 万张图像
   - 推动了深度学习革命

#### 9. 深度学习革命 (2012-至今)

1. 2012 年 AlexNet 突破

   - 在 ImageNet 竞赛中取得突破性成果
   - 标志着深度学习时代的开始

2. 现代应用领域：
   - 图像分类与检索
   - 物体检测和分割
   - 视频分类
   - 活动识别
   - 姿态识别
   - 医学影像
   - 天文图像分析
   - 图像描述生成
   - 艺术风格迁移

#### 10. 技术支撑

深度学习的爆发得益于三个关键因素：

1. 计算能力
   - GPU 性能提升
   - 专门的深度学习硬件（Tensor Cores）
2. 数据
   - 大规模数据集
   - 数据采集和标注能力提升
3. 算法
   - 网络架构创新
   - 训练方法改进

#### 11. 当前挑战与未来展望

1. 技术挑战

   - 仍有许多基础问题待解决
   - 需要更强大的模型和算法

2. 伦理考虑

   - 可能导致有害的刻板印象
   - 影响人们的生活和工作机会

3. 积极影响

   - 在医疗等领域可以挽救生命
   - 推动科技进步

4. 发展方向
   - 算法改进
   - 应用领域拓展
   - 确保技术的公平性和透明度

## Overview of Course CS231n

### 1. 课程讲师团队

- 主讲教师：Fei-Fei Li、Ehsan Adeli、Justin Johnson、Zane Durante
- 特邀讲师：Jiajun Wu、Ranjay Krishna、Ruohan Gao、Yunzhu Li

### 2. 课程主要内容框架

1. **Deep Learning Basics**

   - 图像分类（核心任务）
   - 线性分类器
   - 正则化与优化
   - 神经网络

2. **视觉世界的感知与理解**

   - 基础任务：
     - 分类
     - 语义分割
     - 目标检测
     - 实例分割
   - 进阶任务：
     - 视频分类
     - 可视化理解
     - 多模态视频理解
   - 模型架构：
     - 卷积神经网络
     - 循环神经网络
     - 注意力机制/Transformer

3. **生成式和交互式视觉智能**
   - 自监督学习
   - 生成式建模
     - 风格迁移
     - DALL-E 2 图像生成
     - 扩散模型
   - 视觉语言模型
   - 3D 视觉
   - 具身智能

### 3. 课程实践安排

- 讨论课：每周五 12:30-1:20，NVIDIA 礼堂
- 作业：使用 Google Colab 完成
- 办公时间：线下（Huang 大楼地下室）和线上（Zoom）双模式

### 4. 评分构成

- 作业 (45%)：
  - 作业 1：12%
  - 作业 2：18%
  - 作业 3：15%
- 期中考试：20%
- 课程项目：35%
  - 项目提案：1%
  - 里程碑：2%
  - 最终报告：29%
  - 海报展示：3%
- 参与度加分：最多 3%

### 5. 学习资源

- 课程网站：http://cs231n.stanford.edu/
- 可选教材：
  - [Deep Learning (Goodfellow 等)](https://www.deeplearningbook.org/)
  - [Mathematics of deep learning](https://mml-book.github.io/book/mml-book.pdf)
  - [Dive into deep learning](https://d2l.ai/index.html)

### 6. 先修要求

- 熟练使用 Python，后续的作业都要用 python 完成，还会用到 numpy，pytorch 和 tensorflow
- 大学微积分
- 线性代数
