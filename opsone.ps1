[CmdletBinding()]
param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$Arguments
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$cliPath = Join-Path -Path $PSScriptRoot -ChildPath "src/cli/Invoke-OpsOneCli.ps1"
. $cliPath

try {
    $result = Invoke-OpsOneCli -Arguments $Arguments
    if ($null -ne $result) {
        $result | ConvertTo-Json -Depth 8
        if ($result.status -eq "error") {
            exit 1
        }
    }
    exit 0
}
catch {
    $errorResult = [PSCustomObject]@{
        command      = "opsone"
        status       = "error"
        timestampUtc = (Get-Date).ToUniversalTime().ToString("o")
        runId        = $null
        metadata     = @{}
        artifacts    = @()
        messages     = @("Unhandled CLI failure.")
        errors       = @($_.Exception.Message)
    }
    $errorResult | ConvertTo-Json -Depth 8
    exit 1
}

