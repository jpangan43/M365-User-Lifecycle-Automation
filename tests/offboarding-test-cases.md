# Offboarding Test Cases

| ID | Test | Expected result | Actual result |
|---|---|---|---|
| OFF-01 | Missing `-ConfirmOffboarding` | No changes; operation blocked | Record after execution |
| OFF-02 | Target outside approved domain | Operation refused | Record after execution |
| OFF-03 | Valid approved lab user | Account disabled | Record after execution |
| OFF-04 | Session revocation | Graph request succeeds; propagation is separately validated | Record after execution |
| OFF-05 | Graph revocation failure | Partial state reported clearly; retry/escalation required | Record after execution |
| OFF-06 | Missing `-PreservationReviewed` | License removal blocked | Record after execution |
| OFF-07 | Missing `-ConfirmLicenseRemoval` | License removal blocked | Record after execution |
| OFF-08 | Account still enabled | License removal blocked | Record after execution |
| OFF-09 | Wrong SKU ID | License removal blocked | Record after execution |
| OFF-10 | Approved direct-license removal | License removal requested; verify afterward | Record after execution |

Record the test date/time in UTC, preconditions, sanitized evidence reference, pass/fail, and remediation. Do not test against production accounts.
