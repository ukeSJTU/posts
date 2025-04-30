# Checkpoint 4: measuring the real world

## 1 Overview

By this point in the class, you've implemented the Transmission Control Protocol in an almost fully standards-compliant manner. TCP implementations are arguably the world's single most popular computer program, found in billions of devices. Most implementations use a different strategy from yours, but because all TCP implementations share a common language, they are all interoperable—every TCP implementation can be a peer with any other, across the whole Internet. This checkpoint won't use your TCP implementation: it's about measuring the long-term statistics of some real-world Internet paths.

To complete this checkpoint, we want you to choose and characterize at least three "interesting" Internet paths. Each path will be between your computer and another host and will either go some significant distance (RTT greater than 100 ms) or will include at least one "interesting" link along the way (e.g. a Wi-Fi or tethered cellular or satellite link). Ideally your final report will include a mix—at least one long-distance "boring" path and at least one path that includes an "interesting" link.

For each path, please measure at least the below statistics:

## 2 Collecting data

1. Choose a remote host on the Internet to ping (measured by ping from your computer or VM). Some possibilities of faraway paths to get there:

   - www.cs.ox.ac.uk (Oxford University CS department webserver, United Kingdom)
   - 162.105.253.58 (Computer Center of Peking University, China)
   - www.canterbury.ac.nz (University of Canterbury webserver, New Zealand)
   - 41.186.255.86 (MTN Rwanda)
   - A friend's VM on the CS144 private network
   - preferred: an original choice with an RTT of at least 100 ms from you or that requires crossing a wireless link

2. Use the mtr or traceroute commands to trace the route between your VM and this host.

3. Run a ping for at least an hour to collect data on this Internet path. Use a command like `ping -D -n -i 0.2 hostname | tee data.txt` to save the data in the "data.txt" file. (The -D argument makes ping record the timestamp of every line, and -i 0.2 makes it send one "echo request" ICMP message every 0.2 seconds. The -n argument makes it skip trying to use DNS to reverse-lookup the replying IP address to a hostname.)

4. Note: A default-sized ping every 0.2 seconds is fine, but please do not flood anybody with traffic faster than this for more than a few seconds.

## 3 Analyzing data

If you sent five pings per second for an hour, you will have sent approximately 3,600 echo requests (= 5 × 3600), of which we expect the vast majority to have received a reply in the ping output. Using the programming language and graphing tools of your choice, please compute and graph at least the following information:

1. What was the overall delivery rate over the entire interval? In other words: how many echo replies were received, divided by how many echo requests were sent? (Note: ping on GNU/Linux doesn't print any message about echo replies that are not received. You'll have to identify missing replies by looking for missing sequence numbers.)

2. What was the longest consecutive string of successful pings (all replied-to in a row)?

3. What was the longest burst of losses (all not replied-to in a row)?

4. Produce a graph showing the autocorrelation of "packet loss" over time. In other words:

   - Given that echo request #N received a reply, what is the probability that echo request #(N+k) was also successfully replied-to? In your graph, include a bar for each k between -10 and 10 (inclusive).
   - Given that echo request #N did not receive a reply, what is the probability that echo request #(N+k) was also not replied-to?
   - How do these figures (the conditional delivery rates) compare with the overall "unconditional" packet delivery rate in the first question? How independent or "bursty" were the losses?

5. What was the minimum RTT seen over the entire interval? (This is probably a reasonable approximation of the true MinRTT...)

6. What was the maximum RTT seen over the entire interval?

7. Make a graph of the RTT as a function of time. Label the x-axis with the actual time of day (covering the hour+ period), and the y-axis should be the number of milliseconds of RTT.

8. Graph the Cumulative Distribution Function of the distribution of RTTs observed. This is a graph where the x-axis is each observed value of RTT, and the y-axis is the proportion of samples that were less than or equal to this number (so the y-axis will go from 0 to 1). What rough shape is the distribution?

9. Make a scatter plot of the correlation between "RTT of ping #N" and "RTT of ping #N+1". The x-axis should be the number of milliseconds from the first RTT, and the y-axis should be the number of milliseconds from the second RTT. How correlated is the RTT over time?

10. Do some brief (less than 10 seconds) experiments where you send a higher data rate of pings, by increasing the packet size and frequency. On Linux, you can increase the size of an echo request (and reply) with the "-s" argument (do not use values greater than 1400), and you can increase the frequency of an echo request by reducing the interval given to the "-i" argument. You can tell ping to stop after a certain number of requests with the "-c" argument. Make a graph of the overall data rate of replies (packet size×number of replies/total duration) as a function of the data rate of your echo requests. Does it level off at some value? What was the maximum throughput you were able to obtain?

11. What are your conclusions from the data? Did the network path behave the way you were expecting? What (if anything) surprised you from looking at the graphs and summary statistics?

12. What interesting comparisons can you make between this path and the other network paths you characterized?

Please submit your report as a PDF via Gradescope.

# 中文

## 1 概述

