# Review output format

Use one consolidated report for a review orchestrated by `better-interface`. Standalone domain reviews retain their own formats.

## Scope and coverage

State the exact scope, stack, styling conventions, applicable project documents, states inspected, and exclusions. For changes, include target, baseline/head refs and SHAs, committed and uncommitted scope, file inventory, and expanded consumers with any cutoff.

| Domain | Evidence inspected | Depth and result |
| --- | --- | --- |
| Accessibility | Files, components, states, checks | Screened or reviewed in depth; findings count or clear |

Include Accessibility, Layout, Writing, Typography, Colors, and UI polish. `Clear` requires inspection; distinguish screening from a detailed owner review. `Not reviewed` must explain why, including missing evidence or unavailable owners. A domain unaffected by a change can say `Not reviewed: no evidence in the change scope`.

## Rank by user impact

- `HIGH`: blocks a task, misleads the user, hides content or controls, causes data-loss risk, or creates a repeated systemic failure.
- `MEDIUM`: meaningfully harms comprehension, efficiency, adaptability, or consistency.
- `LOW`: isolated polish with limited task impact.

Within each severity, rank by confirmed reach and the benefit of one fix. A shared root cause outranks the same symptom in one leaf.

The following are `HIGH` once confirmed against owning guidance and evidence:

- An interactive control with no accessible name.
- A keyboard-reachable control with no visible focus indicator.
- A control or path reachable by pointer but not by keyboard.
- Motion or auto-playing content that ignores `prefers-reduced-motion`.
- Content or a control clipped, overlapped, or unreachable at 320px width or 200% zoom.
- Body or control text whose rendered contrast pair fails its required ratio.
- State or meaning carried by color alone.
- A destructive action with no confirmation, undo, or distinct treatment.
- Truncated content with no way to reach the full value.
- Content or a control reachable only past a scroll edge or behind a disclosure that has no visible cue.
- An error that names no way to recover from it.
- A semantic color used against its meaning, such as the danger hue on a non-destructive action.
- A state change carried by motion alone, with no color, icon, or label left behind when the animation does not run.

These determine severity after the owning rule establishes the failure. They do not turn deliberate aesthetic differences into violations.

## Findings

Report at most 15 findings, highest severity and reach first, with one row per root cause. List all confirmed locations together. Put the escalation triggers first; if the cap excludes further blockers, disclose their count and affected scope rather than concealing them.

| Severity | Domain | Location | Before | After | Why |
| --- | --- | --- | --- | --- | --- |
| HIGH | Accessibility | `src/Dialog.tsx:42` | Icon-only button has no name | Add an accessible Close name using the existing button API | The control cannot be identified by assistive technology |

Cite `path/to/file:line`, or the exact screen and component for artifacts without source. Before/After show current behavior or implementation and an actionable fix. Why explains the rule and user impact. With no findings, omit the table and say so.

For change reviews, add a `Status` column:

- `Introduced`: the change created the issue.
- `Regression`: the change weakened previously correct behavior.
- `Pre-existing`: the issue was already present and the change did not cause it.

Confirm causality against both revisions; proximity to a changed line is not evidence. Keep at most three pre-existing findings in a separate section, outside the 15-finding cap and verdict. The change verdict concerns Introduced and Regression findings only.

## Verification and verdict

Report the exact checks, commands or interaction steps, observed results, and any `Not verified` limitations. Do not convert a check you could not run into a finding.

End with `Block` if a relevant `HIGH` remains; otherwise `Approve`, leaving lesser findings as follow-up work. Qualify the verdict by the actual inspected scope and verification limits. Never approve a review with no inspectable scope or claim coverage of uninspected domains.
