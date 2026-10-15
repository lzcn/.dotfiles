# Neovim 速查

终端 LazyVim 与 VS Code 共用 `~/.config/nvim`。`Space` 是 leader，`\` 是 localleader，`Alt` 是 macOS 的 `Option`。

模式：`n` 普通，`i` 插入，`x` 可视，`o` 操作符待定，`c` 命令行，`t` 终端。前面的按键按本地 LazyVim 记录，VS Code 的适配集中放在后面。

## 常用按键

### LazyVim 通用

| 按键 | 操作 | 模式 |
| --- | --- | --- |
| `Ctrl+h/j/k/l` | 切换窗口 | n |
| `Ctrl+方向键` | 调整窗口大小 | n |
| `Space -` / `Space \|` | 下方／右侧分屏 | n |
| `Space wd` / `Space wm` | 关闭／最大化窗口 | n |
| `H` / `L` / `Space bb` | 前一个／后一个／上次文件 | n |
| `Space bd` / `Space bo` | 关闭当前／其他文件 | n |
| `Alt+j/k` | 移动行或选区 | n, i, x |
| `Ctrl+s` | 保存 | n, i, x |
| `Esc` | 退出当前模式并清除搜索高亮 | n, i |
| `gco` / `gcO` | 下方／上方插入注释行 | n |
| `Space Tab Tab` / `Space Tab d` | 新建／关闭 tab | n |
| `Space Tab [` / `Space Tab ]` | 前一个／后一个 tab | n |
| `Space qq` | 退出全部窗口 | n |

`buffer` 是打开的文件，`tab` 是一套窗口布局；顶部 bufferline 标签栏显示的是 buffer。

### Neovim LSP（LazyVim 及语言 extra 映射）

| 按键 | 操作 | 模式 |
| --- | --- | --- |
| `gd` / `gD` | 定义／声明 | n |
| `gr` / `gI` / `gy` | 引用／实现／类型定义 | n |
| `K` / `gK` | 文档／签名帮助 | n |
| `Space ca` / `Space cr` / `Space co` | 代码操作／重命名／整理 imports | n；ca 也支持 x |
| `Space cR` / `Space cA` | 重命名文件／源操作 | n |
| `Space ss` / `Space sS` | 文件／工作区符号 | n |
| `Space cd` | 当前行诊断 | n |
| `[d` / `]d`、`[e` / `]e`、`[w` / `]w` | 前后诊断／错误／警告 | n |

### snacks.nvim

| 按键 | 操作 | 模式 |
| --- | --- | --- |
| `Space Space` / `Space ff` | 找文件 | n |
| `Space /` / `Space sw` | 项目搜索／搜索光标词或选区 | n；sw 也支持 x |
| `Space fr` / `Space ,` | 最近文件／文件列表 | n |
| `Space e` | 文件树 | n |
| `Space gg` / `Space gs` | LazyGit／Git 状态 | n |
| `Space sh` / `Space sk` | 帮助文档／键位搜索 | n |
| `Space n` / `Space .` | 通知历史／临时笔记 | n |
| `Space ft` / `Ctrl+/` | 终端 | n；Ctrl+/ 也支持 t |
| `Space uw` / `Space uz` / `Space uZ` | 折行／专注模式／窗口最大化 | n |
| `Space uL` / `Space ul` / `Space ud` | 相对行号／行号／诊断开关 | n |
| `Space uC` | 预览切换配色 | n |

本地文件树：`a` 新建，目录名以 `/` 结尾；`c/m` 复制／移动，`y` 复制路径，`o` 用系统程序打开。

### 编辑插件

| 来源 | 按键 | 操作 | 模式 |
| --- | --- | --- | --- |
| which-key.nvim | 前缀键后停顿／`Space ?` | 键位提示／当前 buffer 键位 | n |
| flash.nvim | `s` / `S` | 跳转／语法块选择 | n, o, x |
| flash.nvim | `r` / `R` | 远程操作／Treesitter 搜索 | o；R 也支持 x |
| grug-far.nvim | `Space sr` | 项目查找替换 | n, x |
| conform.nvim（LazyVim 入口） | `Space cf` / `Space cF` | 格式化文件或选区／嵌入语言 | n, x |
| trouble.nvim | `Space xx` / `Space cs` | 诊断列表／符号列表 | n |
| todo-comments.nvim | `Space xt` / `[t` / `]t` | TODO 列表／前后 TODO | n |
| noice.nvim | `Space snh` / `Space snd` | 消息历史／清除消息 | n |
| noice.nvim | `Ctrl+f/b` | 文档或消息浮窗翻页 | n, i |
| bufferline.nvim | `Space bj` / `Space bp` / `Space br` | 挑选／固定文件／关闭右侧文件 | n |

`Space sr` 打开替换面板，填搜索词和替换词后按面板提示预览、执行。`s` 跳转先输入搜索字符，再按目标标签。

### gitsigns.nvim

| 按键 | 操作 | 模式 |
| --- | --- | --- |
| `[h` / `]h` | 前一个／后一个改动块 | n |
| `Space ghp` / `Space ghb` | 预览改动／当前行 blame | n |
| `Space ghs` / `Space ghr` | 暂存／重置改动块或选区 | n, x |
| `Space ghu` | 撤销改动块暂存 | n |

### persistence.nvim

| 按键 | 操作 | 模式 |
| --- | --- | --- |
| `Space qs` / `Space ql` | 恢复当前目录会话／最近会话 | n |
| `Space qS` | 选择会话 | n |
| `Space qd` | 停止保存当前会话 | n |

## 已启用的 Extras

### mini.surround

| 按键 | 操作 | 模式 |
| --- | --- | --- |
| `gsaiw"` | 给光标词加双引号 | n |
| `gsa"` | 给选区加双引号 | x |
| `gsd"` / `gsr")` | 删除双引号／将双引号换成圆括号 | n |
| `gsf` / `gsF` | 查找右侧／左侧包围符 | n |

