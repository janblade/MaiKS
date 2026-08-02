> **Orphaned — swept by MEMORY_CONSOLIDATE (EP-23, core.memory.sk).** No branch matches
> this task file (only `main` exists in this repo) and its content was never promoted via
> a proper TASK_CLOSE. The underlying proposal was independently applied via a direct
> KERNEL OVERRIDE in a later session (see `decisions.jsonl` 2026-07-22T09:40:00+08:00) and
> is already reflected in `progress.md`'s EP-8 entry as APPLIED — this file's own
> "Status: PROPOSED" below was simply never updated. Kept here for the historical record,
> not as a source of unconfirmed truths.

## Evolution Proposal: EP-8
- **Date**: 2026-07-22T09:39:25+08:00
- **Type**: memory_update
- **Target**: .agents/AGENTS.md and .ai-os-installer/templates/*
- **What**: Inject the "Deep-Thinking Protocol" into all agent instruction templates. This mandates that agents utilize a `<thinking>` block for constraint analysis, decomposition, hypothesis generation, and verification before outputting their final responses.
- **Why**: Modern fast LLMs (like Gemini Flash) benefit massively from forced Chain-of-Thought (CoT). By placing this at the top-level IDE workspace instructions, we instantly upgrade all agents running in this framework to behave like deliberate "Thinking" models without requiring a KERNEL OVERRIDE on `BOOT.md`.
- **Risk**: Medium (Fundamentally alters the output format and token usage of all agent responses).
- **Rollback Plan**: Revert the additions in `.agents/AGENTS.md` and the installer templates.
- **Rules Check**: Complies with R3 (User space is read-write).
- **Status**: PROPOSED