到课程的这个阶段，您已经以几乎完全符合标准的方式实现了传输控制协议（TCP）。TCP 实现可以说是世界上最受欢迎的计算机程序，存在于数十亿设备中。大多数实现采用了与您不同的策略，但由于所有 TCP 实现共享一种通用语言，它们都是可互操作的——每个 TCP 实现都可以与互联网上的任何其他实现进行对等通信。本检查点不会使用您的 TCP 实现：它是关于测量一些现实世界互联网路径的长期统计数据。

为了完成这个检查点，我们希望您选择并描述至少三个“有趣”的互联网路径。每个路径将是您的计算机与另一个主机之间的路径，并且要么跨越相当大的距离（RTT 大于 100 毫秒），要么沿途包含至少一个“有趣”的链接（例如 Wi-Fi、绑定的蜂窝网络或卫星链接）。理想情况下，您的最终报告将包括多种路径——至少一个长距离的“普通”路径和至少一个包含“有趣”链接的路径。

对于每个路径，请至少测量以下统计数据：

## 2 收集数据

1. 选择互联网上的一个远程主机进行 ping 测试（从您的计算机或虚拟机进行 ping 测量）。一些可能的远距离路径包括：

   - www.cs.ox.ac.uk（牛津大学计算机科学系网站服务器，英国）
   - 162.105.253.58（北京大学计算机中心，中国）
   - www.canterbury.ac.nz（坎特伯雷大学网站服务器，新西兰）
   - 41.186.255.86（MTN 卢旺达）
   - CS144 私有网络上的朋友的虚拟机
   - 首选：一个原创选择，RTT 至少为 100 毫秒，或者需要跨越无线链接

2. 使用 mtr 或 traceroute 命令追踪您的虚拟机与此主机之间的路径。

3. 运行 ping 至少一小时，以收集此互联网路径上的数据。使用类似 `ping -D -n -i 0.2 hostname | tee data.txt` 的命令将数据保存在“data.txt”文件中。（-D 参数使 ping 记录每一行的时间戳，-i 0.2 使其每 0.2 秒发送一个“echo request” ICMP 消息。-n 参数使其跳过尝试使用 DNS 反向查找回复 IP 地址的主机名。）

4. 注意：每 0.2 秒一个默认大小的 ping 是可以的，但请不要以比这更快的速度向任何人发送流量超过几秒钟。

## 3 分析数据

如果您每秒发送五个 ping，持续一小时，您将发送大约 3,600 个 echo 请求（= 5 × 3600），我们预计其中绝大多数会在 ping 输出中收到回复。使用您选择的编程语言和绘图工具，请计算并绘制至少以下信息：

1. 整个时间段内的总体交付率是多少？换句话说：收到了多少个 echo 回复，除以发送了多少个 echo 请求？（注意：在 GNU/Linux 上，ping 不会打印任何关于未收到回复的 echo 回复的消息。您必须通过查找缺失的序列号来识别缺失的回复。）

2. 最长的连续成功 ping 序列（连续回复）是多少？

3. 最长的连续丢失爆发（连续未回复）是多少？

4. 制作一个显示“数据包丢失”随时间自相关的图表。换句话说：

   - 假设 echo 请求 #N 收到了回复，那么 echo 请求 #(N+k) 也成功收到回复的概率是多少？在您的图表中，为 -10 到 10（包括）之间的每个 k 包含一个条形图。
   - 假设 echo 请求 #N 未收到回复，那么 echo 请求 #(N+k) 也未收到回复的概率是多少？
   - 这些数字（条件交付率）与第一个问题中的总体“无条件”数据包交付率相比如何？丢失是多么独立或“突发性”的？

5. 整个时间段内看到的最小 RTT 是多少？（这可能是真实 MinRTT 的合理近似值...）

6. 整个时间段内看到的最大 RTT 是多少？

7. 制作一个 RTT 随时间变化的图表。x 轴标注实际的 daytime（覆盖一小时以上的时间段），y 轴应为 RTT 的毫秒数。

8. 绘制观察到的 RTT 分布的累积分布函数图。这是一个图表，其中 x 轴是每个观察到的 RTT 值，y 轴是小于或等于此数字的样本比例（因此 y 轴将从 0 到 1）。分布的大致形状是什么？

9. 制作一个散点图，显示“ping #N 的 RTT”与“ping #N+1 的 RTT”之间的相关性。x 轴应为第一个 RTT 的毫秒数，y 轴应为第二个 RTT 的毫秒数。RTT 随时间相关性如何？

10. 进行一些短暂（少于 10 秒）的实验，通过增加数据包大小和频率发送更高数据率的 ping。在 Linux 上，您可以使用“-s”参数增加 echo 请求（和回复）的大小（不要使用大于 1400 的值），并且可以通过减小“-i”参数给定的间隔来增加 echo 请求的频率。您可以使用“-c”参数告诉 ping 在一定数量的请求后停止。制作一个回复的总体数据率（数据包大小 × 回复数量/总持续时间）作为您的 echo 请求数据率的函数的图表。它是否在某个值处趋于平稳？您能获得的最大吞吐量是多少？

11. 您从数据中得出的结论是什么？网络路径是否符合您的预期？从查看图表和汇总统计数据中，有什么（如果有的话）让您感到惊讶？

12. 您可以在此路径与其他您描述的网络路径之间做出哪些有趣的比较？

请通过 Gradescope 提交您的报告为 PDF 格式。

# 我的实现
