function New-OpsOneResult {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string]$Command,
        [ValidateSet("ok", "error")][string]$Status = "ok",
        [string]$RunId = "",
        [hashtable]$Metadata = @{},
        [array]$Artifacts = @(),
        [string[]]$Messages = @(),
        [string[]]$Errors = @()
    )

    return [PSCustomObject]@{
        command      = $Command
        status       = $Status
        timestampUtc = (Get-Date).ToUniversalTime().ToString("o")
        runId        = $RunId
        metadata     = $Metadata
        artifacts    = $Artifacts
        messages     = $Messages
        errors       = $Errors
    }
}

function Write-OpsOneResultFile {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]$Session,
        [Parameter(Mandatory = $true)]$Result
    )

    $target = Join-Path -Path $Session.runRoot -ChildPath "result.json"
    $Result | ConvertTo-Json -Depth 16 | Set-Content -LiteralPath $target -Encoding UTF8
    return $target
}

