---
name: self-evolution
description: >-
  PDCA-based self-improvement lifecycle for the AI OS. Proposes, applies, verifies,
  and rolls back system evolutions. Manages skill creation, command updates, and
  workflow optimizations within the boundaries defined by evolution_policy.md.
---

# Self-Evolution Engine

## Overview

The evolution skill is the meta-skill — it enables the AI OS to improve itself.
Every self-modification flows through this skill, ensuring changes are proposed,
reviewed, verified, and logged according to the PDCA cycle.

## Dependencies

- `observability.sk` — Required for decision logging and audit trail

## Commands

### EVOLVE_PROPOSE

Propose a system evolution.

```
> OS_COMMAND EVOLVE_PROPOSE --type=<type> --target=<target> --description=<desc>
```

**Types:** `skill_create`, `skill_update`, `command_create`, `command_update`, `workflow_optimization`, `memory_update`

**Procedure:**
1. Generate a unique evolution ID: `EP-{sequential_number}`
2. Validate the proposal:
   - Is the target in user space? (Kernel space → reject immediately)
   - Is `security.sk` being modified? (→ flag as requiring human approval)
   - Does the change violate any rules? (→ cross-reference `ultimate_rules.md`)
3. Assess risk level:
   - `low`: Memory updates, alias additions, non-critical workflow changes
   - `medium`: New skills, command updates, workflow structural changes
   - `high`: Security-adjacent changes, changes affecting multiple skills
4. Write proposal to `progress.md`:
   ```markdown
   ## Evolution Proposal: EP-{n}
   - **Date**: {timestamp}
   - **Type**: {type}
   - **Target**: {target}
   - **What**: {description}
   - **Why**: {rationale}
   - **Risk**: {level}
   - **Rollback Plan**: {how to undo}
   - **Rules Check**: {confirmed no violations}
   - **Status**: PROPOSED
   ```
5. If low-risk and non-security → proceed to EVOLVE_APPLY automatically
6. If medium/high-risk → present to user and wait for approval

---

### EVOLVE_APPLY

Apply an approved evolution.

```
> OS_COMMAND EVOLVE_APPLY --id=<EP-n>
```

**Procedure:**
1. Look up proposal by ID in `progress.md`
2. Verify status is PROPOSED or explicitly approved by user
3. **Preserve**: Save current state of affected files (for rollback)
4. **Apply**: Execute the evolution:
   - For `skill_create`: Create new `.sk/` directory with SKILL.md, update `registry/index.json`
   - For `skill_update`: Modify the target SKILL.md
   - For `command_create`/`command_update`: Update `commands/index.json`
   - For `workflow_optimization`: Update `memory/procedural/workflows.json`
   - For `memory_update`: Update target memory file
5. **Verify**: Run integrity check:
   - All affected files parse correctly
   - `registry/index.json` is consistent with disk
   - No rules are violated
   - If skill was modified: dry-test the skill
6. **If verification passes**:
   - Update proposal status to APPLIED
   - Log in `decisions.jsonl`
   - If the evolution was structural or architectural, update `memory/semantic/project_knowledge.md` to reflect the new system behavior
   - Increment `manifest.json.evolution_history.total_evolutions`
   - Update `manifest.json.evolution_history.last_evolution`
7. **If verification fails**:
   - Restore preserved files
   - Update proposal status to ROLLED_BACK
   - Log failure in `decisions.jsonl`
   - Report to user

---

### EVOLVE_ROLLBACK

Revert a previously applied evolution.

```
> OS_COMMAND EVOLVE_ROLLBACK --id=<EP-n>
```

**Procedure:**
1. Look up evolution by ID — must have status APPLIED
2. Restore preserved pre-evolution state
3. Run integrity check
4. Update status to ROLLED_BACK
5. Log rollback in `decisions.jsonl`
6. Report result

---

### EVOLVE_STATUS

Show evolution history and pending proposals.

```
> OS_COMMAND EVOLVE_STATUS [--filter=proposed|applied|rolled_back|all]
```

**Procedure:**
1. Read `progress.md` for pending proposals
2. Read `decisions.jsonl` for evolution history
3. Display summary table: ID, Date, Type, Target, Status, Risk
4. Show statistics: total evolutions, success rate, last evolution

---

### EVOLVE_DIFF

Show the diff of a specific evolution.

```
> OS_COMMAND EVOLVE_DIFF --id=<EP-n>
```

**Procedure:**
1. Look up evolution by ID
2. If preserved state exists: show diff between before/after
3. If no preserved state: show current content with annotation

---

### EVOLVE_BENCHMARK

Compare this framework against leading AI agent frameworks/practices; write genuine
capability gaps as new PROPOSED evolutions. On-demand only — invoked explicitly, never
run as part of `BOOT.md` §2. A boot-time competitive-research step would break the
"cheap by design" boot path every other step in §2 follows; this command exists precisely
so that cost is paid only when asked for.

```
> OS_COMMAND EVOLVE_BENCHMARK [--focus=<area>]
```

**Procedure:**
1. Read this framework's actual current state fresh — `registry/index.json`,
   `commands/index.json`, `rules/ultimate_rules.md`, `BOOT.md` — don't rely on
   recollection of a past read (R21).
2. Research comparison frameworks/practices. `WebSearch`/`WebFetch` available → use them,
   prefer sources with visible dates. Not available → rely on internal knowledge only, and
   label every finding as knowledge-cutoff-bounded, not verified current state — never
   present it as fact (R21).
3. Filter to genuine gaps:
   - Capability exists elsewhere, doesn't exist here.
   - Not a deliberate tradeoff this framework already reasoned through — check
     `progress.md`'s past EPs first; a gap already considered and rejected isn't
     re-proposed without new information (R8, e.g. don't re-propose "always show
     chain-of-thought" against `BOOT.md` §11's host-gated reasoning decision).
4. Each surviving gap → write a new `EP-{n}` to `progress.md` using `EVOLVE_PROPOSE`'s
   template, Status `PROPOSED`. Never auto-apply regardless of assessed risk level — an
   externally-sourced proposal always waits for explicit review, unlike an
   internally-verified low-risk change.
5. Report to the user: what was checked, what gaps were found (with confidence label per
   finding), what was excluded as already-considered.
6. Counts toward the standard 5-evolutions-per-conversation rate limit like any other
   batch of proposals.

---

## Stack Drift & Gap Resolution Protocol

When a `stack-drift` event is flagged during Boot Phase 3:
1. **Analyze Gaps**: Compare new technologies in the `tech_stack` with current capabilities in `registry/index.json` and `commands/index.json`.
2. **Draft Proposal**:
   - If a new language is added: propose adapting or adding testing and formatting commands.
   - If a new framework is added: propose scaffold templates or playbooks.
3. **Execute EPs**:
   - If archetype is `hobby` or `startup`: auto-scaffold skill adjustments (e.g. adding a test suite subcommand or pattern template for the new language).
   - If `enterprise` or `critical`: present the EPs to the user for review.
4. **Log Results**: Log the gap and resolution in `decisions.jsonl` and update `progress.md`.

## Rate Limiting

Per `evolution_policy.md`:
- Maximum **5 evolutions per session** without explicit user acknowledgment
- Track evolution count in session state
- After limit: pause and summarize all changes, wait for user to continue

## Common Mistakes

1. **Evolving without proposing** — Always create a proposal first, even for small changes.
2. **Not preserving state** — Always save the pre-evolution state for rollback capability.
3. **Batch evolving** — Apply evolutions one at a time. Verify each before the next.
