function Get-OpsOneSecurityHelp {
    [CmdletBinding()]
    param()

    return @"
Usage:
  opsone security [--quick | --full]

Description:
  Run security bridge checks and produce structured security artifacts.

Options:
  --quick    Run baseline security checks (default).
  --full     Run expanded checks (placeholder for future controls).
  --help     Show this help text.

Examples:
  opsone security --quick
  opsone security --full
"@
}

function Invoke-OpsOneSecurityCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][hashtable]$Options,
        [Parameter(Mandatory = $true)]$Config
    )

    $isQuick = Get-OpsOneOptionBool -Options $Options -Name "quick"
    $isFull = Get-OpsOneOptionBool -Options $Options -Name "full"
    if ($isQuick -and $isFull) {
        return New-OpsOneResult -Command "security" -Status "error" -Errors @("Use only one mode: --quick or --full.")
    }

    $mode = if ($isFull) { "full" } else { "quick" }
    $session = Start-OpsOneSession -Command "security" -Mode $mode -Config $Config
    Initialize-OpsOneLogging -Session $session

    $defender = Collect-OpsOneDefenderStatus
    $firewallProfiles = @()
    try {
        $firewallProfiles = Get-NetFirewallProfile -ErrorAction Stop | Select-Object Name, Enabled, DefaultInboundAction, DefaultOutboundAction
    }
    catch {
        $firewallProfiles = @(
            [PSCustomObject]@{
                Name                  = "collector-error"
                Enabled               = $false
                DefaultInboundAction  = "Unknown"
                DefaultOutboundAction = "Unknown"
            }
        )
    }

    $snapshot = [PSCustomObject]@{
        runId            = $session.runId
        mode             = $mode
        collectedAtUtc   = (Get-Date).ToUniversalTime().ToString("o")
        defenderStatus   = $defender
        firewallProfiles = $firewallProfiles
        todo             = @(
            "TODO: Add SmartScreen, BitLocker, and ASR checks.",
            "TODO: Add optional hardening recommendation engine."
        )
    }

    $summary = @"
# Security Bridge Summary

- Run ID: $($session.runId)
- Mode: $mode

## Highlights

- Defender status captured.
- Firewall profile snapshot captured.

## TODO

- Expand security bridge checks beyond Defender + firewall.
"@

    $artifacts = @()
    $artifacts += Write-OpsOneJsonArtifact -Session $session -FileName "security-snapshot.json" -Data $snapshot -Description "Security command output."
    $artifacts += Write-OpsOneMarkdownArtifact -Session $session -FileName "security-summary.md" -Content $summary -Description "Operator-readable security summary."

    $result = New-OpsOneResult `
        -Command "security" `
        -Status "ok" `
        -RunId $session.runId `
        -Metadata @{ mode = $mode; runRoot = $session.runRoot } `
        -Artifacts $artifacts `
        -Messages @("Security checks completed in scaffold mode.")

    Write-OpsOneResultFile -Session $session -Result $result | Out-Null
    return $result
}
