# 🔄 AI OS Migrations & Deprecations

This file tracks features, files, or skills that have been deprecated or removed in newer versions of MaiKS.
The Agentic Updater (`UPDATE_PROMPT.md`) reads this file during upgrades to safely prune obsolete framework files without destroying the user's custom skills.

## v2.7.0 — Session-Scoped Kernel Override

- **`R3` in `rules/ultimate_rules.md` gained a session-scoped bypass form**: alongside the
  existing per-action `KERNEL OVERRIDE AUTHORIZED: {files}`, a human can now grant
  `KERNEL OVERRIDE AUTHORIZED FOR SESSION: {scope}` — a standing grant for the rest of the
  session instead of re-authorizing every individual kernel edit. `{scope}` must be
  explicit (a file/glob list, or an explicitly-typed `*`) — never defaults to `*` on a bare
  invocation. Expires at 5 kernel edits under one grant (mirrors this file's own
  5-evolutions-per-conversation rate limit) or at session end (`WRAP`), whichever comes
  first; never carries into a new session.
- **New ephemeral file `.ai-os/memory/episodic/session_override.json`**: records the
  active grant (`scope`, `granted_ts`, `session_id`) read from disk, not from conversation
  memory — a `SessionStart`/compact-triggered re-read (see v2.6.0's Claude Code hook,
  EP-40 in `progress.md`) can't be relied on to preserve a grant claim made earlier in a
  paraphrased-away part of the transcript, so the check has to hit durable state instead.
  The grant itself gets one `decisions.jsonl` entry; every kernel edit made under it still
  logs its own entry per R13, unaffected.
- **`BOOT.md` §1 and §3, `rules/evolution_policy.md`'s Kernel Space section and DO step**
  updated to reference both override forms.
- **`INSTALL_PROMPT.md` Step 5**: added `session_override.json` to the ephemeral
  `.gitignore` block (per-machine/per-session state, same tier as `last_session.json`).
- Migration action: none for existing kernel content — `rules/ultimate_rules.md`,
  `BOOT.md`, and `evolution_policy.md` changes are covered by the standard overwrite in
  Step 3 (itself gated by this version's `KERNEL OVERRIDE`); `session_override.json` is
  created on demand on first use, nothing to seed. Existing installs pick up the
  `.gitignore` entry via `UPDATE_PROMPT.md` Step 5's existing generic gitignore-refresh
  check (already re-reads `INSTALL_PROMPT.md` Step 5's current list, no separate migration
  needed).

## v2.6.0 — Honesty Over Approval

- **New `R25` in `rules/ultimate_rules.md`** (Domain 11, BLOCKING, no archetype override):
  optimize for accuracy, not for the response the user wants to hear. A technically-true
  answer shaded toward flattery — emphasizing positives, omitting real weaknesses,
  softening a blunt conclusion, burying disagreement under caveats — violates this even
  with zero false claims. Extends R21 (claim verification) to emphasis/framing, not just
  factual accuracy.
- **`core.self-healing.sk`'s Response Credibility Protocol** gained a 7th checklist item,
  "Sycophancy Resistance," operationalizing R25 as something actually applied before each
  substantive response, not just a rule sitting in a reference file.
- **`BOOT.md` §3 digest table** updated with R25.
- Migration action: none — `rules/ultimate_rules.md`, `BOOT.md`, and
  `registry/core.self-healing.sk/SKILL.md` content changes, covered by the standard
  overwrite/merge in Step 3.

## v2.5.0 — AI-First Kernel Authoring, Evolution-Policy Fixes

- **`BOOT.md` and `rules/ultimate_rules.md` rewritten in dense, AI-first style**: fragments,
  arrows, pipe-lists instead of full connective prose — these files' actual readers are AI
  agents, not humans, so the tradeoff shifted from readability to unambiguous parsing +
  token cost. `ultimate_rules.md` dropped ~45% in word count across two compaction passes,
  `BOOT.md` ~29%. No rule/section numbering or behavior changed — verified programmatically
  (all 24 rule IDs, all 11 `BOOT.md` sections, every command/file cross-reference, the exact
  user-facing quoted conflict message all survived).
- **New standing rule in `rules/evolution_policy.md`**: future kernel-space content
  (`BOOT.md`, `rules/*.md`) is authored in this compact style from the start, not written
  readable-first and compacted in a later pass.
- **Fixed two real bugs found while adding that rule**: `evolution_policy.md`'s decision-log
  examples still showed the pre-EP-20 schema (`timestamp`/`id`/`status`/`details`) instead of
  the unified `{"ts","type","what","why","files"?}` shape — missed when EP-20 unified the
  schema everywhere else. And its "Forbidden Evolutions" #1 said modifying the file itself is
  "NEVER permitted, regardless of archetype or context," directly contradicting the same
  file's own Evolution Boundaries table three sections above, which says kernel files
  (including this one) CAN be modified with `KERNEL OVERRIDE AUTHORIZED`. Fixed both
  "modifying rules"/"modifying this file" items to explicitly require the override rather
  than reading as an absolute, no-exception ban.
- Migration action: none — `rules/*.md` and `BOOT.md` content changes, covered by the
  standard overwrite in Step 3 (gated by the v2.2.0 `KERNEL OVERRIDE` check).

## v2.4.0 — Blast-Radius and Root-Cause Rules

- **New `R23` (Blast-Radius Assessment for Wide-Reaching Changes)** and **`R24` (Root Cause
  Before Fix)** added to `rules/ultimate_rules.md` Domain 11. R23 extends R7's "assess risk
  before destructive ops" concept to non-destructive but widely-reaching changes (a shared
  utility, a schema field, an API contract) — use `INFRA_MAP_DATAFLOW` when the change traces
  to a specific field/entity, otherwise enumerate call sites manually, before scoping the
  implementation. R24 formalizes the debugging discipline already described operationally in
  `BOOT.md` §7 (diff-driven debugging, memory-traced debugging) as a rule: identify root
  cause before calling a fix done, log cause + affected scope together, verify against the
  actual blast radius (`TEST_IMPACT`) rather than guessing test scope.
