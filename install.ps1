<#
.SYNOPSIS
    Install the mubu-memory Agent Skill for multiple AI clients.

.DESCRIPTION
    Copies the skill into:

      ~/.agents/skills/mubu-memory   Codex / Cursor / GitHub Copilot / Gemini CLI (user scope)
      ~/.claude/skills/mubu-memory   Claude Code (personal skills)

    With -Project, installs into the target repository instead.
    With -DSH, also installs into ~/.dsh/skills/mubu-memory.
    When -ExportDir is provided, the installed copies get __MUBU_EXPORT_DIR__ replaced
    with the real folder. The repository source keeps the placeholder.

.EXAMPLE
    .\install.ps1 -ExportDir "D:\MubuExport"

.EXAMPLE
    .\install.ps1 -Project -ProjectPath "D:\my-repo" -ExportDir "D:\MubuExport"
#>
param(
    [string]$ExportDir,
    [switch]$Project,
    [string]$ProjectPath = ".",
    [switch]$DSH,
    [switch]$Force,
    [string]$UserHome = $env:USERPROFILE
)

$ErrorActionPreference = 'Stop'
$source = Join-Path $PSScriptRoot 'mubu-memory'
if (-not (Test-Path (Join-Path $source 'SKILL.md'))) {
    throw "Cannot find $source\SKILL.md - run this script from the repository root."
}

$utf8 = New-Object System.Text.UTF8Encoding($false)
$installed = New-Object System.Collections.Generic.List[string]

function Install-Skill([string]$target) {
    $target = [IO.Path]::GetFullPath($target)
    if (Test-Path $target) {
        if (-not $Force) {
            Write-Host "skip (already exists): $target" -ForegroundColor Yellow
            Write-Host "     use -Force to overwrite (the old copy is backed up first)" -ForegroundColor DarkGray
            return
        }
        $backup = "$target.bak-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Move-Item -LiteralPath $target -Destination $backup
        Write-Host "backup: $backup" -ForegroundColor DarkGray
    }

    New-Item -ItemType Directory -Force -Path (Split-Path $target -Parent) | Out-Null
    Copy-Item -LiteralPath $source -Destination $target -Recurse -Force

    if ($ExportDir) {
        $skillFile = Join-Path $target 'SKILL.md'
        $text = [IO.File]::ReadAllText($skillFile, $utf8)
        if ($text.Contains('__MUBU_EXPORT_DIR__')) {
            $text = $text.Replace('__MUBU_EXPORT_DIR__', $ExportDir)
            [IO.File]::WriteAllText($skillFile, $text, $utf8)
        }
    }

    $installed.Add($target)
    Write-Host "installed: $target" -ForegroundColor Green
}

if ($Project) {
    $root = (Resolve-Path $ProjectPath).Path
    Install-Skill (Join-Path $root '.agents\skills\mubu-memory')
    Install-Skill (Join-Path $root '.claude\skills\mubu-memory')
} else {
    Install-Skill (Join-Path $UserHome '.agents\skills\mubu-memory')
    Install-Skill (Join-Path $UserHome '.claude\skills\mubu-memory')
    if ($DSH) {
        Install-Skill (Join-Path $UserHome '.dsh\skills\mubu-memory')
    }
}

Write-Host ""
if ($installed.Count -eq 0) {
    Write-Host "Nothing installed (existing copies were skipped; use -Force to overwrite)." -ForegroundColor Yellow
    exit 0
}

Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "  1. Connect the official Mubu MCP connector in your AI client (Super membership required):"
Write-Host "     https://mubu.com/help/124"
Write-Host "  2. Restart the client so it rescans skills."
Write-Host "  3. No MCP? Export Mubu docs and build a pack:"
Write-Host "     node mubu-memory\scripts\mubu-pack.mjs --input `"D:\MubuExport`" --out MUBU_MEMORY_PACK.md"
Write-Host "  4. For always-on behavior, add the rule from mubu-memory\references\always-on.md"
Write-Host "     to AGENTS.md / CLAUDE.md / GEMINI.md / .cursor/rules / .github/copilot-instructions.md."
Write-Host ""
