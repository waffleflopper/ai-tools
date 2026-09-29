# 13. Small steps, clean changes, real review

## One change at a time

When a patient is on several medications and something needs adjusting, a careful prescriber changes one thing, waits, and watches. Change three drugs on the same day, and if the patient gets better or worse, you can't tell which change did it.

Agents like to change many things at once. Ask for a feature and you might get a diff that adds the feature, reorganizes two folders, renames a dozen things, and "fixes" some unrelated code along the way. If something breaks, you have no idea which part did it. If you want to keep the feature and undo the rest, you can't.

pstack's principle, sequence work into verifiable units, says:

> Order work as a sequence of small units, each ending in a state you can check, and don't advance until the current one is green.

And the reason:

> A break caught at the unit that caused it is cheap to localize. A break caught after a batch is buried, and you have already built further on a broken base.

## Doing the work in order

For a run of similar changes, like updating twenty screens to a new date format, each change is a small bracket. Start from a known-good state, make one change, run the check, and only then move on. If screen 7 breaks, you know it was screen 7, and screens 8 through 20 aren't piled on top of the problem.

pstack adds one detail. Before starting, make sure you're building on the latest clean version of the main branch. If your starting point is already broken or out of date, your checks measure the wrong thing.

```text
Update the date format on each screen one at a time. After each screen, run the tests and check that screen in the app. Stop and tell me if anything fails. Don't move to the next screen until the current one passes.
```

## Telling the story in order

The second half of the principle is about how the finished work gets saved and presented. The commits should be in an order that proves the work, so a reviewer can follow along and see each step hold up.

pstack gives the standard shapes:

- **Failing test, then fix.** The reviewer sees the bug caught, then sees it fixed.
- **Removal, then new structure.** First a commit that deletes dead code, then the change built on the simpler base. That's chapter 5's subtract-before-you-add, made visible.
- **Baseline, then change.** First record how things behave or perform now, then make the change.
- **Foundation, then feature.** First the shared definitions and tests, then the feature that uses them.

Each commit should work on its own. Read in order, the commits make an argument that the change is correct.

## Keep pull requests small

pstack's guidance on pull requests:

> Prefer five narrow PRs to one large PR.

A reviewer, human or agent, can check a small change properly. A huge one gets skimmed and approved on faith, which is how bugs get through review. When work is large, pstack builds a "stack," a chain of small pull requests where each builds on the one before. Each gets reviewed and merged in order.

## A pull request description is a briefing

Clinicians use a structured handoff called SBAR, for Situation, Background, Assessment, and Recommendation. It exists because unstructured handoffs leave out critical information.

pstack's pull request descriptions follow a similar idea. The description is "a briefing, not the lab notebook." It uses these sections, and drops any that have nothing to say:

- **Why.** What the change is for and the approach, in a paragraph or two.
- **Scope.** What changed, by name, and what's deliberately left out.
- **Tradeoffs.** Alternatives a reviewer would ask about, and why they were rejected.
- **Blast radius.** Who and what the change touches, and why it's safe or risky, in one to three sentences.
- **Verification.** What was actually run and what happened. For a speed change, one number in "before → after" form.

It explicitly leaves out long file-by-file lists, pasted logs, and "everything is clean" declarations. Those can go in a linked file if needed.

When you ask an agent to open a pull request, ask for this format. It also works as a test. If the agent can't fill in "Verification" with real runs, the work isn't done.

## Clean the diff before review

Agent-written code carries leftovers. Before review, pstack runs cleanup passes. The ideas behind them are simple enough to ask for directly.

### Remove the padding

pstack's guide says to "remove narrating comments, unsupported guards, dead compatibility paths, and unrelated edits." In plain terms:

- **Narrating comments.** Notes like "// loop through the shifts" that describe what the code plainly does.
- **Unsupported guards.** Checks for situations that can't happen, added "just in case." Chapter 7 explains why these hurt.
- **Dead compatibility paths.** Old versions of things kept around "in case something still uses them."
- **Unrelated edits.** Changes that have nothing to do with the task, like reformatting files the task didn't need to touch.

The guide is firm that this isn't optional polish.

> A diff with narrating comments and defensive dead weight reads as unfinished to reviewers, and the extra code is where the next bug hides.

### Most comments should go

This surprises people. Aren't comments good? pstack's rule is that a comment should exist only for a non-obvious *why* that the code can't show. The code already says *what* it does.

