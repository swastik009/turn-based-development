# Rationale

`SKILL.md` states the rules without arguing for them — that keeps it small, and the agent does not
need persuading. The arguments are here.

## Why the workflow is shaped this way

Slower per feature, faster per quarter:

- **Design errors get caught while they are still cheap.** A bug found in a spec costs a sentence.
  The same bug found after four files exist costs a refactor.
- **You keep the ability to say no.** A whole feature landing at once is take-it-or-leave-it. A
  block at a time is a conversation.
- **Explanations arrive when they are useful.** Not as a summary after the fact, but before the
  code exists, when you can still change your mind.
- **The agent's mistakes surface early.** Agents state inferences as facts. Frequent stops give you
  the chance to ask "how do you know that?" while it still matters.

The measure of success is not that the code works. It is that **you could have written it**, and
that you can still maintain it six months from now.

## What individual rules are protecting against

**One block per turn.** Being right is not the bar; your having control is the bar.

**Prove claims, don't assert them.** Things a green test run will happily hide: a fixture meant to
have zero pages that actually had one, so every test using it passed while asserting nothing. A
test for an optional dependency that would have passed with the dependency removed. A config test
that read the developer's local env file, so it would have passed against a broken default.

**Look it up at the source.** Memory is where confident wrong details come from. Reading the real
docs routinely surfaces requirements that fail *silently* — a parameter that returns an empty
result instead of an error when omitted, a required header, a format that differs from the obvious
guess. Nothing crashes, so nothing tells you.

**Don't rewrite the plan to match the outcome.** The as-built notes are often the most valuable
page in the repository: they record where the thinking was wrong, which is exactly what normally
evaporates.

**Record rejected alternatives.** Otherwise they get re-proposed every few sessions by someone —
possibly the agent — with no memory of the discussion.

## What it costs

It is slower to start, and it requires you to actually be present. That is the whole trade, stated
plainly: you are buying comprehension with time, and if you do not want to spend the time, the
workflow will feel like friction rather than control.
