---
name: implement
description: "Implement a piece of work based on a spec or set of tickets."
disable-model-invocation: true
---

Implement the work described by the user in the spec or tickets.

Before edits, verify the intended branch and capture the review baseline and any existing working-tree changes.

Use /tdd for behavior changes that warrant tests, at pre-agreed seams. Reuse existing seam approvals; do not add tests merely to mirror a low-impact edit.

Run focused checks after meaningful changes and the project's required final validation after the final relevant edit. Repeat or broaden checks when changes, failures, or unresolved evidence justify it.

Once done, use /code-review to review the work against the captured baseline, including task-owned staged, unstaged, and untracked changes.

Commit only task-owned changes to the intended branch, respecting any user instruction to leave the work uncommitted. Preserve unrelated working-tree and staged changes.
