---
name: user-summary
description: Summarize a set of changes for end users — grouped by screen, one line per point, max 10 words each. Use when asked for a user-focused summary, release-note bullets, a PR description for non-engineers, "summarize the changes", "foglald össze a változásokat", or "mit vettem észre belőle felhasználóként".
---

# User-focused change summary

Describe what a user notices, not what the code does.

## Output shape

Markdown. `**Bold surface name**` headings, bullets under each. No preamble, no closing line.

```
**Log event details**
- Finding no longer shrinks the matched value to fragments

**AI-assisted parsing**
- Long values now wrap fully instead of being cut off (like in log event details)
```

## Rules

1. **Max 10 words per bullet.** Count them. Split or cut if over.
2. **Group by user-visible surface** — the screen, panel or page a user can name. Never by file, layer, or library.
3. **Write the observable effect**, not the mechanism. No component names, file paths, or type names.
4. **Attribute to where it is actually new.** A behaviour that already worked on screen A and only now reaches screen B belongs under B — with `(like in screen A)` appended.
5. **Verify "new".** Check `git log`/`git diff` against the base before claiming anything is new; work already present in the tree or already shipped is not.
6. **Skip invisible changes.** Refactors, extractions and renames earn a bullet only if behaviour changed. One "same component as X" bullet is enough to convey shared behaviour.
7. **Use the product's own vocabulary** — the label on the button, not the internal name (e.g. "finding" if the feature is Find, not "searching").

## Before answering

Read the actual diff. Do not summarize from the conversation alone — the conversation records intent, the diff records what shipped.
