function Get-OpsOneEscalateHelp {
    [CmdletBinding()]
    param()

    return @"
Usage:
  opsone escalate --provider <chatgpt|gemini|claude> [--run-id <id>]

Description:
  Generate provider-specific escalation prompt content for external LLM use.

Options:
  --provider <name>   Escalation provider (chatgpt, gemini, claude).
  --run-id <id>       Optional reference triage run id.
  --help              Show this help text.

Examples:
  opsone escalate --provider chatgpt
  opsone escalate --provider claude --run-id 20260422-230001-abcd1234
"@
}

function Invoke-OpsOneEscalateCommand {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][hashtable]$Options,
        [Parameter(Mandatory = $true)]$Config
    )

    $provider = Get-OpsOneOptionString -Options $Options -Name "provider" -Default $Config.escalation.defaultProvider
    $provider = $provider.ToLowerInvariant()
    $runIdReference = Get-OpsOneOptionString -Options $Options -Name "run-id"

    if ($Config.escalation.allowedProviders -notcontains $provider) {
        return New-OpsOneResult -Command "escalate" -Status "error" -Errors @("Provider '$provider' is not allowed.")
    }

    $session = Start-OpsOneSession -Command "escalate" -Mode $provider -Config $Config
    Initialize-OpsOneLogging -Session $session

    $contextDoc = @"
# Escalation Context

- Session run ID: $($session.runId)
- Provider: $provider
- Referenced triage run ID: $runIdReference

## Analyst Notes

- TODO: Allow loading key artifacts from referenced run.
- TODO: Add redaction workflow before external sharing.
- TODO: Add provider-specific token budgeting guidance.
"@

    $contextArtifact = Write-OpsOneMarkdownArtifact -Session $session -FileName "escalation-context.md" -Content $contextDoc -Description "Escalation context memo."

    $promptContext = @{
        RUN_ID           = $session.runId
        RUN_MODE         = "escalation-only"
        ARTIFACTS_PATH   = $session.artifactDir
        INCIDENT_SUMMARY = (Join-Path -Path $session.artifactDir -ChildPath "escalation-context.md")
        SYSTEM_NAME      = $env:COMPUTERNAME
        DEFENDER_ENABLED = "unknown"
    }
    $promptArtifact = Write-OpsOneProviderPrompt -Session $session -Provider $provider -Context $promptContext

    $result = New-OpsOneResult `
        -Command "escalate" `
        -Status "ok" `
        -RunId $session.runId `
        -Metadata @{ provider = $provider; referenceRunId = $runIdReference; runRoot = $session.runRoot } `
        -Artifacts @($contextArtifact, $promptArtifact) `
        -Messages @("Escalation prompt generated for provider '$provider'.")

    Write-OpsOneResultFile -Session $session -Result $result | Out-Null
    return $result
}

