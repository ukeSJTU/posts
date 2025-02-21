两台电脑，规定发起ssh连接的是client客户端A，接受连接的是server服务端B。
## Step 1 在客户端上生成密钥对
```bash
ssh-keygen -t rsa -b 4096
```

• -t rsa: Specifies the type of key to generate (RSA in this case).

• -b 4096: Specifies the size of the key (4096 bits is recommended for security).

You will be prompted for the following:
- 密钥文件保存在哪里
- 输入passphrase


## Step 2 拷贝公钥到服务端

### method 1
```bash
ssh-copy-id user@server_B_ip
```

### method 2
1. 拷贝公钥的内容
```bash
cat ~/.ssh/id_rsa.pub
```
2. 创建~/.ssh文件夹
```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
```
1. 增加
```bash
echo "your-public-key-here" >> ~/.ssh/authorized_keys
```

chmod 600 ~/.ssh/authorized_keys

### method 3
如果你创建的时候添加了passphrase