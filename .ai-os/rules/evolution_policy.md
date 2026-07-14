# Evolution Policy — Self-Update Constraints & Gates

> This policy governs how the AI OS evolves itself. It defines what can change,
> who approves changes, and how to roll back failed evolutions.

---

## Evolution Boundaries

### Kernel Space — IMMUTABLE

These files can ONLY be modified by a human with KERNEL OVERRIDE AUTHORIZED:

| File | Why It's Protected |
|---|---|
| `BOOT.md` | Core identity and boot protocol — changing this changes everything |
| `manifest.json` | Project identity — only `boot_count`, `last_boot`, `tech_stack` auto-update |
| `kernel/integrity.md` | Self-verification — modifying this could mask corruption |
| `rules/ultimate_rules.md` | Core governance — self-modification creates circular authority |
| `rules/security_policy.md` | Security posture — agent modifying security = fox guarding henhouse |
| `rules/evolution_policy.md` | This file — modifying evolution rules from within = infinite loop |
| `genome/archetypes/*.json` | Governance profiles — pre-defined calibration points |

**Exception**: The following manifest fields ARE auto-updatable:
- `boot_count` (incremented each boot)
- `last_boot` (timestamp updated each boot)
- `tech_stack` (updated by perception scan)
- `evolution_history` (updated by evolution skill)

### User Space — EVOLVABLE

| Target | Create | Update | Delete | Approval Required |
|---|---|---|---|---|
| New skill (`.sk/`) | ✅ | ✅ | ✅ | Auto (log only) |
| `security.sk` | ❌ | ⚠️ | ❌ | Human review ALWAYS |
| `registry/index.json` | — | ✅ | — | Auto (mirrors disk state) |
| `commands/index.json` | — | ✅ | — | Auto (mirrors disk state) |
| `commands/aliases.json` | — | ✅ | — | Auto (log only) |
| Memory files (all) | ✅ | ✅ | ✅ | Auto |
| `project_genome.json` | — | ✅ | — | Auto (perception scan output) |
| `progress.md` | — | ✅ | — | Auto |

---

## Evolution Lifecycle (PDCA)

### 1. PLAN — Proposal

Every evolution begins with a documented proposal:

```markdown
## Evolution Proposal: EP-{sequential_number}
- **Date**: {ISO 8601 timestamp}
- **Type**: {skill_create | skill_update | command_create | command_update | memory_update | workflow_optimization}
- **Target**: {file or skill affected}
- **What**: {description of the change}
- **Why**: {rationale — what's better about the new approach}
- **Risk**: {low | medium | high}
- **Rollback Plan**: {how to undo this change}
- **Rules Check**: {list any rules this change touches — confirm no violations}
- **Status**: PROPOSED | APPROVED | APPLIED | ROLLED_BACK | REJECTED
```

### 2. DO — Apply

- **Low risk, non-security**: Apply immediately, log in `decisions.jsonl`.
- **Medium risk**: Present proposal to user, apply after acknowledgment.
- **High risk or security-related**: Present proposal, wait for explicit "approved" or "proceed".
- **Kernel space**: Refuse. Inform user that KERNEL OVERRIDE is required.

### 3. CHECK — Verify

After applying any evolution:
1. Run integrity check (verify all files parse correctly).
2. Verify no rules are violated by the change.
3. If the evolution modified a skill: invoke the skill with a test command to verify it works.
4. If check fails → **immediate rollback** (see step 4).

### 4. ACT — Commit or Rollback

**If check passes**:
- Update `registry/index.json` (if skills changed)
- Update `commands/index.json` (if commands changed)
- Log in `memory/episodic/decisions.jsonl`:
  ```json
  {"timestamp": "...", "type": "evolution", "id": "EP-{n}", "status": "applied", "details": "..."}
  ```
- Update `progress.md` with outcome
- Increment `manifest.json.evolution_history.total_evolutions`

**If check fails**:
- Restore the previous version of the affected file(s)
- Log the failure:
  ```json
  {"timestamp": "...", "type": "evolution_failure", "id": "EP-{n}", "reason": "...", "rolled_back": true}
  ```
- Update proposal status to `ROLLED_BACK`
- Report failure to user with details

---

## Rollback Protocol

### Automatic Rollback
When an evolution fails verification:
1. The evolution skill preserves the pre-change file content before applying.
2. On failure, restore the preserved content.
3. Log the rollback event.
4. No manual intervention needed.

### Manual Rollback
When a user requests reverting a past evolution:
1. Look up the evolution ID in `decisions.jsonl`.
2. If the previous version is available → restore it.
3. If the previous version is NOT available → inform user, suggest manual fix.
4. Run integrity check after rollback.

---

## Rate Limiting Evolutions

To prevent runaway self-modification:
- **Maximum 5 evolutions per session** without explicit user acknowledgment.
- After 5 evolutions in a session, pause and summarize all changes made.
- The user may extend the limit: "continue evolving" resets the counter for the session.

---

## Forbidden Evolutions

The following changes are NEVER permitted, regardless of archetype or context:
1. Modifying the evolution policy itself (this file)
2. Removing or weakening security scan requirements
3. Increasing the agent's own permission boundaries
4. Disabling logging or audit trail
5. Removing or modifying existing rules
6. Bypassing human approval gates for a lower archetype level
