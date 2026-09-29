# Appendix C. Using pstack itself

This book teaches pstack's ideas in a way that works with any agent. If you use Cursor, you can install pstack and let it apply the ideas for you. This appendix is a short map from the book to pstack's commands. The details come from pstack version 0.15.5 and may change, so check its README for current instructions.

## Installing

In a Cursor chat, run:

```text
/add-plugin pstack
```

Then run `/setup-pstack`. It detects which AI models you have access to, asks a few questions, and saves your choices. Start a new chat afterward so the settings take effect. At the end of setup it also offers to create a verification skill for your project, which is the app-driving guide from chapter 9.

## The one command to remember

`/poteto-mode` is the main entry point. You type it at the start of a task along with what you want, in plain words. It matches your request to a playbook, copies the playbook's steps into a to-do list, and runs the other skills as each step needs them.

```text
/poteto-mode some patients get two reminder texts. repro first, then fix and verify.
```

It stays on for the rest of the conversation until you say otherwise.

## Commands by chapter

- **Chapter 3.** `/bro` restates the last reply in plain language.
- **Chapter 4.** `/how` explains how something works. `/why` digs through history for the reasons. `/teach` combines both into one plain explanation.
- **Chapter 6.** `/architect` designs before building, with several competing sketches.
- **Chapter 9.** `/blast-radius` finds what a change could break and proves the one fact that makes it safe. `/create-verification-skill` and `/maintain-verification-skill` set up and maintain the app-driving guide.
- **Chapter 10.** `/tdd` writes the failing test first, then the fix.
- **Chapter 13.** `/interrogate` has several different models review a change. `/no-comments` sends comments to a separate reviewer and removes most of them. `/unslop` removes AI writing habits from prose. `/technical-writing` applies a documentation standard.
- **Chapter 15.** `/arena` runs several agents on the same task and combines the best parts. `/recall` rebuilds your recent context on a topic from past chats. `/swarm` splits work across parallel workers and gathers one report. `/show-me-your-work` keeps the decision log. `/figure-it-out` designs a custom playbook for large jobs. `/reflect` turns lessons from a session into skill changes. `/automate-me` drafts your own personal mode from how you've actually worked.

Each principle from Appendix A is also its own skill, so agents can read the full rule. You don't call those directly. `/poteto-mode` reads them, and you steer by naming them.

## Other tools

If you use a different agent tool, you can still use pstack's files. They're plain text written in Markdown. Most agent tools support some form of instruction files or skills, and many of pstack's playbooks and principles can be adapted to them with small changes. pstack is open source under the MIT license, and its author invites people to fork it and make it their own.
