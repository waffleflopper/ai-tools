# 11. Fix bugs at the root

## Treating the fever

A fever-reducer brings a fever down. It doesn't treat the infection causing it, and it can hide whether the infection is getting better or worse. It's useful for comfort. As the only treatment, it's malpractice.

Most bug fixes an agent offers on its own are fever-reducers. The app crashes when a nurse's profile has no phone number, so the agent adds a check that skips the step when the phone number is missing. The crash stops. But why was there a nurse with no phone number, when the sign-up form requires one? That question never gets asked. The missing data is still getting in from somewhere, and now nothing complains when it does.

pstack's principle:

> When debugging, do not fix symptoms. Trace every problem to its root cause and fix it there.

And the reason:

> Symptom fixes accumulate. Each workaround makes the system harder to reason about, and the real bug remains.

Every patch that silences a symptom is one more piece of code to understand. Pile enough of them up and nobody can tell which checks matter. That's a large part of what makes vibe-coded projects so hard to maintain.

## The pattern

pstack's root-cause principle has six parts.

1. **Reproduce first.** Make the bug happen on purpose before changing anything. If you can't trigger it, you can't prove you fixed it.
2. **Ask "why" until you hit the root cause.** This is the "five whys" method used in hospital root-cause analysis and in manufacturing. The app crashed. Why? The phone number was empty. Why? The profile was created without one. Why? The bulk staff import skips the phone column when it's formatted differently. Why? The import has no check at the boundary. There's your fix, and it's nowhere near where the crash happened.
3. **Don't add guards.** pstack's words are "adding a nil check to silence a crash is a symptom fix." A nil check is a test for "is this value missing?" that quietly skips the code if so. It's the fever-reducer.
4. **Treat a long justifying comment as a warning.** If a workaround needs a paragraph of explanation next to it, the code is wrong. Fix the code.
5. **Fix the pattern, not only the instance.** If one screen had this bug, search for every other place with the same pattern and fix them all.
6. **When stuck, instrument. Don't guess.** Add logging, read the actual error, and watch what the code really does.

## A differential diagnosis for code

pstack's bug-fix playbook describes a method any clinician will recognize. List the possible causes, then run the tests that rule out the most possibilities at once, until one cause is left.

The playbook calls this "binary-searching the cause." With each step, you pick the test that cuts the remaining possibilities roughly in half. Is the reminder wrong before it's saved or after? After. Is it wrong when the job reads it or when it sends it? When it sends it. Each answer throws away half of the places the bug could be.

The important rule is that every step uses runtime evidence, meaning what the code actually did when it ran. Reading the code and reasoning about it gives you hypotheses. Running it gives you evidence.

> When program state is unclear, add instrumentation or logging and read it as the code runs. Don't guess.

## The bug-fix playbook

Here's pstack's full bug-fix playbook in plain terms.

1. **Reproduce it yourself, in the same place the user saw it.** If the bug is in the phone app, reproduce it in the phone app. The agent should do this itself, not ask you to do it, unless it truly can't reach that part of the system.
2. **Find the cause.** List hypotheses, test them against runtime evidence, and eliminate until one survives. Confirm how the bug happens, not just where.
3. **Plan the fix.** If the fix crosses between parts of the system, design it first, as described in chapter 6.
4. **Verify in the same place.** The original reproduction now passes. "Inconclusive" or "checked somewhere else" doesn't count.
5. **Save the failing test before the fix.** Where a cheap test is possible, the project history shows the test failing first and the fix making it pass, as in chapter 10.
6. **Open a pull request** with the evidence.

The reply should say what was broken, the root cause, the fix, and how it was verified, with the failing-then-passing output pasted in.

Two rules in this playbook are worth repeating to any agent.

> Belt-and-suspenders that "might help" is a hypothesis, not a fix. It does not ship.

Agents like to add extra safety changes "just in case." Each one is untested code and an extra thing to maintain. If there's no evidence it's needed, it doesn't go in.

> When evidence refutes a hypothesis, revert what it motivated.

If the agent changed something because it suspected cause A, and cause A turns out to be wrong, that change comes back out. Otherwise the code fills up with leftovers from wrong guesses.

```text
Some nurses see a shift on the wrong day. Reproduce it first, in the nurse app. Then find the cause using evidence from running the code, not by reading it and guessing. Show me the failing case, the root cause, the fix, and the same case passing. Don't include any changes that aren't backed by evidence.
```

## When it breaks after a restart

pstack has a specific rule for restart bugs. When something works until you restart it and then fails, suspect stored state before suspecting the code.

"State" here means anything saved between runs, such as settings files, cached data, leftover lock files, or saved progress. If a background job worked yesterday and fails after a restart today, the code probably didn't change. Something it saved probably did. If clearing a saved file fixes it, the real fix is to make the code handle bad or stale saved state properly. That connects to chapter 8's point about cleaning up on startup.

## When two fixes fail, question the diagnosis

Sometimes you try a fix, it doesn't work, and you try another, and that doesn't work either. The natural move is to try a third. pstack has a principle for this moment, called attack the premise.

> When two or more fixes that share one premise have failed the same gate, suspect the premise, not the fixes.

A premise is the belief every fix assumed. In medicine, if a patient doesn't respond to two different antibiotics, a good clinician doesn't reach for a third. They ask whether it's a bacterial infection at all.

Here's a ClinicDesk example. The app auto-assigns open shifts to available staff. Nurses complain that the same few people always get stuck with the worst shifts. The first fix adds a weekly cap on shifts per person. Complaints continue. The second fix adds a "rebalance" button for managers. Complaints continue. Both fixes assumed the same thing, that there are simply too many bad shifts to go around.

pstack's steps:

1. **Write the premise down.** "There are too many bad shifts to spread evenly."
2. **Take a census before trying another fix.** Count the imbalance per person. The census doesn't measure how big the problem is. It measures who holds it. Make it a script you can rerun.
3. **Read the skew.** The census shows that the same three nurses get most of the weekend night shifts every single week. When the same few hold most of the imbalance every time, something is assigning them that role. In this case the auto-assigner walks the staff list alphabetically, and those three names come first.
4. **Remove the imbalance at its source.** Rotate where the assigner starts, or randomize it. Don't compensate for the imbalance afterward.

That last step matters. The cap and the rebalance button both left the alphabetical assignment in place and added work every week to undo its effects. pstack is specific that a periodic rebalance or a return path "leaves the assignment in place and adds work on every run." Fixing the assigner removes the problem, and both workarounds can be deleted.

And if the census comes back even, with no skew at all, then the premise really isn't the cause, and you look elsewhere. Either way, you stop throwing fixes at a wrong diagnosis.

```text
We've tried two fixes for this and neither worked. Before trying a third, write down the one assumption both fixes made. Then write a script that counts where the problem actually shows up, broken down by user. Show me the counts before proposing anything.
```

## In practice

- Refuse fixes that only silence the symptom, such as extra checks added right where a crash happened.
- Reproduce first, in the same place the user saw it.
- Ask "why" until the answer points to where the problem starts.
- Use runtime evidence to rule causes in and out. Reading code gives you guesses.
- Remove any change that was based on a guess that turned out wrong.
- Fix every instance of the pattern, not just the one reported.
- After two failed fixes, write down the shared assumption and count the problem before trying again.
