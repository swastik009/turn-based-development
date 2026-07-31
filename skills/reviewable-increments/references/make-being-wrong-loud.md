# Make being wrong loud

An engineering principle, not a workflow rule. It is the natural partner of rules 6 and 7 in
`SKILL.md`, and agents violate it by default: asked to make something robust, an agent will reach
for a fallback, and a fallback is usually a silent failure wearing a helpful costume.

**The failure that matters is not the one that crashes. It is the one that succeeds.**

Rank failures by how detectable they are, not by how bad they look:

| Failure | Cost |
|---|---|
| crashes immediately | cheap — you know instantly |
| returns an error | cheap — the caller decides |
| **returns a plausible wrong answer** | **expensive — nobody ever finds out** |

A crash is a bad afternoon. A pipeline that silently processed 80% of every input for six months
is a data problem you cannot repair, because you no longer know which records are affected.

## What this means in practice

**Refuse to guess.** If a call returns something you cannot interpret, raise. Do not substitute a
default, do not return empty, do not carry on with partial data.

**No fallback chains by default.** *"If the good path fails, try the degraded one"* sounds
robust and usually is not: it converts a loud failure into a quiet, lower-quality success that
nothing downstream can distinguish from the real thing. If you do want a fallback, make it a
deliberate, recorded decision — and mark the output so consumers know which path produced it.

**Assert the invariants you assume.** If a step should never produce an empty result, check that
it did not. The check costs one line and is the only alarm for an entire class of
misconfiguration that otherwise returns success.

**Distinguish "the service is down" from "this input is bad".** They need different exception
types because they need opposite responses: retry later, versus stop and report. Collapsing them
means either retrying forever on a broken input, or permanently rejecting a good one because a
dependency blinked.

**Watch for success responses that are not successes.** A `200` with a truncated body. A parse
that returns an empty string because the format changed. An API that reports OK and silently
dropped half your payload. These are the ones worth writing tests for, because they are the ones
no one notices.

**Carry provenance with derived data.** When a value can be produced by more than one path — an
exact copy versus a model's best guess — record which one produced it. Returning only the value
throws away the single most important thing about it, and you cannot reconstruct it later.

## The trade-off, stated honestly

Strict failure rejects inputs a lenient system would have half-processed. Some of those
rejections are annoying and some are genuinely inconvenient for users.

Take that trade anyway when the output feeds something irreversible, or when nothing downstream
could detect the degradation. Do not take it reflexively everywhere — for a UI that can show a
placeholder, degrading is often right. The question is always: **if this is wrong, will anyone
ever find out?** If the answer is no, fail loudly.
