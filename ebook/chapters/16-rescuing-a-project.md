# 16. Rescuing a vibe-coded project

This chapter is for readers who already have a product, possibly with real users, that was built fast without the habits in this book. That describes my own project, and this is the work I'm doing on it now.

pstack doesn't have a playbook called "rescue a vibe-coded app." It does have a method for large jobs that don't fit a standard playbook, a skill called `figure-it-out`, and it has the principles from the earlier chapters. This chapter applies both to the rescue job. The order of the steps is my own, built from those principles.

## First, don't panic-rewrite

When you finally see how messy the code is, the instinct is to start over. Sometimes that's right. Usually, with live users, it isn't the first move. A from-scratch rewrite means months where the old app gets no fixes while the new one catches up. And the new one will be built on your current understanding of the product, which is incomplete until you've done the mapping in step 2 below.

The approach here is to improve the running system in small, verified steps, and to rewrite specific parts from first principles when the evidence says a part is beyond saving. Chapter 14's outcome-oriented execution covers how to do a planned rewrite of one part without disrupting users.

## Frame the job

pstack's `figure-it-out` skill starts every large job the same way. Before any work, you should be able to state three things.

1. **What "done" means, as something checkable.** "The code is clean" isn't checkable. Try something like "every endpoint checks permissions on the server, all four core user flows have tests that can fail, there's one reminder function and one date formatter, and CI runs all checks on every pull request."
2. **How big the job is.** A rough count of the pieces and the effort, plus any blockers.
3. **How careful to be.** pstack says to lean toward more rigor, especially for "one-way doors." Those are changes that are hard to undo, like database changes or anything touching live user data.

It also says to tackle the riskiest unknowns first and to put checks in place before the work.

## Step 1. Triage

In an emergency department, triage sorts patients by how urgently they need care, not by who arrived first. Your rescue starts the same way. Some problems can hurt people or the business right now, and they come before anything else, including making the code nicer.

Treat these as immediate:

- **Anyone can see or change data that isn't theirs.** Check every server action for authorization, as in chapter 7.
- **Secrets are exposed** in the code, the frontend, the logs, or the project history.
- **User input can reach a database query, a command, or a page's raw HTML** without the safe handling from chapter 7.
- **Money or messages can be doubled.** Payments, refunds, and texts that could repeat on a retry, as in chapter 8.
- **Data can be lost or corrupted.** That includes two users overwriting each other, jobs that fail halfway and leave a mess, and missing backups.

These get fixed first, each as its own small, verified change, following the bug-fix process in chapter 11.

```text
Do a security and data-safety triage of this project. Don't change anything yet. Check:
1. Every backend endpoint. Who can call it, and where exactly does the server check that the user may act on that specific record?
2. Any secret keys in the code, frontend, logs, or git history.
3. Any place user input reaches a database query, shell command, or raw HTML.
4. Any payment, refund, or message that could happen twice on a retry or double-click.
5. Any place two users could overwrite each other's changes.
For each finding, show me the exact code path and rate it as urgent, soon, or later.
```

A caution about this prompt. An agent doing a security review can miss things and can report problems that aren't real. For each finding, ask it to show the path from input to problem, as pstack's review rubric requires. If your product handles health, financial, or other sensitive data, a professional security review is worth paying for. This book can't replace that.

## Step 2. Map it

You can't fix what you don't understand. Chapter 4's habits apply at full scale here.

- **Ask for the overall picture.** Ask how the whole system works, with an overview, the key ideas, how the main flows run, where things live, and the surprises. For a big codebase, the agent can split this among subagents.
- **List the features.** Write down what the app does from a user's point of view and what result proves each feature works. This is the feature map from chapter 9, and it becomes your checklist for everything after.
- **Take inventory of the mess.** Ask for a list of duplicates, like three date formatters or two reminder systems. Include dead code nothing uses, groups of yes-or-no fields that should be one status, and escape hatches that silence the type checker.
- **Ask why about the strange parts.** Before deleting something odd, check whether it exists for a reason, as chapter 4 describes. With your own vibe-coded project, the honest answer is often "the agent added it and nobody asked why." That's worth knowing too.

