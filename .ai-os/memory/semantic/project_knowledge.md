# Project Knowledge Base

> This file accumulates institutional knowledge about the project across sessions.
> The AI OS agent updates this file as it learns about the project's architecture,
> conventions, patterns, gotchas, and domain-specific information.
>
> **Protocol**: Update this file when you discover something non-obvious about the
> project that would help a future session. Do NOT include credentials, personal
> data, or ephemeral information.

---

## Architecture Overview

**GoliathOS Framework**
A cognitive microkernel that governs AI agents running inside an IDE or terminal. 
The system avoids background daemon loops or complex external runtime orchestrators. Instead, it relies on the host IDE (Cursor, Windsurf, Gemini) for context injection, using native bridge files (like `.agents/skills.json` and `AGENTS.md`) to guarantee that OS skills and memory are absorbed.

## Conventions & Patterns

- **Cognitive Security:** We do not use blind regex patterns to scan for vulnerabilities. We rely on the LLM's natural reasoning to perform pre-mutation security checks.
- **Agentic Installer:** Installation into existing codebases is handled by an Agentic Installer. We do not use shell scripts to merge text files; we feed the installer prompt to the user's AI assistant, allowing it to intelligently merge bridge files (like `CLAUDE.md`) without destroying the user's existing rules.
- **Agentic Package Manager (Upgrades):** The Agentic Updater cannot "guess" what to delete during an upgrade without risking user data. We use an explicit `.ai-os-installer/MIGRATIONS.md` file to explicitly instruct the updater AI on what obsolete files to prune, ensuring user space (like custom skills) remains safe.
- **Namespace Protection:** All core OS skills are prefixed with `core.` (e.g. `core.security.sk`). This prevents catastrophic namespace collisions when the OS updates its registry, ensuring the user's custom skills (e.g. `security.sk`) are never overwritten.
- **Self-Healing:** Instead of background polling, self-healing is achieved via cognitive checklists. If an agent loops on an error, it is instructed to step back and read the `self-healing.sk` checklist.
- **Semantic Memory Conflicts:** We accept trivial Git merge conflicts in `project_knowledge.md` as a feature. If two agents log conflicting architectural rules on different branches, the human developers are forced to manually reconcile them, which prevents silent architectural drift.
- **Credibility Review:** Credibility assurance operates at two levels: (1) The `REVIEW_CREDIBILITY` command (on `core.self-healing.sk`) performs a structured audit of documentation and claims — run it before open-sourcing or presenting to stakeholders. (2) The **Response Credibility Protocol** (also on `core.self-healing.sk`) is a behavioral gate the agent silently applies to all substantive responses, ensuring claims are verified, overclaims detected, scope is honest, alternatives acknowledged, and confidence language is calibrated. Added via EP-3.

## Known Gotchas

- **Bridge File Amnesia:** The biggest failure mode in AI coding agents is failing to read the system prompt. We solved this by mapping our custom framework directories (`.ai-os/registry`) into the native `.agents/skills.json` so the IDE forces the agent to read them.
- **Over-Delegation:** Forcing an agent to delegate *all* code edits (strict Rule R19) breaks many host environments. The primary agent operates as a Flexible Coordinator that *can* edit code itself if necessary.
- **First-Boot Detection Logic:** The OS Kernel must not rely on the existence of `.ai-os/` to trigger the First-Boot wizard, because agentic installers often copy the entire `.ai-os/` folder into the workspace prior to the first boot. Instead, the trigger checks if `manifest.json` has an empty `project_name`.
- **Drag-and-Drop Amnesia:** When upgrading the OS, users must not use their host OS file explorer to overwrite the `.ai-os/` directory. Doing so will wipe out their `memory/` folder (Agent Amnesia). The `UPDATE_PROMPT.md` is required to perform a safe merge.
- **Memory Guard Upgrades:** When changing the memory layout (e.g. adding new directories or moving files), the `UPDATE_PROMPT.md` and `MIGRATIONS.md` must be updated to explicitly guide the update agent through the layout migration (creating directories, moving files) rather than relying on a blanket rule forbidding all modifications to the `.ai-os/memory/` directory.

---

*Last updated: 2026-07-17 (Memory Layout Upgrade Fix)*
