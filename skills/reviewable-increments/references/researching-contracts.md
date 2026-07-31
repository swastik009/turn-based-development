# When sources contradict each other

Expands rule 7 in `SKILL.md`, which covers grading a source. This covers the harder case: two
sources you trust that do not agree.

Do not quietly pick one. This happens more than you would expect — an implementation's own code
and a published example can disagree about something as small as which side a slash goes on, and
getting it wrong means the parser matches nothing, does nothing, and reports success.

**The move is not to guess better. It is to handle every variant you have seen, and raise on
anything you have not.** Then record it as an open item and go get the real answer.

That converts *"we picked wrong and corrupted everything quietly"* into *"the first input tells
us, by name, which assumption was wrong."* Being wrong becomes cheap and visible instead of
expensive and invisible.

**Then narrow it once you know.** Tolerating three possible formats is correct while you are
uncertain and wrong afterwards — a parser that handles worlds which do not exist is one nobody can
reason about later. Keep the guard; drop the guesswork.

## Two distinctions worth keeping

**A documented example beats prose describing behaviour.** Both are documentation, but an example
is executable intent and prose is a summary someone wrote from memory. When they disagree, trust
the example.

**"Exact bytes" is a different question from "roughly how does this work".** A delimiter, an escape
sequence, a field name — for these, a captured real response is the only thing that settles it. No
amount of reading prose gets you there.
