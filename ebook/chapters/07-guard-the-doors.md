# 7. Guard the doors

## Check at the gate

On a military installation, you show ID at the gate. Once you're through, you don't get stopped at every hallway to prove who you are again. The gate does the hard check, and everything inside can rely on it having been done. Restricted buildings still check whether your badge grants access to that building. That's part of the entry check for that building, not a repeat of the gate.

That design works because it's clear where the gate is and because the gate is thorough. It would fail badly if some fence sections had no gate, or if the guards only glanced at IDs because "the buildings will check."

pstack's principle of boundary discipline applies the same design to software.

> Place validation, type narrowing, and error handling at system boundaries. Trust internal code unconditionally.

Validation means checking data. Type narrowing means confirming exactly what kind of data it is, so the rest of the code can rely on that.

A boundary is any place where information enters your system from outside. For ClinicDesk, that includes:

- Anything a user types or sends from a browser or phone.
- Responses from outside services, such as the text-message provider or the payment processor.
- Files someone uploads.
- Settings files and environment variables.
- Data read back from the database.

That last one surprises people. pstack's type-system principle lists database rows as external data. Something else may have written them, an old version of your code may have written them, or someone may have edited them by hand.

## What happens at the boundary

At the boundary, you do three things.

1. **Check it.** Is this actually a phone number? Is the shift date in the future? Does this shift ID exist?
2. **Convert it.** Turn the raw input into a clean, trusted record your code understands. A phone number typed as "(555) 123-4567" becomes one standard format. From here on, the rest of the code handles one format, not five.
3. **Reject it clearly.** If it's bad, say so and stop right there, with an error message that says what's wrong.

pstack's name for the second step is parsing. It's more than checking. A check says "this looks fine" and passes the raw input along. A parser turns the raw input into a different, trusted thing, so there's no confusion later about whether it was checked.

## What happens inside

Inside the gate, the code trusts what it receives. That means no repeated checks deep in the system for things the boundary already handled.

This feels backwards to many people. More checks sound safer. pstack says otherwise:

> Scattered validation is noisy, redundant, and gives a false sense of safety.

When checks are scattered everywhere, nobody knows which ones matter. Some are strict and some are loose. When a real gap exists, it hides among dozens of redundant checks. And every scattered check is code to maintain. Agents are especially prone to this. When a crash happens, the easy fix is to add a check right where it crashed. Chapter 11 explains why that's usually the wrong fix.

pstack gives two questions to ask about any check:

- "Is this data crossing a system boundary right now?" If not, the check is redundant.
- "Can this be a pure function that the rest of the code just calls?"

## Pure functions

A pure function takes inputs and returns an output, and it does nothing else. It doesn't save anything, send anything, or depend on anything except its inputs. Give it the same inputs and you always get the same answer.

A dosage formula is like a pure function. Given a weight and a drug, it gives an amount. Giving the medication is not pure. It changes the world, and you can't take it back.

pstack's advice is to keep your business rules in pure functions and keep the outer layer that saves, sends, and displays thin and simple. "Can this nurse take this shift?" should be a pure function. It takes the nurse's schedule and the shift and returns yes or no with a reason. The code that looks up the schedule and saves the claim sits around it.

Two benefits follow. Pure functions are easy to test, because you give them inputs and check the output without setting up a whole running app. And they're easy to understand, because nothing hidden can change their answer.

## Let the type checker do the work

Chapter 2 introduced types, the labels that say what kind of thing each piece of data is. pstack treats the type checker as a tool that proves things about your code before it runs. Used well, it makes whole kinds of bugs impossible. You don't need to write types to benefit. You need to know what to ask an agent for.

### Make impossible situations impossible to write down

Picture a paper discharge form with a checkbox labeled "Discharged" and a separate blank labeled "Discharge date." Someone can check the box and leave the date empty. What does that mean? Nobody knows. Each person who reads the form has to decide.

A better form has only the date field. If there's a date, the patient was discharged. If not, they weren't. The contradiction can't be written down.

pstack's type-system principle uses nearly the same example. A record with "completed: yes or no" and a separate optional "completed at" date allows "completed, with no date," which is meaningless. The fix is either to work out "completed" from whether a date exists, or to define the states explicitly as "open" or "done at this time."

Its test for this problem:

> Can I write a comment explaining when this combination of fields is valid? If yes, the type is too loose.

This is the same idea as the shift status in chapter 6, enforced by the type checker so no agent can break it later.

### Don't let look-alike values mix

A patient ID and a room number might both be plain numbers. If a function takes both, it's easy to pass them in the wrong order. The computer won't notice, and you'll assign a patient to the wrong record. That's the software version of skipping the wristband scan.

pstack recommends giving values like these their own distinct type, which it calls branding. A patient ID and a room number are both numbers underneath, but the type checker refuses to let one stand in for the other. You check the value once when it's created, and after that the type checker keeps track of it.

```text
We have several kinds of IDs that are all plain strings: staff IDs, shift IDs, clinic IDs. Make them distinct types so they can't be mixed up, and check each one where it enters the system.
```

### Don't lie to the type checker

Most typed languages have escape hatches that tell the type checker, "Trust me, this is fine." In TypeScript, the common ones are `any` and `as`. Agents reach for them constantly, because they make errors go away.

