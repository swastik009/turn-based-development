# Adapting it

**Where to put it.** As `SKILL.md` in a skills directory if your tool supports skills, or as
project instructions (`CLAUDE.md`, `AGENTS.md`, `.cursorrules`), or simply pasted at the start of a
session. The rules do not depend on the tool.

**Keep project-specific detail out of `SKILL.md`.** Conventions that apply everywhere live there;
your stack, directory layout and definition of done belong in a project file. Mixing them makes
both harder to reuse.

The line falls between a published standard and a house style. Rule 4 requires Conventional Commits
with a scope, because that is a spec anyone can look up — but the *scope vocabulary* is yours, and
belongs in the project file alongside everything else on that list.

**Use `references/` for anything long.** `SKILL.md` stays resident for the whole session, so it
holds only the rules. Depth goes in
[`references/`](../skills/turn-based-development/references/) and is linked from the rule it belongs
to, so the agent opens it only when the situation calls for it. Two ship with the skill:

| File | Read when |
|---|---|
| [`make-being-wrong-loud.md`](../skills/turn-based-development/references/make-being-wrong-loud.md) | designing error handling, fallbacks, or anything parsing outside input |
| [`researching-contracts.md`](../skills/turn-based-development/references/researching-contracts.md) | two sources disagree, or the exact bytes matter |

Add your own the same way — API contracts, architecture decisions, domain notes.

**Tune the turn size.** One block per turn is right when the code is load-bearing or the stack is
unfamiliar. For a routine CRUD endpoint you may want a whole file per turn. Say which you want; do
not let it drift silently.

**The commit gate should never be relaxed.** It is the cheapest of these rules and the one that
preserves the most optionality.
