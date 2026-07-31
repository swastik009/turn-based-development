# Rationale

`SKILL.md` states the rules without arguing for them — that keeps it small, and the agent does not
need persuading. The arguments are here.

## This is not a constraint invented for agents

It is how the work already gets done. An engineer handed "build user accounts" does not start
typing — they split it into sign-up, then login, then password reset, and take them one at a
time, finishing one before opening the next.

The skill asks the agent to work at the granularity the engineer was going to review at anyway. A
task is one sitting; a turn is one reviewable piece of it. Neither unit is new — what is new is
the agent being held to them instead of delivering a finished branch and asking you to trust it.

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

## Is this a step backwards?

The obvious objection: agents were supposed to free us from supervising every edit, and this puts
the supervision back. Is this just a copilot with extra steps?

**Partly, yes — and deliberately.** Autonomy is genuinely what is being traded away. There is no
autonomous mode and no plan to add one, because an autonomous mode is not a feature of this
workflow, it is its negation.

But the objection conflates *autonomy* with *unsupervised*, and those are different axes.

A 2024 copilot was an autocomplete: no plan, no spec, no research, no reasoning it could defend.
Under this skill the agent still does the whole engineering job — reads the actual documentation
before designing against it, writes the spec, proposes a design and argues for it, writes tests
before implementations, and proves its own claims instead of asserting them. It does not do less.
It reports more often.

What actually changes is the **latency of oversight**, not its quantity. A tech lead who insists on
small pull requests is not nostalgic for 2015. Nobody argues that reviewing a junior engineer's
work means you have rejected the idea of hiring juniors.

Three things worth weighing before dismissing it:

**Review is the bottleneck, not generation.** Once an agent can produce more code per hour than
anyone can read carefully, time saved generating code nobody understands is borrowed against a
maintenance bill that comes due later, to someone, possibly you.

**Autonomy is a dial, not a direction.** This is calibrated for one setting: load-bearing code, an
unfamiliar stack, a repository you personally maintain. For shipping a well-specified feature
against a plan you trust, it is the wrong tool and
[the comparison](comparison.md) says so explicitly and recommends the alternative.

**The autonomous tools are adding gates too.** Plan modes, spec requirements, checkpoints, halting
before irreversible operations. The disagreement is not gates versus no gates. It is where they go
— and this puts one before the commit rather than after it.

### The condition under which this is wrong

This is a bet that comprehension compounds and raw speed does not. The bet has a losing case, and
it is worth naming: **if model reliability improves enough that unreviewed code stays maintainable
anyway, the overhead here buys nothing.**

That is an empirical question, not a philosophical one, and it will be settled by evidence rather
than argument. If you find that six months of unreviewed agent output left you with a codebase you
can still change confidently, this skill is not for you and you should not use it.
