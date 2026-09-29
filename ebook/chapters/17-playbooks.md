# 17. The playbooks

## Why checklists

The World Health Organization's Surgical Safety Checklist asks a few simple questions before incision, like whether this is the right patient, the right procedure, and the right site. Experienced surgeons don't need to be taught those things. The checklist exists because skilled people under pressure skip steps they know perfectly well.

Agents skip steps too, all the time. pstack's main tool is a set of playbooks, which are step lists for each kind of task. When a task starts, the agent copies the matching playbook's steps into its to-do list word for word. If it decides to skip a step, the step stays on the list with a one-line reason, such as "skip: no database changes in this task." You can see what it chose not to do, and push back.

You can ask any agent to work this way. Paste in the playbook, or save it as an instruction file your agent reads, and ask it to copy the steps into its to-do list and mark any skipped step with a reason.

The playbooks below are simplified from pstack's. Each has when to use it, the steps, what the final report should include, and a sample request.

## Investigation

**Use it when** you have a question and want an answer, not a change. How does this work? Why is it built this way? Should we do X or Y?

1. Explain how the relevant part works, with an overview, key ideas, how it works, where things live, and gotchas.
2. If the question is about motivation, look through the history for why, with confidence levels.
3. For a decision between options, give a recommendation with a table of tradeoffs.
4. Change nothing.

**The report includes** the explanation or recommendation, with honest judgment. If the question rests on a wrong assumption, say so.

```text
Investigation only, no code changes. How do reminder texts get scheduled and sent? Why do they wait 90 seconds before sending? Give confidence levels for the why.
```

## Bug fix

**Use it when** something is broken.

1. Reproduce it yourself, in the same place the user saw it.
2. Find the cause. List hypotheses, test each against evidence from running code, and eliminate until one survives. Add logging if needed. Don't guess.
3. Plan the fix. If it crosses between parts of the system, design it first.
4. Verify in the same place. The original reproduction now passes.
5. Where a cheap test is possible, save a failing test before the fix.
6. Open a pull request.

**Rules.** Nothing ships without evidence behind it. A change based on a disproven hypothesis gets removed. No guards that only silence the symptom.

**The report includes** what was broken, the root cause, the fix, how it was verified, and the failing-then-passing output.

```text
Bug fix. Patients sometimes get two reminder texts for one appointment. Reproduce it first, find the root cause with runtime evidence, fix it, and show me the reproduction failing before and passing after.
```

## Feature

**Use it when** you want new or changed behavior.

1. Explain how the affected area works now.
2. Design before building. Name the data shape and structure first. If the change crosses parts of the system, sketch two different designs and pick one.
3. Plan the order of work. Decide what has to happen first, what can happen in parallel, and what shared data needs care.
4. Build it, in small steps.
5. Verify in the real app, and check that what shouldn't change didn't.
6. Save the work as small, ordered commits.
7. If the design is contested, get an independent review.
8. Open a pull request.

**The report includes** what was built, what was chosen and why, alternatives considered, and open decisions.

```text
Feature. Let managers mark a shift as "urgent" so it's highlighted for staff. Existing shift display must not change for non-urgent shifts. Name the data change first. Verify in the app as both a manager and a nurse.
```

## Refactoring

**Use it when** you want to change structure without changing behavior.

1. Record the current behavior with real outputs before touching anything.
2. Name the structure the code is missing. Leave clear, simple code alone.
3. Describe the target shape as if you were writing it today.
4. Delete dead code and needless layers first.
5. Move in small steps, keeping the recorded behavior identical. Move every caller of anything replaced, and delete the old version in the same round.
6. Prove nothing changed, against the real thing.
7. Confirm the code is easier to follow. If not, undo it.
8. Save it as removal first, then the restructure, then cleanup.

**Rules.** No new behavior. Bugs and features found along the way become separate changes.

**The report includes** what structure changed, how behavior was pinned, the proof it's unchanged, and what got simpler.

