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









