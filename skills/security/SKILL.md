---
name: security
description: Language-agnostic vulnerability checklist. Use when writing, editing, or reviewing code that handles user input, auth, secrets, crypto, files, HTTP, DB, templating, deserialization, or external processes; when adding a new endpoint, form handler, query, fetch, or file operation; when reviewing a diff or PR for security issues. Web emphasis but covers CLI and libraries.
---

# Security checklist

Apply this checklist while writing or reviewing code. Flag every match. Do not assume safe by default.

Principle: untrusted input is everything from outside the current process — HTTP request, env var at runtime, file on disk, DB row written by someone else, third-party API response, message queue payload. Validate at the edge, trust the core.

## How to use this skill

**Proactive mode (default):** while editing, watch for the categories below. When a line touches one, verify against the checklist before moving on.

**Review mode (invoked):** walk every category, scan the target files, report findings in the output format at the bottom.

A finding is not a lecture. Point to line, name the class, give the one-line fix.

## Severity guide

- **Critical** — remote code execution, auth bypass, data exfiltration of secrets or full user data.
- **High** — privilege escalation for a single user, stored XSS, SQLi with read, SSRF to internal services, persistent auth weakness.
- **Medium** — reflected XSS, CSRF on non-critical action, info leak, open redirect, weak crypto on non-auth data.
- **Low** — missing defense-in-depth header, verbose error message, minor info leak.

Block merge on critical/high. Fix medium same PR if cheap. Low can be a follow-up.

---

## 1. Injection

- **SQL injection** — parameterized query / prepared statement. Never string-concat user input into SQL. Fix: use driver placeholders.
- **NoSQL injection** — never pass raw user objects to Mongo/Firestore queries. Fix: whitelist fields, cast types.
- **Command injection** — no `shell: true`, no `exec(userString)`. Fix: `execFile` / `spawn` with arg array, never a single shell string.
- **Path traversal** — never open a path built from user input without normalizing and prefix-checking. Fix: `path.resolve(base, user)` then assert `startsWith(base + sep)`.
- **SSRF** — user-supplied URL to `fetch`/`http.request`. Fix: allowlist host, block private IP ranges (10/8, 172.16/12, 192.168/16, 127/8, 169.254/16, ::1, fc00::/7), resolve DNS and check again.
- **Template injection** — user input passed to a template engine's `eval`-like render (e.g. Jinja `from_string`, EJS unescaped). Fix: render fixed templates with user data as variables, never compile user strings.
- **LDAP / XPath injection** — same as SQLi, parameterize or escape per library.
- **Log injection (CRLF)** — user input with `\n` / `\r` written to logs or HTTP headers. Fix: strip control chars before log/header write.
- **Header injection** — user input in `Location`, `Set-Cookie`, or any response header. Fix: validate + strip CRLF.
- **Regex DoS** — user-supplied regex, or catastrophic-backtracking pattern on user input. Fix: never compile user regex; replace nested quantifiers.
- **XXE** — XML parser with external entities enabled. Fix: disable entity expansion (libxml `noent: false`, Java `setFeature(..."external-general-entities"...)`), prefer JSON.
- **Prototype pollution (JS)** — merging user objects into base object. Fix: `Object.create(null)` for maps, reject `__proto__` / `constructor` / `prototype` keys, use `structuredClone` or a dedicated merge lib.
- **Mass assignment** — blindly spreading `req.body` into a DB model. Fix: explicit allowlist of fields per endpoint.

## 2. Deserialization and dynamic execution

- No `eval`, `new Function`, `setTimeout(stringArg)` on user input.
- Python: no `pickle.loads`, `yaml.load` (use `yaml.safe_load`), `marshal.loads` on untrusted data.
- Node: no `vm.runInNewContext(userCode)` outside of a sandboxed runtime with CPU/memory limits.
- Java/.NET: no `ObjectInputStream.readObject`, no `BinaryFormatter` on untrusted bytes.
- JSON is safe to parse; reviving with a custom reviver that executes user strings is not.

## 3. Authentication

- Passwords hashed with `argon2id` (preferred), `bcrypt`, or `scrypt`. Never MD5, SHA-1, SHA-256 without KDF, or plain.
- Compare secrets with constant-time equals. Never `===` / `==` on tokens, HMACs, API keys.
- Session ID rotates on login and privilege change. Prevents fixation.
- Session cookie: `HttpOnly`, `Secure`, `SameSite=Lax` (or `Strict` for auth), path-scoped, expiring.
- JWT: reject `alg: none`, pin the expected `alg`, verify `exp`, verify `iss` / `aud`, sign with a real secret (not `"secret"`), rotate keys.
- MFA enforced for privileged accounts. Recovery flow reviewed — it is the usual bypass.
- Brute-force protection on login, password reset, OTP verify. Rate limit + account lockout with a backoff, not a hard lock that can be abused for DoS.
- Password reset token: single-use, short TTL, tied to user id, invalidated on use.

## 4. Authorization

