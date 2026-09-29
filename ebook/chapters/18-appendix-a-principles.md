# Appendix A. The principles on one page

pstack has 23 principles. Each one below has its pstack name, a plain-language version, a phrase you can say to an agent to apply it, and the chapter that covers it.

pstack's guide suggests using the names to steer. When an agent is about to do something a principle would prevent, naming the principle and the decision you want redirects it faster than a paragraph of explanation. That works when the agent has read the principles, as it does with pstack installed. With any other agent, use the plain phrase given for each one. Ask the agent to say which decision each principle changed. A principle mentioned with no decision behind it was name-dropped, not applied.

## How much to build and when to rethink

**Laziness protocol.** Get the most result from the least code. Prefer deleting to adding, and make the smallest change that works. Say "What's the smallest change that solves this?" See chapter 5.

**Foundational thinking.** Decide the shape of the data before writing logic, and put foundations like tests and shared definitions in first. Say "Name the data shape before writing any logic." See chapter 6.

**Redesign from first principles.** Fit a new requirement in as if it had been there from day one, instead of bolting it on. Say "If we'd known about this from the start, what would we have built?" See chapter 6.

**Attack the premise.** After two failed fixes that share an assumption, question the assumption. Count where the problem shows up before trying again. Say "Write down what both fixes assumed, and count the problem by user before proposing anything." See chapter 11.

**Subtract before you add.** Remove dead weight first, then build on the simpler base. Say "Clean up and delete first, as its own change, then add the feature." See chapter 5.

**Minimize reader load.** Keep the path from a question to its answer short, and keep changing values contained. Say "Could a new reader find where this value comes from, and what changes it, in 30 seconds?" See chapter 5.

**Outcome-oriented execution.** In a planned rewrite, aim for the verified end state. Don't build throwaway compatibility code to keep every in-between step perfect. Say "Plan where temporary breakage on the branch is acceptable, and verify everything at the end." See chapter 14.

**Experience first.** Choose what's best for the user over what's easiest to build. Ship fewer, finished features. Say "Does every option here earn its place for the user?" See chapter 5.

**Exhaust the design space.** When the answer isn't obvious, build two or three real alternatives and compare them. Say "Show me two structurally different designs before choosing." See chapter 6.

**Build the lever.** Write the script that does or checks the work, instead of doing it by hand, so anyone can rerun it. Say "Write a script for this, prove it on one case, then run it on all of them." See chapter 15.

## Where rules, checks, and data live

**Model the domain.** Capture real-world rules in a clear structure, like a single status or a lookup table, instead of scattered if-then checks. Say "Replace these yes-or-no fields with one status" or "Make this a table instead of a chain of special cases." See chapter 6.

**Boundary discipline.** Check and convert everything where it enters the system, then trust it inside. Keep business rules in pure functions. Say "Check this where it comes in, and remove the repeated checks inside." See chapter 7.

**Type system discipline.** Make contradictions impossible to write down, keep look-alike values apart, and don't silence the type checker. Say "Make the types rule this combination out, and remove the escape hatches." See chapter 7.

**Make operations idempotent.** Anything that changes something should end in the same correct state whether it runs once, twice, or after a crash. Say "What happens if this runs twice, or crashes halfway? Make both safe." See chapter 8.

**Migrate callers then delete legacy APIs.** When there's a new way to do something, move everything onto it and delete the old way in the same round. Say "Move every caller to the new one and delete the old one now, not later." See chapter 14.

**Separate before serializing shared state.** If two things might change the same data at once, first remove the sharing. If sharing is truly needed, enforce it with structure, not care. Say "Can we stop sharing this? If not, make the database enforce it in one step." See chapter 8.

## What counts as proof

**Prove it works.** Check the real thing, like the saved value, the running app, or the sent message. A proxy or a self-report doesn't count. Say "Show me the real output, not the build log." See chapter 9.

**Fix root causes.** Reproduce first, ask why until you reach the source, and fix it there. No guards that silence symptoms. Say "Reproduce it, find the root cause, and don't add checks that just hide it." See chapter 11.

**Sequence work into verifiable units.** Work in small steps that each end in a check, and save them in an order that proves the work. Say "One change at a time, and check each one before the next." See chapter 13.

**Test behavior, not implementation.** A test calls the code like a user would and checks an exact expected answer. If it would pass when the code does nothing, rewrite or delete it. Say "Would this test still pass if the code did nothing?" See chapter 10.

## Working with agents

**Guard the context window.** Keep the agent's working memory for decisions. Send bulk reading to subagents and keep summaries in the main conversation. Say "Have a subagent read those and give you a summary." See chapter 15.

**Never block on the human.** Keep moving on reversible work and show results. Ask only about irreversible actions and product decisions. Say "Go ahead on anything you can undo. Ask before anything you can't." See chapter 15.

## Learning

**Encode lessons in structure.** When you give the same correction twice, turn it into a check that enforces itself. Say "Turn this into a check that fails if anyone does it again." See chapter 15.
