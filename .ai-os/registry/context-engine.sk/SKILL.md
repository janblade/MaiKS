---
name: context-engine
description: >-
  Intelligent context assembly, relevance scoring, token budget management, and
  context pruning. Solves the #1 production AI failure mode: loading the wrong
  context, not reasoning incorrectly. Ensures the agent always has the right
  information at the right time within token budget constraints.
---

# Context Engineering Engine

## Overview

Context engineering has replaced prompt engineering as the highest-leverage skill for
production AI. This skill ensures optimal context assembly — loading exactly what's
needed, scoring relevance, managing token budgets, and pruning low-value information.

The core principle: **Minimum Viable Context** — load the minimum set of tokens that
maximizes the probability of a correct response.

## Commands

### CONTEXT_LOAD

Assemble optimal context for a task.

```
> OS_COMMAND CONTEXT_LOAD --task=<description> [--budget=<max_tokens>]
```

**Procedure:**
1. Parse the task description to identify key topics, files, and domains
2. Score available context sources by relevance (see CONTEXT_SCORE)
3. Assemble context in priority order (see priority list below)
4. Track accumulated token count against budget
5. Stop adding context when budget is 80% consumed (reserve 20% for reasoning + output)
6. Report: "Context loaded: {items_count} sources, ~{tokens} tokens, {budget_remaining}% budget remaining"

**Priority order for context assembly:**
1. **Task-critical files** — Files directly mentioned or clearly needed for the task
2. **Active code patterns** — Relevant entries from `memory/semantic/patterns.json`
3. **Recent decisions** — Last 3-5 relevant entries from `decisions.jsonl`
4. **Project knowledge** — Relevant sections from `project_knowledge.md`
5. **Procedural memory** — Matching workflows from `workflows.json`
6. **Related test files** — Tests for modules being modified
7. **Configuration files** — Relevant configs for affected systems

---

### CONTEXT_SCORE

Score file relevance to current task.

```
> OS_COMMAND CONTEXT_SCORE --task=<description> --files=<file1,file2,...>
```

**Scoring factors:**
| Factor | Weight | Description |
|---|---|---|
| Direct mention | 1.0 | File is explicitly mentioned in the task |
| Same directory | 0.7 | File is in the same directory as a target file |
| Import chain | 0.6 | File imports or is imported by a target file |
| Recent modification | 0.5 | File was modified in the last session |
| Name match | 0.4 | File name contains task-relevant keywords |
| Test file for target | 0.8 | File is the test for a file being modified |
| Config for target | 0.6 | File configures a system being modified |
| Unrelated module | 0.1 | No clear connection to the task |

**Output:** Ranked list of files with relevance scores (0.0 – 1.0).

---

### CONTEXT_BUDGET

Check token budget and recommend what to load or prune.

```
> OS_COMMAND CONTEXT_BUDGET [--estimate-file=<path>]
```

**Procedure:**
1. Report current context consumption (estimated tokens loaded)
2. Report remaining budget based on `manifest.json.agent_config.token_budget_warning`
3. If `--estimate-file`: Estimate token cost of loading the specified file
4. Recommend action: "Budget healthy" / "Consider pruning low-relevance items" / "Near limit — prune before loading more"

---

### CONTEXT_PRUNE

Remove low-value context to make room for high-value information.

```
> OS_COMMAND CONTEXT_PRUNE [--aggressive]
```

**Pruning priority (remove first):**
1. Old session data (episodic entries older than current session)
2. Generic patterns not relevant to current task
3. Procedural memory for unrelated workflows
4. Semantic knowledge for unrelated project areas
5. *(Never prune)* Task-critical files and active code

If `--aggressive`: Prune up to 50% of context. Normal mode prunes ~20%.

**Output:** "Pruned {count} items, freed ~{tokens} tokens. New budget: {remaining}%"

---

## Context Engineering Principles

### 1. Write-Select-Compress-Isolate

The four pillars of context engineering:
- **Write**: Externalize state to memory files (don't try to remember everything in context)
- **Select**: Load only relevant information for the current task
- **Compress**: Summarize large documents rather than loading them whole
- **Isolate**: Keep system instructions separate from data content

### 2. Context Pollution Prevention

- Don't load entire files when only a function is needed
- Don't load all memory when only recent decisions matter
- Don't load test files for modules you're not modifying
- Clear irrelevant context before switching tasks

### 3. Adaptive Context Strategy

Context strategy adapts based on project genome:
| Architecture | Strategy |
|---|---|
| `single-app` | Load broadly — most files are relevant |
| `monorepo-fullstack` | Load narrowly — scope to the specific app/service |
| `library` | Load API surface + tests for the modified module |
| `api-service` | Load endpoint handlers + middleware + relevant models |
| `data-pipeline` | Load pipeline stage + upstream/downstream connections |

## Common Mistakes

1. **Loading everything** — More context ≠ better results. Precision matters more than volume.
2. **Ignoring token budget** — Running out of context budget mid-task degrades reasoning quality.
3. **Not pruning between tasks** — Leftover context from the previous task pollutes the current one.
