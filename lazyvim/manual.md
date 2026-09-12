# LazyVim 使用手册

每个模式列都是缩写：

```text
n 普通   i 插入   v/x 可视   o 待定   c 命令行   t 终端
```

## 目录

1. [编辑基础](#1-编辑基础)
2. [LSP：代码智能](#2-lsp代码智能)
3. [核心插件](#3-核心插件)
4. [已启用的 Extras](#4-已启用的-extras)
5. [补全（blink.cmp）](#5-补全blinkcmp)
6. [自定义汇总](#6-自定义汇总)
7. [格式化与语言工具](#7-格式化与语言工具)

---

## 1. 编辑基础

窗口、buffer、分屏这些日常操作：

| 按键 | 功能 | 模式 |
| --- | --- | --- |
| `<C-h/j/k/l>` | 在窗口间移动 | n |
| `<C-方向键>` | 调整窗口大小 | n |
| `<S-h>` / `<S-l>` | 上一个 / 下一个 buffer | n |
| `<leader>bd` / `<leader>bo` | 关闭当前 / 其他 buffer | n |
| `<leader>-` / `<leader>\|` | 水平 / 垂直分屏 | n |
| `<leader>wd` / `<leader>wm` | 关闭 / 最大化当前窗口 | n |
| `<leader><tab><tab>` | 新建 tab | n |
| `<C-/>` | 浮动终端（仓库根目录） | n, t |
| `<A-j>` / `<A-k>` | 移动当前行或选区 | n, i, v |
| `<esc>` | 清除搜索高亮 | i, n, s |
| `gco` / `gcO` | 下 / 上方插入注释行 | n |
| `<C-s>` | 保存文件 | i, x, n, s |
| `<leader>l` | 打开 Lazy 插件管理器 | n |
| `<leader>qq` | 退出全部窗口 | n |

界面细节开关都挂在 `<leader>u` 前缀下（换行、行号、拼写、诊断、动画、Inlay Hints、深色背景），记不住就交给 which-key。

## 2. LSP：代码智能

语言服务器由 `nvim-lspconfig` 驱动、Mason 安装。跳转、引用、重命名、诊断都在这里。

| 按键 | 功能 | 模式 |
| --- | --- | --- |
| `gd` / `gD` | 跳转到定义 / 声明 | n |
| `gr` / `gI` / `gy` | 查找引用 / 实现 / 类型定义 | n |
| `K` / `gK` | 悬浮文档 / 签名帮助 | n |
| `<leader>ca` | 代码操作 | n, x |
| `<leader>cr` | 重命名符号 | n |
| `<leader>co` | 整理 imports | n |
| `<leader>cd` | 查看当前行诊断 | n |
| `[d` / `]d`、`[e` / `]e`、`[w` / `]w` | 上 / 下一个诊断、错误、警告 | n |
| `<leader>cm` | 打开 Mason 面板 | n |

不常用但存在：`<leader>cA`（源操作）、`<leader>cc`/`<leader>cC`（CodeLens）、`<leader>cR`（重命名文件）、`<leader>ss`/`<leader>sS`（LSP 符号）、`gai`/`gao`（调用方/被调用方）、`]]`/`[[`（跳转到下/上一个高亮引用）。

## 3. 核心插件

这些插件随 LazyVim 默认安装，不需要单独开启 extra。

### snacks.nvim — 核心工具箱

一个插件顶多个：模糊查找、文件树、浮动终端、Lazygit 面板、通知历史、scratch 缓冲全在这里，是日常用得最多的插件。

| 按键 | 功能 | 模式 |
| --- | --- | --- |
| `<leader><space>` / `<leader>ff` | 查找文件（仓库根目录） | n |
| `<leader>/` | 全文搜索（仓库根目录） | n |
| `<leader>fr` | 最近文件 | n |
| `<leader>,` | 切换 buffer | n |
| `<leader>e` | 打开文件树 | n |
| `<leader>gg` | 浮窗 Lazygit | n |
| `<leader>gs` | Git 状态 | n |
| `<leader>sw` | 搜索光标词 | n |
| `<leader>sh` / `<leader>sk` | 搜索帮助文档 / 搜索键位 | n |
| `<leader>n` | 通知历史 | n |
| `<leader>.` | 临时笔记 buffer 开关 | n |
| `<leader>uC` | 预览切换配色主题 | n |

其余以 `<leader>f*`（查找）、`<leader>s*`（搜索）、`<leader>g*`（Git）开头的键位都是同一套，记不住就交给 which-key 浏览。

### which-key.nvim — 键位提示

按下任意前缀键（`<leader>`、`g`、`<leader>u` 等）停顿片刻，自动弹出可用键位菜单。`<leader>?` 查看当前 buffer 的全部键位。不需要专门记它的按键。

### flash.nvim — 快速跳转

按 `s` 后输入目标位置附带的字母即可跳转到屏幕上任意位置；替代逐字符按 `f`/`t` 的方式。

| 按键 | 功能 | 模式 |
| --- | --- | --- |
| `s` | 跳转 | n, o, x |
| `S` | Treesitter 节点选择（选中一个函数/类等语法块） | n, o, x |
| `<C-space>` | Treesitter 增量选择 | n, o, x |

### grug-far.nvim — 项目级查找替换

`<leader>sr` 打开面板：输入搜索词和替换词，实时预览所有匹配，确认后一次性替换整个仓库。

### trouble.nvim + todo-comments.nvim — 诊断与 TODO 列表

trouble 把诊断/符号/TODO 汇总成侧栏列表；todo-comments 负责高亮和收集 `TODO`/`FIX`/`FIXME` 注释。

| 按键 | 功能 | 模式 |
| --- | --- | --- |
| `<leader>xx` | 查看全部诊断 | n |
| `<leader>xt` | TODO 列表 | n |
| `[t` / `]t` | 上一个 / 下一个 TODO 注释 | n |

### noice.nvim — 命令行与消息 UI

把默认的命令行、消息提示、搜索框重绘成浮动窗口，视觉上更干净。`<C-f>`/`<C-b>` 在消息里翻页；`<leader>snh` 查看历史消息，`<leader>snd` 清空。

### persistence.nvim — 会话恢复

退出 Neovim 时自动记住打开的 buffer 和窗口布局，下次可以恢复。

| 按键 | 功能 | 模式 |
| --- | --- | --- |
| `<leader>qs` | 恢复上次会话 | n |
| `<leader>qd` | 退出且不保存本次会话 | n |

### bufferline.nvim — 顶部标签栏

显示所有打开的 buffer，附带图标和 LSP 诊断角标。`<leader>bj` 挑选 buffer，`<leader>bp` 固定/取消固定。

### conform.nvim + mason.nvim — 格式化与工具安装

conform.nvim 是格式化引擎，按文件类型调用对应工具（见 [第 7 节](#7-格式化与语言工具)）；mason.nvim 负责安装 LSP、格式化器、调试适配器这些外部工具，`<leader>cm` 打开面板查看/安装。日常触发格式化用 `<leader>cf`，嵌入语言（如 Markdown 里的代码块）用 `<leader>cF`。

## 4. 已启用的 Extras

以下是当前开启的可选功能；没提到的官方 extras（如 `avante`、`harpoon`、`neotest`）都还没开。

### copilot-native — `ai.copilot-native`

打字停顿后出现的灰色 ghost text 建议，走 Neovim 原生的 inline completion 接口（无侧边栏对话形式）。接受方式见 [补全](#5-补全blinkcmp) 一节（`<CR>` 会优先取它）。

### mini.surround — `coding.mini-surround`

批量添加/删除/替换引号、括号等“包围符”，不用一个个手动改。

| 按键 | 功能 | 模式 |
| --- | --- | --- |
| `gsa{对象}{符}` | 添加，例如 `gsaiw"` 给光标所在单词加双引号 | n, x |
| `gsd{符}` | 删除，例如 `gsd"` | n |
| `gsr{旧}{新}` | 替换，例如 `gsr"(` 把双引号换成圆括号 | n |

### yanky.nvim — `coding.yanky`

给 `y`/`p`/`P` 加上历史记录，粘贴后还能在历史里换着挑。

| 按键 | 功能 | 模式 |
| --- | --- | --- |
| `<leader>p` | 打开 Yank 历史 | n, x |
| `[y` / `]y` | 粘贴后循环替换为更早 / 更晚的历史记录 | n |

### vim-illuminate — `editor.illuminate`

自动高亮光标所在符号在当前 buffer 里的其他出现位置，`]]`/`[[` 在它们之间跳转。

### nvim-dap + nvim-dap-ui — `dap.core`

调试器框架，调试适配器由 Mason 安装；开始调试会自动弹出变量/调用栈这些窗口。

| 按键 | 功能 | 模式 |
| --- | --- | --- |
| `<leader>db` / `<leader>dB` | 普通 / 条件断点 | n |
| `<leader>dc` | 启动 / 继续 | n |
| `<leader>di` / `<leader>do` / `<leader>dO` | 步入 / 步出 / 步过 | n |
| `<leader>du` | 打开 Dap UI | n |
| `<leader>dt` | 终止调试 | n |

### nvim-dap-python + venv-selector.nvim — `lang.python`

Python 专属的调试封装和虚拟环境选择器。

| 按键 | 功能 | 模式 |
| --- | --- | --- |
| `<leader>dPc` / `<leader>dPt` | 调试整个类 / 当前方法 | n |
| `<leader>cv` | 选择 Python 虚拟环境 | n |

### vimtex — `lang.tex`

LaTeX 编译、正向反向搜索、目录导航。`<localleader>l` 打开它的子菜单。

### Markdown 全家桶 — `lang.markdown`

一个 extra 打包了 Markdown 相关的四块能力，各司其职：

| 部件 | 作用 |
| --- | --- |
| render-markdown.nvim | **buffer 内直接渲染**：代码块加背景、标题分级展示，编辑时接近成稿效果 |
| markdown-preview.nvim | **浏览器实时预览**，适合最终排版检查 |
| marksman（LSP） | Markdown 补全与链接跳转 |
| prettier + markdown-toc | 格式化；`markdown-toc` 仅在文件里有 `<!-- toc -->` 标记时才生成目录 |

| 按键 | 功能 | 模式 |
| --- | --- | --- |
| `<leader>um` | buffer 内渲染开 / 关 | n |
| `<leader>cp` | 浏览器预览开 / 关 | n |

markdownlint（MD0xx 诊断）已在本仓库禁用 **`*`**：`core.lua` 把 `nvim-lint` 的 markdown linter 设为 `false`，纯粹是渲染 + 预览，不做风格检查。

### lang.json / lang.toml / lang.yaml

只提供对应格式的 LSP（校验、补全）和 SchemaStore 自动匹配 schema，没有额外键位。

## 5. 补全（blink.cmp）**\***

blink.cmp 不在 LazyVim 官方键位页面上；`<CR>` 由 [`core.lua`](../nvim/lua/plugins/core.lua) 显式配置，优先取 Copilot 的 ghost text（复用 `ai.copilot-native` 注册的 `LazyVim.cmp.actions.ai_accept`），其余都是 blink.cmp 自带默认行为。

| 按键 | 功能 | 模式 |
| --- | --- | --- |
| `<CR>` **\*** | 确认菜单项 → 取 Copilot ghost text → 正常换行 | i |
| `<Tab>` / `<S-Tab>` | 菜单中切换选项；关闭时跳 snippet 占位符或正常缩进 | i |
| `<C-e>` | 关闭补全菜单 | i |
| `<C-space>` | 手动触发补全 | i |
| `<C-k>` | 签名帮助 | i |

## 6. 自定义汇总

本仓库对 LazyVim 默认值做的全部修改，方便一眼确认：

| 按键/行为 | 内容 | 来源 |
| --- | --- | --- |
| `<A-o>` **\*** | 查找文件，等价于 `<leader>ff` | `keymaps.lua` |
| `<A-F>` **\*** | 格式化当前文件，等价于 `<leader>cf` | `keymaps.lua` |
| `<CR>` 补全逻辑 **\*** | 见 [第 5 节](#5-补全blinkcmp) | `core.lua` |
| 关闭 Markdown 的 markdownlint 诊断 **\*** | 见 [Markdown 全家桶](#markdown-全家桶--langmarkdown) | `core.lua` |
| 格式化工具与参数 **\*** | 见 [第 7 节](#7-格式化与语言工具) | `core.lua` |
| pyright / ruff 设置 **\*** | 见 [第 7 节](#7-格式化与语言工具) | `core.lua` |
| 关闭自动格式化、snacks 动画；剪贴板用系统寄存器 **\*** | — | `options.lua` |
| 配色主题 Catppuccin Mocha **\*** | — | `core.lua` |
| 关闭 Markdown / Git commit 消息的拼写检查 **\*** | 默认拼写检查对代码标识符和中英混排误报太多 | `autocmds.lua` |

## 7. 格式化与语言工具

非键位，是 [`core.lua`](../nvim/lua/plugins/core.lua) 对格式化器和 LSP 的定制；触发方式仍是 `<leader>cf` / `<A-F>`。

| 文件类型 | 工具 | 参数 |
| --- | --- | --- |
| Python | ruff（format + organize imports） | 行宽 120 |
| sh | shfmt | 缩进 2 空格 |
| zsh | beautysh | 缩进 2 空格 |
| JSON / YAML / Markdown 等 | prettier | 默认参数 |

LSP 定制：pyright 关闭 import 整理（交给 ruff）、完全关闭类型检查（`typeCheckingMode = "off"`）；ruff 只负责格式化和整理 imports，关闭了它自带的 lint。Markdown 的 lint（markdownlint）已整体关闭。
