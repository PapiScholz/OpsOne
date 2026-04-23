function Get-OpsOneRepoRoot {
    [CmdletBinding()]
    param()

    # This file lives under src/core, so two parent traversals resolve repo root.
    return (Split-Path -Path (Split-Path -Path $PSScriptRoot -Parent) -Parent)
}

function ConvertFrom-OpsOneArgs {
    [CmdletBinding()]
    param(
        [string[]]$Arguments
    )

    $options = @{
        _positionals = @()
    }

    if (-not $Arguments) {
        return $options
    }

    for ($index = 0; $index -lt $Arguments.Count; $index++) {
        $token = $Arguments[$index]

        if ($token.StartsWith("--")) {
            $name = $token.Substring(2)
            if ([string]::IsNullOrWhiteSpace($name)) {
                continue
            }

            $hasValue = ($index + 1) -lt $Arguments.Count -and -not $Arguments[$index + 1].StartsWith("-")
            if ($hasValue) {
                $options[$name] = $Arguments[$index + 1]
                $index++
            }
            else {
                $options[$name] = $true
            }
            continue
        }

        if ($token -eq "-h" -or $token -eq "/?" -or $token -eq "--help") {
            $options["help"] = $true
            continue
        }

        $options._positionals += $token
    }

    return $options
}

function Get-OpsOneOptionBool {
    [CmdletBinding()]
    param(
        [hashtable]$Options,
        [Parameter(Mandatory = $true)][string]$Name,
        [bool]$Default = $false
    )

    if (-not $Options.ContainsKey($Name)) {
        return $Default
    }

    $value = $Options[$Name]
    if ($value -is [bool]) {
        return $value
    }

    if ($value -is [string]) {
        switch -Regex ($value.ToLowerInvariant()) {
            "^(1|true|yes|y|on)$" { return $true }
            "^(0|false|no|n|off)$" { return $false }
            default { return $true }
        }
    }

    return [bool]$value
}

function Get-OpsOneOptionString {
    [CmdletBinding()]
    param(
        [hashtable]$Options,
        [Parameter(Mandatory = $true)][string]$Name,
        [string]$Default = ""
    )

    if (-not $Options.ContainsKey($Name)) {
        return $Default
    }

    return [string]$Options[$Name]
}

function Confirm-OpsOneAction {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string]$Message,
        [switch]$Force
    )

    if ($Force) {
        return $true
    }

    $response = Read-Host "$Message Type YES to continue"
    return $response -eq "YES"
}

