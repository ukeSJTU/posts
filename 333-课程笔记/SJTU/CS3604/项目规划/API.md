## 基础信息

- **Base URL**: `/api`
- **认证方式**: JWT Token
- **Content-Type**: `application/json`
- **字符编码**: UTF-8

## 认证说明

除了用户注册和登录接口外，所有 API 都需要在请求头中携带 JWT Token：

```
Authorization: Bearer <jwt_token>
```

## 通用响应格式

### 成功响应

```json
{
  "success": true,
  "data": {}, // 具体数据
  "message": "Success"
}
```

### 错误响应

```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Error description"
  }
}
```

### 通用错误码

- `401 Unauthorized`: 未认证或 Token 无效
- `403 Forbidden`: 权限不足
- `404 Not Found`: 资源不存在
- `422 Unprocessable Entity`: 请求参数验证失败
- `500 Internal Server Error`: 服务器内部错误

---

## 用户模块

### 用户注册 - `POST /{apiBaseURL}/users/register`

#### 请求格式

**Headers:**

- `Content-Type: application/json`

**Body (JSON):**

```json
{
  "email": "user@example.com",
  "password": "Password123!"
}
```

**参数说明:**

- `email` (string, required): 用户邮箱地址，作为登录凭证
- `password` (string, required): 用户密码，至少 8 位，包含大小写字母和数字

#### 响应格式

**成功 (`201 Created`):**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "email": "user@example.com",
    "balance": "0.00",
    "created_at": "2024-01-15T08:00:00Z"
  },
  "message": "Registration successful"
}
```

**失败响应:**

`400 Bad Request`: 请求参数错误

```json
{
  "success": false,
  "error": {
    "code": "INVALID_PARAMS",
    "message": "邮箱格式不正确或密码不符合安全要求"
  }
}
```

`409 Conflict`: 邮箱已存在

```json
{
  "success": false,
  "error": {
    "code": "EMAIL_EXISTS",
    "message": "该邮箱已被注册"
  }
}
```

#### 业务逻辑

1. **前端验证（客户端）**
   - 验证密码格式
   - 确认密码一致性
   - 实时提示密码强度

2. **后端接收与验证**
   - 接收明文密码（通过 HTTPS 加密传输）
   - 验证请求参数完整性和格式
   - 验证邮箱格式（RFC 5322 标准）
   - 再次验证密码强度要求

3. **邮箱唯一性检查**
   - 查询`users`表中是否存在相同邮箱
   - 如果存在，返回`409 Conflict`错误
   - 考虑邮箱大小写不敏感处理

4. **密码加密处理**
   - 生成随机 Salt
   - 使用 Argon2id 算法进行 Hash
   - 将 Salt 和 Hash 值组合存储

5. **用户记录创建**
   - 插入用户记录到`users`表
   - 设置初始余额为 0.00
   - 记录创建时间戳

6. **响应处理**
   - 查询新创建的用户信息
   - **严格排除**密码 Hash 和 Salt 字段
   - 返回用户基本信息和成功状态

### 用户登录 - `POST /{apiBaseURL}/users/login`

#### 请求格式

**Body (JSON):**

```json
{
  "email": "user@example.com",
  "password": "Password123!"
}
```

#### 响应格式

**成功 (`200 OK`):**

```json
{
  "success": true,
  "data": {
    "user": {
      "id": 1,
      "email": "user@example.com",
      "balance": "1000.00"
    },
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "expires_at": "2024-01-16T08:00:00Z"
  },
  "message": "Login successful"
}
```

**失败 (`401 Unauthorized`):**

```json
{
  "success": false,
  "error": {
    "code": "INVALID_CREDENTIALS",
    "message": "Email or password is incorrect"
  }
}
```

#### 业务逻辑

1. **前端验证（客户端）**
   - 验证邮箱格式
   - 验证密码格式

2. **后端接收与验证**
   - 接收明文密码（通过 HTTPS 加密传输）
   - 验证请求参数完整性和格式
   - 查询用户记录
   - 验证密码 Hash 是否匹配

3. **JWT Token 生成**
   - 如果验证成功，生成 JWT Token
   - 设置 Token 过期时间（如 1 小时）
   - 包含用户 ID 和邮箱信息

4. **响应处理**
   - 返回用户信息、JWT Token 和过期时间
   - 严格排除密码 Hash 和 Salt 字段

### 获取用户信息 - `GET /{apiBaseURL}/users/profile`

#### 请求格式

**Headers:**

- `Authorization: Bearer <jwt_token>`

#### 响应格式

**成功 (`200 OK`):**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "email": "user@example.com",
    "balance": "1000.00",
    "created_at": "2024-01-15T08:00:00Z",
    "updated_at": "2024-01-15T10:30:00Z"
  }
}
```

#### 业务逻辑

1. **前端验证（客户端）**
   - 验证 JWT Token 存在性和有效性

2. **后端接收与验证**
   - 从请求头中提取 JWT Token
   - 验证 Token 格式和签名
   - 解码 Token 获取用户 ID 和邮箱信息

3. **数据库查询**
   - 根据用户 ID 查询`users`表中的用户记录

