---
name: infra-scaffolding
description: >-
  Tech stack detection, project scaffolding, CI/CD pipeline generation, health
  diagnostics, and deep project analysis. The infrastructure skill understands
  your project's shape and helps you build, verify, and deploy it.
---

# Infrastructure & Scaffolding

## Overview

The infra skill is the "hands" of the AI OS — it detects what you're working with,
scaffolds what you need, generates CI/CD pipelines, and runs health checks to verify
everything is working correctly.

## Commands

### INFRA_DETECT_STACK

Auto-detect the project's tech stack and architecture.

```
> OS_COMMAND INFRA_DETECT_STACK [--deep]
```

**Procedure:**
1. Scan workspace root for indicator files (see BOOT.md §2 Phase 3)
2. Parse detected config files for framework/library information
3. Identify architecture pattern (monorepo, single-app, library, API, CLI, etc.)
4. Assess project maturity indicators (README, license, CI, tests, contributors)
5. Write results to `genome/project_genome.json`
6. If `--deep`: Also analyze code structure for patterns, entry points, and module boundaries

**Output:** Project genome summary with detected stack, architecture, and maturity.

---

### INFRA_SCAFFOLD

Generate project structure from best practices.

```
> OS_COMMAND INFRA_SCAFFOLD --type=<project_type> [--stack=<stack>]
```

**Types:** `web-app`, `api-service`, `library`, `cli-tool`, `monorepo`, `fullstack`

**Procedure:**
1. Select template based on project type and detected/specified stack
2. Generate directory structure following stack-specific best practices:
   - Source directories, test directories, config files
   - README template, LICENSE selection, .gitignore
   - Linter/formatter configuration
   - TypeScript config (if applicable)
3. Initialize package manager (npm init, uv init, cargo init, etc.)
4. Present generated structure to user for approval before writing

---

### INFRA_SETUP_CI

Generate CI/CD pipeline configuration.

```
> OS_COMMAND INFRA_SETUP_CI --platform=<platform> [--stages=<stages>]
```

**Platforms:** `github-actions`, `gitlab-ci`, `azure-devops`, `circleci`

**Stages** (comma-separated): `lint`, `type-check`, `test`, `security-scan`, `build`, `deploy`

**Procedure:**
1. Detect project stack (or use cached genome)
2. Generate platform-specific pipeline configuration:
   - CI file with requested stages
   - Appropriate runner/image selection
   - Caching configuration for dependencies
   - Branch/PR trigger rules
3. Include AI OS security scan as a pipeline stage
4. Present generated config for user review

---

### INFRA_HEALTH_CHECK

Quick project health verification.

```
> OS_COMMAND INFRA_HEALTH_CHECK
```

**Procedure:**
1. **Build check**: Can the project build successfully?
2. **Lint check**: Do linting tools pass?
3. **Type check**: Do type checkers pass? (if applicable)
4. **Test check**: Do tests pass?
5. **Dependency check**: Are dependencies installed and lock file up to date?

**Output:** Health dashboard with pass/fail for each check.

---

### INFRA_DIAGNOSE

Deep project diagnostic.

```
> OS_COMMAND INFRA_DIAGNOSE [--focus=<area>]
```

**Focus areas:** `dependencies`, `build`, `tests`, `config`, `structure`, `all`

**Procedure:**
1. Run all HEALTH_CHECK verifications
2. Analyze dependency tree for issues (circular deps, outdated, deprecated)
3. Check configuration file consistency
4. Verify directory structure matches detected architecture pattern
5. Check for common anti-patterns (mixed config styles, orphaned files, etc.)
6. Generate detailed diagnostic report with recommendations

---

## Stack-Specific Best Practices

The infra skill references these best practices based on detected stack:

| Stack | Key Practices |
|---|---|
| **Node.js/TypeScript** | ESLint + Prettier, strict tsconfig, path aliases, barrel exports |
| **Python** | Ruff/Black formatting, mypy type checking, pyproject.toml over setup.py |
| **Rust** | Clippy lints, cargo fmt, workspace layout for multi-crate projects |
| **Go** | golangci-lint, go vet, standard project layout |
| **Java/Kotlin** | Checkstyle/ktlint, Gradle over Maven for new projects, JUnit 5 |
| **.NET/C#** | dotnet format, nullable reference types, minimal APIs |

## Common Mistakes

1. **Scaffolding before detecting** — Always run INFRA_DETECT_STACK first on existing projects.
2. **Overwriting existing CI** — Always check for existing pipeline files before generating new ones.
3. **Ignoring health check warnings** — A "passing" health check with warnings still has issues to address.
