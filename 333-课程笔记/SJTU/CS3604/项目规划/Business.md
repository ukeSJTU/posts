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
