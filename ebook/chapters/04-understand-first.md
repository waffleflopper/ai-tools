# 4. Understand before you change anything

## Examine before you treat

No competent clinician prescribes before taking a history and doing an exam. The first plausible diagnosis is often wrong, and treating the wrong thing can make the patient worse while hiding the real problem.

Code is the same. pstack's guide puts it bluntly:

> Editing code you don't understand is how subtle regressions ship.

A regression is something that used to work and now doesn't. Agents cause regressions all the time for a simple reason. Asked to fix something, an agent searches the code, finds the first spot that looks related, and changes it. That spot is often where the problem shows up rather than where it starts. The symptom goes away, the real cause stays, and something else breaks later.

pstack's answer is to make understanding a separate, explicit step before any change. Two questions drive it. How does this work? And why is it built this way?

## "How does this work?"

pstack's `how` skill produces the kind of explanation a senior engineer gives a new teammate on their first day. It isn't a line-by-line reading of the code. It's a working mental model, with enough detail to make good decisions and no more. The explanation has five parts.

1. **Overview.** What this part of the system does, in a few sentences.
2. **Key concepts.** The handful of ideas and names you need.
3. **How it works.** What happens, step by step, when someone uses it.
4. **Where things live.** Which files and modules own which parts.
5. **Gotchas.** The surprising, fragile, or non-obvious parts.

You can ask any agent for this. The important part is asking before any change, and saying that no code should change yet.

```text
Before we change anything, explain how shift claiming works today. Walk me through what happens from the moment a nurse taps "Claim" to the moment the manager sees it. Include where each step lives and anything surprising. Don't change any code.
```

Read the explanation. If a part doesn't make sense, ask about that part. You don't need to follow every detail. You're checking that the agent built a real model, and you're building a rough one yourself. When you hand off the actual change later, the agent will make better decisions because it did this work first.

For a large area, the agent can split the reading among several subagents, each reading one slice, and then combine what they found. pstack does this automatically for big questions. For a narrow question, a single pass is enough.

Two test questions from pstack are worth asking about any part of your system:

- Where does this value come from?
- What can change it?

If the agent can't answer those quickly for, say, "the list of open shifts," the code is harder to follow than it should be. Chapter 5 comes back to this.

## "Why is it built this way?"

Code tells you what it does. It doesn't tell you why it exists. Healthcare has the same problem with medications. You don't stop a patient's medication just because you can't see what it's for. You find out who started it and why, because the reason might still apply.

pstack's `why` skill works like an investigator on a cold case. It starts with the project history, meaning the commits and pull requests that created and changed the code, along with their descriptions. Then it checks whatever other records exist, such as issue trackers, design documents, team chat, and error reports. For a small project, the history and your own memory may be all there is. That's still worth checking.

```text
Why does the reminder job wait 90 seconds before sending? Look through the history of that code and tell me what you find. Tell me how confident you are in each part of the answer.
```

The most useful part of `why` is how it reports confidence. Every claim falls into one of five levels.

1. **Direct.** Someone wrote down the reason. "The commit message says the text provider rejected bursts of more than 10 messages a second."
2. **Supported.** Several pieces of indirect evidence point the same way.
3. **Inferred.** A reasonable reading with nothing explicit behind it. The report says "appears to" or "likely."
4. **Speculative.** A plausible guess that other explanations fit just as well.
5. **Unknown.** The agent looked and couldn't find out. It says exactly where it looked.

pstack treats "nobody wrote down why" as a real answer. It's far better than an invented reason. Watch for words like "because," "was designed to," and "fixes." They claim certainty. If an agent uses them, there should be a source right next to the claim.

Once you get used to these levels, you'll notice how often agents present an inference as a fact. Ask for the levels by name.

## Put them together

"How" and "why" answer different questions, and you often want both. pstack's `teach` skill runs both and combines them into one plain explanation that builds up piece by piece. You can prompt for the same result.

```text
Teach me how the payment retry works and why it's built this way. Start with the simplest version and add detail as we go. Assume I don't write code.
```

One phrase from pstack's guide is worth borrowing when you're reviewing a fix.

```text
Convince me this fixes the cause and not the symptom.
```

That asks the agent for an argument you can check, not just a description.

## When the history explains the mess

Sometimes code looks strange for a good reason. A workaround might exist because an outside service behaves oddly, or because of a real incident you've forgotten about. Sometimes it looks strange for a bad reason, like a quick patch that nobody revisited. You can't tell which from the code alone. So when something looks wrong, ask why before asking for a fix. If the reason still holds, the fix needs to respect it. If it doesn't hold anymore, you may be able to delete the thing entirely, which is usually the best outcome. Chapter 5 is about exactly that.

## Plan the check before the change

Understanding also covers what else a change might affect. Before a risky change, ask what it could break outside the lines it touches. Chapter 9 shows how to get a real answer instead of a list of maybes.

## Why this is worth the time

It's tempting to skip this step because the agent will read the code anyway. pstack's guide answers that directly:

> An agent that starts editing without a traced model tends to fix the symptom at the first plausible spot. `/how` first is cheaper than the second bug.

A few minutes of reading costs almost nothing. A wrong fix in production can cost you users.

## In practice

- Before any real change, ask for an explanation of how the affected area works, and say "don't change any code yet."
- When code looks odd, ask why it exists before asking to change it.
- Ask for confidence levels on every "why" answer.
- Ask what the change could break elsewhere, and what single fact makes it safe.
- Ask for the explanation in plain language, built up one piece at a time.
