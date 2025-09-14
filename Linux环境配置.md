## apt换镜像源

aliyun: https://developer.aliyun.com/mirror/ubuntu

```bash
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak
sudo vim /etc/apt/sources.list
# 然后按照镜像源文档里面的内容放进去
# ...
# 保存文件
sudo apt update
```

```plaintext
# ubuntu 24.04(noble)
deb https://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ noble main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ noble-security main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ noble-security main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ noble-updates main restricted universe multiverse

# deb https://mirrors.aliyun.com/ubuntu/ noble-proposed main restricted universe multiverse
# deb-src https://mirrors.aliyun.com/ubuntu/ noble-proposed main restricted universe multiverse

deb https://mirrors.aliyun.com/ubuntu/ noble-backports main restricted universe multiverse
deb-src https://mirrors.aliyun.com/ubuntu/ noble-backports main restricted universe multiverse
```

## Bash -> Zsh

```bash
sudo apt install zsh
chsh -s $(which zsh)
```

## Shell增强工具

```bash
sudo apt install -y \
tmux \
htop \
tree \
unzip \
zip \
jq \
bat \
fd-find \
ripgrep
```

## Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

镜像下载办法参考教程：https://developer.aliyun.com/mirror/homebrew/
如下：

```bash
# 从阿里云下载安装脚本并安装 Homebrew git clone https://mirrors.aliyun.com/homebrew/install.git brew-install /bin/bash brew-install/install.sh rm -rf brew-install # 也可从 GitHub 获取官方安装脚本安装 Homebrew /bin/bash -c "$(curl -fsSL https://github.com/Homebrew/install/raw/master/install.sh)"
```

## 开发环境

### Python

uv
