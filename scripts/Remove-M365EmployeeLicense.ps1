[CmdletBinding(SupportsShouldProcess=$true, ConfirmImpact="High")]
param(
    [Parameter(Mandatory)][string]$UserPrincipalName,
    [Parameter(Mandatory)][string]$AllowedDomain,
    [Parameter(Mandatory)][string]$SkuId,
    [switch]$PreservationReviewed,
    [switch]$ConfirmLicenseRemoval
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "Common/Lifecycle.Common.ps1")
Assert-LifecycleConnection | Out-Null
Assert-ApprovedTestDomain -UserPrincipalName $UserPrincipalName -AllowedDomain $AllowedDomain

if (-not $PreservationReviewed) {
    Write-LifecycleAudit -Action "RemoveLicense" -TargetUser $UserPrincipalName -Status "Blocked" -Details "Preservation review not confirmed."
    throw "Blocked: complete and document mailbox, OneDrive, retention, and legal-hold review first."
}
if (-not $ConfirmLicenseRemoval) {
    Write-LifecycleAudit -Action "RemoveLicense" -TargetUser $UserPrincipalName -Status "Blocked" -Details "Missing -ConfirmLicenseRemoval."
    throw "Blocked: re-run with -ConfirmLicenseRemoval after reviewing the target and SKU."
}

$skuGuid = [guid]::Empty
if (-not [guid]::TryParse($SkuId, [ref]$skuGuid)) { throw "SkuId must be a real GUID." }

$user = Get-MgUser -UserId $UserPrincipalName -Property Id,UserPrincipalName,AccountEnabled,AssignedLicenses
if (-not $user) { throw "User not found." }
if ($user.AccountEnabled) { throw "Target account is still enabled; disable and verify it first." }

$assignedSkuIds = @($user.AssignedLicenses | ForEach-Object { [guid]$_.SkuId })
if ($assignedSkuIds -notcontains $skuGuid) { throw "The specified SKU is not directly assigned to this user, or cannot be found in the current user license list." }

if ($PSCmdlet.ShouldProcess("$UserPrincipalName / $skuGuid", "Remove Microsoft 365 license")) {
    try {
        Set-MgUserLicense -UserId $user.Id -AddLicenses @() -RemoveLicenses @($skuGuid) | Out-Null
        Write-LifecycleAudit -Action "RemoveLicense" -TargetUser $UserPrincipalName -Status "Success" -Details "License removal requested after preservation review. Verify final state."
        Get-MgUserLicenseDetail -UserId $user.Id |
            Select-Object SkuPartNumber,SkuId
    }
    catch {
        Write-LifecycleAudit -Action "RemoveLicense" -TargetUser $UserPrincipalName -Status "Failed" -Details $_.Exception.Message
        throw
    }
}
