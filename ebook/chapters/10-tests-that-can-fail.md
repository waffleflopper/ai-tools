# 10. Tests that can actually fail

## What a test is for

A test is a small program that runs a piece of your code with a known input and checks for a known result. You write it once, and it runs automatically every time anything changes. When a change breaks something the test covers, the test fails and tells you.

That's the whole value of a test. It can fail when something is wrong. A test that can't fail catches nothing. It still costs time to run and time to maintain, and it's worse than nothing, because it makes you think you're protected.

The opposite problem is just as real. A test that fails when nothing is wrong, every time someone tidies the code, teaches everyone to ignore it. Then it can't warn anyone about a real problem either.

Agents write a lot of both kinds. They're easy to produce, they pass on the day they're written, and they make the test count go up. pstack has a principle for the first problem. This chapter adds rules of my own for the second, and for deciding which of your existing tests are worth keeping.

## The lab analogy

A clinical lab runs quality control on its tests. One standard practice is to run a positive control, a sample known to contain the thing being tested for. If the assay doesn't flag the known positive, the assay is broken, and every "normal" result it produced is worthless.

A test that can't fail is like an assay that reports "normal" for every sample. It passes every check that only asks whether it produced a result. It'll never find a problem.

## The check

pstack's principle, test behavior not implementation, gives one check to run on any test:

> Before you keep a test, ask whether it would still pass if every function it imports returned `undefined`.

Put plainly, would this test still pass if the code it's testing did nothing at all? If yes, the test isn't testing anything. Rewrite it or delete it.

You can ask an agent to apply this check to every test in your project. It's one of the fastest ways to find out how much of your test suite is real.

```text
Go through our tests. For each one, tell me whether it would still pass if the code it tests did nothing and returned nothing. List the ones that would, and for each, either rewrite it to check a real result or recommend deleting it.
```

## Five kinds of tests that can't fail

pstack lists five common shapes. Here they are with ClinicDesk examples.

**1. No real check.** The test runs the code and then only confirms that it didn't crash, or that it returned something. "Calling the reminder function returns a result." Any result counts, including an empty or wrong one.

**2. Checking that a call happened, not what it did.** Tests often swap real outside services for fakes, called mocks. The fake text-message service doesn't send real texts. It records what it was asked to send. A weak test checks only that the fake was called. "The text service was called." It doesn't check the message, the phone number, or the time. The code could send the wrong message to the wrong person and the test would pass.

**3. Grading its own homework.** The expected answer comes from the same code being tested. "The formatted phone number equals whatever the phone formatter returns." That's always true, even when the formatter is wrong.

**4. Restating a setting.** "The reminder window is 24 hours." The test just repeats a value from a settings file. It can't catch a bug, because no logic runs. And when you deliberately change the setting to 48 hours, the test fails and has to be edited. It blocks good changes and catches no bad ones.

**5. Testing the test's own data.** The test builds some fake data, then checks that the fake data looks the way it built it. A close cousin tells a fake service to return a certain answer, then checks that the answer came back. Either way, the test only reads back what it wrote.

## What a good test looks like

pstack's rule for a good test:

> A test calls the code the way its users do and asserts the result they observe against a literal expected value.

"Literal expected value" means the test spells out the exact right answer, written by hand.

```text
formatPhone("(555) 123-4567") should equal "+15551234567"
```

That test gives one concrete input and one exact expected output. If the formatter breaks, the test fails. If someone rewrites the formatter completely but it still produces the right answer, the test still passes. That's what you want.

The expected answer came from someone who knew what a correct phone number looks like, not from the code. That's why it can disagree with the code, and a test whose answer can't disagree with the code can't catch a mistake in it.

This is the "behavior, not implementation" part. Behavior is what the code does from the outside, meaning the result a user or caller sees. Implementation is how it does it inside. Tests should check behavior. A test that checks implementation details breaks every time someone improves the code, even when the result is identical. People learn to ignore tests like that, which defeats the point.

pstack's fixes for the weak shapes:

