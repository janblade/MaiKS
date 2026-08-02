# GoliathOS

GoliathOS is a governance-first, microkernel-inspired Operating System layer designed to run directly inside your project workspaces. It governs, secures, and enhances AI coding agents (such as Claude Code, Antigravity/Gemini, GitHub Copilot, Cursor, and Windsurf) in any codebase.

> **🌟 Deterministic, Git-Native Memory**
> Many AI frameworks rely on opaque Vector Databases (RAG) for memory management. GoliathOS takes a different approach by using a **deterministic, human-readable Hub and Spoke memory architecture**. The AI's context is stored in pure Markdown and JSON files alongside your code. When a new developer clones your repo, their AI instantly inherits the exact same project knowledge, technical history, and custom skills. No external databases required.

---

## 🚀 Key Features

*   **Microkernel Architecture**: Strict separation between the kernel space (immutable governance, rules, configuration) and user space (evolvable skills, memory, commands).
*   **PDCA Self-Evolution**: The OS implements a strict Plan-Do-Check-Act lifecycle. If the AI discovers a more efficient pattern, it can propose and apply upgrades to its own workflows and skills, complete with auto-rollback if integrity checks fail.
*   **Flexible Agent Delegation**: The primary agent acts as a Coordinator that can edit code directly, but can also delegate complex, multi-file architectures to specialized subagents if the host environment supports it.
*   **Pre-Mutation Security Checklist**: The OS enforces a mandatory pre-mutation security review before any code is written to disk, catching hardcoded credentials, injection patterns, and unsafe functions. For production-grade static analysis, integrate a dedicated SAST tool (like Semgrep or Snyk) into your CI pipeline.
*   **Pragmatic Self-Healing**: Uses loop detection to break out of failure cycles. More importantly, when the AI successfully repairs a complex issue, it prompts the user to extract the fix into a permanent playbook so it never hallucinates the same error twice.
*   **Perception & Stack Discovery**: The OS can actively profile your workspace (via `OS_COMMAND INFRA_DISCOVER_MODULES`) to detect tech stack drift, map sub-modules, and automatically synthesize new semantic rules or custom skills based on what it finds.
*   **Idea-to-Code Scaffolding**: Integrated `Architect` skill that guides greenfield ideas from structured interview to architecture planning, code scaffolding, and environment config.
*   **Native IDE Absorption**: Bridges natively with your IDE's customization systems (`.agents/skills.json`, a root `AGENTS.md` for the emerging cross-tool convention, plus IDE-specific files like `CLAUDE.md` and Cursor's `.mdc` rules) to guarantee that OS skills and semantic memory are absorbed immediately into the agent's context window — even on hosts that never execute the full boot sequence, each bridge file carries a self-sufficient minimum contract on its own.
*   **Four-Tier Memory Model**: Eradicates agent amnesia by maintaining Episodic (decisions), Semantic (global architecture), Task (active branches), and Procedural (executable playbooks) memory across all your chat sessions.
*   **Hub and Spoke Task Memory**: Integrates seamlessly with Git! When you switch to an ephemeral feature or bugfix branch, the OS automatically isolates your technical working memory into a specialized task file, keeping your global project knowledge clean and lightning fast.
*   **Verified Memory Promotion**: Task notes are deliberately unscrutinized working memory — half-formed ideas and dead ends are expected. Before anything gets promoted into permanent, cross-session semantic memory, the OS checks it two ways: is the claim still factually true against the current code, *and* was the underlying change actually accepted (not still buggy, mid-revision, or awaiting your sign-off)? A description of a bug that's still in the code is a true statement and a terrible thing to remember as "how it works."

## 💸 Token Economics

**"Wait, won't reading the entire OS framework on every boot cost a fortune in tokens?"**

