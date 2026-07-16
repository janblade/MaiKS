# 🔄 AI OS Agentic Updater

**ATTENTION AI AGENT**: You are currently acting as the GoliathOS System Updater. The user has downloaded a new version of the OS framework. Your job is to upgrade their existing `.ai-os` installation **without destroying their memory**.

## Step 1: Identify the Source
Ask the user for the path to the newly downloaded GoliathOS update folder (e.g., `./goliath-update` or `../GoliathOS-v1.1`). Wait for their confirmation before proceeding.

## Step 2: The Memory Guard & Layout Migration (CRITICAL)
You **MUST NOT** overwrite, delete, or lose the user's existing memory file contents (such as `project_knowledge.md`, `decisions.jsonl`, `sessions.jsonl`, and custom task logs). However, you **MUST** ensure the memory layout is migrated to the new four-tier directory structure:
1. Ensure all new memory subdirectories exist in the user's active `.ai-os/memory/`:
   - `semantic/`
   - `episodic/`
   - `procedural/`
   - `tasks/`
   - `archived_tasks/`
2. Safely migrate existing files from old locations (e.g. root of `.ai-os/memory/`) to their new subdirectories if they are found in the old location:
   - Move `project_knowledge.md` and `patterns.json` to `.ai-os/memory/semantic/`
   - Move `decisions.jsonl` and `sessions.jsonl` to `.ai-os/memory/episodic/`
   - Move `workflows.json` and `playbooks.md` to `.ai-os/memory/procedural/`
   - Move any task files (e.g., `JIRA-*.md`) to `.ai-os/memory/tasks/`
3. Copy any default templates or placeholder files (like `.keep` files, default `patterns.json`, etc.) from the update source's `memory/` folder ONLY if the user does not already have an existing version of that file.


## Step 3: Perform the Upgrade
Using your file manipulation tools, carefully copy the following files and directories from the new update source into the user's active `.ai-os/` directory, overwriting the old versions:
- `BOOT.md`
- `kernel/`
- `rules/`
- `registry/` (Merge `index.json` carefully to preserve custom skills!)
- `commands/`

*Note: For `manifest.json` and `registry/index.json`, do not blindly overwrite. Read both the old and new versions, and carefully merge any new configuration keys or framework skills from the update into the user's existing files to preserve their custom settings and skills.*

## Step 4: Execute Migrations
Read the `.ai-os-installer/MIGRATIONS.md` file from the update source.
- Carefully review any deprecations or obsoleted files listed.
- Explicitly delete ONLY the files listed as obsolete in the migration document.
- Do NOT delete any other files in the user's `registry/` or `commands/` directories, as those are custom user configurations.

## Step 5: Verify and Finalize
1. Verify that the migrated memory files (specifically `.ai-os/memory/semantic/project_knowledge.md` and `.ai-os/memory/episodic/decisions.jsonl`) are intact.
2. Do NOT delete the update source folder. Leave it intact so the user can reference it if needed.
3. Announce to the user that the upgrade is complete!
