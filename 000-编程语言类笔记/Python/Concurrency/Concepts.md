# 1. 多线程 (Threading) - 餐厅服务员模型

想象一家餐厅：

- **一个餐厅（进程）** 里有多个服务员（线程）
- 所有服务员共享餐厅的资源（厨房、餐具、菜单等）

## 工作方式：

```
餐厅（共享空间）
├── 服务员A: 负责1-3号桌
├── 服务员B: 负责4-6号桌
└── 服务员C: 负责7-9号桌
```

## 特点：

1. **共享资源**

   - 所有服务员使用同一个厨房
   - 共用同一套餐具和设备

2. **协调需求**

   - 服务员需要协调使用咖啡机
   - 需要避免拿错别人的餐单

3. **适用场景**
   - 多个客人同时点餐
   - 上菜、收盘子等 I/O 操作

# 2. 多进程 (Multiprocessing) - 多家连锁店模型

想象一个连锁餐厅品牌：

- **每家分店（进程）** 都是独立运营
- 各自有自己的资源和员工

## 工作方式：

```
连锁品牌
├── 北京店：完整的独立运营
├── 上海店：完整的独立运营
└── 广州店：完整的独立运营
```

## 特点：

1. **资源独立**

   - 每家店有自己的厨房
   - 独立的库存和设备

2. **通信成本高**

   - 店铺间需要电话或网络沟通
   - 资源不能直接共享

3. **适用场景**
   - 大量烹饪任务（CPU 密集）
   - 完全独立的业务处理

# 3. 协程 (Coroutine) - 一个超高效的独立服务员模型

想象一个非常高效的服务员：

- **一个服务员（单线程）** 同时处理多个任务
- 利用等待时间处理其他事情

## 工作方式：

```
高效服务员的工作流
├── 接待A桌点餐
│   └── 等待A桌决定时，去B桌
├── 接待B桌点餐
│   └── 等待厨房炒菜时，去C桌
└── 接待C桌结账
    └── 等待刷卡时，给A桌上菜
```

## 特点：

1. **高效切换**

   - 不会傻等，利用等待时间
   - 灵活处理多个任务

2. **低资源消耗**

   - 只有一个服务员
   - 通过任务切换提高效率

3. **适用场景**
   - 大量需要等待的任务
   - 如等待顾客、等待出菜

# 4. 实际编程对应关系

## 多线程例子

```python
# 餐厅服务员模型
import threading

def serve_table(table_number):
    print(f"服务员开始服务{table_number}号桌")
    # 处理点餐、上菜等

# 创建多个服务员（线程）
waiter1 = threading.Thread(target=serve_table, args=(1,))
waiter2 = threading.Thread(target=serve_table, args=(2,))
waiter1.start()
waiter2.start()
```

## 多进程例子

```python
# 连锁店模型
from multiprocessing import Process

def run_restaurant(location):
    print(f"开始运营{location}分店")
    # 独立运营一家分店

# 开设多家分店（进程）
store1 = Process(target=run_restaurant, args=('北京',))
store2 = Process(target=run_restaurant, args=('上海',))
store1.start()
store2.start()
```

## 协程例子

```python
# 高效服务员模型
import asyncio

async def handle_customer(customer):
    print(f"开始服务顾客{customer}")
    # 等待顾客点餐
    await asyncio.sleep(1)  # 模拟等待时间
    print(f"完成顾客{customer}的服务")

async def main():
    # 一个服务员同时处理多个顾客
    await asyncio.gather(
        handle_customer('A'),
        handle_customer('B'),
        handle_customer('C')
    )

asyncio.run(main())
```

# 5. 选择建议

## 使用多线程当：

- 需要同时服务多个客人
- 服务员之间需要共享信息
- 任务涉及等待（如等待顾客点餐）

## 使用多进程当：

- 需要同时运营多家独立店铺
- 每家店处理自己的业务
- 需要大量计算（如复杂的烹饪）

## 使用协程当：

- 一个服务员要高效处理多个任务
- 任务包含大量等待时间
- 需要处理大量并发请求
