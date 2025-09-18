## 用户密码格式

- 至少 8 位字符
- 至少包含一个字母和一个数字
- 不可以有空格
- 可以有特殊符号

## 用户密码 Hash 操作

目前前端不 Hash 密码，后端接收明文密码后进行 Hash 操作，传输过程依靠 HTTPS 加密通信

后端使用 Argon2id 算法进行密码 Hash 操作，生成随机 Salt 并与密码 Hash 值组合存储

- Memory: 64MB (65536 KB)
- Iterations: 3
- Parallelism: 4

## JWT

本项目使用 JWT（JSON Web Token）进行用户认证和授权。

### 后端生成 Token

当用户使用邮箱和密码成功登录后，后端服务器将生成一个 JWT Token 并返回给客户端。这个 Token 是后续请求的身份凭证。

- **算法 (Algorithm):** `HS256` (HMAC with SHA-256)
- **JWT 结构:** JWT 由三部分组成，通过 `.` 连接：`Header.Payload.Signature`
  - **Header (头部)**

    指定了签名算法和 Token 类型。

    ```json
    {
      "alg": "HS256",
      "typ": "JWT"
    }
    ```

  - **Payload (载荷)**
    - 包含了需要传递的数据（称为 Claims）。为了安全和高效，我们只存放用户的核心身份信息和 Token 的元数据。
    - **标准声明 (Registered Claims):**
      - `sub` (Subject): **用户 ID**。这是 Token 的核心，用于标识该 Token 属于哪个用户。
      - `iat` (Issued At): **签发时间戳**。记录 Token 是何时生成的。
      - `exp` (Expiration Time): **过期时间戳**。这是 Token 的生命周期，**必须设置**以保证安全。本项目设置成 24 小时。
    - **示例 Payload:**

    ```json
    {
      "sub": 123, // 用户的数据库ID
      "email": "user@example.com", // 可选，方便调试或某些场景使用
      "iat": 1726651200, // 签发时间 (Unix Timestamp)
      "exp": 1726737600 // 过期时间 (签发时间 + 24小时)
    }
    ```

  - **Signature (签名)**
    - 签名用于验证消息在传递过程中没有被篡改，并且可以验证 Token 的签发者。
    - **生成方式:**
      1.  将 `Header` 和 `Payload` 分别进行 Base64Url 编码。
      2.  将编码后的两部分用 `.` 连接起来。
      3.  使用`HS256`算法和预定义的**密钥 (Secret Key)** 对连接后的字符串进行加密。
    - **密钥 (Secret Key):**
      - 部署的时候用`openssl rand -base64 32`生成一个随机的 32 字节 Base64 编码字符串，放到`.env`文件中作为密钥。运行时用`process.env.JWT_SECRET`来读取

### 后端解析 Token

客户端在收到 Token 后，应将其存储在本地（如 LocalStorage 或 HttpOnly Cookie）。对于需要认证的 API 请求，客户端必须在 HTTP 请求的 `Authorization` Header 中携带 Token。

**格式:** `Authorization: Bearer <jwt_token>`

后端通过一个中间件（Middleware）来保护需要认证的路由。该中间件负责解析和验证 Token。

#### 1. 提取 Token

中间件首先从 `Authorization` Header 中解析出 `<jwt_token>` 部分。如果 Header 不存在或格式不正确，则直接拒绝请求（返回 `401 Unauthorized`）。

#### 2. 验证 Token

后端 JWT 库会使用当初签发时**相同的密钥 (Secret Key)** 来执行以下验证：

1.  **验证签名:** 重新计算 `Header` 和 `Payload` 的签名，并与 Token 中的 `Signature` 部分进行比对。
    - 如果签名不匹配，说明 Token 被篡改或是伪造的，验证失败。
2.  **验证标准声明:**
    - 检查 `exp` 声明，确保 Token 没有过期。如果 `当前时间戳 > exp时间戳`，则验证失败。
    - 可以根据需要检查其他声明（如 `iss` 签发者, `aud` 接收方等，但 MVP 阶段可省略）。

#### 3. 处理结果

**验证成功:**

- Token 是有效且可信的。
- 中间件从 `Payload` 中解析出用户 ID (`sub` 声明)。
- 将用户信息（如用户 ID）附加到请求对象上（例如 `request.user = { id: 123 }`），以便后续的业务逻辑代码可以直接使用。
- 请求被放行，继续执行目标 API 的逻辑。

**验证失败:**

- 无论是签名错误、Token 过期还是格式错误，都意味着请求未被授权。
- 中间件立即中断请求，并向客户端返回 `401 Unauthorized` 错误响应。

---

## 火车时刻表搜索与筛选逻辑

### 搜索参数处理

#### 必填参数验证

- **出发城市 (departure_city)**: 必须提供，不能为空字符串
- **到达城市 (arrival_city)**: 必须提供，不能为空字符串，且不能与出发城市相同
- **出发日期 (departure_date)**: 必须提供，格式为 YYYY-MM-DD，且不能早于当前日期

