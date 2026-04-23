function Collect-OpsOneSystemSummary {
    [CmdletBinding()]
    param()

    try {
        $os = Get-CimInstance -ClassName Win32_OperatingSystem -ErrorAction Stop
        $computer = Get-CimInstance -ClassName Win32_ComputerSystem -ErrorAction Stop
        $bios = Get-CimInstance -ClassName Win32_BIOS -ErrorAction SilentlyContinue

        return [PSCustomObject]@{
            collectedAtUtc      = (Get-Date).ToUniversalTime().ToString("o")
            computerName        = $env:COMPUTERNAME
            userName            = $env:USERNAME
            osCaption           = $os.Caption
            osVersion           = $os.Version
            osBuildNumber       = $os.BuildNumber
            lastBootUpTime      = ([DateTime]$os.LastBootUpTime).ToUniversalTime().ToString("o")
            totalPhysicalMemory = [int64]$computer.TotalPhysicalMemory
            manufacturer        = $computer.Manufacturer
            model               = $computer.Model
            biosVersion         = ($bios.SMBIOSBIOSVersion -join ";")
        }
    }
    catch {
        # TODO: Add fallback collection for restricted WMI/CIM environments.
        return [PSCustomObject]@{
            collectedAtUtc = (Get-Date).ToUniversalTime().ToString("o")
            computerName   = $env:COMPUTERNAME
            error          = $_.Exception.Message
        }
    }
}

