# Architecture Overview

**MaiKS**: cognitive microkernel governing AI agents in IDE/terminal hosts. No background
daemons/external orchestrators — host IDE (Cursor/Windsurf/Gemini/Claude Code) does context
injection via native bridge files (`.agents/skills.json`, `AGENTS.md`) → guarantees OS
skills/memory get absorbed into agent context.
