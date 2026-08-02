---
name: memory-lifecycle
description: >-
  Backs the built-in TASK_CLOSE and MEMORY_CONSOLIDATE commands with a real
  procedure. Governs the task -> archived -> semantic promotion pipeline:
  verifying claims before they become permanent, not silently dropping
  concurrent branches' work, deduplicating instead of accumulating, and
  sweeping up what falls through the cracks (orphaned task files, unbounded
  archives).
---

# Memory Lifecycle

## Overview

`TASK_CLOSE` and `MEMORY_CONSOLIDATE` are built-in commands (available even without this
skill installed — see `BOOT.md` §4), but without this skill their procedure is just a
couple of bullet points, which is thin enough to create real gaps: unverified claims
promoted to permanent memory, silent data loss when two branches touch semantic memory
concurrently, duplicate entries, and orphaned files nothing ever revisits. This skill is
where that procedure actually lives.

Neither command is this skill's concern when someone just wants to pause — that's `WRAP`
(session-summary write only, no promotion, not documented here because there's nothing to
verify or gate). Don't let "wrap up for the day" get routed to `MEMORY_CONSOLIDATE` — that
was a real bug (fixed) where the `wrap` alias pointed at full consolidation, meaning taking
a break could silently promote whatever happened to pass the accept gate at that moment.

The verify-before-promote / accept-gate / dedup discipline below isn't exclusive to these
two commands, either — it's the standard for *any* write into `project_knowledge.md` or
`knowledge/*.md`, wherever it originates. A skill command that derives a finding straight
from the codebase (e.g. `core.infra.sk`'s `INFRA_MAP_DATAFLOW`, which can resolve a custom
sink pattern worth remembering) follows the same steps 2/2a/4 here rather than writing
directly — a mechanically-derived fact still needs the accept gate, since the *distillation*
of what's worth keeping is a judgment call even when the underlying data is accurate.

## Dependencies

- `observability.sk` — decision logging

## Commands

### TASK_CLOSE

```
> OS_COMMAND TASK_CLOSE [branch-or-task-name]
```

Defaults to the current branch (`git rev-parse --abbrev-ref HEAD`), or the open ad-hoc task
name if there's no git identity (§2 step 4). If given explicitly and it does **not** match
the current branch/task, confirm with the user before touching that file — don't silently
archive a task that isn't the one you're on.

