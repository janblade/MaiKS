---
name: observability-audit
description: >-
  Decision logging, action tracing, session export, progress reporting, and
  system health dashboards. Provides transparency and an audit trail inspired
  by ISO/IEC 42001 principles and the AI OS governance framework.
---

# Observability & Audit Trail

## Overview

The observability skill ensures transparency — every significant decision, action,
and system state change is logged and auditable. This skill is the backbone of
the governance framework's transparency requirements, inspired by ISO 42001 principles.

## Commands

### LOG_DECISION

Record an architectural or significant decision.

```
> OS_COMMAND LOG_DECISION --decision=<text> --rationale=<text> [--alternatives=<text>]
```

**Procedure:**
1. Construct decision record:
   ```json
   {
     "timestamp": "{ISO 8601}",
     "type": "decision",
     "decision": "{what was decided}",
     "rationale": "{why this was chosen}",
     "alternatives_considered": ["{alt1}", "{alt2}"],
     "outcome": "pending",
     "confidence": 0.0-1.0,
     "references": ["{rules or standards referenced}"],
     "session_id": "{current session}"
   }
   ```
2. Append to `memory/episodic/decisions.jsonl`
3. Confirm: "Decision logged: {summary}"

---

### LOG_ACTION

Record a significant action with reasoning trace.

```
> OS_COMMAND LOG_ACTION --action=<text> --reason=<text> [--files=<affected>]
```

**Procedure:**
1. Construct action record:
   ```json
   {
     "timestamp": "{ISO 8601}",
     "type": "action",
     "action": "{what was done}",
     "reason": "{why}",
     "files_affected": ["{file1}", "{file2}"],
     "reversible": true|false,
     "session_id": "{current session}"
   }
   ```
2. Append to `memory/episodic/decisions.jsonl`

---

### TRACE_SESSION

Export the full session trace for audit.

```
> OS_COMMAND TRACE_SESSION [--session=<id>] [--format=json|markdown]
```

**Procedure:**
1. Collect all entries from `decisions.jsonl` matching the session ID
2. Collect session metadata from `sessions.jsonl`
3. Format as requested (JSON for machine processing, Markdown for human review)
4. Include: session duration, decisions made, files modified, evolutions applied, security scans run
5. Write to file: `.ai-os/memory/episodic/trace_{session_id}.{ext}`

---

### REPORT_PROGRESS

Generate a progress report from logs.

```
> OS_COMMAND REPORT_PROGRESS [--period=today|week|all]
```

**Procedure:**
1. Read recent entries from `decisions.jsonl`
2. Read evolution proposals from `progress.md`
3. Summarize:
   - Tasks completed
   - Decisions made (with rationale summaries)
   - Evolutions proposed/applied
   - Security scans run and findings
   - Open items and next steps
4. Update `progress.md` with the report

---

### REPORT_HEALTH

System-wide health dashboard.

```
> OS_COMMAND REPORT_HEALTH
```

**Procedure:**
1. **Boot status**: Last boot time, boot count, integrity result
2. **Archetype**: Active archetype and governance level
3. **Skills**: Status of each skill (circuit breaker state, last invoked, failure count)
4. **Memory**: Size of each memory store, last updated timestamps
5. **Security**: Last scan time, open findings count
6. **Evolutions**: Total applied, pending proposals, last evolution
7. **Project Genome**: Detected stack summary

**Output:** Formatted health dashboard.

---

## Automatic Logging

The observability skill is invoked automatically by other skills:
- **Security skill**: Logs scan results after every SECURITY_AUDIT/SCAN_FILE
- **Evolution skill**: Logs every proposal, application, and rollback
- **Self-healing skill**: Logs diagnoses, repairs, and circuit breaker state changes
- **Boot sequence**: Logs session start and integrity results

## Common Mistakes

1. **Logging too much detail** — Keep entries concise. Reference files rather than embedding content.
2. **Forgetting to log decisions** — If you chose between alternatives, log it. Future sessions need this context.
3. **Not reviewing logs** — Logs are useful only if read. Regularly review via REPORT_PROGRESS.
