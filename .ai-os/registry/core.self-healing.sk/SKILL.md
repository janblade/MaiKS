---
name: self-healing
description: >-
  Circuit breakers, loop detection, failure classification, auto-repair, and
  emergency protocols. Makes the AI OS resilient to failures — it detects when
  something is broken and repairs itself or escalates gracefully.
---

# Self-Healing & Resilience

## Overview

Production AI systems fail. The self-healing skill ensures failures are detected,
classified, and recovered from — automatically when possible, with human escalation
when necessary. It implements the circuit breaker pattern, loop detection, and
failure classification from BOOT.md §7.

## Dependencies

- `observability.sk` — Required for logging diagnoses and repairs

## Commands

### HEAL_DIAGNOSE

Diagnose system issues.

```
> OS_COMMAND HEAL_DIAGNOSE [--scope=framework|project|all] [--auto-repair]
```

**Procedure:**
1. **Framework Diagnosis:** Review `ultimate_rules.md` and `BOOT.md` to ensure you haven't violated any governance constraints.
2. **Project Diagnosis:** Run tests or builds to identify the root cause of the current failure.
3. **Report Findings:** Clearly explain the root cause of the failure to the user before attempting a fix.

---

### HEAL_REPAIR

Auto-repair detected issues.

```
> OS_COMMAND HEAL_REPAIR [--issue=<id>] [--all-safe]
```

**Repair strategies by issue type:**

| Issue | Repair Strategy |
|---|---|
| Missing user-space file | Recreate from default template |
| Orphaned skill registration | Remove from `index.json` |
| Missing skill registration | Add to `index.json` based on disk scan |
| Corrupt JSON file | Attempt parse recovery; if impossible, reset to default |
| Corrupt JSONL file | Remove malformed lines, preserve valid entries |
| Stale project genome | Re-run perception scan |
| Circuit breaker stuck OPEN | Reset to CLOSED after probe test |
| Orphaned evolution proposal | Mark as EXPIRED |

**Safety rules:**
- NEVER repair kernel-space files without human approval
- NEVER delete memory without logging what was removed
- NEVER modify security.sk during repair
- Always log every repair action in `decisions.jsonl`

If `--all-safe`: Repair all issues that are safe to auto-fix (LOW + MEDIUM severity).

---

### HEAL_ROLLBACK

Rollback to last known good state.

```
> OS_COMMAND HEAL_ROLLBACK [--scope=last-evolution|last-session|full-reset]
```

**Scopes:**
- `last-evolution`: Revert the most recent evolution (delegates to `EVOLVE_ROLLBACK`)
- `last-session`: Revert all changes made in the current session (requires session tracking)
- `full-reset`: Reset all user-space files to default templates (DESTRUCTIVE — requires confirmation)

**Procedure:**
1. Identify the rollback scope
2. For `last-evolution`: Use preserved state from evolution skill
3. For `last-session`: Use git diff or session change log to identify and revert changes
4. For `full-reset`: Confirm with user, then recreate all user-space files from defaults
5. Run integrity check after rollback
6. Log rollback in `decisions.jsonl`

---

## Cognitive Loop Detection

If you find yourself attempting the same fix 3 times and receiving the same error, **STOP**.
Do not blindly retry a 4th time. Escalate to the user and ask for guidance or alternative approaches.

## Cognitive Repair Protocol

When you encounter a persistent failure:
1. Stop the current action chain.
2. Formulate a new hypothesis. If the local fix isn't working, consider if the root cause is in a different file or dependency.
3. Use your file reading tools (`view_file`, `grep_search`) to gather broader context.
4. Attempt an alternative strategy.
5. **If the repair is successful**, ask the user: *"I have successfully repaired the issue. Would you like me to document this fix in `playbooks.md` so I know how to resolve it automatically next time?"*

## Common Mistakes

1. **Blind Retries** — Retrying the exact same command hoping it will work.
2. **Ignoring Root Causes** — Fixing the symptom instead of the underlying architectural flaw.
3. **Not Logging Repairs** — Every repair is a learning opportunity. Always log what was broken and how it was fixed.
