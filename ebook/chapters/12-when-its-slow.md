# 12. When it's slow

## Measure, don't guess

Slowness is where guessing does the most damage. An agent told "the schedule page is slow" will read the code, spot something that looks inefficient, rewrite it, and report an improvement. Often the part it rewrote wasn't the slow part. Now you have a riskier, more complicated version of code that was never the problem, and the page is as slow as before.

pstack's performance playbook opens with this rule:

> Tie every fix to a measurement, don't read source instead of measuring.

A clinician doesn't adjust blood pressure medication based on how the patient looks. They take a reading, make one change, and take another reading. Speed work is the same.

## Start with a baseline

A baseline is a measurement taken before any change. Without one, "it's faster now" means nothing. pstack's playbook starts by capturing one.

The baseline should come from a trace, which is a detailed timing record of where the time goes during a slow operation. Ask the agent to time both what happens in the browser and what happens on the server, including each database request, because browser tools alone only show that the page is waiting on the server. A trace might show that loading the schedule page takes 3.2 seconds, and that 2.9 of those seconds are spent waiting on the database. That tells you where to look. Reading the code wouldn't.

State the measurement in your request, not a feeling.

```text
The schedule page takes about 3 seconds to load for a clinic with a year of shifts. Capture a timing trace of the page load first and show me where the time goes. Then fix the biggest measured cause and show me the before and after numbers.
```

## Eight places speed comes from

pstack lists eight families of fixes. It's explicit that they're hypothesis generators, not a checklist. You try a family only when the measurement points to it. They're worth knowing because they give you words for what an agent proposes.

**1. Elimination.** Before making something faster, ask whether it needs to happen at all. The schedule page might calculate every nurse's yearly overtime even though the page never shows it. The fastest work is work you don't do. A trace shows what's slow but never shows that it's unnecessary, so this family needs the "how does this work" step from chapter 4.

**2. Divide and conquer.** The cost grows with the size of the input. If searching all shifts gets slower every month, split the work so each piece touches less, or run independent pieces at the same time.

**3. Caching.** The same calculation or lookup happens again and again with the same inputs. Save the answer and reuse it. pstack adds a warning here. Before claiming a caching win, name what makes the saved answer out of date. If you cache the list of open shifts, what happens when someone claims one? A cache with no plan for going stale shows people wrong information.

**4. Indirection.** An in-between step can do the expensive part cheaply. The most common example is an index. A database index works like the index at the back of a book, letting it jump to "shifts for clinic 17 in March" without reading every shift ever posted. Another example is a queue, where slow work gets handed to a background process so the user doesn't wait for it.

**5. Batching.** Many small requests each pay a fixed cost. Combine them to pay it once.

**6. Redundancy.** The wait depends on one slow source. Ask several and take the fastest answer. This is rare in small apps and only helps when there's spare capacity.

**7. Lazy evaluation.** Work gets done before anyone needs it, or for things nobody looks at. Loading a full year of shifts when the nurse is looking at this week is an example. Do the work when it's first needed.

**8. Scheduling.** The work has to happen, but not while someone's waiting. Generate the monthly report overnight, not when the manager clicks "Report." The measurement that matters here is how long the user waits, not how much total work gets done.

## The most common slowness in AI-built apps

One pattern shows up so often in agent-written code that it's worth describing on its own. It's called the "N+1 query," and pstack's own examples mention it.

Say the schedule page shows 50 shifts, each with the name of the nurse who claimed it. The code asks the database for the 50 shifts. That's one trip. Then, for each shift, it makes a separate trip to look up the nurse's name. That's 50 more trips, for 51 total. Each trip is quick on its own, but they add up, and the page gets slower as the clinic grows.

It's like sending someone to the supply room 50 times for 50 items instead of handing them one list. The fix is batching. Ask the database for the 50 shifts and their nurses' names in one or two trips.

N+1 problems are invisible when you test with five shifts, and painful with five thousand. That's why you measure with realistic data.

```text
Check whether any page makes one database request per item in a list. If so, show me the trace, fix it by batching, and show the number of database requests and the load time before and after.
```

## Compare real numbers

After the fix, the agent captures a second trace the same way and compares the two. pstack wants the result reported as a baseline number, a post-fix number, the difference, and where the raw measurements are saved. For example, "Schedule page load went from 3.2 s to 0.6 s, median of 10 loads on the test clinic with a year of data."

Two details in that sentence matter.

- **"Median of 10."** A single measurement is noisy. Anything from network hiccups to other programs running can swing it. pstack's playbooks take several samples and use a typical value.
- **"With a year of data."** The test has to use realistic amounts of data. A fix measured on a tiny test clinic proves nothing about a big one.

## Hillclimbing

Sometimes you want steady improvement on one number over many attempts. Maybe you want the page load under one second, and no single fix gets you there. pstack has a playbook for this called hillclimb. The name comes from taking small steps, each one uphill, toward a goal.

Its core discipline:

> One change, one measurement, keep or revert. Never stack untested changes, and never claim a win from code inspection.

The steps, in plain terms:

1. **Pick a realistic case and a goal.** Use a case that shows the problem. Pick one number to improve, which direction is better, and when to stop. pstack pairs a target with a minimum number of attempts, such as "at least 50% faster and at least 10 attempts," so a lucky early result doesn't end the run too soon.
2. **Build the measuring tool, prove it works, and then freeze it.** The measurement script must not change during the run. If it changes, your before and after numbers aren't comparable.
3. **Keep a log.** Record one row per attempt, with the idea, the change, the before and after numbers, whether the tests still pass, and whether it was kept or reverted.
4. **Base each attempt on a specific reason.** "Move the overtime calculation out of the page load, because the trace shows it takes 40% of the time" is a real hypothesis. "Try caching something" isn't.
5. **Make one change per attempt.** Keep it only if the number moves by more than the normal noise and all tests still pass. Otherwise, undo it completely.
6. **Don't stop at the first plateau.** When several attempts in a row fail, try a different family of fix or look more closely at the code before deciding you're done.

One rule in the hillclimb playbook ranks correctness above speed:

> Correctness and simplicity outrank the number. Revert a win that breaks behavior, and keep a simplification that holds the number.

A faster page that shows wrong shifts isn't an improvement. And a change that makes the code much simpler without slowing it down is worth keeping even if it doesn't speed anything up.

## In practice

- Never accept a speed fix without before and after numbers.
- Start with a trace that shows where the time actually goes.
- Test with realistic amounts of data.
- Ask whether the slow work needs to happen at all before making it faster.
- Watch for one-request-per-item patterns, and batch them.
- For caching, ask what makes the saved answer go stale.
- Make one change at a time, measure it, and undo it if it didn't help.
