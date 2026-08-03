# Architecture Overview

**MaiKS Framework**
A cognitive microkernel that governs AI agents running inside an IDE or terminal. 
The system avoids background daemon loops or complex external runtime orchestrators. Instead, it relies on the host IDE (Cursor, Windsurf, Gemini) for context injection, using native bridge files (like `.agents/skills.json` and `AGENTS.md`) to guarantee that OS skills and memory are absorbed.
