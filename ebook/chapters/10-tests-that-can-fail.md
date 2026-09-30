# 10. Tests that can actually fail

## What a test is for

A test is a small program that runs a piece of your code with a known input and checks for a known result. You write it once, and it runs automatically every time anything changes. When a change breaks something the test covers, the test fails and tells you.

That's the whole value of a test. It can fail when something is wrong. A test that can't fail catches nothing. It still costs time to run and time to maintain, and it's worse than nothing, because it makes you think you're protected.

Agents write a lot of tests like that. They're easy to produce, they always pass, and they make the test count go up. pstack has a principle for this problem.

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

**5. Testing the test's own data.** The test builds some fake data, then checks that the fake data looks the way it built it. The real code never runs.

## What a good test looks like

pstack's rule for a good test:

> A test calls the code the way its users do and asserts the result they observe against a literal expected value.

"Literal expected value" means the test spells out the exact right answer, written by hand.

```text
formatPhone("(555) 123-4567") should equal "+15551234567"
```

That test gives one concrete input and one exact expected output. If the formatter breaks, the test fails. If someone rewrites the formatter completely but it still produces the right answer, the test still passes. That's what you want.

This is the "behavior, not implementation" part. Behavior is what the code does from the outside, meaning the result a user or caller sees. Implementation is how it does it inside. Tests should check behavior. A test that checks implementation details breaks every time someone improves the code, even when the result is identical. People learn to ignore tests like that, which defeats the point.

pstack's fixes for the weak shapes:

- Instead of checking that a fake service was called, check what it was called with, meaning the exact message and phone number, or check the state afterward.
- When a test checks that something is absent, also check that it's present in the case where it should be. "Cancelled appointments get no reminder" should sit next to "active appointments get exactly one reminder."
- Instead of restating a setting, test the logic that uses the setting, with one input.
- When no good check exists, delete the test.

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

## In practice

- Ask of every test whether it would still pass if the code did nothing.
- Good tests use one concrete input and check against an exact answer written by hand.
- Check what was sent or saved, not just that something was called.
- For bugs, write the test first and watch it fail before fixing.
- Skip tests that would be fragile or expensive, and use a real check instead.
- Question every change an agent makes to a test's expected answer.
