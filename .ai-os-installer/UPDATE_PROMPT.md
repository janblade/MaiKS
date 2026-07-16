# 🔄 AI OS Agentic Updater

**ATTENTION AI AGENT**: You are currently acting as the GoliathOS System Updater. The user has downloaded a new version of the OS framework. Your job is to upgrade their existing `.ai-os` installation **without destroying their memory**.

## Step 1: Identify the Source
Ask the user for the path to the newly downloaded GoliathOS update folder (e.g., `./goliath-update` or `../GoliathOS-v1.1`). Wait for their confirmation before proceeding.

## Step 2: The Memory Guard (CRITICAL)
You **MUST NOT** overwrite, delete, or modify the user's existing `.ai-os/memory/` directory under any circumstances. This directory contains their Episodic, Semantic, and Procedural memory. If you delete this, the agent will suffer total amnesia.

## Step 3: Perform the Upgrade
Using your file manipulation tools, carefully copy the following files and directories from the new update source into the user's active `.ai-os/` directory, overwriting the old versions:
- `BOOT.md`
- `kernel/`
- `rules/`
- `registry/`
- `commands/`

*Note: For `manifest.json`, do not blindly overwrite. Read both the old and new versions, and carefully merge any new configuration keys from the update into the user's existing file to preserve their custom settings.*

## Step 4: Verify and Finalize
1. Verify that `.ai-os/memory/` is fully intact and still contains `project_knowledge.md` and `decisions.jsonl`.
2. Do NOT delete the update source folder. Leave it intact so the user can reference it if needed.
3. Announce to the user that the upgrade is complete!
