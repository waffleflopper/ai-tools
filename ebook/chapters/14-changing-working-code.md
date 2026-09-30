# 14. Changing code that already works

## Restructuring without breaking

Sooner or later you'll want to change how code is organized without changing what it does. You might merge three date formatters into one, split a 2,000-line file into sensible pieces, or replace the four yes-or-no shift fields from chapter 6 with a single status. Engineers call this refactoring. The structure changes and the behavior stays the same.

It's also one of the riskiest things you can ask an agent to do. A refactor touches a lot of code, and the whole point is that nothing visible should change. So how would you know if something did? pstack's refactoring playbook answers that question.

> You own the contract. The structure changes. The behavior does not.

"Contract" here means what the code promises to do from the outside, such as what inputs it takes, what results it gives, and what it saves and sends.

## Record the behavior first

Before a renovation, a contractor photographs everything. Afterward, you can compare. Before surgery, you record baseline vitals, so afterward you can tell whether anything changed.

pstack's first step for a refactor is the same.

> Pin the behavior contract first.

Before any structure moves, the agent writes something that records exactly what the code does today. That could be a characterization test, which records current outputs for a range of inputs. It could be a snapshot, a saved copy of the output. Or it could be an equivalence harness, a script that runs old and new versions side by side and compares them.

A characterization test records what the code does now, even if some of it is wrong. The point isn't correctness. The point is to detect any change.

pstack is specific that "type check and lint are not a pin." Those checks confirm the code is well-formed. They don't confirm it behaves the same.

```text
Before restructuring the reminder code, record its current behavior. Run it against at least 20 realistic appointments covering different types, time zones, and cancelled ones, and save the exact output. After the restructure, run the same appointments and show me the outputs are identical.
```

## The refactoring playbook

Here's pstack's full playbook in plain terms.

1. **Pin the behavior.** First understand the area, as in chapter 4. Then record what it does now, before touching anything.
2. **Name the missing structure.** What's the code missing that would make it simpler? A single status instead of scattered switches? A table instead of a chain of special cases? If the current code is already clear and local, leave it alone. A restructure has to remove if-then paths or impossible states. It shouldn't add layers.
3. **Name the target shape.** Describe what the code would look like if it were written today with everything you now know, as in chapter 6.
4. **Subtract first.** Delete dead code, remove pointless wrappers, and drop redundant checks before building the new shape. Any speculative cleanup that "might help" gets undone.
5. **Move in small steps, each keeping the pin green.** After each step, the recorded behavior still matches.
6. **Prove nothing changed.** Compare against the pin on the real thing, not "it compiles."
7. **Confirm it was worth it.** Is the code actually easier to understand now? If the restructure doesn't make the code easier to read somewhere, undo it.
8. **Save the work in order.** Removal first, then the restructure, then any follow-up cleanup.

Step 7 is unusual and important. The playbook says:

> If the diff does not lower reader load somewhere, revert it.

A refactor that moves code around without making it easier to follow isn't an improvement. It's churn, and it costs review time and risk for nothing.

## Don't mix restructuring with fixes

A refactor often turns up bugs. You're reading code closely, and you notice something's wrong. The temptation is to fix it along the way.

pstack says to split it out. First ship the restructure, checked against the pinned behavior, bug and all. Then fix the bug as a separate change, using the bug-fix process from chapter 11. If you do both at once, the pin fails, and you can't tell whether it failed because of your intended fix or because the restructure broke something.

The same goes for new features. If restructuring reveals that a feature is missing, that's a separate piece of work.

## Replace, then delete

When an agent builds a better version of something, it very often leaves the old version in place. It adds a new reminder function and keeps the old one "for compatibility." Both keep getting used. Now there are two ways to do the same thing, some screens use one and some use the other, and every future change has to account for both.

Hospitals switching electronic record systems learn this lesson the hard way. If the old and new systems both stay in use, records split between them, staff don't know which to trust, and every process has to handle both. A good transition sets a go-live date, moves everything over, and shuts the old system off.

pstack's principle, migrate callers then delete legacy APIs, says:

> When we decide a new API is the right design, migrate callers and remove the old API in the same refactor wave instead of preserving compatibility layers.

In plain terms, when there's a new way to do something:

1. **List everything that uses the old way.** These are the "callers."
2. **Move every one of them to the new way.**
3. **Delete the old way.** Do it in the same round of work, not "later."
4. **Update the tests** to check the new behavior, and delete tests that only protected the old internals.

pstack explains the cost of skipping step 3:

> Keeping both old and new APIs creates dual-path complexity, slows cleanup, and makes the codebase feel append-only.

"Append-only" means code only ever gets added and never removed. That's exactly how vibe-coded projects end up the way they do.

Temporary adapters, meaning small pieces of code that let old callers use the new version, are allowed only as exceptions, with an end date.

This principle has limits. It applies when you control all the callers. If outside customers or other companies' software depend on your old version, you can't delete it without warning them. For most small products, though, every caller is your own code, and you can move them all at once. Watch for one exception. If you have a phone app, older versions stay installed on people's phones and keep calling your server the old way. Those are callers you don't control.

### Watch renames closely

pstack's playbook warns that renames "silently miss usages in strings, prose, and back-references." If you rename a field from `phone` to `mobilePhone`, a search-and-replace will catch most uses. It may miss the one where the name is built from pieces of text, or where it appears in a settings file or documentation. Ask the agent to check every rename against the actual files, and to search for the old name after it's done.

```text
We have two reminder functions, the old one and the new one. List every place that uses the old one. Move each to the new one, then delete the old one entirely. Afterward, search for the old name everywhere, including settings and documentation, and show me that nothing refers to it.
```

## Aim for the destination

One more principle covers large planned rewrites. It's called outcome-oriented execution.

> Optimize for the intended, verifiable end state rather than preserving smooth intermediate states.

It sounds like it contradicts the small-steps idea from chapter 13, but it doesn't. You still work in small, checked steps. The difference is what you check along the way.

In a big migration, like moving every screen from an old data format to a new one, a tempting approach is to keep everything fully working at every moment. That means writing translation code so old screens can read new data and new screens can read old data. That translation code is throwaway work. It has its own bugs, and it tends to stick around long after the migration.

Outcome-oriented execution says to skip most of that. Work on a separate branch. Accept that some parts will be temporarily broken there, as long as the breakage is planned, limited, and reversible. Keep checking the parts you're actively changing. At the end, require full verification of everything before the work merges.

pstack's guardrails:

- Use this only for planned rewrites and migrations with clear phases.
- Say in advance where temporary breakage is acceptable.
- Keep strong checks on the areas you're actively changing.
- Require full verification, of both the code and the running app, at the end.

The code breakage stays on the branch, so users only see the finished, verified result. Stored data is different. Your production database is shared, so a change to how data is stored can't stay on a branch. When the new code goes live, the existing records are still in the old format. Changes to stored data need a migration, which is a script that converts existing records when the new version is deployed. They also need a fresh backup first, and often a short period where the code can read both the old and new formats. Treat any change to live data as irreversible, and approve it yourself.

## In practice

- Record current behavior before restructuring anything, with real outputs and not just "it compiles."
- Restructure in small steps, and compare against the recording after each one.
- Keep restructuring, bug fixes, and new features in separate changes.
- Undo any restructure that doesn't make the code easier to understand.
- When there's a new way to do something, move everything to it and delete the old way in the same round.
- For big migrations, plan the end state, allow scoped breakage on the branch, and fully verify before merging.
