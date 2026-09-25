# AI tools

This repo holds the agent skills I use across my machines, including skills I've written and skills I've picked up from other people. I've tweaked many of those copies for my own workflow, so they may differ from the originals.

## Install on another computer

Clone the repository and copy the skills into your user skill directory:

```sh
git clone https://github.com/waffleflopper/ai-tools.git
cd ai-tools
mkdir -p "$HOME/.agents/skills"
cp -R skills/. "$HOME/.agents/skills/"
```

To update, run `git pull --ff-only` in the clone and copy the skills again. The copy will overwrite matching files in your skill directory, so save any local edits you want to keep.

## Skills

These groups show where each skill started, even if I've changed it since.

### waffleflopper skills

| Skill | What it does |
| --- | --- |
| [finish-pr](skills/finish-pr/SKILL.md) | Takes a PR through review fixes, CI, and merge or handoff. |
| [prune-tests](skills/prune-tests/SKILL.md) | Audits brittle or tautological tests for removal or rewrite. |

### From [mattpocock/skills](https://github.com/mattpocock/skills)

| Skill | What it does |
| --- | --- |
| [ask-matt](skills/ask-matt/SKILL.md) | Helps pick the right skill for a task. |
| [code-review](skills/code-review/SKILL.md) | Reviews a change against project standards and the requested behavior. |
| [codebase-design](skills/codebase-design/SKILL.md) | Helps design clearer module boundaries and interfaces. |
| [diagnosing-bugs](skills/diagnosing-bugs/SKILL.md) | Works through hard bugs and performance regressions. |
| [domain-modeling](skills/domain-modeling/SKILL.md) | Builds a shared vocabulary and records design decisions. |
| [grill-me](skills/grill-me/SKILL.md) | Asks pointed questions to sharpen an idea or plan. |
| [grill-with-docs](skills/grill-with-docs/SKILL.md) | Sharpens a plan while recording decisions and shared terms. |
| [grilling](skills/grilling/SKILL.md) | Tests a plan or decision against evidence and tradeoffs. |
| [handoff](skills/handoff/SKILL.md) | Captures context for another agent to pick up the work. |
| [implement](skills/implement/SKILL.md) | Implements work from a spec or set of tickets. |
| [improve-codebase-architecture](skills/improve-codebase-architecture/SKILL.md) | Finds and explores opportunities to improve code structure. |
| [prototype](skills/prototype/SKILL.md) | Builds a quick prototype to answer a design question. |
| [research](skills/research/SKILL.md) | Investigates a question using primary sources and saves the findings. |
| [resolving-merge-conflicts](skills/resolving-merge-conflicts/SKILL.md) | Resolves merge and rebase conflicts using the history behind each change. |
| [setup-matt-pocock-skills](skills/setup-matt-pocock-skills/SKILL.md) | Sets up the issue tracker and project docs used by the engineering skills. |
| [tdd](skills/tdd/SKILL.md) | Builds features and fixes bugs with a test-first loop. |
| [teach](skills/teach/SKILL.md) | Teaches a topic using trusted sources and exercises. |
| [to-spec](skills/to-spec/SKILL.md) | Turns a conversation into a spec. |
| [to-tickets](skills/to-tickets/SKILL.md) | Breaks a plan into linked, actionable tickets. |
| [triage](skills/triage/SKILL.md) | Sorts and verifies issues before implementation. |
| [wayfinder](skills/wayfinder/SKILL.md) | Maps a large project into decisions that can be resolved one at a time. |
| [writing-great-skills](skills/writing-great-skills/SKILL.md) | A reference for writing clear, dependable skills. |

### From [jakubkrehel/skills](https://github.com/jakubkrehel/skills)

| Skill | What it does |
| --- | --- |
| [better-accessibility](skills/better-accessibility/SKILL.md) | Reviews and improves accessibility. |
| [better-colors](skills/better-colors/SKILL.md) | Builds palettes and color systems, including contrast checks. |
| [better-interface](skills/better-interface/SKILL.md) | Reviews an interface across layout, type, color, copy, and accessibility. |
| [better-layout](skills/better-layout/SKILL.md) | Improves grouping, alignment, spacing, and reading order. |
| [better-typography](skills/better-typography/SKILL.md) | Refines type choices, sizing, spacing, and wrapping. |
| [better-ui](skills/better-ui/SKILL.md) | Polishes surfaces, icons, alignment, and motion. |
| [better-writing](skills/better-writing/SKILL.md) | Improves product copy. |
| [break](skills/break/SKILL.md) | Stress tests a component across states and scenarios. |
| [explain-interface](skills/explain-interface/SKILL.md) | Investigates how a web interface was built. |
| [interface-review](skills/interface-review/SKILL.md) | Gives a detailed review of an interface. |
| [variant](skills/variant/SKILL.md) | Creates and compares component variations. |

### From [humanlayer/skills](https://github.com/humanlayer/skills)

| Skill | What it does |
| --- | --- |
| [show-me](skills/show-me/SKILL.md) | Explains ideas with diagrams and focused visual examples. |

## License

[MIT](LICENSE)
