# 8. Plan for things happening twice

## Real use means repeats

When you test your app by hand, everything happens once, in order, with a good connection. Real use isn't like that.

- A nurse on a weak signal taps "Claim" twice because nothing seemed to happen the first time.
- A phone loses connection halfway through a request, and the app automatically tries again.
- Your server restarts in the middle of sending the morning's reminder texts.
- The payment processor takes too long to answer, so your code assumes it failed and retries.
- Two nurses tap "Claim" on the same shift within the same second.

Each of these means some piece of your code runs twice, or runs at the same moment as another copy of itself, or stops halfway and starts over. Code that only works when everything happens once, in order, will fail in production. Worse, it fails intermittently, which makes it hard to track down.

pstack has two principles for this. One is about repeats and the other is about sharing.

## Make operations idempotent

"Idempotent" is an intimidating word for a simple idea. An idempotent action has the same effect whether you do it once or five times.

An elevator call button is idempotent. Press it once or press it ten times, and one elevator comes. A "turn the lights on" switch is idempotent. A "toggle the lights" switch is not, because pressing it twice leaves you where you started.

pstack's version:

> Design operations so they converge to the correct state regardless of how many times they run or where they start from.

It gives three questions to ask about any operation that changes something.

1. What happens if this runs twice in a row?
2. What happens if the previous run crashed at any point partway through?
3. Does running it again always end in the same, correct state?

If any answer is "it depends on what state was left behind," the operation needs fixing.

### The double reminder

Here's how ClinicDesk's reminder job could fail. Every morning it finds today's appointments and texts each patient. Halfway through the list, the server restarts. When the job starts again, it begins from the top and texts the first half of the patients a second time.

Patients getting two texts is annoying. Now apply the same pattern to payments. A monthly billing job crashes halfway, restarts, and charges half your customers twice. That's how you lose customers.

### How idempotent code works

Nursing already solved this problem for medications. Before giving the 9 a.m. dose, the nurse checks the medication administration record. If it's already charted, they don't give it again. They don't rely on memory, and they don't assume the last shift finished everything. They check the record, act, and chart it.

Idempotent code does the same thing.

- **Claim the job before doing it.** Before sending a reminder, the job records "reminder for appointment 881" in the database, in a single step the database guarantees can only succeed once. Only the run that makes that record sends the text. A second run, or a restarted one, finds the record and skips. Checking first and recording afterward isn't enough, because a crash between sending and recording leaves no trace, and two runs at once can both pass the check. That gap comes up again later in this chapter.
- **Know which failure you'd rather have.** When the action goes to an outside service, like a text provider, no design is perfect. A crash right after claiming but before sending means one reminder never goes out. Decide which is worse for each action, a missed message or a doubled one, and ask your agent to design for that choice.
- **Give each action a unique name.** Payment processors often accept an "idempotency key" with each charge. It's a unique label, such as "clinic 17, March subscription." If the same key arrives twice, the processor charges once and returns the original result for the second request. Ask your agent to use one for every charge. These keys expire after a while at some processors, so a job retried days later isn't covered. For recurring billing, the simplest safe option is usually to let the payment processor run the subscription itself instead of writing your own monthly charge job.
- **Set, don't add.** "Set this shift's status to claimed" is idempotent. "Add one to this nurse's claimed-shift count" is not. Run it twice and the count is wrong. Where possible, describe the end state you want instead of a change to make.
- **Clean up on startup.** pstack describes "convergent startup," where a process looks at what's already there when it starts, cleans up leftovers from a crashed run, and picks up what was in progress, instead of assuming it's starting fresh.

```text
Go through every operation that sends a message, charges money, or creates a record. For each one, tell me what happens if it runs twice, and what happens if the server restarts halfway through. Fix any that would double-send, double-charge, or create duplicates, and show me a test that runs each one twice and gets one result.
```

## Separate before sharing

The second principle is about two things happening at the same time.

### The same shift, claimed twice

Two nurses open ClinicDesk and see the same open Saturday shift. Both tap "Claim" at nearly the same moment. Here's what the code does for each of them:

1. Check whether the shift is still open. It is.
2. Mark the shift as claimed by this nurse.

Both requests run step 1 before either reaches step 2. Both see "open." Both claim it. Depending on timing, the shift ends up with the second nurse's name, and the first nurse has a confirmation for a shift they don't have. Or the data ends up in some broken in-between state.

This is called a race condition. The result depends on which request wins a race that nobody controls. It's intermittent, so it might happen once a month. It's nearly impossible to reproduce by hand. And it's exactly the kind of bug that agents create, because code that runs one request at a time works perfectly in testing.

The gap between checking and acting is the weak point. Security reviewers call it "time of check to time of use." Anything can change between the moment you look and the moment you act.

### pstack's approach

pstack's principle has a specific order.

> When concurrent actors might share mutable state, first ask whether they need the same mutable object. If not, eliminate the sharing.

"Concurrent actors" means anything running at the same time, such as two users, two background jobs, or two agents. "Mutable state" means information that gets changed.

**Step one. Ask whether they really need to share it.** Often they don't. Say ClinicDesk keeps a running "hours this week" total for each nurse, and every claim adds to it. Two claims at once can step on each other's update. But you don't need that shared total at all. Each claim can be its own record, and the weekly hours can be added up from those records whenever someone asks. Nothing is shared, so nothing can collide. This is the same "calculate, don't copy" idea from chapter 5.

pstack gives a sharp example of fake separation. Two workers that each write their own field into one shared file are still sharing that file. Two workers that each write their own file aren't.

**Step two. If sharing is real, enforce it with structure.** A shift really can only have one nurse. That rule is real, so the two claims really do compete for one thing. In that case, pstack says to enforce the rule structurally, meaning with something the system guarantees, rather than with care or good intentions.

Controlled substances in a hospital are a good model. You don't protect the narcotics cabinet with a sign that says "one person at a time, please." There's one key, or one badge-controlled drawer that logs every access. The structure enforces the rule.

For ClinicDesk, the structural fix is to make the claim a single step the database guarantees. The claim says, "Mark this shift as claimed by this nurse, but only if it's still open," all in one action. The database makes sure only one of two simultaneous requests can succeed. The second one gets told the shift is taken. There's no gap between checking and acting.

> Instructions and conventions are not concurrency control.

A comment in the code saying "don't call this at the same time" does nothing. Neither does telling an agent to be careful. The protection has to be built in.

pstack also treats "we need a lock" as a warning sign. A lock is a mechanism that makes everyone wait their turn. Sometimes one is needed. But reaching for a lock first often means you skipped step one. Ask whether the sharing can be removed before adding machinery to manage it.

```text
Find every place where two users or two background jobs could change the same record at the same time. For each one, tell me whether the sharing can be removed. If it can't, make the database enforce the rule in a single step, and show me a test that fires two requests at once and gets exactly one success.
```

## The same rule applies to agents

This principle applies to your agents as much as to your app. Two agents working in the same folder at the same time will overwrite each other's files. pstack's answer is the same. Don't make them take turns. Give each agent its own worktree, meaning its own copy of the files, so they never share anything. Chapter 15 covers this.

## In practice

- Assume every action can run twice, stop halfway, or run at the same moment as another copy.
- Ask the three questions. What if it runs twice? What if it crashed partway? Does rerunning always end in the right state?
- Record what's been done and check before doing it, especially for messages and payments.
- Remove shared data when you can, by calculating totals from records instead of keeping running counts.
- When sharing is real, make the database enforce the rule in one step. Don't rely on code comments or care.