- **`BOOT.md` §3's Rules Digest table updated**: R23 folded into the existing R7 digest row
  (same severity pattern), R24 folded into the existing advisory-rules row.
- **Project-Specific Addendum note fixed**: was still referencing "R1–R19" as the rules
  user-defined additions must not conflict with — already stale before this release (R20–22
  existed), now corrected to "R1–R24."
- Migration action: none — this is a `rules/ultimate_rules.md` and `BOOT.md` content change,
  covered by the standard overwrite in Step 3 (itself gated by the v2.2.0 `KERNEL OVERRIDE`
  check, so a user's own project-specific rule additions in the addendum section are safe).

## v2.3.0 — Retrospective Memory Amendment

- **New `MEMORY_AMEND` command** on `core.memory.sk`: corrects or retracts an existing
  `knowledge/*.md` entry that turned out to be wrong, or that was accurate but caused a bug
  when followed. `TASK_CLOSE`/`MEMORY_CONSOLIDATE` only ever add to semantic memory or
  delete something a *new* fact supersedes — neither one revisits an existing entry just
  because it was later found to be wrong, so a bad promotion previously had no path back to
  being corrected short of someone noticing it during an unrelated pass. Outcomes: correct
  in place (stale fact), relocate to `known_gotchas.md` (true but harmful advice — keep the
  lesson, discard the recommendation), or remove outright (diff-before-delete, same as the
  Forgetting Policy). Same archetype-scaled accept gate as any other semantic-memory write.
- **`BOOT.md` §7 (Self-Healing)** gained a "memory-traced debugging" bullet: when a bug's
  root cause traces back to a `knowledge/*.md` entry, run `MEMORY_AMEND` too, not just the
  code fix — the entry is still trusted ground truth for every other session and developer
  until it's corrected. `BOOT.md` §4 gained a matching natural-language routing callout
  ("that doc is wrong," "this caused the bug") so the match isn't missed the way the
  data-flow impact-analysis phrasing was in v2.2.0.
- Migration action: none — new command content, covered by the standard `registry/`/
  `commands/` merge in Step 3. The two `BOOT.md` additions are covered by the standard
  overwrite, now itself protected by v2.2.0's `KERNEL OVERRIDE` check.

## v2.2.0 — Task Memory on Every Branch, Lightweight WRAP, Data-Flow Tracing

- **Task memory now created on every branch, no exceptions except detached `HEAD`**:
  `main`/`master`/`develop`/`release/*` previously skipped task-file creation entirely and
  implicitly allowed writing straight to `project_knowledge.md` — that contradicted the
  verify/accept promotion gate enforced everywhere else. Protected branches now get a
  *rolling* task file, drained by `MEMORY_CONSOLIDATE`'s verify/accept gate instead of
  archived by `TASK_CLOSE`. A branchless workspace (detached `HEAD`, no git identity) checks
  for an existing open task first, and **always asks** the user what to call one if none
  exists — no silent skip, no invented name. Migration action: none for existing task files
  (they're still valid); going forward, expect a task file to exist even on protected
  branches, and see the corrected orphan-sweep exception in the v2.1.0 section below — ad-hoc
  named files are not orphans just because they lack a branch match.
- **New lightweight `WRAP` built-in**: session-summary write only (no promotion, no task/
  semantic memory writes) — added because the `wrap` alias previously pointed straight at
  `MEMORY_CONSOLIDATE`, meaning "let's take a break" could silently trigger full memory
  promotion. Migration action: `commands/index.json`'s new `WRAP` entry is covered by the
  standard Step 3 copy. **Force-correct `commands/aliases.json`'s `wrap` key specifically**
  even though that file is otherwise a preserve-the-user's-customizations merge target: if
  the user's existing value is `"MEMORY_CONSOLIDATE"` or the older broken
  `"LOG_DECISION && MEMORY_CONSOLIDATE"` chain, overwrite it to `"WRAP"` — this one key is a
  bug fix, not a customization worth preserving.
- **New `INFRA_MAP_DATAFLOW` command** (alias `trace`) on `core.infra.sk`: on-demand data-flow
  tracing (input field to every DB/API/queue/file/cache/email sink it reaches, or backward
  from a sink to its inputs) for bug triage and change-impact analysis. Migration action:
  none — new command content, covered by the standard `registry/`/`commands/` merge in Step 3.
- Bumped `ai_os_version` to `2.2.0` — the prior three evolutions (EP-28/29/30/31) shipped
  without a version bump, which meant `UPDATE_PROMPT.md` Step 4's old-vs-new version compare
  saw no newer sections to walk and skipped all of the above during upgrades. That's the
  actual root cause of an orphan-sweep bug a user hit testing the updater: without a version
  bump, the migration walk never reached the ad-hoc-exception fix above at all.

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
  rather than waiting for the next `MEMORY_CONSOLIDATE`. **A task file with no matching
  branch is not automatically an orphan** — as of v2.2.0, ad-hoc task files (opened when
  there's no git identity, named after what the user called the task rather than a branch)
  are expected to have no branch match by design. Only move a file to `archived_tasks/` if
  it has no matching branch *and* shows no sign of being an active ad-hoc task (recently
  modified, or referenced in recent `sessions.jsonl` entries) — when in doubt, leave it for
  the next `MEMORY_CONSOLIDATE` to judge rather than archiving it during an upgrade on a
  branch-match check alone.
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


