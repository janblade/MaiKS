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
