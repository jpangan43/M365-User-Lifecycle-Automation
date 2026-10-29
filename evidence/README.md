# Evidence Checklist

Use fictional users or a dedicated test tenant. Redact tenant IDs, email addresses, object IDs where appropriate, secrets, tokens, and other sensitive information before publishing.

| ID | Evidence | What it proves |
|---|---|---|
| E01 | Architecture diagram | Workflow and trust boundaries |
| E02 | Graph connection context | SDK connectivity and reviewed scopes |
| E03 | Sample CSV/configuration | Input and access mapping |
| E04 | User creation output | Account creation and key attributes |
| E05 | License details | License assignment verification |
| E06 | Group membership | Department access assignment |
| E07 | Conditional Access policy | MFA policy configuration |
| E08 | Test sign-in / MFA status | MFA validation |
| E09 | Disabled account properties | AccountEnabled is false |
| E10 | Session revocation result | Revocation request completed |
| E11 | Data-preservation checklist | Mailbox/OneDrive/retention review |
| E12 | License details after removal | License state verified |
| E13 | Sanitized audit log | Operations are recorded |
| E14 | Test-case results | Negative and positive testing |

For every image, document objective, steps, expected result, actual result, and any limitations. Do not describe an unexecuted test as successful.
