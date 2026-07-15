---
name: security-audit
description: >-
  Vulnerability scanning, dependency auditing, pre-commit security gates, and
  emergency lockdown. Enforces OWASP GenAI Top 10 defenses and ensures all code
  mutations pass security review before execution. This skill is PROTECTED —
  modifications require human approval regardless of archetype.
---

# Security Audit & Enforcement

## Overview

The security skill is the gatekeeper of the AI OS. No code enters or leaves the
project without its approval. It implements the security scan gate defined in
BOOT.md §6 and enforces the security policy from `rules/security_policy.md`.

> [!CAUTION]
> This skill is **PROTECTED**. Unlike other skills, modifications to `security.sk`
> require explicit human approval at ALL archetype levels. This prevents the agent
> from weakening its own security controls.

## Commands

### SECURITY_AUDIT

Full workspace vulnerability scan.

```
> OS_COMMAND SECURITY_AUDIT [--depth=quick|standard|all] [--scope=<path>]
```

**Parameters:**
- `--depth` (default: `standard`)
  - `quick`: Secrets scan only — fast, catches hardcoded credentials
  - `standard`: Secrets + injection patterns + unsafe functions
  - `all`: Full scan including dependency audit, license check, and configuration review
- `--scope` (default: `.`): Limit scan to a specific directory or file

**Procedure:**
1. Check context engine mode. If Massive Context Strategy is active, load dependency graph and perform full-codebase cross-file taint analysis simultaneously.
2. Scan all files in scope for secret patterns (see `security_policy.md` LLM02 patterns)
3. Scan for injection vulnerabilities (command injection, SQL injection, XSS, path traversal). With massive context, track variables across module boundaries to find complex injection vectors.
4. Scan for unsafe function usage (`eval`, `exec`, `os.system`, `pickle.loads`, etc.)
5. If `--depth=all`: Run dependency vulnerability check (SECURITY_CHECK_DEPS)
6. Generate report: findings count by severity, file locations, recommended fixes
7. Log scan result in `memory/episodic/decisions.jsonl`

**Output:** Structured scan report with findings categorized as CRITICAL / HIGH / MEDIUM / LOW.

---

### SECURITY_SCAN_FILE

Scan a specific file for vulnerabilities.

```
> OS_COMMAND SECURITY_SCAN_FILE --file=<path>
```

**Procedure:**
1. Read the target file
2. Run all pattern checks (secrets, injection, unsafe functions)
3. Report findings or "CLEAN — no vulnerabilities detected"

This is the command invoked automatically by the pre-commit security gate.

---

### SECURITY_CHECK_DEPS

Dependency vulnerability check.

```
> OS_COMMAND SECURITY_CHECK_DEPS [--fix]
```

**Procedure:**
1. Identify the project's dependency files (package.json, pyproject.toml, Cargo.toml, etc.)
2. Parse installed dependencies and their versions
3. Cross-reference against known vulnerability patterns:
   - Deprecated packages
   - Packages with known CVEs
   - Suspiciously named packages (typosquatting detection)
   - Packages with no recent updates (>2 years)
4. Report findings with severity and recommended actions
5. If `--fix`: Suggest version upgrades for vulnerable packages

---

### SECURITY_REVIEW_CHANGE

Pre-commit security review of staged or proposed changes.

```
> OS_COMMAND SECURITY_REVIEW_CHANGE [--files=<file1,file2,...>]
```

**Procedure:**
1. Identify changed files (from git diff or explicit list)
2. Run SECURITY_SCAN_FILE on each changed file
3. Check for new dependencies added
4. Check for permission changes (file mode changes)
5. Check for new API endpoints or exposed surfaces
6. Generate change-specific security review

**This command is automatically invoked before any code mutation** per Rule R1.

---

### SECURITY_LOCKDOWN

Emergency freeze — halt all autonomous operations.

```
> OS_COMMAND SECURITY_LOCKDOWN [--reason=<description>]
```

**Procedure:**
1. Set all skill circuit breakers to OPEN
2. Disable autonomous operations
3. Log the lockdown event with timestamp and reason
4. Notify user immediately: "SECURITY LOCKDOWN ACTIVATED: {reason}"
5. Only available commands in lockdown: HELP, STATUS, HEAL_DIAGNOSE, SECURITY_AUDIT
6. Lockdown remains until user explicitly runs: `> OS_COMMAND SECURITY_LOCKDOWN --lift`

---

## Detection Patterns

### Secrets (CRITICAL)
```
API keys:        (?i)(api[_-]?key|apikey)\s*[=:]\s*['"]?[A-Za-z0-9_\-]{16,}
AWS keys:        (AKIA|ABIA|ACCA|ASIA)[0-9A-Z]{16}
Private keys:    -----BEGIN (RSA |EC |DSA )?PRIVATE KEY-----
GitHub tokens:   (ghp_|gho_|ghu_|ghs_|ghr_)[A-Za-z0-9_]{36,}
Generic secrets: (?i)(secret|password|passwd|pwd)\s*[=:]\s*['"][^'"]{8,}
JWT tokens:      eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}
```

### Injection (HIGH)
```
Command:  os\.system\(   subprocess\.call\(.*shell=True   child_process\.exec\(
SQL:      f"SELECT.*{    f"INSERT.*{    "SELECT " + var
XSS:      innerHTML\s*=  document\.write\(   v-html=
Path:     \.\./          \.\.\\
```

### Unsafe Functions (MEDIUM)
```
eval(     exec(     pickle.loads(     yaml.load(.*Loader
__import__(   compile(.*exec   unserialize(
```

## Common Mistakes

1. **Skipping scan for "trivial" changes** — Even a one-line change can introduce a secret leak. The gate is mandatory.
2. **Ignoring LOW severity findings** — Low-severity issues compound. Review them periodically.
3. **Assuming dependencies are safe** — Transitive dependencies can introduce vulnerabilities the direct dependency doesn't have.
