function Get-OpsOnePromptTemplatePath {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][ValidateSet("chatgpt", "gemini", "claude")]$Provider
    )

    $repoRoot = Get-OpsOneRepoRoot
    return Join-Path -Path $repoRoot -ChildPath "prompts/$Provider-triage.md"
}

function Build-OpsOnePromptContent {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)][string]$TemplatePath,
        [hashtable]$Context = @{}
    )

    if (-not (Test-Path -LiteralPath $TemplatePath)) {
        throw "Prompt template not found: $TemplatePath"
    }

    $content = Get-Content -LiteralPath $TemplatePath -Raw
    foreach ($key in $Context.Keys) {
        $token = "{{{0}}}" -f $key
        $content = $content.Replace($token, [string]$Context[$key])
    }

    return $content
}

function Write-OpsOneProviderPrompt {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]$Session,
        [Parameter(Mandatory = $true)][ValidateSet("chatgpt", "gemini", "claude")]$Provider,
        [hashtable]$Context = @{}
    )

    $templatePath = Get-OpsOnePromptTemplatePath -Provider $Provider
    $content = Build-OpsOnePromptContent -TemplatePath $templatePath -Context $Context

    $fileName = "llm-prompt-$Provider.md"
    $target = Join-Path -Path $Session.artifactDir -ChildPath $fileName
    Set-Content -LiteralPath $target -Value $content -Encoding UTF8

    return New-OpsOneArtifactRecord -Name $fileName -Path $target -Type "markdown" -Description "Provider escalation prompt."
}

