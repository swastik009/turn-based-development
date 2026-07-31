# Reviewable Increments

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
Task 2/4 — Rate limit the API client
Turn 1/4 — token bucket helper
```

Approval never carries to the next turn. Ten tasks might be sixty turns — that is the intent, not
overhead.

## Install

```bash
git clone https://github.com/swastik009/reviewable-increments.git
cd reviewable-increments
./install.sh
```

Symlinks the skill into `~/.agents/skills/` and points each installed runtime at it, so
`git pull` updates all of them. Claude Code also reads `~/.claude/skills/`; Codex, Copilot CLI
and Gemini CLI read `~/.agents/skills/`. For Cursor, Grok CLI or direct API use, paste
[`SKILL.md`](skills/reviewable-increments/SKILL.md) into your rules file — it names no
Claude-specific feature.

Claude Code, without cloning:

```
/plugin marketplace add swastik009/reviewable-increments
/plugin install reviewable-increments@reviewable-increments
```

## When not to use it

If you want to describe a feature and come back to a finished branch, this is the wrong tool —
pick a different one deliberately rather than eroding this one turn by turn. There is no
autonomous mode, because an autonomous mode would defeat the point.

Already using [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)? It overlaps —
[docs/comparison.md](docs/comparison.md) covers what differs and when its `incremental-implementation`
is the better choice.

## Read next

- [**The skill**](skills/reviewable-increments/SKILL.md) — 11 rules, the whole product
- [Rationale](docs/rationale.md) — why each rule exists, and what it costs
- [Comparison](docs/comparison.md) — versus `incremental-implementation`
- [Adapting it](docs/adapting.md) — project files, `references/`, tuning turn size

## License

MIT — see [LICENSE](LICENSE).
