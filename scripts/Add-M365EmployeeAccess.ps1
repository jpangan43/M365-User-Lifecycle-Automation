[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$UserPrincipalName,
    [Parameter(Mandatory)][string]$Department,
    [Parameter(Mandatory)][string]$AllowedDomain,
    [string]$DepartmentConfigPath = (Join-Path $PSScriptRoot "../config/department-groups.example.json"),
    [string]$LicenseConfigPath = (Join-Path $PSScriptRoot "../config/license-mapping.example.json"),
    [switch]$AssignLicense,
    [switch]$ConfirmChanges
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "Common/Lifecycle.Common.ps1")
Assert-LifecycleConnection | Out-Null
Assert-ApprovedTestDomain -UserPrincipalName $UserPrincipalName -AllowedDomain $AllowedDomain

if (-not $ConfirmChanges) {
    Write-LifecycleAudit -Action "AssignAccess" -TargetUser $UserPrincipalName -Status "Blocked" -Details "Missing -ConfirmChanges."
    throw "No changes made. Re-run with -ConfirmChanges after reviewing mappings."
}

if (-not (Test-Path $DepartmentConfigPath)) { throw "Department config not found: $DepartmentConfigPath" }
$groups = Get-Content $DepartmentConfigPath -Raw | ConvertFrom-Json -AsHashtable
if (-not $groups.ContainsKey($Department)) { throw "Department '$Department' has no approved group mapping." }

$user = Get-MgUser -UserId $UserPrincipalName -Property Id,UserPrincipalName,AccountEnabled
if (-not $user) { throw "User not found." }
if (-not $user.AccountEnabled) { throw "Target account is disabled; refusing to assign access." }

$groupEntry = $groups[$Department]
$groupId = [string]$groupEntry.groupObjectId
if ($groupId -notmatch '^[0-9a-fA-F-]{36}$') { throw "Replace the placeholder groupObjectId for '$Department' with a real GUID." }

try {
    $members = Get-MgGroupMember -GroupId $groupId -All
    if ($members.Id -notcontains $user.Id) {
        New-MgGroupMemberByRef -GroupId $groupId -BodyParameter @{
            "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$($user.Id)"
        }
    }
    Write-LifecycleAudit -Action "AddGroupMember" -TargetUser $UserPrincipalName -Status "Success" -Details "Approved department group: $Department"

    if ($AssignLicense) {
        if (-not (Test-Path $LicenseConfigPath)) { throw "License config not found: $LicenseConfigPath" }
        $licenseMap = Get-Content $LicenseConfigPath -Raw | ConvertFrom-Json -AsHashtable
        if (-not $licenseMap.ContainsKey($Department)) { throw "Department '$Department' has no license mapping." }
        $skuText = [string]$licenseMap[$Department].skuId
        $skuGuid = [guid]::Empty
        if (-not [guid]::TryParse($skuText, [ref]$skuGuid)) { throw "Replace the placeholder skuId for '$Department' with a real SKU GUID." }

        $sku = Get-MgSubscribedSku | Where-Object { $_.SkuId -eq $skuGuid }
        if (-not $sku) { throw "SKU is not available in this tenant: $skuGuid" }
        if ($sku.ConsumedUnits -ge $sku.PrepaidUnits.Enabled) { throw "No unassigned seats are available for SKU $($sku.SkuPartNumber)." }

        Set-MgUserLicense -UserId $user.Id -AddLicenses @(@{ SkuId = $skuGuid }) -RemoveLicenses @() | Out-Null
        Write-LifecycleAudit -Action "AssignLicense" -TargetUser $UserPrincipalName -Status "Success" -Details "SKU assignment requested: $($sku.SkuPartNumber)"
    }

    [pscustomobject]@{
        UserPrincipalName = $UserPrincipalName
        Department = $Department
        GroupDisplayName = $groupEntry.groupDisplayName
        GroupObjectId = $groupId
        LicenseAssignmentRequested = [bool]$AssignLicense
        Status = "Completed; verify group membership and license independently."
    }
}
catch {
    Write-LifecycleAudit -Action "AssignAccess" -TargetUser $UserPrincipalName -Status "Failed" -Details $_.Exception.Message
    throw
}
