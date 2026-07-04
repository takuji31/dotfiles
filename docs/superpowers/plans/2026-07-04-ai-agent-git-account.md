# AI エージェント用 Git/gh アカウント分離 実装計画

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** AI エージェント (Claude Code / Codex / Cursor) 配下の git / gh 操作だけを GitHub アカウント `takuji31ai` で実行させる。

**Architecture:** 切り替えの本体は環境変数 2 つ (`GIT_CONFIG_GLOBAL` → `~/.config/git/config-ai`、`GH_CONFIG_DIR` → `~/.config/gh-ai`)。Claude Code と Codex は各ツールの設定でネイティブに注入し、Cursor はエージェントシェルにだけ入る `CURSOR_AGENT` 環境変数を zsh/fish/bash の起動時に検出して export する。普段のシェルにはこの環境変数が無いので、ユーザー自身の git / gh は完全に従来通り。

**Tech Stack:** chezmoi (Go テンプレート / modify テンプレート)、git、gh CLI、zsh / fish / bash

**Spec:** `docs/superpowers/specs/2026-07-04-ai-agent-git-account-design.md`

## Global Constraints

- 作業ディレクトリは chezmoi ソース: `/Users/takuji/.local/share/chezmoi`
- 設定ファイルを変更したら `chezmoi apply` を実行する (リポジトリ規約)
- `git push` は必ず remote と branch を明示する (`git push origin main`)。裸の `git push` 禁止
- AI アカウント: `takuji31ai` / GitHub ID `289154972` / commit email `289154972+takuji31ai@users.noreply.github.com`
- 専用鍵のパス: `~/.ssh/id_ed25519_ai` (全マシン共有。秘密鍵は chezmoi リポジトリに入れない)
- `~/.claude/settings.json` は現在パーミッション 600。modify テンプレートは `modify_private_settings.json` という名前にして 600 を維持する (`modify_settings.json` だと 644 に変わってしまうことを確認済み)
- 検証コマンドの「未設定であること」の確認は、Claude Code セッション自身が将来この環境変数を持つため、必ず `env -u GIT_CONFIG_GLOBAL -u GH_CONFIG_DIR` を付けて実行する

---

### Task 1: 専用 SSH 鍵の準備と allowed_signers への追記

**Files:**
- Modify: `dot_config/git/allowed_signers`
- (リポジトリ外) Create: `~/.ssh/id_ed25519_ai`, `~/.ssh/id_ed25519_ai.pub`

**Interfaces:**
- Produces: `~/.ssh/id_ed25519_ai` (Task 2 の `core.sshCommand` / `user.signingkey`、Task 7 の GitHub 登録で使う)

- [ ] **Step 1: 鍵が無ければ生成する**

```bash
test -f ~/.ssh/id_ed25519_ai || ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_ai -N "" -C "takuji31ai"
ls -l ~/.ssh/id_ed25519_ai ~/.ssh/id_ed25519_ai.pub
```

Expected: 2 ファイルが存在。秘密鍵は `-rw-------` (600)

- [ ] **Step 2: allowed_signers に公開鍵を追記する (chezmoi ソース側)**

```bash
printf '289154972+takuji31ai@users.noreply.github.com namespaces="git" %s\n' \
  "$(awk '{print $1, $2}' ~/.ssh/id_ed25519_ai.pub)" >> dot_config/git/allowed_signers
tail -n 1 dot_config/git/allowed_signers
```

Expected: `289154972+takuji31ai@users.noreply.github.com namespaces="git" ssh-ed25519 AAAA...` の 1 行

- [ ] **Step 3: apply して適用先を確認**

```bash
chezmoi apply
tail -n 1 ~/.config/git/allowed_signers
```

Expected: Step 2 と同じ行

- [ ] **Step 4: Commit**

```bash
git add dot_config/git/allowed_signers
git commit -m "feat: AIエージェント用署名鍵をallowed_signersに追加"
```

---

### Task 2: AI 用 git 設定 `config-ai` の作成

