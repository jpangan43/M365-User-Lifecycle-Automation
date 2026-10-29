[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

if (-not (Get-Module -ListAvailable -Name Microsoft.Graph.Authentication)) {
    throw "Microsoft Graph PowerShell SDK is missing. Install-Module Microsoft.Graph -Scope CurrentUser"
}

# Review scopes against the exact operations and Microsoft Graph permissions before use.
$scopes = @(
    "User.ReadWrite.All",
    "Group.ReadWrite.All",
    "LicenseAssignment.ReadWrite.All",
    "User.RevokeSessions.All"
)

Connect-MgGraph -Scopes $scopes -NoWelcome
Get-MgContext | Select-Object TenantId, Account, Scopes
