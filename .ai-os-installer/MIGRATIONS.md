# 🔄 AI OS Migrations & Deprecations

This file tracks features, files, or skills that have been deprecated or removed in newer versions of GoliathOS.
The Agentic Updater (`UPDATE_PROMPT.md`) reads this file during upgrades to safely prune obsolete framework files without destroying the user's custom skills.

## v2.1.1 — Verified-Acceptance Gate for Memory Promotion

- **`core.memory.sk` TASK_CLOSE step 2 split into 2 + 2a**: step 2 (unchanged) verifies a
  candidate truth is factually accurate against the current repo state; new step 2a checks
  it was actually *accepted* — scans the task file for unresolved-problem markers
  (`TODO`/`FIXME`/`BUG`/`WIP`/etc.) near the claim, and gates the write on human
  confirmation scaled by archetype (reuses R15's existing override table: `hobby` promotes
  directly, `startup`+ requires explicit sign-off before writing to semantic memory).
- **Why**: a claim can be 100% factually accurate (the buggy code really does exist and
  behave that way) while still being exactly the kind of thing that shouldn't become
  permanent project truth. Verifying facts and verifying acceptance are different checks;
  v2.1.0 only had the first one.
- **`R15` in `ultimate_rules.md`** gained one bullet: promoting a task-memory claim to
  semantic memory is now explicitly listed as functionally irreversible.
- Migration action: none — this is a rules/skill content change, covered by the standard
  `BOOT.md`/`rules/`/`registry/` overwrite in `UPDATE_PROMPT.md` Step 3.

## v2.1.0 — Memory Lifecycle Hardening

- **New skill**: `.ai-os/registry/core.memory.sk/` — backs `TASK_CLOSE`/`MEMORY_CONSOLIDATE`
  with a real procedure (verify-before-promote, diff-before-delete, dedup, branch-name
  sanitization, orphan sweep, archive pruning). Migration action: copy the skill folder in
  (covered by the `registry/` copy in `UPDATE_PROMPT.md` Step 3), register it in the user's
  `registry/index.json` and `manifest.json.installed_skills`, add its path to
  `kernel/integrity.md`'s required-paths list if the user has a customized copy of that file.
- **Task-memory filename sanitization**: `memory/tasks/[branch].md` now sanitizes slashes and
  other path-unsafe characters in the branch name (`feature/x` → `feature_x`) instead of
  creating nested paths, and detached-HEAD state no longer collides on a literal `tasks/HEAD.md`.
  Migration action: if the user has existing task files with unsanitized names (nested dirs
  under `tasks/`, or a `tasks/HEAD.md`), leave them — they're still valid working files, just
  rename going forward.
- **One-time orphan sweep recommended**: sweep `tasks/*.md` against `git branch -a` once
  during the upgrade (handled generically by `UPDATE_PROMPT.md` Step 4's migration walk)
  rather than waiting for the next `MEMORY_CONSOLIDATE`.
- **Installer purge scope widened**: `INSTALL_PROMPT.md` Step 3 now also purges
  `.ai-os/memory/tasks/*.md` and `.ai-os/memory/archived_tasks/*.md` (except `.keep`) on fresh
  installs — a stray framework-development task file was previously shipping into new installs.
  No migration action for existing users; this only affects the install flow.

## v2.0.0 — Boot Slimming & Log Schema Unification

- **BOOT.md restructured**: went from one ~25KB monolith to a ~7KB hot core (§1-§11 kept,
  but detail moved out) plus two new on-demand files. Migration action: overwrite the
  user's `BOOT.md` with the new version (Step 3 already does this); no memory content is
  affected, this is kernel space only.
- **New kernel file**: `.ai-os/kernel/bootstrap.md` (the First-Boot wizard, moved out of
  BOOT.md §10). Migration action: copy it in if missing (covered by the `kernel/` directory
  copy in `UPDATE_PROMPT.md` Step 3).
- **New episodic file**: `.ai-os/memory/episodic/last_session.json` — a single-entry session
  summary read at boot instead of scanning all of `sessions.jsonl`. Migration action: if
  missing, create it from the last entry in the user's existing `sessions.jsonl` (or an
  empty placeholder if `sessions.jsonl` is empty). Do not overwrite if it already exists.
- **Log schema unified**: `decisions.jsonl` entries now use one shape —
  `{"ts","type","what","why","files"?}` — replacing the four different shapes
  (`decision`/`rationale`/`confidence`/`alternatives_considered`/`outcome`/`references`,
  `action`/`reason`/`files_affected`/`reversible`/`session_id`, etc.) that had accumulated.
  Migration action: **do not rewrite the user's historical entries** — old-shape lines
  remain valid history. Only new entries written going forward use the new schema.
- **`registry/index.json` schema simplified**: removed the per-skill `circuit_breaker`,
  `failure_count`, `last_invoked` fields — nothing was reliably maintaining them, so
  `HEAL_CIRCUIT_STATUS` now derives skill health from `decisions.jsonl` on demand instead.
  Migration action: if the user's `registry/index.json` has custom skills with these
  fields, it's safe to leave them (extra keys are harmless) or strip them for consistency.
- **Rule R4 (persona prefix) demoted** from BLOCKING to ADVISORY, and R5/R16 (token/step
  limits) reframed from enforced counters to best-effort heuristics, since an agent cannot
  reliably self-instrument exact token or step counts. No file migration needed — this is
  a `rules/ultimate_rules.md` content change, covered by the Step 3 overwrite.

## v1.0.0
- **Four-Tier Memory Layout Migration**: 
  - Subdirectories added: `semantic/`, `episodic/`, `procedural/`, `tasks/`, `archived_tasks/`
  - Migration action: Move files from `.ai-os/memory/` root to subdirectories (see `UPDATE_PROMPT.md` Step 2).
  - Clean up: After verifying the files are successfully copied/moved to their respective subdirectories, delete the obsolete root-level files in `.ai-os/memory/` (specifically `project_knowledge.md`, `decisions.jsonl`, and `sessions.jsonl` if they remain in the root) to prevent duplicate context loading.
- **Indexed Semantic Knowledge Segregation**:
  - Subdirectory added: `.ai-os/memory/semantic/knowledge/`
  - Migration action: If the upgrading user has a monolithic `project_knowledge.md`, parse and segregate its sections into individual files (`architecture_overview.md`, `conventions_patterns.md`, `known_gotchas.md`, etc.) under `semantic/knowledge/`, then convert `project_knowledge.md` into the index document referencing those sub-files (see `UPDATE_PROMPT.md` Step 2).