- Instead of checking that a fake service was called, check what it was called with, meaning the exact message and phone number, or check the state afterward.
- When a test checks that something is absent, also check that it's present in the case where it should be. "Cancelled appointments get no reminder" should sit next to "active appointments get exactly one reminder."
- Instead of restating a setting, test the logic that uses the setting, with one input.
- When no good check exists, delete the test.

## Tests that fail when nothing is wrong

This section and the next three go beyond pstack. pstack's principle notes that tests of implementation details break when the code improves. The rules here come from `prune-tests`, a skill I wrote for cleaning up test suites.

Hospitals have a name for this problem, alarm fatigue. When monitors beep all day for things that don't matter, like a loose lead or a patient shifting in bed, staff learn to tune them out. Then the alarm that matters gets missed. A test suite can train people the same way.

Engineers call these change-detector tests. A change detector fails whenever the code or the screen changes, without pointing to anything that became wrong. When it goes red, the only fix is to update the test to match the new code. After the tenth time, people and agents do that without looking.

Here are the common shapes, with ClinicDesk examples.

**1. Reading the code instead of running it.** The test searches the text of the code. "The shifts file uses the date formatter." "There's a file called reminders." Nothing runs, so no behavior gets checked. Rename the date formatter and the test fails, even though every date on screen still looks right.

**2. Counting things.** "The schedule screen has 14 boxes on it." "The app has 22 pages." "The reminder module offers four functions." Add a helpful label to the schedule screen and the count is off, though nothing is broken.

**3. Saving a copy of the structure.** A snapshot test saves a copy of something, such as the behind-the-scenes code that draws the shift list, and fails if the next copy differs at all. Move a button or change a color and it fails. The agent saves a new copy to make it pass, and nobody reads the difference.

**4. Checking the inside steps.** "Claiming a shift runs the calendar check, then the save step, in that order." That's how the code happens to work today. If someone combines the two into one faster step, the test fails, even though claiming a shift works exactly as before.

**5. Checking the same thing again.** One rule gets checked by three tests at three different levels. The extra two add nothing except more places to update when the rule changes on purpose.

Delete these. Sometimes a real rule is hiding inside one. In that case, replace it with the smallest test that checks the rule itself. Say a test searches every endpoint's code for the words "check permission." The real rule is that nobody can use an endpoint they aren't allowed to use. So test that. Send each endpoint a request as a nurse from a different clinic and confirm it's refused. That test fails for exactly the problem you care about, and it doesn't care what the permission check is called.

```text
Look through our tests for change detectors, meaning tests that read the code instead of running it, count things, save snapshots of structure, check which internal steps ran, or repeat another test. List each one. If a real rule is hiding inside it, tell me the smallest test that would check that rule directly. Don't change anything yet.
```

## Looks, wording, and small screen details

Three more areas where tests often check the wrong thing.

**Looks.** A test that checks sizes, positions, widths, or colors is checking appearance, not behavior. A button can be exactly 120 pixels wide and still do nothing when tapped. Check looks by eye instead. Have the agent take screenshots, as chapter 9 describes, and review them yourself. Automated screenshot comparison belongs in your tests only if you've decided on purpose that it's worth the upkeep.

A test can still pretend to be a phone, since some problems only show up on a small screen. What it checks should be a task. "A nurse on a phone-sized screen can scroll to an open shift and tap Claim" is a test. "The shift list is no wider than the screen" is a measurement.

**Wording.** Tests need a way to find buttons and fields, and the best way is by their labels, like the "Claim shift" button. Screen readers, the software that reads the screen aloud for people who can't see it, use those same labels. So the labels are part of how people use your app, and finding things by label is fine. If you rename a button on purpose, updating the test to match is fine too.

Checking the exact sentences on the screen is different. Check exact wording only when the wording itself is a requirement. The opt-out line in a reminder text, "Reply STOP to unsubscribe," may be required by law, so a test that checks it word for word earns its place. The friendly message after a nurse claims a shift doesn't. Check what happened instead. The shift shows the nurse's name, and it's gone from the open list.

