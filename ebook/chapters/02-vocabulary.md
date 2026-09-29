# 2. Just enough vocabulary

You can't hold an agent to a standard if you can't follow what it tells you. This chapter covers the words that come up in the rest of the book. Skim it now and come back when a word trips you up.

## The pieces of a software product

**Code.** Instructions written in a programming language that a computer follows. An agent writes code when you ask it to build something.

**Codebase or repository.** All the code for one product, kept together in one folder, with its history. People shorten repository to "repo."

**File and module.** Code is split across many files. A module is a file or group of files that handles one job, such as "everything about shifts" or "everything about payments."

**Function.** A named, reusable chunk of code that takes some input and produces a result. `calculateOvertime(hours)` might take a number of hours and return the overtime pay. When one piece of code uses a function, it "calls" it. The code that uses a function is its "caller."

**Data.** The information your product stores and moves around. That includes shifts, users, reminder times, and payment records.

**Database.** Where data lives permanently. Think of a set of very strict spreadsheets. Each table has fixed columns, and each row is one record. A request to read or change data in the database is called a query.

**Frontend and backend.** The frontend is what runs on the user's screen, such as a web page or a phone app. The backend runs on your servers. It holds the database, enforces the rules, and talks to outside services. This split matters a great deal for security, and chapter 7 explains why.

**Server.** A computer that runs your backend and answers requests from users' browsers and phones.

**API.** Short for application programming interface. It's the set of requests one piece of software accepts from another. ClinicDesk's backend might accept a request called "claim shift 42 for this user." A text-message service like Twilio accepts a request called "send this message to this number." An API is a menu of what you're allowed to ask for. Each item on the menu is called an endpoint.

**Interface.** The same idea, more broadly. An interface is the part of something that others use, as opposed to how it works inside. A light switch is the interface to your home's wiring.

## Keeping track of changes

Software is built in small changes over time. A tool called Git records every change. You don't need to run Git yourself, but agents will talk about it constantly.

**Commit.** One saved change, with a short message describing it. The history of a project is a list of commits. A good commit does one thing and says what it does.

**Diff.** The exact lines a change adds and removes. When you review an agent's work, you're reviewing a diff.

**Branch.** A separate line of work. The main branch, usually called `main`, holds the official version. You make changes on a side branch so `main` stays safe until the change is ready.

**Pull request, or PR.** A request to fold a branch's changes into `main`. It holds the diff, a description, and review comments. It's where changes get checked before they become official.

**Merge.** Folding a branch into `main`. After a merge, the change is part of the official version.

**Worktree.** A separate copy of the project's files on your computer, tied to one branch. If two agents work at the same time, each needs its own worktree. Otherwise they overwrite each other's files, the way two people typing in the same document at once would.

## Checks

**Build or compile.** Turning code into something that runs. If it "compiles," the computer could read it. That says nothing about whether it does the right thing. A letter can be spelled perfectly and still be addressed to the wrong person.

**Types and the type checker.** Many languages let you label what kind of thing each piece of data is, such as a number, some text, or a date. The type checker reads the code before it runs and refuses to proceed if the labels don't fit. It catches mistakes like passing a date where a phone number belongs. Chapter 7 shows how to use it to rule out whole categories of bugs. TypeScript is a common language that adds types to JavaScript.

**Linter.** A tool that scans code for known bad patterns and style problems. You can add your own rules to it.

**Tests.** Small programs that run your code with a known input and check for a known output. "When a nurse claims an open shift, the shift shows that nurse's name." Tests run automatically and tell you if a change broke something. Chapter 10 covers what makes a test worth keeping.

**CI, for continuous integration.** A service that automatically builds your code and runs your tests and linter every time someone opens or updates a pull request. A red X means a check failed. A green check mark means they all passed. Green is good, but chapter 9 explains why it isn't proof.

## When things run

**Local, staging, production.** Local means running on your own computer. Staging is a practice copy of the real thing. Production, or "prod," is the real thing that real users touch. Mistakes in production cost the most.

**Deploy.** Pushing a new version to production.

**Environment variable.** A setting given to your app by the computer it runs on, rather than written in the code. Secret keys usually go here, so they never appear in the code itself.

**Bug.** The software does something other than what it should.

**Error, exception, crash.** The software hit something it couldn't handle. Sometimes it recovers and sometimes it stops.

**Logs.** A running record the software writes about what it's doing, like a patient chart for your app. When something goes wrong, the logs are often the first evidence.

**Edge case.** An unusual input or situation. Examples are an empty list, a name with an apostrophe, a shift that crosses midnight, or a user who clicks a button twice.

## Working with agents

**Model.** The AI system itself. Different companies make different models, and each has its own strengths.

**Agent.** A model that can take actions such as reading files, running commands, and editing code, not just chat.

**Prompt.** What you type to the agent.

**Context window.** How much the agent can hold in its working memory at once. It includes your conversation, the files it has read, and the output of commands it ran. When it fills up, the agent starts forgetting or summarizing, and its work gets worse. Chapter 15 covers how to protect it.

**Subagent.** A second agent that the main agent starts to handle a piece of work, like a team lead handing a task to a teammate. The subagent reports back with a summary.

**Skill.** A saved set of instructions that an agent reads before doing a certain kind of work. pstack is a collection of skills. You can write your own.

## One more term, slop

"Slop" is the informal name for output that looks like work but isn't good work. In code, it's extra lines that do nothing useful, comments that narrate the obvious, checks for things that can't happen, and features nobody asked for. In writing, it's padding and fancy words. Slop is what agents produce when nobody holds them to a standard. Most of this book is about how to hold them to one.
