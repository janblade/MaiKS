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