**Files:**
- Create: `dot_config/git/config-ai.tmpl` (適用先 `~/.config/git/config-ai`)

**Interfaces:**
- Consumes: `~/.ssh/id_ed25519_ai` (Task 1)
- Produces: `~/.config/git/config-ai` (Task 3〜5 が `GIT_CONFIG_GLOBAL` に設定するパス)

- [ ] **Step 1: `dot_config/git/config-ai.tmpl` を以下の内容で作成**

```gitconfig
# AI エージェント用 git 設定。エージェントが GIT_CONFIG_GLOBAL でこのファイルを
# 指定して読み込む。通常のシェルからの git は従来通り ~/.gitconfig を使う。
[include]
    path = ~/.gitconfig
[user]
    name = takuji31ai
    email = 289154972+takuji31ai@users.noreply.github.com
    signingkey = ~/.ssh/id_ed25519_ai.pub
[github]
    user = takuji31ai
[core]
{{ if eq .chezmoi.os "windows" -}}
    sshCommand = C:/Windows/System32/OpenSSH/ssh.exe -i ~/.ssh/id_ed25519_ai -o IdentitiesOnly=yes
{{ else -}}
    sshCommand = ssh -i ~/.ssh/id_ed25519_ai -o IdentitiesOnly=yes
{{ end -}}
[credential "https://github.com"]
    ; keychain 等に入っている本人の資格情報をリセットして gh (GH_CONFIG_DIR=gh-ai) に委譲
    helper =
    helper = !gh auth git-credential
```

- [ ] **Step 2: apply して差し替えが効くことを確認**

```bash
chezmoi apply
GIT_CONFIG_GLOBAL=$HOME/.config/git/config-ai git config user.name
GIT_CONFIG_GLOBAL=$HOME/.config/git/config-ai git config user.email
GIT_CONFIG_GLOBAL=$HOME/.config/git/config-ai git config alias.st
GIT_CONFIG_GLOBAL=$HOME/.config/git/config-ai git config core.sshCommand
```

Expected (順に): `takuji31ai` / `289154972+takuji31ai@users.noreply.github.com` / `status` (include が効いている証拠) / `ssh -i ~/.ssh/id_ed25519_ai -o IdentitiesOnly=yes`

- [ ] **Step 3: 通常の git が影響を受けていないことを確認**

```bash
env -u GIT_CONFIG_GLOBAL git config user.email
```

Expected: `takuji31@gmail.com`

- [ ] **Step 4: Commit**

```bash
git add dot_config/git/config-ai.tmpl
git commit -m "feat: AIエージェント用git設定config-aiを追加"
```

---

### Task 3: Claude Code への環境変数注入 (settings.json の modify テンプレート)

**Files:**
- Create: `private_dot_claude/modify_private_settings.json` (適用先 `~/.claude/settings.json`)

**Interfaces:**
- Consumes: `~/.config/git/config-ai` (Task 2)
- Produces: `~/.claude/settings.json` の `env.GIT_CONFIG_GLOBAL` / `env.GH_CONFIG_DIR`

- [ ] **Step 1: `private_dot_claude/modify_private_settings.json` を以下の内容で作成**

```
{{- /* chezmoi:modify-template */ -}}
{{- $cfg := dict -}}
{{- if ne (.chezmoi.stdin | trim) "" -}}
  {{- $cfg = fromJson .chezmoi.stdin -}}
{{- end -}}

{{- /* AI エージェント配下の git / gh を takuji31ai アカウントに切り替える */ -}}
{{- $cfg = $cfg | setValueAtPath "env.GIT_CONFIG_GLOBAL" (printf "%s/.config/git/config-ai" .chezmoi.homeDir) -}}
{{- $cfg = $cfg | setValueAtPath "env.GH_CONFIG_DIR" (printf "%s/.config/gh-ai" .chezmoi.homeDir) -}}

{{- $cfg | toPrettyJson -}}
```

- [ ] **Step 2: diff で「env 2 キーの追加 + 整形」だけであることを確認**