**Focus and grayed-out buttons.** Focus is the part of the screen the keyboard is pointed at, like the form field with the blinking cursor. Sometimes where the focus goes, or whether a button is grayed out, is the whole point of the feature. These deserve a test:

- When a nurse submits a form with a mistake, the cursor jumps to the first field that needs fixing.
- When a pop-up closes, the keyboard goes back to where the person was before it opened.
- The Save button lights up after a real edit, and goes gray again if the person changes the value back.

Tests that only confirm a button is gray because the code said to make it gray, or that the cursor stayed put when nothing happened, check nothing a user would notice. Delete them.

## The bar for keeping a test

"Would it pass if the code did nothing?" catches tests that can't fail. Change detectors pass that check, so you need a fuller one. A test is worth keeping when the answer to all six of these questions is yes.

1. **Does the right answer come from outside the code?** It should come from a requirement, a bug report, an accessibility rule, a worked example, or some other independent source. "Clinic policy says reminders go out 24 hours ahead" counts. "That's what the code does" doesn't.
2. **Would a failure be something a user or caller recognizes?** "The patient got no reminder" is recognizable. "The helper ran twice" isn't.
3. **Could the expected answer disagree with the code?** If it was copied from the code, it can't.
4. **Does it use the code the way users do?** It should go through the front door, meaning the screen, the endpoint, or the function other code calls, not the internal pieces.
5. **Would it survive a rewrite of the insides?** That includes changes to wording or layout that nobody would call a bug.
6. **Is it at the lowest level that proves the behavior, and is it the only test checking it?**

The last question needs a little explaining. Tests run at different levels, and lower levels are faster and more reliable.

- **Rules.** One calculation or rule, run on its own, like overtime pay or "is this shift in the past?" These are fast, so this is where to try lots of variations.
- **Operations.** One complete action on the backend, like claiming a shift, which checks permission, checks for conflicts, and saves. This is where to test who's allowed to do what, and what gets saved.
- **Screen parts.** One piece of a screen, like the card for a single shift, tested on its own to confirm it responds correctly when someone uses it.
- **End to end.** A robot drives the whole app like a person would, from logging in to seeing the result. These are slow and break for unrelated reasons, so save them for the handful of workflows that must never break.

Pick the lowest level that can prove the behavior. For the Save button above, the twenty ways someone might type the same phone number belong in rule tests, which decide whether an edit is real. One screen-part test then confirms that Save lights up after a real edit. That covers it. You don't need twenty screen tests.

When a test is in doubt, delete it. Keeping it, or rewriting it, needs a written reason that answers all six questions. If any answer is weak, delete it. A rewrite keeps only what it needs to prove the one behavior. It doesn't need to be as long as the old test or check as many things.

Don't judge a test suite by its size. Some projects set a coverage target, meaning a minimum share of the code that the tests run. A coverage target is easy to hit with tests that run code without checking anything. If deleting fake tests drops you below the target, the target is the problem. Say so and change the target. Don't write new fake tests to meet it.

## Pruning the tests you already have

Most projects built with agents already have plenty of tests that fail these checks. The `prune-tests` skill follows the steps below, and you can ask any agent to do the same. The skill is free at `github.com/waffleflopper/ai-tools`, alongside this book.

1. **Set the scope.** Pick one feature, one pull request, or the whole project, and keep to it.
2. **Get a report first.** In this round, the agent looks and recommends but deletes nothing. Say so plainly, because agents like to start fixing as soon as they find something.
3. **Judge each test, not each file.** One file can hold one good test and five bad ones. Every test gets one verdict, which is delete, rewrite, or keep. Every keep and every rewrite comes with its answers to the six questions.
4. **Read the report and approve it.** Push back on any keep whose answers are vague.
5. **Clean up.** The agent deletes and rewrites what you approved. It also removes the helpers, fake data, and saved snapshots that only the deleted tests used. It doesn't change how the app works just to keep a test passing, and it doesn't touch tests outside the scope.
6. **Run every check.** That means the tests, the type checker, the linter, and anything else CI runs. If a check fails because of a minimum test count or coverage target, the agent reports that to you rather than writing new fake tests.

