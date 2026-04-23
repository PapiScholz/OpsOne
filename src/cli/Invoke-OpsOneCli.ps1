function Get-OpsOneModulePaths {
    [CmdletBinding()]
    param()

    $repoRoot = Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent

    $files = @(
        "src/core/Utils.ps1",
        "src/core/Configuration.ps1",
        "src/core/Session.ps1",
        "src/core/Logging.ps1",
        "src/core/Artifacts.ps1",
        "src/core/Output.ps1",
        "src/core/Prompts.ps1",
        "src/collectors/Processes.ps1",
        "src/collectors/NetworkConnections.ps1",
        "src/collectors/Services.ps1",
        "src/collectors/ScheduledTasks.ps1",
        "src/collectors/Autoruns.ps1",
        "src/collectors/InstalledSoftware.ps1",
        "src/collectors/DefenderStatus.ps1",
        "src/collectors/SystemSummary.ps1",
        "src/commands/Triage.ps1",
        "src/commands/Tune.ps1",
        "src/commands/Repair.ps1",
        "src/commands/Security.ps1",
        "src/commands/Escalate.ps1"
    )

    return $files | ForEach-Object {
        $path = Join-Path -Path $repoRoot -ChildPath $_
        if (-not (Test-Path -LiteralPath $path)) {
            throw "Required module file missing: $_"
        }
        $path
    }
}

function Get-OpsOneGlobalHelp {
    [CmdletBinding()]
    param()

    return @"
OpsOne - local-first Windows triage and operations toolkit

Usage:
  opsone <command> [options]

Commands:
  triage    Collect evidence artifacts and LLM escalation prompts.
  tune      Plan or apply safe tuning actions.
  repair    Run common repair routines (basic profile scaffold).
  security  Run security bridge checks (Defender + baseline posture).
  escalate  Generate provider-specific escalation prompts.
  help      Show this help text.

Examples:
  opsone triage --quick
  opsone triage --full
  opsone tune --dry-run
  opsone repair --basic
  opsone security --quick
  opsone escalate --provider chatgpt
"@
}

function Invoke-OpsOneCli {
    [CmdletBinding()]
    param(
        [string[]]$Arguments
    )

    foreach ($modulePath in (Get-OpsOneModulePaths)) {
        . $modulePath
    }
    $config = Get-OpsOneConfig

    if (-not $Arguments -or $Arguments.Count -eq 0) {
        return New-OpsOneResult -Command "help" -Status "ok" -Messages @(Get-OpsOneGlobalHelp)
    }

    $command = $Arguments[0].ToLowerInvariant()
    $remaining = @()
    if ($Arguments.Count -gt 1) {
        $remaining = $Arguments[1..($Arguments.Count - 1)]
    }
    $options = ConvertFrom-OpsOneArgs -Arguments $remaining

    switch ($command) {
        "help" {
            return New-OpsOneResult -Command "help" -Status "ok" -Messages @(Get-OpsOneGlobalHelp)
        }
        "triage" {
            if (Get-OpsOneOptionBool -Options $options -Name "help") {
                return New-OpsOneResult -Command "triage" -Status "ok" -Messages @(Get-OpsOneTriageHelp)
            }
            return Invoke-OpsOneTriageCommand -Options $options -Config $config
        }
        "tune" {
            if (Get-OpsOneOptionBool -Options $options -Name "help") {
                return New-OpsOneResult -Command "tune" -Status "ok" -Messages @(Get-OpsOneTuneHelp)
            }
            return Invoke-OpsOneTuneCommand -Options $options -Config $config
        }
        "repair" {
            if (Get-OpsOneOptionBool -Options $options -Name "help") {
                return New-OpsOneResult -Command "repair" -Status "ok" -Messages @(Get-OpsOneRepairHelp)
            }
            return Invoke-OpsOneRepairCommand -Options $options -Config $config
        }
        "security" {
            if (Get-OpsOneOptionBool -Options $options -Name "help") {
                return New-OpsOneResult -Command "security" -Status "ok" -Messages @(Get-OpsOneSecurityHelp)
            }
            return Invoke-OpsOneSecurityCommand -Options $options -Config $config
        }
        "escalate" {
            if (Get-OpsOneOptionBool -Options $options -Name "help") {
                return New-OpsOneResult -Command "escalate" -Status "ok" -Messages @(Get-OpsOneEscalateHelp)
            }
            return Invoke-OpsOneEscalateCommand -Options $options -Config $config
        }
        default {
            return New-OpsOneResult -Command $command -Status "error" -Messages @(Get-OpsOneGlobalHelp) -Errors @("Unknown command '$command'.")
        }
    }
}
