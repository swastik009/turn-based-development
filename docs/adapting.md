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

## The hook

The description alone will not trigger the skill. A description answers *"what kind of task is
this?"*, so a model reading `add a retry helper` looks for a skill about retries. This is not a
kind of task — it is how you do any task, so there is nothing for it to match. On a clean test
repo it never fired: the skill sat correctly installed and unread while the agent edited files.
The hook exists because of that result, not in anticipation of it.

`hooks/hooks.json` runs [`hooks/session-start.sh`](../hooks/session-start.sh) at session start.
Two details in it are deliberate.

**It fires on `startup|clear|compact`.** Compaction discards the injected instruction along with
everything else, so without the `compact` matcher the workflow would quietly stop applying partway
through a long task — around the point the discipline matters most.

**Outside a git repo it says so rather than going quiet.** The skill genuinely does not apply
there; every gate it has is built on commits. But a hook that exits silently is indistinguishable
from a hook that is broken, so it explains itself and offers `git init` if this is a real project.
That is the same standard the skill holds code to — see
[make-being-wrong-loud.md](../skills/turn-based-development/references/make-being-wrong-loud.md).
