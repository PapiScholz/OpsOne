[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)][string]$Version
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Path $PSScriptRoot -Parent
$distRoot = Join-Path -Path $repoRoot -ChildPath "dist"
$target = Join-Path -Path $distRoot -ChildPath "opsone-$Version-placeholder.txt"

New-Item -ItemType Directory -Path $distRoot -Force | Out-Null

$content = @"
OpsOne packaging placeholder
Version: $Version
Generated: $((Get-Date).ToUniversalTime().ToString("o"))

TODO:
- Package CLI assets.
- Build signed archive.
- Emit checksums and manifest.
"@

Set-Content -LiteralPath $target -Value $content -Encoding UTF8
Write-Output "Created placeholder package artifact at $target"

