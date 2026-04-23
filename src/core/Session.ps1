function Start-OpsOneSession {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string]$Command,
        [Parameter(Mandatory = $true)][string]$Mode,
        [Parameter(Mandatory = $true)]$Config
    )

    $timestamp = Get-Date -Format "yyyyMMdd-HHmmss"
    $suffix = [Guid]::NewGuid().ToString("N").Substring(0, 8)
    $runId = "$timestamp-$suffix"

    $runRoot = Join-Path -Path $Config.runRootAbs -ChildPath $runId
    $artifactDir = Join-Path -Path $runRoot -ChildPath "artifacts"
    $promptDir = Join-Path -Path $runRoot -ChildPath "prompts"
    $logDir = Join-Path -Path $runRoot -ChildPath "logs"

    foreach ($path in @($runRoot, $artifactDir, $promptDir, $logDir)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }

    return [PSCustomObject]@{
        runId       = $runId
        command     = $Command
        mode        = $Mode
        startedUtc  = (Get-Date).ToUniversalTime().ToString("o")
        runRoot     = $runRoot
        artifactDir = $artifactDir
        promptDir   = $promptDir
        logDir      = $logDir
        logFile     = Join-Path -Path $logDir -ChildPath "opsone.log"
    }
}

