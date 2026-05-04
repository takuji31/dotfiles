---
name: wt-worktrees
description: "Use when Git worktree or parallel branch work is needed, including requests mentioning git worktree/worktrees, separate working directories, parallel agents, isolated feature branches, or Worktrunk wt. Prefer Worktrunk wt over raw git worktree for inspecting, creating, switching, launching Claude Code or Codex in a worktree, merging, removing, pruning, and diagnosing shell integration/configuration."
---

# WT Worktrees

## Overview

Use Worktrunk `wt` as the primary interface for Git worktree lifecycle tasks. Prefer `wt` over raw `git worktree` when the user wants branch-addressed worktrees, agent-friendly parallel work, local merge automation, or consistent cleanup.

## First Checks

- Run `wt list` before changing worktrees so the current branch, dirty state, integration status, and existing worktree paths are visible.
- Use `wt list --format=json` when scripting or when exact fields are needed.
- Run `wt config show` when path layout, shell integration, hooks, or commit-message generation behavior is relevant.
- If `wt switch` cannot change directory, check shell integration with `wt config show`; Worktrunk needs shell integration for `cd` behavior.

## Common Operations

| Task | Command |
| --- | --- |
| List worktrees | `wt list` |
| Include branches without worktrees | `wt list --branches` |
| Include CI/diff/summary details | `wt list --full` |
| Switch to a worktree | `wt switch <branch>` |
| Switch to previous worktree | `wt switch -` |
| Create a new worktree branch | `wt switch --create <branch>` |
| Create from a base branch | `wt switch --create <branch> --base <base>` |
| Switch to a GitHub PR branch | `wt switch pr:<number>` |
| Launch Claude Code in a new worktree | `wt switch -c <branch> -x claude -- '<task>'` |
| Launch Codex in a new worktree | `wt switch -c <branch> -x codex -- '<task>'` |
| Show branch diff since branching | `wt step diff` |
| Commit with configured LLM message | `wt step commit` |
| Push current branch to target | `wt step push` |
| Merge current branch into default target | `wt merge` |
| Merge but keep worktree | `wt merge --no-remove` |
| Remove current integrated worktree | `wt remove` |
| Remove a named integrated worktree | `wt remove <branch>` |
| Preview prune candidates | `wt step prune --dry-run` |

## Lifecycle Workflow

1. Inspect state: `wt list --branches`.
2. Create or enter worktree: `wt switch --create <branch>` or `wt switch <branch>`.
3. Do the requested work inside that worktree. Preserve unrelated user changes.
4. Review before integration: `wt step diff`, then run the repo's verification commands.
5. Choose integration path:
   - PR workflow: `wt step commit`, push/open PR with the repo's GitHub/GitLab flow, then `wt remove` after remote merge.
   - Local workflow: `wt merge` from the feature worktree to squash/rebase/fast-forward into the default branch and clean up.
6. For stale worktrees, run `wt step prune --dry-run` first, then prune only when the listed candidates match the user's intent.

## Safety Rules

- Treat `wt merge`, `wt remove`, `wt step prune`, and flags like `--force`, `-D`, `--no-hooks`, and `--yes` as high-impact operations. Inspect status first and only use them when the user's intent is clear.
- Do not use `wt remove -D` unless the user explicitly wants to delete unmerged branch work.
- Prefer `wt merge --no-remove` when the user wants integration but may continue inspecting the worktree.
- If hooks fail during `wt merge` or `wt remove`, stop and inspect the hook output/logs before retrying or bypassing hooks.
- If a worktree contains ignored local state that should not be deleted, lock it with `git worktree lock <path> --reason '<reason>'`.

## Troubleshooting

- Branch does not exist: use `wt list --branches`; create it with `wt switch --create <branch>` if appropriate.
- Target path is occupied or stale: inspect the path and existing `wt list` output before using `--clobber`.
- Shell integration missing: run `wt config show`; install with `wt config shell install` when the user wants persistent `cd` behavior.
- Need diagnostics: run `wt config show --full` or rerun the failing command with `-vv`, then inspect `.git/wt/logs/`.
