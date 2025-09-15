先说目前我的结论（我对材料学的知识很少，基本是这几天自己差的）：两种材料没有找到S-N曲线。想要比较精确的S-N曲线必须要做实验。下面我记录了查到的一种近似方法。

---

## 基础知识 - 不是很重要

关于应力和应变的基础知识介绍视频：https://www.youtube.com/watch?v=aQf6Q8t1FQE

简单总结：应力和应变是描述物体在外力作用下响应的基本概念，通过分析轴向加载的金属杆探讨了正应力、剪应力及其计算方法，并介绍了应力-应变图与材料特性之间的关系。

in small strain range, Hooke's Law applies: $\sigma = E \epsilon$ E是Young's Modulus

关于S-N曲线的基本知识：https://www.youtube.com/watch?v=15BVllILXFo&list=PL5e-0AcdojuTpohwUhoMy1hdl0tJ6KTDT

---

## 具体研究材料

我们要研究的两种材料：

- 12Cr2Ni4A/GJB1951-1994
- 16Cr3NiWMoVNbEQ/s10-0361-2004

### 12Cr2Ni4A/GJB1951-1994

按照“12Cr2Ni4A”这个关键词**没**查到什么有用的信息。

唯一相关的这篇[文章](https://www.sciencedirect.com/science/article/pii/S0142112322006569)的结论是：超声参数对**12Cr2Ni4A合金表面应力的影响**，发现与传统磨削表面的残余拉应力相比，超声辅助磨削产生了残余压应力，且随超声振幅增加而增大

按照“GJB1951-1994”这个关键词：

https://www.164580.com/info_385067.html 这个网页里面包含了这个标准下的多种材料，其中`12Cr2Ni4A`对应的文档是：https://www.caishuku.com/material/detail.php?mid=4433142 。里面包含两组数据，分别是钢棒尺寸小于等于或者大于200mm的力学性能。每一组数据有抗拉强度$\sigma_{b}$，屈服点$\sigma_{s}$，断后伸长率或延伸率，断面收缩率，硬度，冲击吸收能量 KV2。

按照前面的视频里面提到的近似方法：S-N曲线是**应力幅值(S) vs 疲劳寿命(N)**的关系曲线，横坐标是循环次数N，纵坐标是应力幅值σ。

基于Basquin方程建立S-N曲线：

$$\sigma \cdot N^{1/m} = C$$

#### Step 1: 估算疲劳极限

基于抗拉强度$\sigma_b$估算疲劳极限：
$$\sigma_{-1} = 0.45 \times \sigma_b$$

此值代表**无限寿命点**：当应力低于$\sigma_{-1}$时，材料理论上不会发生疲劳破坏。

#### Step 2: 确定S-N曲线关键控制点

**点1**：疲劳极限点

- 坐标：$(10^7, \sigma_{-1})$
- 物理意义：循环$10^7$次时的疲劳极限

**点2**：高应力短寿命点

- 坐标：$(10^3, 0.9\sigma_b)$
- 物理意义：接近抗拉强度时的低周疲劳

#### Step 3: 拟合S-N曲线参数

利用两个控制点拟合Basquin方程参数：

**计算斜率m**：
$$m = \frac{\lg(10^7) - \lg(10^3)}{\lg(0.9\sigma_b) - \lg(\sigma_{-1})} = \frac{4}{\lg(0.9\sigma_b) - \lg(\sigma_{-1})}$$

**计算常数C**：
$$C = \sigma_{-1} \cdot (10^7)^{1/m}$$

#### Step 4: 建立完整S-N方程

$$\sigma = \frac{C}{N^{1/m}} = \sigma_{-1} \left(\frac{10^7}{N}\right)^{1/m}$$

#### Step 5: 进行修正

##### 修正判断准则

```
材料特性判断：
if (σₛ/σᵦ) > 0.8:     # 高强度钢，需要修正疲劳极限
if KV₂ < 20J:         # 脆性材料，需要降低疲劳极限
if 硬度 > 350HB:      # 高硬度材料，需要特殊修正

尺寸效应判断：
存在不同尺寸规格时，必须进行尺寸修正
```

##### 屈服强度修正

**屈服比修正系数**：
$$k_{\sigma_s} = 0.8 + 0.2 \times \frac{\sigma_s}{\sigma_b}$$

**判断逻辑**：

- $\frac{\sigma_s}{\sigma_b} > 0.8$：高强度材料，疲劳性能相对更好
- $\frac{\sigma_s}{\sigma_b} < 0.6$：高韧性材料，但疲劳极限可能偏低

##### 冲击韧性修正

**韧性修正系数**：

$$
k_{KV} = \begin{cases}
0.8 & \text{if } KV_2 < 20\text{J (脆性)} \\
1.0 & \text{if } 20\text{J} \leq KV_2 \leq 60\text{J (正常)} \\
1.1 & \text{if } KV_2 > 60\text{J (高韧性)}
\end{cases}
$$

##### 硬度修正

**硬度修正系数**：

$$
k_{HB} = \begin{cases}
0.9 & \text{if } HB < 200 \text{(软钢)} \\
1.0 & \text{if } 200 \leq HB \leq 300 \text{(中碳钢)} \\
1.15 & \text{if } 300 < HB \leq 400 \text{(高强钢)} \\
1.0 & \text{if } HB > 400 \text{(过硬，疲劳敏感)}
\end{cases}
$$

##### 尺寸效应修正

**尺寸修正系数**：
$$k_d = \left(\frac{d}{7.62}\right)^{-0.133}$$

其中d为有效直径(mm)。

**实际应用**：

- ≤200mm组：$k_d = 0.72$
- > 200mm组（以300mm为例）：$k_d = 0.65$

##### 塑性修正

**基于延伸率和断面收缩率**：
$$k_{塑性} = 0.9 + 0.1 \times \min\left(\frac{\delta}{25}, \frac{\psi}{60}\right)$$

#### Step 6: 综合修正

$$\sigma_{-1}^{最终} = k_{\sigma_s} \times k_{KV} \times k_{HB} \times k_d \times k_{塑性} \times 0.45\sigma_b$$

这种近似方法的缺点：

- 缺乏实际疲劳试验数据验证
- 未考虑环境因素（温度、腐蚀等）影响
- 加载方式差异（拉压、弯曲、扭转）未充分考虑
- 表面状态和应力集中影响需要进一步修正

### 16Cr3NiWMoVNbE Q/s10-0361-2004

按照“Q/s10-0361-2004”这个作为关键词的搜索结果只有下面这个，看起来没什么用

https://msc.nuaa.edu.cn/_upload/article/files/e0/a8/650a77be49749953c973ff22c006/e648fb81-04ba-441e-8d97-4fe1838fd77f.pdf

按照”16Cr3NiWMoVNbE“这个关键词搜索：

- https://www.caishuku.com/material/detail.php?mid=azhlNWIxMTg4Njg= 里面只有元素成分数据。
- http://www.mojusteel.com/product/8705.html 这里面有部分力学性能（但是不是很精确，例如：延伸率：通常为20% 至 30%； 抗拉强度：约550 MPa 至 700 MPa 等等）
- https://www.jssyjs.net/About.html?article_id=84 也有一些力学性能，但和上面这些稍微有些不同。

---

文章1: https://www.mtssans.com/index.php?case=archive&act=show&aid=611
文章1提到如何认定高周疲劳的标准：将$10^7$次循环定义为无限寿命点是针对钢材的一种常见做法。但对于某些高强度钢或在特定应用中，可能需要更高的循环次数（如$10^8$）来定义疲劳极限。

新的拟合方法主要考虑了低周疲劳，高周疲劳以及疲劳极限这三个区间。三个周期从哪一个数量级开始是根据上面文章的数据假定的。

拟合结果如下：

| 材料名称        | 抗拉强度 σb (MPa) | 屈服强度 σs (MPa) | 断面收缩率 ψ (%) | 屈服比 (σs/σb) | 屈服比修正系数 (k_σs) | 基础疲劳极限 (MPa) | 最终修正疲劳极限 (MPa) |
| --------------- | ----------------- | ----------------- | ---------------- | -------------- | --------------------- | ------------------ | ---------------------- |
| 12Cr2Ni4A       | 1030              | 785               | 55               | 0.762          | 0.952                 | 597.4              | 569.0                  |
| 16Cr3NiWMoVNbEQ | 600               | 550               | 30               | 0.917          | 0.983                 | 348.0              | 342.2                  |

--- Advanced 3-Stage S-N Curve Estimation Tool ---
Please provide the following material properties (use minimum guaranteed values).

Enter the material name (e.g., 12Cr2Ni4A): 12Cr2Ni4A

1. Tensile Strength (σb) [MPa]: 1030
2. Yield Strength (σs) [MPa]: 785
3. Reduction of Area (ψ) [%]: 55

--- Select a Performance Profile ---
Choose a preset that best describes your component's condition:
[A] Standard Polished Specimen (Conservative)
[B] High-Performance / Surface-Treated Component (Aggressive)
Enter your choice (A/B): B

--- Calculation Summary ---
Selected Profile: High-Performance / Surface-Treated Component (Aggressive)
Yield Ratio (σs/σb): 0.762
Yield Ratio Correction Factor (k_σs): 0.952
Base Fatigue Limit (before correction): 597.4 MPa
Final Corrected Fatigue Limit: 569.0 MPa

--- Advanced 3-Stage S-N Curve Estimation Tool ---
Please provide the following material properties (use minimum guaranteed values).

Enter the material name (e.g., 12Cr2Ni4A): 16Cr3NiWMoVNbEQ

1. Tensile Strength (σb) [MPa]: 600
2. Yield Strength (σs) [MPa]: 550
3. Reduction of Area (ψ) [%]: 30

--- Select a Performance Profile ---
Choose a preset that best describes your component's condition:
[A] Standard Polished Specimen (Conservative)
[B] High-Performance / Surface-Treated Component (Aggressive)
Enter your choice (A/B): B

--- Calculation Summary ---
Selected Profile: High-Performance / Surface-Treated Component (Aggressive)
Yield Ratio (σs/σb): 0.917
Yield Ratio Correction Factor (k_σs): 0.983
Base Fatigue Limit (before correction): 348.0 MPa
Final Corrected Fatigue Limit: 342.2 MPa
