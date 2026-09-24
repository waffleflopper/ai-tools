# AI tools

Personal collection of skills for AI coding agents, including local customizations.  This repo is really just so I have a place to keep my skills in sync between my systems all running T3Code.  The skills are mostly from Matt Pocock's skills at https://github.com/mattpocock/skills (these are excellent skills and you should 100% check it out and give him a star if you haven't heard of him already, somehow); the interface skills are from https://github.com/jakubkrehel/skills (I use these when I'm using a GPT model, not so much if using Claude).  Many of the skills have been edited and tweaked to work a bit more how I want them to with Astra, since it's my main driver, and Matt designs his skills around Claude models, for the most part.

This repository contains all 35 skills from `~/.agents/skills`, plus `finish-pr`.
Supporting references, scripts, and `agents/openai.yaml` files are included.

## Install on another computer

Clone the repository, then copy the skills into your user skill directory:

```sh
git clone https://github.com/waffleflopper/ai-tools.git
cd ai-tools
mkdir -p "$HOME/.agents/skills"
cp -R skills/. "$HOME/.agents/skills/"
```

To update an existing clone, run `git pull --ff-only` from the clone and repeat the
copy command. Copying replaces matching local files; back up any changes on the
destination computer that you want to keep first. Other installed skill folders
are left in place.

Skill content and invocation settings are preserved from the source computer.
Machine installation metadata (`.skill-lock.json`) and macOS `.DS_Store` files are
not included. Project-specific guidance referenced by skills (such as
`docs/agents/issue-tracker.md`) still belongs in each project.

## Skills

| Skill | Description |
| --- | --- |
| [ask-matt](skills/ask-matt/SKILL.md) | Ask which skill or flow fits your situation. A router over the skills in this repo. |
| [better-accessibility](skills/better-accessibility/SKILL.md) | Helps your project comply with accessibility standards and best practices. |
| [better-colors](skills/better-colors/SKILL.md) | Helps you build a color system and answer anything about color in your project. You can generate palettes, use semantic tokens, convert between formats, check contrast and more. |
| [better-interface](skills/better-interface/SKILL.md) | Review an interface or UI change across accessibility, layout, writing, typography, color, and polish; consolidate evidence into one ranked report. |
| [better-layout](skills/better-layout/SKILL.md) | Helps with grouping, alignment, reading order, progressive disclosure and other details that make a good layout. |
| [better-typography](skills/better-typography/SKILL.md) | Focuses on type scale, spacing, sizing, variable fonts, OpenType features, wrapping, truncation and other details that make typography feel great across your product. |
| [better-ui](skills/better-ui/SKILL.md) | Review or improve UI surfaces, icons, alignment, and motion within an existing design system. |
| [better-writing](skills/better-writing/SKILL.md) | Focuses on improving product copy in your project. |
| [break](skills/break/SKILL.md) | Renders a component you choose in every state and scenario on a temporary page and stress tests it. |
| [code-review](skills/code-review/SKILL.md) | Review branches, PRs, or working changes with independent Standards and Spec reviewers, then report both axes. |
| [codebase-design](skills/codebase-design/SKILL.md) | Shared vocabulary for designing deep modules. Use when the user wants to design or improve a module's interface, find deepening opportunities, decide where a seam goes, make code more testable or AI-navigable, or when another skill needs the deep-module vocabulary. |
| [diagnosing-bugs](skills/diagnosing-bugs/SKILL.md) | Diagnosis loop for hard bugs and performance regressions. Use when the user says "diagnose"/"debug this", or reports something broken/throwing/failing/slow. |
| [domain-modeling](skills/domain-modeling/SKILL.md) | Build and sharpen a project's domain model. Use when the user wants to pin down domain terminology or a ubiquitous language, record an architectural decision, or when another skill needs to maintain the domain model. |
| [explain-interface](skills/explain-interface/SKILL.md) | Helps you figure out how something was built on the web. |
| [finish-pr](skills/finish-pr/SKILL.md) | Carry a pull request through review fixes, CI, and authorized merge or handoff. Use when asked to finish a PR or handle its review-to-merge workflow. |
| [grill-me](skills/grill-me/SKILL.md) | A relentless interview to sharpen a plan or design. |
| [grill-with-docs](skills/grill-with-docs/SKILL.md) | A relentless interview to sharpen a plan or design, which also creates docs (ADR's and glossary) as we go. |
| [grilling](skills/grilling/SKILL.md) | Stress-test a plan, decision, or idea through evidence and consequential tradeoffs. Use when the user asks to grill or challenge their thinking. |
| [handoff](skills/handoff/SKILL.md) | Compact the current conversation into a handoff document for another agent to pick up. |
| [implement](skills/implement/SKILL.md) | Implement a piece of work based on a spec or set of tickets. |
| [improve-codebase-architecture](skills/improve-codebase-architecture/SKILL.md) | Scan a codebase for deepening opportunities, present them as a visual HTML report, then grill through whichever one you pick. |
| [interface-review](skills/interface-review/SKILL.md) | Reviews your work across multiple categories like UI, typography, layout, color, writing and accessibility and gives you a detailed analysis of the findings. |
| [prototype](skills/prototype/SKILL.md) | Build a throwaway prototype to answer a design question. Use when the user wants to sanity-check whether a state model or logic feels right, or explore what a UI should look like. |
| [prune-tests](skills/prune-tests/SKILL.md) | Audit brittle or tautological tests and, when cleanup is authorized, delete or rewrite them around independently specified behavior. |
| [research](skills/research/SKILL.md) | Investigate a question against high-trust primary sources and capture the findings as a Markdown file in the repo. Use when the user wants a topic researched, docs or API facts gathered, or reading legwork delegated to a background agent. |
| [resolving-merge-conflicts](skills/resolving-merge-conflicts/SKILL.md) | Use when you need to resolve an in-progress git merge/rebase conflict. |
| [setup-matt-pocock-skills](skills/setup-matt-pocock-skills/SKILL.md) | Configure this repo for the engineering skills — set up its issue tracker, triage label vocabulary, and domain doc layout. Run once before first use of the other engineering skills. |
| [show-me](skills/show-me/SKILL.md) | Help the user understand the current topic visually with concise diagrams, code-shape sketches, and focused HTML artifacts. |
| [tdd](skills/tdd/SKILL.md) | Build features or fix bugs test-first using red-green-refactor. A request for integration tests alone does not require TDD. |
| [teach](skills/teach/SKILL.md) | Teach the user a new skill or concept, within this workspace. |
| [to-spec](skills/to-spec/SKILL.md) | Turn the current conversation into a spec and publish it to the project issue tracker — no interview, just synthesis of what you've already discussed. |
| [to-tickets](skills/to-tickets/SKILL.md) | Break a plan, spec, or the current conversation into a set of tracer-bullet tickets, each declaring its blocking edges, published to the configured tracker — edges as text in one file per ticket locally, or native blocking links on a real tracker. |
| [triage](skills/triage/SKILL.md) | Move issues and external PRs through a state machine of triage roles — categorise, verify, grill if needed, and write agent-ready briefs. |
| [variant](skills/variant/SKILL.md) | Builds multiple variants of a component you're working on and helps you iterate and pick one. |
| [wayfinder](skills/wayfinder/SKILL.md) | Plan a huge chunk of work — more than one agent session can hold — as a shared map of decision tickets on your issue tracker, and resolve them one at a time until the way to the destination is clear. |
| [writing-great-skills](skills/writing-great-skills/SKILL.md) | Reference for writing and editing skills well — the vocabulary and principles that make a skill predictable. |

## License

[MIT](LICENSE)