```bash
chezmoi diff --include files ~/.claude/settings.json
```

Expected: `GIT_CONFIG_GLOBAL` と `GH_CONFIG_DIR` の追加を含む diff。キー順のソートと整形による差分は出るが、既存キーの値の消失やパーミッション変更 (`old mode`/`new mode` 行) が無いこと

- [ ] **Step 3: apply して既存設定が保持されていることを確認**

```bash
chezmoi apply
jq -r '.env.GIT_CONFIG_GLOBAL, .env.GH_CONFIG_DIR, .env.CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS' ~/.claude/settings.json
jq '.permissions.allow | length' ~/.claude/settings.json
stat -f '%Lp' ~/.claude/settings.json
```

Expected: `/Users/takuji/.config/git/config-ai` / `/Users/takuji/.config/gh-ai` / `1` (既存キー保持)、permissions.allow の件数が 0 より大、パーミッション `600`

- [ ] **Step 4: Commit**

```bash
git add private_dot_claude/modify_private_settings.json
git commit -m "feat: Claude CodeにAIアカウント用環境変数を注入"
```

---

### Task 4: Codex への環境変数注入 (shell_environment_policy)

**Files:**
- Modify: `dot_codex/modify_config.toml:12` (`sandbox_workspace_write.network_access` の行の直後)

**Interfaces:**
- Consumes: `~/.config/git/config-ai` (Task 2)
- Produces: `~/.codex/config.toml` の `[shell_environment_policy.set]` 2 キー

- [ ] **Step 1: `dot_codex/modify_config.toml` の `sandbox_workspace_write.network_access` 行の直後に以下を追記**

```
{{- /* AI エージェント配下の git / gh を takuji31ai アカウントに切り替える */ -}}
{{- $cfg = $cfg | setValueAtPath "shell_environment_policy.set.GIT_CONFIG_GLOBAL" (printf "%s/.config/git/config-ai" .chezmoi.homeDir) -}}
{{- $cfg = $cfg | setValueAtPath "shell_environment_policy.set.GH_CONFIG_DIR" (printf "%s/.config/gh-ai" .chezmoi.homeDir) -}}
```

- [ ] **Step 2: apply して config.toml に反映されたことを確認**

```bash
chezmoi apply
python3 -c "
import tomllib, pathlib, os
cfg = tomllib.loads(pathlib.Path(os.path.expanduser('~/.codex/config.toml')).read_text())
print(cfg['shell_environment_policy']['set'])
print(cfg['model'])
"
```

Expected: 1 行目に `{'GIT_CONFIG_GLOBAL': '/Users/takuji/.config/git/config-ai', 'GH_CONFIG_DIR': '/Users/takuji/.config/gh-ai'}` (キー順は不問)、2 行目に `gpt-5.5` (既存設定が保持されている証拠)

- [ ] **Step 3: Commit**

```bash
git add dot_codex/modify_config.toml
git commit -m "feat: CodexにAIアカウント用環境変数を注入"
```

---

### Task 5: Cursor 用シェル断片 (zsh / fish / bash)

**Files:**
- Create: `dot_zsh/50-ai-agent.zsh`
- Create: `dot_config/fish/conf.d/50-ai-agent.fish`
- Modify: `dot_bashrc.tmpl:3` (XDG export の直後)

**Interfaces:**
- Consumes: `~/.config/git/config-ai` (Task 2)
- Produces: Cursor エージェントシェル (`CURSOR_AGENT` あり) でのみ `GIT_CONFIG_GLOBAL` / `GH_CONFIG_DIR` が export される

- [ ] **Step 1: `dot_zsh/50-ai-agent.zsh` を以下の内容で作成**

```zsh
# Cursor エージェントのシェルでは git/gh を takuji31ai アカウントに切り替える。
# Claude Code / Codex は各ツールの設定でネイティブに注入しているためここでは扱わない。
if [[ -n "$CURSOR_AGENT" ]]; then
    export GIT_CONFIG_GLOBAL="$HOME/.config/git/config-ai"
    export GH_CONFIG_DIR="$HOME/.config/gh-ai"
fi
```

