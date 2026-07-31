# Reviewable Increments

An agent skill for building software *with* an AI agent instead of *from* one.

The default agent workflow produces a lot of code quickly. Twenty files change at once, you
review it in bulk, it mostly works — and three weeks later you are reading your own repository
like a stranger.

This skill makes the **turn** the unit of work instead. A task is split into turns before any
code is written; each turn is one coherent block of change; the agent stops, shows you the
commit message, asks you to review it, and does not move on until you have answered. Plans get
explained before they are built, not summarised after. Facts get looked up at the source rather
than recalled.

The measure of success is not that the code works. It is that **you could have written it**, and
that you can still maintain it six months from now.

Read [the skill itself](skills/reviewable-increments/SKILL.md) — it is the whole product.

## Why this exists

It is slower per feature and faster per quarter, because:

- **You catch design errors while they are still cheap.** Bugs found in a spec cost a sentence.
  The same bug found after four files exist costs a refactor.
- **You keep the ability to say no.** A whole feature landing at once is take-it-or-leave-it. A
  block at a time is a conversation.
- **Explanations arrive when they are useful.** Not as a summary after the fact, but before the
  code exists, when you can still change your mind.
- **The agent's mistakes surface early.** Agents state inferences as facts. A workflow with
  frequent stops gives you the chance to ask "how do you know that?" while it still matters.

## What the rules are actually protecting against

`SKILL.md` states the rules without arguing for them — that keeps it small, and the agent does
not need persuading. The arguments are here.

**One block per turn.** Being right is not the bar; your having control is the bar. A whole
feature landing at once is take-it-or-leave-it. A block at a time is a conversation.

**Prove claims, don't assert them.** Things a green test run will happily hide: a fixture meant
to have zero pages that actually had one, so every test using it passed while asserting nothing.
A test for an optional dependency that would have passed with the dependency removed. A config
test that read the developer's local env file, so it would have passed against a broken default.

**Look it up at the source.** Memory is where confident wrong details come from. Reading the real
docs routinely surfaces requirements that fail *silently* — a parameter that returns an empty
result instead of an error when omitted, a required header, a format that differs from the
obvious guess. Nothing crashes, so nothing tells you.

**Don't rewrite the plan to match the outcome.** The as-built notes are often the most valuable
page in the repository: they record where the thinking was wrong, which is exactly what normally
evaporates.

**Record rejected alternatives.** Otherwise they get re-proposed every few sessions by someone —
possibly the agent — with no memory of the discussion.

## How this differs from `/build`

