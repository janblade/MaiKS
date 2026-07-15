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
- **Self-Healing:** Instead of background polling, self-healing is achieved via cognitive checklists. If an agent loops on an error, it is instructed to step back and read the `self-healing.sk` checklist.
- **Semantic Memory Conflicts:** We accept trivial Git merge conflicts in `project_knowledge.md` as a feature. If two agents log conflicting architectural rules on different branches, the human developers are forced to manually reconcile them, which prevents silent architectural drift.

## Known Gotchas

- **Bridge File Amnesia:** The biggest failure mode in AI coding agents is failing to read the system prompt. We solved this by mapping our custom framework directories (`.ai-os/registry`) into the native `.agents/skills.json` so the IDE forces the agent to read them.
- **Over-Delegation:** Forcing an agent to delegate *all* code edits (strict Rule R19) breaks many host environments. The primary agent operates as a Flexible Coordinator that *can* edit code itself if necessary.
- **First-Boot Detection Logic:** The OS Kernel must not rely on the existence of `.ai-os/` to trigger the First-Boot wizard, because agentic installers often copy the entire `.ai-os/` folder into the workspace prior to the first boot. Instead, the trigger checks if `manifest.json` has an empty `project_name`.

---

*Last updated: 2026-07-15 (Post-Refactoring Consolidation)*
