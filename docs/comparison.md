# Versus `incremental-implementation`

The nearest existing thing is [addyosmani/agent-skills](https://github.com/addyosmani/agent-skills)
— its [`incremental-implementation`](https://github.com/addyosmani/agent-skills/blob/main/skills/incremental-implementation/SKILL.md)
skill and the [`/build`](https://github.com/addyosmani/agent-skills/blob/main/.claude/commands/build.md)
command that drives it. It is mature and well-built, and the overlap is real: both work one unit at
a time, both run a test-driven loop per unit, both commit each unit separately, both carry a
rationalisation table, and both forbid *"while I'm here"* scope creep. If you already use it, read
this before adding a second skill on top.

Two things genuinely differ.

## 1. What a unit is for

`incremental-implementation` sizes a slice so the system stays *deployable* — a slice is a vertical
cut through the stack, and its own example is `Slice 1: Create a task (DB + API + basic UI)`. Every
slice ends working end-to-end.

Reviewable Increments sizes a turn so a human can *read* it. Those goals pull in opposite
directions: a slice that leaves the system working necessarily spans files, and a change small
enough to review carefully usually cannot.

Both skills say so themselves. `incremental-implementation` triggers on *"any feature or change
that touches more than one file"* and lists **`When NOT to use: single-file, single-function
changes where the scope is already minimal.`** Rule 2 here treats *"several files in one turn"* as
a violation. Each switches off roughly where the other switches on.

## 2. Which side of the commit the human stands on

`incremental-implementation`'s cycle is *Implement → Test → Verify → **Commit** → Next slice*,
where commit means *"save your progress with a descriptive message."* No approval step. `/build`'s
default loop likewise ends *"7. Commit with a descriptive message → 8. Mark the task complete and
stop"* — it commits, then stops. The gate is that tests passed.

Here the turn ends *before* the commit, and the agent asks two things — is this message right, and
please review this — every time, approval never carrying forward. The gate is that a person read
the diff.

## Side by side

| | `incremental-implementation` | this |
|---|---|---|
| Slice sized for | staying deployable | staying readable |
| Unit of work | vertical cut through the stack | one coherent block, one file |
| Human gate | none per unit; upfront-only in `/build auto` | before every commit, always |
| Gate condition | tests pass, build succeeds | a person read it |
| Batch escape hatch | `/build auto` — one approval, then the whole plan | none by design |
| Explains its approach first | — | rule 1 |
| Grades its sources | — | rule 7 |
| Halts on irreversible actions | in `auto` mode, by category | rule 9, by predicate |

## Which to use

**`incremental-implementation`** when you trust the plan and want throughput — there is a spec, the
tasks are understood, and passing tests are assurance enough. It is the better tool for shipping a
known feature.

**This** when the point is that you personally understand and can maintain the result, and you are
willing to be present for it.

Rule 9 is a debt to `/build`, which halts on *"anything you can't undo with `git revert`"* — a
sharper predicate than any category list, and worth adopting.