The nearest existing thing is [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
— its [`incremental-implementation`](https://github.com/addyosmani/agent-skills/blob/main/skills/incremental-implementation/SKILL.md)
skill and the [`/build`](https://github.com/addyosmani/agent-skills/blob/main/.claude/commands/build.md)
command that drives it. It is mature and well-built, and the overlap with this is real: both work
one unit at a time, both run a test-driven loop per unit, both commit each unit separately, both
carry a rationalisation table, and both forbid *"while I'm here"* scope creep. If you already use
it, read this section before adding a second skill on top.

Two things genuinely differ.

**1. What a unit is for.** `incremental-implementation` sizes a slice so the system stays
*deployable* — a slice is a vertical cut through the stack, and its own example is
`Slice 1: Create a task (DB + API + basic UI)`. Every slice ends working end-to-end.

This sizes a turn so a human can *read* it. Those goals pull in opposite directions: a slice that
leaves the system working necessarily spans files, and a change small enough to review carefully
usually cannot.

The two skills say so themselves. `incremental-implementation` triggers on *"any feature or change
that touches more than one file"* and lists **`When NOT to use: single-file, single-function
changes where the scope is already minimal.`** Rule 2 here treats *"several files in one turn"* as
a violation. Each switches off roughly where the other switches on.

**2. Which side of the commit the human stands on.** `incremental-implementation`'s cycle is
*Implement → Test → Verify → **Commit** → Next slice*, where commit means *"save your progress
with a descriptive message."* No approval step. `/build`'s default loop likewise ends *"7. Commit
with a descriptive message → 8. Mark the task complete and stop"* — it commits, then stops. The
gate is that tests passed.

Here the turn ends *before* the commit, and the agent asks two things — is this message right, and
please review this — every time, approval never carrying forward. The gate is that a person read
the diff.

| | `incremental-implementation` | this |
|---|---|---|
| Slice sized for | staying deployable | staying readable |
| Unit of work | vertical cut through the stack | one coherent block, one file |
| Human gate | none per unit; upfront-only in `/build auto` | before every commit, always |
| Gate condition | tests pass, build succeeds | a person read it |
| Batch escape hatch | `/build auto` — one approval, then the whole plan | none by design |
| Explains its approach first | — | rule 1 |
| Grades its sources | — | rule 8 |
| Halts on irreversible actions | in `auto` mode, by category | rule 11, by predicate |

**Use `incremental-implementation`** when you trust the plan and want throughput — there is a
spec, the tasks are understood, and passing tests are assurance enough. It is the better tool for
shipping a known feature.

**Use this** when the point is that you personally understand and can maintain the result, and you
are willing to be present for it. It is slower, and it has no autonomous mode, because an
autonomous mode would defeat the reason it exists.

Rule 11 is a debt to `/build`, which halts on *"anything you can't undo with `git revert`"* — a
sharper predicate than any category list, and worth adopting.

## What it costs

Honestly: it is slower to start, and it requires you to actually be present. If you want to
describe a feature and come back to a finished branch, this is the wrong workflow — use a
different one deliberately rather than eroding this one turn by turn.

## Install

```bash
git clone https://github.com/swastik009/reviewable-increments.git
cd reviewable-increments
./install.sh
```

`install.sh` symlinks the skill into `~/.agents/skills/` (the shared cross-runtime location) and
points each installed runtime's own skills directory at it. Because every location is a symlink
to this repo, `git pull` updates all of them at once.

### Per-runtime notes

| Runtime | How it picks the skill up |
|---|---|
| Claude Code | `~/.claude/skills/` — auto-invoked from the `description`, or run `/reviewable-increments` |
| Codex, Copilot CLI, Gemini CLI | `~/.agents/skills/` |
| Grok CLI, Cursor, direct API use | no skills directory — include `SKILL.md` in the system prompt or project rules file |

The skill body names no Claude-specific feature, so the last row loses nothing but the automatic
loading.

### Claude Code, without cloning

This repo is also a Claude Code plugin marketplace:

```
/plugin marketplace add swastik009/reviewable-increments
/plugin install reviewable-increments@reviewable-increments
```

## Adapting it

**Where to put it.** As `SKILL.md` in a skills directory if your tool supports skills, or as
project instructions (`CLAUDE.md`, `AGENTS.md`, `.cursorrules`), or simply pasted at the start of
a session. The rules do not depend on the tool.

**Keep project-specific detail out of `SKILL.md`.** Conventions that apply everywhere live there;
your stack, directory layout and definition of done belong in a project file. Mixing them makes
both harder to reuse.

The line falls between a published standard and a house style. Rule 4 requires Conventional
Commits with a scope, because that is a spec anyone can look up — but the *scope vocabulary* is
yours, and belongs in the project file alongside everything else on that list.

**Use `references/` for anything long.** `SKILL.md` stays resident for the whole session, so it
holds only the rules. Depth goes in
[`references/`](skills/reviewable-increments/references/) and is linked from the rule it belongs
to, so the agent opens it only when the situation calls for it. Two ship with the skill:

| File | Read when |
|---|---|
| [`make-being-wrong-loud.md`](skills/reviewable-increments/references/make-being-wrong-loud.md) | designing error handling, fallbacks, or anything parsing outside input |
| [`researching-contracts.md`](skills/reviewable-increments/references/researching-contracts.md) | writing against an external API, or two sources disagree |

Add your own the same way — API contracts, architecture decisions, domain notes.

**Tune the block size.** "One block per turn" is right when you are learning a stack or the code
is load-bearing. For a familiar CRUD endpoint you may want a whole file per turn. Say which you
want; do not let it drift silently.

**The commit gate should never be relaxed.** It is the cheapest of these rules and the one that
preserves the most optionality.

## License

MIT — see [LICENSE](LICENSE).