4. **响应处理**
   - 返回用户基本信息（不包括密码 Hash 和 Salt）
   - 处理查询失败情况（如用户不存在）

### TODO：

- `POST /api/users/refresh-token`：Token 刷新机制，当前端发现 accessToken 过期时，可以静默地（无感知地）使用 refreshToken 去请求一个新的 accessToken。
- `POST /api/users/logout`: 登出接口。虽然 JWT 是无状态的，但配合 Refresh Token 机制，登出时可以在后端将对应的 refreshToken 加入黑名单，使其失效。
- `PUT /api/users/profile`: 允许认证用户更新自己的信息（例如，如果未来增加了昵称、头像等字段）。
- `POST /api/users/change-password`: 允许已登录用户修改自己的密码（需要提供旧密码）。

## 乘车人模块

### 添加乘车人 - `POST /{apiBaseURL}/users/me/passengers`

#### 请求格式

**Headers:**

- `Authorization: Bearer <jwt_token>`
- `Content-Type: application/json`

**Body (JSON):**

```json
{
  "name": "张三",
  "id_card": "110101199001011234",
  "phone": "13800138000",
  "email": "zhangsan@example.com"
}
```

**参数说明:**

- `name` (string, required): 乘车人姓名，最长 50 字符
- `id_card` (string, required): 身份证号，18 位
- `phone` (string, optional): 手机号，最长 20 字符
- `email` (string, optional): 邮箱地址，最长 100 字符

#### 响应格式

**成功 (`201 Created`):**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "张三",
    "id_card": "110101199001011234",
    "phone": "13800138000",
    "email": "zhangsan@example.com",
    "created_at": "2024-01-15T08:00:00Z"
  },
  "message": "Passenger added successfully"
}
```

**失败响应:**

`400 Bad Request`: 请求参数错误

```json
{
  "success": false,
  "error": {
    "code": "INVALID_PARAMS",
    "message": "Name and ID card are required, please check parameter format"
  }
}
```

`409 Conflict`: 乘车人已存在

```json
{
  "success": false,
  "error": {
    "code": "PASSENGER_EXISTS",
    "message": "Passenger with this ID card already exists"
  }
}
```

#### 业务逻辑

1. **JWT Token 验证**
   - 验证请求头中的 JWT Token
   - 获取当前登录用户的 user_id

2. **参数验证**
   - 验证必填字段（name, id_card）
   - 验证身份证号格式（18 位数字/字母）
   - 验证手机号和邮箱格式（如果提供）

3. **重复性检查**
   - 查询当前用户是否已添加过该身份证号的乘车人
   - 如果存在，返回 `409 Conflict` 错误

4. **数据库操作**
   - 插入新乘车人记录到 `passengers` 表
   - 自动关联当前用户的 user_id
   - 记录创建时间戳

### 获取乘车人列表 - `GET /{apiBaseURL}/users/me/passengers`

#### 请求格式

**Headers:**

- `Authorization: Bearer <jwt_token>`

#### 响应格式

**成功 (`200 OK`):**

```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "张三",
      "id_card": "110101****1234",
      "phone": "138****8000",
      "email": "zhangsan@example.com",
      "created_at": "2024-01-15T08:00:00Z"
    },
    {
      "id": 2,
      "name": "李四",
      "id_card": "220202****5678",
      "phone": "139****9000",
      "email": "lisi@example.com",
      "created_at": "2024-01-16T09:00:00Z"
    }
  ]
}
```

#### 业务逻辑

1. **JWT Token 验证**
   - 验证请求头中的 JWT Token
   - 获取当前登录用户的 user_id

2. **数据库查询**
   - 根据 user_id 查询 `passengers` 表中的所有记录
   - 按创建时间倒序排列

3. **数据脱敏处理**
   - 身份证号脱敏：显示前 6 位和后 4 位，中间用 `****` 替代
   - 手机号脱敏：显示前 3 位和后 4 位，中间用 `****` 替代
   - 邮箱不脱敏（相对不敏感）

### 获取单个乘车人信息 - `GET /{apiBaseURL}/users/me/passengers/{id}`

#### 请求格式

**Headers:**

- `Authorization: Bearer <jwt_token>`

**路径参数:**

- `id` (integer, required): 乘车人 ID

#### 响应格式

**成功 (`200 OK`):**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "张三",
    "id_card": "110101199001011234",
    "phone": "13800138000",
    "email": "zhangsan@example.com",
    "created_at": "2024-01-15T08:00:00Z",
    "updated_at": "2024-01-15T08:00:00Z"
  }
}
```

**失败 (`404 Not Found`):**

```json
{
  "success": false,
  "error": {
    "code": "PASSENGER_NOT_FOUND",
    "message": "Passenger not found or access denied"
  }
}
```

#### 业务逻辑

1. **JWT Token 验证**
   - 验证请求头中的 JWT Token
   - 获取当前登录用户的 user_id

2. **权限验证**
   - 根据乘车人 ID 和 user_id 查询记录
   - 确保只能访问属于当前用户的乘车人

3. **完整信息返回**
   - 返回完整的乘车人信息（不脱敏）
   - 包含详细的时间戳信息

