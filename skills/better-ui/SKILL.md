---
name: better-ui
description: Review or improve UI surfaces, icons, alignment, and motion within an existing design system.
---

# UI polish

Preserve the project's approved component library, tokens, density, and motion language. Numerical values and visual recipes in this skill's references are optional starting points where the project has no suitable convention. Do not replace an approved pattern merely to match a recipe; a review finding needs evidence of user impact or inconsistency.

Review without editing unless changes are authorized. Text rendering belongs to `better-typography`; hit areas, keyboard behavior, focus, ARIA, and reduced motion to `better-accessibility`; grouping and responsive structure to `better-layout`.

## Inspect the relevant details

- **Surfaces and alignment:** Check closely nested radii, optical balance, and whether borders or shadows communicate structure, state, or depth. Preserve structural and focus boundaries. Read [surfaces.md](surfaces.md) for a demonstrated surface or image-edge problem.
- **Icons:** Reuse the existing icon set and its optical conventions. Keep icons recognizable at render size, state styling coherent, and direction appropriate under RTL. Read [icons.md](icons.md) when inspecting icon weight, assets, or direction.
- **Interactive motion:** Feedback should remain responsive when interrupted. Prefer simple transitions for interactive changes and static feedback for frequent actions. Every state change needs a cue that remains when animation does not run. Read [animations.md](animations.md) for press feedback, initial mount, or theme-switch problems.
- **Entrances, exits, and icon swaps:** Animate only when the transition helps communicate the change. Read [enter-exit.md](enter-exit.md) or [icon-transitions.md](icon-transitions.md) for those cases. Use the installed motion package and existing imports; do not add a dependency for a decorative effect.
- **Performance:** Name the properties that actually transition. Investigate observed stutter before adding compositing hints; avoid speculative `will-change`. Read [performance.md](performance.md) for transition or rendering-performance concerns.

Respect reduced-motion preferences in every recipe. Do not add animations, component props, wrappers, or global theme behavior unless the requested outcome needs them.

## Verification and reporting

Inspect the relevant hover, focus, active, disabled, loading, empty, and changed states. Use a browser for visual or runtime claims; replay motion slowly when timing is unclear. Source inspection supports implementation claims, but does not verify rendered behavior. Name checks that could not run.

When part of `better-interface`, use its consolidated report only. Standalone reviews use one row per root cause, ranked by impact:

| Severity | Location | Before | After | Why |
| --- | --- | --- | --- | --- |

Cite `path/to/file:line` and explain the user impact. `HIGH` breaks an interaction, makes motion unusable, or leaves a state change visible only during animation. `MEDIUM` is a consequential inconsistency in surfaces, icons, or motion. `LOW` is isolated polish.

End with `Block` when any `HIGH` remains, `Approve` otherwise, limited to the inspected scope. If there are no findings, say so and report verification.