pstack's comment reviewer keeps only a short list of comments. It keeps legal notices, documentation for code other people use, links to outside issues that explain a constraint, and explanations of odd behavior forced by an outside service you can't change.

Everything else goes. The reasoning is sharp. If your own code needs a comment to explain a surprise, the fix is to make the code less surprising. Rename things, restructure, or fix the underlying problem. A long comment defending a workaround is, in pstack's words, "a confession."

The most interesting case is a comment like "DO NOT REMOVE" or "don't change this without asking Sam." That comment is trying to enforce a rule. Comments can't enforce anything, since the next agent will skim right past it. pstack's approach is to turn the rule into something that can enforce itself, such as a type, a test, or an automated check that fails if someone breaks it. Then delete the comment. Chapter 15 comes back to this idea.

pstack also has this cleanup done by a reviewer that didn't write the code, because "an author defends its comments the way you'd defend yours."

## Real review

Once the change is clean, it gets reviewed. pstack's review skill is called `interrogate`, and its design has a lesson for anyone working with agents.

### Use different reviewers

The same change goes to several reviewers running on different AI models. Different models have different blind spots. When two different models independently flag the same problem, that's strong evidence it's real.

You can do a simple version of this yourself. Paste the change and the goal into a fresh session, ideally with a different model than the one that wrote it, and ask it to find problems.

### What reviewers look for

pstack's review rubric covers six areas. You can ask a reviewer to check each one.

1. **Correctness.** Does it do what it's supposed to do? What about empty inputs, unusual values, errors, running twice, and two users at once? For each suspected bug, the reviewer must show the path that causes it, not just say "this might break."
2. **Root cause or symptom.** Is this fixing the real problem, or covering it up?
3. **Fit.** Does the change fit the existing structure, or was it bolted on? Would the code look like this if the requirement had been known from the start?
4. **Proof.** Can you tell it works? Are there tests that can fail?
5. **Complexity.** Is anything here more than the job needs? pstack's line is "Simpler is better unless simpler is wrong."
6. **Security.** Can user input reach anything dangerous? Are there permission gaps or exposed secrets?

pstack's strict code-quality review adds a few alarms worth knowing.

- A file that grows past about 1,000 lines is a warning sign that it's doing too much.
- "Weird if statements in random places" are a design problem, not a style issue. New special cases dropped into unrelated code make the whole thing harder to follow.
- Reviewers should look for "code judo." That's a restructuring that keeps the behavior the same while making the code much simpler, often by deleting whole sets of special cases or layers.

### Sort the findings

A review produces a list of findings, and not all of them are right. pstack sorts findings into four groups. **Act on** means real and worth fixing. **Consider** means worth thinking about. **Noted** means true but minor. **Dismissed** means wrong or not worth it, with a stated reason. Nothing gets changed automatically, and you can overrule the sorting in either direction.

The same thinking applies to automated review bots that comment on pull requests. pstack treats them skeptically, because "they catch real bugs and also file non-issues and nitpicks." Each comment gets one of three responses.

- **Fix** if it points to a plausible real problem.
- **Dismiss** with a concrete reason if it's noise.
- **Ask** a human if it's new, severe, or involves security, privacy, or data.

Don't let an agent change code just to make every comment go away. Each change made to satisfy a noisy comment adds code without fixing anything.

## Ready is not the same as merged

pstack draws a line between getting a pull request ready and merging it. Its "babysit" playbook works through the blockers on an open pull request in order. It takes them in a fixed order, starting with conflicts, then review comments, then failed checks. Conflicts it reports to the owner rather than resolving itself. It batches fixes so the checks restart once instead of after every fix. Then it stops at "ready to merge." It never merges, even when everything is green, because merging is a separate decision.

Its shipping playbook, which does the merging, adds one more rule. Before anything merges, an agent that didn't write the change verifies it independently in the real app. In pstack's words, "CI green is not a verdict, and an approving bot review is not a verdict."

## In practice

- Make one change at a time and check it before starting the next.
- Save work in an order that tells the story, such as failing test then fix, or removal then rebuild.
- Prefer several small pull requests to one big one.
- Ask for pull request descriptions with why, scope, tradeoffs, blast radius, and verification.
- Strip padding and most comments before review. Turn "do not touch" comments into checks.
- Get review from a fresh session or a different model, and sort findings before acting on them.
- Treat merging as its own decision, made only after independent verification.
