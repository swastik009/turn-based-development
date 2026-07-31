# Researching a contract, and grading the evidence

Expands rule 7 in `SKILL.md`. Read this before writing a client for an external API, model, or
service, and whenever two sources disagree about how something behaves.

## Grade what you have

These are not the same and should never be reported as if they were:

| Evidence | Confidence |
|---|---|
| a captured real response | fact |
| source code, read verbatim | near fact |
| documented example | strong |
| prose describing behaviour | weak — the wording may be loose |
| a summary of any of the above | **an inference, not a fact** |

**Go to the primary source, not a summary of it.** A summary of a README is not the README. If
the exact bytes matter — a delimiter, an escape sequence, a field name — find the actual source,
example, or response. Say which one you used.

## What research catches

Requirements that fail *silently*: a parameter that returns an empty result instead of an error
when omitted, a required header, a format that differs from the obvious guess. Those are the
expensive ones, because nothing crashes.

## When sources contradict each other

Do not quietly pick one. This happens more than you would expect: an implementation's own code
and a published example can disagree about something as small as which side a slash goes on —
and getting it wrong means the parser matches nothing, does nothing, and reports success.

The move is not to guess better. It is to **handle every variant you have seen, and raise on
anything you have not.** Then record it as an open item and go get the real answer.

That converts "we picked wrong and corrupted everything quietly" into "the first input tells us,
by name, which assumption was wrong." Being wrong becomes cheap and visible instead of expensive
and invisible.

**Then narrow it once you know.** Tolerating three possible formats is correct while you are
uncertain and wrong afterwards — a parser that handles worlds which do not exist is one nobody
can reason about later. Keep the guard; drop the guesswork.
