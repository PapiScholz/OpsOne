function Get-OpsOneConfig {
    [CmdletBinding()]
    param(
        [string]$Path
    )

    $repoRoot = Get-OpsOneRepoRoot
    $configPath = $Path
    if ([string]::IsNullOrWhiteSpace($configPath)) {
        $configPath = Join-Path -Path $repoRoot -ChildPath "config/default.json"
    }

    if (-not (Test-Path -LiteralPath $configPath)) {
        throw "Configuration file not found at '$configPath'."
    }

    $config = Get-Content -LiteralPath $configPath -Raw | ConvertFrom-Json -Depth 16
    $runRootAbs = Join-Path -Path $repoRoot -ChildPath $config.runRoot

    $config | Add-Member -NotePropertyName repoRoot -NotePropertyValue $repoRoot -Force
    $config | Add-Member -NotePropertyName configPath -NotePropertyValue $configPath -Force
    $config | Add-Member -NotePropertyName runRootAbs -NotePropertyValue $runRootAbs -Force

    if (-not (Test-Path -LiteralPath $runRootAbs)) {
        New-Item -ItemType Directory -Path $runRootAbs -Force | Out-Null
    }

    return $config
}

