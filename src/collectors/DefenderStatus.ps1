function Collect-OpsOneDefenderStatus {
    [CmdletBinding()]
    param()

    try {
        $status = Get-MpComputerStatus -ErrorAction Stop
        return [PSCustomObject]@{
            collectedAtUtc              = (Get-Date).ToUniversalTime().ToString("o")
            AMServiceEnabled            = $status.AMServiceEnabled
            AntivirusEnabled            = $status.AntivirusEnabled
            AntispywareEnabled          = $status.AntispywareEnabled
            RealTimeProtectionEnabled   = $status.RealTimeProtectionEnabled
            NISEnabled                  = $status.NISEnabled
            QuickScanAge                = $status.QuickScanAge
            FullScanAge                 = $status.FullScanAge
            AntivirusSignatureVersion   = $status.AntivirusSignatureVersion
            DefenderSignaturesOutOfDate = $status.DefenderSignaturesOutOfDate
        }
    }
    catch {
        # TODO: Add Windows Security Center API fallback where Defender cmdlets are unavailable.
        return [PSCustomObject]@{
            collectedAtUtc = (Get-Date).ToUniversalTime().ToString("o")
            error          = $_.Exception.Message
        }
    }
}

