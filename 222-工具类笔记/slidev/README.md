# Sli.dev 学习笔记

所有的标题都可以通过点击跳转到官方文档相应的位置

Slidev 是一个为开发者设计的、基于 Web 的幻灯片制作和演示工具。它允许用户使用 Markdown 语法专注于内容创作，同时利用 Vue、Vite 和 UnoCSS 等 Web 技术，实现像素级完美的设计、丰富的交互性和高度的可定制性，旨在提供比传统 WYSIWYG 工具更灵活、更具表现力的演示文稿创建体验 。本笔记根据 Sli.dev 官方文档整理，旨在提供一份快速参考指南。

## 为什么用 Slidev？

Slidev 专为开发者设计，旨在提供一种既简单又强大的演示文稿创建方式，其核心优势和独特功能点体现在以下几个方面 ：

- **📝 基于 Markdown:** 采用扩展的 Markdown 格式，允许用户在单个纯文本文件中组织幻灯片，便于版本控制（如 Git）和使用熟悉的编辑器 。这种方式让内容创作回归简单，同时通过特定语法扩展实现复杂功能。
- **🧑‍💻 开发者友好:** 对代码片段提供一流支持，使用([https://github.com/shikijs/shiki](https://github.com/shikijs/shiki)) 进行准确的语法高亮 。支持 Shiki Magic Move 和 TwoSlash 集成等高级功能，非常适合技术分享 。
- **🎨 可定制主题:** 通过 npm 包轻松应用和切换主题，官方和社区提供了丰富的主题选择 。主题不仅控制外观，还可以提供自定义布局和组件 。
- **⚡️ 快速:** 基于 [Vite](https://vitejs.dev/) 构建，利用其 HMR（热模块替换）功能，实现编辑时的即时预览更新，无需手动刷新浏览器 。
- **🤹 交互性与表现力:** 允许在幻灯片中嵌入和使用 Vue 组件，实现丰富的交互效果 。内置 Monaco 编辑器支持，可在幻灯片中进行实时编码演示 。
- **✨ 渐进式:** 可以从一个简单的 Markdown 文件开始，根据需要逐步引入内置功能、主题和插件，无需复杂的初始配置 。
- **🎥 录制支持:** 内置录制功能和摄像头视图，方便分享带有演讲者画面的演示或分别录制屏幕和摄像头 。
- **📤 便携性:** 可通过简单命令将幻灯片导出为多种格式（PDF、PPTX、PNG）或可部署的单页应用（SPA），易于分享和托管 。
- **🛠️ 可扩展与 Hackable:** 基于 Web 技术构建，理论上任何 Web 应用能实现的功能都可集成到幻灯片中，如 WebGL、API 请求、iframe 等 。提供插件（Addons）机制进一步扩展功能 。
- **开源与社区:** 作为一个活跃的开源项目，拥有强大的社区支持，不断迭代和完善 。

相较于 Reveal.js 或 Marp 等其他工具，Slidev 在保持 Markdown 简洁性的同时，通过深度整合 Vue 和 Vite 生态，提供了更强的交互性、定制能力和开发体验 。它试图在 Markdown 的简单性与 Web 应用的灵活性之间找到最佳平衡点。

## 基础使用 (Getting Started)

开始使用 Slidev 非常简单，可以通过在线编辑器快速体验，也可以在本地进行安装和开发 。

1.  **创建幻灯片:**

    - **在线尝试:** 访问 [sli.dev/new](https://sli.dev/new) 使用 StackBlitz 提供的在线编辑器，无需本地安装即可开始创建 。
    - **本地创建:**
      - **环境要求:** 需要安装 Node.js 18.0 或更高版本 。
      - **初始化项目:** 在终端运行以下命令之一（推荐使用 pnpm）：
        - `pnpm create slidev`
        - `npm init slidev@latest`
        - `yarn create slidev`
        - `bun create slidev`
      - **项目结构:** 根据提示设置项目。核心内容位于 `slides.md` 文件中，该文件默认包含 Slidev 功能的演示 。
    - **单文件使用 (不推荐):** 可全局安装 `@slidev/cli` (`pnpm i -g @slidev/cli`)，然后直接使用 `slidev slides.md` 启动单个 Markdown 文件 。

2.  **编写内容:**

    - 主要在 `slides.md` 文件中使用 Markdown 语法编写幻灯片内容。
    - 使用 `---` 分隔不同的幻灯片 。
    - 参考后续的 **语法指南** 部分了解更多 Slidev 特有的 Markdown 扩展语法。

3.  **启动开发服务器:**

    - 在项目目录下运行 `slidev` 或 `npm run dev` (如果使用 `npm init slidev` 创建) 。
    - 这将启动一个本地开发服务器，并通常会自动在浏览器中打开预览。得益于 Vite 的 HMR，编辑 `slides.md` 或相关文件时，预览会自动更新 。

## `slidev` 命令与项目结构

Slidev 提供了一套命令行界面（CLI）工具来管理演示文稿的开发、构建和导出 。

### 常用命令

以下是一些核心的 `slidev` CLI 命令 ：

- **`slidev [entry]` (或 `slidev dev [entry]`)**:

  - **作用:** 启动本地开发服务器，用于实时预览和编辑幻灯片。
  - **`[entry]`:** 可选参数，指定入口 Markdown 文件，默认为 `slides.md` 。
  - **常用选项:**
    - `--port <port>`, `-p <port>`: 指定服务器端口，默认为 3030 。
    - `--open`, `-o`: 启动后自动在浏览器中打开 。
    - `--remote [password]`: 启用远程控制，允许在其他设备上控制演示。可选用密码保护 。
    - `--theme <theme>`, `-t <theme>`: 临时覆盖当前主题进行预览 。
    - `--base <path>`: 设置应用的基础 URL 路径，用于部署到子目录 。
    - `--log <level>`: 设置日志级别 (`error`, `warn`, `info`, `silent`) 。
    - `--force`, `-f`: 强制 Vite 重新构建依赖，忽略缓存 。
  - **注意:** 使用 `npm run slidev -- [options]` 或 `npm run dev -- [options]` 时，需要在选项前加 `--` 。

- **`slidev build [entry]`**:

  - **作用:** 将幻灯片构建为静态单页应用（SPA），用于部署托管 。
  - **常用选项:**
    - `--out <dir>`, `-o <dir>`: 指定输出目录，默认为 `dist` 。
    - `--base <path>`: 设置部署时的基础 URL 路径 。
    - `--download`: 在构建的 SPA 中启用 PDF 下载功能 。
    - `--theme <theme>`, `-t <theme>`: 在构建时覆盖主题 。

- **`slidev export [...entry]`**:

  - **作用:** 将幻灯片导出为不同格式的文件，如 PDF、PNG、PPTX 或 Markdown 。
  - **常用选项:**
    - `--output <filename>`: 指定导出文件名（不含扩展名） 。
    - `--format <format>`: 指定导出格式 (`pdf`, `png`, `pptx`, `md`)，默认为 `pdf` 。
    - `--timeout <ms>`: 导出渲染的超时时间（毫秒），默认 30000 。
    - `--range <pages>`: 指定导出的页面范围，如 `'1,4-5,6'` 。
    - `--dark`: 使用深色主题导出 。
    - `--with-clicks`, `-c`: 为每个点击动画步骤导出单独页面/图片 。
    - `--theme <theme>`, `-t <theme>`: 在导出时覆盖主题 。
    - `--omit-background`: 导出 PNG 时省略背景 。

- **`slidev format [entry]`**:

  - **作用:** 格式化 `slides.md` 文件的结构（不修改内容） 。

- **`slidev theme eject [entry]`**:

  - **作用:** 将当前使用的主题文件提取到本地 `theme` 目录，方便进行深度定制 。
  - **选项:**
    - `--dir <dir>`: 指定输出目录，默认为 `theme` 。
    - `--theme <theme>`, `-t <theme>`: 指定要提取的主题 。

- **`slidev --help`**:

  - **作用:** 显示帮助信息，列出所有可用命令和选项 。

### 项目文件结构

```
Slidev 项目遵循一定的目录结构约定，以简化配置并使扩展更直观。以下是推荐的结构 ：
your-slidev/
├── components/ \# (可选) 自定义 Vue 组件 (_.{vue,js,ts,jsx,tsx,md})
├── layouts/ \# (可选) 自定义布局 (_.{vue,js,ts,jsx,tsx})
├── public/ \# (可选) 静态资源 (图片、字体等)，会被直接复制到构建输出的根目录
├── setup/ \# (可选) 用于高级配置和 Hook (如 shiki.ts, katex.ts, main.ts)
├── snippets/ \# (可选) 存放代码片段，方便 \<\<\< 导入
├── styles/ \# (可选) 自定义样式 (index.{css,js,ts} 或 style.css)
│ ├── index.css \# 主样式入口，可导入其他 CSS 文件
│ └──...
├── index.html \# (可选) 用于注入 meta 标签或脚本到主 HTML 文件
├── slides.md \# (必需) 幻灯片主文件
├── vite.config.ts \# (可选) 扩展 Vite 配置
└── package.json \# 项目依赖和脚本配置
```

除了 `slides.md`，其他目录和文件都是可选的。这种结构使得项目组织清晰，易于管理自定义内容和配置 。

## 编辑器设置 (VSCode)

虽然任何支持 Markdown 的文本编辑器都可以用来编写 Slidev 幻灯片，但官方推荐并提供了一些工具来增强编辑体验，特别是针对 VS Code 。

**推荐的 VS Code 扩展:**

- **Slidev (by Anthony Fu - `antfu.slidev`)**: 这是官方推荐的扩展，提供了最全面的集成 。

  - **功能:**
    - **侧边栏预览:** 在 VS Code 侧边栏实时预览幻灯片 。
    - **幻灯片树视图:** 显示项目中所有幻灯片的结构，方便导航 。
    - **幻灯片排序:** 通过在树视图中拖放来重新排列幻灯片顺序 。
    - **幻灯片块折叠:** 支持在 Markdown 文件中折叠幻灯片分隔符之间的内容 。
    - **多项目支持:** 管理工作区中的多个 Slidev 项目 。
    - **一键启动服务:** 快速启动开发服务器 。
    - **预览同步:** 可选择将预览导航与编辑器光标位置同步 。
  - **使用:** 安装后，点击活动栏的 Slidev 图标打开面板。面板包含项目树、幻灯片树和预览视图。可以通过图标或命令面板 (`Slidev`) 执行操作 。
  - **配置:**
    - `slidev.include`: 配置哪些文件被识别为 Slidev 入口 (默认 `["**/*.md"]`) 。
    - `slidev.dev-command`: 自定义启动开发服务器的命令 (默认 `npm exec -c 'slidev ${args}'`) 。

- **其他相关扩展 (可能有用):**
  - **Slidev Copilot (`robothy.slidev-copilot`):** 利用 GitHub Copilot Chat 从聊天上下文生成 Slidev 演示文稿 。
  - **VS Code Slides (`nicoespeon.slides`):** 一个通用的将 VS Code 用作演示工具的扩展，可以按文件顺序切换标签作为“幻灯片”，并优化设置 。
  - **Demo Time (`eliostruyf.demo-time`):** 用于编写和执行演示脚本，可以与 Slidev (通过 Simple Browser 显示网页) 结合使用，实现幻灯片和代码演示的流畅切换 。

**其他工具:**

- **集成编辑器:** Slidev 自身提供了一个可以在浏览器中与预览并排编辑 `slides.md` 源文件的集成编辑器 。
- **Prettier 插件:** 提供了 Prettier 插件 (`prettier-plugin-slidev`) 来格式化 `slides.md` 文件，保持代码风格一致 。

通过配置 VS Code 并安装官方 Slidev 扩展，可以显著提高创建和管理 Slidev 演示文稿的效率。

## [语法指南 (Syntax Guide)](https://sli.dev/guide/syntax)

Slidev 使用扩展的 Markdown 语法（称为 **Slidev Markdown**）来编写幻灯片内容。除了标准的 Markdown 功能外，Slidev 还引入了许多特定语法来支持演示文稿的各种特性。

### [幻灯片分隔符](https://sli.dev/guide/syntax#slide-separators)

使用三个或更多连续的连字符 `---` 并用空行包围，来分隔不同的幻灯片 。

```md
# 第一张幻灯片

这是内容。

---

# 第二张幻灯片

更多内容...

---

# 第三章幻灯片

第三章幻灯片内容...
```

### [Frontmatter & Headmatter](https://sli.dev/guide/syntax#frontmatter)

Slidev 使用 [YAML Frontmatter](https://jekyllrb.com/docs/front-matter/) 来配置幻灯片。

- **Headmatter (全局配置):** 位于 `slides.md` 文件**最顶部**的第一个 Frontmatter 块。它用于设置整个演示文稿的全局配置，如主题、标题、作者信息、导出选项、字体、默认布局等 。
- **Frontmatter (单页配置):** 位于每个 `---` 分隔符**之后**、幻灯片内容**之前**的 YAML 块。它用于配置当前这张幻灯片的特定属性，如布局、背景、过渡效果、点击次数、是否隐藏等。这些配置会覆盖 Headmatter 中的 `defaults` 设置 。

**示例:**

```md
---
# Headmatter (全局配置)
theme: seriph
title: 我的 Slidev 演示
author: 我的名字
defaults:
  layout: default
  transition: slide-left
#... 其他全局配置
---

# 幻灯片 1 (使用默认配置)

## 内容...

# Frontmatter (幻灯片 2 的配置)

layout: cover # 覆盖默认布局
background: /images/bg2.png
transition: fade # 覆盖默认过渡
clicks: 5 # 自定义点击次数

---

# 幻灯片 2

## 内容...

# Frontmatter (幻灯片 3 的配置)

## src:./pages/external-slide.md # 导入外部 Markdown 文件作为此幻灯片

---

# Frontmatter (幻灯片 4 的配置)

## hide: true # 隐藏此幻灯片

# 幻灯片 4 (不会显示)
```

**详细配置选项:**

Headmatter 和 Per-slide Frontmatter 支持丰富的配置选项。

- **Headmatter 主要选项 :**

  - `theme`: 主题 (ID, 包名或路径)
  - `addons`: 插件列表 (包名或路径)
  - `title`: 演示文稿标题
  - `titleTemplate`: 网页标题模板 (`%s` 会被替换为 `title`)
  - `info`: 演示文稿信息 (Markdown 字符串)
  - `author`: 作者 (用于 PDF/PPTX 导出)
  - `keywords`: 关键词 (用于 PDF 导出)
  - `presenter`: 启用演讲者模式 (`true`, `false`, `'dev'`, `'build'`)
  - `download`: 在 SPA 中启用 PDF 下载 (`false`, `true`, 或自定义 URL)
  - `exportFilename`: 导出文件名 (不含扩展名)
  - `export`: 导出选项 (如 `format`, `timeout`, `dark`, `withClicks`)
  - `lineNumbers`: 代码块显示行号
  - `monaco`: 启用 Monaco 编辑器 (`true`, `false`, `'dev'`, `'build'`)
  - `selectable`: 允许选择幻灯片文本
  - `record`: 启用录制功能 (`true`, `false`, `'dev'`, `'build'`)
  - `colorSchema`: 强制颜色模式 (`'auto'`, `'light'`, `'dark'`)
  - `routerMode`: 路由模式 (`'history'`, `'hash'`)
  - `aspectRatio`: 宽高比 (`16/9`, `4/3` 等)
  - `canvasWidth`: 画布宽度 (像素)
  - `themeConfig`: 传递给主题的配置 (会注入 CSS 变量)
  - `favicon`: 网站图标路径或 URL
  - `fonts`: 字体配置 (自动从 Google Fonts 导入)
  - `defaults`: 应用于所有幻灯片的默认 Frontmatter
  - `drawings`: 绘图功能配置
  - `htmlAttrs`: `<html>` 标签属性 (`lang`, `dir`)
  - `seoMeta`: SEO 元数据 (Open Graph, Twitter Cards)

- **Per-slide Frontmatter 主要选项 :**

  - `layout`: 当前幻灯片的布局
  - `clicks`: 自定义当前幻灯片的总点击次数
  - `disabled`/`hide`: 禁用/隐藏当前幻灯片
  - `hideInToc`: 在目录中隐藏此幻灯片
  - `level`: 覆盖标题级别 (需同时声明 `title`)
  - `preload`: 预加载此幻灯片
  - `routeAlias`: 定义路由别名
  - `src`: 导入外部 Markdown 文件 (`.md#2,5-7` 可导入特定页面)
  - `title`: 覆盖 `<TitleRenderer>` 和 `<Toc>` 中的标题 (需同时声明 `level`)
  - `transition`: 当前幻灯片到下一张的过渡效果
  - `zoom`: 自定义缩放比例
  - `dragPos`: 可拖动元素的初始位置

这种 Headmatter/Frontmatter 的双层结构提供了极大的灵活性。用户可以在 Headmatter 中设定全局风格和默认行为，然后在需要特殊处理的幻灯片上通过其独立的 Frontmatter 进行覆盖，既能保持一致性，又能实现个别页面的定制化，而无需重复配置 。

### 代码块

Slidev 对代码块提供了强大的支持，利用 Shiki 进行语法高亮，并集成了多种高级功能 。

1.  **标准围栏代码块:** 使用标准的 Markdown 语法，即三个反引号 ` ``` ` 包围代码，并在开始的反引号后指定语言标识符 。

    ````md
    ```typescript
    function greet(name: string) {
      console.log(`Hello, ${name}!`);
    }
    ```
    ````

2.  **导入外部代码片段 (`<<<`):** 可以从外部文件导入代码片段，保持 `slides.md` 的整洁 。

    - **基本语法:** `<<< @/<path/to/file>[#region-identifier]{lang}`
    - **路径:**
      - `@/`: 指向项目的根目录 (推荐将片段放在 `@/snippets/` 下以兼容 Monaco 编辑器) 。
      - 也支持相对路径 (如 `<<<../path/to/file.js`) 。
    - **区域标识符 (`#region-name`):** 可选，用于仅导入文件中特定 VS Code region (`#region name`... `#endregion`) 的内容 。
    - **语言标识符 (`{lang}`):** 可选，显式指定导入代码的语言，如 `{ts}`。如果未指定，有时可能导致渲染问题 。
    - **结合其他功能:** 可以与行高亮、Monaco 编辑器等功能结合使用 。

    **示例:**

    ```md
    <<< @/snippets/my-function.js

    <<< @/snippets/my-class.ts#main-logic{ts}

    <<< @/snippets/another-script.py{2,3|5}

    <<< @/snippets/config.json{json}{monaco}

    <<< @/snippets/highlight-example.js{\*}{lines:true}
    ```

3.  **Shiki 集成:**

    - Slidev 内置([https://github.com/shikijs/shiki](https://github.com/shikijs/shiki)) 作为默认语法高亮器 。
    - 可以通过 `./setup/shiki.ts` 文件进行配置，例如更换主题、添加语言支持等（详见 **配置** 部分） 。

4.  **相关代码块功能 (简述):** Slidev 还提供了许多与代码块相关的高级功能，通常通过在语言标识符后添加 `{}` 选项来启用：

    - **行号 (`{lines:true}`):** 显示行号 。
    - **行高亮 (`{1,3-5|7}`):** 高亮特定行，支持点击逐步高亮 。
    - **最大高度 (`{maxHeight:'200px'}`):** 设置代码块最大高度并启用滚动 。
    - **Monaco 编辑器 (`{monaco}`):** 将静态代码块转换为可交互的 Monaco 编辑器 。
    - **Monaco Diff (`{monaco-diff}`):** 显示两个代码块之间的差异 。
    - **Shiki Magic Move:** 在用四个反引号 ` ````magic-move ` 包裹的多个代码块之间实现平滑过渡动画 。
    - **TwoSlash (`{twoslash}`):** 为 TypeScript/JavaScript 代码块提供类型悬停信息和内联错误展示 。

### LaTeX (KaTeX 集成)

Slidev 内置了对 LaTeX 的支持，使用([https://katex.org/](https://katex.org/)) 引擎渲染数学和化学公式 。

- **行内模式 (Inline Mode):** 使用单个美元符号 `$` 包裹 LaTeX 代码，公式将嵌入在文本行内 。

  - 示例: `这是一个行内公式 $E = mc^2$。`

- **块模式 (Block Mode):** 使用双美元符号 `$$` 包裹 LaTeX 代码，公式将单独成块、居中显示，并使用更大的符号 。

  - 示例:
    ```latex
    $$
    \frac{\partial \rho}{\partial t} + \nabla \cdot (\rho \mathbf{v}) = 0
    $$
    ```

- **行高亮:** 类似于代码块，可以在块模式公式中使用 `{}` 指定高亮行号 (从 1 开始) 。

  - 示例: `$${1|3}...$$`

- **化学方程式 (mhchem):** 需要额外配置。首先，通过 Vite 配置加载 KaTeX 的 `mhchem` 扩展。在 `vite.config.ts` (或 `./setup/vite.config.ts`) 中添加 `import 'katex/contrib/mhchem'` 。之后就可以使用 `\ce{...}` 语法书写化学式 。

  - 示例: `$$\ce{H2 + O2 -> H2O}$$`

- **配置:** 可以通过 `./setup/katex.ts` 文件对 KaTeX 进行更详细的配置（详见 **配置** 部分） 。

### 注释 (Presenter Notes)

可以在每张幻灯片的末尾添加演讲者注释，这些注释只在演讲者模式下可见，对观众隐藏 。

- **语法:** 使用标准的 HTML 注释 \`\`，并且该注释块必须位于幻灯片内容的**最后** 。
- **内容:** 注释内部支持基本的 Markdown 和 HTML 语法 。

<!-- end list -->

```md
# 这是一个带有注释的幻灯片

这里是幻灯片的主要内容。
```

### 其他语法 (简述)

Slidev 还支持其他一些有用的语法特性：

- **导入幻灯片 (`src:`):** 在幻灯片的 Frontmatter 中使用 `src:./path/to/another.md` 可以将另一个 Markdown 文件的内容导入作为当前幻灯片。使用 `#` 可以导入特定页面，如 `src:./deck.md#2,5-7`。
- **图表 (Diagrams):** 支持使用 Mermaid 和 PlantUML 语法直接在 Markdown 中绘制图表 。
- **MDC 语法:** Markdown Components 语法，一种增强的语法，可以更方便地在 Markdown 中使用组件和应用样式。
- **作用域 CSS:** 支持在幻灯片文件中使用 `<style scoped>` 标签来定义仅作用于当前组件（或布局）的 CSS 样式 。

总而言之，Slidev 的语法设计体现了其作为 Markdown 超集的特性。它在保留标准 Markdown 易读易写的基础上，通过 Frontmatter、代码导入、LaTeX/图表集成等扩展语法，为创建功能丰富、结构清晰的演示文稿提供了强大的支持 。

## 配置 (Customizations)

Slidev 提供了高度的可定制性，允许用户从样式到内部工具链进行全方位的配置 。配置主要通过以下几种方式进行：

1.  **Frontmatter/Headmatter:** 如前所述，用于配置全局默认值和单页特定属性 。
2.  **`./setup/` 目录:** 存放用于配置特定工具或功能的 TypeScript 文件 。
3.  **`vite.config.ts`:** 用于扩展和配置底层的 Vite 构建工具 。
4.  **主题 (Themes) 和插件 (Addons):** 通过安装和配置主题/插件来引入样式和功能 。

这种分层的配置模型使得定制过程非常灵活。用户可以从简单的 Headmatter 全局设置开始，然后根据需要通过主题、插件、单页 Frontmatter 甚至深入到底层工具的 setup 文件进行逐级定制和覆盖 。

### 高亮器 (Shiki) 配置

- **文件:** `./setup/shiki.ts`
- **作用:** 配置 Shiki 语法高亮器。
- **方法:** 使用 `@slidev/types` 中的 `defineShikiSetup` 函数导出一个返回配置对象的函数 。
- **主要选项 :**
  - `themes`: 指定亮色和暗色模式下的 Shiki 主题 (可以是内置主题名或自定义主题 JSON 对象)。
  - `langs`: 添加额外的语言支持 (导入 TextMate 语法文件)。
  - `transformers`: 应用代码转换（注意：Shiki Magic Move 目前不支持 transformers）。
- **环境:** Node.js 。
- **参考:** 完整的选项列表请查阅([https://shiki.style](https://shiki.style)) 。

<!-- end list -->

```typescript
//./setup/shiki.ts
import { defineShikiSetup } from "@slidev/types";

export default defineShikiSetup(() => {
  return {
    themes: {
      dark: "min-dark",
      light: "min-light",
    },
    // 可选：添加自定义语言
    // langs: [
    //   import('shiki/langs/my-custom-lang.tmLanguage.json')
    // ]
  };
});
```

### KaTeX 配置

- **文件:** `./setup/katex.ts`
- **作用:** 配置 KaTeX LaTeX 渲染引擎。
- **方法:** 使用 `@slidev/types` 中的 `defineKatexSetup` 函数导出一个返回 KaTeX 配置对象的函数 。
- **主要选项:** 可以传递 KaTeX 支持的任何选项，例如 `maxExpand`, `macros` 等 。
- **环境:** Node.js 。
- **参考:** 完整的选项列表请查阅([https://katex.org/docs/options.html](https://katex.org/docs/options.html)) 。
- **注意:** 如需使用 `mhchem` 扩展渲染化学公式，需要在 Vite 配置中导入它 (`import 'katex/contrib/mhchem'`) 。

<!-- end list -->

```typescript
//./setup/katex.ts
import { defineKatexSetup } from "@slidev/types";

export default defineKatexSetup(() => {
  return {
    // 示例：增加宏展开限制
    maxExpand: 2000,
    // 示例：定义自定义宏
    macros: {
      "\\RR": "\\mathbb{R}",
    },
  };
});
```

### Monaco 编辑器配置

- **文件:** `./setup/monaco.ts`
- **作用:** 配置用于交互式代码块的 Monaco 编辑器。
- **方法:** 使用 `@slidev/types` 中的 `defineMonacoSetup` 函数导出一个异步函数，该函数接收 `monaco` 实例作为参数，并可返回配置对象 。
- **主要选项 :**
  - `editorOptions`: 应用于所有 Monaco 实例的编辑器选项 (如 `wordWrap: 'on'`)。
  - `monacoTypesSource`: TypeScript 类型获取来源 (`'cdn'`, `'local'`, `'none'`, `'ata'`)。
  - `monacoTypesAdditionalPackages`: 显式指定需要加载类型的本地 npm 包。
- **环境:** 客户端 (浏览器) 。
- **主题:** 从 v0.48.0 开始，Monaco 编辑器会自动复用 Shiki 配置的主题 。
- **禁用:** 可以在 Frontmatter 中设置 `monaco: false` 来禁用 Monaco 编辑器 。

<!-- end list -->

```typescript
//./setup/monaco.ts
import { defineMonacoSetup } from "@slidev/types";

export default defineMonacoSetup(async (monaco) => {
  // 可以直接调用 monaco API 进行配置
  // monaco.languages.typescript.javascriptDefaults.setCompilerOptions(...)

  // 也可以返回一个配置对象
  return {
    editorOptions: {
      fontSize: 14,
      wordWrap: "on",
    },
    // 强制从 CDN 加载类型
    // monacoTypesSource: 'cdn',
  };
});
```

### Vite 配置

- **文件:** `vite.config.ts` (项目根目录)
- **作用:** 扩展或覆盖 Slidev 底层的 Vite 配置。
- **方法:** 创建标准的 `vite.config.ts` 文件。用户的配置会与 Slidev、主题和插件的内部 Vite 配置合并 。
- **配置内部插件:** 通过 `slidev` 字段配置 Slidev 使用的内部 Vite 插件 (如 `@vitejs/plugin-vue`, `unplugin-vue-components`, `vite-plugin-vue-markdown` 等)。**警告:** 覆盖内部插件配置属于高级用法，可能导致意外行为 。
- **添加自定义插件:** 可以在 `plugins` 数组中添加自定义 Vite 插件 。
- **基于幻灯片数据的插件:** 如果插件逻辑需要访问幻灯片数据，应在 `./setup/vite-plugins.ts` 中使用 `defineVitePluginsSetup` 来定义 。
- **环境:** Node.js 。

<!-- end list -->

```typescript
// vite.config.ts
import { defineConfig } from "vite";
import MyCustomPlugin from "./my-vite-plugin"; // 示例自定义插件

export default defineConfig({
  // 添加自定义 Vite 插件
  plugins: [MyCustomPlugin()],

  // 配置 Slidev 内部插件 (高级)
  slidev: {
    vue: {
      // Vue 插件选项
      include: [/\.vue$/, /\.md$/],
    },
    markdown: {
      // markdown-it 选项
      markdownItSetup(md) {
        // 添加 markdown-it 插件
        md.use(require("markdown-it-abbr"));
      },
    },
    // 其他内部插件选项...
  },
});
```

### 其他配置 (简述)

- **Vue App (`./setup/main.ts`):** 配置 Vue 应用实例，例如注册全局组件、插件等 。环境：客户端。
- **UnoCSS (`./setup/unocss.ts`):** 配置 UnoCSS 引擎，例如添加自定义规则、快捷方式等 。环境：Node.js。
- **Code Runners (`./setup/code-runners.ts`):** 配置 Monaco Runner 如何执行代码，或添加对自定义语言的支持 。环境：客户端。
- **Pre-Parser (`./setup/preparser.ts`):** 高级功能，用于在 Markdown 解析前对其进行转换，实现自定义语法扩展 。环境：Node.js。

### 主题 (Themes)

- **作用:** 主要负责演示文稿的视觉外观，包括全局样式、字体、颜色方案，并可以提供自定义布局和组件 。
- **使用:**
  1.  在 Headmatter 中指定 `theme: <theme-name>` 或 `theme:./path/to/local/theme` 。
  2.  如果主题未安装，Slidev 会提示自动安装；也可手动使用 `npm install <theme-package-name>` 或 `yarn add <theme-package-name>` 安装 。
- **编写:**
  1.  **脚手架:** 使用 `pnpm create slidev-theme` (或 npm/yarn/bun) 创建主题模板 。
  2.  **实现:** 在主题项目中添加全局样式 (`style.css` 或 `styles/index.css`)、自定义布局 (`layouts/`)、自定义组件 (`components/`) 等，方式与在普通 Slidev 项目中类似 。
  3.  **默认配置:** 在主题的 `package.json` 中添加 `slidev.defaults` 字段，为使用该主题的项目提供默认配置 。
  4.  **元数据:** 在 `package.json` 中设置 `engines.slidev` 指定兼容的 Slidev 版本，`slidev.colorSchema` 指定支持的颜色模式 (`light`, `dark`, `both`) 。
  5.  **预览:** 在主题项目根目录创建 `slides.md`，设置 `theme:./`，然后运行 `slidev` 。
  6.  **发布 (可选):**
      - 包名约定: `slidev-theme-<name>` 或 `@scope/slidev-theme-<name>` 。
      - 关键词: 在 `package.json` 中添加 `"slidev-theme"`, `"slidev"` 。
      - 无需预编译 `.vue`, `.ts` 文件 。

### 插件 (Addons)

- **作用:** 主要用于添加**功能性**扩展，如图标集、绘图工具、代码运行器、特定组件库集成等，而不是改变整体外观 。
- **使用:**
  1.  在 Headmatter 的 `addons` 数组中列出插件名称或本地路径 。
  2.  安装方式与主题类似（自动提示或手动安装） 。
- **编写:**
  1.  **结构:** 类似于主题项目，可以包含 `components/`, `layouts/`, `setup/` 等目录来提供相应的功能 。
  2.  **侧重:** 专注于添加新功能（新组件、新布局、新代码运行器），避免覆盖性样式或与主题冲突的配置 。
  3.  **预览:** 在 `slides.md` 中设置 `addons: ['./']` 来预览本地插件 。
  4.  **发布 (可选):**
      - 包名约定: `slidev-addon-<name>` 或 `@scope/slidev-addon-<name>` 。
      - 关键词: 在 `package.json` 中添加 `"slidev-addon"`, `"slidev"` 。
      - 无需预编译 `.vue`, `.ts` 文件 。

主题和插件的设计理念体现了关注点分离：主题管“皮肤”，插件管“功能”。这使得用户可以灵活地组合不同的外观主题和功能插件，构建模块化的演示文稿系统 。

### 布局 (Layouts)

- **作用:** 定义幻灯片内容的结构和框架。本质上是 Vue 组件 。
- **使用:**
  1.  在幻灯片的 Frontmatter 中指定 `layout: <layout-name>` 。
  2.  默认布局：第一页为 `cover`，其余为 `default` 。
  3.  **加载顺序 (同名覆盖):** 内置布局 -\> 主题布局 -\> 插件布局 -\> 项目本地布局 (`layouts/`) 。
- **编写:**
  1.  在项目根目录的 `layouts/` 文件夹下创建 Vue 组件文件 (如 `MyLayout.vue`) 。
  2.  在组件的 `<template>` 中，使用 `<slot/>` 标签来指定幻灯片 Markdown 内容的插入位置 。
  3.  可以使用**命名插槽** (`<slot name="xxx"/>`) 来定义布局中的多个内容区域，并在 Markdown 中使用特定语法（Slot Sugar）填充 。

<!-- end list -->

```vue
<template>
  <div class="slidev-layout grid grid-cols-2 gap-4">
    <div class="image-container">
      <slot name="image" />
    </div>
    <div class="content-container">
      <slot />
    </div>
  </div>
</template>
```

## 全局上下文 (Global Context)

Slidev 向每个幻灯片和相关组件注入了一个“全局上下文”，包含一系列响应式状态和控制函数，允许在幻灯片内容或自定义组件中动态地访问和操作演示状态 。这使得创建交互式和动态演示成为可能，例如根据当前页码显示不同内容，或创建自定义导航控件。

**访问方式 :**

1.  **直接访问 (模板内):**

    - **Markdown:** 使用双花括号 `{{ }}` 访问响应式对象。例如 `当前页码: {{ $nav.currentPage }}`。
    - **Vue 模板:** 使用 `$` 前缀访问。例如 `<button @click="$nav.nextSlide()">下一页</button>`。

2.  **组合式 API (Composable Usage):**

    - 在 Vue 组件的 `<script setup>` 中，从 `@slidev/client` 导入相应的 Composable 函数以获得类型安全和更程序化的访问。
    - 常用 Composable:
      - `useNav()`: 访问导航状态和函数 (`currentPage`, `currentLayout`, `next()`, `prev()`, `go()`, `nextSlide()` 等)。
      - `useSlideContext()`: 访问 `$slidev` 上下文对象。
      - `useDarkMode()`: 访问和切换深色模式状态。
      - `useClicks()`: 访问当前幻灯片的本地点击计数。
      - `useSlideInfo()`: 获取当前幻灯片的信息。
      - `useIsSlideActive()`: 判断当前组件所在的幻灯片是否激活。
      - `onSlideEnter(callback)` / `onSlideLeave(callback)`: 注册幻灯片进入/离开时的回调函数。

**关键属性 :**

- **`$slidev`**: 主上下文对象，包含配置等。
- **`$nav`**: 响应式导航对象。
  - `$nav.currentPage`: 当前幻灯片编号 (从 1 开始)。
  - `$nav.currentLayout`: 当前布局名称。
  - `$nav.currentSlideRoute`: 当前幻灯片的路由信息。
  - `$nav.clicks`: **全局**点击计数 (跨幻灯片累加)。
  - `$nav.next()`: 前往下一步 (可能是下一点击或下一页)。
  - `$nav.prev()`: 前往上一步。
  - `$nav.nextSlide()`: 直接前往下一张幻灯片 (跳过内部点击)。
  - `$nav.prevSlide()`: 直接前往上一张幻灯片。
  - `$nav.go(index)`: 跳转到指定页码。
- **`$frontmatter`**: 当前幻灯片的 Frontmatter 对象 (在全局层组件中可能为空)。
- **`$clicks`**: 当前幻灯片**内部**的点击计数 (从 0 开始)。
- **`$page`**: `$nav.currentPage` 的别名。
- **`$renderContext`**: 当前渲染环境 (`'slide'`, `'overview'`, `'presenter'`, `'previewNext'`, `'print'`)。可用于条件渲染，例如使用 `<RenderWhen>` 组件。
- **`$slidev.configs`**: 响应式的全局配置对象 (来自 Headmatter 和 `slidev.config.ts`)。
- **`$slidev.themeConfigs`**: 响应式的主题配置对象。

**类型:**

- 可以从 `@slidev/types` 导入相关的 TypeScript 类型定义，以增强开发体验 。

通过访问全局上下文，开发者可以创建出响应演示状态的动态组件和布局，例如自定义进度条、根据点击步骤显示不同内容的组件、或者只有在特定渲染环境（如演讲者模式）下才显示的控件。

## 导出与托管 (Export & Hosting)

Slidev 提供了将演示文稿导出为多种格式以及将其作为 Web 应用托管的能力。

### 导出幻灯片

- **命令:** `slidev export [entry][options]` 。
- **依赖:** 导出为 PDF, PNG, PPTX 需要安装 `playwright-chromium` (`npm i -D playwright-chromium`) 。
- **支持格式 :**
  - **PDF (默认):** `$ slidev export`。生成静态 PDF 文件。
  - **PNG:** `$ slidev export --format png`。为每张幻灯片（包括点击步骤，如果使用 `--with-clicks`）生成 PNG 图片。
  - **PPTX:** `$ slidev export --format pptx`。生成 PPTX 文件，每页为一张图片，包含演讲者注释，默认启用 `--with-clicks`。文本不可选。
  - **Markdown (MD):** `$ slidev export --format md`。生成一个包含编译后 PNG 图片的 Markdown 文件。
- **导出选项总结:**

| 格式 | 主要选项/说明                                                                                                                           |
| :--- | :-------------------------------------------------------------------------------------------------------------------------------------- |
| PDF  | `--with-clicks` (多页动画), `--dark` (深色主题), `--range` (页面范围), `--with-toc` (生成目录), `--output` (文件名), `--timeout` (超时) |
| PNG  | `--omit-background` (透明背景), `--with-clicks`, `--dark`, `--range`, `--output`                                                        |
| PPTX | 默认 `--with-clicks`, 包含注释, 页面为图片, `--dark`, `--range`, `--output`                                                             |
| MD   | 生成包含 PNG 图片的 Markdown 文件                                                                                                       |

- **通用选项 :**
  - `--output <filename>`: 指定输出文件名 (不含扩展名)。
  - `--range <pages>`: 指定导出页面范围 (e.g., `'1,5-7,9'`)。
  - `--dark`: 使用深色主题导出。
  - `--with-clicks` / `-c`: 为每个点击动画步骤导出单独页面/图片。
  - `--timeout <ms>`: 增加渲染超时时间。
  - `--wait <ms>`: 每页导出前增加等待时间，用于内容加载。
  - `--wait-until <state>`: Playwright 等待状态 (`'networkidle'`, `'load'` 等)。
  - `--with-toc`: 在 PDF 中生成大纲/目录。
- **浏览器导出器:** 从 v0.50.0-beta.11 开始，可以通过访问 `/export` 路径使用浏览器 UI 进行导出 (推荐 Chromium 浏览器) 。
- **注意:** 导出为静态格式（如 PDF, PPTX）会丢失大部分交互功能（如 Vue 组件交互、Monaco 编辑器等）。这是一个需要在分享便捷性与功能完整性之间权衡的选择。

### 托管幻灯片

可以将 Slidev 演示文稿构建为单页应用 (SPA) 并部署到各种静态网站托管平台 。这种方式可以完整保留演示文稿的所有交互特性。

1.  **构建 SPA:**

    - 运行命令: `$ slidev build [entry][options]` 。
    - 默认输出: `dist/` 目录 。
    - **基础路径 (`--base`):** 如果要部署到网站的子目录 (如 `https://example.com/my-talk/`)，需要在构建时指定基础路径: `$ slidev build --base /my-talk/` 。路径必须以 `/` 开头和结尾。

2.  **托管平台与方法 :**

    - **GitHub Pages:**
      - **推荐方法:** 使用 GitHub Actions 自动部署。
      - **步骤:** 在仓库 `Settings > Pages` 选择 `GitHub Actions` 作为部署源。创建 `.github/workflows/deploy.yml` 文件（官方文档提供模板），该 workflow 会在推送到主分支时自动构建（使用正确的 `--base`）并部署到 GitHub Pages。
      - **访问:** `https://<username>.github.io/<repository-name>/` (如果设置了 `--base`)。
    - **Netlify:**
      - **方法:** 在项目根目录创建 `netlify.toml` 配置文件。
      - **配置:** 文件中需指定构建命令 (`npm run build`)、发布目录 (`dist`)、Node 版本，并设置 SPA 的重定向规则 (`[[redirects]]... status = 200`)。
      - **部署:** 在 Netlify 网站连接仓库，它会自动读取 `netlify.toml` 进行构建和部署。
    - **Vercel:**
      - **方法:** 在项目根目录创建 `vercel.json` 配置文件。
      - **配置:** 文件中需设置 SPA 的重写规则 (`"rewrites": [{ "source": "/(.*)", "destination": "/index.html" }]`)。
      - **部署:** 在 Vercel 网站连接仓库进行部署。
    - **Docker:**
      - **方法 1 (使用预构建镜像):** 运行 `docker run --rm -p 3030:3030 -v $PWD:/slidev tangramor/slidev:latest`。
      - **方法 2 (创建自定义镜像):** 编写 `Dockerfile` (基于 `tangramor/slidev:latest`，复制项目文件)，然后构建 (`docker build`) 和运行 (`docker run`) 自己的镜像。

托管为 SPA 的核心优势在于其静态特性。构建产物是标准的 HTML/CSS/JS 文件，使其能够轻松部署到任何支持静态文件托管的服务上，极大地简化了部署流程 。

## 组件 (Components)

Slidev 允许直接在 Markdown 中使用 Vue 组件，极大地增强了幻灯片的表现力和交互性。借助 [`unplugin-vue-components`](<https://www.google.com/search?q=%5Bhttps://github.com/unplugin/unplugin-vue-components%5D(https://github.com/unplugin/unplugin-vue-components)>)，这些组件无需手动导入即可使用 。

### 使用内置组件

Slidev 提供了一系列开箱即用的内置组件，覆盖了常见的演示需求 。

- **使用方法:** 直接在 Markdown 中像使用 HTML 标签一样使用组件名，并传递必要的 props 。

  ```md
  <Tweet id="1390115482657726468" />

  <Youtube id="dQw4w9WgXcQ" />
  ```

- **参考:** 完整的内置组件列表、功能说明和可用 Props，请查阅 [内置组件文档](https://sli.dev/builtin/components) 。

- **部分关键内置组件概览 :**

| 组件名           | 描述                                                     | 主要 Props/用法                                                                                   |
| :--------------- | :------------------------------------------------------- | :------------------------------------------------------------------------------------------------ |
| `Arrow`          | 绘制箭头                                                 | `x1`, `y1`, `x2`, `y2`, `color`, `width`, `two-way`                                               |
| `VDragArrow`     | 可拖动的箭头                                             | 同 `Arrow` (位置相关除外)                                                                         |
| `AutoFitText`    | 文本字体大小自动适应容器                                 | `modelValue` (文本), `max`, `min` (字号)                                                          |
| `LightOrDark`    | 根据亮/暗模式显示不同内容                                | `#dark` 和 `#light` 具名插槽                                                                      |
| `Link`           | 导航到指定幻灯片                                         | `to` (页码或路由别名), `title` (链接文本)                                                         |
| `RenderWhen`     | 根据渲染上下文 (slide, presenter, print 等) 条件渲染内容 | `context` (上下文名称或数组), `#default` 和 `#fallback` 插槽                                      |
| `SlideCurrentNo` | 显示当前页码                                             | 无                                                                                                |
| `SlidesTotal`    | 显示总页数                                               | 无                                                                                                |
| `Toc`            | 生成目录                                                 | `columns`, `listClass`, `minDepth`, `maxDepth`, `mode` (`all`, `onlyCurrentTree`, `onlySiblings`) |
| `Transform`      | 应用 CSS Transform (主要是 scale)                        | `scale`, `origin`                                                                                 |
| `Tweet`          | 嵌入推文                                                 | `id` (推文 ID), `scale`, `conversation`, `cards`                                                  |
| `VClick`         | 点击动画：显示元素                                       | 可用作组件 `<v-click>` 或指令 `v-click`                                                           |
| `VAfter`         | 点击动画：与前一个 `v-click` 同时显示                    | 可用作组件 `<v-after>` 或指令 `v-after`                                                           |
| `VClicks`        | 为子元素自动应用 `v-click` (用于列表等)                  | `depth`, `every`                                                                                  |
| `VSwitch`        | 根据点击次数切换显示不同内容                             | `unmount`, `tag`, `childTag`, `transition`                                                        |
| `SlidevVideo`    | 嵌入视频播放器                                           | `controls`, `autoplay`, `autoreset`, `poster`, `timestamp` 等。`<source>` 标签置于插槽内。        |
| `Youtube`        | 嵌入 YouTube 视频                                        | `id` (视频 ID, 可带 `?start=<seconds>`), `width`, `height`                                        |

### 使用自定义组件

用户可以创建自己的 Vue 组件，并在 Slidev 中复用 。

1.  **创建组件:** 在项目根目录下的 `components/` 文件夹中创建 `.vue` 文件 (如 `MyCounter.vue`) 。
2.  **编写组件:** 按照标准的 Vue 3 语法编写组件逻辑和模板 。

    ```vue
    <script setup>
    import { ref } from 'vue'

    const props = defineProps({
      initial: {
        type: Number,
        default: 0,
      },
    })

    const count = ref(props.initial)
    </script>

    <template>
      <div class="my-counter">
        Count: {{ count }}
        <button @click="count++">+</button>
      </div>
    </template>

    <style scoped>
    ```

.my-counter button {
margin-left: 8px;
}
\</style\>
``3.  **使用组件:** 在 `slides.md` 中直接使用组件名（基于文件名，驼峰或短横线分隔均可），无需导入 。可以传递 props (`:prop-name="..."`) 和监听事件 (`@event-name="..."`) 。``md
\# 自定义组件示例

````
<MyCounter :initial="5" />

<my-counter /> ```
````

这种基于约定的组件加载方式（将 `.vue` 文件放入 `components/` 目录即可全局使用）极大地简化了开发流程，避免了在 Markdown 文件中维护复杂的 `import` 语句，让用户更专注于内容和组件逻辑本身 。

通过允许使用自定义 Vue 组件，Slidev 实际上将整个 Vue 生态系统的能力引入到了演示文稿制作中。这意味着开发者可以利用熟悉的工具和库，创建出远超传统 Markdown 能力范围的复杂、交互式幻灯片元素，例如数据可视化图表、实时数据展示、交互式表单等，使得演示文稿更像一个定制化的 Web 应用 。

### 主题/插件组件

主题和插件也可以提供自己的组件，使用方式与内置组件和自定义组件相同 。

## 动画 (Animations)

Slidev 提供了多种方式为演示文稿添加动画效果，增强视觉吸引力和信息传递的节奏感 。

### 点击动画 (Click Animations)

点击动画允许元素在幻灯片内部根据用户的点击（或按键）操作逐步显示或隐藏 。

- **核心概念:** "Clicks"（点击）是动画的基本单位。一张幻灯片可以包含多个 Clicks。
- **`v-click` / `<v-click>`:**
  - 最基础的指令/组件，使其包裹或应用的元素初始隐藏，在下一次“前进”操作时显示 。
  - 示例: `<div v-click>第一步出现</div>` 或 `<v-click>第一步出现</v-click>`。
- **`v-after` / `<v-after>`:**
  - 使元素与**前一个** `v-click` 元素**同时**出现 。
  - 示例:
    ````md
    <div v-click>Hello</div>
    <div v-after>World</div> ```
    ````
- **隐藏 (`.hide` / `hide` prop):**
  - 在 `v-click` 或 `v-after` 后添加 `.hide` 修饰符或 `hide` prop，可以在后续点击中隐藏该元素 。
  - 示例: `<div v-click.hide>点击两次后隐藏</div>`。
- **`v-clicks` / `<v-clicks>`:**
  - 自动为所有直接子元素应用 `v-click`，常用于列表项的逐个显示 。
  - `depth`: 用于嵌套列表，控制应用 `v-click` 的层级。
  - `every`: 指定每次点击显示多少个子元素。
  - 示例:
    ```md
    <ul v-clicks>
      <li>Item 1</li>
      <li>Item 2</li>
      <li>Item 3</li>
    </ul>
    ```
- **动画顺序控制 (Positioning):**
  - **默认:** 按元素在 Markdown 中出现的顺序依次触发。
  - **指定索引:**
    - `v-click="3"` 或 `<v-click :at="3">`: 在第 3 次点击时显示 (绝对定位)。
    - `v-click="+2"` 或 `<v-click at="+2">`: 在上一个相对定位元素的点击索引基础上加 2 时显示 (相对定位)。
  - 可以混合使用绝对和相对定位 。
- **进入/离开范围 (`v-click="[enter, leave]"` / `<v-switch>`):**
  - `v-click=""`: 元素在第 2 次点击时出现 (包含)，在第 5 次点击时消失 (不包含) 。
  - `<v-switch>` 组件提供了基于模板的更灵活的范围控制 。
- **自定义总点击数:**
  - Slidev 会自动计算所需点击数，但可以通过 Frontmatter 的 `clicks: <number>` 强制指定 。
- **元素过渡效果:**
  - 应用 `v-click` 的元素会添加 `slidev-vclick-target` 类，隐藏时添加 `slidev-vclick-hidden` 类 。
  - 默认有简单的透明度过渡效果。可以通过自定义 CSS 覆盖这些类的样式，实现更复杂的进入/离开动画 (如滑动、缩放) 。

### 幻灯片过渡 (Slide Transitions)

幻灯片过渡是在切换不同幻灯片时应用的视觉效果 。

- **启用:** 在 Headmatter (全局) 或单页 Frontmatter (局部) 中设置 `transition: <transition-name>` 。
- **内置过渡效果 :**
  - `fade`: 淡入淡出。
  - `fade-out`: 当前页淡出，下一页淡入。
  - `slide-left`: 新页面从右侧滑入 (前进时)。
  - `slide-right`: 新页面从左侧滑入 (前进时)。
  - `slide-up`: 新页面从底部滑入 (前进时)。
  - `slide-down`: 新页面从顶部滑入 (前进时)。
  - `view-transition`: 使用实验性的 View Transitions API 实现更平滑的元素过渡。
- **View Transitions API:**
  - 一种新的 Web API，允许在不同 DOM 状态间创建动画过渡。
  - 通过在跨幻灯片的对应元素上设置相同的 `view-transition-name` CSS 属性，可以实现这些元素间的平滑移动或变形效果 。
  - 启用 MDC 语法有助于更方便地应用此属性 。
  - 注意：此 API 仍处于实验阶段，浏览器支持有限 。
- **自定义过渡:**
  - Slidev 的过渡基于 Vue 的 `<Transition>` / `<TransitionGroup>` 。
  - 可以在自定义 CSS 中定义 Vue 过渡类 (如 `.my-transition-enter-active`, `.my-transition-leave-to` 等)，然后在 Frontmatter 中使用 `transition: my-transition` 。
- **方向性过渡:**
  - 可以使用 `|` 分隔符为前进和后退指定不同的过渡效果：`transition: slide-left | slide-right` 。
- **高级配置:**
  - `transition` 字段可以接受一个对象，其属性会直接传递给底层的 Vue `<TransitionGroup>` 组件，允许更精细的控制 。

### Motion (`v-motion`)

Slidev 还集成了 [`@vueuse/motion`](<https://www.google.com/search?q=%5Bhttps://motion.vueuse.org/%5D(https://motion.vueuse.org/)>) 库，可以通过 `v-motion` 指令为单个元素添加更复杂的、基于物理或状态驱动的动画效果 。

Slidev 的动画系统设计体现了声明式的简洁性。大部分常见动画（如逐项显示、页面切换）可以通过简单的指令 (`v-click`) 或 Frontmatter 配置 (`transition:`) 实现，无需编写复杂的 JavaScript 代码 。同时，对于更高级的需求，系统也提供了足够的控制粒度，例如通过点击索引定位、自定义 CSS 过渡、甚至集成 `v-motion` 库，满足从简单到复杂的各种动画场景 。

## 结论

Slidev 是一个功能强大且高度可定制的演示文稿工具，特别适合需要展示代码、利用 Web 技术进行交互以及偏好 Markdown 写作流程的开发者。其核心优势在于将 Markdown 的简洁性与现代 Web 开发生态（Vue, Vite, UnoCSS）的灵活性相结合 。

通过 Headmatter 和 Frontmatter 的分层配置系统，结合主题、插件和布局机制，用户可以轻松定制演示文稿的外观和功能 。其丰富的语法扩展（如代码导入、LaTeX、图表）和组件系统（内置、自定义、第三方）使得创建内容丰富、交互性强的幻灯片成为可能 。全局上下文则为实现动态演示逻辑提供了基础 。

Slidev 的命令行工具提供了完整的开发、构建和导出流程 ，支持导出为多种静态格式（PDF, PNG, PPTX）或部署为可交互的 SPA 。虽然静态导出牺牲了部分交互性，但 SPA 托管方式能完整保留所有功能，适应不同的分享和展示需求。

总而言之，Slidev 提供了一套完整、灵活且对开发者友好的演示文稿解决方案。本笔记涵盖了其主要功能和使用方法，可作为快速入门和后续参考的指南。要深入了解特定功能或高级用法，建议查阅官方文档中对应的详细章节。