```text
Refactor. Replace the four yes-or-no fields on shifts with a single status. Record current behavior for every screen and job that reads shift status first, and prove it's identical afterward. Show me how existing records with conflicting values will be converted. Take a backup, and ask me before removing the old fields from the live database.
```

## Performance

**Use it when** something is measurably slow.

1. Capture a baseline measurement, with a timing trace from realistic data.
2. Understand the slow area. Form hypotheses only from what the trace shows.
3. Plan and make one fix at a time. Measure after each.
4. Compare the before and after measurements directly.
5. Report the numbers in the pull request.

**The report includes** the baseline number, the after number, the difference, and where the measurements are saved.

```text
Performance. The monthly report takes about 8 seconds for a clinic with a year of data. Trace it first, fix the biggest measured cause, and show me before and after numbers as a median of several runs.
```

## Prototype

**Use it when** you need to make a design decision cheaply.

1. Name the decision the prototype will settle. No decision, no prototype.
2. If the direction is wide open, gather a few examples of how others have done it.
3. Build it throwaway, in a separate folder, with the simplest tools. No tests, no structure.
4. Put alternatives side by side behind a switch.
5. Look at each one in action.
6. Recommend one. Then build it for real using the Feature playbook.

**The report includes** the options, screenshots or observations, tradeoffs, and a recommendation, plus a clear statement that the prototype is throwaway.

```text
Prototype. Show me three different ways a nurse could see and claim open shifts on a phone, in a throwaway page with fake data and a button to switch between them. This code won't be kept.
```

## Opening a pull request

**Use it at** the end of every other playbook that changes code.

1. Work on a branch in its own worktree.
2. Save the work as small commits in an order that tells the story.
3. Remove padding, such as narrating comments, needless guards, dead leftovers, and unrelated edits.
4. Write the description with why, scope, tradeoffs, blast radius, and verification.
5. Keep it small. Split large work into several pull requests that build on each other.

```text
Open a pull request. Small ordered commits. Clean out narrating comments and unrelated changes first. Description with why, scope, tradeoffs, blast radius, and verification with what you actually ran.
```

## Getting a pull request ready and merged

**Use it when** a pull request has failing checks, review comments, or conflicts.

1. Handle conflicts first, then review comments, then failing checks. Report conflicts to whoever owns the branch rather than having the agent resolve them on its own.
2. Sort each review comment into fix, dismiss with a reason, or ask. Never dismiss security, privacy, or data findings without a human.
3. Batch fixes, so checks rerun once.
4. Stop at "ready to merge."
5. Before merging, have an agent that didn't write the change verify it in the real app.

## Long run

**Use it when** you want an agent to keep going until something is done.

1. State the finish condition as something that can come out true or false.
2. Each round, make the smallest change the evidence supports, check it, and keep it or throw it out.
3. Log one row per round in a decision log.
4. A plateau means change approach, not stop.
5. Never loosen the finish condition to declare success.
6. If truly stuck, stop and write up why.
7. Ask before anything irreversible.

**The report includes** the finish condition, how many rounds ran, what was kept and thrown out, and where things stand against the finish condition.

## Pause and pick up

**Pause** when a session must end or has filled up.

1. Stop at a safe point.
2. Save everything as a clearly labeled work-in-progress commit.
3. Write a resume note covering the goal, progress, what's verified, the next steps, the key files, and the gotchas.

**Pick up** when a new session takes over.

1. Read the note, the decision log, and the history.
2. Work out what's done and what's left. Don't redo finished work.
3. Verify the important claims against the real thing before building on them.
4. Continue with the matching playbook.

## When nothing fits

For large or unusual work, pstack's `figure-it-out` skill designs a custom playbook before starting. You can ask for the same thing.

```text
This is a big job and none of our usual checklists fit. Before any work, write a plan with a checkable definition of done, the rough size of the job, the riskiest unknowns to tackle first, how each step will be verified, and where you'll need my approval. Keep a decision log as you go.
```
