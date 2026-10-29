[CmdletBinding()]
param(
    [Parameter(Mandatory)][string]$UserPrincipalName
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "Common/Lifecycle.Common.ps1")
Assert-LifecycleConnection | Out-Null

$user = Get-MgUser -UserId $UserPrincipalName -Property Id,DisplayName,UserPrincipalName,Department,JobTitle,UsageLocation,AccountEnabled,AssignedLicenses
if (-not $user) { throw "User not found: $UserPrincipalName" }

[pscustomobject]@{
    Id                = $user.Id
    DisplayName       = $user.DisplayName
    UserPrincipalName = $user.UserPrincipalName
    Department        = $user.Department
    JobTitle          = $user.JobTitle
    UsageLocation     = $user.UsageLocation
    AccountEnabled    = $user.AccountEnabled
    AssignedLicenseCount = @($user.AssignedLicenses).Count
}
