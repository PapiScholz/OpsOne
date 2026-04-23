Describe "Collect-OpsOneProcesses" {
    BeforeAll {
        $repoRoot = Split-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent) -Parent
        . (Join-Path -Path $repoRoot -ChildPath "src/collectors/Processes.ps1")
    }

    It "returns at least one row" {
        $rows = @(Collect-OpsOneProcesses)
        $rows.Count | Should BeGreaterThan 0
    }
}
