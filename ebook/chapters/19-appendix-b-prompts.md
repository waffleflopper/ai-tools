# Appendix B. Prompts to copy

These requests work with any capable coding agent. Swap in your own details. They're written informally on purpose, because that's how people actually type, and agents read intent fine from short prompts.

## Starting a task

```text
New task. [What's wrong or what you want.] Reproduce it first / Don't change code yet. Done means [something checkable]. [What must not change] must stay exactly the same.
```

```text
Before we change anything, explain how [area] works today. Overview, key ideas, how it works step by step, where things live, and anything surprising. Don't change any code.
```

```text
Why is [thing] built this way? Look through the history and tell me what you find, with a confidence level for each part: direct, supported, inferred, speculative, or unknown.
```

## Keeping it small

```text
What's the smallest change that solves this? Is there anything we can delete instead?
```

```text
Before adding anything, tell me what in this area can be deleted or merged. Do that as its own change first.
```

```text
This feels like more than the job needs. What would you remove?
```

## Design

```text
Before writing code, name the data shape. What records exist, what's in each, and what states can each be in?
```

```text
Sketch two structurally different designs. For each, show how the rest of the code would use it. Check each for shallow modules, repeated details, code organized by step order, and pass-through layers. Recommend one.
```

```text
Build a throwaway prototype of [idea] with two or three variations behind a switch, in a separate folder, with fake data. This code won't be kept.
```

## Safety

```text
For every backend endpoint, show me the exact line where the server checks that the logged-in user may act on that specific record. Flag any endpoint that only checks that someone is logged in.
```

```text
Find every place user input reaches a database query, shell command, or raw HTML, and confirm each uses the safe method. Show me the path from input to each one.
```

```text
Check for secret keys in the code, frontend, logs, and git history.
```

```text
For every operation that sends a message, charges money, or creates a record, tell me what happens if it runs twice or the server restarts halfway. Fix any that would duplicate, and show a test that runs each one twice.
```

```text
Find every place two users or jobs could change the same record at once. Remove the sharing where possible. Otherwise have the database enforce it in one step, and show a test that fires two requests at once.
```

## Proof

```text
Show me the evidence. The exact commands you ran and what they output. Label each claim as measured, inferred, or guessed.
```

```text
You said [claim]. Where is that on the proof ladder: said so, pointed at the line, showed it can't happen, ran it, or reproduced it in the app? Get it to "ran it."
```

```text
What's the one fact that makes this change safe? Prove it with a script that runs the real code.
```

```text
Show me the real output in the app, not the build log.
```

## Tests

```text
For each test, would it still pass if the code it tests did nothing? List the ones that would, and rewrite or delete each.
```

```text
Write a test that reproduces this bug and show me it failing. Then fix it and show me it passing.
```

```text
You changed a test's expected answer. Why? Was the old answer actually wrong?
```

## Bugs and speed

```text
Reproduce it first. Find the root cause using evidence from running the code, not by reading it. Don't add checks that only hide the symptom. Remove any change based on a guess that turned out wrong.
```

```text
We've tried two fixes and neither worked. Write down what both assumed. Then count where the problem actually shows up, by user, before proposing anything else.
```

```text
Capture a timing trace with realistic data first and show me where the time goes. Fix the biggest measured cause. Show before and after as a median of several runs.
```

## Restructuring

```text
Before restructuring, record the current behavior with real outputs for [area]. After each step, show that the outputs are identical.
```

```text
List every place that uses the old [thing]. Move each to the new one, delete the old one, then search everywhere, including settings and docs, to confirm nothing refers to it.
```

## Review and shipping

```text
Clean up the diff before review. Remove narrating comments, checks for things that can't happen, leftover old code, and unrelated edits.
```

```text
Review this change skeptically. Check correctness, root cause versus symptom, fit with the existing design, proof, unnecessary complexity, and security. For each problem, show the path that causes it. No nitpicks unless it's a real bug.
```

```text
Open a pull request with small ordered commits. Description with why, scope, tradeoffs, blast radius, and verification.
```

## Running agents

```text
Keep going on anything you can undo. Stop and ask before anything you can't, like deploying, deleting data, messaging users, or spending money.
```

```text
Do this in a new worktree on a new branch off main.
```

```text
Keep a decision log, one row per real decision, with what, why, and a pointer to evidence. At the end, list anything I should look at closely.
```

```text
I'm stepping away. [Goal.] Done means [checkable condition]. Keep a decision log. You don't need to ask before committing. If you're truly stuck, stop and write up why.
```

```text
Stop at a safe point. Commit what you have as work in progress, and write a resume note a new agent could pick up from cold.
```

```text
Restate that in plain language, without jargon, like you're talking to someone who doesn't write code.
```

## Common mistakes

These come from pstack's guide, restated for any tool.

- **Scripting every step for the agent.** A hand-written sequence of tools and steps tends to drop or reorder things a good playbook would have kept. State the goal and the constraints, plus any order that matters, such as "reproduce first."
- **A vague finish condition.** "Make it better" gives the agent nothing to check. Name a command, a result, or a number.
- **Parallel agents in one folder.** They overwrite each other. Give each its own worktree.
- **Accepting every review comment.** Reviewers, human and automated, mix real problems with noise. Sort them first.
- **Calling it done because the build passed.** A build proves the code compiles and nothing more. Ask for the real result.
