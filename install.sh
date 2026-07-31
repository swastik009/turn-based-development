#!/usr/bin/env bash
# Link this skill into every agent runtime installed on this machine.
#
# Canonical copy: skills/reviewable-increments/SKILL.md in this repo.
# Everything else is a symlink, so `git pull` updates every runtime at once.
set -euo pipefail

SKILL_NAME="reviewable-increments"
REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
SRC="$REPO/skills/$SKILL_NAME"

[ -f "$SRC/SKILL.md" ] || { echo "no SKILL.md at $SRC" >&2; exit 1; }

# Cross-runtime location. Claude Code, Codex, Copilot CLI and Gemini CLI are
# documented to read ~/.agents/skills; keep this the one real link target.
AGENTS_DIR="$HOME/.agents/skills"

link() {
  local dest="$1" target="$2"
  mkdir -p "$(dirname "$dest")"
  if [ -L "$dest" ]; then
    [ "$(readlink "$dest")" = "$target" ] && { echo "ok       $dest"; return; }
    rm "$dest"
  elif [ -e "$dest" ]; then
    echo "SKIP     $dest (exists and is not a symlink — move it aside first)" >&2
    return
  fi
  ln -s "$target" "$dest"
  echo "linked   $dest -> $target"
}

link "$AGENTS_DIR/$SKILL_NAME" "$SRC"

# Runtimes that keep their own skills directory point at the shared one.
for dir in "$HOME/.claude/skills" "$HOME/.codex/skills" "$HOME/.copilot/skills"; do
  parent="$(dirname "$dir")"
  [ -d "$parent" ] || continue          # runtime not installed here
  link "$dir/$SKILL_NAME" "$AGENTS_DIR/$SKILL_NAME"
done

echo
echo "Runtimes without a skills directory (Grok CLI, Cursor, plain API use):"
echo "  paste or include $SRC/SKILL.md directly — it is deliberately"
echo "  tool-agnostic and names no Claude-specific feature."
