function Collect-OpsOneNetworkConnections {
    [CmdletBinding()]
    param()

    try {
        return Get-NetTCPConnection -ErrorAction Stop |
            Select-Object `
                LocalAddress,
                LocalPort,
                RemoteAddress,
                RemotePort,
                State,
                OwningProcess
    }
    catch {
        # TODO: Implement fallback parser for netstat output when Get-NetTCPConnection is unavailable.
        return @(
            [PSCustomObject]@{
                LocalAddress  = "collector-error"
                LocalPort     = 0
                RemoteAddress = "collector-error"
                RemotePort    = 0
                State         = "Unknown"
                OwningProcess = -1
            }
        )
    }
}