#### 可选参数处理

- **车次编号 (train_number)**: 支持模糊搜索，使用 SQL LIKE 操作符，如 `%G35%` 匹配包含 "G35" 的车次
- **价格范围**: min_price 和 max_price 必须为非负数，且 min_price <= max_price
- **时间范围**: departure_time_start 和 departure_time_end 格式为 HH:MM，且开始时间不能晚于结束时间
- **排序参数**: sort_by 限制为预定义值，sort_order 限制为 'asc' 或 'desc'
- **分页参数**: page >= 1，limit 在 1-100 之间

### 数据库查询优化

#### 索引利用策略

1. **主要查询路径**: 使用复合索引 `idx_train_schedules_route_time(departure_city, arrival_city, departure_datetime)`
2. **车次筛选**: 利用 `idx_train_schedules_train_number` 索引
3. **状态筛选**: 利用 `idx_train_schedules_status` 索引

#### 查询构建逻辑

```sql
SELECT * FROM train_schedules
WHERE departure_city = ?
  AND arrival_city = ?
  AND DATE(departure_datetime) = ?
  AND train_status NOT IN ('cancelled', 'suspended')
  AND (train_number LIKE ? OR ? IS NULL)
  AND (price >= ? OR ? IS NULL)
  AND (price <= ? OR ? IS NULL)
  AND (TIME(departure_datetime) >= ? OR ? IS NULL)
  AND (TIME(departure_datetime) <= ? OR ? IS NULL)
ORDER BY
  CASE WHEN ? = 'departure_time' THEN departure_datetime END ASC/DESC,
  CASE WHEN ? = 'price' THEN price END ASC/DESC,
  CASE WHEN ? = 'duration' THEN duration_minutes END ASC/DESC
LIMIT ? OFFSET ?
```

### 座位可用性计算逻辑

#### 实时座位计算

对于每个查询到的时刻表记录，需要计算实时的座位可用性：

1. **基础查询**:

   ```sql
   SELECT COUNT(*) as sold_seats
   FROM orders
   WHERE train_schedule_id = ?
     AND travel_date = ?
     AND status = 'PAID'
   ```

2. **可用座位计算**:
   ```
   available_seats = train_schedules.seat_count - sold_seats
   ```

#### 性能优化考虑

- **批量查询**: 对搜索结果中的所有时刻表，使用 IN 查询批量获取已售票数
- **缓存策略**: 对于热门路线，可以缓存座位可用性数据，设置较短的过期时间（如 1-5 分钟）
- **异步更新**: 在订单状态变更时，异步更新相关的座位可用性缓存

### 日期时间处理逻辑

#### 日期范围转换

用户输入的 departure_date (YYYY-MM-DD) 需要转换为完整的日期时间范围：

- **开始时间**: departure_date + ' 00:00:00'
- **结束时间**: departure_date + ' 23:59:59'

#### 时区处理

- **存储**: 数据库中的 datetime 字段统一使用 UTC 时间
- **显示**: API 响应中的时间使用 ISO 8601 格式 (YYYY-MM-DDTHH:MM:SSZ)
- **查询**: 前端传入的日期时间需要转换为 UTC 进行查询

### 分页与性能优化

#### 分页实现

- **OFFSET 方式**: 适用于小数据量和前几页的查询
- **游标分页**: 对于大数据量，考虑使用基于 ID 或时间戳的游标分页

#### 查询性能优化

1. **查询计划优化**: 确保查询使用正确的索引
2. **结果集限制**: 限制单次查询的最大结果数量
3. **字段选择**: 只查询必要的字段，避免 SELECT \*
4. **连接优化**: 座位可用性查询与主查询分离，避免复杂的 JOIN

### 错误处理与边界情况

#### 常见错误场景

1. **无搜索结果**: 返回空数组，但保持正确的响应格式
2. **日期过期**: 不允许查询过去的日期
3. **参数冲突**: 如时间范围不合理、价格范围倒置等
4. **系统异常**: 数据库连接失败、查询超时等

#### 业务规则处理

1. **列车状态过滤**: 自动排除已取消和停运的列车
2. **座位售罄处理**: 显示座位数为 0 的列车，但标注售罄状态
3. **价格显示**: 统一保留两位小数，使用字符串格式避免浮点精度问题

### 缓存策略

#### 多层缓存设计

1. **应用层缓存**: 缓存热门路线的搜索结果
2. **数据库查询缓存**: 缓存复杂的统计查询结果
3. **CDN 缓存**: 对于相对静态的时刻表数据

#### 缓存失效策略

1. **时间失效**: 搜索结果缓存 5-10 分钟
2. **事件失效**: 时刻表更新、订单变更时主动清除相关缓存
3. **版本控制**: 使用版本号管理缓存的一致性
