# AI tools

This repo holds the agent skills I use across my machines and [Build It Right](ebook/README.md), an ebook for people without a programming background who want to build software with AI.

The skills include ones I've written and ones I've picked up from other people. I've made many of my skills repo specific so they fit each project's tools, architecture, and conventions. This directory keeps the small set I use across projects, and my copies may differ from the originals.

## Install on another computer

Clone the repository and copy the skills into your user skill directory:

```sh
git clone https://github.com/waffleflopper/ai-tools.git
cd ai-tools
mkdir -p "$HOME/.agents/skills"
cp -R skills/. "$HOME/.agents/skills/"
```

To update, run `git pull --ff-only` in the clone and copy the skills again. The copy will overwrite matching files in your skill directory, so save any local edits you want to keep. Copying doesn't remove previously installed skills that have been deleted from this repo; remove those separately if you want to keep the installed set in sync.

## Skills

These groups show where each skill started, even if I've changed it since. The architecture workflow depends on `codebase-design`, `grilling`, and `domain-modeling`, so those are included too.

### waffleflopper skills

| Skill | What it does |
| --- | --- |
| [prune-tests](skills/prune-tests/SKILL.md) | Audits brittle or tautological tests for removal or rewrite. |

### From [mattpocock/skills](https://github.com/mattpocock/skills)

| Skill | What it does |
| --- | --- |
| [code-review](skills/code-review/SKILL.md) | Reviews a change against project standards and the requested behavior. |
| [codebase-design](skills/codebase-design/SKILL.md) | Helps design clearer module boundaries and interfaces. |
| [domain-modeling](skills/domain-modeling/SKILL.md) | Builds a shared vocabulary and records design decisions. |
| [grilling](skills/grilling/SKILL.md) | Tests a plan or decision against evidence and tradeoffs. |
| [improve-codebase-architecture](skills/improve-codebase-architecture/SKILL.md) | Finds and explores opportunities to improve code structure. |

### From [humanlayer/skills](https://github.com/humanlayer/skills)

| Skill | What it does |
| --- | --- |
| [show-me](skills/show-me/SKILL.md) | Explains ideas with diagrams and focused visual examples. |

## Build It Right

[Build It Right](ebook/README.md) is an ebook for people outside programming and development who want to use AI to make software. It translates the engineering skills, principles, and lessons from [pstack](https://github.com/cursor/plugins/tree/main/pstack) by Lauren Tan (poteto) into plain language, with practical examples and playbooks.

The book covers how to direct agents, choose simpler designs, verify their work, fix bugs at the cause, and keep software reliable as it grows. Start with [About this book](ebook/chapters/00-about.md) and [chapter 1](ebook/chapters/01-why-this-book.md). The [ebook README](ebook/README.md) has the full chapter list and instructions for building EPUB, HTML, and PDF copies.

## License

[MIT](LICENSE)