- Every state-changing endpoint authorizes the actor on the target resource — not just "is logged in". Missing this = IDOR.
- Do not trust IDs from the client to imply ownership. Re-check: "does `user.id` own `resource.id`?".
- Role check at mutation, not only in the UI.
- Privilege escalation paths: role change, invite flow, share link — assume attacker controls the input to every field.
- Tenant isolation: multi-tenant query must include `tenant_id = :current` in the WHERE, even on a seemingly scoped table.

## 5. Secrets and credentials

- No secret in the repo. Scan `.env`, `config.*`, `*.pem`, `*.key`, service-account JSON, cloud cred files before commit.
- No secret in logs. Redact tokens, passwords, cookie values, auth headers.
- No secret in client bundle. Public env vars (`NEXT_PUBLIC_`, `PUBLIC_`, `VITE_`) are public — treat accordingly.
- No secret in error messages returned to users.
- No hardcoded credentials, API keys, DB URLs with inline password.
- Use platform secret manager or env at runtime. Rotate on compromise or role change.

## 6. Crypto

- Do not roll your own. Use a vetted library.
- Symmetric: AES-GCM or ChaCha20-Poly1305. No ECB. Never reuse an IV with the same key.
- Asymmetric: RSA ≥ 2048, preferably EdDSA / ECDSA on curve25519 / P-256.
- Hashing for integrity: SHA-256+. For passwords: see §3.
- Randomness for security: `crypto.randomBytes` / `secrets.token_bytes` / `SecureRandom`. Never `Math.random`, `rand()`, or `new Random()`.
- Salt passwords per-user. No static salt. No missing salt.
- TLS: pin minimum TLS 1.2, prefer 1.3. Verify cert chain. Do not `rejectUnauthorized: false` outside of local dev.

## 7. XSS and output encoding

- Escape user content by context: HTML body, HTML attribute, JS string, URL, CSS. Use the framework's auto-escape. Audit every bypass.
- Framework escapes: React/JSX (safe by default, watch `dangerouslySetInnerHTML`), Svelte (safe, watch `{@html}`), Vue (`v-html` is raw), Angular (`[innerHTML]` + trusted types).
- Content-Security-Policy header: default `script-src 'self'`, avoid `unsafe-inline` and `unsafe-eval`. Use nonces if inline needed.
- Reflected XSS: any user value rendered in HTML or JS must be escaped.
- Stored XSS: apply the same at render time. Do not sanitize only on write — render path must not trust DB.
- DOM XSS: `innerHTML`, `outerHTML`, `document.write`, `eval`, `setTimeout` with string, `location = userUrl`, `href = 'javascript:...'`.

## 8. CSRF

- State-changing endpoints use one of: same-site cookie + origin check, CSRF token, or a framework's built-in (e.g. SvelteKit form actions, Rails `authenticity_token`).
- Endpoints that accept `GET` must be side-effect-free. `GET /logout` is a CSRF bug.
- Custom headers (e.g. `X-Requested-With`) rely on browsers rejecting them cross-origin — safe for fetch/XHR, not for form submissions.

## 9. CORS

- Default: no CORS. Same-origin only.
- If needed: explicit origin allowlist, not `*` when credentials are involved.
- `Access-Control-Allow-Credentials: true` with `Access-Control-Allow-Origin: *` is forbidden by browsers and suggests a config mistake.
- Never reflect `Origin` back without validation.

## 10. Open redirect

- Do not redirect to a URL supplied by the user without allowlisting.
- Relative path allowlist: reject `//evil.com` (protocol-relative), reject absolute URLs unless host matches a known-safe list.
- Login `?next=` param is the classic offender — validate before redirect.

## 11. Security headers

- `Content-Security-Policy` — §7.
- `Strict-Transport-Security: max-age=31536000; includeSubDomains` on HTTPS.
- `X-Content-Type-Options: nosniff`.
- `X-Frame-Options: DENY` (or `frame-ancestors` in CSP).
- `Referrer-Policy: strict-origin-when-cross-origin` or stricter.
- `Permissions-Policy` to disable unused browser features.
- Remove `Server` / `X-Powered-By` headers.

## 12. Cookies

- `HttpOnly` for session and auth cookies.
- `Secure` in production.
- `SameSite=Lax` default. `Strict` for auth. `None` only with `Secure` and a reason.
- Path and domain scoped narrowly.
- Expire on logout. Rotate on auth events.

## 13. Rate limiting and abuse

- Rate-limit: login, signup, password reset, OTP verify, email send, expensive endpoints, any unauthenticated write.
- Limit by IP + user + API key. Separate buckets.
- Exponential backoff on repeated failure. Lockout strategies must not let an attacker DoS a victim.
- Enforce resource caps: max request body size, max file upload size, max JSON depth, max array length in body, max query result rows.

## 14. File upload and download

- Validate size before reading into memory.
- Validate type by magic bytes, not just Content-Type or extension.
- Store uploads outside web root, or on a separate origin / storage bucket.
- Serve user uploads from a different domain or with `Content-Disposition: attachment` to block scripts.
- Sanitize filenames: strip path separators, control chars, leading dots; prefer storing under a generated id and keeping the original name as metadata.
- Antivirus-scan user content when the product ingests documents broadly.
- For downloads: do not build paths from user input (§1 path traversal).

