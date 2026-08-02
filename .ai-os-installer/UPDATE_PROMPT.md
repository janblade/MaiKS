# 🔄 AI OS Agentic Updater

**ATTENTION AI AGENT**: You are currently acting as the GoliathOS System Updater. The user has downloaded a new version of the OS framework. Your job is to upgrade their existing `.ai-os` installation **without destroying their memory**.

## Step 1: Identify the Source
Ask the user for the path to the newly downloaded GoliathOS update folder (e.g., `./goliath-update`). Wait for their confirmation before proceeding. Before touching anything, read the user's *current* `.ai-os/manifest.json.ai_os_version` and hold onto it — Step 4 needs it to know which migrations actually apply.

## Step 2: The Memory Guard & Layout Migration (CRITICAL)
You **MUST NOT** overwrite, delete, or lose the user's existing memory file contents (such as `project_knowledge.md`, `decisions.jsonl`, `sessions.jsonl`, and custom task logs). However, you **MUST** ensure the memory layout is migrated to the new four-tier directory structure:
1. Ensure all new memory subdirectories exist in the user's active `.ai-os/memory/`:
   - `semantic/`
   - `semantic/knowledge/`
   - `episodic/`
   - `procedural/`
   - `tasks/`
   - `archived_tasks/`
2. Safely migrate existing files from old locations (e.g. root of `.ai-os/memory/`) to their new subdirectories if they are found in the old location:
   - Move `project_knowledge.md` and `patterns.json` to `.ai-os/memory/semantic/`
   - Move `decisions.jsonl` and `sessions.jsonl` to `.ai-os/memory/episodic/`
   - Move `workflows.json` and `playbooks.md` to `.ai-os/memory/procedural/`
   - Move any task files (e.g., `JIRA-*.md`) to `.ai-os/memory/tasks/`
3. **Indexed Semantic Knowledge Segregation**:
   If the user has a monolithic `project_knowledge.md` (without a `.ai-os/memory/semantic/knowledge/` directory):
   - Create `.ai-os/memory/semantic/knowledge/`.
   - Read the user's existing `project_knowledge.md` and parse its sections.
   - Write their section contents into specialized files under `knowledge/` (e.g., `architecture_overview.md`, `conventions_patterns.md`, `known_gotchas.md`, or custom category files based on their headers).
   - Rewrite their `.ai-os/memory/semantic/project_knowledge.md` as an index document linking to those sub-files so all their existing knowledge is preserved and properly segregated.
4. Copy any default templates or placeholder files (like `.keep` files, default `patterns.json`, etc.) from the update source's `memory/` folder ONLY if the user does not already have an existing version of that file.
5. If missing, create `.ai-os/memory/episodic/last_session.json` (seed it from the last entry in the user's existing `sessions.jsonl`, or a null placeholder if empty).

## Step 3: Perform the Upgrade
Using your file manipulation tools, carefully copy the following files and directories from the new update source into the user's active `.ai-os/` directory, overwriting the old versions:
- `BOOT.md`
- `kernel/`
- `rules/`
- `registry/` (Merge `index.json` carefully to preserve custom skills! This also brings in any new core skills the user doesn't have yet — diff the update source's `registry/index.json` skill IDs against the user's, and copy in any folder that's new.)
- `commands/`

*Note: For `manifest.json`, `registry/index.json`, `commands/index.json`, and `commands/aliases.json`, do not blindly overwrite. Read both the old and new versions, and carefully merge any new configuration keys, framework skills, or new core commands/aliases from the update into the user's existing files to preserve their custom settings, custom skills, and custom aliases. Confirm any new skill IDs present in the update's `registry/index.json` are also added to the user's `manifest.json.installed_skills` array — a skill folder copied to disk but missing from that list won't be treated as installed. Once everything else is merged, set `manifest.json.ai_os_version` to the update source's version — this is the one field that's supposed to change wholesale, not merge.*

## Step 4: Execute Migrations
Read `.ai-os-installer/MIGRATIONS.md` from the update source in full — it's a reverse-chronological
list of version sections. Using the pre-upgrade `ai_os_version` you captured in Step 1:
1. Walk every version section **newer** than the user's old version, oldest-of-those-first
   (i.e. if upgrading from v1.0.0 to v2.1.1, apply v2.0.0's actions, then v2.1.0's, then
   v2.1.1's, in that order — later migrations can assume earlier ones already ran).
2. For each: review deprecations/obsoleted files and delete ONLY files explicitly listed as
   obsolete (never other files in the user's `registry/` or `commands/` — those may be
   custom). Then perform whatever one-time action that version's entry describes (e.g. a
   one-time orphan sweep, a schema note, a file that needs seeding) — treat every
   `Migration action:` line in each section as a step to actually execute, not background
   reading.
3. If the user was already on the latest version, there's nothing to do here — confirm that
   and move on rather than silently skipping the check.

This replaces having a separate hardcoded step per version (e.g. an old "v2.1.0-only" step)
— new versions just add a new MIGRATIONS.md section and this loop picks them up
automatically, so this file doesn't need editing every release.

## Step 5: Verify and Finalize
1. Verify that the migrated memory files (specifically `.ai-os/memory/semantic/project_knowledge.md` and `.ai-os/memory/episodic/decisions.jsonl`) are intact.
2. Refresh the user's `.gitignore` "AI OS Ephemeral Memory" block against the current list in `INSTALL_PROMPT.md` Step 4 — if they installed under an older installer version, they may be missing a newer ephemeral file (e.g. `last_session.json`).
3. Do NOT delete the update source folder. Leave it intact so the user can reference it if needed.
4. Announce to the user that the upgrade is complete, stating the old and new `ai_os_version`.
