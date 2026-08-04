# Conventions & Patterns

- **Cognitive Security**: no blind regex vuln scanning — LLM reasoning does pre-mutation
  security checks instead.
- **Agentic Installer**: existing-codebase installs use an Agentic Installer, not shell
  scripts — install prompt fed to the user's AI assistant, which merges bridge files
  (`CLAUDE.md` etc.) intelligently without destroying existing user rules.
- **Agentic Updater**: never guesses what to delete on upgrade (risks user data) —
  `.ai-os-installer/MIGRATIONS.md` explicitly lists obsolete files to prune, keeping user
  space (custom skills etc.) safe.
- **Namespace Protection**: core skills prefixed `core.*` (`core.security.sk`) → registry
  updates never collide with/overwrite a user's own `security.sk`-style custom skill.
- **Self-Healing**: no background polling — error loop → agent steps back, reads
  `self-healing.sk` checklist.
- **Semantic Memory Conflicts** (superseded EP-10+EP-23): old view treated
  `project_knowledge.md` merge conflicts as an intentional human-reconciliation forcing
  function. EP-10 split it into `knowledge/*.md` specifically to reduce that surface.
  Current mechanism (EP-23, `core.memory.sk`): Forgetting Policy deletions check
  `git merge-base` first — entry added after your fork point by another branch → flag,
  don't drop. A conflict reaching a human is a bug caught late, not a design goal.
- **Credibility Review** (`core.self-healing.sk`, EP-3): two levels — `REVIEW_CREDIBILITY`
  command = structured audit of docs/claims, run before open-sourcing/stakeholder
  presentation. Response Credibility Protocol = silent behavioral gate on every
  substantive response (claim verification, overclaim detection, honest scope,
  alternatives acknowledged, calibrated confidence language).
- **Installer/Updater Sync Gate** (EP-17): `MEMORY_CONSOLIDATE`/`wrap` → if the session
  applied structural evolutions to skills/memory-layout/commands, check whether
  `INSTALL_PROMPT.md`/`UPDATE_PROMPT.md`/`MIGRATIONS.md` need updating too, else installer
  rot.
- **Self-Hosting Gitignore Exception** (EP-25): `INSTALL_PROMPT.md` tells installed
  projects to gitignore `sessions.jsonl`/`last_session.json`/`progress.md` as ephemeral
  noise. This repo (MaiKS's own dev repo) intentionally does NOT — its
  `progress.md`/`decisions.jsonl` are the framework's own changelog, meant to be committed
  and read by contributors. Don't "fix" this repo's `.gitignore` to match; the exception
  is deliberate.
- **Standing vs Per-Action Kernel Override** (EP-41): R3 was originally per-action-only
  (`KERNEL OVERRIDE AUTHORIZED: {files}`) → forced re-prompting on every edit even with
  unchanged human intent. Added session-scoped form
  `KERNEL OVERRIDE AUTHORIZED FOR SESSION: {scope}` (scope explicit, never `*`) →
  recorded in `memory/episodic/session_override.json`, disk-checked not
  conversation-memory (so `/compact` can't resurrect/erase it) → capped 5 kernel edits per
  grant or session end, whichever first.
