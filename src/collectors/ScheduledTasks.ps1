function Collect-OpsOneScheduledTasks {
    [CmdletBinding()]
    param()

    try {
        return Get-ScheduledTask -ErrorAction Stop |
            Select-Object `
                TaskName,
                TaskPath,
                State,
                Author,
                Description
    }
    catch {
        # TODO: Add schtasks.exe fallback parsing for legacy systems.
        return @(
            [PSCustomObject]@{
                TaskName    = "collector-error"
                TaskPath    = "\"
                State       = "Unknown"
                Author      = "Unknown"
                Description = "TODO: Collector fallback not implemented."
            }
        )
    }
}

