# GoliathOS

GoliathOS is a standards-driven, microkernel-inspired Operating System layer designed to run directly inside your project workspaces. It governs, secures, and enhances AI coding agents (such as Claude Code, Antigravity/Gemini, GitHub Copilot, Cursor, and Windsurf) in any codebase.

---

## 🚀 Key Features

*   **Microkernel Architecture**: Strict separation between the kernel space (immutable governance, rules, configuration) and user space (evolvable skills, memory, commands).
*   **Supervisor-Worker Topology**: Enforced multi-agent delegation (Rule R19). The primary agent operates strictly as a Coordinator, delegating all codebase modifications to restricted, specialized sub-agents.
*   **Dynamic Model-Tiering & Escalation**: Intelligent model routing (Reasoning, Balanced, and Lightweight tiers). Automatically escalates workers to high reasoning models during critical errors, loop healing, or audits, and de-escalates back to save token budget.
*   **Perception & Stack-Drift Detection**: Scans the workspace on boot, maps codebase sub-modules, and automatically synthesizes custom skills and agent profiles if stack drift or new modules are detected.
*   **Idea-to-Code Scaffolding**: Integrated `Architect` skill that guides greenfield ideas from structured interview to architecture planning, code scaffolding, and environment config.
*   **Self-Healing & Resilience**: Built-in circuit breakers, loop detection, and failure recovery to keep autonomous workflows stable and reliable.

---

## 📊 System Architecture

```mermaid
graph TB
    %% Styling Definitions
    classDef bridge fill:#3b82f6,stroke:#1d4ed8,stroke-width:2px,color:#fff;
    classDef kernel fill:#ef4444,stroke:#b91c1c,stroke-width:2px,color:#fff;
    classDef governance fill:#f59e0b,stroke:#d97706,stroke-width:2px,color:#fff;
    classDef userspace fill:#10b981,stroke:#047857,stroke-width:2px,color:#fff;
    classDef database fill:#8b5cf6,stroke:#6d28d9,stroke-width:2px,color:#fff;
    classDef gate fill:#ec4899,stroke:#be185d,stroke-width:2px,color:#fff;

    %% Entry Bridges
    subgraph MultiAgentBridges ["Multi-Agent Entry Bridges"]
        direction LR
        AG["AGENTS.md (Root/Codex)"]:::bridge
        CL["CLAUDE.md (Claude Code)"]:::bridge
        CO[".github/copilot-instructions.md"]:::bridge
        CU[".cursor/rules/ai-os.md"]:::bridge
        WI[".windsurfrules"]:::bridge
    end

    %% Kernel Space
    subgraph KernelSpace ["KERNEL SPACE - Immutable"]
        BOOT["BOOT.md<br>(Master Boot Prompt)"]:::kernel
        MANIFEST["manifest.json<br>(System Configurations)"]:::kernel
        INTEGRITY["kernel/integrity.md<br>(Self-Verification Checksums)"]:::kernel
        
        subgraph GovernanceRules ["Governance Rules"]
            RULES["ultimate_rules.md<br>(ISO 42001 Core Rules)"]:::governance
            SECPOL["security_policy.md<br>(OWASP GenAI Defenses)"]:::governance
            EVOPOL["evolution_policy.md<br>(Self-Update Constraints)"]:::governance
        end
    end

    %% Perception Layer
    subgraph PerceptionLayer ["Perception Layer"]
        GENOME["project_genome.json<br>(Stack DNA File)"]:::database
        ARCHETYPES["archetypes/*.json<br>(Hobby / Startup / Enterprise / Critical)"]:::database
    end

    %% User Space
    subgraph UserSpace ["USER SPACE - Agent-Evolvable"]
        direction TB
        
        subgraph MemorySystem ["Memory System - 3-Tier Cognitive Model"]
            EPISODIC["Episodic Memory<br>(decisions.jsonl + sessions.jsonl)"]:::database
            SEMANTIC["Semantic Memory<br>(project_knowledge.md + patterns.json)"]:::database
            PROCEDURAL["Procedural Memory<br>(workflows.json + playbooks.md)"]:::database
        end

        subgraph CoreSkills ["Core Skills - Registry"]
            SEC_SK["security.sk<br>(Audit Gates)"]:::userspace
            INF_SK["infra.sk<br>(Scaffold & CI/CD)"]:::userspace
            TST_SK["testing.sk<br>(Validation Run)"]:::userspace
            EVO_SK["evolution.sk<br>(PDCA Lifecycle)"]:::userspace
            OBS_SK["observability.sk<br>(Audit Logs)"]:::userspace
            CTX_SK["context-engine.sk<br>(Budget Engine)"]:::userspace
            HEAL_SK["self-healing.sk<br>(Circuit Breakers)"]:::userspace
            ARC_SK["architect.sk<br>(Greenfield Plan)"]:::userspace
        end

        subgraph Interface ["Interface"]
            CMD_REG["commands/index.json<br>(Command Catalog)"]:::userspace
            ALIASES["commands/aliases.json<br>(User Shortcuts)"]:::userspace
            SHELL["progress.md<br>(Living Dashboard)"]:::userspace
        end
    end

    %% Boot Redirection Flow
    AG & CL & CO & CU & WI -->|Redirect / Load| BOOT

    %% Initialization Sequence (The Boot Sequence)
    BOOT -->|1. Run Check| INTEGRITY
    INTEGRITY -->|2. Enforce| GovernanceRules
    GovernanceRules -->|3. Scan Stack| GENOME
    ARCHETYPES -->|Calibrate| GENOME
    GENOME -->|4. Restore| MemorySystem
    MemorySystem -->|5. Catalog Capabilities| CoreSkills
    CoreSkills -->|Register Commands| CMD_REG

    %% Runtime Invocation Loop
    input([User Command / Natural Language Input]) --> ALIASES
    ALIASES -->|Resolve| CMD_REG
    CMD_REG -->|Route Execution| SEC_SK
    
    SEC_SK -->|Pre-mutation Security Gate| ScanGate{"Security Scan Gate"}:::gate
    ScanGate -->|Fail| BlockResponse["Block Write & Report Incident"]
    ScanGate -->|Pass| TargetSkill["Target Execution Skill"]

    %% Action Loop Details
    TargetSkill -->|Perform Action| Action(["Write Code / Run Tool / Modify Workspace"])
    Action -->|Verify & Trace| OBS_SK
    OBS_SK -->|Commit Decision| EPISODIC
    OBS_SK -->|Ingest Context| SEMANTIC
    OBS_SK -->|Record Success| PROCEDURAL
    
    %% Resilience
    HEAL_SK -.->|Monitor loop & circuit breakers| TargetSkill
    EVO_SK -.->|Propose & verify self-updates| CoreSkills
    CTX_SK -.->|Calculate token budgets| TargetSkill
```

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
├── agents/                          # Custom specialized agent profiles
│   ├── index.json                   # Agent active profiles catalog
│   └── templates/                   # Default developer/QA worker templates
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
> OS_COMMAND HELP             # View all 40 available commands
> OS_COMMAND audit            # Run full security vuln scan
> OS_COMMAND fix              # Run auto-healing diagnostic & repair
> OS_COMMAND plan --idea="..." # Kick off greenfield planning pipeline
> OS_COMMAND INFRA_DISCOVER_MODULES --auto-scaffold # Auto-generate skills and agent profiles for modules
```

---

*GoliathOS v1.0.0 — An operating system for the next generation of AI developers.*
