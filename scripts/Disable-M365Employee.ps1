[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$UserPrincipalName,
    [Parameter(Mandatory)][string]$AllowedDomain,
    [switch]$ConfirmOffboarding
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "Common/Lifecycle.Common.ps1")
Assert-LifecycleConnection | Out-Null
Assert-ApprovedTestDomain -UserPrincipalName $UserPrincipalName -AllowedDomain $AllowedDomain

if (-not $ConfirmOffboarding) {
    Write-LifecycleAudit -Action "DisableAndRevokeSessions" -TargetUser $UserPrincipalName -Status "Blocked" -Details "Missing -ConfirmOffboarding."
    throw "No changes made. Re-run with -ConfirmOffboarding after verifying the approved request."
}

$user = Get-MgUser -UserId $UserPrincipalName -Property Id,DisplayName,UserPrincipalName,AccountEnabled
if (-not $user) { throw "User not found: $UserPrincipalName" }

try {
    Write-LifecycleAudit -Action "DisableAccount" -TargetUser $UserPrincipalName -Status "Started" -Details "Approved offboarding."
    Update-MgUser -UserId $user.Id -AccountEnabled:$false
    Write-LifecycleAudit -Action "DisableAccount" -TargetUser $UserPrincipalName -Status "Success" -Details "AccountEnabled set to false."

    try {
        Revoke-MgUserSignInSession -UserId $user.Id | Out-Null
        Write-LifecycleAudit -Action "RevokeSessions" -TargetUser $UserPrincipalName -Status "Success" -Details "Graph session-revocation request completed; propagation may take time."
    }
    catch {
        Write-LifecycleAudit -Action "RevokeSessions" -TargetUser $UserPrincipalName -Status "Failed" -Details $_.Exception.Message
        throw "Account was disabled, but session revocation failed. Investigate and retry revocation. $($_.Exception.Message)"
    }

    Get-MgUser -UserId $user.Id -Property DisplayName,UserPrincipalName,AccountEnabled |
        Select-Object DisplayName,UserPrincipalName,AccountEnabled
}
catch {
    Write-LifecycleAudit -Action "DisableAndRevokeSessions" -TargetUser $UserPrincipalName -Status "Failed" -Details $_.Exception.Message
    throw
}