pstack calls these "latent runtime crashes." The type checker couldn't prove the code was safe, and the escape hatch told it to stop asking. When an agent uses one, ask why. Usually the real fix is to check the data properly at the boundary, which gives the type checker what it needs.

```text
Find every place the code uses "any" or "as" to silence the type checker. For each one, tell me where the data came from and whether we can check it at the boundary instead.
```

### Make the checker find every spot that needs updating

When you add a new shift status, say "pending approval," every piece of code that handles statuses needs a new case. In a large project, some of those spots will get missed.

pstack's rule is that the type checker should refuse to accept the code until every spot handles the new status. It's called exhaustive matching. Most typed languages can do it, but in some, including TypeScript, it only happens if the code is written to ask for it, and agents often skip that. Ask your agent to make status handling exhaustive so the build fails when a case is missing. With it, adding a status produces a list of every place that needs an update, instead of a bug report from a user weeks later.

### One source of truth for data shapes

If the database defines what a shift looks like, the code shouldn't have a separate, hand-written description of a shift that can drift out of sync. pstack says to derive the code's version from the authoritative source. When one changes, the other follows automatically.

## Security

This section goes beyond pstack. pstack's review rules include security, and its boundary rules are the foundation of most security work, but it's written for engineers who already know the basics. If you're building with agents and don't have a background in software, these are the gaps you're most likely to have.

### The browser is outside the gate

This is the most important security fact for a new builder. The user's browser and phone are outside your system. Anything they send can be faked.

Say ClinicDesk hides the "Cancel shift" button from nurses and only shows it to managers. That hides a button. It doesn't protect anything. A nurse who knows how, or anyone with a free tool, can send the "cancel shift 42" request straight to your backend without ever seeing the button. If the backend doesn't check whether the person asking is a manager, the shift gets cancelled.

So every request that reaches your server is a boundary crossing, and it gets the full entry check every time. That's what the gate model means for a web app. The repeated checks this chapter warns against are the ones deeper inside, after a request has already been checked.

- **Authentication.** Who is this? Is the login real and current?
- **Authorization.** Is this person allowed to do this specific thing to this specific record?

A very common hole in AI-built apps is checking the first and skipping the second. The app confirms you're logged in, then lets you see or change any record whose ID you ask for. If the address of a clinic's schedule is `/clinics/17/schedule`, try changing 17 to 18. If you see another clinic's schedule, you have a serious problem.

```text
For every backend endpoint, list who is allowed to call it and show me the exact line where the server checks that the logged-in user is allowed to act on that specific record. Flag any endpoint that only checks that the user is logged in.
```

### Data must never become instructions

Many attacks work by sneaking instructions in where the system expects plain data. If a nurse's name field contains text that the database reads as a command, or that the browser runs as code, an attacker can take over. pstack's review rubric names the places this happens, which it calls "dangerous sinks." They include database queries, which are requests to read or change data. They include shell commands, which are instructions to the server's operating system. They include code evaluation, where a program runs text as code. And they include inserting raw HTML, the language web pages are written in, into a page.

You don't need to know how each attack works. You need to know that user input should never be pasted directly into any of those. Modern tools have safe ways to pass data that keep it as data. Ask your agent to find every place user input reaches one of those sinks and confirm it uses the safe method. pstack's rubric asks reviewers to trace the actual path from input to sink and show it, rather than just saying "this might be unsafe."

### Secrets stay secret

Keys and passwords for outside services, such as your payment processor and text-message provider, are secrets. pstack's rubric flags "secrets in code, logs, or error messages." In practice:

- Secrets never go in the code itself. They go in environment variables or a secrets manager.
- Secrets never go in the frontend. Anything the browser receives, a user can read. Some services issue a separate public key that's meant for the browser, such as Stripe's publishable key or Supabase's anonymous key. Those are fine to expose, but only if everything they can reach is locked down on the server. For Supabase, that means row-level security rules on every table.
- Secrets never appear in logs or error messages.
- If a secret was ever committed to your repository, assume it's compromised. Replace it with a new one at the provider. Deleting it from the code doesn't help, because it's still in the history.

### Security findings are never "noise"

When automated reviewers comment on your pull requests, many comments are noise. pstack's triage guide for these comments sorts them into fix, dismiss, or ask. Security, privacy, authentication, billing, and data-loss findings always land in "fix" or "ask." They never get dismissed automatically, even if a similar comment was dismissed before.

> Skipping a noisy code-quality comment is cheap; skipping a real data or security bug is not.

### Health data and other regulated data

If your product stores health information, payment details, or other regulated data, laws apply. In the United States, health data can fall under HIPAA. This book can't cover that, and neither can an agent's best guess. Store as little sensitive data as you can, and get qualified advice before you store any. The cheapest data to protect is data you never collected.

## In practice

- Know where your boundaries are, and check and convert everything at them.
- Don't scatter repeated checks through the inside of the system.
- Keep business rules in pure functions that are easy to test.
- Ask for types that make contradictions impossible, keep look-alike values apart, and flag missing cases.
- Treat every request from a browser or phone as untrusted, and check permissions on the server for every action on every record.
- Keep user input out of queries and commands, and keep secrets out of code, frontends, and logs.