```text
Explain how this whole app works, at the level of a senior engineer onboarding a new teammate. Then list every user-facing feature and what a user would see that proves it works. Then list duplicated functionality, code nothing uses, and places where the same rule is written in more than one spot. Don't change anything.
```

## Step 3. Build the safety net

Before changing structure, make it possible to detect when something breaks. pstack's foundational thinking says to put in place first anything that helps every later step.

- **Automated checks on every change.** Set up CI to run the tests, the linter, and the type checker on every pull request. If your language has a strict type-checking setting, turn it on and see what it finds.
- **Pin the core flows.** For the handful of things that must never break, record current behavior with characterization tests, as in chapter 14. For ClinicDesk, those are signing up, posting a shift, claiming a shift, reminders, and billing. Write them so they can fail, as chapter 10 describes.
- **A way to drive the app.** Set up a repeatable way for agents to launch and use the app and capture evidence, as chapter 9 describes.
- **Prune the fake tests.** Apply chapter 10's check to your existing tests. Tests that would pass even if the code did nothing are giving you false confidence. Rewrite or delete them.

This step feels slow, because nothing visible improves. It's what makes every later step safe.

## Step 4. Subtract

Now start removing. Chapter 5's subtract-before-you-add and chapter 14's migrate-then-delete do most of the work.

- Delete dead code.
- For each duplicate, pick the best version, move every caller onto it, and delete the rest, all in one round.
- Remove guards and checks that exist only to silence symptoms, carefully. On a live app, removing one can turn a silent skip into a crash for a real user. First have the agent log each time the guard fires in production and find what triggers it. Fix that cause at its root, then remove the guard.
- Remove features nobody uses. Ask your users or check your analytics. A feature that doesn't earn its place is maintenance with no return.

Each removal is its own small change, checked against the safety net from step 3.

## Step 5. Fix the shape

With less code in the way, fix the structure, starting with the parts that cause the most bugs.

- **Data first.** Replace groups of yes-or-no fields with single statuses, and replace copied values with calculated ones, as in chapters 5 and 6.
- **Boundaries.** Move checking and conversion to where data enters the system, and remove scattered checks from the inside, as in chapter 7.
- **Rules in one place.** Anywhere the same decision gets made in several spots, make it once.

Use chapter 14's refactoring playbook for each change. Pin the behavior, subtract, move in small steps, prove nothing changed, and undo anything that doesn't make the code easier to read.

Sometimes a part is so tangled that restructuring it piece by piece costs more than rebuilding it. That's the moment for redesign from first principles. Ask what you'd build if you were starting today with everything you now know. Rebuild that part on a branch, verify it against the pinned behavior, and move callers over in one round.

## Step 6. Keep it traceable

A rescue is long, and you'll do it across many sessions and many agents. Chapter 15's habits keep it under control.

- Keep a decision log for the whole effort. Commit it, because this is the kind of large job where the trail matters.
- Work in small pull requests, each with a real verification section.
- End each session with a handoff note and start each one by reading it.
- Have a fresh session or a different model review each significant change.

## Step 7. Make the lessons stick

Every class of problem you find is a chance to make sure it can't come back. If you found permission checks missing, add an automated test that fails if any endpoint lacks one. If you found phone numbers in five formats, make the type checker require the one standard format. If you found secrets in code, add a check that blocks commits containing them. That's chapter 15's encode-lessons-in-structure, applied to your own history.

This matters more than it seems, because agents copy what they see. Once the code shows the right patterns everywhere, and the checks block the wrong ones, new work from agents starts out better.

## Going forward

Once the rescue is far enough along, run new work through the playbooks in chapter 17.

## In practice

- Frame the rescue with a checkable definition of done, and tackle the riskiest problems first.
- Triage for security, money, and data safety before any cleanup.
- Map the system and its features before changing structure.
- Build the safety net of CI, pinned core flows, and a way to drive the app before restructuring.
- Subtract first, then fix the shape, one verified change at a time.
- Turn every class of problem you find into a check that keeps it from coming back.
