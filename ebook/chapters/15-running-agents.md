# 15. Running agents well

The earlier chapters covered what good work looks like. This one covers how to run agents so they produce it, including over long stretches when you're not watching. It draws on the part of pstack written for operating agents, which it calls delegation, plus a few habits for keeping work traceable.

## Protect the agent's working memory

Chapter 2 introduced the context window, the agent's working memory. Everything goes into it, including your messages, every file it reads, and every line of output from every command it runs. When it fills up, the agent either forgets earlier material or compresses it into summaries, and its reasoning gets worse. Instructions you gave early on get lost. It starts repeating mistakes it already fixed.

pstack's principle is called guard the context window.

> The context window is finite and non-renewable within a session. Every token should be worth its cost.

A token is roughly a word or part of a word. The practical rules:

- **Send bulky work to subagents.** Reading fifty files, scanning long logs, or digging through screenshots can happen in a separate agent that reports back a short summary. The main agent keeps the conclusion, not the raw material.
- **Keep phases small.** Limit how many files each step touches.
- **Start fresh when a conversation gets long.** A new session with a clear summary of where things stand often does better than pushing on in a crowded one.

You'll notice a crowded context when the agent forgets something you said, contradicts an earlier decision, or redoes finished work. When that happens, don't argue with it. Ask it to write down the current state, then start a new session from that note. The section on handoffs below covers how.

pstack points out that people have the same limit. Minimize reader load, from chapter 5, is "the human analog" of this principle. Your working memory is finite too.

## Don't make yourself the bottleneck

An agent that stops to ask permission for every step makes you the slowest part of the system. pstack's principle is never block on the human.

> Proceed, present the result, let the human course-correct after the fact.

This works because most of what an agent does can be undone. Code can be thrown away. A branch can be deleted. A wrong decision on reversible work usually costs less than an hour of waiting for your answer.

But pstack draws a hard line. Some actions can't be undone, and those always need your confirmation. Its list:

- Force-pushing over shared history, which rewrites the project's saved record.
- Deploying to production.
- Deleting data.
- Sending messages to customers.

To that list, add anything that spends money, changes permissions, or touches production settings.

Product direction, meaning what to build and for whom, also stays with you. In pstack's words, "*Execution* should not block." Decisions about the product still belong to the human.

A clear way to put this to an agent:

```text
Keep going on anything you can undo, like writing code, running tests, or making branches, and show me the results. Stop and ask before anything you can't undo, like deploying, deleting data, sending anything to users, or spending money.
```

## Give parallel agents separate space

If you run more than one agent at a time, they must not work in the same folder. They'll overwrite each other's files and produce a mess nobody can untangle. This is chapter 8's shared-state problem again, and pstack's answer is the same. Don't share. Give each agent its own worktree, a separate copy of the project on its own branch.

```text
Do this in a new worktree on a new branch off main, so it doesn't collide with anything else I have running.
```

Parallel agents are useful in two ways. pstack's `arena` skill gives several agents the same task, compares their results, picks the best as a base, and borrows the best ideas from the others. That's chapter 6's "design it twice," done in parallel. Its `swarm` skill splits a large job into independent slices, like checking each of twenty screens, and gathers one report at the end.

Whichever you use, the agent that starts the others is responsible for their work. pstack says:

> You own every subagent's work. Review the diff and write your own summary, don't pass through what it said.

The same goes for you and your agents.

## Write a script instead of editing by hand

Say you need to change something in 80 files. An agent can edit them one by one, by hand. Or it can write a small script that makes the change and run the script on all 80. pstack strongly prefers the second, and calls the principle build the lever.

> When the work isn't trivial, build the tool that does it instead of doing it by hand.

It gives two payoffs.

- **Consistency.** A script does the job the same way every time. Eighty hand edits will include a few mistakes.
- **Reviewability.** A reviewer can read one short script and rerun it. Nobody can re-check 80 hand edits except by redoing them. In pstack's words, it "turns 'trust me' into 'run this'."

The method is to do the first one by hand to learn the recipe, then write the script, then run the script on that first one and confirm it matches your hand-done version. Then run it on everything. Checks count too. A script that verifies the result is also a lever.

The bar isn't "is this repetitive?" It's "is this trivial?" A couple of obvious edits don't need a script. Anything bigger, or anything where you need to prove what happened, usually does. pstack also warns against overdoing it. Build the smallest script that does the job, not a framework.

## Turn lessons into guardrails

You'll find yourself correcting an agent on the same thing more than once. "Don't store phone numbers with dashes." "Always check permissions on the server." The instinct is to write it down somewhere, such as a project instructions file. pstack says that's the weak option.

> Encode recurring fixes in mechanisms (tools, code, metadata, automation) instead of textual instructions.

Written instructions only work if the reader notices them, remembers them, and follows them. Agents skim. A mechanism works whether anyone remembers or not.

pstack ranks the options from strongest to weakest.

1. **Make the mistake impossible to write.** The type checker refuses code that breaks the rule, as in chapter 7.
2. **Make it fail the automated checks.** A linter rule that flags the pattern, so the change can't merge.
3. **Provide one standard way to do it.** A shared helper function that everyone uses, like a single phone formatter.
4. **Check it while the app runs.** The app itself refuses the bad input.
5. **Write it down.** This is only for rules that need judgment and can't be automated. Make it prominent and include an example of the mistake.

