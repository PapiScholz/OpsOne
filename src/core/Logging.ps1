function Initialize-OpsOneLogging {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]$Session
    )

    if (-not (Test-Path -LiteralPath $Session.logFile)) {
        New-Item -ItemType File -Path $Session.logFile -Force | Out-Null
    }

    Write-OpsOneLog -Session $Session -Level "Info" -Message "Session initialized."
}

function Write-OpsOneLog {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]$Session,
        [ValidateSet("Debug", "Info", "Warn", "Error")][string]$Level = "Info",
        [Parameter(Mandatory = $true)][string]$Message
    )

    $line = "{0} [{1}] {2}" -f (Get-Date).ToUniversalTime().ToString("o"), $Level.ToUpperInvariant(), $Message
    Add-Content -LiteralPath $Session.logFile -Value $line
}

