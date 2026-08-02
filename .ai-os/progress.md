## Evolution Proposal: EP-1 (Internal: EP-5)
- **Date**: 2026-07-22T09:26:00+08:00
- **Type**: memory_update
- **Target**: .agents/AGENTS.md
- **What**: Append a global customization rule that suppresses the IDE's built-in "Planning Mode" artifacts (`task.md`, `implementation_plan.md`, `walkthrough.md`) in favor of using the AI OS `.ai-os/memory/tasks/` memory system.
- **Why**: Currently, the IDE continuously overrides the AI OS BOOT rules by injecting an ephemeral message that forces the creation of non-persistent workspace artifacts. This causes memory fragmentation. By evolving `.agents/AGENTS.md` (which sits outside the AI OS kernel but governs the IDE's interaction), we can harmonize the IDE with the AI OS.
- **Risk**: Low
- **Rollback Plan**: Revert appended rule in .agents/AGENTS.md
- **Rules Check**: Complies with IDE Customizations framework and R3 (User Space is read-write within evolution policy constraints). Does not modify Kernel Space.
- **Status**: APPLIED

## Evolution Proposal: EP-6
- **Date**: 2026-07-22T09:28:13+08:00
- **Type**: command_update
- **Target**: .ai-os/commands/index.json
- **What**: Update the `TASK_CLOSE` command description to explicitly state that the task memory file must be MOVED via file system operations from `.ai-os/memory/tasks/` to `.ai-os/memory/archived_tasks/`.
- **Why**: The OS operator was attempting to close tasks without actually triggering a file move operation on the `.md` file, causing closed tasks to remain in the active directory and confusing the active task isolation logic. Explicitly mentioning "physically move the file" will ensure the AI OS executes the file move.
- **Risk**: Low
- **Rollback Plan**: Revert description in `commands/index.json`.
- **Rules Check**: Target is in user-space, no kernel files modified. Complies with rule R3.
- **Status**: APPLIED

## Evolution Proposal: EP-7
- **Date**: 2026-07-22T09:32:19+08:00
- **Type**: memory_update
- **Target**: .ai-os-installer/templates/
- **What**: Propagate the "Memory & Context" and "IDE Planning Mode Override" rules to all IDE configuration templates (`.windsurfrules`, `CLAUDE.md`, `copilot-instructions.md`, `cursor-rules.md`, `AGENTS.md`).
- **Why**: The templates used by the Agentic Installer to bootstrap new projects were out of sync with the live framework's evolved standards. This ensures future projects inherit the correct memory routines and IDE override directives automatically.
- **Risk**: Low
- **Rollback Plan**: Revert appended sections in template files.
- **Rules Check**: Complies with IDE Customizations framework and R3 (User space is read-write).
- **Status**: APPLIED

## Evolution Proposal: EP-8
- **Date**: 2026-07-22T09:39:25+08:00
- **Type**: memory_update
- **Target**: .ai-os/BOOT.md (KERNEL)
- **What**: Inject the "Deep-Thinking Protocol" into all agent instruction templates. This mandates that agents utilize a `<thinking>` block for constraint analysis, decomposition, hypothesis generation, and verification before outputting their final responses.
- **Why**: Modern fast LLMs benefit massively from forced Chain-of-Thought (CoT). User explicitly authorized a `KERNEL OVERRIDE` to make this a master directive for the entire framework rather than just an IDE template patch.
- **Risk**: High (Kernel space modification affecting all booted agents).
- **Rollback Plan**: Revert the addition in `.ai-os/BOOT.md §11`.
- **Rules Check**: KERNEL OVERRIDE AUTHORIZED by user.
- **Status**: APPLIED

## Evolution Proposal: EP-9
- **Date**: 2026-07-22T09:43:42+08:00
- **Type**: memory_update
- **Target**: .ai-os/BOOT.md (KERNEL)
- **What**: Added "Diff-Driven Debugging" protocol to BOOT.md §7.3.
- **Why**: Ensures agents inherently correlate newly discovered bugs with their latest `git diff` mutations instead of treating every bug as a deep systemic issue. 
- **Risk**: High (Kernel space modification affecting baseline debugging behavior).
- **Rollback Plan**: Revert the addition in `.ai-os/BOOT.md §7.3`.
- **Rules Check**: KERNEL OVERRIDE explicitly authorized by user.
- **Status**: APPLIED

## Evolution Proposal: EP-10
- **Date**: 2026-07-23T06:55:56+08:00
- **Type**: memory_update
- **Target**: .ai-os/memory/semantic/
- **What**: Split the monolithic `project_knowledge.md` file into an index file and separate topic-specific files under a new `.ai-os/memory/semantic/knowledge/` directory: `architecture_overview.md`, `conventions_patterns.md`, and `known_gotchas.md`.
- **Why**: When multiple developers or feature branch agents make concurrent semantic updates, a single monolithic `project_knowledge.md` causes frequent git merge conflicts. Indexing and splitting it into granular category files minimizes concurrent write collisions and reduces memory consolidation friction.
- **Risk**: Low
- **Rollback Plan**: Re-concatenate the sub-files back into a monolithic `.ai-os/memory/semantic/project_knowledge.md` and delete the `knowledge/` subdirectory.
- **Rules Check**: Target is in user space memory, which is fully evolvable. Complies with rule R3 and R9.
- **Status**: APPLIED

## Evolution Proposal: EP-11
- **Date**: 2026-07-23T07:04:14+08:00
- **Type**: memory_update
- **Target**: .ai-os/memory/semantic/knowledge/conventions_patterns.md
- **What**: Codify the "Indexed Semantic Memory Pattern" rule in `conventions_patterns.md`.
- **Why**: Formalizes the operational steps for creating new categories and updating the index in `project_knowledge.md`, ensuring future agents and developers conform to the indexed knowledge layout and avoid merge conflicts.
- **Risk**: Low
- **Rollback Plan**: Revert the rule entry in `conventions_patterns.md`.
- **Rules Check**: Modifying user-space conventions is fully authorized. Complies with rule R3 and R9.
- **Status**: APPLIED

## Evolution Proposal: EP-12
- **Date**: 2026-07-23T07:09:05+08:00
- **Type**: command_create
- **Target**: .ai-os/commands/index.json and .ai-os/registry/core.infra.sk/SKILL.md
- **What**: Create and register the `INFRA_ANALYZE_COMMITS` command (`OS_COMMAND INFRA_ANALYZE_COMMITS [--count=N] [--supersede-check]`).
- **Why**: Allows the AI OS to parse the last $N$ Git commits (`git log -n <N>`) to extract architectural decisions, conventions, and gotchas into `project_knowledge.md` (or topic sub-files under `knowledge/`). Incorporates temporal reconciliation to detect and mark superseded info when newer commits modify or revert older patterns.
- **Risk**: Medium
- **Rollback Plan**: Remove command definition from `commands/index.json` and `core.infra.sk/SKILL.md`.
- **Rules Check**: Target files are in user space. Complies with rules R3 and R9.
- **Status**: APPLIED

## Evolution Proposal: EP-13
- **Date**: 2026-07-23T07:32:07+08:00
- **Type**: command_update
- **Target**: .ai-os/commands/index.json and .ai-os/registry/core.infra.sk/SKILL.md
- **What**: Refactor `INFRA_ANALYZE_COMMITS` (and add alias `INFRA_ANALYZE_MERGES`) to target the last $N$ **merge commits** to the primary branch (`git log --first-parent main -n <N>` or `git log --merges -n <N>`) by default instead of raw individual commits.
- **Why**: Micro-commits contain WIP noise ("fix typo", "temp fix"), whereas merge commits and PR descriptions encapsulate high-level architectural decisions, feature increments, and breaking changes. Filtering for main branch merges provides a vastly cleaner signal for seeding `project_knowledge.md`.
- **Risk**: Medium
- **Rollback Plan**: Revert procedure in `core.infra.sk/SKILL.md` and parameters in `commands/index.json`.
- **Rules Check**: Target files are in user space. Complies with rules R3 and R9.
- **Status**: APPLIED

## Evolution Proposal: EP-14
- **Date**: 2026-07-23T07:35:10+08:00
- **Type**: command_update
- **Target**: .ai-os/commands/aliases.json
- **What**: Replace the `merges` alias with `absorb_history` (and `absorb`) in `commands/aliases.json`.
- **Why**: The `merges` shortcut was ambiguous and easily confused with native git commands. `absorb_history` clearly conveys the intentional action of reading git merge history and absorbing it into AI OS semantic memory.
- **Risk**: Low
- **Rollback Plan**: Revert key in `commands/aliases.json`.
- **Rules Check**: Target is user-space command alias file. Complies with rules R3 and R9.
- **Status**: APPLIED

## Evolution Proposal: EP-15
- **Date**: 2026-07-23T08:35:32+08:00
- **Type**: memory_update
- **Target**: .ai-os-installer/UPDATE_PROMPT.md and .ai-os-installer/MIGRATIONS.md
- **What**: Update the Agentic Updater (`UPDATE_PROMPT.md`) and Migration guide (`MIGRATIONS.md`) to execute automatic **Indexed Semantic Memory Segregation** during upgrades.
- **Why**: Currently, existing users updating to the latest framework retain a monolithic `project_knowledge.md`. Updating the Agentic Updater forces it to create `.ai-os/memory/semantic/knowledge/`, parse their existing monolithic file into section sub-files, and transform `project_knowledge.md` into the new index format without losing their project memory.
- **Risk**: Medium
- **Rollback Plan**: Revert steps in `.ai-os-installer/UPDATE_PROMPT.md` and `.ai-os-installer/MIGRATIONS.md`.
- **Rules Check**: Target files are in user space / installer templates. Complies with rules R3 and R9.
- **Status**: APPLIED

## Evolution Proposal: EP-16
- **Date**: 2026-07-23T08:37:34+08:00
- **Type**: installer_update
- **Target**: .ai-os-installer/INSTALL_PROMPT.md and .ai-os-installer/UPDATE_PROMPT.md
- **What**: Comprehensive installer & updater audit fixes:
  1. Fix `INSTALL_PROMPT.md` Step 3: Purge meta-memory using the new **Indexed Knowledge Base** structure (`knowledge/` sub-files + `project_knowledge.md` index file).
  2. Fix `INSTALL_PROMPT.md` Step 3: Correct manifest reset location (reset `manifest.json.project_name` to `""`, reset `manifest.json.tech_stack`, and reset `boot_count` to `0` so the First-Boot wizard in `BOOT.md` §10 is correctly triggered).
  3. Update `UPDATE_PROMPT.md` Step 3: Add explicit instructions to merge `commands/index.json` and `commands/aliases.json` without wiping user-defined custom aliases or commands.
- **Why**: Eliminates critical installer bugs where new installations were given an obsolete monolithic `project_knowledge.md` template, and where resetting `project_name` targeted the wrong file (`project_genome.json` instead of `manifest.json`).
- **Risk**: Medium
- **Rollback Plan**: Revert steps in `.ai-os-installer/INSTALL_PROMPT.md` and `.ai-os-installer/UPDATE_PROMPT.md`.
- **Rules Check**: Target files are installer prompts in user space. Complies with rules R3 and R9.
- **Status**: APPLIED

## Evolution Proposal: EP-17
- **Date**: 2026-07-23T08:41:38+08:00
- **Type**: memory_update
- **Target**: .ai-os/memory/semantic/knowledge/conventions_patterns.md
- **What**: Codify the "Installer & Updater Synchronization Gate" convention in `conventions_patterns.md`.
- **Why**: Ensures that whenever session memory is consolidated or wrapped (`wrap` / `MEMORY_CONSOLIDATE`), the operator verifies whether `.ai-os-installer/INSTALL_PROMPT.md`, `UPDATE_PROMPT.md`, and `MIGRATIONS.md` require updates to keep installer packages in sync with structural evolutions.
- **Risk**: Low
- **Rollback Plan**: Revert rule entry in `conventions_patterns.md`.
- **Rules Check**: Target file is in user space memory. Complies with rules R3 and R9.
- **Status**: APPLIED

## Evolution Proposal: EP-18
- **Date**: 2026-07-23T08:45:06+08:00
- **Type**: kernel_update
- **Target**: .ai-os/BOOT.md
- **What**: Upstream proven User Space evolutions into Kernel Space (`BOOT.md`):
  1. **BOOT.md §4 (Command Protocol)**: Add `INFRA_ANALYZE_COMMITS` to the core skill-backed command table.
  2. **BOOT.md §9 (Memory Management)**: Update Semantic Memory definitions to explicitly mandate the **Indexed Semantic Memory Pattern** (`semantic/knowledge/` sub-files + `project_knowledge.md` index file).
  3. **BOOT.md §11 (Behavioral Guidelines)**: Update "Always Do" and "Never Do" directives to reference indexed memory sub-files (`semantic/knowledge/*.md`).
- **Why**: Propagates proven memory layout improvements and command capabilities into the core OS Kernel specification so all future booted sessions and framework installations inherit them.
- **Risk**: High (Modifies Kernel Space specification file `BOOT.md`).
- **Rollback Plan**: Revert changes in `.ai-os/BOOT.md`.
- **Rules Check**: Target is Kernel Space file `BOOT.md`. Requires explicit KERNEL OVERRIDE approval per Rule R1.
- **Status**: APPLIED

## Evolution Proposal: EP-19
- **Date**: 2026-08-02T00:00:00+08:00
- **Type**: kernel_update
- **Target**: .ai-os/BOOT.md, .ai-os/kernel/bootstrap.md (new), .ai-os/kernel/integrity.md
- **What**: Restructured `BOOT.md` from a ~25KB monolith into a ~7KB hot core with pointers to detail loaded only on demand. Moved the First-Boot Wizard (old §10) to a new `kernel/bootstrap.md`, loaded only when `manifest.json.project_name` is empty. Replaced the boot-time full read of `rules/ultimate_rules.md` + `security_policy.md` + `evolution_policy.md` with a condensed Rules Digest table embedded directly in BOOT.md §3. Rewrote `kernel/integrity.md`'s required-path list to match the EP-10 indexed memory layout (it still listed the pre-EP-10 monolithic structure) and removed claims of a kernel integrity hash and live circuit-breaker verification that nothing in the framework actually computes.
- **Why**: A credibility review found the boot sequence cost ~16k tokens every session before any user work started, and `kernel/integrity.md` had drifted out of sync with the EP-10 memory restructure. Since BOOT.md itself references detail files by pointer instead of inlining them, an agent only pays the token cost for the sections a given session actually needs.
- **Risk**: High (kernel space — `BOOT.md`, `kernel/integrity.md`).
- **Rollback Plan**: Restore prior `BOOT.md`/`kernel/integrity.md` from git history; delete `kernel/bootstrap.md`.
- **Rules Check**: Kernel space change, authorized directly by the project maintainer's explicit instruction to implement the reviewed action list on this repository.
- **Status**: APPLIED

## Evolution Proposal: EP-20
- **Date**: 2026-08-02T00:00:00+08:00
- **Type**: memory_update
- **Target**: .ai-os/registry/core.observability.sk/SKILL.md, .ai-os/memory/episodic/last_session.json (new), .ai-os/commands/index.json
- **What**: Unified `decisions.jsonl` to a single log schema (`{"ts","type","what","why","files"?}`), dropping `confidence`, `alternatives_considered`, `outcome`, `references`, and `session_id` fields that were never kept current in practice (confidence was always `1.0`, outcome always `pending`). Added `memory/episodic/last_session.json` — a single-entry session summary read at boot instead of scanning the full, ever-growing `sessions.jsonl`. Moved the session-log write from boot time (when there's nothing to report yet) to session wrap (`MEMORY_CONSOLIDATE`/`TASK_CLOSE`), which also now archives consolidated `decisions.jsonl` entries to `decisions.archive.jsonl` instead of letting the file grow unbounded.
- **Why**: A review of the actual `decisions.jsonl` history found four different entry shapes in use despite Rule R13 mandating one, and three of seven `sessions.jsonl` entries had `"ended": null` because nothing ever closes a session at boot time. The schema needed to match what an agent can actually keep consistent, and be cheap enough that every future read isn't paying for dead fields.
- **Risk**: Medium (touches the core logging skill; historical entries in `decisions.jsonl` are left untouched — only new entries use the new schema).
- **Rollback Plan**: Revert `core.observability.sk/SKILL.md`; delete `last_session.json`; new-schema entries in `decisions.jsonl` remain valid JSONL either way.
- **Rules Check**: Target files are user-space memory/skills. Complies with R3 and R9.
- **Status**: APPLIED

## Evolution Proposal: EP-21
- **Date**: 2026-08-02T00:00:00+08:00
- **Type**: kernel_update + memory_update + installer_update
- **Target**: .ai-os/rules/ultimate_rules.md, .ai-os/rules/security_policy.md, .ai-os/rules/evolution_policy.md, .ai-os/registry/core.self-healing.sk/SKILL.md, .ai-os/registry/core.context-engine.sk/SKILL.md, .ai-os/registry/index.json, .ai-os/commands/aliases.json, .ai-os-installer/templates/*, .agents/AGENTS.md, /AGENTS.md (new)
- **What**: Consistency and realism pass:
  1. Demoted R4 (persona-prefix-on-every-response) from BLOCKING to ADVISORY — it cost tokens on every message and was the rule most likely to silently drift on hosts with their own response conventions.
  2. Reframed R5 (token tracking) and R16 (step-count ceiling) from enforced counters to best-effort heuristics — an agent cannot reliably self-instrument exact token or step counts; that's host-owned accounting.
  3. Removed the per-skill `circuit_breaker`/`failure_count`/`last_invoked` fields from `registry/index.json` (unmaintained after 6+ boots) and rewrote `HEAL_CIRCUIT_STATUS` in `core.self-healing.sk` to derive skill health from recent `decisions.jsonl` entries instead of a phantom stored state — that command previously had no procedure documented at all.
  4. Softened `core.context-engine.sk`'s token-budget language to acknowledge the host manages the real context window on most agent platforms.
  5. Fixed three broken command aliases in `commands/aliases.json`: `fix` now matches its own documented example, `wrap` no longer chains a command requiring parameters an alias can't supply, `test` now runs tests instead of generating them.
  6. Fixed UTF-8 mojibake in `registry/index.json` (em-dashes mangled through cp1252) and absolute machine-specific `file:///d:/...` links in `project_knowledge.md` and the installer template, replacing both with plain relative paths.
  7. Hardened the bridge templates (`AGENTS.md`, `CLAUDE.md`, `cursor-rules.md`, `copilot-instructions.md`, `.windsurfrules`) with an inline "Minimum Contract" so weaker hosts get real governance value even if they never execute the full multi-file `BOOT.md` sequence. Added root-level `AGENTS.md` as an installer target (emerging cross-tool convention) and switched the Cursor installer step to `.cursor/rules/ai-os.mdc` with `alwaysApply: true` frontmatter, since a plain `.md` may not auto-attach in current Cursor versions.
- **Why**: A credibility review found the framework's own history was the evidence for these problems — 18 evolutions in, the circuit-breaker fields were still all-zero, three of four aliases were broken on first real use, and the bridge templates hadn't changed even though every weak-host gap they could hit was avoidable with a self-sufficient fallback block.
- **Risk**: Medium (rule-severity changes are kernel space; alias/registry/template fixes are user space).
- **Rollback Plan**: Revert each file individually from git history; changes are independent of one another.
- **Rules Check**: Kernel-space rule changes authorized directly by the project maintainer's explicit instruction to implement the reviewed action list. User-space changes comply with R3/R9 without override.
- **Status**: APPLIED

## Evolution Proposal: EP-22
- **Date**: 2026-08-02T00:00:00+08:00
- **Type**: kernel_update
- **Target**: .ai-os/rules/ultimate_rules.md, .ai-os/BOOT.md
- **What**: Second-pass rules review. Fixed: R1 SHOULD→MUST (matched its own BLOCKING label), R3 noted as self-restraint not a technical control (+ host-level pairing suggestion), R9 rollback tied to git instead of an undefined "preserved copy," R13's log schema updated to match the EP-20 unified format (was still showing the old one — my own miss), R17 gated CVE/crypto claims on actual tool availability. Added R20 (Git Safety — force-push/hard-reset/discard require confirmation), R21 (Claim Verification — don't assert unverified file/function state), R22 (Scope Discipline — no unrequested refactors). Synced BOOT.md §3 digest table to match.
- **Why**: User asked for a fresh review of `ultimate_rules.md` specifically; found R13 had drifted from my own EP-20 change, and R9/R17 made claims about mechanisms (rollback storage, CVE lookups) that don't exist. R20-22 close real gaps: no git-destructive-op rule existed despite that being the highest-blast-radius action an agent takes, and no explicit hallucination guard existed despite it being the most common agentic failure mode.
- **Risk**: Medium (kernel space — `ultimate_rules.md`, `BOOT.md`); additions are net-positive constraints, no capability removed.
- **Rollback Plan**: Revert both files from git history.
- **Rules Check**: Kernel-space change, authorized by direct maintainer instruction.
- **Status**: APPLIED

## Evolution Proposal: EP-23
- **Date**: 2026-08-02T00:00:00+08:00
- **Type**: skill_create + kernel_update + memory_update + installer_update
- **Target**: .ai-os/registry/core.memory.sk/SKILL.md (new), .ai-os/registry/index.json, .ai-os/manifest.json, .ai-os/kernel/integrity.md, .ai-os/commands/index.json, .ai-os/BOOT.md, .ai-os/rules/ultimate_rules.md, .ai-os/memory/semantic/knowledge/conventions_patterns.md, .ai-os/memory/tasks/EP-8-thinking-protocol.md (moved), .ai-os-installer/INSTALL_PROMPT.md, .ai-os-installer/UPDATE_PROMPT.md, .ai-os-installer/MIGRATIONS.md
- **What**: Hardened the task → archived → semantic memory pipeline, previously specified only as a few bullets with no dedicated procedure:
  1. New `core.memory.sk` skill backing `TASK_CLOSE`/`MEMORY_CONSOLIDATE`: verify-before-promote (ties to R21), diff-before-delete against `git merge-base` (prevents one branch silently deleting another's un-merged semantic additions), dedup-before-append, branch-name sanitization, orphan sweep (task files whose branch no longer exists), and `archived_tasks/` pruning (it was a write-only, unbounded sink — same class of problem already fixed for `decisions.jsonl`).
  2. R21 extended to explicitly cover promotion into semantic memory, not just claims made to the user.
  3. Fixed a live self-contradiction in `conventions_patterns.md`: a pre-EP-10 note claimed merge conflicts in `project_knowledge.md` were an intentional feature, directly contradicting EP-10's stated purpose of eliminating that conflict surface.
  4. Found and fixed a real leak: `memory/tasks/EP-8-thinking-protocol.md` was an orphaned framework-development task file with no corresponding branch, sitting in the repo and about to ship into every fresh install via `INSTALL_PROMPT.md` (which didn't purge `tasks/`/`archived_tasks/` at all). Archived it with a sweep note as the first real dogfood of the new protocol, and widened the installer purge step.
  5. Cascaded to the installer/updater: `INSTALL_PROMPT.md` now purges task memory on fresh installs; `UPDATE_PROMPT.md` registers the new skill and runs a one-time orphan sweep on upgrade; `MIGRATIONS.md` documents it all as v2.1.0.
- **Why**: User asked specifically whether there were loopholes in task→archived→semantic memory handling. Found that the promotion step had no verification gate (letting unverified or since-invalidated task notes become permanent cross-session "truth"), that the Forgetting Policy could cause one branch to silently destroy another's un-merged semantic knowledge, and that both `archived_tasks/` and orphaned task files had no lifecycle — plus a live example of exactly that problem sitting in this repo.
- **Risk**: Medium (new skill + kernel-space BOOT.md/rules changes + installer changes; task-file move is reversible via git).
- **Rollback Plan**: Delete `core.memory.sk/`, revert its registry/manifest/integrity entries, revert BOOT.md/ultimate_rules.md/conventions_patterns.md, restore the archived task file to `tasks/`, revert installer files.
- **Rules Check**: Kernel-space rule/BOOT.md changes authorized by direct maintainer instruction; skill/memory/installer changes comply with R3/R9 without override.
- **Status**: APPLIED

## Evolution Proposal: EP-24
- **Date**: 2026-08-02T00:00:00+08:00
- **Type**: kernel_update + memory_update
- **Target**: .ai-os/registry/core.memory.sk/SKILL.md, .ai-os/rules/ultimate_rules.md, .ai-os/BOOT.md, .ai-os-installer/MIGRATIONS.md
- **What**: Split `TASK_CLOSE`'s promotion check into step 2 (factual verification — does the claim match current repo state) and new step 2a (acceptance verification — was the underlying work actually accepted, not still buggy/WIP/unreviewed). 2a scans for unresolved-problem markers in the task file and gates the actual write on human confirmation scaled by archetype, reusing R15's existing override table rather than inventing a new one. R15 gained an explicit bullet naming semantic-memory promotion as functionally irreversible. Same gate applied to `MEMORY_CONSOLIDATE`'s episodic extraction. Logged as v2.1.1 in `MIGRATIONS.md`.
- **Why**: User pointed out that EP-23's "verify before promoting" only checked factual accuracy, not whether the described work was actually accepted — a task with buggy, reverted, or user-unapproved modifications could still get its (true) description of that bug promoted into permanent project memory. Factually-accurate and accepted-as-correct are different bars; only the first one existed.
- **Risk**: Low (tightens an existing gate; no new files, no layout change).
- **Rollback Plan**: Revert `core.memory.sk/SKILL.md` step 2a, revert the R15 bullet.
- **Rules Check**: Kernel-space `ultimate_rules.md`/`BOOT.md` changes authorized by direct maintainer instruction.
- **Status**: APPLIED

## Evolution Proposal: EP-25
- **Date**: 2026-08-02T00:00:00+08:00
- **Type**: installer_update
- **Target**: .ai-os-installer/INSTALL_PROMPT.md, .ai-os-installer/UPDATE_PROMPT.md, .ai-os-installer/MIGRATIONS.md, .ai-os/memory/semantic/knowledge/conventions_patterns.md
- **What**: Staleness audit of the installer/updater docs (and confirmed there are no actual executable scripts anywhere in the repo — installation is 100% agentic file edits, as documented). Found and fixed: (1) `INSTALL_PROMPT.md` purge step never reset `manifest.json.evolution_history`, so a fresh install would inherit GoliathOS's own evolution count; (2) its gitignore block was missing `last_session.json` (new in v2.0.0) and didn't clarify `decisions.archive.jsonl` should stay tracked; (3) `UPDATE_PROMPT.md` had a version-locked "Step 3.5 (v2.1.0+)" that would need a new hardcoded step every release — generalized into a Step 4 loop that walks every `MIGRATIONS.md` section newer than the user's pre-upgrade version and executes each one's migration action; (4) nothing explicitly told the updater to bump `manifest.json.ai_os_version` after merging — the one field that should be replaced wholesale, not merged; (5) a hardcoded `core.memory.sk`-specific example and a stale `v1.1` example path were generalized; (6) a dangling reference to the now-removed "Step 3.5" in `MIGRATIONS.md`'s v2.1.0 entry. Also documented (not "fixed") that this repo's own `.gitignore` intentionally does not follow the ephemeral-file advice it gives to installed projects, since `progress.md`/`decisions.jsonl` double as GoliathOS's own changelog.
- **Why**: User asked directly whether the installer/updater had gone stale relative to everything changed in EP-19 through EP-24, and whether any scripts existed. They hadn't been audited as a batch since EP-16/17; several of the newer memory-layer changes (last_session.json, core.memory.sk, evolution_history growth) had only been partially cascaded.
- **Risk**: Low (docs-only; no runtime behavior change for this repo, only for future installs/upgrades).
- **Rollback Plan**: Revert each file individually from git history.
- **Rules Check**: User-space installer docs and memory notes. Complies with R3/R9.
- **Status**: APPLIED

## Evolution Proposal: EP-26
- **Date**: 2026-08-02T00:00:00+08:00
- **Type**: kernel_update
- **Target**: .ai-os/BOOT.md
- **What**: Diagnosed why agents were observed visibly deliberating over tool/command selection before acting: (1) §11's Reasoning clause asked for visible "options considered" text on any "non-trivial" request whenever the host lacked native extended thinking — a condition true for a lot of real hosts (Cursor default model, Copilot, plain Windsurf), so it fired far more than intended; (2) nothing said when to use the ~40-command taxonomy vs. raw tools, so every task silently required a classification step first. Initially proposed removing command-first routing as part of the fix; the user corrected this — they want natural-language requests to match the closest existing command first (that's what keeps behavior consistent across agents/sessions, the framework's stated purpose), not fall back to raw tools by default. Revised fix: §4 now explicitly says to match plain-English requests against `commands/index.json`/`aliases.json` and use that command's procedure, but to do the match *silently* and commit — no "this could be X or Y" narration — falling back to raw tools only when nothing in the list actually fits (most granular actions). §11's Reasoning clause narrowed to fire only on requests that are actually ambiguous/high-stakes/architecturally significant, and explicitly excludes command/tool selection from what's worth deliberating about out loud.
- **Why**: Visible deliberation burns output tokens and time without improving outcomes — the underlying issue was never "should commands be preferred," it was "is the preference/matching step narrated." Conflating the two in the first draft would have undermined the framework's own consistency goal to fix a verbosity problem.
- **Risk**: Low (BOOT.md wording only, no structural change).
- **Rollback Plan**: Revert the two edited paragraphs in `BOOT.md` §4 and §11.
- **Rules Check**: Kernel-space change, authorized by direct maintainer instruction.
- **Status**: APPLIED






## Evolution Proposal: EP-27
- **Date**: 2026-08-02T00:00:00+08:00
- **Type**: memory_update
- **Target**: README.md
- **What**: Fixed README staleness against v1.0.0 -> v2.1.1 reality. Factual errors: the `test` alias table row still showed the old (broken, pre-EP-21) `TEST_GENERATE` mapping instead of `TEST_RUN`; both diagrams showed `.cursor/rules/ai-os.md` instead of the `.mdc` path EP-21 switched to; Backup & Restore still framed `project_knowledge.md` merge conflicts as an intentional "feature," directly contradicting EP-10's stated purpose and ignoring EP-23's actual `git merge-base` check; Token Economics answered the boot-cost question with a caching argument that predates and misrepresents the real fix (hot-core restructure, ~4,260 measured tokens); footer read v1.0.0. Missing features added: a Key Features bullet for `core.memory.sk`'s verify+accept promotion gate, `INFRA_ANALYZE_COMMITS`/`absorb_history` and `REVIEW_CREDIBILITY` added to the command table, `core.memory.sk` and the previously-already-missing `core.context-engine.sk` added to the architecture diagram's skill registry. Diagram boot-sequence edges rewritten to stop implying an integrity-check-and-full-governance-read happens every boot (neither does, post-EP-19); `kernel/integrity.md`'s node relabeled from "Self-Verification Checksums" to "Structural Self-Checks" (no checksum exists). TASK_CLOSE's workflow description updated to mention the verification/acceptance gate instead of implying blind promotion.
- **Why**: User asked for a staleness review against the framework's own latest features; README hadn't been touched since before EP-19 despite 26 evolutions changing the boot design, memory pipeline, and several command/path details it documents.
- **Risk**: Low (documentation only, no runtime behavior change).
- **Rollback Plan**: Revert README.md from git history.
- **Rules Check**: User-space documentation. Complies with R3/R9/R21 (claims now match verified current state).
- **Status**: APPLIED

## Evolution Proposal: EP-28
- **Date**: 2026-08-02T00:00:00+08:00
- **Type**: kernel_update + memory_update
- **Target**: .ai-os/BOOT.md, .ai-os/commands/index.json, .ai-os/registry/core.memory.sk/SKILL.md, README.md
- **What**: Fixed a real logic gap the user spotted while reading the README's Branch Auto-Detection description: `BOOT.md` §2 step 4 told the agent to *skip* task-memory creation entirely on `main`/`master`/`develop`/`release/*`, and §9's routing rule only forbade writing straight to `project_knowledge.md` "on a feature branch" — meaning on a protected branch it was implicitly allowed, directly contradicting the verify/accept promotion gate `core.memory.sk` enforces everywhere else. Fix: task memory is now created on every branch with no exception (only a literal detached `HEAD` skips it, for lack of any stable identity to key off). Since protected branches never get a "done" event the way a ticket branch does, their task file is now explicitly a *rolling* file: `MEMORY_CONSOLIDATE` runs the same verify/accept/diff/dedup gate against it that `TASK_CLOSE` would, promotes what qualifies, then clears it back to empty rather than archiving it as a finished ticket. Updated `commands/index.json`'s `MEMORY_CONSOLIDATE` description, added a "Drain rolling task files" step and a 4th Common Mistake to `core.memory.sk`, and rewrote the README note that had surfaced the bug.
- **Why**: The original exclusion (inherited unmodified from the pre-restructure v1.0.0 design) assumed nobody works directly on main — not true for solo/hobby projects, hotfixes, or trunk-based development, all of which are legitimate and none of which should mean working notes get promoted to permanent memory unverified just because there's no ticket branch to isolate them in.
- **Risk**: Medium (kernel-space `BOOT.md` behavior change — every protected-branch session now creates/loads a task file it previously wouldn't have).
- **Rollback Plan**: Revert `BOOT.md` §2/§9, `commands/index.json`, `core.memory.sk`, and README.md from git history.
- **Rules Check**: Kernel-space change authorized by direct maintainer instruction; closes a real R21/core.memory.sk enforcement gap rather than opening one.
- **Status**: APPLIED

## Evolution Proposal: EP-29
- **Date**: 2026-08-02T00:00:00+08:00
- **Type**: kernel_update + memory_update
- **Target**: .ai-os/BOOT.md, .ai-os/registry/core.memory.sk/SKILL.md, README.md
- **What**: Closed the last remaining task-memory gap from EP-28: a detached `HEAD` or a workspace with no git identity at all still silently skipped task memory. Now `BOOT.md` §2 step 4 says to check `memory/tasks/` for an existing open task first, and if none exists, **always ask** the user what task they're working on before creating one — no fuzzy-matching heuristics, no silently invented names, no silent skip (simplified after a follow-up correction — the first draft hedged with "if none fits" language that softened the ask-first rule). §9 now documents three task-file categories instead of two: ticket branches and user-named ad-hoc tasks both close explicitly via `TASK_CLOSE`; only protected branches (main/master/develop/release) are rolling/drained. `core.memory.sk`'s `TASK_CLOSE` and orphan-sweep procedures updated to handle ad-hoc task names (which by design have no matching git branch, so the orphan check matches them by name instead of branch existence). README's Branch Auto-Detection paragraph updated to describe this ask-first behavior — missed in the first pass of this EP, caught by the user on review.
- **Why**: User pointed out mid-review that EP-28 still left one silent skip in place — the truly branch-less case — which is the same unverified-promotion risk EP-28 had just closed everywhere else; then caught that the first implementation still hedged instead of always asking, and that the README hadn't been synced.
- **Risk**: Low (extends existing behavior to one more edge case; no structural change).
- **Rollback Plan**: Revert `BOOT.md` §2/§9 and `core.memory.sk` from git history.
- **Rules Check**: Kernel-space change authorized by direct maintainer instruction.
- **Status**: APPLIED
