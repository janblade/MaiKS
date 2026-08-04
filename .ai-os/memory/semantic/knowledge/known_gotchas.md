# Known Gotchas

- **Bridge File Amnesia**: #1 AI-coding-agent failure mode = not reading the system
  prompt. Fix: map `.ai-os/registry` into native `.agents/skills.json` → IDE forces the
  agent to read it.
- **Over-Delegation**: forcing 100% delegation of code edits (strict R19) breaks many
  hosts. Primary agent = Flexible Coordinator, can edit code directly when necessary.
- **First-Boot Detection**: don't gate the First-Boot wizard on `.ai-os/` existing —
  agentic installers often copy the whole folder in before first boot. Gate on
  `manifest.json.project_name` being empty instead.
- **Drag-and-Drop Amnesia**: never let users upgrade by overwriting `.ai-os/` via host
  file-explorer drag-drop — wipes `memory/` (Agent Amnesia). `UPDATE_PROMPT.md` must do a
  safe merge instead.
- **Memory Guard Upgrades**: memory-layout changes (new dirs, moved files) →
  `UPDATE_PROMPT.md`/`MIGRATIONS.md` must explicitly guide the migration (create dirs,
  move files), not just blanket-forbid touching `.ai-os/memory/`.
- **Task Memory Routing** (EP-4): feature-branch working notes →
  `memory/tasks/[branch_name].md`, NEVER `project_knowledge.md`. Original Phase 4 wording
  ("primary technical working memory") was too vague — agents defaulted to
  `project_knowledge.md` or wrote nothing. Fixed with explicit "write HERE not THERE" in
  Phase 4 + §11.
- **Commit Log Noise** (EP-13): raw individual commits pollute context ("fix typo",
  "wip"). `absorb_history`'s `git log --first-parent main` filters to PR-merge
  commits/summaries → clean signal for seeding semantic knowledge.
- **Version/Counter Bump Discipline**: `manifest.json.ai_os_version` +
  `.evolution_history.total_evolutions` must bump in the SAME pass as any
  `.ai-os/`-payload-touching evolution — missed 7x (EP-23/32/37/42/47/54/55) before being
  written down. Missed `ai_os_version` → `UPDATE_PROMPT.md`'s version-gated migrations
  silently skip real changes on existing installs. Missed counter → `EVOLVE_STATUS`
  misreports applied-evolution count. Not a later cleanup step — part of the edit itself.
- **Self-Hosting State Leak on Fresh Install**: kernel-space fields holding THIS repo's own
  project state (`project_archetype`, `tech_stack`, `PROJECT_RULES_START/END` block,
  project-only command registrations e.g. removed `EVOLVE_BENCHMARK`) need explicit
  reset/purge in `INSTALL_PROMPT.md`'s purge list, else a fresh install copying this
  repo's `.ai-os/` silently inherits MaiKS's own identity instead of running first-boot
  detection. Recurred EP-23/37/42/47. Purging a project-only feature must strip EVERY
  registration point (rule text + `commands/index.json` + `registry/index.json`) — EP-47
  caught EP-43's purge missing the latter two.
- **Updater Must Never Blind-Overwrite Kernel Files**: `UPDATE_PROMPT.md` → search
  `decisions.jsonl`/`.archive.jsonl`/`progress.md` for `KERNEL OVERRIDE` entries targeting
  a file BEFORE overwriting it on upgrade (EP-32). Structurally-marked sections
  (`PROJECT_RULES_START/END`) → preserve unconditionally regardless of log-search result;
  log-search alone is fragile for unmarked rule-text edits, marked blocks have a reliable
  structural extract-reinsert path instead (EP-38).
- **Claude Code `/compact` Is Lossy for Injected Kernel Rules**: no host-native protection
  for `BOOT.md`/`rules/*.md` content against transcript-summarization paraphrase (proven:
  R23/R24/R25 got paraphrased, README/MIGRATIONS content dropped outright in a real
  session). `PreCompact` stdout is discarded (block-only) → can't inject replacement
  context. Fix: `SessionStart` hook, matcher `startup|clear|compact`, injects file content
  via `{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"..."}}`
  — stdout for this event only is fed straight into agent context. No `"shell"` field in
  Claude Code's hook schema (valid: `type`/`command`/`timeout`/`statusMessage`) — invoke
  bash explicitly in `command` on Windows. (EP-40, EP-56)
- **Kernel Overrides: Check Before Editing, Not After**: a skill's own `--fix` / user's
  "fix all" can't self-grant `KERNEL OVERRIDE AUTHORIZED` (R3 forbids self-granted
  permission). Every file in a multi-file fix pass → check against `evolution_policy.md`'s
  Kernel Space table BEFORE editing, not caught after as a lucky save. Happened for real
  in EP-57's `REVIEW_CREDIBILITY --fix` pass.
