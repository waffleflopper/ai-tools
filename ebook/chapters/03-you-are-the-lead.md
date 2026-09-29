# 3. You are the lead

## The job you actually have

When you build with an AI agent, you're not the typist. The agent types. Your job is closer to that of a charge nurse or a platoon leader. You decide what the mission is, you decide what counts as done, and you check the work before anyone relies on it.

pstack frames every task this way. Each playbook opens with a line about ownership, such as "You own this task. Plan, review, verify." or "You own the answer." The agent that runs the playbook owns the outcome, even when it hands pieces to other agents. You own the agent. If it hands you something broken, that's on you. The fix is to never accept its work on faith.

## Give intent, not instructions

The Army has a concept called commander's intent. An order says what to do. The intent says why, and what success looks like. When the situation changes and the plan stops fitting, people who know the intent can still act correctly. People who only have the steps get stuck.

Agents work the same way. The habit pstack's guide asks you to remember above all is this:

> Give the agent a goal and a way to check it, in your own words.

Compare two requests.

```text
Fix the reminders.
```

```text
Some patients are getting two reminder texts for one appointment. Reproduce it first, then fix it, then show me that one appointment produces exactly one text.
```

The first leaves the agent to guess what "fix" means. It might change something, see no error, and tell you it's fixed. The second gives a goal, which is one text per appointment. It gives an order of operations, which is to reproduce first. And it gives a check the agent can run, which is to show that one appointment produces one text.

You don't need to write a specification. You don't need to tell the agent which files to open or which tools to use. pstack's guide warns against spelling out which tools the agent should use in what order, because its playbooks already sequence the work. The same idea helps with any agent. Say what you want, what must not change, and how you'll know it's done. Add a required order only where it matters, such as "reproduce first."

## The finish condition

The "way to check it" deserves its own name. Call it the finish condition. It's a statement that can come out true or false by running something or looking at something.

Good finish conditions:

- "Every existing test passes, and a new test shows a double-click creates one shift claim, not two."
- "The monthly report page loads in under two seconds with a year of data."
- "The old reminder function has no remaining callers and has been deleted."
- "The text-message output for an appointment is exactly the same as before, and the new email output matches the sample I gave you."

Bad finish conditions:

- "Make it better."
- "Clean up the code."
- "Work on the reports for a few hours."

A duration isn't a finish condition. "Work on this for four hours" gives the agent nothing to check, and you get four hours of activity instead of a result.

If you can't write a finish condition, you're not ready to hand off the task. That's a sign you need to understand the problem better first, which is the subject of the next chapter.

## Say what must not change

Every change risks breaking something that already works. The cheapest protection is to say out loud what must stay the same.

```text
Add an option to export the shift schedule as a spreadsheet. The existing PDF export must produce exactly the same output as before. Verify both.
```

That one sentence about the PDF gives the agent a second thing to check. Without it, the agent will probably assume the PDF is fine because it didn't mean to touch it.

## Decide what is yours to decide

Agents ask a lot of questions. Some are real questions for you, and some aren't. pstack draws a sharp line between them.

**Questions about facts.** "Which of these two approaches is faster?" "Does the layout break on a small phone?" "Will this change affect the billing page?" The agent can answer these by running something, so it shouldn't ask you. Your answer would be a guess, and its experiment would be evidence. When an agent asks you a factual question, tell it to find out.

**Questions about direction.** "Should managers be able to see who declined a shift?" "Do we charge per clinic or per user?" "Is it acceptable for a reminder to arrive five minutes late?" These are product decisions. No experiment can settle them. They're yours.

pstack's rule is that the agent should keep moving on anything reversible and bring you real decisions, not permission requests. Writing code is reversible, since you can always throw it away. Deleting production data isn't. Chapter 15 covers where to draw that line.

## Ask for disagreement

AI agents are built to be agreeable. Left alone, they'll tell you your idea is great and then build it. pstack pushes hard against this. Its main operating instructions say:

> No is an acceptable answer. Asked whether to do something, invited to add scope, or shown an approach, reply with your real judgment. Decline, push back, or say "this doesn't earn its place" when true.

You can get the same behavior from any agent by asking for it. Tell it you want its honest judgment, including "don't build this." When you propose a feature, ask what it would cost to maintain and whether something simpler gets you most of the value. An agent that never disagrees with you isn't giving you judgment.

## Demand evidence in the reply

Agents often report success with total confidence and no proof. pstack requires every claim in a reply to carry its evidence or a label saying what kind of claim it is.

- **Measured.** The agent ran something and saw the result. "The page loaded in 1.4 seconds, measured over five runs."
- **Inferred.** The agent reasoned its way there without checking. "This probably also fixes the calendar view, since it uses the same function."
- **Guess.** A prediction or an unseen cause. "The slowdown might be the database."

Ask your agent to label its claims this way. Once it does, you'll see how much of what agents tell you is inference presented as fact. Another rule from pstack is worth adopting word for word:

> Never hand the human a check you could run.

If the agent tells you "you should verify this works on mobile," ask it to verify it on mobile.

## Ask for plain language

Agents write for engineers by default. pstack includes a tiny skill called `bro` whose entire instruction is this:

> Restate your last message. Stop using jargon and speak coherently. State it more simply and concisely, like one human talking to another.

You can type that sentence, or something like it, to any agent at any time. There's nothing embarrassing about it. A senior engineer who can't explain a change plainly often doesn't understand it well. Asking for the plain version also tests whether the agent does.

pstack also asks agents to frame every result around two people. The first is the person who uses the work, such as a clinic manager, a nurse, or a patient. The second is whoever maintains the code next, which might be you in six months or another agent next week. Ask your agent what each of them would notice about the change. If it can't say, either the change or the explanation is off.

## One task at a time

A long conversation with an agent collects context from earlier work. When you switch subjects, say so clearly.

```text
New task. Figure out why a shift still shows as open after a nurse claims it. Don't change any code yet.
```

"New task" tells the agent to stop treating your message as the next step of the old job. "Don't change any code yet" keeps it in investigation mode. Without phrases like these, an agent in the middle of building a feature will often treat your question as a request to build more.

## What this chapter asks of you

- State a goal and a finish condition for every task.
- Say what must not change.
- Make product decisions yourself and send factual questions back to the agent.
- Ask for honest pushback.
- Require evidence, and ask for claims to be labeled as measured, inferred, or guessed.
- Ask for plain language whenever you need it.
