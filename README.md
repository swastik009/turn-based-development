# Turn-Based Development

An agent skill for engineers who want granular control over what an AI agent writes.

## Why

Agents produce code faster than anyone can review it. You read it in bulk, it mostly works, you
ship it — and months later you are reading your own repository like a stranger.

This is built on the premise that writing the code and maintaining it later are the same job. It
keeps you in the conversation while the design is still being decided, gives the agent's work a
review it actually has to pass, and leaves you owning every line rather than inheriting it.

It is for engineers, not for throughput. The trade is deliberate.

## Turns

A project has tasks. **Each task is split into several turns**, and a turn — not the task — is
the unit of work: one coherent block of change, roughly a function, a class, or one cohesive
edit.

Before starting a task, the agent lists that task's turns and asks you to agree them. Then, each
turn, it:

1. explains the approach **before** writing it — what, why, what else it considered, what it costs
2. writes one block, and stops
3. shows the exact files and commit message, and asks you to review before anything lands

```
Turn 2 — the implementation
```

The agreed turn list lives in `tasks/plan.md` and is ticked off as each one lands, so progress is
something you check rather than something the agent remembers.

Approval never carries to the next turn. Ten tasks might be sixty turns — that is the intent, not
overhead.

## Install

```bash
git clone https://github.com/swastik009/turn-based-development.git
cd turn-based-development
./install.sh
```

Symlinks the skill into `~/.agents/skills/` and points each installed runtime at it, so
`git pull` updates all of them. Claude Code also reads `~/.claude/skills/`; Codex, Copilot CLI
and Gemini CLI read `~/.agents/skills/`. For Cursor, Grok CLI or direct API use, paste
[`SKILL.md`](skills/turn-based-development/SKILL.md) into your rules file — it names no
Claude-specific feature.

Claude Code, without cloning — **this route also installs the trigger below**:

```
/plugin marketplace add swastik009/turn-based-development
/plugin install turn-based-development@turn-based-development
```

## Making it actually fire

Installing the skill is not enough, and this is the part everyone gets wrong.

A skill's `description` answers *"what kind of task is this?"* — so a model reads
`add a retry helper` and looks for a skill about retries. This isn't a kind of task. It is how
you do **any** task, so there is no request for it to match against. Tested on a real repo, it
did not fire once. The skill sat correctly installed and unread while the agent edited files.

Something has to *tell* the agent it exists. Pick one:

| | Covers | Setup |
|---|---|---|
| **Plugin install** | every git repo | none — [`hooks/hooks.json`](hooks/hooks.json) ships with it |
| **`CLAUDE.md` line** | one repo | one line, no config |
| **`/turn-based-development`** | one session | type it |

If you installed with `install.sh` rather than as a plugin, the hook does not come with it — a
shell script quietly editing your global settings would be worse than the problem. Either add
[`hooks/hooks.json`](hooks/hooks.json)'s `SessionStart` entry to `~/.claude/settings.json`
yourself, or use the `CLAUDE.md` route:

```markdown
**Use the `turn-based-development` skill for all work in this repository.** Load it before the
first file edit or commit — not only at the start of a session.
```

The shipped hook fires on `startup|clear|compact` and stays silent outside a git repo. The
`compact` matcher matters: compaction discards the injected instruction along with everything
else, so without it the workflow quietly stops applying partway through a long task.

## When not to use it

If you want to describe a feature and come back to a finished branch, this is the wrong tool —
pick a different one deliberately rather than eroding this one turn by turn. There is no
autonomous mode, because an autonomous mode would defeat the point.

Already using [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)? It overlaps —
[docs/comparison.md](docs/comparison.md) covers what differs and when its `incremental-implementation`
is the better choice.

## Read next

- [**The skill**](skills/turn-based-development/SKILL.md) — 11 rules, the whole product
- [Rationale](docs/rationale.md) — why each rule exists, and what it costs
- [Comparison](docs/comparison.md) — versus `incremental-implementation`
- [Adapting it](docs/adapting.md) — project files, `references/`, tuning turn size

## License

MIT — see [LICENSE](LICENSE).
