# Architecture

## Business problem

Manual employee onboarding and offboarding can cause delays, inconsistent access, missing audit evidence, and unnecessary license costs. The target workflow uses a controlled request, PowerShell validation, Microsoft Graph operations, verification, and a human-controlled data-preservation decision.

## Logical flow

1. HR/manager submits a request.
2. An authorized IT operator validates the request and approval.
3. PowerShell validates identity attributes and configured mappings.
4. Microsoft Graph performs permitted user, group, license, and session operations.
5. The scripts verify the resulting state and write sanitized audit events.
6. MFA and Conditional Access are configured and validated in Microsoft Entra.
7. For offboarding, IT confirms mailbox, OneDrive, retention, and legal-hold requirements before license removal.

## Trust boundaries

- Request data is untrusted until validated.
- The operator's Microsoft Graph session is privileged and must be protected.
- Configuration files contain tenant-specific object IDs; use examples in public GitHub and keep real values in a secure local copy.
- Logs must never contain passwords, tokens, secrets, or unnecessary personal data.
- License removal and any account deletion require separate approvals.

## Limitations

This repository does not create Conditional Access policies through code, perform mailbox exports, transfer OneDrive ownership, or delete users. Those actions depend on licensing, Exchange/SharePoint configuration, retention obligations, and organization-specific approvals.
