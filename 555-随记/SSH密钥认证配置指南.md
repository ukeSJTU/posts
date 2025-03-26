## Step 1：在客户端生成密钥对

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ~/.ssh/my_custom_key
```

**参数说明：**

- `-t rsa`: 指定密钥类型为RSA（推荐使用`ed25519`更安全高效）
- `-b 4096`: 指定密钥长度（RSA建议4096位，Ed25519固定长度256位）
- `-C`: 添加注释信息（建议使用邮箱/用途标识）
- `-f`: 指定密钥存储路径（默认为`~/.ssh/id_rsa`）

**交互提示说明：**

1. 密钥保存路径建议：
   - 保持默认可直接回车
   - 自定义路径可用于多密钥场景
2. Passphrase设置建议：
   - 推荐设置增强安全性（即使密钥泄露也需要口令）
   - 空回车表示不设置（仅限测试环境使用）

> 📌 安全提示：Ed25519算法比RSA更安全高效，生成命令：  
> `ssh-keygen -t ed25519`

---

## Step 2：部署公钥到服务端

### 方法一：ssh-copy-id（推荐）

```bash
ssh-copy-id -i ~/.ssh/my_custom_key user@server_B_ip
```

- 自动完成以下操作：
  1. 创建`~/.ssh`目录（如不存在）
  2. 追加公钥到`authorized_keys`
  3. 自动设置正确权限

### 方法二：手动部署

1. 获取公钥内容：

```bash
# 显示公钥内容（复制全部输出）
cat ~/.ssh/my_custom_key.pub
```

1. 服务端操作：

```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
echo "粘贴公钥内容" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
```

> ⚠️ 权限要求：
>
> - `.ssh`目录必须为700
> - `authorized_keys`文件必须为600
> - 用户Home目录不能有写权限（建议设为755）

### 方法三：SCP传输（适合自定义路径）

```bash
scp -p ~/.ssh/my_custom_key.pub user@server_B_ip:~/
ssh user@server_B_ip "mkdir -p ~/.ssh && cat ~/my_custom_key.pub >> ~/.ssh/authorized_keys && rm ~/my_custom_key.pub"
```

---

## Step 3：使用ssh-agent管理Passphrase

### 基础使用

```bash
# 启动ssh-agent
eval "$(ssh-agent -s)"

# 添加密钥（会提示输入passphrase）
ssh-add ~/.ssh/my_custom_key

# 查看已加载密钥
ssh-add -l
```

### 高级配置

在`~/.ssh/config`中添加：

```config
Host *
  AddKeysToAgent yes
  UseKeychain yes  # macOS专用钥匙串记忆
  IdentityFile ~/.ssh/my_custom_key
```

**效果：**

- 首次使用自动加载密钥到agent
- 会话期间只需输入一次passphrase
- 重启后需要重新添加（可通过`-K`选项持久化存储）

---

## 连接验证

```bash
ssh -T -i ~/.ssh/my_custom_key user@server_B_ip
```

**排障技巧：**

1. 服务端查看日志：

```bash
sudo tail -f /var/log/auth.log
```

1. 客户端调试模式：

```bash
ssh -vvv user@server_B_ip
```

---

## 安全加固建议

1. 禁用密码登录（服务端修改`/etc/ssh/sshd_config`）：

```config
PasswordAuthentication no
ChallengeResponseAuthentication no
```

1. 修改默认SSH端口：

```config
Port 58222
```

1. 定期轮换密钥（建议每3-6个月更新）

> 🔄 密钥更新流程：
>
> 1. 生成新密钥对
> 2. 部署新公钥到服务端
> 3. 删除旧公钥
> 4. 更新所有客户端的密钥