- [ ] **Step 2: `dot_config/fish/conf.d/50-ai-agent.fish` を以下の内容で作成**

```fish
# Cursor エージェントのシェルでは git/gh を takuji31ai アカウントに切り替える。
# Claude Code / Codex は各ツールの設定でネイティブに注入しているためここでは扱わない。
if set -q CURSOR_AGENT
    set -gx GIT_CONFIG_GLOBAL $HOME/.config/git/config-ai
    set -gx GH_CONFIG_DIR $HOME/.config/gh-ai
end
```

- [ ] **Step 3: `dot_bashrc.tmpl` の `export XDG_CONFIG_HOME XDG_DATA_HOME` 行の直後に以下を追記**

```bash

# Cursor エージェントのシェルでは git/gh を takuji31ai アカウントに切り替える。
# Claude Code / Codex は各ツールの設定でネイティブに注入しているためここでは扱わない。
if [ -n "$CURSOR_AGENT" ]; then
  export GIT_CONFIG_GLOBAL="$HOME/.config/git/config-ai"
  export GH_CONFIG_DIR="$HOME/.config/gh-ai"
fi
```

- [ ] **Step 4: apply して 3 シェルで検出が効くことを確認**

```bash
chezmoi apply
env CURSOR_AGENT=1 fish -c 'echo $GIT_CONFIG_GLOBAL'
env CURSOR_AGENT=1 zsh -ic 'echo $GIT_CONFIG_GLOBAL'
env CURSOR_AGENT=1 bash -ic 'echo $GIT_CONFIG_GLOBAL'
```

Expected: 3 つとも `/Users/takuji/.config/git/config-ai`

- [ ] **Step 5: CURSOR_AGENT が無いシェルでは何も起きないことを確認**

```bash
env -u CURSOR_AGENT -u GIT_CONFIG_GLOBAL -u GH_CONFIG_DIR fish -c 'echo "[$GIT_CONFIG_GLOBAL]"'
env -u CURSOR_AGENT -u GIT_CONFIG_GLOBAL -u GH_CONFIG_DIR zsh -ic 'echo "[$GIT_CONFIG_GLOBAL]"'
env -u CURSOR_AGENT -u GIT_CONFIG_GLOBAL -u GH_CONFIG_DIR bash -ic 'echo "[$GIT_CONFIG_GLOBAL]"'
```

Expected: 3 つとも `[]` (空)

- [ ] **Step 6: Commit**

```bash
git add dot_zsh/50-ai-agent.zsh dot_config/fish/conf.d/50-ai-agent.fish dot_bashrc.tmpl
git commit -m "feat: CursorエージェントのシェルでAIアカウントに切り替える断片を追加"
```

---

### Task 6: AGENTS.md にアカウント分離の説明を追記

**Files:**
- Modify: `AGENTS.md` (「アーキテクチャに関する注意事項」セクションの末尾、「ローカルカスタマイズパターン」の直前)

**Interfaces:**
- Produces: 将来のエージェント・人間向けのドキュメント (コード依存なし)

- [ ] **Step 1: AGENTS.md の「ローカルカスタマイズパターン」セクションの直前に以下を追記**

