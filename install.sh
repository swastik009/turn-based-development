#!/usr/bin/env bash
# Link this skill into every agent runtime installed on this machine.
#
# Canonical copy: skills/turn-based-development/SKILL.md in this repo.
# Everything else is a symlink, so `git pull` updates every runtime at once.
set -euo pipefail

SKILL_NAME="turn-based-development"
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

# ---------------------------------------------------------------------------
# The trigger. Linking the skill does not make it run: a skill description says
# what kind of task it suits, and this suits every task, so nothing matches it.
# Claude Code needs a SessionStart hook to be told the skill exists.
#
# This edits ~/.claude/settings.json, so it asks first and backs up before
# writing. Skip it and the skill still installs — you just invoke it by hand
# with /turn-based-development, or add a line to a project's CLAUDE.md.
# ---------------------------------------------------------------------------
install_hook() {
  local settings="$HOME/.claude/settings.json"
  local script="$REPO/hooks/session-start.sh"

  [ -d "$HOME/.claude" ] || { echo "skip     hook (Claude Code not installed here)"; return; }
  [ -f "$script" ] || { echo "SKIP     hook ($script missing)" >&2; return; }
  command -v python3 >/dev/null 2>&1 || { echo "SKIP     hook (needs python3 to edit JSON safely)" >&2; return; }
  chmod +x "$script"

  if [ -f "$settings" ] && grep -q 'turn-based-development/hooks/session-start.sh' "$settings" 2>/dev/null; then
    echo "ok       hook already in $settings"
    return
  fi

  echo
  echo "The skill will not fire on its own. A SessionStart hook in"
  echo "  $settings"
  echo "tells Claude Code to load it in any git repository."
  printf "Add it? [y/N] "
  read -r reply || reply=""
  case "$reply" in
    [yY]*) ;;
    *) echo "skip     hook — use /turn-based-development, or a CLAUDE.md line"; return ;;
  esac

  [ -f "$settings" ] && cp "$settings" "$settings.bak.$(date +%s)" && echo "backup   $settings.bak.*"

  SETTINGS="$settings" SCRIPT="$script" python3 - <<'PY'
import json, os, pathlib
p = pathlib.Path(os.environ["SETTINGS"])
cfg = json.loads(p.read_text()) if p.exists() and p.read_text().strip() else {}
entry = {
    "matcher": "startup|clear|compact",
    "hooks": [{
        "type": "command",
        "command": f'"{os.environ["SCRIPT"]}"',
        "shell": "bash",
        "async": False,
        "timeout": 5,
        "statusMessage": "Checking workflow",
    }],
}
cfg.setdefault("hooks", {}).setdefault("SessionStart", []).append(entry)
p.parent.mkdir(parents=True, exist_ok=True)
p.write_text(json.dumps(cfg, indent=2) + "\n")
PY
  echo "hooked   $settings -> $script"
  echo "         open /hooks once, or restart, for it to take effect"
}

install_hook

echo
echo "Runtimes without a skills directory (Grok CLI, Cursor, plain API use):"
echo "  paste or include $SRC/SKILL.md directly — it is deliberately"
echo "  tool-agnostic and names no Claude-specific feature."
