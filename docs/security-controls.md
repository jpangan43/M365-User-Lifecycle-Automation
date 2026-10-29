# Security Controls

## Control objectives

- Least privilege: request only the Microsoft Graph scopes needed for the current tasks.
- Approval: require an explicit confirmation switch for high-impact changes.
- Target validation: use the intended lab domain and verify the exact user.
- Input validation: reject missing, malformed, duplicate, or unmapped values.
- Data preservation: gate license removal on a separate review flag.
- Auditability: record timestamps, action, target, status, and sanitized details.
- Secret hygiene: never log passwords, access tokens, or authentication secrets.
- Separation of duties: where feasible, have a second operator approve destructive or high-impact steps.

## Known limitations

The confirmation switches are operator guardrails, not a complete authorization system. Domain checks must be customized and reviewed. Scripts should be peer-reviewed, tested, and adapted before production use. Do not use a broad tenant-wide scope when a narrower permission model is available.

## Suggested improvements

- Add Pester tests and CI linting.
- Use certificate-based app-only authentication only where appropriate and securely managed.
- Use managed identity in supported automation hosting environments.
- Store logs in a controlled, immutable or access-restricted destination.
- Add change-ticket/approval references to every operation.
- Implement retry logic with bounded retries and clear partial-failure reporting.
- Use a secure secrets manager rather than files or environment variables for secrets.
- Add dry-run support and an allowlist of lab users.
