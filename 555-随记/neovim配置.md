lazy.nvim 作为插件管理器，安装了git，neovim，lua，luarocks

配置lazynvim前，先安装luarocks（别的都下载好了）

```bash
brew update
brew install luarocks
```

按照官方教程配置后启动neovim：`nvim`，假如显示：

```text
Error detected while processing ~/.config/nvim/init.lua: No specs found for module "plugins"
```

这是因为plugins文件夹下缺少文件，先随便放一个`~/.config/nvim/lua/plugins/init.lua`:

```text
return {

}
```

这样应该就解决了。正确启动后：

配置后，运行`:checkhealth lazy`先是结果如下：

```text
lazy.nvim ~
- {lazy.nvim} version `11.17.1`
- ✅ OK {git} `version 2.39.5 (Apple Git-154)`
- ✅ OK no existing packages found by other package managers
- ✅ OK packer_compiled.lua not found

luarocks ~
- checking `luarocks` installation
- ✅ OK no plugins require `luarocks`, so you can ignore any warnings below
- ✅ OK {luarocks} `/opt/homebrew/bin/luarocks 3.12.2`
- ⚠️ WARNING `lua` version `5.1` needed, but found `Lua 5.4.8  Copyright (C) 1994-2025 Lua.org, PUC-Rio`
- ⚠️ WARNING {lua5.1} or {lua} or {lua-5.1} version `5.1` not installed
```

```text
tree nvim
nvim
├── init.lua
└── lua
    ├── config
    │   └── lazy.lua
    └── plugins
        └── init.lua

4 directories, 3 files
```

### Kickstart

https://github.com/nvim-lua/kickstart.nvim

设置基本的目录结构，安装lazynvim作为插件管理器，并且提供常用的vim配置。

---

教程里面用的colorscheme是tokyonight，我更喜欢monokai这个颜色主题，按照：https://github.com/loctvl842/monokai-pro.nvim 进行配置。

colorscheme.lua文件：

```lua
return {
    {
        "loctvl842/monokai-pro.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        lazy = false,
        priority = 1000,
        config = function(_, opts)
            require("monokai-pro").setup(opts)
            vim.cmd.colorscheme("monokai-pro")
        end,
    }
}
```

如果你和一样临时用vscode进行编辑lua配置文件，并且vim下方总是有橙黄色squiggles的话，可以`.vscode/settings.json`:

```json
{
  "Lua.diagnostics.globals": ["vim"]
}
```

---

### Mini Icons

vs _nvim_-_web_-_devicons_

---

## which-key

---

下面安装snacks.nvim

如果你启用snacks.nvim的时候遇到报错：

```text
Terminal **cmd** `colorscript -e square` failed with code `1`: - `vim.o.shell = "/bin/zsh"`
```

解决步骤：

```bash
cd /tmp
git clone https://gitlab.com/dwt1/shell-color-scripts.git
cd shell-color-scripts
sudo cp colorscript.sh /usr/local/bin/colorscript
sudo chmod +x /usr/local/bin/colorscript
sudo cp -r colorscripts /opt/shell-color-scripts/colorscripts
```

然后snacks自己提供了很多QoL的插件，我更倾向于每个文件配置一个单独的文件，因此文件结构：

```bash
tree ./lua/plugins/snacks
./lua/plugins/snacks
├── dashboard.lua
└── init.lua

1 directory, 2 files
```

我会推荐的集中字体风格：
https://www.patorjk.com/software/taag/#p=display&f=ANSI%20Shadow&t=TYPE%20SOMETHING

```text
-- BlurVision ASCII

-- Chiseled

-- ANSI Shadow
```

先配置了dashboard

然后gitbrowse

---

如果安装了Mason但是Ctrl-f按照语言选择的时候看起来界面只有数字标号和对应的内容，可以参考：

https://www.reddit.com/r/neovim/comments/152pxd8/weekly_stupid_questions_thread/

或者 https://github.com/NvChad/NvChad/discussions/2939 但是我也不知道为什么，这个dressing有啥用？

```text


Failed to run `config` for nvim-lspconfig

/Users/uke/.config/nvim/lua/plugins/mason.lua:46: attempt to call field 'setup_handlers' (a nil value)

# stacktrace:
  - ~/.config/nvim/lua/plugins/mason.lua:46 _in_ **config**
  - ~/.config/nvim/lua/config/lazy.lua:25
  - ~/.config/nvim/init.lua:138
```
