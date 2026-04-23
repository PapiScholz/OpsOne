function Collect-OpsOneServices {
    [CmdletBinding()]
    param()

    try {
        return Get-Service |
            Select-Object `
                Name,
                DisplayName,
                Status,
                StartType
    }
    catch {
        # TODO: Add WMI fallback for service collection.
        return @(
            [PSCustomObject]@{
                Name        = "collector-error"
                DisplayName = "collector-error"
                Status      = "Unknown"
                StartType   = "Unknown"
            }
        )
    }
}

