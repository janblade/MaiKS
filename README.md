# GoliathOS

GoliathOS is a standards-driven, microkernel-inspired Operating System layer designed to run directly inside your project workspaces. It governs, secures, and enhances AI coding agents (such as Claude Code, Antigravity/Gemini, GitHub Copilot, Cursor, and Windsurf) in any codebase.

---

## 🚀 Key Features

*   **Microkernel Architecture**: Strict separation between the kernel space (immutable governance, rules, configuration) and user space (evolvable skills, memory, commands).
*   **Standards-Driven**: Built-in compliance checks aligned with **ISO/IEC 42001** (AI Management Systems) and **OWASP GenAI Top 10 (2025)** security standards.
*   **Three-Tier Memory**: Episodic (decisions), Semantic (project knowledge), and Procedural (learned workflows) logs that persist context across sessions.
*   **Perception & Stack-Drift Detection**: Scans the workspace on boot, detects technology stacks, and automatically proposes skill updates if teammates introduce new tools/languages.
*   **Idea-to-Code Scaffolding**: Integrated `Architect` skill that guides greenfield ideas from structured interview to architecture planning, code scaffolding, and environment config.
*   **Self-Healing**: Built-in circuit breakers, loop detection, and failure recovery to keep autonomous workflows stable and reliable.

---

## 📂 Directory Layout

```
.ai-os/
├── BOOT.md                          # Master boot prompt
├── manifest.json                    # Project config & metadata
├── kernel/
│   └── integrity.md                 # System self-verification checks
├── rules/
│   ├── ultimate_rules.md            # ISO 42001 rules
│   ├── security_policy.md           # OWASP safety policy
│   └── evolution_policy.md          # Evolution boundary rules
├── genome/
│   ├── project_genome.json          # Detected stack DNA
│   └── archetypes/                  # Governance profiles (hobby -> critical)
├── memory/
│   ├── episodic/                    # decisions.jsonl + sessions.jsonl
│   ├── semantic/                    # project_knowledge.md + patterns.json
│   └── procedural/                  # workflows.json + playbooks.md
└── registry/                        # Skill catalogs (.sk/)
```

---

## ⚙️ How to Install & Use

1. Copy the `.ai-os/` directory into your project root.
2. Copy the relevant bridge file(s) for the AI assistant you use:
   - For **Antigravity (Gemini)** or **Codex**: `.agents/AGENTS.md`
   - For **Claude Code**: `CLAUDE.md`
   - For **GitHub Copilot**: `.github/copilot-instructions.md`
   - For **Cursor**: `.cursor/rules/ai-os.md`
   - For **Windsurf**: `.windsurfrules`
   - Or just keep `AGENTS.md` at the project root as a generic fallback.
3. Open your project in your AI editor or launch your terminal assistant.
4. The agent will read the bridge file, load `BOOT.md`, initialize, and greet you with the status banner!

---

## 🛠️ Command Interface

Once booted, you can direct the agent using standard commands or aliases in your chat window:

```
> OS_COMMAND STATUS           # Show system health & stats
> OS_COMMAND HELP             # View all 39 available commands
> OS_COMMAND audit            # Run full security vuln scan
> OS_COMMAND fix              # Run auto-healing diagnostic & repair
> OS_COMMAND plan --idea="..." # Kick off greenfield planning pipeline
```

---

*GoliathOS v1.0.0 — An operating system for the next generation of AI developers.*
