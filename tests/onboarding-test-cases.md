# Onboarding Test Cases

| ID | Test | Expected result | Actual result |
|---|---|---|---|
| ONB-01 | Valid new user + approved domain + `-ConfirmCreate` | User created with expected attributes | Record after execution |
| ONB-02 | Duplicate UPN | Script stops; no duplicate user | Record after execution |
| ONB-03 | Unapproved domain | Script refuses before change | Record after execution |
| ONB-04 | Missing `-ConfirmCreate` | Script blocks operation | Record after execution |
| ONB-05 | Unknown department mapping | Access assignment stops | Record after execution |
| ONB-06 | Placeholder group ID remains | Access assignment stops | Record after execution |
| ONB-07 | Valid group mapping | User added to intended group | Record after execution |
| ONB-08 | Available license SKU + `-AssignLicense` | License assignment requested and verified | Record after execution |
| ONB-09 | Invalid/unavailable SKU | Script stops before assignment | Record after execution |
| ONB-10 | MFA pilot sign-in | Sign-in follows configured MFA policy | Record after execution |

Record the test date/time in UTC, test user alias, preconditions, sanitized evidence reference, pass/fail, and remediation. Never paste passwords or access tokens into this file.
