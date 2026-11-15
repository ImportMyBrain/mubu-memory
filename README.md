# 🗂️ mubu-memory

<a id="chinese"></a>

**简体中文** | [English](#english)

> 笔记都在幕布，不想迁移？这个 Skill 让 AI 在回答前先查你的幕布。

基于 [Agent Skills 开放标准](https://agentskills.io/specification) 的「记忆优先」Skill：支持通过**幕布官方 MCP** 直接读取/搜索幕布文档，也支持**导出快照**兜底。同一份 `SKILL.md` 可以装进 Claude Code / Claude.ai / ChatGPT / Codex / Cursor / GitHub Copilot / Gemini CLI / DSH 等客户端。

## 为什么需要它

- 你的笔记、项目、复盘全在幕布（mubu.com）；
- 迁移到 Obsidian / Notion 成本太高，也没必要；
- AI 每次对话又像失忆一样，不知道你之前记了什么。

`mubu-memory` 把「先查幕布，再回答」变成固定流程：**回答前先搜索/读取相关幕布文档，判断哪些还有效，整合进答案。不用迁移。**

## ✨ 三种使用模式

| 模式 | 适合谁 | 需要什么 |
| --- | --- | --- |
| **A. 幕布 MCP（推荐）** | 幕布超级会员，客户端支持 MCP | 在 AI 客户端里连接官方幕布 MCP，OAuth 或 Token 授权 |
| **B. 导出目录** | 有本地文件的客户端（Claude Code / Codex / Cursor / Copilot / Gemini / DSH） | 把幕布文档批量导出为 Markdown/OPML/MM，指向这个目录 |
| **C. Memory Pack** | ChatGPT 网页 / Claude.ai / 手机等无本地权限的客户端 | 用脚本把导出文件打包成 `MUBU_MEMORY_PACK.md`，作为 Project 文件或附件 |

## 📦 兼容性

| 客户端 | 使用方式 |
| --- | --- |
| Claude Code | Skill 装到 `~/.claude/skills/`；MCP 或导出目录 |
| Claude.ai | 上传 skill zip；连接 MCP 或附加 Memory Pack |
| ChatGPT 桌面 / Codex CLI / IDE 扩展 | Skill 装到 `~/.agents/skills/`；MCP 或导出目录 |
| ChatGPT 网页 / 移动端 | 附加 `MUBU_MEMORY_PACK.md` 到 Project / 对话 |
| Cursor | `~/.agents/skills/` 或 `~/.cursor/skills/`；支持 MCP |
| GitHub Copilot | `~/.agents/skills/` 或 `~/.copilot/skills/` |
| Gemini CLI | `~/.agents/skills/` 或 `~/.gemini/skills/` |
| DeepSeek Harness（DSH） | `~/.dsh/skills/`（安装脚本加 `-DSH` / `--dsh`） |

## 🚀 安装

### 一键脚本

Windows：

```powershell
git clone https://github.com/ImportMyBrain/mubu-memory.git
cd mubu-memory
.\install.ps1 -ExportDir "D:\MubuExport"   # 没有导出目录可以省略
```

macOS / Linux：

```bash
git clone https://github.com/ImportMyBrain/mubu-memory.git
cd mubu-memory
./install.sh --export-dir "/path/to/MubuExport"   # 可选
```

脚本会把 skill 复制到 `~/.agents/skills/mubu-memory/`（Codex / Cursor / Copilot / Gemini 共用）和 `~/.claude/skills/mubu-memory/`（Claude Code），并在提供导出目录时自动填入配置。

### 手动安装

把 `mubu-memory/` 整个文件夹复制到对应客户端的 skills 目录，然后编辑其中的 `SKILL.md` 第 0 节（见下方配置）。

### 下载 zip

从 [Releases](https://github.com/ImportMyBrain/mubu-memory/releases) 下载 zip，解压后按需复制。

## ⚙️ 配置

编辑 `mubu-memory/SKILL.md` 第 0 节：

```markdown
- `MUBU_MCP`: `auto`                                  # 连接了幕布 MCP 就用
- `MUBU_EXPORT_DIR`: `D:\MubuExport`                  # 可选：导出目录
- `MUBU_PACK`: `MUBU_MEMORY_PACK.md`                  # 可选：记忆快照
```

三种模式只填需要的那一种即可；都没有时，skill 会先说明再正常回答，不会编造。

## 🔌 方式一：连接幕布官方 MCP（推荐）

幕布官方支持 MCP（**超级会员**功能），AI 可以直接搜索、读取你的幕布文档，不用导出。

- 官方说明：<https://mubu.com/help/124>
- OAuth 自动授权：<https://mubu.com/help/125>
- 个人 Token 接入：<https://mubu.com/help/126>

支持 OAuth 的客户端（Claude、ChatGPT、Cursor 等）直接添加连接并登录授权；不能弹授权页的客户端用个人 Token（Token 存在客户端配置里，**不要发到对话里**）。

隐私要点（来自幕布官方说明）：加密文档不会被 MCP 读取，也不会出现在列表里；AI 只在你明确要求时访问幕布；可以随时在幕布「设置 → MCP 连接」里断开。

## 📤 方式二：导出 + Memory Pack（没有 MCP 也能用）

### 批量导出

社区 Chrome 扩展 [Navyum/chrome-extension-mubu-export](https://github.com/Navyum/chrome-extension-mubu-export) 可以在本地批量导出幕布大纲/思维导图，支持 **Markdown / OPML / Freemind (.mm) / HTML / JSON**，保留文件夹层级。它通过浏览器里已登录的 `Jwt-Token` 直接请求 `api2.mubu.com`，不经过第三方服务器。

> 第三方工具，非幕布官方；仅用于备份自己的数据，请遵守幕布服务条款，并自行审查扩展代码。

也可以使用幕布官方的 Word / PDF / 图片导出（见幕布帮助「支持哪些导出/导入格式」「如何导出图片/Word/PDF」）。Word 导出可以先转成 Markdown 再处理。

### 生成 Memory Pack

```bash
node mubu-memory/scripts/mubu-pack.mjs --input "D:\MubuExport" --out MUBU_MEMORY_PACK.md
```

支持 `.md` / `.opml` / `.mm`，会保留标题层级，并生成：

- 个人档案 / 偏好、目标、当前项目摘录
- 最近文档
- 全量文档索引

想生成可直接搜索的 Markdown 笔记目录，加 `--notes-out`：

```bash
node mubu-memory/scripts/mubu-pack.mjs --input "D:\MubuExport" --notes-out "D:\MubuNotes"
```

可以用仓库里的示例数据先试跑：

```bash
node mubu-memory/scripts/mubu-pack.mjs --input examples/sample-export --out /tmp/MUBU_MEMORY_PACK.md
```

然后把 `MUBU_MEMORY_PACK.md` 附加到 ChatGPT Project / Claude 对话，或作为系统提示词的一部分。

## 🔁 让它每轮自动生效（推荐）

在客户端的常驻指令文件里加一行（完整版见 `references/always-on.md`）：

```markdown
## 幕布记忆优先（每轮强制）
回答任何消息之前，先加载 `mubu-memory` skill，从我的幕布账号回忆相关笔记（已连接 MCP 就用 MCP；否则用导出目录或 MUBU_MEMORY_PACK.md），整合后再回答。没查到就用一句话说明并正常回答，不要编造记忆。
```

对应文件：`AGENTS.md`、`CLAUDE.md`、`GEMINI.md`、`.cursor/rules`、`.github/copilot-instructions.md`、ChatGPT/Claude 自定义指令。

## 🔒 隐私

- 不包含任何账号凭据：MCP 的 OAuth / Token 由客户端管理，skill 不读取、不保存。
- 默认只读：只有你明确要求时才会创建/移动幕布文档。
- 加密文档无法通过 MCP 读取（幕布官方限制）。
- 导出目录和 `MUBU_MEMORY_PACK.md` 含私人笔记内容：只放本地，不要提交进 git（仓库 `.gitignore` 已忽略 `MUBU_MEMORY_PACK*.md`、`MUBU_NOTES*/`、`MUBU_EXPORT*/`）。
- 本仓库示例数据全部为虚构文本。

## 🗂️ 目录结构

```
mubu-memory/
├── SKILL.md
├── references/
│   ├── mubu-mcp.md       # 官方 MCP 接入说明
│   ├── export-pack.md    # 导出 + 打包说明
│   └── always-on.md      # 每轮强制配置
├── scripts/
│   └── mubu-pack.mjs     # 导出 → 记忆快照 / Markdown 笔记
└── agents/
    └── openai.yaml       # ChatGPT / Codex 界面元数据
examples/sample-export/   # 虚构示例数据，可直接试跑
install.ps1 / install.sh
README.md / LICENSE
```

## ❓FAQ

**一定要幕布超级会员吗？**
用 MCP 需要超级会员（官方限制）；方式 B/C 不需要，只需导出。

**要迁移笔记吗？**
不用。MCP 直接读；导出只是给不支持 MCP 的客户端做快照，原笔记仍留在幕布。

**加密文档能读吗？**
不能。幕布 MCP 明确不读取加密文档。

**会乱改我的幕布吗？**
默认只读。只有你明确要求时才会调用创建/移动工具。

## 📄 License

[MIT](LICENSE)

## 🔗 相关项目

- [obsidian-memory-anywhere](https://github.com/ImportMyBrain/obsidian-memory-anywhere) —— 同样的思路，笔记在 Obsidian 的版本。

---

<a id="english"></a>

# 🌐 English

[简体中文](#chinese) | **English**

> Your notes live in Mubu (幕布)? Keep them there. This skill makes the AI recall them before answering.

Built on the [Agent Skills open standard](https://agentskills.io/specification), `mubu-memory` works across Claude Code, Claude.ai, ChatGPT/Codex, Cursor, GitHub Copilot, Gemini CLI, DSH and other clients.

## Three modes

| Mode | Who | Requirement |
| --- | --- | --- |
| **A. Mubu MCP (recommended)** | Mubu Super members with an MCP-capable client | Connect the official Mubu MCP connector (OAuth or personal token) |
| **B. Export folder** | Clients with local file access | Batch-export Mubu docs to Markdown/OPML/FreeMind and point the skill at the folder |
| **C. Memory pack** | Chat-only clients (ChatGPT web, Claude.ai, mobile) | Build `MUBU_MEMORY_PACK.md` and attach it |

## Install

```powershell
# Windows
.\install.ps1 -ExportDir "D:\MubuExport"
```

```bash
# macOS / Linux
./install.sh --export-dir "/path/to/MubuExport"
```

Installs to `~/.agents/skills/mubu-memory/` (shared by Codex, Cursor, Copilot, Gemini) and `~/.claude/skills/mubu-memory/` (Claude Code).

## MCP (recommended)

Official docs: <https://mubu.com/help/124> · OAuth: <https://mubu.com/help/125> · Token: <https://mubu.com/help/126>

MCP is a Mubu Super-membership feature. Encrypted documents are not readable through MCP; the AI accesses Mubu only when the conversation asks it to; you can revoke access in Mubu Settings → MCP connections.

## Export fallback

Use a local batch exporter (e.g. the community Chrome extension `Navyum/chrome-extension-mubu-export`, Markdown/OPML/MM/HTML/JSON, keeps folders; third-party, review before use) or Mubu's official Word/PDF/image exports.

```bash
node scripts/mubu-pack.mjs --input "D:\MubuExport" --out MUBU_MEMORY_PACK.md
node scripts/mubu-pack.mjs --input "D:\MubuExport" --notes-out "D:\MubuNotes"
```

Supports `.md`, `.opml`, `.mm`; zero dependencies, no network access. Try the synthetic sample:

```bash
node scripts/mubu-pack.mjs --input examples/sample-export --out /tmp/MUBU_MEMORY_PACK.md
```

## Always-on

Add the rule from `references/always-on.md` to `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.cursor/rules/`, `.github/copilot-instructions.md`, or your client's custom instructions.

## Privacy

- No credentials in this repo; MCP OAuth/tokens live in the client.
- Read-only by default; creates/moves Mubu documents only when explicitly asked.
- Exports and packs contain private notes — keep them local; `.gitignore` covers `MUBU_MEMORY_PACK*.md`, `MUBU_NOTES*/`, `MUBU_EXPORT*/`.
- All sample data in this repository is fictional.

## License

[MIT](LICENSE)

## Related

- [obsidian-memory-anywhere](https://github.com/ImportMyBrain/obsidian-memory-anywhere) — the same idea for Obsidian vaults.
