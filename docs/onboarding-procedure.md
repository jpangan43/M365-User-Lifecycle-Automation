# Onboarding Procedure

## Goal

Provision a new employee using validated input and a least-privilege access profile.

## 1. Validate the request

Confirm the request has approval, legal name, unique UPN, department, job title, usage location, start date, manager (if applicable), and required access. Do not treat a CSV row as proof of approval by itself.

## 2. Prepare configuration

- Map department to an approved security group.
- Map the role to a license SKU.
- Verify the group and SKU exist in the tenant.
- Confirm license availability.
- Ensure the UPN domain is verified and approved.

## 3. Create the user

Use `scripts/New-M365Employee.ps1`. The script checks for an existing UPN, requires an explicit confirmation switch, creates the account, and records a sanitized audit event.

## 4. Assign access

Use `scripts/Add-M365EmployeeAccess.ps1` to add the user to the configured department group. License assignment is optional and requires both `-AssignLicense` and `-ConfirmChanges`.

## 5. Configure MFA and application access

- Apply the tenant's approved Conditional Access / MFA policy to the appropriate pilot group.
- Validate application assignments and role requirements.
- Confirm the user can sign in and complete the required MFA flow.
- Do not place users into privileged groups simply to make a test succeed.

## 6. Verify

- Read the user back from Graph.
- Confirm the correct department and job title.
- Confirm group membership.
- Confirm the expected license SKU.
- Validate MFA and application access in the relevant admin portals.
- Record evidence and audit results.

## Expected result

The employee account is created with the approved properties and only the intended access. Any failed step must be documented and resolved before the onboarding request is marked complete.
