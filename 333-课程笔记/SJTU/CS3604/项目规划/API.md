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
