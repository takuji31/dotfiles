---
name: wt-worktrees
description: "Use when Git worktree or parallel branch work is needed, including requests mentioning git worktree/worktrees, separate working directories, parallel agents, isolated feature branches, Worktrunk wt, project hooks, .config/wt.toml, or Windows environments where wt conflicts with Windows Terminal."
---

# WT Worktrees

## Overview

Use Worktrunk `wt` as the primary interface for Git worktree lifecycle tasks. Prefer `wt` over raw `git worktree` when the user wants branch-addressed worktrees, agent-friendly parallel work, local merge automation, or consistent cleanup.

## First Checks

- On Windows, `wt` can resolve to Windows Terminal. Read every `wt ...` command in this skill as `git-wt ...` unless the environment clearly has a Worktrunk `wt` shim earlier in `PATH`.
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
| Create project config for hooks | `wt config create --project` |
| Show configured hooks | `wt hook show` |
| Run a hook manually | `wt hook <type>` |
| Run only project hooks | `wt hook <type> project:` |
| Inspect background hook logs | `wt config state logs` |
| Manage hook approvals | `wt config approvals add` / `wt config approvals clear` |

## Project Hooks

Use project hooks when a repository needs shared Worktrunk lifecycle automation. Project hooks live in `.config/wt.toml`, should be committed with the repo, and require first-run approval because they execute project-provided commands.

Start with `wt config create --project` if `.config/wt.toml` does not exist. If it exists, edit the existing file and preserve unrelated settings.

Choose hook timing by dependency:

- Use `pre-start` for setup that must finish before work begins, such as dependency install or env file generation.
- Prefer `post-start` for background work such as dev servers, file watchers, cache copying, and long builds.
- Use `pre-commit` for quick format/lint/typecheck during `wt merge`.
- Use `pre-merge` for slower verification, tests, builds, and security checks before integration.
- Use `pre-remove` or `post-remove` for cleanup tied to deleting a worktree.

Use simple string hooks for one command:

```toml
pre-merge = "npm test"
```

Use a table when independent commands can run concurrently:

```toml
[post-start]
server = "npm run dev -- --port {{ branch | hash_port }}"
watch = "npm run watch"
```

Use `[[hook]]` pipeline blocks when later steps depend on earlier steps. Prefer this for `pre-*` hooks with multiple commands because table form for `pre-*` hooks is deprecated:

```toml
[[pre-start]]
deps = "npm ci"

[[pre-start]]
env = "cp .env.example .env.local"
```

Test hook changes manually before relying on lifecycle commands:

```bash
wt hook show
wt hook pre-start project:
wt hook pre-merge project:
```

Run with `-v` when template variables or expanded commands need inspection.

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
- Treat project hook additions as code execution changes. Inspect commands, avoid destructive shell snippets, and keep commands repo-relative when possible.
- Do not bypass project hook approval with `--yes` unless the user explicitly wants non-interactive execution, such as CI.
- Do not skip hooks with `--no-hooks` to hide failures. Use it only when the user explicitly chooses to bypass a known hook.

## Troubleshooting

- Branch does not exist: use `wt list --branches`; create it with `wt switch --create <branch>` if appropriate.
- Target path is occupied or stale: inspect the path and existing `wt list` output before using `--clobber`.
- Shell integration missing: run `wt config show`; install with `wt config shell install` when the user wants persistent `cd` behavior.
- Need diagnostics: run `wt config show --full` or rerun the failing command with `-vv`, then inspect `.git/wt/logs/`.
- Need to debug configured hooks: run `wt hook show`, then run the specific hook manually with `wt hook <type> project:` or `wt -v hook <type> project:`.
- Background `post-*` hook failed or appears silent: inspect logs with `wt config state logs`; background hook output is logged rather than blocking the command.
- Project hook asks for approval: review the displayed commands; approve only when the commands match the repo's intended automation.