### 更新乘车人信息 - `PUT /{apiBaseURL}/users/me/passengers/{id}`

#### 请求格式

**Headers:**

- `Authorization: Bearer <jwt_token>`
- `Content-Type: application/json`

**路径参数:**

- `id` (integer, required): 乘车人 ID

**Body (JSON):**

```json
{
  "name": "张三",
  "id_card": "110101199001011234",
  "phone": "13900139000",
  "email": "zhangsan_new@example.com"
}
```

**参数说明:**

- `name` (string, required): 乘车人姓名
- `id_card` (string, required): 身份证号（允许修改）
- `phone` (string, optional): 手机号
- `email` (string, optional): 邮箱地址

#### 响应格式

**成功 (`200 OK`):**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "张三",
    "id_card": "110101199001011234",
    "phone": "13900139000",
    "email": "zhangsan_new@example.com",
    "updated_at": "2024-01-15T10:30:00Z"
  },
  "message": "Passenger information updated successfully"
}
```

**失败响应:**

`404 Not Found`: 乘车人不存在

```json
{
  "success": false,
  "error": {
    "code": "PASSENGER_NOT_FOUND",
    "message": "Passenger not found or access denied"
  }
}
```

#### 业务逻辑

1. **JWT Token 验证**
   - 验证请求头中的 JWT Token
   - 获取当前登录用户的 user_id

2. **权限验证**
   - 确保只能修改属于当前用户的乘车人

3. **参数验证**
   - 验证所有字段格式（包括身份证号）
   - 验证手机号和邮箱格式（如果提供）

4. **数据库更新**
   - 更新 `passengers` 表中的记录
   - 更新 updated_at 时间戳

### 删除乘车人 - `DELETE /{apiBaseURL}/users/me/passengers/{id}`

#### 请求格式

**Headers:**

- `Authorization: Bearer <jwt_token>`

**路径参数:**

- `id` (integer, required): 乘车人 ID

#### 响应格式

**成功 (`200 OK`):**

```json
{
  "success": true,
  "message": "Passenger deleted successfully"
}
```

**失败响应:**

`404 Not Found`: 乘车人不存在

```json
{
  "success": false,
  "error": {
    "code": "PASSENGER_NOT_FOUND",
    "message": "Passenger not found or access denied"
  }
}
```

`409 Conflict`: 存在关联订单

```json
{
  "success": false,
  "error": {
    "code": "PASSENGER_HAS_ORDERS",
    "message": "Cannot delete passenger with active orders"
  }
}
```

#### 业务逻辑

1. **JWT Token 验证**
   - 验证请求头中的 JWT Token
   - 获取当前登录用户的 user_id

2. **权限验证**
   - 确保只能删除属于当前用户的乘车人

3. **关联订单检查**
   - 查询 `orders` 表中是否存在该乘车人的活跃订单
   - 如果存在未完成订单，返回 `409 Conflict` 错误

4. **数据库删除**
   - 从 `passengers` 表中删除记录

---

## 火车时刻表模块

### 搜索火车时刻表 - `GET /{apiBaseURL}/train/schedules`

#### 请求格式

**Headers:**

- `Authorization: Bearer <jwt_token>` (可选，用于个性化功能)

**Query Parameters:**

| 参数名                 | 类型    | 必填 | 说明                                                          |
| ---------------------- | ------- | ---- | ------------------------------------------------------------- |
| `departure_city`       | string  | 是   | 出发城市                                                      |
| `arrival_city`         | string  | 是   | 到达城市                                                      |
| `departure_date`       | string  | 是   | 出发日期，格式：YYYY-MM-DD                                    |
| `train_number`         | string  | 否   | 车次编号，支持模糊搜索                                        |
| `min_price`            | number  | 否   | 最低价格筛选                                                  |
| `max_price`            | number  | 否   | 最高价格筛选                                                  |
| `departure_time_start` | string  | 否   | 出发时间范围开始，格式：HH:MM                                 |
| `departure_time_end`   | string  | 否   | 出发时间范围结束，格式：HH:MM                                 |
| `sort_by`              | string  | 否   | 排序字段，可选值：`departure_time`(默认), `price`, `duration` |
| `sort_order`           | string  | 否   | 排序方向，可选值：`asc`(默认), `desc`                         |
| `page`                 | integer | 否   | 页码，默认为 1                                                |
| `limit`                | integer | 否   | 每页数量，默认为 20，最大 100                                 |

#### 响应格式

**成功 (`200 OK`):**

```json
{
  "success": true,
  "data": {
    "schedules": [
      {
        "id": 1,
        "train_number": "G357",
        "departure_city": "北京",
        "arrival_city": "上海",
        "departure_datetime": "2024-01-20T08:00:00Z",
        "arrival_datetime": "2024-01-20T13:30:00Z",
        "duration_minutes": 330,
        "price": "553.00",
        "available_seats": 156,
        "total_seats": 200,
        "train_status": "normal"
      },
      {
        "id": 2,
        "train_number": "G159",
        "departure_city": "北京",
        "arrival_city": "上海",
        "departure_datetime": "2024-01-20T09:15:00Z",
        "arrival_datetime": "2024-01-20T14:45:00Z",
        "duration_minutes": 330,
        "price": "553.00",
        "available_seats": 89,
        "total_seats": 200,
        "train_status": "normal"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 3,
      "total_count": 45,
      "per_page": 20,
      "has_next": true,
      "has_prev": false
    }
  }
}
```

**失败响应:**

`400 Bad Request`: 请求参数错误

```json
{
  "success": false,
  "error": {
    "code": "INVALID_PARAMS",
    "message": "Departure city, arrival city and departure date are required"
  }
}
```

`422 Unprocessable Entity`: 参数格式错误

```json
{
  "success": false,
  "error": {
    "code": "INVALID_DATE_FORMAT",
    "message": "Departure date must be in YYYY-MM-DD format"
  }
}
```

#### 业务逻辑

1. **参数验证**
   - 验证必填参数（departure_city, arrival_city, departure_date）
   - 验证日期格式和有效性
   - 验证价格范围参数（min_price <= max_price）
   - 验证时间格式（HH:MM）
   - 验证分页参数（page >= 1, limit <= 100）

2. **日期处理**
   - 将 departure_date 转换为对应的 datetime 范围
   - 支持查询当天 00:00:00 到 23:59:59 的所有班次

3. **数据库查询**
   - 根据出发城市、到达城市和日期范围查询 `train_schedules` 表
   - 应用可选的筛选条件（车次、价格、时间范围）
   - 排除已取消或停运的列车（train_status != 'cancelled' AND train_status != 'suspended'）

4. **座位可用性计算**
   - 对每个时刻表记录，查询 `orders` 表统计已售票数
   - 计算可用座位数：total_seats - 已售出座位数
   - 统计状态为 'PAID' 和 'PENDING_PAYMENT' 的订单

5. **结果排序和分页**
   - 根据 sort_by 和 sort_order 参数排序
   - 应用分页逻辑
   - 返回分页元数据

### 获取单个火车时刻表详情 - `GET /{apiBaseURL}/train/schedules/{id}`

#### 请求格式

**Headers:**

- `Authorization: Bearer <jwt_token>` (可选)

**路径参数:**

| 参数名 | 类型    | 必填 | 说明          |
| ------ | ------- | ---- | ------------- |
| `id`   | integer | 是   | 火车时刻表 ID |

**Query Parameters:**

| 参数名        | 类型   | 必填 | 说明                                                   |
| ------------- | ------ | ---- | ------------------------------------------------------ |
| `travel_date` | string | 否   | 乘车日期，格式：YYYY-MM-DD，用于计算该日期的座位可用性 |

#### 响应格式

**成功 (`200 OK`):**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "train_number": "G357",
    "departure_city": "北京",
    "arrival_city": "上海",
    "departure_datetime": "2024-01-20T08:00:00Z",
    "arrival_datetime": "2024-01-20T13:30:00Z",
    "duration_minutes": 330,
    "price": "553.00",
    "total_seats": 200,
    "available_seats": 156,
    "train_status": "normal",
    "created_at": "2024-01-15T08:00:00Z",
    "updated_at": "2024-01-15T08:00:00Z"
  }
}
```

**失败 (`404 Not Found`):**

```json
{
  "success": false,
  "error": {
    "code": "SCHEDULE_NOT_FOUND",
    "message": "Train schedule not found"
  }
}
```

#### 业务逻辑

1. **参数验证**
   - 验证时刻表 ID 是否为有效整数
   - 验证 travel_date 格式（如果提供）

2. **数据库查询**
   - 根据 ID 查询 `train_schedules` 表
   - 如果记录不存在，返回 404 错误

3. **座位可用性计算**
   - 如果提供了 travel_date，计算该日期的座位可用性
   - 如果未提供 travel_date，使用时刻表的 departure_datetime 日期
   - 查询对应日期的已售票数量

4. **响应处理**
   - 返回完整的时刻表信息
   - 包含实时的座位可用性数据

### 管理员创建火车时刻表 - `POST /{apiBaseURL}/admin/train/schedules`

#### 请求格式

**Headers:**

- `Authorization: Bearer <jwt_token>`
- `Content-Type: application/json`

**Body (JSON):**

```json
{
  "train_number": "G357",
  "departure_city": "北京",
  "arrival_city": "上海",
  "departure_datetime": "2024-01-20T08:00:00Z",
  "arrival_datetime": "2024-01-20T13:30:00Z",
  "price": "553.00",
  "seat_count": 200
}
```

**参数说明:**

| 参数名               | 类型    | 必填 | 说明                        |
| -------------------- | ------- | ---- | --------------------------- |
| `train_number`       | string  | 是   | 车次编号，最长 10 字符      |
| `departure_city`     | string  | 是   | 出发城市，最长 50 字符      |
| `arrival_city`       | string  | 是   | 到达城市，最长 50 字符      |
| `departure_datetime` | string  | 是   | 出发日期时间，ISO 8601 格式 |
| `arrival_datetime`   | string  | 是   | 到达日期时间，ISO 8601 格式 |
| `price`              | number  | 是   | 票价，精确到分              |
| `seat_count`         | integer | 是   | 座位总数，必须大于 0        |

#### 响应格式

**成功 (`201 Created`):**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "train_number": "G357",
    "departure_city": "北京",
    "arrival_city": "上海",
    "departure_datetime": "2024-01-20T08:00:00Z",
    "arrival_datetime": "2024-01-20T13:30:00Z",
    "duration_minutes": 330,
    "price": "553.00",
    "seat_count": 200,
    "train_status": "normal",
    "created_at": "2024-01-15T08:00:00Z"
  },
  "message": "Train schedule created successfully"
}
```

**失败响应:**

`400 Bad Request`: 请求参数错误

```json
{
  "success": false,
  "error": {
    "code": "INVALID_PARAMS",
    "message": "Arrival time must be after departure time"
  }
}
```

`409 Conflict`: 时刻表已存在

```json
{
  "success": false,
  "error": {
    "code": "SCHEDULE_EXISTS",
    "message": "Train schedule for this train number and departure time already exists"
  }
}
```

#### 业务逻辑

1. **管理员权限验证**
   - 验证 JWT Token 中的用户权限
   - 确保只有管理员可以创建时刻表

2. **参数验证**
   - 验证所有必填字段
   - 验证日期时间格式和有效性
   - 验证到达时间晚于出发时间
   - 验证价格和座位数为正数

3. **重复性检查**
   - 检查相同车次和出发时间的记录是否已存在
   - 如果存在，返回 409 错误

4. **自动计算字段**
   - 计算 duration_minutes（到达时间 - 出发时间）
   - 设置默认 train_status 为 'normal'

5. **数据库操作**
   - 插入新记录到 `train_schedules` 表
   - 返回创建的记录信息

### 管理员更新火车时刻表 - `PUT /{apiBaseURL}/admin/train/schedules/{id}`

#### 请求格式

**Headers:**

- `Authorization: Bearer <jwt_token>`
- `Content-Type: application/json`

**路径参数:**

| 参数名 | 类型    | 必填 | 说明          |
| ------ | ------- | ---- | ------------- |
| `id`   | integer | 是   | 火车时刻表 ID |

**Body (JSON):**

```json
{
  "train_number": "G357",
  "departure_city": "北京",
  "arrival_city": "上海",
  "departure_datetime": "2024-01-20T08:00:00Z",
  "arrival_datetime": "2024-01-20T13:30:00Z",
  "price": "553.00",
  "seat_count": 200,
  "train_status": "normal"
}
```

#### 响应格式

**成功 (`200 OK`):**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "train_number": "G357",
    "departure_city": "北京",
    "arrival_city": "上海",
    "departure_datetime": "2024-01-20T08:00:00Z",
    "arrival_datetime": "2024-01-20T13:30:00Z",
    "duration_minutes": 330,
    "price": "553.00",
    "seat_count": 200,
    "train_status": "normal",
    "updated_at": "2024-01-15T10:30:00Z"
  },
  "message": "Train schedule updated successfully"
}
```

