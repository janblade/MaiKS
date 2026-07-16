# 🔄 AI OS Migrations & Deprecations

This file tracks features, files, or skills that have been deprecated or removed in newer versions of GoliathOS.
The Agentic Updater (`UPDATE_PROMPT.md`) reads this file during upgrades to safely prune obsolete framework files without destroying the user's custom skills.

## v1.0.0
- **Four-Tier Memory Layout Migration**: 
  - Subdirectories added: `semantic/`, `episodic/`, `procedural/`, `tasks/`, `archived_tasks/`
  - Migration action: Move files from `.ai-os/memory/` root to subdirectories (see `UPDATE_PROMPT.md` Step 2).
  - Clean up: After verifying the files are successfully copied/moved to their respective subdirectories, delete the obsolete root-level files in `.ai-os/memory/` (specifically `project_knowledge.md`, `decisions.jsonl`, and `sessions.jsonl` if they remain in the root) to prevent duplicate context loading.

