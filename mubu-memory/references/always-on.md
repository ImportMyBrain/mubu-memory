# Always-on instructions (make the skill run every turn)

Add the rule below to the client's always-on instruction file so the assistant checks Mubu before every answer.

## The rule (English)

```markdown
## Mubu memory first (every turn)
Before answering any message, load the `mubu-memory` skill and recall relevant notes from my Mubu (幕布) account — use the Mubu MCP tools if connected, otherwise the export folder or MUBU_MEMORY_PACK.md — then integrate those memories into the answer. Do this for new chats, follow-ups, simple questions and short messages too. If nothing relevant is found, say so in one line and answer normally; never invent memories.
```

## 中文版

```markdown
## 幕布记忆优先（每轮强制）
回答任何消息之前，先加载 `mubu-memory` skill，从我的幕布账号回忆相关笔记（已连接 MCP 就用 MCP；否则用导出目录或 MUBU_MEMORY_PACK.md），整合后再回答。新对话、追问、简单问题、短消息都要做；没查到就用一句话说明并正常回答，不要编造记忆。
```

## Where to put it

| Client | File |
| --- | --- |
| Claude Code | `CLAUDE.md` in the project, or `~/.claude/CLAUDE.md` globally |
| Codex CLI / ChatGPT desktop | `AGENTS.md` in the repo, or `~/.codex/AGENTS.md` globally |
| Cursor | `AGENTS.md` in the repo, or a `.cursor/rules/*.mdc` rule with `alwaysApply: true` |
| GitHub Copilot | `.github/copilot-instructions.md`, or user-level custom instructions |
| Gemini CLI | `GEMINI.md` |
| DSH | `AGENTS.md` in the workspace, or the global instruction file |
| Claude.ai / ChatGPT web | Personal preferences / custom instructions, or Project instructions |

## Manual invocation

- Claude Code: `/mubu-memory`
- Codex CLI: `$mubu-memory` (or open `/skills`)
- Cursor: `/mubu-memory` or `@mubu-memory`
- ChatGPT desktop: `@` and pick the skill
- Others: type the skill name with the client's invocation syntax

Always-on instructions affect every conversation in that scope. Prefer workspace-level files over global ones if the same machine also runs group-chat bots or unrelated agents.
