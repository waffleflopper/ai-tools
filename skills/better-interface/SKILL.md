---
name: better-interface
description: Review an interface or UI change across accessibility, layout, writing, typography, color, and polish; consolidate evidence into one ranked report.
---

# Interface review

Screen the requested interface across all six disciplines, investigate relevant concerns, and produce one evidence-backed review. Review requests are read-only unless implementation is also authorized.

## Resolve scope and conventions

Infer the requested screen, flow, or repository boundary. If it is too large to inspect credibly, cover one complete requested flow and state the exclusions. Include applicable empty, loading, error, disabled, and narrow-width states; never imply uninspected surfaces were reviewed.

Inspect the framework, approved components, tokens, density, motion language, supported viewports, and applicable project guidance. Reuse those patterns in proposed fixes. Deliberate aesthetic choices are not findings without a demonstrated user impact or requirement violation. Report a defective shared convention once at its source.

For a branch, PR, range, or uncommitted change, read [scope resolution](../interface-review/scope-resolution.md) and [removed signals](../interface-review/removed-signals.md) directly. Resolve and record the baseline, head, changed files, untracked contents where applicable, exclusions, and affected consumers. Read both sides of the diff and the stated intent. Do not require the user to invoke another skill. Keep the author's checkout intact; use an isolated worktree if rendered verification needs another revision. If the requested change cannot be resolved, report the facts and ask only for the missing target; never substitute an unrelated commit.

## Screen every discipline; load detail selectively

Use the checklist below for every scoped surface. Load an owning skill when a candidate finding, uncertainty, requested depth, or specialized verification warrants its detailed guidance. A comprehensive audit still examines every discipline; selective loading does not authorize skipping checks.

| Discipline and owner | Screening questions |
| --- | --- |
| [Accessibility](../better-accessibility/SKILL.md) | Are controls named, keyboard-operable, and visibly focused? Are semantics, labels, focus movement, errors, dynamic announcements, hit areas, reduced motion, zoom, and non-color cues usable? |
| [Layout](../better-layout/SKILL.md) | Are grouping, reading order, action hierarchy, hidden-content cues, spacing, responsive growth, clipping, and relevant RTL behavior clear? |
| [Writing](../better-writing/SKILL.md) | Do labels, terminology, action text, errors, and empty states explain what happens and how to proceed in the project's voice? |
| [Typography](../better-typography/SKILL.md) | Do hierarchy, weights, line spacing, measure, wrapping, truncation recovery, changing numbers, mobile inputs, and language direction remain readable with realistic content? |
| [Colors](../better-colors/SKILL.md) | Are tokens used in their intended roles, themes consistent, rendered contrast sufficient, and state meanings understandable without color alone? |
| [UI polish](../better-ui/SKILL.md) | Are surfaces, icons, alignment, interaction states, and motion coherent with the design system, without distraction or loss of static feedback? |

Read the owning guidance before confirming a finding; its specialized references are conditional too. If an owner is missing, mark that domain's detailed review unavailable and continue. Record what was screened versus examined in depth. From loaded owners use the relevant principles and verification guidance, with the single reporting and severity policy below replacing their standalone reports.

## Evidence and fixes

Cite source findings at `path/to/file:line` with the current implementation; for artifacts without source, identify the screen and component. Inspect the rendered state for claims that depend on appearance or runtime behavior. Run safe, relevant project checks and disclose unavailable verification.

One root cause is one finding, including confirmed repeated locations. Prefer removing unnecessary work or reusing the project's approved primitive, token, or seam; add a new abstraction only when those cannot satisfy the demonstrated need. Preserve accessibility and meaningful static feedback when simplifying.

## Report

Use [review-format.md](review-format.md) for scope, six-discipline coverage, severity, findings, verification, and verdict. It is the single report format for both surface and change reviews. Do not produce six standalone reports or treat a recipe preference as a defect.
