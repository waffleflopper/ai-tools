---
name: resolving-merge-conflicts
description: "Use when you need to resolve an in-progress git merge/rebase conflict."
---

1. **See the current state** of the merge/rebase. Check git history, and the conflicting files.

2. **Find the primary sources** for each conflict. Understand deeply why each change was made, and what the original intent was. Read the commit messages, check the PRs, check original issues/tickets.

3. **Resolve each hunk.** Preserve both intents where possible. Where incompatible, pick the one matching the merge's stated goal and note the trade-off. Do **not** invent new behaviour. Follow an explicit user request to abort. If incompatible intents leave a consequential product choice unresolved, explain that choice and ask rather than inventing behavior.

4. Discover the project's **automated checks** and run them — typically typecheck, then tests, then format. Fix anything the merge broke.

5. **Finish the merge/rebase.** Stage resolved task-owned files and retain the intended changes already staged by the merge or rebase. Preserve unrelated working-tree and staged changes. Verify the staged diff contains only the intended merge or rebase changes before committing; if unrelated staged changes would enter the commit, preserve them outside that commit or ask when safe separation is unclear. If rebasing, continue the rebase process until all commits are rebased.
