# Export → memory pack (fallback, no MCP)

Use this path when:

- you do not have Mubu Super membership (MCP unavailable), or
- your AI client cannot connect to MCP, or
- you want an offline backup / a stable snapshot.

## 1. Export your Mubu documents

### Option A: third-party Chrome extension (batch, keeps folder tree)

[`Navyum/chrome-extension-mubu-export`](https://github.com/Navyum/chrome-extension-mubu-export) is a community Chrome extension that runs locally:

- batch export of outlines / mind maps
- formats: **Markdown / OPML / Freemind (.mm) / HTML / JSON**
- keeps your Mubu folder hierarchy as local directories
- reads the `Jwt-Token` cookie from your logged-in browser; requests go directly to `api2.mubu.com`

> It is a third-party tool, not affiliated with Mubu. Use it for backing up your own data, follow Mubu's terms of service, and review the extension before installing.

Export to e.g. `D:\MubuExport`.

### Option B: official exports

Mubu also exports Word / PDF / images (see Mubu help: 幕布支持哪些导出/导入格式, 如何导出图片/Word/PDF). For Word exports, convert `.docx` to Markdown first (e.g. with pandoc) before building the pack.

## 2. Build the pack

```bash
node scripts/mubu-pack.mjs --input "D:\MubuExport" --out MUBU_MEMORY_PACK.md
```

Options:

| Flag | Default | Meaning |
| --- | --- | --- |
| `--input <dir>` | `$MUBU_EXPORT_DIR` | folder with exported Mubu files |
| `--out <file>` | `MUBU_MEMORY_PACK.md` | output pack |
| `--notes-out <dir>` | — | also convert `.opml` / `.mm` into plain Markdown notes (searchable) |
| `--max-chars <n>` | `40000` | soft size budget |
| `--days <n>` | `90` | "recent" window |

Supported inputs: `.md` (usually already converted by the exporter), `.opml`, `.mm`. HTML and raw JSON exports are not parsed — prefer Markdown or OPML.

## 3. Use the pack

- **ChatGPT web / mobile:** add `MUBU_MEMORY_PACK.md` to a Project or attach it to the chat.
- **Claude.ai:** attach it to the conversation or a Project.
- **Clients with local file access:** either attach the pack, or point `MUBU_EXPORT_DIR` at the export folder and search the files directly.
- **Better local search:** run with `--notes-out` once, then use the generated Markdown notes folder as a searchable vault.

## 4. Privacy

- The export and the pack contain your private note content. Store them locally.
- Do not commit them: the repository `.gitignore` ignores `MUBU_MEMORY_PACK*.md`, `MUBU_EXPORT*/` and `MUBU_NOTES*/`.
- The converter makes no network requests and does not touch your Mubu account; it only reads the files you point it at.
