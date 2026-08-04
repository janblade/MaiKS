#!/usr/bin/env bash
# Claude Code SessionStart hook for the AI OS Framework (MaiKS).
#
# Injects the verbatim content of BOOT.md and rules/ultimate_rules.md directly
# into session context via hookSpecificOutput.additionalContext, instead of
# just telling the agent to go re-read them. A printed reminder still depends
# on the agent choosing to act on it afterward; this makes boot state present
# in context unconditionally, the moment the hook fires (startup/clear/compact).
set -euo pipefail

PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$(cd "$(dirname "$0")/../.." && pwd)}"
BOOT_FILE="${PROJECT_DIR}/.ai-os/BOOT.md"
RULES_FILE="${PROJECT_DIR}/.ai-os/rules/ultimate_rules.md"

boot_content=$(cat "$BOOT_FILE" 2>&1 || echo "Error reading BOOT.md")
rules_content=$(cat "$RULES_FILE" 2>&1 || echo "Error reading ultimate_rules.md")

# Escape for JSON embedding via bash parameter substitution (single C-level
# pass per replacement, not a character-by-character loop).
escape_for_json() {
    local s="$1"
    s="${s//\\/\\\\}"
    s="${s//\"/\\\"}"
    s="${s//$'\n'/\\n}"
    s="${s//$'\r'/\\r}"
    s="${s//$'\t'/\\t}"
    printf '%s' "$s"
}

boot_escaped=$(escape_for_json "$boot_content")
rules_escaped=$(escape_for_json "$rules_content")

context="<AI_OS_BOOT_STATE>\nThis project is governed by the AI OS Framework (MaiKS). Below is the full, verbatim content of .ai-os/BOOT.md and .ai-os/rules/ultimate_rules.md, injected directly so boot state is present from the first message and survives /clear and compaction without depending on a manual re-read.\n\n--- .ai-os/BOOT.md ---\n${boot_escaped}\n\n--- .ai-os/rules/ultimate_rules.md ---\n${rules_escaped}\n</AI_OS_BOOT_STATE>"

# Pure JSON on stdout only - for SessionStart this is fed directly into context.
printf '{\n  "hookSpecificOutput": {\n    "hookEventName": "SessionStart",\n    "additionalContext": "%s"\n  }\n}\n' "$context"

exit 0
