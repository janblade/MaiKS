# Kernel Integrity Protocol

> This file defines the self-verification checks executed during Boot Phase 1.
> If any check fails, the system enters Safe Mode.

## Required Directory Structure

The following paths MUST exist for a healthy boot:

### Kernel Space (Immutable)
```
.ai-os/BOOT.md
.ai-os/manifest.json
.ai-os/kernel/integrity.md
.ai-os/rules/ultimate_rules.md
.ai-os/rules/security_policy.md
.ai-os/rules/evolution_policy.md
.ai-os/genome/archetypes/index.json
.ai-os/genome/archetypes/hobby.json
.ai-os/genome/archetypes/startup.json
.ai-os/genome/archetypes/enterprise.json
.ai-os/genome/archetypes/critical.json
```

### User Space (Evolvable)
```
.ai-os/genome/project_genome.json
.ai-os/memory/episodic/decisions.jsonl
.ai-os/memory/episodic/sessions.jsonl
.ai-os/memory/semantic/project_knowledge.md
.ai-os/memory/semantic/patterns.json
.ai-os/memory/procedural/workflows.json
.ai-os/memory/procedural/playbooks.md
.ai-os/registry/index.json
.ai-os/registry/security.sk/SKILL.md
.ai-os/registry/infra.sk/SKILL.md
.ai-os/registry/testing.sk/SKILL.md
.ai-os/registry/evolution.sk/SKILL.md
.ai-os/registry/observability.sk/SKILL.md
.ai-os/registry/context-engine.sk/SKILL.md
.ai-os/registry/self-healing.sk/SKILL.md
.ai-os/registry/architect.sk/SKILL.md
.ai-os/agents/index.json
.ai-os/agents/supervisor.json
.ai-os/agents/templates/web_developer.json
.ai-os/agents/templates/api_developer.json
.ai-os/agents/templates/qa_auditor.json
.ai-os/commands/index.json
.ai-os/commands/aliases.json
.ai-os/progress.md
```

## Verification Checks

### Check 1: Structure Exists
Verify every path listed above exists. Missing files → attempt scaffold from defaults.

### Check 2: Manifest Schema Valid
`manifest.json` must contain: `ai_os_version` (string, semver), `project_archetype` (string, one of: auto|hobby|startup|enterprise|critical), `security_level` (string), `installed_skills` (array).

### Check 3: Skill Registry Consistent
Every entry in `registry/index.json` must have a corresponding `.sk/SKILL.md` on disk. Orphaned entries → remove from index. Missing entries → add to index.

### Check 4: Memory Files Parseable
- All `.jsonl` files must have valid JSON on each line (empty file is valid).
- All `.json` files must parse as valid JSON.
- All `.md` files must be readable text.

### Check 5: No Circular Skill Dependencies
Parse skill dependencies from each `SKILL.md` — verify no circular chains exist.

## Failure Response

| Severity | Condition | Response |
|---|---|---|
| **WARN** | Non-critical user-space file missing | Recreate from default template, continue boot |
| **ERROR** | Kernel-space file missing | Attempt repair, log error |
| **CRITICAL** | Multiple kernel files missing or manifest corrupt | Enter Safe Mode |

## Safe Mode

In Safe Mode:
1. Only Prime Directives and Security Protocol are active
2. No autonomous operations permitted
3. Only diagnostic commands available: `HELP`, `STATUS`, `HEAL_DIAGNOSE`, `HEAL_REPAIR`
4. User must resolve the integrity failure before normal operation resumes
