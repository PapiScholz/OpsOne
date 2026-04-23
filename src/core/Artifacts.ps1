function New-OpsOneArtifactRecord {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string]$Name,
        [Parameter(Mandatory = $true)][string]$Path,
        [Parameter(Mandatory = $true)][string]$Type,
        [string]$Description = ""
    )

    return [PSCustomObject]@{
        name        = $Name
        path        = $Path
        type        = $Type
        description = $Description
    }
}

function Write-OpsOneCsvArtifact {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]$Session,
        [Parameter(Mandatory = $true)][string]$FileName,
        [Parameter(Mandatory = $true)]$Data,
        [string]$Description = ""
    )

    $target = Join-Path -Path $Session.artifactDir -ChildPath $FileName
    $Data | Export-Csv -LiteralPath $target -NoTypeInformation -Encoding UTF8
    return New-OpsOneArtifactRecord -Name $FileName -Path $target -Type "csv" -Description $Description
}

function Write-OpsOneJsonArtifact {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]$Session,
        [Parameter(Mandatory = $true)][string]$FileName,
        [Parameter(Mandatory = $true)]$Data,
        [string]$Description = ""
    )

    $target = Join-Path -Path $Session.artifactDir -ChildPath $FileName
    $Data | ConvertTo-Json -Depth 16 | Set-Content -LiteralPath $target -Encoding UTF8
    return New-OpsOneArtifactRecord -Name $FileName -Path $target -Type "json" -Description $Description
}

function Write-OpsOneMarkdownArtifact {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]$Session,
        [Parameter(Mandatory = $true)][string]$FileName,
        [Parameter(Mandatory = $true)][string]$Content,
        [string]$Description = ""
    )

    $target = Join-Path -Path $Session.artifactDir -ChildPath $FileName
    Set-Content -LiteralPath $target -Value $Content -Encoding UTF8
    return New-OpsOneArtifactRecord -Name $FileName -Path $target -Type "markdown" -Description $Description
}

