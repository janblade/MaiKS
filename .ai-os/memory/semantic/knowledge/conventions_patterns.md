# Conventions & Patterns

- **Cognitive Security:** We do not use blind regex patterns to scan for vulnerabilities. We rely on the LLM's natural reasoning to perform pre-mutation security checks.
- **Agentic Installer:** Installation into existing codebases is handled by an Agentic Installer. We do not use shell scripts to merge text files; we feed the installer prompt to the user's AI assistant, allowing it to intelligently merge bridge files (like `CLAUDE.md`) without destroying the user's existing rules.
- **Agentic Package Manager (Upgrades):** The Agentic Updater cannot "guess" what to delete during an upgrade without risking user data. We use an explicit `.ai-os-installer/MIGRATIONS.md` file to explicitly instruct the updater AI on what obsolete files to prune, ensuring user space (like custom skills) remains safe.
- **Namespace Protection:** All core OS skills are prefixed with `core.` (e.g. `core.security.sk`). This prevents catastrophic namespace collisions when the OS updates its registry, ensuring the user's custom skills (e.g. `security.sk`) are never overwritten.
- **Self-Healing:** Instead of background polling, self-healing is achieved via cognitive checklists. If an agent loops on an error, it is instructed to step back and read the `self-healing.sk` checklist.
- **Semantic Memory Conflicts:** We accept trivial Git merge conflicts in `project_knowledge.md` as a feature. If two agents log conflicting architectural rules on different branches, the human developers are forced to manually reconcile them, which prevents silent architectural drift.
- **Credibility Review:** Credibility assurance operates at two levels: (1) The `REVIEW_CREDIBILITY` command (on `core.self-healing.sk`) performs a structured audit of documentation and claims — run it before open-sourcing or presenting to stakeholders. (2) The **Response Credibility Protocol** (also on `core.self-healing.sk`) is a behavioral gate the agent silently applies to all substantive responses, ensuring claims are verified, overclaims detected, scope is honest, alternatives acknowledged, and confidence language is calibrated. Added via EP-3.
- **Installer & Updater Synchronization Gate:** Whenever consolidating memory or wrapping a session (`wrap` / `MEMORY_CONSOLIDATE`), if any structural evolutions were applied to skills, memory layouts, or commands during the session, verify whether `.ai-os-installer/INSTALL_PROMPT.md`, `UPDATE_PROMPT.md`, or `MIGRATIONS.md` need to be updated to prevent installer rot. Added via EP-17.