It would — so the OS doesn't do that. `BOOT.md` is a small hot core (~4,000 tokens as measured) that carries a condensed rules digest and *pointers* to the full rules, skill procedures, and command catalog, rather than inlining them. Boot reads exactly five small files — `BOOT.md`, `manifest.json`, `project_genome.json`, your active archetype file, and a single-entry session-continuity summary — and stops there. The full text of `rules/*.md`, `registry/*/SKILL.md`, and `commands/index.json` (tens of KB combined) loads only when a specific situation actually calls for it: a rule conflict, a security-sensitive change, or a command being invoked.

Net effect: boot costs roughly **4,000–4,500 tokens** regardless of how much governance content the framework has accumulated, since new rules and skills live in files that are opt-in by trigger, not opt-out by size. Provider-side context caching (Claude, Gemini, GPT-4o, etc.) still helps on top of this for the parts that are read repeatedly, but it's a bonus, not the mechanism the design relies on.

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
    subgraph MultiAgentBridges ["Multi-Agent Entry Bridges (each carries a self-sufficient fallback contract)"]
        direction LR
        AG["AGENTS.md (Root, cross-tool)"]:::bridge
        CL["CLAUDE.md (Claude Code)"]:::bridge
        CO[".github/copilot-instructions.md"]:::bridge
        CU[".cursor/rules/ai-os.mdc"]:::bridge
        WI[".windsurfrules"]:::bridge
    end

    %% Kernel Space
    subgraph KernelSpace ["KERNEL SPACE - Immutable"]
        BOOT["BOOT.md<br>(Hot-core Boot Prompt, ~4K tokens)"]:::kernel
        MANIFEST["manifest.json<br>(System Configurations)"]:::kernel
        INTEGRITY["kernel/integrity.md<br>(Structural Self-Checks, no checksum)"]:::kernel
        BOOTSTRAP["kernel/bootstrap.md<br>(First-Boot Wizard, loaded once ever)"]:::kernel
        
        subgraph GovernanceRules ["Governance Rules (loaded on-demand, not at boot)"]
            RULES["ultimate_rules.md<br>(Governance Rules)"]:::governance
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
        
        subgraph MemorySystem ["Memory System - Cognitive Model"]
            EPISODIC["Episodic Memory<br>(decisions.jsonl + sessions.jsonl<br>+ last_session.json, decisions.archive.jsonl)"]:::database
            SEMANTIC["Semantic (Hub)<br>(project_knowledge.md index<br>+ knowledge/*.md sub-files)"]:::database
            TASK["Task (Spokes)<br>(tasks/ + archived_tasks/,<br>orphan-swept & pruned)"]:::database
            PROCEDURAL["Procedural Memory<br>(workflows.json + playbooks.md)"]:::database
        end

        subgraph CoreSkills ["Core Skills - Registry"]
            SEC_SK["security.sk<br>(Audit Gates)"]:::userspace
            INF_SK["infra.sk<br>(Scaffold & CI/CD)"]:::userspace
            TST_SK["testing.sk<br>(Validation Run)"]:::userspace
            EVO_SK["evolution.sk<br>(PDCA Lifecycle)"]:::userspace
            OBS_SK["observability.sk<br>(Audit Logs)"]:::userspace
            CTX_SK["context-engine.sk<br>(Relevance & Selection)"]:::userspace
            MEM_SK["memory.sk<br>(Verify + Accept-Gate Promotion)"]:::userspace
            HEAL_SK["self-healing.sk<br>(Loop Detection & Repair)"]:::userspace
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

    %% Initialization Sequence (~4K tokens, 5 small files — see Token Economics)
    BOOT -->|1. Skim Rules Digest, inline| GENOME
    ARCHETYPES -->|Calibrate one archetype| GENOME
    GENOME -->|2. Read last_session.json only, O(1)| EPISODIC
    GENOME -->|3. Task branch? load/create tasks/*.md| TASK
    BOOT -.->|On-demand: conflict, security decision, or evolution| GovernanceRules
    BOOT -.->|On-demand: something looks broken| INTEGRITY
    BOOT -.->|First boot only, once ever| BOOTSTRAP
    BOOT -.->|On-demand: command invoked| CMD_REG

    %% Runtime Invocation Loop
    input([User Command / Natural Language Input]) --> ALIASES
    ALIASES -->|Resolve, or match closest command silently| CMD_REG
    CMD_REG -->|Route Execution| SEC_SK
    
    SEC_SK -->|Pre-mutation Security Gate| ScanGate{"Security Scan Gate"}:::gate
    ScanGate -->|Fail| BlockResponse["Block Write & Report Incident"]
    ScanGate -->|Pass| TargetSkill["Target Execution Skill"]

    %% Action Loop Details
    TargetSkill -->|Perform Action| Action(["Write Code / Run Tool / Modify Workspace"])
    Action -->|Verify & Trace| OBS_SK
    OBS_SK -->|Commit Decision| EPISODIC
    OBS_SK -->|Record Success| PROCEDURAL
    TASK -->|TASK_CLOSE / MEMORY_CONSOLIDATE| MEM_SK
    MEM_SK -->|Verify facts + Accept-Gate (R15/R21), then promote| SEMANTIC
    
    %% Resilience
    HEAL_SK -.->|Detect loops & run checklists| TargetSkill
    EVO_SK -.->|Propose & verify self-updates| CoreSkills
    CTX_SK -.->|Score relevance for what to read| TargetSkill
```

---

## 📂 Installation & Upgrade Guide

### First-Time Installation
If you are installing GoliathOS for the first time:
1. **Copy** the `.ai-os/` and `.ai-os-installer/` folders from the downloaded package into the root of your project.
2. Provide the `INSTALL_PROMPT.md` to your AI assistant.

### 🔄 Upgrading (WARNING)
If you already have GoliathOS installed and are upgrading to a new version, **DO NOT overwrite your existing `.ai-os/` folder manually!** Doing so will wipe out your AI's memory.
1. Place the newly downloaded GoliathOS folder *somewhere else* in your workspace (e.g., in a temporary folder like `./goliath-update/`).
2. Provide the `UPDATE_PROMPT.md` to your AI assistant. The Agentic Installer will safely merge the new kernel files without destroying your Episodic, Semantic, or Procedural memory.

---

### 1. Before Install (The Downloaded Package)
```
goliath-os/
├── .ai-os/                          # The OS Kernel
├── .ai-os-installer/                # The Agentic Installer
│   ├── INSTALL_PROMPT.md            # The script you feed to your AI for first install
│   ├── UPDATE_PROMPT.md             # The script you feed to your AI for upgrading
│   └── templates/                   # Bridge file templates (CLAUDE.md, etc.)
└── README.md
```

### 2. After Install (Your Workspace)
```
your-project/
├── .ai-os/                          
│   ├── BOOT.md                      # Master boot prompt
│   ├── manifest.json                # Project config & metadata
│   ├── progress.md                  # Living dashboard & status tracker
│   ├── kernel/                      # System self-verification checks
│   ├── rules/                       # ISO 42001 rules & OWASP safety policy
│   ├── commands/                    # User aliases and command catalog
│   ├── genome/                      # Detected stack DNA & Archetypes
│   ├── memory/                      
│   │   ├── episodic/                # decisions.jsonl, sessions.jsonl, last_session.json,
│   │   │                            # decisions.archive.jsonl (rotated on consolidation)
│   │   ├── semantic/                # project_knowledge.md (index) + knowledge/*.md + patterns.json
│   │   ├── procedural/              # workflows.json + playbooks.md
│   │   ├── tasks/                   # Active Jira/feature branch working memory
│   │   └── archived_tasks/          # History of closed tasks (pruned, not unbounded)
│   ├── agents/                      # Custom specialized agent profiles
│   └── registry/                    # Skill catalogs (.sk/), incl. core.memory.sk
│
├── .gitignore                       # (Updated by installer to ignore OS noise)
├── src/                             # (Your actual app code)
│
├── AGENTS.md                        # Root bridge — universal fallback, always added
└── [Host-Specific Bridge File]      # (Merged by the installer)
    ├── CLAUDE.md                    # ...if using Claude Code
    ├── .windsurfrules               # ...if using Windsurf
    ├── .cursor/rules/ai-os.mdc      # ...if using Cursor (alwaysApply: true frontmatter)
    ├── .github/copilot-instructions.md # ...if using GitHub Copilot
    └── .agents/AGENTS.md            # ...if using Antigravity/Gemini
```

---

## ⚙️ How to Install & Use

1. Copy the `.ai-os/` and `.ai-os-installer/` directories into your project root.
2. Open your project in your AI editor or launch your terminal assistant.
3. Open your AI chat and type: **"Please install the AI OS using the instructions in `.ai-os-installer/INSTALL_PROMPT.md`"**
4. The agent will act as an installer. It will safely merge the necessary bridge instructions into your existing rules (e.g., `.windsurfrules`, `CLAUDE.md`) without destroying them, clean up the installer directory, and boot up!
5. Upon its first boot, the OS will notice that your `manifest.json` is unpopulated, which triggers the **First-Boot Wizard**. This wizard will ask for your project name and automatically run a perception scan (`INFRA_DETECT_STACK`) to map your tech stack.

---

## 🔄 How to Update

To update an existing workspace to the latest version of GoliathOS while preserving your agent's learned memory and custom configurations, we use the **Agentic Updater**:

1. Download the new version of GoliathOS and place the unzipped folder in your workspace (e.g., `./goliath-update`).
2. Open your AI chat and type: **"Please update my AI OS using the instructions in `./goliath-update/.ai-os-installer/UPDATE_PROMPT.md`"**
3. The agent will act as a safe updater. It will intelligently copy the new Kernel, Rules, and Skills, while explicitly **guarding your `memory/` folder** to ensure it never suffers amnesia. It will also carefully merge any new settings into your `manifest.json`.

---

## 🏎️ Efficient Workflow

How to get the most out of GoliathOS in your daily development:

1. **The Boot**: While the bridge files naturally instruct the agent to read `.ai-os/BOOT.md` in the background, LLMs don't always act until spoken to. Begin your first chat of the day with: **`> OS_COMMAND BOOT`** to guarantee a verified load of your project's memory.
2. **Branch Auto-Detection (Zero Setup)**: Start a new ticket by checking out a branch (e.g., `git checkout -b feature/JIRA-123`). The OS will automatically detect this branch and create a dedicated, isolated task memory file (`tasks/feature_JIRA-123.md`). It will use this file to log deep technical debugging steps so your main project memory isn't polluted — and it'll do the same even if you work directly on `main`/`release` (solo projects, hotfixes, trunk-based workflows). There's no branch where working notes are allowed to skip straight to permanent project memory unverified; on those protected branches the task file is just *rolling* — periodically drained into `project_knowledge.md` by `MEMORY_CONSOLIDATE` instead of closed all at once by `TASK_CLOSE`. Not in a git repo, or in a detached `HEAD` state with no branch to key off? The OS won't skip task memory or invent a name for you — it checks for an already-open task first, and if it can't find one, it just asks what you're working on before creating the file.
3. **Daily Development**: Code normally! You don't need to micromanage the OS. Just ask your agent to build features, fix bugs, or write tests. The OS's security and architecture rules govern it silently as it works.
4. **Complex Planning**: If you have a massive architectural change, don't just tell the agent to code. Type `> OS_COMMAND plan`. The `Architect` skill will engage in a structured interview with you to design the feature safely.
5. **Task Completion & Consolidation**: When you finish your feature and are ready to open a Pull Request, tell the agent: **`> OS_COMMAND TASK_CLOSE`** (or just say "summarize and close this task"). The AI reads your task memory, checks each candidate fact two ways — is it still factually accurate, and was the underlying change actually accepted rather than still buggy or awaiting your sign-off — before saving anything to the `semantic/` hub, then archives the task file. Nothing gets promoted to permanent memory just because it was written down.

---

## 💾 Backup & Restore (Portability)

Because GoliathOS stores all of its memory, skills, and governance in plain-text markdown and JSON files within your workspace, **the OS state travels with your code**.

- **To Backup**: Simply commit the `.ai-os/` directory to your project's Git repository.
- **Merge Conflicts?**: 
  - *Append-only Logs (`decisions.jsonl`)*: Git naturally auto-merges append-only logs very well.
  - *Semantic Memory (`knowledge/*.md`, indexed by `project_knowledge.md`)*: institutional knowledge is split into topic files specifically to keep concurrent branches from touching the same file. When the OS considers deleting something as superseded, it checks Git history first — if another branch added that entry after your branch forked, it flags the conflict to you instead of silently dropping it on merge. A conflict reaching you at all is a signal something needs a human look, not a designed-in forcing function.
  - *Noisy Files*: The Agentic Installer automatically adds noisy, per-machine files (`sessions.jsonl`, `last_session.json`, and `progress.md`) to your `.gitignore` to prevent conflict hell — `decisions.jsonl` itself stays tracked, since it's the shared audit trail.
- **To Restore**: When you clone your repo on a new laptop (or a teammate clones it), the host AI agent will instantly absorb the exact same episodic memories, architectural rules, and custom skills the moment they open the project! There are no hidden databases or cloud states to sync.

---

## 🛠️ Command Reference

Because GoliathOS is an Agentic OS, you don't need to type strict command syntax. You can invoke any of these commands using **natural language**, and the AI will handle the parameters in the background.

### Core System
| Command | Alias | Description | Example Prompt |
|---|---|---|---|
| `STATUS` | `status` | Show system health and memory stats | *"Can you check the OS status?"* |
| `HELP` | | View all available pragmatic commands | *"What commands can you run?"* |

### Security & Healing
| Command | Alias | Description | Example Prompt |
|---|---|---|---|
| `SECURITY_AUDIT` | `audit` | Full workspace security review | *"Please audit the workspace before we commit"* |
| `SECURITY_SCAN_FILE` | `scan` | Security review on a specific file | *"Check auth.ts for security flaws"* |
| `HEAL_DIAGNOSE` | `fix` | Run troubleshooting checklist | *"I'm stuck in an error loop, please run a diagnosis"* |
| `HEAL_REPAIR` | `repair` | Execute an auto-repair sequence | *"Go ahead and repair that issue"* |
| `REVIEW_CREDIBILITY` | | Audit docs/claims for overclaims and stale info | *"Review this README for anything that's gone stale"* |

### Architecture & Infrastructure
| Command | Alias | Description | Example Prompt |
|---|---|---|---|
| `ARCHITECT_PLAN` | `plan` | Interactive interview to plan a feature | *"Let's plan a new user dashboard feature"* |
| `INFRA_DISCOVER_MODULES` | `discover` | Profile codebase to detect stack drift | *"Profile the codebase, I just added Next.js"* |
| `INFRA_SCAFFOLD` | | Generate boilerplate project structure | *"Scaffold the project structure for me"* |
| `INFRA_ANALYZE_COMMITS` | `absorb_history` | Seed semantic memory from recent PR-merge history | *"Absorb our commit history into project memory"* |

### Memory & Evolution
| Command | Alias | Description | Example Prompt |
|---|---|---|---|
| `TASK_CLOSE` | `close` | Execute the Consolidation Protocol | *"I'm done with this branch, summarize and close the task"* |
| `MEMORY_CONSOLIDATE`| `consolidate`| Extract rules into semantic memory | *"Extract the rules we just learned into memory"* |
| `EVOLVE_PROPOSE` | `propose` | Draft a PDCA system upgrade | *"Propose a new command to automate docker builds"* |
| `EVOLVE_APPLY` | `apply` | Apply an approved evolution | *"That proposal looks good, apply it"* |

### Testing
| Command | Alias | Description | Example Prompt |
|---|---|---|---|
| `TEST_RUN` | `test` | Execute the test suite | *"Run the tests"* |
| `TEST_GENERATE` | | AI-assisted test generation | *"Write some robust tests for this new utility"* |

---

*GoliathOS v2.1.1 — An operating system for the next generation of AI developers.*
