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
1. **Framework diagnosis:**
   - Run kernel integrity check (verify all expected files exist and parse)
   - Check `registry/index.json` consistency (all registered skills exist on disk)
   - Check `commands/index.json` consistency (all commands map to valid skills)
   - Check memory file integrity (JSONL parse, JSON parse, MD readability)
   - Check circuit breaker states (any skills in OPEN or DEGRADED?)
   - Check for orphaned evolution proposals (PROPOSED but never resolved)

2. **Project diagnosis:**
   - Run `INFRA_HEALTH_CHECK` (build, lint, type-check, test)
   - Check for common project health issues (missing lock file, outdated deps)

3. **Report findings:**
   | Severity | Examples |
   |---|---|
   | CRITICAL | Kernel files missing, manifest corrupt, security.sk broken |
   | HIGH | Skill circuit breaker OPEN, integrity check failures |
   | MEDIUM | Orphaned registrations, stale memory entries |
   | LOW | Missing optional files, outdated genome |

4. If `--auto-repair`: Automatically fix LOW and MEDIUM issues (see HEAL_REPAIR)

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

### HEAL_CIRCUIT_STATUS

Circuit breaker dashboard.

```
> OS_COMMAND HEAL_CIRCUIT_STATUS
```

**Output:** Status of every skill's circuit breaker:

```
┌──────────────────────┬──────────┬──────────┬───────────────┐
│ Skill                │ State    │ Failures │ Last Invoked  │
├──────────────────────┼──────────┼──────────┼───────────────┤
│ security.sk          │ CLOSED   │ 0        │ 2 min ago     │
│ infra.sk             │ CLOSED   │ 0        │ 5 min ago     │
│ testing.sk           │ DEGRADED │ 2        │ 1 min ago     │
│ evolution.sk         │ CLOSED   │ 0        │ 10 min ago    │
│ observability.sk     │ CLOSED   │ 0        │ 30 sec ago    │
│ context-engine.sk    │ CLOSED   │ 0        │ 3 min ago     │
│ self-healing.sk      │ CLOSED   │ 0        │ now           │
└──────────────────────┴──────────┴──────────┴───────────────┘
```

---

## Circuit Breaker Protocol

### State Transitions

```
CLOSED ──[3 consecutive failures]──→ OPEN
OPEN ──[probe succeeds after 5 interactions]──→ DEGRADED
DEGRADED ──[3 consecutive successes]──→ CLOSED
DEGRADED ──[1 failure]──→ OPEN
```

### Critical Failure (Instant OPEN)
These bypass the 3-failure threshold:
- Security breach detection
- Data loss or corruption
- Infinite loop detected
- Memory file corruption

### Probe Protocol
When a skill is OPEN:
1. Every 5 interactions, attempt a minimal "probe" invocation of the skill
2. If probe succeeds → transition to DEGRADED
3. If probe fails → remain OPEN, increment failure count
4. After 10 consecutive probe failures → escalate to user

---

## Loop Detection Protocol

### Detection Triggers
| Metric | Threshold | Action |
|---|---|---|
| Steps without progress | >15 | Pause and reassess |
| Tokens without output | >50,000 | Pause and report |
| Same action repeated | 3+ times, same result | Stop, try alternative |
| Circular reasoning | Contradictory conclusions | Reset context, re-approach |

### Recovery from Loop
1. Stop the current action chain
2. Log: `{loop_type, steps_taken, tokens_consumed, repeated_actions}`
3. Try alternative strategy (if available in procedural memory)
4. If no alternative: escalate to user with summary

## Common Mistakes

1. **Ignoring DEGRADED state** — DEGRADED means "partially working." Investigate before it goes OPEN.
2. **Manually resetting circuit breakers** — Let the probe protocol handle it. Manual resets bypass failure learning.
3. **Not logging repairs** — Every repair is a learning opportunity. Always log what was broken and how it was fixed.
