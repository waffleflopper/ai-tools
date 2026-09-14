---
name: tdd
description: Build features or fix bugs test-first using red-green-refactor. A request for integration tests alone does not require TDD.
---

# Test-Driven Development

Use a red → green → refactor loop for the authorized behavior. Read the applicable guidance once, then revisit it only when new behavior or uncertainty changes the testing decision.

When exploring the codebase, read `CONTEXT.md` (if it exists) so test names and interface vocabulary match the project's domain language, and respect ADRs in the area you're touching.

## What a good test is

Tests verify behavior through public interfaces, not implementation details. Code can change entirely; tests shouldn't. A good test reads like a specification — "user can checkout with valid cart" tells you exactly what capability exists — and survives refactors because it doesn't care about internal structure.

Read [tests.md](tests.md) when examples would clarify a test-design decision and [mocking.md](mocking.md) when deciding how to isolate an external boundary.

## Seams — where tests go

A **seam** is the public boundary you test at: the interface where you observe behavior without reaching inside. Tests live at seams, never against internals.

**Test only at pre-agreed seams.** Reuse seams already approved in the conversation, spec, or applicable project test policy. State the chosen seams and proceed without asking again. Ask which public interfaces to test only when a consequential seam choice remains unresolved. You can't test everything — agreeing the seams up front is how testing effort lands on the critical paths and complex logic instead of every edge case.

## Anti-patterns

- **Implementation-coupled** — mocks internal collaborators, tests private methods, or verifies through a side channel (querying the database instead of using the interface). The tell: the test breaks when you refactor but behavior hasn't changed.
- **Tautological** — the assertion recomputes the expected value the way the code does (`expect(add(a, b)).toBe(a + b)`, a snapshot derived by hand the same way, a constant asserted equal to itself), so it passes by construction and can never disagree with the code. Expected values must come from an independent source of truth — a known-good literal, a worked example, the spec.
- **Horizontal slicing** — writing all tests first, then all implementation. Bulk tests verify _imagined_ behavior: you test the _shape_ of things rather than user-facing behavior, the tests go insensitive to real changes, and you commit to test structure before understanding the implementation. Work in **vertical slices** instead — one test → one implementation → repeat, each test a **tracer bullet** that responds to what the last cycle taught you.

## Rules of the loop

- **Red before green.** Write the failing test first, then only enough code to pass it. Don't anticipate future tests or add speculative features.
- **One slice at a time.** One seam, one test, one minimal implementation per cycle.
- **Refactor while green.** Once the behavior passes, simplify duplication or structure when it improves the code. Preserve observable behavior and keep the relevant tests green. Refactoring does not require a separate review stage or skill invocation.
