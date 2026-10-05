---
name: issue-prompt
description: Write a ticket-ready issue description that doubles as an implementation prompt — Issue, Solution, numbered Steps each with checks and a verification, and an Ask-before-deciding list. Use when asked to "create an issue prompt", "write a ticket description", "turn this into a ticket", "csinálj issue promptot", "írj ticket leírást".
---

# Issue prompt

One document a human reads as a ticket and an agent executes as a prompt.
Default cap **75 lines**; use the user's cap when they give one, and count it with `wc -l`.

## Output shape

```
# <title naming the problem, never the fix>

## Issue

<one sentence: the root cause>. Symptoms:

- <user-visible symptom>
- <user-visible symptom>

## Solution

1. <required behaviour, no file paths>
2. <required behaviour>

<one line: scope rules + "If anything below is ambiguous, stop and ask — do not guess." + the key mechanism insight>

## Step 1 — <what changes>

- `path/to/file.ts:17` — `old` → `new`.

Checks:
- <invariant that must stay true, with file:line>
- <adjacent thing that must NOT be touched>
- Verify: <observable result>

## Step N — Lint, test, browser

1. <lint + test commands>
2. <run the app, the three things to look at>
3. Report what you saw.

## Ask before deciding

- <wording or copy choice>
- <anything the steps do not cover>
```

## Rules

1. **Title names the problem.** "X broken by Y", not "Add Z".
2. **Issue = why it is broken** — root cause first, then symptoms a user can see. One fact per line; merge overlapping bullets.
3. **Solution = required behaviour**, numbered. Paths belong in the steps, not here.
4. **Every claim cites `file:line`.** Read the code first; never guess a path, line, or default.
5. **Each step ends in a `Verify:` line** — an observable result, not "check it works".
6. **Name what must NOT change.** Adjacent code that looks like it should move is the most common wrong edit.
7. **Flag scope gaps out loud.** A symptom listed under Issue that the steps do not fix goes in Ask-before-deciding, marked as such.
8. **Nothing local.** No absolute paths, worktree or branch names, ticket URLs, or issue numbers — this becomes the ticket.
9. **Push decisions to the reader.** Tell the executor to ask; park real forks in Ask-before-deciding rather than choosing silently.

## Before writing

Explore and verify every path, line, constant and default you cite. Where two readings would
produce materially different work, ask with AskUserQuestion — one focused question, not a battery.
