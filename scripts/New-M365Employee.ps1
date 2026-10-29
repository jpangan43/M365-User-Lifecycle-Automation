[CmdletBinding()]
param(
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$FirstName,
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$LastName,
    [Parameter(Mandatory)][ValidatePattern('^[^@\s]+@[^@\s]+\.[^@\s]+$')][string]$UserPrincipalName,
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$Department,
    [Parameter(Mandatory)][ValidateNotNullOrEmpty()][string]$JobTitle,
    [Parameter(Mandatory)][ValidatePattern('^[A-Z]{2}$')][string]$UsageLocation,
    [Parameter(Mandatory)][string]$AllowedDomain,
    [switch]$ConfirmCreate
)

$ErrorActionPreference = "Stop"
. (Join-Path $PSScriptRoot "Common/Lifecycle.Common.ps1")
Assert-LifecycleConnection | Out-Null
Assert-ApprovedTestDomain -UserPrincipalName $UserPrincipalName -AllowedDomain $AllowedDomain

if (-not $ConfirmCreate) {
    Write-LifecycleAudit -Action "CreateUser" -TargetUser $UserPrincipalName -Status "Blocked" -Details "Missing -ConfirmCreate."
    throw "No changes made. Re-run with -ConfirmCreate after reviewing the request."
}

$existing = Get-MgUser -Filter "userPrincipalName eq '$UserPrincipalName'" -ConsistencyLevel eventual
if ($existing) { throw "A user with UPN '$UserPrincipalName' already exists." }

$securePassword = Read-Host "Enter a temporary password for the lab account" -AsSecureString
$passwordText = [System.Net.NetworkCredential]::new("", $securePassword).Password

try {
    $params = @{
        AccountEnabled    = $true
        DisplayName       = "$FirstName $LastName"
        GivenName         = $FirstName
        Surname           = $LastName
        UserPrincipalName = $UserPrincipalName
        MailNickname      = (($UserPrincipalName -split "@")[0] -replace "[^A-Za-z0-9._-]", "")
        Department        = $Department
        JobTitle          = $JobTitle
        UsageLocation     = $UsageLocation
        PasswordProfile   = @{
            Password = $passwordText
            ForceChangePasswordNextSignIn = $true
        }
    }

    Write-LifecycleAudit -Action "CreateUser" -TargetUser $UserPrincipalName -Status "Started" -Details "Approved lab request."
    $created = New-MgUser @params
    Write-LifecycleAudit -Action "CreateUser" -TargetUser $UserPrincipalName -Status "Success" -Details "User object created; object ID omitted from audit."
    $created | Select-Object Id,DisplayName,UserPrincipalName,Department,JobTitle,UsageLocation,AccountEnabled
}
catch {
    Write-LifecycleAudit -Action "CreateUser" -TargetUser $UserPrincipalName -Status "Failed" -Details $_.Exception.Message
    throw
}
finally {
    $passwordText = $null
    $securePassword = $null
    if ($params) { $params.PasswordProfile = $null; $params = $null }
}
