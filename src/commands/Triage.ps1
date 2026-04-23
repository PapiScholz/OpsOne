function Get-OpsOneTriageHelp {
    [CmdletBinding()]
    param()

    return @"
Usage:
  opsone triage [--quick | --full]

Description:
  Collect local evidence artifacts and generate LLM escalation prompts.

Options:
  --quick    Run baseline collection set (default).
  --full     Run expanded collection set (includes installed software).
  --help     Show this help text.

Examples:
  opsone triage --quick
  opsone triage --full
"@
}

function New-OpsOneIncidentSummary {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]$Session,
        [Parameter(Mandatory = $true)][string]$Mode,
        [int]$ProcessCount,
        [int]$ConnectionCount,
        [int]$ServiceCount,
        [int]$ScheduledTaskCount
    )

    return @"
# OpsOne Incident Summary

- Run ID: $($Session.runId)
- Command: $($Session.command)
- Mode: $Mode
- Started (UTC): $($Session.startedUtc)

## Evidence Snapshot

- Processes collected: $ProcessCount
- Network connections collected: $ConnectionCount
- Services collected: $ServiceCount
- Scheduled tasks collected: $ScheduledTaskCount

## Initial Analyst Notes

- TODO: Add anomaly scoring for high-risk process patterns.
- TODO: Add suspicious network destination tagging.
- TODO: Add service/task persistence heuristics.

## Next Actions

1. Review `defender_status.json` for immediate security posture.
2. Validate suspicious startup entries in `autoruns.json`.
3. Use provider prompts for external LLM-assisted triage.
"@
}

function Invoke-OpsOneTriageCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][hashtable]$Options,
        [Parameter(Mandatory = $true)]$Config
    )

    $isQuick = Get-OpsOneOptionBool -Options $Options -Name "quick"
    $isFull = Get-OpsOneOptionBool -Options $Options -Name "full"

    if ($isQuick -and $isFull) {
        return New-OpsOneResult -Command "triage" -Status "error" -Errors @("Use only one mode: --quick or --full.")
    }

    $mode = if ($isFull) { "full" } else { "quick" }
    $session = Start-OpsOneSession -Command "triage" -Mode $mode -Config $Config
    Initialize-OpsOneLogging -Session $session
    Write-OpsOneLog -Session $session -Level "Info" -Message "Starting triage mode '$mode'."

    try {
        $artifacts = @()

        $processes = @(Collect-OpsOneProcesses)
        $connections = @(Collect-OpsOneNetworkConnections)
        $services = @(Collect-OpsOneServices)
        $scheduledTasks = @(Collect-OpsOneScheduledTasks)
        $autoruns = Collect-OpsOneAutoruns
        $defender = Collect-OpsOneDefenderStatus
        $systemSummary = Collect-OpsOneSystemSummary

        $artifacts += Write-OpsOneCsvArtifact -Session $session -FileName "processes.csv" -Data $processes -Description "Process snapshot."
        $artifacts += Write-OpsOneCsvArtifact -Session $session -FileName "net_connections.csv" -Data $connections -Description "Network connection snapshot."
        $artifacts += Write-OpsOneCsvArtifact -Session $session -FileName "services.csv" -Data $services -Description "Service inventory."
        $artifacts += Write-OpsOneCsvArtifact -Session $session -FileName "scheduled_tasks.csv" -Data $scheduledTasks -Description "Scheduled task inventory."
        $artifacts += Write-OpsOneJsonArtifact -Session $session -FileName "autoruns.json" -Data $autoruns -Description "Run key autoruns and startup entries."
        $artifacts += Write-OpsOneJsonArtifact -Session $session -FileName "defender_status.json" -Data $defender -Description "Microsoft Defender status snapshot."
        $artifacts += Write-OpsOneJsonArtifact -Session $session -FileName "system_summary.json" -Data $systemSummary -Description "Host identity and OS summary."

        if ($mode -eq "full") {
            $installedSoftware = @(Collect-OpsOneInstalledSoftware)
            $artifacts += Write-OpsOneCsvArtifact -Session $session -FileName "installed_software.csv" -Data $installedSoftware -Description "Installed software inventory (full mode)."
        }

        $incidentSummary = New-OpsOneIncidentSummary `
            -Session $session `
            -Mode $mode `
            -ProcessCount $processes.Count `
            -ConnectionCount $connections.Count `
            -ServiceCount $services.Count `
            -ScheduledTaskCount $scheduledTasks.Count
        $artifacts += Write-OpsOneMarkdownArtifact -Session $session -FileName "incident-summary.md" -Content $incidentSummary -Description "Operator-facing run summary."

        $defenderEnabled = "unknown"
        if ($defender.PSObject.Properties.Name -contains "AntivirusEnabled") {
            $defenderEnabled = [string]$defender.AntivirusEnabled
        }

        $context = @{
            RUN_ID            = $session.runId
            RUN_MODE          = $mode
            ARTIFACTS_PATH    = $session.artifactDir
            INCIDENT_SUMMARY  = (Join-Path -Path $session.artifactDir -ChildPath "incident-summary.md")
            SYSTEM_NAME       = [string]$systemSummary.computerName
            DEFENDER_ENABLED  = $defenderEnabled
        }

        foreach ($provider in @("chatgpt", "gemini", "claude")) {
            $artifacts += Write-OpsOneProviderPrompt -Session $session -Provider $provider -Context $context
        }

        $zipFlow = @"
# Final ZIP Bundle Placeholder Flow

- Intended output: `opsone-$($session.runId).zip`
- Candidate inputs:
  - `artifacts/*.csv`
  - `artifacts/*.json`
  - `artifacts/incident-summary.md`
  - `artifacts/llm-prompt-*.md`
- TODO: Implement deterministic zip creation with integrity metadata.
"@
        $artifacts += Write-OpsOneMarkdownArtifact -Session $session -FileName "final-zip-placeholder.md" -Content $zipFlow -Description "Placeholder flow for final incident bundle packaging."

        Write-OpsOneLog -Session $session -Level "Info" -Message "Triage completed successfully."

        $result = New-OpsOneResult `
            -Command "triage" `
            -Status "ok" `
            -RunId $session.runId `
            -Metadata @{
                mode         = $mode
                runRoot      = $session.runRoot
                artifactRoot = $session.artifactDir
            } `
            -Artifacts $artifacts `
            -Messages @("Triage completed. Artifacts are available under the run directory.")

        Write-OpsOneResultFile -Session $session -Result $result | Out-Null
        return $result
    }
    catch {
        Write-OpsOneLog -Session $session -Level "Error" -Message $_.Exception.Message
        $result = New-OpsOneResult `
            -Command "triage" `
            -Status "error" `
            -RunId $session.runId `
            -Metadata @{ mode = $mode; runRoot = $session.runRoot } `
            -Errors @($_.Exception.Message)
        Write-OpsOneResultFile -Session $session -Result $result | Out-Null
        return $result
    }
}
