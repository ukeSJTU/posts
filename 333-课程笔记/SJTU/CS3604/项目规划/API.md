jwt方式验证

所有的api路径都是 `/api` 开头，是否需要版本号？

这个header是不是都应该是Content-Type：application/json？

## 用户模块

### 用户注册 - `POST /{apiBase}/users/register`

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

- `email` (string, required): 用户的邮箱地址，将作为登录凭证。
- `password` (string, required): 用户密码。

### **响应格式**

**成功 (`201 Created`):**

```json
{
  "id": 1,
  "email": "user@example.com",
  "balance": "1000.00",
  "created_at": "2025-09-18T08:00:00Z"
}
```

**失败:**

`400 Bad Request`: 请求体格式错误，或密码不符合安全策略。

```json
{
  "error": "Email and password are required."
}
```

`409 Conflict`: 邮箱地址已被注册。

```json
{
  "error": "Email already exists."
}
```

### **业务逻辑说明**

1. **验证输入:** 检查 `email` 和 `password` 字段是否存在且格式有效。
2. **检查邮箱唯一性:** 查询 `users` 表，确保该 `email` 没有被注册。如果已存在，则返回 `409 Conflict`。
3. **密码加密:** **严禁明文存储密码。** 在应用层使用安全的哈希算法（如 Argon2 或 bcrypt）对用户传入的 `password` 进行加密。
4. **创建用户:** 将 `email` 和加密后的密码哈希值存入 `users` 表。`balance` 默认为 `1000.00`。
5. **返回结果:** 从数据库中获取新创建的用户信息（**排除密码哈希值**），并将其作为响应体返回。
