# Prerequisites

## Environment

- PowerShell 7 recommended.
- Microsoft Graph PowerShell SDK installed for the current user.
- A dedicated Microsoft 365 / Entra ID test tenant.
- A verified test domain and a test user UPN.
- Test security groups and an available license SKU.
- An administrator/operator account authorized for the operations being tested.

## Install the SDK

```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
```

To update an existing installation, use your organization's approved module-management process.

## Connect

The example connection script requests delegated scopes for user, group, license, and session operations. Review the exact permission requirements for each Graph API and request only what the test needs. Admin consent and appropriate Entra roles may be required.

```powershell
.\scripts\Connect-MgGraph.ps1
Get-MgContext | Select-Object TenantId, Account, Scopes
```

Do not paste tokens or secrets into the repository, issue tracker, screenshots, or chat.

## Required configuration

1. Copy `config/department-groups.example.json` to a local configuration file.
2. Replace example group IDs with actual group object IDs in the test tenant.
3. Copy `config/license-mapping.example.json` to a local configuration file.
4. Replace the example SKU GUID with an available SKU ID.
5. Replace all example domains in commands and script safety checks before running.
6. Confirm usage location and licensing requirements.

## MFA requirements

MFA enforcement is a policy configuration task, not simply a user property. Configure Conditional Access in Microsoft Entra if the tenant license supports it; otherwise review supported security defaults. Test with a pilot group and protect emergency-access accounts according to Microsoft's guidance.

## Cleanup

After testing, review assigned licenses, group membership, test users, logs, and any temporary configuration. Do not remove the account or license until you have documented the data-retention and recovery implications.
