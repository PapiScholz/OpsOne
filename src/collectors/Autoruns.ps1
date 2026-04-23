function Collect-OpsOneAutoruns {
    [CmdletBinding()]
    param()

    $runKeyPaths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run",
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\RunOnce",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\RunOnce"
    )

    $entries = @()
    foreach ($keyPath in $runKeyPaths) {
        try {
            if (-not (Test-Path -LiteralPath $keyPath)) {
                continue
            }

            $item = Get-ItemProperty -LiteralPath $keyPath
            foreach ($property in $item.PSObject.Properties) {
                if ($property.Name -match "^PS") {
                    continue
                }

                $entries += [PSCustomObject]@{
                    RegistryPath = $keyPath
                    Name         = $property.Name
                    Command      = [string]$property.Value
                }
            }
        }
        catch {
            # TODO: Improve structured error reporting for inaccessible registry keys.
            $entries += [PSCustomObject]@{
                RegistryPath = $keyPath
                Name         = "collector-error"
                Command      = $_.Exception.Message
            }
        }
    }

    return [PSCustomObject]@{
        collectedAtUtc = (Get-Date).ToUniversalTime().ToString("o")
        itemCount      = $entries.Count
        entries        = $entries
    }
}

