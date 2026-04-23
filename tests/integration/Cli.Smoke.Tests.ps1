Describe "OpsOne CLI smoke" {
    BeforeAll {
        $repoRoot = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent
        $script:entry = Join-Path -Path $repoRoot -ChildPath "opsone.ps1"
    }

    It "returns help payload" {
        $raw = & $script:entry help
        $parsed = $raw | ConvertFrom-Json
        $parsed.status | Should Be "ok"
    }
}