```text
Review the tests for shift claiming. Don't change anything yet. Give each test a verdict of delete, rewrite, or keep, with delete as the default. For each keep or rewrite, answer all six: where the right answer comes from outside the code, what a user would notice if it failed, why the expected answer could disagree with the code, how it uses the code the way users do, why it would survive a rewrite of the insides, and why it's at the lowest level without repeating another test.
```

## Write the failing test first

The strongest way to fix a bug uses a test in a particular order. It's called test-driven development, or TDD, and pstack includes a skill for it. For bugs, the steps are:

1. **Understand the bug.** What should happen, what happens instead, and the smallest way to trigger it.
2. **Write a test that reproduces the bug.** It checks for the correct behavior, so it should fail right now.
3. **Run it and watch it fail.** Confirm it fails for the right reason. If it passes, or fails for some unrelated reason, the test is wrong. Fix the test before touching the code.
4. **Fix the bug** with the smallest change that makes the behavior correct.
5. **Run the test again and watch it pass.**

Step 3 is the positive control. Watching the test fail first proves it can detect the bug. A test written after the fix, which has only ever passed, has never shown it can catch anything.

It also leaves you a permanent guard. If a future change brings the bug back, the test fails.

pstack's bug-fix playbook arranges the history so the failing test is saved before the fix. Anyone reviewing it can see the test go red, then green.

```text
Nurses who claim a shift that crosses midnight are seeing it on the wrong day. Write a test that reproduces this and show me it failing. Then fix it and show me the same test passing.
```

## When not to write a test

pstack's TDD skill is practical about this. Don't force a test when it would need huge setup, fragile fakes of many services, slow full-system runs, or conditions that only exist in production. In those cases, use the closest useful check instead, such as a script that reproduces the problem, a recorded before-and-after comparison, or a check in the running app.

> Prefer no new test over a bad test.

A bad test, in pstack's words, is one that "mostly tests mocks, encodes current implementation details, depends on timing or unrelated global state, needs expensive infrastructure for a small fix, or would be deleted immediately after proving the fix."

## Watch for tests being bent to fit

Agents have one more habit to watch for. When a test fails after a change, an agent will sometimes "fix" it by changing the test's expected answer to match whatever the code now produces. Sometimes that's right, because the correct behavior really did change. Often it's covering up a bug.

pstack's rules:

- Don't change tests just to match a wrong implementation.
- Don't weaken an existing check unless the expected behavior really changed and the reason is clear.

When an agent's diff changes a test, ask why that test's expected answer changed, and whether the old answer was actually wrong.

## Tests that pin current behavior

One more kind of test matters for projects that already exist. Before restructuring code, pstack's refactoring playbook asks for a characterization test. It records what the code does today, right or wrong, so you can prove a restructuring changed nothing. Chapter 14 covers this in detail.

A characterization test is a change detector on purpose. During a restructuring, any change in behavior is a mistake, so a test that fails at any change is exactly what you want. Treat it like scaffolding, though. When the restructuring is done, keep the parts that pass the six questions and delete the rest.

## In practice

- Ask of every test whether it would still pass if the code did nothing.
- Good tests use one concrete input and check against an exact answer written by hand.
- Check what was sent or saved, not just that something was called.
- Delete tests that break when code changes but nothing is wrong, such as ones that read the code, count things, or save snapshots of structure.
- Check looks by eye, and check exact wording only when the wording is a requirement.
- Keep a test only when it passes all six questions, and test each behavior at the lowest level that proves it.
- When pruning, get a report first, judge each test on its own, and don't write fake tests to hit a coverage target.
- For bugs, write the test first and watch it fail before fixing.
- Skip tests that would be fragile or expensive, and use a real check instead.
- Question every change an agent makes to a test's expected answer.
