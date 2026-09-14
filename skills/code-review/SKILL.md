---
name: code-review
description: Review branches, PRs, or working changes with independent Standards and Spec reviewers, then report both axes.
---

Two-axis review of the change scope requested by the user:

- **Standards** — does the code conform to this repo's documented coding standards?
- **Spec** — does the code faithfully implement the originating issue / PRD / spec?

Both axes run as **parallel sub-agents** so they don't pollute each other's context, then this skill aggregates their findings.

Use `docs/agents/issue-tracker.md` when present; otherwise use the supplied spec or available tracker workflow. A review does not require setting up new repository instructions.

## Process

### 1. Pin the fixed point

Resolve the requested scope and pin applicable refs to commit SHAs. Use a supplied PR base or explicit scope; ask only when the intended comparison remains materially ambiguous.

- Branch/PR review: resolve the merge-base of the base branch and HEAD, then compare that SHA to HEAD.
- Changes since an exact commit or tag: compare that resolved SHA directly to HEAD; do not silently substitute the merge-base.
- Staged-only review: `git diff --cached`. Unstaged-only review: `git diff`.
- Full WIP review: `git diff HEAD` plus relevant untracked file contents from `git ls-files --others --exclude-standard`. When WIP is requested since a baseline, use `git diff <baseline-sha>` plus those untracked files to include both committed and uncommitted changes.

Record the exact baseline, commands, and in-scope file inventory for both reviewers. Include a commit list when committed changes are in scope. Confirm refs resolve and inspect `git status --short`; an empty tracked diff does not imply an empty WIP review. Report if the scope has no changes. If files change during review, reconcile the findings with the final snapshot.

### 2. Identify the spec source

Look for the originating spec, in this order:

1. Issue references in the commit messages (`#123`, `Closes #45`, GitLab `!67`, etc.) — fetch via the workflow in `docs/agents/issue-tracker.md`.
2. A path the user passed as an argument.
3. A PRD/spec file under `docs/`, `specs/`, or `.scratch/` matching the branch name or feature.
4. Use an explicit task request or recorded owner decision when it supplies the requirements. If no independent requirements source is available, continue the Standards and independently assessable correctness review, skip the **Spec** sub-agent, and report "no spec available". Ask for a missing source only when a consequential finding depends on it; do not block independent review or infer a spec from the implementation.

### 3. Identify the standards sources

Anything in the repo that documents how code should be written, such as `CODING_STANDARDS.md` or `CONTRIBUTING.md`.

On top of whatever the repo documents, the Standards axis always carries the **smell baseline** below — a fixed set of Fowler code smells (_Refactoring_, ch.3) that applies even when a repo documents nothing. Two rules bind it:

- **The repo overrides.** A documented repo standard always wins; where it endorses something the baseline would flag, suppress the smell.
- **Always a judgement call.** Each smell is a labelled heuristic ("possible Feature Envy"), never a hard violation — and avoid repeating routine style findings already enforced by tooling. Still report evidenced correctness or security defects even when a checker nominally covers them.

Each smell reads *what it is* → *how to fix*; match it against the diff:

- **Mysterious Name** — a function, variable, or type whose name doesn't reveal what it does or holds. → rename it; if no honest name comes, the design's murky.
- **Duplicated Code** — the same logic shape appears in more than one hunk or file in the change. → extract the shared shape, call it from both.
- **Feature Envy** — a method that reaches into another object's data more than its own. → move the method onto the data it envies.
- **Data Clumps** — the same few fields or params keep travelling together (a type wanting to be born). → bundle them into one type, pass that.
- **Primitive Obsession** — a primitive or string standing in for a domain concept that deserves its own type. → give the concept its own small type.
- **Repeated Switches** — the same `switch`/`if`-cascade on the same type recurs across the change. → replace with polymorphism, or one map both sites share.
- **Shotgun Surgery** — one logical change forces scattered edits across many files in the diff. → gather what changes together into one module.
- **Divergent Change** — one file or module is edited for several unrelated reasons. → split so each module changes for one reason.
- **Speculative Generality** — abstraction, parameters, or hooks added for needs the spec doesn't have. → delete it; inline back until a real need shows.
- **Message Chains** — long `a.b().c().d()` navigation the caller shouldn't depend on. → hide the walk behind one method on the first object.
- **Middle Man** — a class or function that mostly just delegates onward. → cut it, call the real target direct.
- **Refused Bequest** — a subclass or implementer that ignores or overrides most of what it inherits. → drop the inheritance, use composition.

### 4. Spawn both sub-agents in parallel

Use the available subagent API to start both independent reviews before waiting for results. Give each reviewer the same pinned scope and the evidence relevant to its axis. If subagents are unavailable, perform separate passes and disclose that independent review was unavailable.

**Standards sub-agent prompt** — include:

- The full scope commands, file inventory (including in-scope untracked files), and applicable commit list.
- The list of standards-source files you found in step 3, **plus the smell baseline from step 3** pasted in full — the sub-agent has no other access to it.
- The brief: "Report — per file/hunk where relevant — (a) every place the diff violates a documented standard: cite the standard (file + the rule); and (b) any baseline smell you spot: name it and quote the hunk. Distinguish hard violations from judgement calls — documented-standard breaches can be hard, but baseline smells are always judgement calls, and a documented repo standard overrides the baseline. Avoid routine tooling-enforced style findings, but retain evidenced correctness or security defects. Under 400 words."

**Spec sub-agent prompt** — include:

- The same scope commands, file inventory, and applicable commit list.
- The path or fetched contents of the spec.
- The brief: "Report: (a) requirements the spec asked for that are missing or partial; (b) behaviour in the diff that wasn't asked for (scope creep); (c) requirements that look implemented but where the implementation looks wrong. Quote the spec line for each finding. Under 400 words."

If the spec is missing, skip the Spec sub-agent and note this in the final report.

### 5. Aggregate

Verify each finding against the diff and its cited source; remove unsupported claims and duplicates within each axis. Present the reports under `## Standards` and `## Spec` headings. If both axes identify the same defect, cross-reference it while preserving both attributions. Do not merge the axes or rank one against the other (see _Why two axes_).

End with a one-line summary: total findings per axis, and the worst issue _within each axis_ (if any). Don't pick a single winner across axes — that's the reranking the separation exists to prevent.

## Why two axes

A change can pass one axis and fail the other:

- Code that follows every standard but implements the wrong thing → **Standards pass, Spec fail.**
- Code that does exactly what the issue asked but breaks the project's conventions → **Spec pass, Standards fail.**

Reporting them separately stops one axis from masking the other.
