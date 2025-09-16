7.1 Sampling
7.2 Reconstruction
7.3. Sampling Theorem

## 7.1 Sampling

### 7.1.1 Time-Domain Expression of Sampling

TODO: copy from PPT

There are two kinds of sampling:

1. Periodic sampling: the sampling interval is a constant
2. Aperiodic sampling: the sampling interval is a variable

> 这节课我们只考虑 periodic sampling，后续的所有sampling都是periodic sampling

Suppose x(n) is discrete-time signal and x_c(t) is continuous-time signal. Then the time-domain expression of (periodic) sampling is as below:

x(n)=xc(t)|t=nT=xc(nT).

TODO: convert to latex

### 7.1.2 Frequency-Domain Expression of Sampling

Let:

xc(t) be a continuous-time signal, Xc() be the continuous-

time Fourier transform of xc(t), x(n) be a discrete-time signal, and

X() be the discrete-time Fourier transform of x(n).

Then we have:

See page 3 of PPT and convert to LATEX.

Clarify two concepts:

CT signal processing we have the concept of frequency, in e^j(omega)\*t, we call the omega freq. This is actually the **physical frequency**. It means the change of phase in one second. We can look at this from another perspective: omega = d(omega\*t) / dt, unit: rad/s.

However, in DT signal processing, we also have a "frequency" concept: e^j(omega)\*n: omega here is also called frequency. This is called the **normalized frequency**. It means the change of phase in a sampling interval. omega = omega \* n - omage(n-1). unit: rad

TODO: 上面两个里面的数学公式换成latex，并且注意大小写omega的区分。

Relation between two frequencies above? lower_omega = Uppercase_omega \* sampling_interval

> Do not get confused of two concepts.

Go back to our previous sampling over freq-domain:

![image.png](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/09/20250916103510704.webp)

If x(n)=xc(nT), ie. DT signal x(n) is obtained from CT signal x_c(nT) by a sampling interval of T. Then we have the expression below:

![image.png](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/09/20250916103659412.webp)

TODO: convert to latex.

Since we have lowercase_omega = Uppercase_omega \* T, we have that:

![image.png](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/09/20250916103841835.webp)

This LHS is the DT FT of x(n) in terms of physical frequency (lowercase_omega).

Then (in class, teacher here writes on blackboard), expand the RHS, letting m = -2, -1, 0, 1, 2 we get the expression below: refer to image in phone

TODO: prove of expression 7.2

inverse CT FT: x_c(t) = ...

然后t=nT代换就有了PPT上的第三行表达式

继续交换积分和sigma的计算顺序得到第四行

第四行的中括号内部是e^jwn的 DTFT。再加上小omega=大omega乘以T，就得到第五行。

再交换一次积分和累加

最后记大Omega=小omega‘ / T， 带入， 这里我在手机里放图片了

## 7.2 Reconstruction

### 7.2.1 Frequency-Domain Expression of Reconstruction

TODO: add notations from PPT, here we use prime notation because reconstruction may face distortion and two signal might differ(?)

To reconstruct, we need to limit the X(Omega T) to the basic period and also multiplies the amplitude by T from A/T to A.

Then this explains the equation below:

![image.png](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/09/20250916111207362.webp)

if x_c(t) is real, then X_c(大Omega) = X_c^\*(-大Omega) contrary to symmetric(?), therefore, central freq is 0 and expression 7.5 extends to:

![image.png](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/09/20250916111603434.webp)

On textbook, we only consider expression 7.6 (special case) only.

### 7.2.2 Time-Domain Expression of Reconstruction

Question how to obtain x_t'(t) from x(n).

The overall is by changing each x(n) sample to a sinc function.

TODO: prove and special case.

第一步：Inverse CTFT
1->2: 根据Frequency-Domain Expression of Reconstruction
2->3: TODO

## 7.3 Sampling Theorem

x_c(t) CT signal, bandwidth: W. x(n) DT signal obtained by sampling x_c(t) with sampling interval T.

If 2pie/T > W, x_c(t) can be reconstructed from x(n) without distortion. OW, may have distortion owing to aliasing, see below:

![image.png](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/09/20250916112938820.webp)

TODO: why?

和我们之前提到的reconstruction过程中，我们要找basic period有关。

当2pie/T > W的时候，curves are separate，也就可以reconstruct

下面的对比

![image.png](https://pub-cc2ebc8a43754210aa734d07c4898ad1.r2.dev/2025/09/20250916113428081.webp)

Homework: 4.8 & 4.19