#### 业务逻辑

1. **管理员权限验证**
   - 验证 JWT Token 中的用户权限

2. **存在性检查**
   - 验证时刻表 ID 是否存在

3. **参数验证**
   - 验证更新字段的格式和有效性
   - 特别注意时间逻辑的一致性

4. **影响评估**
   - 检查是否有已售出的票
   - 如果有重大变更（如时间、价格），可能需要特殊处理

5. **数据库更新**
   - 更新 `train_schedules` 表记录
   - 重新计算 duration_minutes

### 管理员删除火车时刻表 - `DELETE /{apiBaseURL}/admin/train/schedules/{id}`

#### 请求格式

**Headers:**

- `Authorization: Bearer <jwt_token>`

**路径参数:**

| 参数名 | 类型    | 必填 | 说明          |
| ------ | ------- | ---- | ------------- |
| `id`   | integer | 是   | 火车时刻表 ID |

#### 响应格式

**成功 (`200 OK`):**

```json
{
  "success": true,
  "message": "Train schedule deleted successfully"
}
```

**失败响应:**

`409 Conflict`: 存在关联订单

```json
{
  "success": false,
  "error": {
    "code": "SCHEDULE_HAS_ORDERS",
    "message": "Cannot delete train schedule with existing orders"
  }
}
```