### yanky.nvim / vim-illuminate

| 来源 | 按键 | 操作 | 模式 |
| --- | --- | --- | --- |
| yanky.nvim | `Space p` | 复制历史 | n, x |
| yanky.nvim | `[y` / `]y` | 粘贴后循环复制历史 | n |
| vim-illuminate | `[[` / `]]` | 前一个／后一个同名符号 | n |
| vim-illuminate | `Space ux` | 同名符号高亮开关 | n |

### nvim-dap / nvim-dap-ui

| 按键 | 操作 | 模式 |
| --- | --- | --- |
| `Space db` / `Space dB` | 普通／条件断点 | n |
| `Space dc` / `Space dP` | 启动或继续／暂停 | n |
| `Space di` / `Space do` / `Space dO` | 步入／步出／步过 | n |
| `Space du` / `Space dt` | 调试面板／终止 | n |

### Python / LaTeX / Markdown

| 来源 | 按键 | 操作 | 模式 |
| --- | --- | --- | --- |
| venv-selector.nvim | `Space cv` | 选择 Python 环境 | n |
| nvim-dap-python | `Space dPc` / `Space dPt` | 调试 Python 类／方法 | n |
| vimtex | `\ll` / `\lv` / `\lt` | 编译／查看 PDF／目录 | n |
| render-markdown.nvim | `Space um` | buffer 内 Markdown 渲染开关 | n |
| markdown-preview.nvim | `Space cp` | 浏览器 Markdown 预览开关 | n |

JSON、TOML、YAML 的 extra 提供语言服务；Markdown 使用 Marksman，LaTeX 使用 Texlab。

## 补全：blink.cmp / Copilot

本地补全菜单不预选候选；先选择，再确认。Copilot 通过原生行内建议显示灰色文本。

| 按键 | 操作 | 模式 |
| --- | --- | --- |
| `Ctrl+n/p` / `↓/↑` | 下一个／上一个候选 | i |
| `Enter` | 确认选中候选 → 接受 Copilot 建议 → 换行 | i |
| `Ctrl+y` | 选择并确认候选 | i |
| `Ctrl+Space` | 触发补全／切换文档 | i |
| `Ctrl+e` | 取消补全 | i |
| `Tab` / `Shift+Tab` | 下一／上一片段占位；Tab 也可接受 AI 建议 | i |
| `Ctrl+k` | 签名帮助开关 | i |
| `Alt+]` / `Alt+[` | 下一／上一 Copilot 建议 | n, i |

命令行补全：`Tab` / `Shift+Tab` 或 `Ctrl+n/p` 选候选，`Ctrl+y` 确认，`Ctrl+e` 取消。

## 个人修改

- `J` 合并行后保留光标位置；可视模式 `p` 使用 `"_dP`，保留原复制内容。两边共享。
- 本地 `Alt+Shift+f` 调用格式化，与 VS Code 原生按键一致。

### 折行与中文

Markdown、纯文本、LaTeX、RST、AsciiDoc、Git 提交和邮件默认折行；代码保持默认不折行，项目设置可另行指定。LazyVim 的 `j/k` 按显示行移动，`5j/5k` 按逻辑行移动；VS Code 使用编辑器的折行位置。普通模式和字符可视模式支持显示行移动，VS Code 的整行／块选择仍按逻辑行移动。