**Procedure:**
1. **Resolve the task file.** Derive the filename the same way it was created (see
   `BOOT.md` §2 step 4's sanitization rule): slashes and other path-unsafe characters in
   the branch name become `_`, so `feature/oauth-fix` → `tasks/feature_oauth-fix.md`, not
   a nested path. For an ad-hoc task (no git identity), use the name it was opened under.
2. **Verify facts before promoting.** For each candidate "confirmed truth" in the task
   file, re-check it against the actual current repo state (read the file, grep the
   symbol, run the check) before writing it to semantic memory — don't promote a claim
   from task notes just because it's written down. This is R21 applied at the
   highest-stakes point in the system: once something lands in `project_knowledge.md`,
   every future session on every branch treats it as ground truth without re-deriving it.
   **This alone is not enough** — a claim can be perfectly factually accurate and still
   describe a buggy, reverted, or not-yet-accepted design (step 2a).
2a. **Confirm the underlying work was actually accepted, not just closed.** "Factually
   verified" and "correct/accepted" are different things — a candidate truth can pass
   step 2 (the code it describes really exists) while still describing an approach that's
   broken or mid-revision:
   - **Scan for unresolved-problem markers** in the task file near each candidate truth
     (`TODO`, `FIXME`, `BUG`, `known issue`, `doesn't work`, `WIP`, `broken`, `revert`,
     case-insensitive). If present, don't promote that item — leave it in the task file.
   - **Gate on human sign-off, scaled by archetype (same table as R15)**: before writing,
     list the specific facts about to be promoted.
     - `hobby`: promote directly if step 2/2a pass, log for review.
     - `startup`/`enterprise`/`critical`: show the list to the user and get explicit
       confirmation before writing — do not treat "the task branch reached TASK_CLOSE" as
       itself sufficient sign-off. Prefer running `TASK_CLOSE` after the branch is actually
       merged (or the user explicitly says the task is done) over mid-task or on an
       abandoned experiment.
   - If a fact fails 2a but passed 2, it's real but not yet trustworthy framework-wide —
     leave it in the task file (or `archived_tasks/` when archiving) rather than promoting
     it as a stopgap; it can be promoted later once actually accepted.
3. **Diff before deleting.** If applying the Forgetting Policy (deleting something you
   believe is superseded) in `knowledge/*.md`: check `git log`/`git merge-base` for that
   file since this branch's fork point. If the entry you're about to delete was added
   *after* your fork point (i.e., by a different branch that merged first), don't delete
   it — you don't have full context on it. Flag the apparent conflict to the user instead.
4. **Dedup before appending.** Before adding a new entry to a `knowledge/*.md` sub-file,
   scan that file for an existing entry covering the same fact. If found, update it in
   place instead of appending a near-duplicate. Route to the sub-file whose *existing*
   domain it matches (`architecture_overview.md` / `conventions_patterns.md` /
   `known_gotchas.md`) — only create a new domain file if nothing existing fits, and
   register it in `project_knowledge.md`'s index when you do.
5. **Archive.** Move `tasks/[file].md` → `archived_tasks/[file].md`.
6. **Prune the archive.** If `archived_tasks/` now has more than ~20 files, or files
   clearly older than a few months of project history, fold the oldest ones into a single
   `archived_tasks/_summary.md` (one line each: date, branch, one-sentence outcome) and
   delete the originals. `archived_tasks/` is a record of *that something happened*, not a
   full-text archive that needs to grow forever — nothing else in the system reads
   individual archived files back.
7. **Log and report.** Append to `decisions.jsonl` (schema in `BOOT.md` §9), write the
   session summary per `BOOT.md` §9's wrap protocol.

---

### MEMORY_CONSOLIDATE

```
> OS_COMMAND MEMORY_CONSOLIDATE
```

Same verify/accept/diff/dedup rules as `TASK_CLOSE` steps 2, 2a, 3, 4 apply here when
extracting episodic decisions into semantic knowledge — a `decisions.jsonl` entry
describing a fix that was later reverted is just as promotable-by-mistake as a buggy task
note. Three additions specific to this command:

**Drain rolling task files on protected branches**: every branch has a task file (`BOOT.md`
§2 step 4 — main/master/develop/release included, there's no branch where working notes
skip straight to a permanent tier). Ticket branches close theirs explicitly via
`TASK_CLOSE`. Protected branches never get a "done" event, so their task file is treated as
*rolling*: on every `MEMORY_CONSOLIDATE`, run `TASK_CLOSE` steps 2/2a/3/4 against it, then
clear it back to empty (don't move it to `archived_tasks/` — it isn't a finished ticket,
it's ongoing scratch space that just got drained). If nothing in it passes the accept gate
yet, leave it as-is and don't force a promotion.

**Orphan sweep** (run every time this executes, cheap): list `tasks/*.md` and compare
against `git branch -a`. Any task file whose branch no longer exists locally or remotely is
orphaned — move it to `archived_tasks/` with a one-line note ("orphaned — branch deleted
without TASK_CLOSE") rather than leaving it to accumulate untouched. Ad-hoc task files (no
matching branch by design) aren't orphans by this check — match them against the sanitized
name they were opened under instead; only flag one as stale if it hasn't been touched in a
long time and no session has referenced it. Do not attempt to extract semantic truths from
an orphaned file automatically — an abandoned branch's working notes may describe a design
that was rejected, not confirmed; surface it to the user instead if it looks substantive.

**Episodic rotation**: after extracting lessons, move the processed `decisions.jsonl` lines
to `decisions.archive.jsonl` (per `BOOT.md` §9) rather than leaving them to accumulate.

## Why Task Memory Isn't Semantic Memory

Task memory is deliberately unscrutinized — the entire point of routing working notes
there instead of `project_knowledge.md` is so an agent can write down half-formed ideas,
dead ends, and in-progress reasoning without every line being held to the same bar as
permanent project truth. That means the *promotion* step (§TASK_CLOSE steps 2/2a) is the
only place that bar gets enforced. Skipping it — promoting everything in a task file
indiscriminately — defeats the reason the two tiers exist.

## Common Mistakes

1. **Treating task-memory closure as a formality.** Rubber-stamping everything in a task
   file into semantic memory is exactly how unverified, buggy, or rejected ideas become
   permanent "truths" that later sessions build on without question. Factually accurate
   (step 2) is not the same as accepted/correct (step 2a) — a description of a bug that's
   still in the code is a true statement and a terrible thing to promote.
2. **Deleting on a stale view.** Applying the Forgetting Policy without checking whether
   another branch added the thing you're about to delete.
3. **Letting archives grow forever.** `archived_tasks/` and `decisions.jsonl` both need an
   active pruning step, not just a place to write to.
4. **Assuming main/protected branches don't need task memory.** Trunk-based workflows and
   direct hotfixes are real; "no ticket branch" doesn't mean "no working notes," it means
   the notes need a rolling file that gets drained by `MEMORY_CONSOLIDATE` instead of an
   explicit `TASK_CLOSE`. Skipping task memory there and writing straight to
   `project_knowledge.md` is exactly the unverified-promotion failure mode this skill exists
   to prevent — it doesn't stop applying just because there's no branch name to point at.
