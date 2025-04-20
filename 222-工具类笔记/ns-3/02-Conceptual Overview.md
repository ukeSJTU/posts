# Conceptual Overview

这个部分和官方 tutorial 的 Conceptual Overview 这一章对应。

## Key Abstractions

Review some terms that are commonly used in networking, btu ahvve a speciific emaning in _ns-3_.

### Node

类似 Host，但是为了做哦出区别。basic computing device, 可以视作计算机。可以给他添加功能。

### Application

### Channel

### Net Device

### Topology Helpers

## A First ns-3 Script

这里通过一个自带的 example 程序学习怎么用 ns-3

（这里官方文档把代码拆成一部分一部分的小代码并讲解，我合并成完整的代码）

```cpp
/*
 * SPDX-License-Identifier: GPL-2.0-only
 */

// 包含必要的NS-3模块头文件
#include "ns3/applications-module.h"  // 包含应用层模块，如UDP回显客户端和服务器
#include "ns3/core-module.h"          // 包含核心功能模块，如日志、命令行参数等
#include "ns3/internet-module.h"      // 包含互联网协议栈模块，如IP地址、TCP/UDP等
#include "ns3/network-module.h"       // 包含网络模块，如节点、设备等
#include "ns3/point-to-point-module.h" // 包含点对点链路模块

// 默认网络拓扑结构说明
//
//       10.1.1.0
// n0 -------------- n1
//    point-to-point
//
// 这表示两个节点n0和n1通过点对点链路连接，网络地址为10.1.1.0

using namespace ns3;  // 使用ns3命名空间，这样就不需要在每个NS-3类名前加ns3::前缀

// 定义日志组件名称为"FirstScriptExample"，方便调试和日志输出
NS_LOG_COMPONENT_DEFINE("FirstScriptExample");

int
main(int argc, char* argv[])
{
    // 创建命令行解析器，可以让用户通过命令行参数修改仿真参数
    CommandLine cmd(__FILE__);
    // 解析命令行参数
    cmd.Parse(argc, argv);

    // 设置仿真时间的精度为纳秒级别
    Time::SetResolution(Time::NS);
    // 启用UDP回显客户端应用程序的INFO级别日志
    LogComponentEnable("UdpEchoClientApplication", LOG_LEVEL_INFO);
    // 启用UDP回显服务器应用程序的INFO级别日志
    LogComponentEnable("UdpEchoServerApplication", LOG_LEVEL_INFO);

    // 创建节点容器
    NodeContainer nodes;
    // 在容器中创建2个节点（n0和n1）
    nodes.Create(2);

    // 创建点对点链路辅助对象，用于配置点对点链路
    PointToPointHelper pointToPoint;
    // 设置链路的数据传输速率为5Mbps
    pointToPoint.SetDeviceAttribute("DataRate", StringValue("5Mbps"));
    // 设置链路的传播延迟为2毫秒
    pointToPoint.SetChannelAttribute("Delay", StringValue("2ms"));

    // 创建网络设备容器
    NetDeviceContainer devices;
    // 在节点上安装点对点网络设备，并返回创建的设备集合
    devices = pointToPoint.Install(nodes);

    // 创建互联网协议栈辅助对象
    InternetStackHelper stack;
    // 在所有节点上安装完整的TCP/IP协议栈
    stack.Install(nodes);

    // 创建IPv4地址辅助对象
    Ipv4AddressHelper address;
    // 设置IP地址分配的基础网络地址为10.1.1.0，子网掩码为255.255.255.0
    address.SetBase("10.1.1.0", "255.255.255.0");

    // 为网络设备分配IP地址，并返回接口容器
    Ipv4InterfaceContainer interfaces = address.Assign(devices);

    // 创建UDP回显服务器辅助对象，服务端口为9
    UdpEchoServerHelper echoServer(9);

    // 在节点n1（索引为1的节点）上安装UDP回显服务器应用
    ApplicationContainer serverApps = echoServer.Install(nodes.Get(1));
    // 设置服务器应用在仿真开始后1秒启动
    serverApps.Start(Seconds(1));
    // 设置服务器应用在仿真开始后10秒停止
    serverApps.Stop(Seconds(10));

    // 创建UDP回显客户端辅助对象，指向服务器的IP地址和端口9
    UdpEchoClientHelper echoClient(interfaces.GetAddress(1), 9);
    // 设置客户端最多发送1个数据包
    echoClient.SetAttribute("MaxPackets", UintegerValue(1));
    // 设置发送数据包的时间间隔为1秒
    echoClient.SetAttribute("Interval", TimeValue(Seconds(1)));
    // 设置每个数据包的大小为1024字节
    echoClient.SetAttribute("PacketSize", UintegerValue(1024));

    // 在节点n0（索引为0的节点）上安装UDP回显客户端应用
    ApplicationContainer clientApps = echoClient.Install(nodes.Get(0));
    // 设置客户端应用在仿真开始后2秒启动（比服务器晚启动1秒）
    clientApps.Start(Seconds(2));
    // 设置客户端应用在仿真开始后10秒停止
    clientApps.Stop(Seconds(10));

    // 运行仿真
    Simulator::Run();
    // 清理仿真资源
    Simulator::Destroy();
    // 程序正常结束
    return 0;
}
```

如果你看上面的代码已经理解了，那你可以跳过下面的拆解部分。

### Copyright

省略

### Module Includes

省略。这个和最一开始如何从源代码进行构建有关。

### Ns3 Namespace

```cpp
using namespace ns3;
```

### Logging

TODO: 这里用来展示如何查阅 ns-3 的文档。

### Main Function

入口函数，和别的 cpp 程序别无二致。

设置 time resolution，默认 1ns。整个程序只能设置一次。

再继续开启 LogComponent。

### Topology Helpers

#### NodeContainer

创建 Nodes。后面还要将 Nodes 相互连接形成 network

#### PointToPointHelper

前面提到 NetDevice 和 Channel 这两个概念和实际的网络中 peripheral cards 以及 network cables 相对应。这里保持这样的想法：

```cpp

```

From a more detailed perspective, the string “DataRate” corresponds to what we call an Attribute of the
PointToPointNetDevice. If you look at the Doxygen for class ns3::PointToPointNetDevice and find the
documentation for the GetTypeIdmethod, you will find a list of Attributesdefined for the device. Among these is
the “DataRate” Attribute. Most user-visible ns-3 objects have similar lists of Attributes. We use this mechanism
to easily configure simulations without recompiling as you will see in a following section.

#### NetDeviceContainer

#### InternetStackHelper

#### Ipv4AddressHelper

### Applications
