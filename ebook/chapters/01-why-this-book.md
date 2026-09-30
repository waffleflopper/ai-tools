# 1. Why this book exists

## Where I'm coming from

My background is the Army and healthcare. It isn't software. When AI coding agents got good enough to build a real product from plain-English requests, I did what a lot of people are doing right now. I described what I wanted, the agent wrote the code, and I kept asking for more until the thing worked.

It did work. People signed up and started using it. Then I had to change something, and the change broke other things. Fixing those broke more. I found security gaps I didn't know to look for. Pages got slower as more people used them. Every fix the agent offered looked reasonable, and the pile kept growing.

I'm now taking apart and rebuilding a platform that has live users on it, because I built it without knowing how good software gets built. The agent wasn't the problem. It did what I asked. I didn't know what to ask for, what to refuse, or how to check its work.

This book is what I wish I'd read first.

## The gap

An AI agent can write code faster than any person. Speed was never the hard part of software. The hard parts are these:

- Deciding what to build, and what not to build.
- Choosing a structure that stays easy to change.
- Knowing when something is actually finished and correct, as opposed to finished-looking.
- Keeping out people who shouldn't get in.
- Fixing problems where they start instead of where they show up.

Senior engineers spend years learning those judgments. Most of that judgment is habits and questions, not typing. You can learn the habits and questions without learning to write code. Once you have them, you can hold an agent to them.

The term "vibe coding" describes building by feel. You accept whatever the agent produces as long as the screen looks right. It's a fine way to make a prototype on a Saturday. It's a bad way to build something people depend on. What gets you from one to the other isn't learning a programming language. It's learning what good work looks like and how to demand evidence of it.

## Where these ideas come from

Almost everything in this book comes from pstack, a free, open-source collection of instructions for AI agents written by Lauren Tan, who goes by "poteto" online. She has worked on very large codebases at Meta, Netflix, and Cursor, and she's on the team that builds the React compiler. pstack is how she makes AI agents work the way a careful senior engineer works. You can read it at `github.com/cursor/plugins/tree/main/pstack`.

pstack is written for engineers, and it's written as instructions for agents to follow. That makes it dense. A line like "concentrate guards at system boundaries (CLI, config, network, external APIs); trust internal types" packs in years of experience, but it means nothing to most people outside the field.

This book unpacks it. I kept the ideas and the order of operations. I replaced the jargon with plain language, added examples, and drew comparisons from places I know, healthcare and the Army. Where I added something pstack doesn't cover in depth, such as a fuller treatment of security, I say so.

pstack also has a strong opinion about writing. Its "unslop" rules ban padding, fancy words, and vague claims. I tried to follow them here. If a sentence in this book doesn't tell you something you can use, it's a mistake.

## Who this is for

This book is for you if:

- You build software by directing AI agents, or you want to start.
- You don't have a programming background, or you have a little and know it has holes.
- You want what you build to be safe, reliable, and something you can keep changing without fear.

You don't need to read code to use this book. You'll see a few short snippets, and each one is explained in plain words. The goal is that you can recognize good and bad work when an agent shows it to you, and ask for the right thing.

## What you'll learn

The chapters build on each other.

1. Chapter 2 gives you just enough vocabulary to follow the rest.
2. Chapter 3 covers your role. You're the lead on the project, and the agent works for you.
3. Chapters 4 through 8 cover judgment before and during building. You'll learn to understand code before changing it, to build less, to get the structure right first, to guard the entrances to your system, and to plan for the things that go wrong in the real world.
4. Chapters 9 through 12 cover evidence. That means proving something works, writing tests that can catch real problems, fixing bugs at their cause, and dealing with slowness.
5. Chapters 13 through 15 cover process. You'll learn to work in small checked steps, change existing code safely, and run agents for long stretches without losing control.
6. Chapter 16 puts it together for a project that's already a mess, which is where many readers will start.
7. Chapter 17 collects the playbooks as checklists you can use every day.

The appendices hold the principles on one page, prompts you can copy, and notes for readers who use Cursor and want to install pstack itself.

## The example we'll use

Examples stick better when they're about one thing. Throughout this book we'll follow a made-up product called ClinicDesk. It's a scheduling app for a small outpatient clinic.

- Managers post open shifts.
- Nurses and medical assistants claim shifts from their phones.
- Patients get text-message reminders before their appointments.
- The clinic pays a monthly subscription.

ClinicDesk is small, but it has everything that trips up new builders. It has logins and permissions, so it has security. Two people can grab the same shift at once, so it has timing problems. It sends texts that can go out twice, and it takes payments that can be charged twice. It keeps records that other features depend on. Every principle in this book shows up somewhere in it.

## How to read it

Read chapters 2 and 3 first. After that, the chapters stand on their own reasonably well. If you're sitting on a messy project right now, you can skip to chapter 16 and follow the references back.

Don't try to memorize anything. Read it once. Then, the next time an agent tells you "Done! Everything works," come back to chapter 9. The ideas stick when you use them.
