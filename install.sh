#!/usr/bin/env bash
# Install the mubu-memory Agent Skill for multiple AI clients.
#
#   ./install.sh --export-dir "/path/to/MubuExport"
#   ./install.sh --project /path/to/repo --export-dir "/path/to/MubuExport"
#   ./install.sh --dsh
#
# Copies the skill to:
#   ~/.agents/skills/mubu-memory   Codex / Cursor / GitHub Copilot / Gemini CLI (user scope)
#   ~/.claude/skills/mubu-memory   Claude Code (personal skills)
#   ~/.dsh/skills/mubu-memory      only with --dsh
set -euo pipefail

EXPORT_DIR=""
PROJECT=""
DSH=0
FORCE=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --export-dir) EXPORT_DIR="${2:-}"; shift 2 ;;
    --project)    PROJECT="${2:-}"; shift 2 ;;
    --dsh)        DSH=1; shift ;;
    --force)      FORCE=1; shift ;;
    -h|--help)    sed -n '2,14p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown option: $1" >&2; exit 1 ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$SCRIPT_DIR/mubu-memory"
[[ -f "$SRC/SKILL.md" ]] || { echo "Cannot find $SRC/SKILL.md — run this script from the repository root." >&2; exit 1; }

installed=0

install_skill() {
  local target="$1"
  if [[ -e "$target" ]]; then
    if [[ "$FORCE" -ne 1 ]]; then
      echo "skip (already exists): $target"
      echo "     use --force to overwrite (the old copy is backed up first)"
      return 0
    fi
    local backup="$target.bak-$(date +%Y%m%d-%H%M%S)"
    mv "$target" "$backup"
    echo "backup: $backup"
  fi

  mkdir -p "$(dirname "$target")"
  cp -R "$SRC" "$target"

  if [[ -n "$EXPORT_DIR" && -f "$target/SKILL.md" ]]; then
    local tmp="$target/SKILL.md.tmp"
    while IFS= read -r line || [[ -n "$line" ]]; do
      printf '%s\n' "${line//__MUBU_EXPORT_DIR__/$EXPORT_DIR}"
    done < "$target/SKILL.md" > "$tmp"
    mv "$tmp" "$target/SKILL.md"
  fi

  echo "installed: $target"
  installed=$((installed + 1))
}

if [[ -n "$PROJECT" ]]; then
  install_skill "$PROJECT/.agents/skills/mubu-memory"
  install_skill "$PROJECT/.claude/skills/mubu-memory"
else
  install_skill "$HOME/.agents/skills/mubu-memory"
  install_skill "$HOME/.claude/skills/mubu-memory"
  if [[ "$DSH" -eq 1 ]]; then
    install_skill "$HOME/.dsh/skills/mubu-memory"
  fi
fi

echo ""
if [[ "$installed" -eq 0 ]]; then
  echo "Nothing installed (existing copies were skipped; use --force to overwrite)."
  exit 0
fi

echo "Next steps:"
echo "  1. Connect the official Mubu MCP connector in your AI client (Super membership required):"
echo "     https://mubu.com/help/124"
echo "  2. Restart the client so it rescans skills."
echo "  3. No MCP? Export Mubu docs and build a pack:"
echo "     node mubu-memory/scripts/mubu-pack.mjs --input \"/path/to/MubuExport\" --out MUBU_MEMORY_PACK.md"
echo "  4. For always-on behavior, add the rule from mubu-memory/references/always-on.md"
echo "     to AGENTS.md / CLAUDE.md / GEMINI.md / .cursor/rules / .github/copilot-instructions.md."
echo ""
