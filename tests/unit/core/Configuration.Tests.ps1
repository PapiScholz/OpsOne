Describe "Get-OpsOneConfig" {
    BeforeAll {
        $repoRoot = Split-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -Parent
        . (Join-Path -Path $repoRoot -ChildPath "src/core/Utils.ps1")
        . (Join-Path -Path $repoRoot -ChildPath "src/core/Configuration.ps1")
    }

    It "loads default config with absolute run root" {
        $config = Get-OpsOneConfig
        $config.runRootAbs | Should Not BeNullOrEmpty
        (Test-Path -LiteralPath $config.runRootAbs) | Should Be $true
    }
}
