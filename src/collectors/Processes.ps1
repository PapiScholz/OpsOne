function Collect-OpsOneProcesses {
    [CmdletBinding()]
    param()

    try {
        return Get-Process |
            Sort-Object -Property CPU -Descending |
            Select-Object -First 250 `
                @{ Name = "Name"; Expression = { $_.ProcessName } },
                @{ Name = "Id"; Expression = { $_.Id } },
                @{ Name = "CpuSeconds"; Expression = { [Math]::Round(($_.CPU | ForEach-Object { $_ }), 2) } },
                @{ Name = "WorkingSetMB"; Expression = { [Math]::Round($_.WorkingSet64 / 1MB, 2) } },
                @{ Name = "StartTimeUtc"; Expression = {
                    try { $_.StartTime.ToUniversalTime().ToString("o") } catch { $null }
                } }
    }
    catch {
        # TODO: Add alternate collector strategy if Get-Process fails on constrained hosts.
        return @(
            [PSCustomObject]@{
                Name         = "collector-error"
                Id           = -1
                CpuSeconds   = 0
                WorkingSetMB = 0
                StartTimeUtc = $null
            }
        )
    }
}

