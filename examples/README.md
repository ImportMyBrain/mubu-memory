# Sample Mubu export (synthetic)

`sample-export/` contains **fictional** documents shaped like a Mubu export. Use it to try the converter without touching real data:

```bash
node scripts/mubu-pack.mjs --input examples/sample-export --out /tmp/MUBU_MEMORY_PACK.md --notes-out /tmp/MUBU_NOTES
```

Included:

- `个人档案/关于我（示例）.opml` — OPML outline
- `项目/示例项目.md` — Markdown export
- `项目/示例思维导图.mm` — FreeMind export
- `目标/2026 目标（示例）.opml` — OPML outline

All names and content are placeholders. Replace this folder with your own export (see `obsidian-memory/references/export-pack.md`).
