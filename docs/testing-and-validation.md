# Testing and Validation

Use only authorized test accounts. Record actual observed results; do not mark a test as passed before running it.

## General test method

1. Record the test ID and preconditions.
2. Execute the command against a designated lab account.
3. Verify state with a separate Graph read or admin portal.
4. Save sanitized evidence.
5. Record pass/fail, timestamp, operator, and remediation.

## Test scenarios

| ID | Scenario | Expected result |
|---|---|---|
| ONB-01 | Create user with valid attributes | User exists with expected properties |
| ONB-02 | Create duplicate UPN | Script stops without creating duplicate |
| ONB-03 | Use unknown department | Access assignment is rejected |
| ONB-04 | Assign available SKU | Expected license appears on user |
| ONB-05 | Add approved group | User appears in group membership |
| ONB-06 | Verify MFA policy | Test sign-in follows configured policy |
| OFF-01 | Disable approved lab user | AccountEnabled is false |
| OFF-02 | Revoke sessions | Graph request succeeds and is logged |
| OFF-03 | Omit preservation approval | License removal is blocked |
| OFF-04 | Target outside lab domain | Safety validation rejects target |
| OFF-05 | Simulate Graph failure | Failure is logged; completion isn't falsely reported |

## Evidence fields

- Test ID
- Preconditions
- Command/operation
- Expected result
- Actual result
- Pass/fail
- Date/time (UTC)
- Sanitized screenshot or log reference
- Remediation notes
