# 9. Prove it works

## "Done!" is not evidence

Every agent you work with will, many times, report that a task is complete and working when it isn't. Usually it isn't lying on purpose. The code compiled, nothing crashed, and the agent concluded that the job was done. Sometimes it ran a check that couldn't have failed. Sometimes it checked the wrong thing.

pstack's principle for this is short.

> Verify every task output by checking the real thing directly. Do not infer from proxies, self-reports, or "it compiles."

Before a surgeon closes, the team counts the sponges and instruments. Nobody asks the surgeon whether they think everything's out. Nobody checks that the tray looks about right. They count the actual items against the actual number. That's what this chapter asks of every change.

## Proxies and self-reports

A proxy is something related to the thing you care about that's easier to check. A self-report is the agent telling you how it went. Both feel like evidence, and neither is.

Common proxies agents rely on:

- **"It compiles" or "the build passed."** That shows the computer can read the code. It says nothing about whether the code does the right thing.
- **"The tests pass."** That's only as good as the tests. Chapter 10 shows how tests can pass while checking nothing.
- **"CI is green."** All the automated checks passed. pstack says flatly that "green is not safe." Green means the checks you have didn't catch anything. It doesn't mean nothing is wrong.
- **"The file was updated."** A file's timestamp changed. That doesn't show the contents are right.
- **"The subagent said it worked."** A report about the work isn't the work.

pstack's direct-evidence rules:

- **Check the actual value.** If the fix was supposed to save a nurse's phone number correctly, read the saved phone number from the database. Don't infer it from the absence of an error.
- **Check the actual process.** If a background job is supposed to be running, check that it's running. Don't conclude it from a status file it wrote an hour ago.
- **When a check fails strangely, suspect the check first.** Before concluding the system is broken, make sure the way you looked is right.

## Put the finish condition in the first message

Chapter 3 introduced the finish condition. This is where it pays off. If your first message says what "done" means in checkable terms, the agent has something concrete to verify against, rather than a feeling to satisfy.

```text
Add an email option to appointment reminders. The text-message reminders must stay exactly the same. Done means a test appointment produces one email with the right time and clinic address, the text-message output is unchanged from before, and you show me both.
```

When the reply comes back, it should include what was run and what came out. pstack's guide says:

> Treat a confident reply without evidence as a red flag.

## Match the check to the change

Different changes need different proof. pstack's guide gives a list worth keeping handy.

- A command-line tool change runs the real command.
- A screen change walks through the changed flow in the running app.
- A change to how data gets read or converted replays saved real input.
- A speed change compares measurements from before and after.
- A storage change reads back what was written.

ClinicDesk examples:

- **New "decline shift" button.** Open the app, log in as a nurse, decline a shift, and confirm the manager's view updates. A screenshot or a recording of the steps is the evidence.
- **Fix to reminder timing.** Create a test appointment, run the reminder job, and look at the exact message it would send and when.
- **Change to how payments get recorded.** Run a test payment and read the resulting record from the database.

## "Inconclusive" is an honest answer

Sometimes a check can't be run. The test environment is down, or the change affects something that only exists in production. pstack is firm about what happens then.

> A verdict is VERIFIED, NOT VERIFIED, or INCONCLUSIVE. Inconclusive is not a pass.

pstack also rules out checking on the wrong surface. If the bug was on the phone app, a passing check in the web app doesn't count.

You want your agent to say "I couldn't verify this, and here's why." An honest "inconclusive" lets you decide what to do. A false "verified" hides a problem until a user finds it.

## How sure are you? A five-step ladder

pstack's `blast-radius` skill gives a ladder for how well a claim has been proven. Use it to judge an agent's claims.

1. **You said so.** Worthless on its own.
2. **You pointed at the line.** The agent shows the specific place in the code.
3. **You showed the bad case can't happen.** The agent walks through the failure step by step and shows it can't be reached.
4. **You ran it.** A script or test calls the real code and would fail loudly if the claim were wrong.
5. **You reproduced it in the running app.**

Most agent claims sit at step 1. Ask where on the ladder each claim sits, and push the important ones to step 4 or 5.

```text
You said this change can't affect billing. Where is that on the proof ladder? Get it to "ran it" with a script that calls the real billing code.
```

## Find the one fact that makes it safe

The same skill has a second idea worth borrowing. Most changes that look risky are safe because of one specific fact. A change to delete old reminder records might be safe because "it only deletes reminders for appointments that are already cancelled." If that fact is true, most of the scary scenarios can't happen.

So instead of writing a long list of everything that might break, the agent finds that one fact and proves it by running code. pstack's reasoning:

> A blast-radius writeup that sounds right is worthless. It reads as convincing whether or not it's true.

Agents are very good at writing convincing paragraphs. A script that runs and passes is harder to fake.

## Script the check

A one-time manual check proves the change worked once. A script proves it every time, and anyone can rerun it. pstack says:

> The strongest proof is a deterministic script that re-runs the same comparison, not a one-time eyeball.

"Deterministic" means it gives the same result every time you run it on the same code. When a script does the verification, a reviewer doesn't have to take anyone's word for it. They can run it. pstack calls this turning "trust me" into "run this." Chapter 15 covers the broader version of this idea.

## A standard way to drive your app

Screen changes are the hardest to verify, because the agent needs a way to open and use your app like a person would. pstack includes a skill that sets this up once per project. It's called `create-verification-skill`, and it writes a guide that any agent can follow to verify your app, with these parts:

- **Launch.** The exact command that starts the app, and how to tell it's ready.
- **Doctor.** A quick check that the running copy is healthy and is the right version.
- **Drive.** How to use the app by script, clicking and typing like a user.
- **Evidence.** What to capture as proof, such as screenshots, messages sent, or records saved.
- **Cleanup.** How to shut down what the check started, while keeping the evidence.

It also keeps a feature map, a list of what your app does and what result proves each feature works. Its proof standards are worth adopting on their own.

- Use the real user path. Don't use shortcuts or test-only back doors.
- Capture the action and the result, not just the final screen.
- Check side effects too, such as records saved and messages sent, alongside what's visible.
- Don't trust a "dry run" or "test mode" to do what its name says. Look at what it actually touched.

You can ask any agent to build something like this for your project. It's worth doing early. After that, "verify it in the app" becomes a step any agent can carry out.

## The builder shouldn't be the only checker

In some high-risk settings, one person does the work and a second person checks it, because people are bad at catching their own mistakes. The Army requires two-person integrity for its most sensitive material, where no one person may handle it alone. Hospitals require an independent double check for high-alert medications like insulin.

pstack applies the same rule. Before it merges code, it has a fresh agent that didn't write the change verify the behavior. In its words, "the agent that judges a change is never the one that wrote it." An agent reviewing its own work tends to see what it meant to write.

You can do this with any tool. Start a new conversation, give it the change and the goal, and ask it to try to prove the change is wrong. Chapter 13 covers this under code review.

## In practice

- Never accept "done" without evidence, and treat a confident reply with no proof as a warning.
- Check the real thing, like the saved value, the running app, or the message actually sent. Not a proxy.
- Put the finish condition in your first message.
- Accept "inconclusive" as honest and reject "verified" without proof.
- Use the five-step ladder, and push important claims to "ran it" or "reproduced it."
- Prefer scripted checks anyone can rerun, and have someone other than the builder do the checking.
