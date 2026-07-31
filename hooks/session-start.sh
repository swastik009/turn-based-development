#!/usr/bin/env bash
# Injected into the model's context at session start.
#
# In a git repo: tell the agent to load the skill.
# Outside one: say so, and say why — the skill's gates are built on commits, so
# it genuinely does not apply. Staying silent here would look identical to the
# hook being broken, and a failure nobody can see is the one that costs most.
set -uo pipefail

emit() {
  printf '{"hookSpecificOutput":{"hookEventName":"SessionStart","additionalContext":"%s"}}' "$1"
}

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  emit "This is a git repository. Use the turn-based-development skill for work here: split the task into turns, agree the list with the engineer before starting, and stop for review before every commit. Load it before the first file edit or commit, including for changes that look too small to need it."
else
  emit "This directory is not a git repository, so the turn-based-development skill does not apply - every one of its gates is built on commits. If the engineer is starting a real project here rather than a scratch directory, say so and offer to run git init; then the workflow applies from the first turn."
fi