```markdown
### AI エージェント用 GitHub アカウント分離

AI コーディングエージェント (Claude Code / Codex / Cursor) 配下の git / gh 操作は、専用アカウント
`takuji31ai` で実行される。仕組みは環境変数 2 つだけ:

- `GIT_CONFIG_GLOBAL=~/.config/git/config-ai`: `~/.gitconfig` を include しつつ user /
  署名鍵 (`~/.ssh/id_ed25519_ai`) / sshCommand を上書きする AI 用 git 設定
- `GH_CONFIG_DIR=~/.config/gh-ai`: gh の認証を takuji31ai に分離

注入点: Claude Code は `~/.claude/settings.json` の `env` (`private_dot_claude/modify_private_settings.json`)、
Codex は `shell_environment_policy.set` (`dot_codex/modify_config.toml`)、Cursor は `CURSOR_AGENT`
環境変数をシェル起動時に検出する断片 (`dot_zsh/50-ai-agent.zsh` / `conf.d/50-ai-agent.fish` /
`dot_bashrc.tmpl`)。ユーザー自身のシェルにはこの環境変数が無いため、手動の git / gh は従来通り
takuji31 で動く。

新しいマシンのセットアップ: `~/.ssh/id_ed25519_ai` を配置 (1Password から) し、
`GH_CONFIG_DIR=$HOME/.config/gh-ai gh auth login` を実行する。設計の詳細は
`docs/superpowers/specs/2026-07-04-ai-agent-git-account-design.md` を参照。
```

- [ ] **Step 2: Commit**

```bash
git add AGENTS.md
git commit -m "docs: AIエージェント用アカウント分離の説明をAGENTS.mdに追記"
```

---

### Task 7: gh-ai のログインと GitHub への鍵登録 (対話・ユーザー操作あり)

**Files:** なし (リポジトリ外の状態のみ変更)

**Interfaces:**
- Consumes: `~/.ssh/id_ed25519_ai.pub` (Task 1)
- Produces: `~/.config/gh-ai/` (takuji31ai の gh 認証)、GitHub 上の Authentication key + Signing key

このタスクはブラウザ認証を伴うため、ログインはユーザー自身がプロンプトで `!` プレフィックスを使って実行する。

- [ ] **Step 1: (ユーザー実行) takuji31ai として gh にログイン**

ブラウザ側で **takuji31ai のアカウント**でログインしてから認可すること (普段のブラウザセッションが takuji31 のままだと takuji31 に紐付いてしまう。シークレットウィンドウ推奨):

```
! GH_CONFIG_DIR=$HOME/.config/gh-ai gh auth login --hostname github.com --git-protocol ssh --web --scopes admin:public_key,admin:ssh_signing_key
```

途中で SSH 鍵のアップロードを聞かれたら `~/.ssh/id_ed25519_ai.pub` を選んでよい (その場合 Step 3 の authentication 登録はスキップ)。

- [ ] **Step 2: ログイン先が takuji31ai であることを確認**

```bash
GH_CONFIG_DIR=$HOME/.config/gh-ai gh api user --jq .login
```

Expected: `takuji31ai`。もし `takuji31` が表示されたら `GH_CONFIG_DIR=$HOME/.config/gh-ai gh auth logout` してブラウザのアカウントを切り替えて Step 1 からやり直す

- [ ] **Step 3: 公開鍵を Authentication key として登録 (Step 1 で未アップロードの場合のみ)**

```bash
GH_CONFIG_DIR=$HOME/.config/gh-ai gh ssh-key add ~/.ssh/id_ed25519_ai.pub --title "ai-shared-key" --type authentication
```

Expected: `✓ Public key added to your account`

- [ ] **Step 4: 公開鍵を Signing key として登録**

```bash
GH_CONFIG_DIR=$HOME/.config/gh-ai gh ssh-key add ~/.ssh/id_ed25519_ai.pub --title "ai-shared-key" --type signing
```

Expected: `✓ Public key added to your account`

- [ ] **Step 5: 鍵と SSH 認証を確認**

```bash
GH_CONFIG_DIR=$HOME/.config/gh-ai gh ssh-key list
ssh -i ~/.ssh/id_ed25519_ai -o IdentitiesOnly=yes -T git@github.com 2>&1 | head -n 1
```

Expected: 鍵リストに authentication と signing の 2 行 (title: ai-shared-key)。SSH 出力は `Hi takuji31ai! You've successfully authenticated, ...`

- [ ] **Step 6: (ユーザー操作) 秘密鍵 `~/.ssh/id_ed25519_ai` を 1Password 等に保存する**

他マシン展開時は `~/.ssh/id_ed25519_ai` (600) に配置 + このタスクの Step 1〜2 を実行するだけでよい。