#### 业务逻辑

1. **管理员权限验证**
   - 验证 JWT Token 中的用户权限

2. **存在性检查**
   - 验证时刻表 ID 是否存在

3. **关联订单检查**
   - 查询 `orders` 表中是否存在该时刻表的订单
   - 如果存在订单，返回 409 错误

4. **数据库删除**
   - 从 `train_schedules` 表中删除记录

---

## 订单模块

### 创建订单 - `POST /{apiBaseURL}/orders`

#### 请求格式

**Headers:**

- `Authorization: Bearer <jwt_token>`
- `Content-Type: application/json`

**Body (JSON):**

```json
{
  "train_schedule_id": 1,
  "passenger_id": 2,
  "travel_date": "2024-01-20"
}
```

**参数说明:**

- `train_schedule_id` (integer, required): 火车时刻表 ID
- `passenger_id` (integer, required): 乘车人 ID，必须属于当前用户
- `travel_date` (string, required): 乘车日期，格式：YYYY-MM-DD

#### 响应格式

**成功 (`201 Created`):**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "order_number": "TK2024012012345678",
    "train_schedule_id": 1,
    "buyer_id": 1,
    "passenger_id": 2,
    "price": "553.00",
    "status": "PENDING_PAYMENT",
    "travel_date": "2024-01-20",
    "train_info": {
      "train_number": "G357",
      "departure_city": "北京",
      "arrival_city": "上海",
      "departure_datetime": "2024-01-20T08:00:00Z",
      "arrival_datetime": "2024-01-20T13:30:00Z"
    },
    "passenger_info": {
      "name": "张三",
      "id_card": "110101****1234"
    },
    "created_at": "2024-01-20T07:30:00Z"
  },
  "message": "Order created successfully"
}
```

**失败响应:**

`400 Bad Request`: 请求参数错误

```json
{
  "success": false,
  "error": {
    "code": "INVALID_PARAMS",
    "message": "Train schedule ID, passenger ID and travel date are required"
  }
}
```

`403 Forbidden`: 乘车人不属于当前用户

```json
{
  "success": false,
  "error": {
    "code": "PASSENGER_ACCESS_DENIED",
    "message": "You can only create orders for your own passengers"
  }
}
```

`404 Not Found`: 火车时刻表不存在

```json
{
  "success": false,
  "error": {
    "code": "SCHEDULE_NOT_FOUND",
    "message": "Train schedule not found"
  }
}
```

`409 Conflict`: 座位不足

```json
{
  "success": false,
  "error": {
    "code": "NO_SEATS_AVAILABLE",
    "message": "No seats available for this train"
  }
}
```

`422 Unprocessable Entity`: 乘车日期无效

```json
{
  "success": false,
  "error": {
    "code": "INVALID_TRAVEL_DATE",
    "message": "Travel date must be today or in the future"
  }
}
```

#### 业务逻辑

1. **JWT Token 验证**
   - 验证请求头中的 JWT Token
   - 获取当前登录用户的 user_id 作为 buyer_id

2. **参数验证**
   - 验证必填字段完整性
   - 验证 travel_date 格式和有效性（不能是过去的日期）
   - 验证 train_schedule_id 和 passenger_id 为有效整数

3. **权限验证**
   - 查询 passengers 表验证 passenger_id 是否属于当前用户
   - 如果不属于，返回 403 错误

4. **火车时刻表验证**
   - 根据 train_schedule_id 查询 train_schedules 表
   - 验证时刻表存在且状态正常（非取消或停运）
   - 如果不存在，返回 404 错误

5. **座位可用性检查**
   - 统计该时刻表在指定日期的已售票数（状态为 PAID 和 PENDING_PAYMENT）
   - 计算可用座位：seat_count - 已售票数
   - 如果无可用座位，返回 409 错误

6. **订单编号生成**
   - 按照 `TK + YYYYMMDD + 8位流水号` 格式生成唯一订单编号
   - 确保订单编号在数据库中唯一

7. **数据库操作**
   - 在事务中创建订单记录
   - 设置初始状态为 PENDING_PAYMENT
   - 记录当前时刻表的价格到订单中

8. **响应处理**
   - 查询并返回完整的订单信息
   - 包含关联的火车时刻表和乘车人信息（脱敏处理）

**注意事项:**

- MVP 阶段不支持批量创建订单，用户需要为每个乘车人分别调用此 API
- 订单创建后有 10 分钟的支付时限，超时将自动取消并释放座位

### 获取用户订单列表 - `GET /{apiBaseURL}/users/me/orders`

#### 请求格式

**Headers:**

- `Authorization: Bearer <jwt_token>`

**Query Parameters:**

| 参数名       | 类型    | 必填 | 说明                                                                     |
| ------------ | ------- | ---- | ------------------------------------------------------------------------ |
| `status`     | string  | 否   | 订单状态筛选，可选值：`PENDING_PAYMENT`, `CANCELLED`, `PAID`, `REFUNDED` |
| `start_date` | string  | 否   | 乘车日期范围开始，格式：YYYY-MM-DD                                       |
| `end_date`   | string  | 否   | 乘车日期范围结束，格式：YYYY-MM-DD                                       |
| `sort_by`    | string  | 否   | 排序字段，可选值：`created_at`(默认), `travel_date`                      |
| `sort_order` | string  | 否   | 排序方向，可选值：`desc`(默认), `asc`                                    |
| `page`       | integer | 否   | 页码，默认为 1                                                           |
| `limit`      | integer | 否   | 每页数量，默认为 20，最大 100                                            |

#### 响应格式

**成功 (`200 OK`):**

```json
{
  "success": true,
  "data": {
    "orders": [
      {
        "id": 1,
        "order_number": "TK2024012012345678",
        "train_schedule_id": 1,
        "price": "553.00",
        "status": "PAID",
        "travel_date": "2024-01-20",
        "train_info": {
          "train_number": "G357",
          "departure_city": "北京",
          "arrival_city": "上海",
          "departure_datetime": "2024-01-20T08:00:00Z",
          "arrival_datetime": "2024-01-20T13:30:00Z"
        },
        "passenger_info": {
          "name": "张三",
          "id_card": "110101****1234"
        },
        "created_at": "2024-01-20T07:30:00Z",
        "updated_at": "2024-01-20T07:35:00Z"
      },
      {
        "id": 2,
        "order_number": "TK2024012112345679",
        "train_schedule_id": 2,
        "price": "553.00",
        "status": "PENDING_PAYMENT",
        "travel_date": "2024-01-21",
        "train_info": {
          "train_number": "G159",
          "departure_city": "北京",
          "arrival_city": "上海",
          "departure_datetime": "2024-01-21T09:15:00Z",
          "arrival_datetime": "2024-01-21T14:45:00Z"
        },
        "passenger_info": {
          "name": "李四",
          "id_card": "220202****5678"
        },
        "created_at": "2024-01-21T08:00:00Z",
        "updated_at": "2024-01-21T08:00:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "total_pages": 2,
      "total_count": 25,
      "per_page": 20,
      "has_next": true,
      "has_prev": false
    }
  }
}
```

#### 业务逻辑

1. **JWT Token 验证**
   - 验证请求头中的 JWT Token
   - 获取当前登录用户的 user_id

2. **参数验证**
   - 验证可选参数的格式和有效性
   - 验证日期范围（start_date <= end_date）
   - 验证分页参数（page >= 1, limit <= 100）

3. **数据库查询**
   - 根据 buyer_id 查询当前用户的所有订单
   - 应用状态筛选和日期范围筛选
   - 关联查询 train_schedules 和 passengers 表获取详细信息

4. **数据脱敏处理**
   - 乘车人身份证号脱敏显示
   - 其他敏感信息按需脱敏

5. **结果排序和分页**
   - 根据 sort_by 和 sort_order 参数排序
   - 应用分页逻辑并返回分页元数据

### 获取订单详情 - `GET /{apiBaseURL}/orders/{id}`

#### 请求格式

**Headers:**

- `Authorization: Bearer <jwt_token>`

**路径参数:**

- `id` (integer, required): 订单 ID

#### 响应格式

**成功 (`200 OK`):**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "order_number": "TK2024012012345678",
    "train_schedule_id": 1,
    "buyer_id": 1,
    "passenger_id": 2,
    "price": "553.00",
    "status": "PAID",
    "travel_date": "2024-01-20",
    "train_info": {
      "id": 1,
      "train_number": "G357",
      "departure_city": "北京",
      "arrival_city": "上海",
      "departure_datetime": "2024-01-20T08:00:00Z",
      "arrival_datetime": "2024-01-20T13:30:00Z",
      "duration_minutes": 330
    },
    "passenger_info": {
      "id": 2,
      "name": "张三",
      "id_card": "110101199001011234",
      "phone": "13800138000",
      "email": "zhangsan@example.com"
    },
    "buyer_info": {
      "id": 1,
      "email": "buyer@example.com"
    },
    "created_at": "2024-01-20T07:30:00Z",
    "updated_at": "2024-01-20T07:35:00Z"
  }
}
```

**失败 (`404 Not Found`):**

```json
{
  "success": false,
  "error": {
    "code": "ORDER_NOT_FOUND",
    "message": "Order not found or access denied"
  }
}
```

#### 业务逻辑

1. **JWT Token 验证**
   - 验证请求头中的 JWT Token
   - 获取当前登录用户的 user_id

2. **权限验证**
   - 根据订单 ID 查询订单记录
   - 验证订单的 buyer_id 是否为当前用户
   - 如果不匹配或订单不存在，返回 404 错误

3. **关联数据查询**
   - 查询关联的火车时刻表详细信息
   - 查询关联的乘车人完整信息（不脱敏）
   - 查询购票人基本信息

4. **完整信息返回**
   - 返回订单的所有详细信息
   - 包含完整的关联数据，便于用户查看和管理

### 支付订单 - `POST /{apiBaseURL}/orders/{id}/pay`

#### 请求格式

**Headers:**

- `Authorization: Bearer <jwt_token>`
- `Content-Type: application/json`

**路径参数:**

- `id` (integer, required): 订单 ID

**Body (JSON):**

```json
{
  "payment_method": "balance"
}
```

**参数说明:**

- `payment_method` (string, required): 支付方式，当前只支持 "balance"（账户余额）

#### 响应格式

**成功 (`200 OK`):**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "order_number": "TK2024012012345678",
    "status": "PAID",
    "price": "553.00",
    "payment_method": "balance",
    "paid_at": "2024-01-20T07:35:00Z",
    "remaining_balance": "447.00"
  },
  "message": "Payment successful"
}
```

**失败响应:**

`400 Bad Request`: 订单状态不允许支付

```json
{
  "success": false,
  "error": {
    "code": "INVALID_ORDER_STATUS",
    "message": "Only pending payment orders can be paid"
  }
}
```

`402 Payment Required`: 余额不足

```json
{
  "success": false,
  "error": {
    "code": "INSUFFICIENT_BALANCE",
    "message": "Insufficient account balance"
  }
}
```

`404 Not Found`: 订单不存在

```json
{
  "success": false,
  "error": {
    "code": "ORDER_NOT_FOUND",
    "message": "Order not found or access denied"
  }
}
```

#### 业务逻辑

1. **JWT Token 验证**
   - 验证请求头中的 JWT Token
   - 获取当前登录用户的 user_id

2. **订单验证**
   - 根据订单 ID 查询订单记录
   - 验证订单属于当前用户（buyer_id 匹配）
   - 验证订单状态为 PENDING_PAYMENT
   - 如果订单不存在或状态不正确，返回相应错误

3. **余额验证**
   - 查询用户当前账户余额
   - 验证余额是否足够支付订单金额
   - 如果余额不足，返回 402 错误

4. **支付处理（数据库事务）**
   - 开始数据库事务
   - 扣减用户账户余额
   - 更新订单状态为 PAID
   - 记录支付时间戳
   - 提交事务

5. **响应处理**
   - 返回支付成功信息
   - 包含订单状态和用户剩余余额

### 取消订单 - `POST /{apiBaseURL}/orders/{id}/cancel`

#### 请求格式

**Headers:**

- `Authorization: Bearer <jwt_token>`
- `Content-Type: application/json`

**路径参数:**

- `id` (integer, required): 订单 ID

#### 响应格式

**成功 (`200 OK`):**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "order_number": "TK2024012012345678",
    "status": "CANCELLED",
    "cancelled_at": "2024-01-20T07:40:00Z"
  },
  "message": "Order cancelled successfully"
}
```