中文使用 [jieba.vim](https://github.com/kkew3/jieba.vim)，本地和 VS Code 共用：

| 按键 | 操作 | 模式 |
| --- | --- | --- |
| `w/b/e/ge` | 后一词首／前一词首／词尾／前一词尾 | n, x, o |
| `W/B/E/gE` | 对应的大词移动 | n, x, o |
| `iw/aw` / `iW/aW` | 词内／含周围空白的词对象 | x, o |

例如 `南京市长江大桥` 上按 `w` 到“长江大桥”，`diw` 删除光标所在中文词，`yiw` 复制该词。

## 格式化与语言工具

默认手动格式化，用 `Space cf`；本地也可用 `Alt+Shift+f`。

| 文件类型 | 本地工具 | 参数 |
| --- | --- | --- |
| Python | Ruff：格式化、整理 imports | 行宽 120 |
| sh / zsh | shfmt／beautysh | 缩进 2 空格 |
| JSON / YAML / Markdown | Prettier | 默认参数 |

Pyright 提供 Python 语言服务，类型检查关闭；Ruff 的 lint、Markdown 的 markdownlint 诊断关闭。Markdown 标有 `<!-- toc -->` 时可用 markdown-toc 生成目录。

## 两边的区别

- 本地查找和文件树使用 `cwd`；VS Code 使用工作区。
- VS Code Markdown 预览用 `Shift+h/l` 切换前后标签，`Ctrl+h/j/k/l` 切换相邻编辑器组。
- 本地文件树：`a` 新建（目录名以 `/` 结尾），`c/m` 复制／移动，`y` 复制路径，`o` 用系统程序打开。
- VS Code Explorer：`yy/xx/p` 复制／剪切／粘贴文件，`yp/yP` 复制完整／相对路径，`dd` 删除，`a/A` 新建文件／目录，`o` 打开。`Space e` 进入后再按一次关闭；`Esc` 或 `Ctrl+l` 返回编辑器；`Space E` 定位当前文件。
- 本地 `Space ?` 是 which-key，VS Code 是额外适配的操作菜单。`Space br` 关闭右侧文件；VS Code 的 `Space ue` 开关侧栏。
- 本地补全用 `Ctrl+n/p` 或方向键选项；`Tab` 主要跳片段。两边 `Enter` 都是：选中的候选 → 行内建议 → 换行。
- 默认手动格式化。Python 本地用 Ruff，VS Code 用 Black，行宽都是 120。sh/zsh 缩进 2 空格；Python 4 空格。
- 本地专用：`Space p` 复制历史列表，`Space cv` Python 环境，`Space um/cp` Markdown 渲染／预览，`\ll/lv/lt` LaTeX 编译／查看／目录，`Space qs/ql` 恢复会话。
- 调试：本地 `Space db/dc/di/do/dO/dt` 是断点／继续／步入／步出／步过／终止；VS Code 用原生调试界面。

## VS Code 补充配置

安装 VS Code Neovim 扩展。共享 Lua 配置优先使用 LazyVim 官方 VS Code extra；下面补充 Neovim 启动设置，以及编辑器、Explorer、终端和预览中的 Vim 按键适配。

### 新增 VS Code 适配

共享插件：Flash、mini.surround、Yanky、jieba.vim。以下按键改为调用 VS Code 命令：

| 按键 | VS Code 中的操作 |
| --- | --- |
| 预览 `Shift+h/l`（`H/L`） | 前一个／后一个标签 |
| `j/k` / `↑/↓` | 按折行移动；带数字时按逻辑行移动 |
| `Space ff` / `Space sw` / `Space sr` / `Space ,` | 找文件／搜索光标词／项目替换／文件列表 |
| `Space e` / `Space E` / `Space ue` | Explorer／定位当前文件／开关侧栏 |
| `Ctrl+h/j/k/l` / `Space -` / `Space \|` / `Space wd` / `Space wm` | 切换编辑器、侧栏和面板／分屏／关闭或最大化编辑器组 |
| `Space bb` / `Space bd` / `Space bo` / `Space br` | 上次文件／关闭当前或其他文件／关闭右侧文件 |
| `gr` / `gI` / `gy` / `Space cr` / `Space ca` / `Space co` / `Space sS` | 引用／实现／类型／重命名／代码操作／整理 imports／工作区符号 |
| `Alt+j/k` / `Ctrl+s` / `Space cf` / `Alt+Shift+f` | 移动行／保存／格式化；普通、可视模式格式化转发给扩展 |
| `[d` / `]d` / `Space xx` | 前后诊断／Problems 面板 |
| `Space gg` / `[h` / `]h` / `Space ghp` | 源代码管理侧栏／前后改动／预览改动 |
| `Space uw` / `Space uz` / `Space ?` | 折行／专注模式／操作菜单 |
| Explorer `yy/xx/p` / `dd` / `yp/yP` / `o` | 复制、剪切、粘贴／删除／复制完整或相对路径／打开 |
| Explorer `Esc` / `Ctrl+l` / `Space e` | 返回编辑器／关闭侧栏 |
| 插入模式 `Enter` | 接受选中候选或行内建议，否则换行 |
| 终端 `Ctrl+/` | 返回编辑器 |

Explorer 的 `p` 和 `a/A` 由 VS Code Neovim 扩展提供。

VS Code 中 `Space ?` 打开可搜索的适配按键菜单；前缀停顿时不会自动弹出 which-key 提示。

撤销保持扩展默认：`u/Ctrl+r` 使用 Neovim，`Cmd+z/Cmd+Shift+z` 使用 VS Code，各自的历史没有统一。AI 修改优先使用对应工具的撤销；直接写磁盘的改动不保证进入编辑器撤销历史。
