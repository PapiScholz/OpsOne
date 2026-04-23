function Get-OpsOneRepairHelp {
    [CmdletBinding()]
    param()

    return @"
Usage:
  opsone repair --basic [--dry-run] [--yes]

Description:
  Run common Windows repair routines through explicit, safe orchestration.

Options:
  --basic     Run basic repair profile (currently the only scaffold profile).
  --dry-run   Preview intended repair actions without applying changes.
  --yes       Skip interactive confirmation.
  --help      Show this help text.

Examples:
  opsone repair --basic
  opsone repair --basic --dry-run
"@
}

function Invoke-OpsOneRepairCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][hashtable]$Options,
        [Parameter(Mandatory = $true)]$Config
    )

    $basic = Get-OpsOneOptionBool -Options $Options -Name "basic"
    if (-not $basic) {
        return New-OpsOneResult -Command "repair" -Status "error" -Errors @("Only --basic is currently supported in this scaffold.")
    }

    $dryRun = Get-OpsOneOptionBool -Options $Options -Name "dry-run" -Default $Config.safety.defaultDryRun
    $force = Get-OpsOneOptionBool -Options $Options -Name "yes" -Default $false

    $session = Start-OpsOneSession -Command "repair" -Mode "basic" -Config $Config
    Initialize-OpsOneLogging -Session $session

    $routines = @(
        [PSCustomObject]@{ id = "sfc-scan"; description = "Run System File Checker scan and capture output."; risk = "medium" },
        [PSCustomObject]@{ id = "dism-health-check"; description = "Run DISM health check for component store."; risk = "medium" },
        [PSCustomObject]@{ id = "network-stack-baseline"; description = "Validate network stack state before optional reset."; risk = "high" }
    )

    $applied = $false
    if (-not $dryRun) {
        $approved = Confirm-OpsOneAction -Message "Repair can modify local system state." -Force:$force
        if (-not $approved) {
            return New-OpsOneResult -Command "repair" -Status "error" -RunId $session.runId -Metadata @{ profile = "basic"; dryRun = $false } -Errors @("Repair aborted by operator confirmation gate.")
        }

        # TODO: Implement staged repair execution with pre/post snapshots.
        $applied = $true
    }

    $report = @"
# Repair Run (Basic Profile)

- Run ID: $($session.runId)
- Dry-run: $dryRun
- Applied: $applied

## Planned Routines

1. SFC scan
2. DISM health check
3. Network stack baseline

## TODO

- Add command output capture and parser.
- Add rollback and escalation hints per routine.
"@

    $artifacts = @()
    $artifacts += Write-OpsOneMarkdownArtifact -Session $session -FileName "repair-report.md" -Content $report -Description "Repair summary report."
    $artifacts += Write-OpsOneJsonArtifact -Session $session -FileName "repair-routines.json" -Data $routines -Description "Repair routine inventory."

    $result = New-OpsOneResult `
        -Command "repair" `
        -Status "ok" `
        -RunId $session.runId `
        -Metadata @{ profile = "basic"; dryRun = $dryRun; applied = $applied; runRoot = $session.runRoot } `
        -Artifacts $artifacts `
        -Messages @("Repair command completed in scaffold mode.")

    Write-OpsOneResultFile -Session $session -Result $result | Out-Null
    return $result
}

