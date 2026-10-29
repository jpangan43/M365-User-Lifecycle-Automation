# Offboarding Procedure

## Goal

Terminate access promptly while preserving business data and meeting retention obligations.

## 1. Validate approval and identity

Confirm the employee identity, approved termination/change request, effective time, and required systems. Use the exact UPN and verify it belongs to the lab/test domain when using this repository's example safety check.

## 2. Disable sign-in and revoke sessions

Run `scripts/Disable-M365Employee.ps1` with `-ConfirmOffboarding`. Verify `AccountEnabled` is false and the session-revocation request succeeded.

Revocation is not guaranteed to invalidate every application session instantaneously. Review other sign-in paths, app-specific sessions, devices, refresh-token behavior, service accounts, and credentials as required by the organization's incident/offboarding procedure.

## 3. Remove or adjust access

Review group membership, enterprise application assignments, privileged roles, VPN, endpoint access, and other non-Microsoft systems. This sample repository does not automatically remove all of these.

## 4. Preserve data

Before license removal, review:
- Exchange mailbox type, size, archive, retention policies, and legal holds.
- OneDrive files, ownership transfer, retention, and access requirements.
- SharePoint/Teams data ownership and retention.
- eDiscovery or litigation hold obligations.
- Approved retention period and data owner.

A shared mailbox conversion is not a universal preservation solution. Licensing and mailbox size, archive, hold, and retention conditions matter. Consult current Microsoft documentation and the tenant's policies.

## 5. Remove eligible license

Only after preservation has been reviewed and approved, run `scripts/Remove-M365EmployeeLicense.ps1` with both `-PreservationReviewed` and `-ConfirmLicenseRemoval`. This is a direct-license removal example; group-based licensing should be managed through the assigned group.

## 6. Close out

Document results, failures, outstanding tasks, ticket/reference number, operator, and timestamps. Do not delete the user as part of this sample workflow.