**失败响应:**

`400 Bad Request`: 订单状态不允许取消

```json
{
  "success": false,
  "error": {
    "code": "INVALID_ORDER_STATUS",
    "message": "Only pending payment orders can be cancelled"
  }
}
```

`404 Not Found`: 订单不存在

```json
{
  "success": false,
  "error": {
    "code": "ORDER_NOT_FOUND",
    "message": "Order not found or access denied"
  }
}
```

#### 业务逻辑

1. **JWT Token 验证**
   - 验证请求头中的 JWT Token
   - 获取当前登录用户的 user_id

2. **订单验证**
   - 根据订单 ID 查询订单记录
   - 验证订单属于当前用户（buyer_id 匹配）
   - 验证订单状态为 PENDING_PAYMENT
   - 如果订单不存在或状态不正确，返回相应错误

3. **取消处理**
   - 更新订单状态为 CANCELLED
   - 记录取消时间戳
   - 释放占用的座位（供其他用户购买）

4. **响应处理**
   - 返回取消成功信息
   - 包含更新后的订单状态

### 申请退款 - `POST /{apiBaseURL}/orders/{id}/refund`

#### 请求格式

**Headers:**

- `Authorization: Bearer <jwt_token>`
- `Content-Type: application/json`

**路径参数:**

- `id` (integer, required): 订单 ID

