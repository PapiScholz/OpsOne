Describe "Invoke-OpsOneTriageCommand" {
    BeforeAll {
        $repoRoot = Split-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -Parent
        . (Join-Path -Path $repoRoot -ChildPath "src/cli/Invoke-OpsOneCli.ps1")
        foreach ($modulePath in (Get-OpsOneModulePaths)) {
            . $modulePath
        }
        $script:config = Get-OpsOneConfig
    }

    It "returns ok status in quick mode" {
        $result = Invoke-OpsOneTriageCommand -Options @{ quick = $true; _positionals = @() } -Config $script:config
        $result.status | Should Be "ok"
        $result.runId | Should Not BeNullOrEmpty
    }
}