## 15. Server-side requests (SSRF, §1 expanded)

- Fetch-from-user-URL flows: preview, webhook, image proxy, import. Each is high-risk.
- Block private/link-local/loopback ranges at DNS resolution and at IP level (TOCTOU resolver tricks exist).
- Do not follow redirects blindly — re-validate the final URL.
- In cloud: block metadata endpoints (`169.254.169.254`, `fd00:ec2::254`, GCP metadata). These leak IAM credentials.

## 16. Race conditions and concurrency

- TOCTOU: checking a file/record then using it — attacker mutates between. Fix: do the check inside the same atomic operation.
- Financial mutations (balance, transfer, quota): use DB transactions or row-level locks, not read-then-write.
- Unique constraint races: rely on DB unique index, not a pre-insert SELECT.
- Idempotency keys on external mutations (payments, email) so retries do not double-act.

## 17. Errors and information disclosure

- No stack trace to the client in production.
- No raw DB error text to the client — leaks schema.
- Distinguish expected errors (return 4xx with safe message) from unexpected (log internally, return a generic 500).
- 404 vs 403: returning 404 when the resource exists but is unauthorized can leak less than 403; returning 403 when it does not exist leaks existence. Pick one policy and apply consistently.

## 18. Logging and audit

- Log authentication events: login, logout, password change, MFA enroll, role change, permission grant.
- Log privileged actions: user impersonation, data export, admin access.
- Do not log: passwords, tokens, full credit cards, full SSN, session IDs. Redact.
- Log with structure (JSON), include request id, user id, tenant id where available.
- Logs go to a sink the attacker cannot scrub. Integrity matters for forensics.

## 19. Privacy and PII

- Collect minimum. Justify each field.
- Encrypt PII at rest when the platform does not already.
- Delete on account deletion. Respect retention policies.
- Do not paste PII into third-party services (AI APIs, analytics) without review.
- Share link / export features: verify scope before returning data.

## 20. Dependencies and supply chain

- Pin versions in the manifest, use a lockfile, commit the lockfile.
- Run the platform audit (`npm audit`, `pip-audit`, `cargo audit`, `go list -json -deps -m all`) in CI.
- Review new deps: maintainer, last release, install scripts, native deps. An obscure dep with a postinstall script is a supply-chain vector.
- Prefer stdlib for small utility needs.
- Verify checksums / signatures for binaries and container base images.

## 21. Infrastructure and config

- Secrets via platform secret manager. Not in Docker image, not in CI env dumps.
- Minimum IAM per service. No wildcard `*` on resource or action in prod.
- Public S3 / GCS buckets audited. Default private.
- DB not reachable from public internet. VPC-scoped.
- Container runs as non-root. Read-only root filesystem where possible.
- Debug/admin endpoints disabled or auth-gated in prod.

## 22. Framework-specific reminders

- **React / Vue / Svelte:** watch `dangerouslySetInnerHTML` / `v-html` / `{@html}`; avoid rendering JSON straight into `<script>` without escaping `</`.
- **Node / Express:** body size limit (`express.json({ limit: '100kb' })`), `helmet` for default headers.
- **SvelteKit:** form actions have CSRF. `+server.js` endpoints do not — validate origin for state-changing endpoints.
- **Next.js:** API routes do not CSRF-protect by default. Server Actions do. Know which one you are writing.
- **Python Django:** CSRF middleware on by default — do not decorate views with `csrf_exempt` lightly.
- **Python Flask:** no CSRF built in, add `Flask-WTF` or equivalent.
- **Rails:** `protect_from_forgery` on, do not `skip_before_action` without thought.
- **Spring:** `@EnableWebSecurity`, CSRF on for stateful apps.

## 23. What to check in a diff

1. Every new input source — request body/query/header, file read, env var at runtime, DB row of untrusted origin.
2. Every new output sink — HTML render, SQL query, shell command, `fetch`, file write, log line with user content, HTTP header write, redirect.
3. Every new endpoint/handler — auth? authorize? rate limit? CSRF? input validation? error shape?
4. Every new secret path — env, config, key file, header. Not in the repo?
5. Every new dep — trusted? pinned? audited?

## 24. Output format (review mode)

When asked to review, produce findings as a list. One block per finding:

```
[SEVERITY] <short name>
File: <path>:<line>
Class: <vuln category from §1–22>
What: <one-line description of the vulnerable pattern>
Fix: <one-line remediation>
```

After the findings, add:

- **Summary:** N critical, N high, N medium, N low.
- **Blocking:** list any critical/high items that block merge.
- **Confidence:** note if any finding relies on assumption about code not shown.

If no findings: say "No findings in reviewed scope" and list what was scoped (files, categories skipped and why).

## 25. Not in scope

- Formal threat modeling of the whole system.
- Compliance-specific controls (PCI, HIPAA) beyond the hygiene here.
- Red-team / active exploitation — code review only.
- Cryptographic protocol design — flag "use a library" and stop.

Flag these as out of scope; do not fake coverage.
