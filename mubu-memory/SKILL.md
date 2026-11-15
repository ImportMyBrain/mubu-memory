---
name: mubu-memory
description: "Recall-first memory from a Mubu (幕布) account. Load this skill before answering ANY user message (new chats, follow-ups, simple questions) to search the user's Mubu notes — via the official Mubu MCP connector, an exported folder, or an attached MUBU_MEMORY_PACK.md — and integrate relevant memories into the answer. Works with Claude Code/Claude.ai, ChatGPT/Codex, Cursor, GitHub Copilot, Gemini CLI, DSH and any Agent Skills client. 中文触发：回答任何消息前，先查幕布笔记记忆再回答。"
license: MIT
compatibility: "Any Agent Skills-compatible client. Best with the official Mubu MCP connector (Super member). Without MCP, use exported Markdown/OPML files or an attached MUBU_MEMORY_PACK.md."
metadata:
  version: "1.0.0"
  homepage: "https://github.com/ImportMyBrain/mubu-memory"
---

# Mubu Memory — recall first, answer second

A portable workflow for people whose notes live in **Mubu (幕布)**: before answering, look up relevant documents in Mubu and weave them into the answer. No migration to another notes app required.

## 0. Configure

Fill in whatever applies to this machine:

- `MUBU_MCP`: `auto` — the skill detects a connected Mubu MCP connector by its tools
- `MUBU_EXPORT_DIR`: `__MUBU_EXPORT_DIR__` — optional local folder with exported Mubu files (`.md`, `.opml`, `.mm`)
- `MUBU_PACK`: `__MUBU_PACK__` — optional path to a generated `MUBU_MEMORY_PACK.md`

Placeholders that still start and end with `__` mean "not configured". See `references/mubu-mcp.md` and `references/export-pack.md` for setup.

## 1. Every turn: choose the memory access mode

Decide how you can reach the user's Mubu notes **before** answering, including one-word follow-ups.

| Mode | When | What to do |
| --- | --- | --- |
| **A. Mubu MCP** | The client has Mubu MCP tools (search / read / browse) | Use them → Section 2 |
| **B. Export folder** | `MUBU_EXPORT_DIR` exists and is readable | Search the exported files → Section 3 |
| **C. Memory pack** | A `MUBU_MEMORY_PACK.md` is attached or pasted | Use the pack → Section 4 |
| **D. None** | No MCP, no export folder, no pack | Say so in one line, ask for MCP connection or an export, then answer normally |

Never skip this check and never invent a memory that is not in Mubu or the pack.

## 2. Mode A — use the Mubu MCP connector

The official Mubu MCP server exposes tools to **search documents**, **read a document**, **browse folders**, and optionally create or move documents. Tool names vary by client — inspect the available tools first and use the ones that search/read documents.

1. **Extract 2–6 keywords** from the message: people, projects, courses, goals, dates, proper nouns, plus synonyms.
2. **Search documents** with the keywords. Browse folders if search returns nothing.
3. **Read the top 3–5 documents**, newest/most relevant first. Prefer documents in folders that match the topic.
4. **Cite the document title** (and folder) when a memory changes the answer.
5. **Encrypted documents** are not readable through MCP and do not appear in results — do not pretend to know their content.
6. **Do not create, edit, move or delete** anything in Mubu unless the user explicitly asks for it. Read-only by default.
7. **Cost control**: at most 1–2 searches and 5 document reads; reuse results for follow-ups on the same topic.

## 3. Mode B — search an export folder

Experienced users can keep a local export of their Mubu docs (see `references/export-pack.md`). When `MUBU_EXPORT_DIR` is set and readable:

1. Search `.md` files first; they are already plain text.
2. For `.opml` / `.mm`, either read their `text=` attributes directly or (recommended once) convert them:
   `node scripts/mubu-pack.mjs --input "<MUBU_EXPORT_DIR>" --notes-out "<notes dir>"`
3. Read the top 3–5 matching files, then integrate as usual.
4. The export is a snapshot: mention its date if the user asks for "the latest" information.

## 4. Mode C — use a memory pack

A memory pack is a generated Markdown snapshot for clients without local file access or MCP (some web/mobile clients):

- Read the attached/pasted pack; treat it as a read-only snapshot.
- Find the relevant section (profile, goals, projects, recent documents) and cite the document title.
- If the pack lacks the answer, say so; do not extrapolate.
- If it looks stale, ask the user to regenerate it (it starts with a generation date).

## 5. Integrate into the answer

- Weave memory into the answer naturally; do not dump a list of documents.
- Let memory shape conclusions, priorities, tone and examples.
- Cite source and date when possible ("according to your Mubu doc X...").
- Keep "what the note says" separate from "what I infer".
- Sensitive information (finances, IDs, accounts, health, family) only when directly relevant; do not volunteer it.
- **No relevant memory found**: say "I couldn't find relevant documents in your Mubu notes" in one line, then answer normally. Never invent a memory.

## 6. Write back (rare, opt-in)

- This skill is read-only by default.
- If the user explicitly asks to save something to Mubu, use the MCP create-document tool with a **Markdown outline**; confirm the folder first.
- Never store passwords, tokens or API keys anywhere — in Mubu, in the pack, or in the conversation.

## 7. Privacy and safety

- MCP access is controlled by the client's Mubu connection; OAuth or a personal token is stored by the client, never by this skill.
- Never ask the user to paste a Mubu password or token into the chat.
- Only read documents when needed for the current answer; do not bulk-dump the account.
- Encrypted documents are outside MCP access by design; respect that.
- Exports and memory packs contain private note content: keep them local and out of git repositories.
- Use this skill only for the account owner's own sessions.

## 8. Make it run every turn (recommended)

Skills are usually loaded on demand. To run this before every answer, add the one-line rule from `references/always-on.md` to the client's always-on instruction file (`AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `.cursor/rules/`, `.github/copilot-instructions.md`, custom instructions, etc.).
