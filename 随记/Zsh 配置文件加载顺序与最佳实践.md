## 常见场景分析

### 场景一：直接打开终端软件（交互式登录 shell）

加载顺序：

1. `.zshenv`
2. `.zprofile`
3. `.zshrc`
4. `.zlogin`

### 场景二：SSH 远程登录（交互式登录 shell）

加载顺序：

1. `.zshenv`
2. `.zprofile`
3. `.zshrc`
4. `.zlogin`

### 场景三：执行脚本（非交互式非登录 shell）

加载顺序：

1. 仅 `.zshenv`

### 场景四：`zsh -c "命令"`（非交互式非登录 shell）

加载顺序：

1. 仅 `.zshenv`

### 场景五：新建子 shell（交互式非登录 shell）

加载顺序：

1. `.zshenv`
2. `.zshrc`

## 配置文件最佳实践

### 应放在 `.zshenv` 中的内容

- 影响所有 shell 会话的环境变量（PATH、EDITOR 等）
- 对所有场景都需要的设置
- 例如：
  ```zsh
  export PATH=$HOME/bin:$PATH
  export EDITOR=vim
  export LANG=zh_CN.UTF-8
  ```

### 应放在 `.zprofile` 中的内容

- 只在登录时执行一次的命令
- 启动图形界面相关的设置
- 只需在登录时设置一次的环境变量
- 例如：

  ```zsh
  # 启动 X 服务器
  [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx

  # 登录时显示系统信息
  uname -a
  ```

### 应放在 `.zshrc` 中的内容

- 交互式 shell 的设置
- 命令别名和函数
- 提示符设置
- 命令补全配置
- 历史记录设置
- 插件配置（如 oh-my-zsh）
- 例如：

  ```zsh
  # 别名
  alias ls='ls --color=auto'
  alias ll='ls -la'
  alias reload='source ~/.zshrc'

  # 提示符
  PROMPT='%F{green}%n@%m%f:%F{blue}%~%f$ '

  # 历史记录
  HISTSIZE=10000
  SAVEHIST=10000
  HISTFILE=~/.zsh_history
  ```

### 应放在 `.zlogin` 中的内容

- 登录后需要执行的命令
- 通常较少使用
- 例如：

  ```zsh
  # 显示日历
  cal

  # 显示待办事项
  cat ~/.todo
  ```

## 结论

1. **环境变量**：放在 `.zshenv` 中
2. **登录时执行一次的命令**：放在 `.zprofile` 中
3. **交互式 shell 设置**（别名、函数、提示符等）：放在 `.zshrc` 中
4. **登录后的欢迎信息或状态展示**：放在 `.zlogin` 中

重新加载配置的别名应放在 `.zshrc` 中：

```zsh
# 重新加载 .zshrc
alias reload="source ~/.zshrc"

# 重新加载 .zshenv（如有需要）
alias reload-env="source ~/.zshenv"
```

这样组织配置文件可以确保正确的加载顺序，并使配置更加模块化和易于维护。
