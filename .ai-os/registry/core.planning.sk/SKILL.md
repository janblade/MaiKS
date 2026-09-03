---
name: planning
description: >-
  Per-feature brainstorm -> write-plan -> execute cycle for work inside an
  existing project. Clarifies scope through small rounds of questions, writes
  an implementation plan concrete enough to execute without re-deriving
  intent, then works it step by step with verification at each step.
---

# Planning — Brainstorm, Write, Execute

## Overview

`core.architect.sk` handles the greenfield case: an idea with no project yet, interviewed
and scaffolded once at genesis. This skill handles the far more common case — a feature or
fix requested *inside* an existing project — with the same discipline (clarify before
designing, write the plan down, don't wing execution) applied per task instead of once per
project. The two skills don't overlap: architect.sk triggers when there's no project;
this skill triggers on ordinary feature/bugfix requests within one that already exists.

Not every request needs this. A granular action (fix a typo, rename a variable, answer a
question) doesn't match anything here — use normal tools directly, same rule `BOOT.md` §4
already states for command matching in general. This skill is for units of work substantial
enough that skipping straight to code risks building the wrong thing or losing track of
steps partway through.

## Dependencies

- `core.observability.sk` — decision logging for plan approval and step completion
- `core.testing.sk` — TDD discipline governs how each execution step gets verified
- `core.self-healing.sk` — Verification-Before-Completion Protocol gates each step and the
  final report

## Commands

### PLAN_BRAINSTORM

Clarify a feature's scope before any design or code.

```
> OS_COMMAND PLAN_BRAINSTORM --feature="<description in plain language>"
```

**Procedure:**
1. Restate understanding in one sentence: "Here's what I think you're asking for: [...].
   Is that right?"
2. Ask 2-3 clarifying questions per round, not all at once — acceptance criteria, edge
   cases, what's explicitly out of scope, how it should fail.
3. Check the active task file (`memory/tasks/*.md`) for constraints or conventions already
   established this task before asking — don't re-ask what's already known.
4. Completion criteria — move to `PLAN_WRITE` when you can state: what the feature does in
   one sentence, its acceptance criteria, and what's explicitly excluded.
5. Write the outcome to the active task file's working notes (task memory, per `BOOT.md`
   §9's routing rule — never straight to semantic memory).

---

### PLAN_WRITE

Turn a clarified feature into a concrete, ordered implementation plan.

```
> OS_COMMAND PLAN_WRITE [--feature="<description>"]
```

**Procedure:**
1. If the request is non-trivial and `PLAN_BRAINSTORM` hasn't run this task yet, run it
   first (or ask the user if they'd rather skip straight to planning).
2. Break the work into discrete, ordered steps. Each step must be concrete enough that a
   literal-minded executor doesn't need to re-derive intent — name specific files/functions
   where already known, not just "update the backend."
3. For each step that changes behavior, note how it gets verified (which test, which
   manual check) — ties directly into `core.testing.sk`'s TDD discipline: a step that adds
   behavior should name the test that proves it, written before the implementation.
4. Present the full plan to the user. Wait for approval before `PLAN_EXECUTE` starts —
   same "present, wait for approval" pattern as `core.architect.sk`'s Phase 2/3.
5. Write the approved plan to its own file: `memory/plans/<YYYY-MM-DD>-<slug>.md`, where
   `<slug>` is a short kebab-case name from the feature (`add-pkce-flow`, not the whole
   sentence) and `<YYYY-MM-DD>` is today. Structure:

   ```markdown
   # Plan: <one-line title>
   - Branch: <sanitized branch name, or "none">
   - Created: <YYYY-MM-DD>
   - Status: approved          # draft | approved | in-progress | done | abandoned
   - Task file: memory/tasks/<name>.md

   ## Context
   <the one-paragraph PLAN_BRAINSTORM outcome — what it does, acceptance criteria,
   what's explicitly out of scope>

   ## Steps
   1. [ ] <step> — verify: <the test or check from procedure step 3>
   2. [ ] ...
   ```

   This file is the single source of truth for both the plan and its execution progress.
   In the active task file, write only a one-line pointer:
   `Active plan: memory/plans/<file>.md (approved, 0/<N>)` — never a second copy of the
   step list. Plans are not gitignored; they're shared project artifacts like the task
   file itself.

---

### PLAN_EXECUTE

Work an approved plan step by step.

```
> OS_COMMAND PLAN_EXECUTE [--plan=<plan_file>]
```

**Procedure:**
1. Load the plan file — the one named by the active task file's `Active plan:` pointer,
   or the path given in `--plan`. Set its `Status:` to `in-progress`.
2. Execute one step at a time. After each step, run its verification (per `PLAN_WRITE`
   step 3 and `core.self-healing.sk`'s Verification-Before-Completion Protocol) before
   moving to the next — don't batch verification to the end.
3. Check off each step (`[ ]` → `[x]`) in the plan file as it completes, and update the
   task file's `Active plan:` pointer count (`.../my-plan.md (in-progress, 3/7)`) — so
   progress survives a session break from either file.
4. A step turns out wrong, blocked, or reveals the plan itself was mistaken → stop, don't
   silently improvise past it. Surface it to the user rather than guessing (R24: confirm
   before applying a fix when confidence is below High).
5. All steps done → set the plan file's `Status:` to `done`, then report completion
   through the Verification-Before-Completion Protocol, not a bare "done." The plan file
   stays in `memory/plans/` as a dated record — `TASK_CLOSE`/`MEMORY_CONSOLIDATE` handle
   its eventual pruning (`core.memory.sk`), not this command.

---

## Common Mistakes

1. **Skipping brainstorm on a "small" feature** — scope that turns out to have a hidden
   edge case is the exact failure mode `PLAN_BRAINSTORM` exists to catch before code is
   written, not after.
2. **Writing a plan too vague to execute** — "improve the auth flow" is not a step; "add
   rate-limiting to `POST /login`, capped at 5/min per IP, test: 6th request in a minute
   returns 429" is.
3. **Marking a step done without verifying it** — defeats the point of splitting execution
   into steps in the first place; see `core.self-healing.sk`'s Verification-Before-
   Completion Protocol.
