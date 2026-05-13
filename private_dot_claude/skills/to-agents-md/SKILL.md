---
name: to-agents-md
description: Convert a project's CLAUDE.md to AGENTS.md following https://code.claude.com/docs/en/memory#agents-md . Splits content into AGENTS.md (generic, shared with other coding agents) and CLAUDE.md (`@AGENTS.md` import plus Claude-specific overrides). Use when user wants to migrate CLAUDE.md to AGENTS.md, share instructions with other coding agents (Codex/Cursor/Aider), or says 「AGENTS.md 化」「AGENTS.md に移行」.
---

# To AGENTS.md

Migrate a repo's `CLAUDE.md` to the dual-file layout from <https://code.claude.com/docs/en/memory#agents-md>:

- `AGENTS.md` — generic instructions, shared with every coding agent (Codex, Cursor, Aider, ...).
- `CLAUDE.md` — `@AGENTS.md` import plus a `## Claude Code` section reserved for genuinely Claude-specific overrides.

The skill writes files only. The user reviews `git diff` and commits.

## Process

### 1. Detect

Look in the repository root for: `./CLAUDE.md`, `./.claude/CLAUDE.md`, `./AGENTS.md`, `./.claude/AGENTS.md`.

If no CLAUDE.md exists, stop — nothing to migrate.

### 2. Idempotency

A CLAUDE.md whose body is `@AGENTS.md` followed by `## Claude Code` (and whose imported AGENTS.md actually exists) is **already migrated**. Report and exit. The skill is safe to re-run.

### 3. Handle `./.claude/CLAUDE.md`

If both `./CLAUDE.md` and `./.claude/CLAUDE.md` exist, ask:

> `.claude/CLAUDE.md` も検出しました。ルートの AGENTS.md にマージして `.claude/CLAUDE.md` を削除しますか? (Yes / No)

- **Yes**: merge into the root AGENTS.md, delete `./.claude/CLAUDE.md`.
- **No**: process only the root, leave `./.claude/CLAUDE.md` untouched.

If only one of the two exists, process it without asking.

### 4. Pre-existing AGENTS.md

If AGENTS.md exists but CLAUDE.md is not migrated, show its content to the user and ask whether to:

- merge CLAUDE.md content into it,
- discard CLAUDE.md content and just convert CLAUDE.md to a `@AGENTS.md` stub, or
- abort.

### 5. Detect language

Detect the dominant natural language of the source CLAUDE.md. The generated AGENTS.md and the CLAUDE.md meta-rule must use the **same** language. Never translate.

### 6. Classify content

For each section / paragraph in the source, decide:

**To AGENTS.md** (generic):

- Project overview, build commands, repo structure, conventions, workflows, gotchas.
- Capabilities that exist across agents — rewrite to generic vocabulary:
  - "plan モード" → "実装着手前にプランを提示する"
  - "Claude の skills" → "自動化された手順テンプレート" / "agent skills"
  - "/init" → "プロジェクト初期化コマンド"
  - "CLAUDE.md" self-reference → "this instructions file" / "エージェント指示ファイル"

**Stays in CLAUDE.md `## Claude Code`** (genuinely Claude-specific):

- `<remember>` / `<remember priority>` tags
- `--append-system-prompt`, `CLAUDE_CODE_*` env vars
- `.claude/` internals (`claudeMdExcludes`, `claudeMd` managed setting, ...)
- Claude-specific framework references (e.g. `oh-my-claudecode`, `omc-*`)
- Slash commands with no equivalent in other agents
- Self-identifying instructions ("You are Claude...")

When in doubt, prefer AGENTS.md with generic phrasing.

### 7. Write the files

**AGENTS.md** — generic content from step 6, preserving the source's section structure where possible. No meta-instructions about file management.

**CLAUDE.md** — import stub:

````markdown
@AGENTS.md

## Claude Code

<meta-rule, in the detected language>

<Claude-specific content from step 6, if any>
````

The meta-rule must convey: *"Add new project instructions to AGENTS.md. CLAUDE.md only imports AGENTS.md and is reserved for Claude Code-specific overrides."*

Japanese template:

```markdown
このプロジェクトの指示は AGENTS.md に追記してください。CLAUDE.md は AGENTS.md を import するスタブで、Claude Code 固有のオーバーライドだけをここに書きます。
```

English template:

```markdown
Add new project instructions to AGENTS.md, not here. This file only imports AGENTS.md and contains Claude Code-specific overrides.
```

If step 3 was Yes, delete `./.claude/CLAUDE.md`.

### 8. Report

Print a summary of files written / deleted and run `git diff --stat` for the affected paths.

Do **not** stage or commit. Tell the user to review `git diff` and commit themselves.

## Out of scope

- Hooks, `.claude/settings.json`, managed policy CLAUDE.md — untouched.
- Auto-commit, push, PR creation.
- chezmoi-specific handling. The skill operates inside any repo; if the target is a chezmoi-managed dotfiles repo, the user handles chezmoi `re-add` / staging separately.