---

### Task 8: エンドツーエンド検証

**Files:** なし (検証のみ。sandbox リポジトリは takuji31ai 上に作成)

**Interfaces:**
- Consumes: Task 1〜7 の全成果物

- [ ] **Step 1: AI 環境変数を再現した sandbox リポジトリで commit → push → 確認**

```bash
cd $(mktemp -d)
export GIT_CONFIG_GLOBAL=$HOME/.config/git/config-ai GH_CONFIG_DIR=$HOME/.config/gh-ai
gh repo create takuji31ai/ai-account-sandbox --private --clone
cd ai-account-sandbox
echo "AI account test" > README.md
git add README.md
git commit -m "test: AIアカウント分離の検証"
git log --show-signature -1
git push origin main
gh api repos/takuji31ai/ai-account-sandbox/commits --jq '.[0] | {author: .author.login, verified: .commit.verification.verified}'
```

Expected: `git log --show-signature` に `Good "git" signature for 289154972+takuji31ai@users.noreply.github.com` を含む。push 成功。最後の jq 出力が `{"author":"takuji31ai","verified":true}`

- [ ] **Step 2: 通常環境が無傷であることを確認**

```bash
cd /Users/takuji/.local/share/chezmoi
env -u GIT_CONFIG_GLOBAL -u GH_CONFIG_DIR git config user.email
env -u GIT_CONFIG_GLOBAL -u GH_CONFIG_DIR gh api user --jq .login
```

Expected: `takuji31@gmail.com` / `takuji31`

- [ ] **Step 3: (ユーザー確認) 新しい Claude Code セッションでの動作確認**

新しいターミナルで `claude` を起動し、次を依頼: 「`git config user.email` と `gh api user --jq .login` を実行して」

Expected: `289154972+takuji31ai@users.noreply.github.com` / `takuji31ai`

- [ ] **Step 4: (ユーザー確認) Codex での動作確認**

```
codex exec "git config user.email と gh api user --jq .login を実行して結果だけ出力して"
```

Expected: `289154972+takuji31ai@users.noreply.github.com` / `takuji31ai`

- [ ] **Step 5: (ユーザー確認) Cursor での動作確認**

1. Cursor のエージェントに「`echo $CURSOR_AGENT && git config user.email` を実行して」と依頼 → `CURSOR_AGENT` が非空、email が noreply アドレス
2. Cursor の統合ターミナルを手動で開き `echo "[$CURSOR_AGENT]" && git config user.email` → `[]` (空) かつ `takuji31@gmail.com`。もし `CURSOR_AGENT` が手動ターミナルにも入っていた場合は妥協ライン (統合ターミナルも AI アカウント扱い) として記録する
3. cursor-agent CLI でも同様に確認: `cursor-agent "git config user.email を実行して"`

- [ ] **Step 6: (ユーザー操作・任意) 後片付けと運用設定**

- 検証用 `takuji31ai/ai-account-sandbox` リポジトリは GitHub の Web UI から削除してよい (`gh repo delete` は追加スコープが必要なため Web 推奨)
- AI に触らせる private リポジトリへ takuji31ai を collaborator (write) として追加
- レビューを強制したいリポジトリで branch protection / ruleset の「Require a pull request before merging」+「Require approvals」を有効化

---

## Self-Review メモ

- スペック全要件との対応: config-ai (Task 2)、Claude 注入 (Task 3)、Codex 注入 (Task 4)、Cursor 3 シェル断片 (Task 5)、allowed_signers (Task 1)、手動手順 (Task 7)、検証 (Task 8)、ドキュメント (Task 6)。gh-ai の `git_protocol ssh` は Task 7 Step 1 の `--git-protocol ssh` で設定されるため個別ステップ不要
- スペックの「`~/.claude/settings.json` のキー順ソート + 整形」は Task 3 Step 2 の Expected に反映済み
- パーミッション 600 維持のため `modify_private_settings.json` を採用 (スペックのファイル名 `modify_settings.json` から実装上の理由で変更)
