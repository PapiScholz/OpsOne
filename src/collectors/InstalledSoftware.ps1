function Collect-OpsOneInstalledSoftware {
    [CmdletBinding()]
    param()

    $paths = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
    )

    $results = @()
    foreach ($path in $paths) {
        try {
            $items = Get-ItemProperty -Path $path -ErrorAction SilentlyContinue
            foreach ($item in $items) {
                if ([string]::IsNullOrWhiteSpace($item.DisplayName)) {
                    continue
                }

                $results += [PSCustomObject]@{
                    DisplayName    = $item.DisplayName
                    DisplayVersion = $item.DisplayVersion
                    Publisher      = $item.Publisher
                    InstallDate    = $item.InstallDate
                    UninstallString = $item.UninstallString
                }
            }
        }
        catch {
            # TODO: Capture collector errors in a dedicated diagnostics channel.
        }
    }

    return $results | Sort-Object -Property DisplayName -Unique
}

