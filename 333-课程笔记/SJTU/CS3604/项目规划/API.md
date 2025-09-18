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
