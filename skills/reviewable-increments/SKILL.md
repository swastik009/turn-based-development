---
name: reviewable-increments
description: Use when about to edit files or make commits in a repository the engineer maintains themselves - including sessions that began as a question, a review, a small fix, or work on the tooling itself and grew into real changes. Check at the point of the first write or commit, not only at the start of a session.
---

# Reviewable Increments

The unit of work is a **turn**: one coherent block of change, reviewed by the engineer, committed
on its own with their approval. Split every task into turns before writing code.

```
brainstorm → spec → plan → turn → review → commit → turn → … → docs sync
```

Each arrow is a gate. Nothing passes one on the agent's own judgement.

## Precedence

Incompatible with `superpowers:subagent-driven-development` by design — that skill forbids
checking in between tasks; this one exists to check in. **When both load, this one governs.**

Compose freely *inside* a turn: `test-driven-development`, `systematic-debugging`,
`verification-before-completion`.

## Rules

Not preferences. An agent that "improves" on these has broken the workflow.

### 1. Explain a new plan before writing it

Triggers on: a new approach, a new dependency, a pattern not already in the repo. Explain
*before* the code exists — an explanation delivered alongside finished code is a summary.

1. **What it is** — one sentence, no term that itself needs explaining.
2. **The problem it solves** — what breaks or gets error-prone without it.
3. **The alternative, named** — "we could use X; we aren't, because Y."
4. **The trade-off** — what got worse.

Parts 3 and 4 are mandatory. No cost stated means a default was pattern-matched rather than
chosen; if that is the case, say so explicitly. For a concept from an ecosystem the engineer uses
less often, name its analogue in one they do: *"`Depends` is a `before_action` that returns a
value instead of setting an instance variable"*, not *"this uses FastAPI's `Depends`"*.

### 2. One block per turn, then stop

Roughly a function, a class, or one cohesive change.

Violations, even when the result is correct and the tests pass:

- a complete file in one turn
- several files in one turn
- a test suite in the same turn as the code it tests
- a second block because the first "obviously" needed it

Turn size is the engineer's to set. Ask which; never widen a turn on your own.

### 3. Test and implementation are separate turns

Write the test. Run it. Confirm it fails for the right reason — a missing module, not a typo in
the test. Stop. Implement in the next turn.

### 4. Ask before every commit, and ask for review

Stop and ask both:

- "Here is the exact message and the exact files — is this message right?"
- "Please review this before I commit."

Every time, including "obviously done" fixes and mid-task commits. Approval never carries
forward. Finishing an edit is not permission to commit it.

### 5. Do not start the next change until the commit is resolved

Committed, deferred, or declined — but answered. *"This next bit is related, I'll fold it in"* is
how one reviewable commit becomes an end-of-session pile.

### 6. Never transplant unreviewed code

Nothing arrives from a stash, another branch, an old commit, a sibling repo, or a previous
session — not by `stash pop`, and not by copying its contents into a file either. Recovered work
re-enters through review.

### 7. Prove claims, do not assert them

Break the thing a test guards and show it fail. Check a fixture's actual bytes. Vary a limit and
measure that it binds. A green run is not evidence that a test asserts anything.

Partner principle: `references/make-being-wrong-loud.md` — read before designing error handling,
fallbacks, or anything parsing input from outside the repo.

### 8. Look it up at the source, never from memory

Read the actual docs or source before writing against any external API, library, model, or
service. Name the source used and grade it: a captured response is fact, verbatim source is
near-fact, prose describing behaviour is weak, a summary of any of those is an inference. Report
inferences as inferences.

When sources disagree, or the exact bytes matter: `references/researching-contracts.md`.

### 9. Docs change in the same commit as the code

Behaviour changed → update the spec. Convention changed → update the agent instructions. Plan
moved → update the status section. Drift is a bug, not tidying.

### 10. Record rejected alternatives with reasons

A rejected option with a stated reason is a decision. Without one it is an oversight, and gets
re-proposed every few sessions.

### 11. Escalate anything the repo cannot take back

Rules 2 and 4 assume a bad turn costs a `git revert`. Some changes escape that: a dropped column,
a rotated secret, a deploy, a deleted branch, a sent email, a paid API call at volume.

**Test: if this turn is wrong, can the repository undo it alone?** If no, do not treat it as a
normal turn. Name the effect that outlives the commit, say what would have to happen to reverse
it, and get explicit sign-off on that specific action — approving the code is not approving the
consequence.

## Turn structure

Every turn contains:

1. **The change** — one block.
2. **Evidence** — actual command output, not a claim about it.
3. **Notable** — a decision made, a trade-off taken, something surprising found.
4. **Uncertain** — anything guessed, assumed, or unverified.
5. **A stop** — the next step named, and a question.

Point 4 is not optional. *"I inferred this from the docs but have not confirmed it against the
real service"* is the highest-value line in a turn.

## Spec and plan

**Spec** — written after design discussion, before code. Records what is being built, the
decisions and their reasons, the error paths, the testing approach. Committed and reviewed like
code.

**Plan** — breaks the spec into turns. Exact files, real code per step, no placeholders: no
"TBD", no "add appropriate error handling", no "similar to step 3".

When plan and outcome diverge, **do not rewrite the plan to match.** Append an as-built note per
deviation, with the reason.

## Anti-patterns

| Agent says | Means |
|---|---|
| "I'll also fix X while I'm here" | scope creep; X gets no review |
| "Tests pass" *(no output shown)* | unverified claim |
| "This is a simple change, so..." | simple changes are where unreviewed code hides |
| "As you know…" | skipping an explanation the engineer may need |
| "I've updated several files" | review is no longer possible |
| "Following best practice" | no reason given; give the actual one |
| "This should work" | it was not run |
| *silence about an assumption* | the most expensive failure mode |
