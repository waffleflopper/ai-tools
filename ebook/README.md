# Build It Right

*Senior engineering habits for people who build with AI agents.*

This ebook translates the engineering skills, principles, and lessons learned from [pstack](https://github.com/cursor/plugins/tree/main/pstack), articles, and talks by Lauren Tan (poteto) into plain language for people outside programming and development who want to use AI to make software.

## Read it

The chapters are Markdown files in [`chapters/`](chapters/), and GitHub renders them. Start with [About this book](chapters/00-about.md) and [chapter 1](chapters/01-why-this-book.md).

| Chapter | Covers |
| --- | --- |
| [1. Why this book exists](chapters/01-why-this-book.md) | Who it's for and where the ideas come from. |
| [2. Just enough vocabulary](chapters/02-vocabulary.md) | The terms the rest of the book uses. |
| [3. You are the lead](chapters/03-you-are-the-lead.md) | Goals, finish conditions, and demanding evidence. |
| [4. Understand before you change anything](chapters/04-understand-first.md) | How it works, why it's built that way, and confidence levels. |
| [5. Build less](chapters/05-build-less.md) | Deleting first, small changes, and code that's easy to read. |
| [6. Get the shape right first](chapters/06-shape-first.md) | Data shape, domain structures, prototypes, and design sketches. |
| [7. Guard the doors](chapters/07-guard-the-doors.md) | Boundaries, types, and security basics. |
| [8. Plan for things happening twice](chapters/08-plan-for-twice.md) | Retries, crashes, and two users at once. |
| [9. Prove it works](chapters/09-prove-it-works.md) | Real evidence instead of "it compiles." |
| [10. Tests that can actually fail](chapters/10-tests-that-can-fail.md) | Telling real tests from fake ones, pruning tests that break for no reason, and writing the failing test first. |
| [11. Fix bugs at the root](chapters/11-fix-root-causes.md) | Reproducing, root causes, and questioning the diagnosis. |
| [12. When it's slow](chapters/12-when-its-slow.md) | Measuring, eight kinds of speed fixes, and hillclimbing. |
| [13. Small steps, clean changes, real review](chapters/13-small-steps.md) | Commits, pull requests, cleanup, and review. |
| [14. Changing code that already works](chapters/14-changing-working-code.md) | Refactoring safely and deleting old versions. |
| [15. Running agents well](chapters/15-running-agents.md) | Context, autonomy, scripts, guardrails, logs, and handoffs. |
| [16. Rescuing a vibe-coded project](chapters/16-rescuing-a-project.md) | Applying all of it to a project that's already a mess. |
| [17. The playbooks](chapters/17-playbooks.md) | Checklists for each kind of task. |
| [Appendix A](chapters/18-appendix-a-principles.md) | The 23 principles on one page. |
| [Appendix B](chapters/19-appendix-b-prompts.md) | Prompts to copy. |
| [Appendix C](chapters/20-appendix-c-pstack.md) | Using pstack itself in Cursor. |

## Build the EPUB, HTML, and PDF

You need [pandoc](https://pandoc.org/installing.html). The PDF also needs Chromium or Google Chrome.

```sh
./build.sh
```

The files land in `dist/`. The PDF is sized for a 6 by 9 inch page.

## Credits

pstack is copyright 2026 Lauren Tan and released under the MIT License. This book is based on pstack version 0.15.5.
