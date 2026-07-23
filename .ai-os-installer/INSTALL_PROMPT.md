# AI OS Framework Installer

Hello! If you are reading this, the user has asked you to install the **AI OS Framework** into this workspace. 
You are going to act as the Agentic Installer. Your job is to merge the necessary boot instructions into the user's existing workspace without destroying any of their existing rules.

## 🛑 Pre-Flight Safety Check
Before proceeding, check if the host AI environment's bridge file (e.g., `.cursor/rules/ai-os.md`, `.windsurfrules`, `.agents/AGENTS.md`) is already configured with AI OS boot instructions. If it is already configured, **STOP IMMEDIATELY**. Inform the user: *"The AI OS Framework is already installed here. Please use the UPDATE_PROMPT.md instead to prevent memory loss and duplicate rules."* Do not execute any further steps. (Note: If `.ai-os/` exists but the bridge files do not, it means the user just copied the framework into their project and needs to install it. Proceed with the installation).

## Step 1: Detect Host AI Environment
Do not guess your environment. Use your file/directory listing tools to check the workspace root:
- If a `.cursor` directory exists, you are in **Cursor**.
- If a `.windsurf` directory or `.windsurfrules` exists, you are in **Windsurf**.
- If neither exists, ask the user: *"Which AI assistant are you using? (Cursor, Windsurf, Claude Code, GitHub Copilot, Gemini/Antigravity)"*

## Step 2: Merge Bridge Files (Do Not Overwrite!)
Depending on the host environment, find the corresponding template file in `.ai-os-installer/templates/`.
Read the template. Then, **append** its exact text to the bottom of the user's existing bridge file. 
- **Cursor:** Append to `.cursor/rules/ai-os.md` (Create the file and `.cursor/rules` folder if they don't exist).
- **Windsurf:** Append to `.windsurfrules`.
- **Claude Code:** Append to `CLAUDE.md`.
- **GitHub Copilot:** Append to `.github/copilot-instructions.md`.
- **Gemini / Antigravity:** Append to `.agents/AGENTS.md` and copy `skills.json` to `.agents/skills.json`.

**Fallback:** If you do not have the tool capabilities to create or edit files, do not apologize. Simply print the exact text of the template into the chat in a markdown block, and ask the user to paste it into their bridge file.

## Step 3: Purge Framework Meta-Memory & Reset Manifest
If the user copied the `.ai-os/` folder directly from the GoliathOS repository, it will contain memory logs and genome details from the framework's own development. This will pollute the user's new project.
Using your file editing tools, reset the following files to prevent context pollution:
1. **`.ai-os/memory/semantic/project_knowledge.md`**: Overwrite with the default Indexed Knowledge Index template:
   ```markdown
   # Project Knowledge Index

   > This file acts as the primary index for the project's semantic knowledge base.
   > To prevent git merge conflicts between multiple developers and concurrent branches,
   > institutional knowledge is split into specialized sub-files linked below.

   ---

   ## Knowledge Domains

   - [Architecture Overview](file:///.ai-os/memory/semantic/knowledge/architecture_overview.md) — System architecture, module boundaries, and host integrations.
   - [Conventions & Patterns](file:///.ai-os/memory/semantic/knowledge/conventions_patterns.md) — Coding standards, security rules, and testing patterns.
   - [Known Gotchas](file:///.ai-os/memory/semantic/knowledge/known_gotchas.md) — Pitfalls, failure modes, and environment workarounds.
   ```
2. **`.ai-os/memory/semantic/knowledge/` sub-files**: Ensure `.ai-os/memory/semantic/knowledge/` exists. Reset `architecture_overview.md`, `conventions_patterns.md`, and `known_gotchas.md` to baseline header files.
3. **`.ai-os/memory/episodic/decisions.jsonl`** & **`.ai-os/memory/episodic/sessions.jsonl`**: Empty the contents of these files.
4. **`.ai-os/progress.md`**: Clear out the decisions and evolution proposals sections.
5. **`.ai-os/manifest.json`**: Reset `project_name` to `""`, reset `boot_count` to `0`, reset `last_boot` to `null`, and clear the `tech_stack` object (`{}`). Also reset `.ai-os/genome/project_genome.json` indicators to baseline defaults so the **First-Boot Wizard** in `BOOT.md` §10 will correctly trigger.


## Step 4: Verify Integrity & Gitignore
1. Check that the `.ai-os/` directory exists in the root of the workspace. If it does not, inform the user they need to copy the `.ai-os/` folder from the downloaded framework package.
2. Open the user's `.gitignore` file (create it if it doesn't exist) and append the following lines to prevent merge-conflict hell from highly active AI files:
```text
# AI OS Ephemeral Memory
.ai-os/memory/episodic/sessions.jsonl
.ai-os/progress.md
```

## Step 5: Boot!
Read `.ai-os/BOOT.md` and begin executing the Initialization Checklist as the newly installed AI OS Kernel. Greet the user with the boot status banner!
