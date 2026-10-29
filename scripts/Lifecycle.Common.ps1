# Shared helpers for M365 User Lifecycle Automation.
# Do not log credentials, access tokens, or secrets.

$script:LifecycleRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$script:LifecycleLogPath = Join-Path $script:LifecycleRoot "logs/lifecycle-audit.csv"

function Write-LifecycleAudit {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$Action,
        [Parameter(Mandatory)][string]$TargetUser,
        [Parameter(Mandatory)][ValidateSet("Started","Success","Blocked","Failed","ReviewRequired")][string]$Status,
        [string]$Details = ""
    )

    $logDirectory = Split-Path -Parent $script:LifecycleLogPath
    if (-not (Test-Path $logDirectory)) {
        New-Item -ItemType Directory -Path $logDirectory -Force | Out-Null
    }

    $record = [pscustomobject]@{
        TimestampUtc = (Get-Date).ToUniversalTime().ToString("o")
        Action       = $Action
        TargetUser   = $TargetUser
        Status       = $Status
        Details      = ($Details -replace "[\r\n]+", " ").Trim()
    }

    if (Test-Path $script:LifecycleLogPath) {
        $record | Export-Csv -Path $script:LifecycleLogPath -NoTypeInformation -Append
    } else {
        $record | Export-Csv -Path $script:LifecycleLogPath -NoTypeInformation
    }
}

function Assert-LifecycleConnection {
    $context = Get-MgContext
    if (-not $context -or -not $context.TenantId) {
        throw "No Microsoft Graph context. Run scripts/Connect-MgGraph.ps1 first."
    }
    return $context
}

function Assert-ApprovedTestDomain {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)][string]$UserPrincipalName,
        [Parameter(Mandatory)][string]$AllowedDomain
    )

    if ($AllowedDomain -match "YOUR-VERIFIED-TEST-DOMAIN|example\.com|example\.org" -or
        $AllowedDomain -notmatch "^[A-Za-z0-9.-]+\.[A-Za-z]{2,}$") {
        throw "Set -AllowedDomain to your actual verified lab domain before running."
    }

    $domain = ($UserPrincipalName -split "@")[-1]
    if ($domain -ine $AllowedDomain) {
        throw "Target UPN is outside the approved lab domain '$AllowedDomain'."
    }
}