There's a reason to prefer the strongest option that goes beyond reliability.

> Agents copy whatever the surrounding code already does and a weaker guard becomes the next template.

If the code shows the right way everywhere and the wrong way can't get through the checks, agents learn the right pattern from the code itself.

The Army's after-action review asks what was supposed to happen, what happened, why they differed, and what to sustain or improve. The last step only matters if something actually changes. pstack's version is the same. Every correction is a signal. Decide whether it's a one-off or a pattern. Route patterns into a mechanism. Then close the loop by doing it now or creating a concrete task, not by saying "I'll keep that in mind."

pstack's `reflect` skill runs this review after a hard session. pstack's guide adds a warning when describing it. Only turn a lesson into a rule if it would change a future decision. "One weird session is an anecdote, not a rule."

## Keep a decision log

When an agent works for hours, you need a way to see what it decided and why without rereading the whole conversation. pstack's `show-me-your-work` skill keeps a simple log, one row per decision, with these columns:

- **When.** The date and time.
- **Phase.** Which part of the work.
- **Decision.** What was chosen or done, in one line.
- **Why.** The reason in plain words.
- **Evidence.** A pointer to proof, such as a commit, a test result, or a screenshot. Never a paragraph.
- **Result.** What happened, such as "tests pass," "reverted," or "inconclusive."

A row might read: "Threw out a helper's work because its screenshots were blank. Checked the real files instead of trusting its summary. Reverted, and tightened the instructions for next time."

The log is append-only. A wrong decision gets a new row that corrects it. Old rows never get edited or deleted, which is the same principle as a medical chart. At the end, a reviewer on a different model reads the log and flags anything you should look at, such as decisions with weak evidence, skipped checks, or risky calls. That list goes in an "Attention" section at the end of the report, along with the name of the model that reviewed it. Read that section first.

```text
Keep a decision log as you work, one row per real decision, with what you chose, why, and a pointer to the evidence. Don't edit old rows. At the end, list anything in the log I should look at closely.
```

## Leaving an agent running

The payoff for everything in this book is being able to hand an agent a real task and walk away. pstack's guide describes an overnight handoff with four parts.

1. The goal.
2. The finish condition, something that can come out true or false.
3. Permissions, meaning what the agent can do without asking.
4. An escape hatch, meaning what to do if it gets truly stuck.

```text
I'm stepping away for the night. Move every screen onto the new date formatter, in a new worktree off main. Done means the old formatter has no remaining users and is deleted, and every test passes. Keep a decision log. You don't need to ask before committing. If you're truly stuck, stop and write up why instead of guessing.
```

pstack's rules for a long run:

- Each round makes the smallest change the evidence supports, checks it against the finish condition, and keeps it or throws it out.
- Changes that didn't help get removed, "not left to ride."
- Hitting a plateau means trying a different approach, not stopping.
- The agent must never quietly loosen the finish condition to declare victory.

The escape hatch matters. Without it, pstack's guide warns, you can get "eight hours of creative goal reinterpretation." A clear "if stuck, stop and explain" gets you a useful report instead.

## Handoffs

Nurses give a structured report at every shift change, because the next nurse has to pick up care without re-examining every patient from scratch. The Army does the same at a relief in place, where the incoming unit gets the outgoing unit's picture of the situation before taking over. Agent work needs the same discipline. Sessions end, context fills up, and you'll often want a fresh agent to pick up where another left off.

pstack has two matching playbooks.

**Pausing.** When work has to stop:

1. Stop at a safe point. Finish the current step or back out of it cleanly.
2. Don't do anything irreversible just to pause.
3. Save everything, with a clearly labeled "work in progress" commit so nothing is lost. If the code is broken at this point, say so.
4. Write a resume note covering the goal, what was being done, what's finished and verified, the current state, the next steps, the key files, and any gotchas.

**Picking up.** When a new agent takes over:

1. Read the previous trail, meaning the note, the decision log, and the project history.
2. Work out what's done and what's left.
3. Don't redo finished work. pstack treats the previous trail as authoritative. An agent that insists on "verifying everything from scratch" wastes time.
4. Do verify the claims that matter against the real thing before building on them. A previous agent's "it works" is a self-report, as chapter 9 explained.

```text
Stop at a safe point. Commit what you have as work in progress, and write a resume note a new agent could pick up from cold, covering the goal, what's done and verified, what's next, the key files, and anything surprising.
```

## Write your own playbook

pstack is one engineer's style, and its author encourages people to build their own version. You can do that without any special tools. As you work, notice the requests you type over and over, the corrections you keep making, and the checks you always ask for. Write them down as your own checklists and instructions for your agents, and turn the ones you can into automated checks. Chapter 17 gives you pstack's playbooks as a starting point.

## In practice

- Keep the agent's working memory for decisions. Send bulk reading to subagents and start fresh sessions when things get crowded.
- Let agents move freely on reversible work, and require your approval for anything irreversible.
- Give each parallel agent its own worktree, and review what subagents produce yourself.
- For non-trivial or repetitive work, have the agent write a script and prove it on one case first.
- When you correct the same thing twice, turn it into a check that enforces itself.
- For long runs, give a goal, a finish condition, permissions, and an escape hatch, and ask for a decision log.
- End and start sessions with a written handoff.