**Body (JSON):**

```json
{
  "reason": "行程变更"
}
```

**参数说明:**

- `reason` (string, optional): 退款原因，最长 200 字符

#### 响应格式

**成功 (`200 OK`):**

```json
{
  "success": true,
  "data": {
    "id": 1,
    "order_number": "TK2024012012345678",
    "status": "REFUNDED",
    "refund_amount": "553.00",
    "refunded_at": "2024-01-19T15:30:00Z",
    "current_balance": "1553.00"
  },
  "message": "Refund processed successfully"
}
```

**失败响应:**

`400 Bad Request`: 订单状态不允许退款

```json
{
  "success": false,
  "error": {
    "code": "INVALID_ORDER_STATUS",
    "message": "Only paid orders can be refunded"
  }
}
```

`400 Bad Request`: 超过退款时限

```json
{
  "success": false,
  "error": {
    "code": "REFUND_TIME_EXPIRED",
    "message": "Cannot refund after train departure time"
  }
}
```

`404 Not Found`: 订单不存在

```json
{
  "success": false,
  "error": {
    "code": "ORDER_NOT_FOUND",
    "message": "Order not found or access denied"
  }
}
```

#### 业务逻辑

1. **JWT Token 验证**
   - 验证请求头中的 JWT Token
   - 获取当前登录用户的 user_id

2. **订单验证**
   - 根据订单 ID 查询订单记录
   - 验证订单属于当前用户（buyer_id 匹配）
   - 验证订单状态为 PAID
   - 如果订单不存在或状态不正确，返回相应错误

3. **退款时限验证**
   - 查询关联的火车时刻表信息
   - 验证当前时间是否在火车发车时间之前
   - 如果已过发车时间，返回 400 错误

4. **退款处理（数据库事务）**
   - 开始数据库事务
   - 将订单金额退回到用户账户余额
   - 更新订单状态为 REFUNDED
   - 记录退款时间戳和退款原因
   - 释放占用的座位
   - 提交事务

5. **响应处理**
   - 返回退款成功信息
   - 包含退款金额和用户当前余额
