# AI エージェント用 Git / gh アカウント分離 設計

日付: 2026-07-04
ステータス: 承認済み

## 背景と目的

AI コーディングエージェント (Claude Code / Codex / Cursor) が行う git / gh 操作を、普段使いの
`takuji31` とは別の専用アカウント `takuji31ai` (GitHub ID: 289154972) で実行させる。

目的:

1. **AI 自身への可視化**: コミット履歴・PR の author を見れば AI が書いた変更だと (人間にも AI にも) 分かる
2. **人間レビューの強制**: PR 作成者が takuji31ai になることで、branch protection の
   「Require approvals」下では takuji31 による承認が必須になる (self-approve 不可)

## 要件

- シェルの関数・エイリアス・abbr による実装は不可。`claude` / `codex` / `cursor-agent` コマンドは
  そのまま使えること
- ユーザーが普段のシェルから実行する git / gh は従来通り takuji31 で動くこと (特殊な操作不要)
- 設定ファイルの分離は可。全マシン (macOS / Linux / WSL / Windows) で使えるよう chezmoi で配布
- AI コミットも SSH 鍵署名する (専用鍵、GitHub で Verified になる)
- 専用鍵は 1 本を全マシンで共有 (秘密鍵の配布はユーザーが 1Password 等で行う。chezmoi には入れない)

## アーキテクチャ

切り替えの本体は環境変数 2 つ。git / gh のバイナリにも通常設定にも一切手を入れない。
エージェント配下のプロセスにだけこの環境変数が乗る。

| 環境変数 | 値 | 効果 |
|---|---|---|
| `GIT_CONFIG_GLOBAL` | `~/.config/git/config-ai` | git のグローバル設定を AI 用に差し替え |
| `GH_CONFIG_DIR` | `~/.config/gh-ai` | gh の認証・設定ディレクトリを AI 用に分離 |

### 注入方法 (ツール別)

| ツール | 注入点 | 備考 |
|---|---|---|
| Claude Code | `~/.claude/settings.json` の `env` | chezmoi の modify テンプレートで 2 キーだけマージ。シェル非依存で確実 |
| Codex | `~/.codex/config.toml` の `shell_environment_policy.set` | 既存 `dot_codex/modify_config.toml` に追記 |
| Cursor (IDE / CLI) | シェル起動時に `CURSOR_AGENT` を検出して export | zsh / fish / bash に同一の極小断片を配置。手動で開く統合ターミナルには `CURSOR_AGENT` が無いため影響しない |

Cursor のエージェントシェルは `CURSOR_AGENT` 環境変数を持つ (公式ドキュメントが案内する検出方法)。
エージェントが使うシェルはバージョンにより fish / bash 等に揺れるため、シェルを固定するのではなく
3 シェル全部に断片を置く (各 3〜4 行)。

### `~/.config/git/config-ai` の内容

```gitconfig
[include]
    path = ~/.gitconfig          ; alias / delta / lfs などを全部引き継ぐ
[user]
    name = takuji31ai
    email = 289154972+takuji31ai@users.noreply.github.com
    signingkey = ~/.ssh/id_ed25519_ai.pub
[github]
    user = takuji31ai
[core]
    sshCommand = ssh -i ~/.ssh/id_ed25519_ai -o IdentitiesOnly=yes   ; Windows は ssh.exe
[credential "https://github.com"]
    helper =                     ; keychain 等をリセット (本人資格情報の誤用防止)
    helper = !gh auth git-credential   ; GH_CONFIG_DIR 経由で takuji31ai の token を使う
```

- include が先頭なので、後続の上書きが常に勝つ (`~/.gitconfig.local` 込み)
- SSH リモートは専用鍵で push。HTTPS リモートでも gh-ai の token に落ちる
- 署名鍵も専用鍵なので、AI コミットは takuji31ai の署名として Verified になる

## ファイル構成 (chezmoi ソース)

新規:

| ソース | 適用先 |
|---|---|
| `dot_config/git/config-ai.tmpl` | `~/.config/git/config-ai` |
| `private_dot_claude/modify_settings.json` | `~/.claude/settings.json` (modify テンプレート) |
| `dot_zsh/50-ai-agent.zsh` | `~/.zsh/50-ai-agent.zsh` |
| `dot_config/fish/conf.d/50-ai-agent.fish` | `~/.config/fish/conf.d/50-ai-agent.fish` |

変更:

- `dot_codex/modify_config.toml`: `shell_environment_policy.set` に 2 キー追記
- `dot_bashrc.tmpl`: `CURSOR_AGENT` 検出を追記
- `dot_config/git/allowed_signers`: AI 鍵の公開鍵を追記 (principal は noreply メール)

シェル断片の内容 (fish 版。zsh / bash も同等):

```fish
# Cursor エージェントのシェルでは git/gh を takuji31ai に切り替える
# (Claude Code / Codex は各ツールの設定でネイティブに注入するためここでは扱わない)
if set -q CURSOR_AGENT
    set -gx GIT_CONFIG_GLOBAL $HOME/.config/git/config-ai
    set -gx GH_CONFIG_DIR $HOME/.config/gh-ai
end
```

注意点:

- `~/.claude/settings.json` が chezmoi 管理 (modify テンプレート) に入る。ローカルの変更は保持
  されるが、apply のたびにキー順ソート + 整形される
- nushell は対象外 (Cursor で使わない前提。必要になったら同じ断片を追加)

## 手動手順 (chezmoi 外)

1 回だけ:

1. 鍵生成: `ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519_ai -N "" -C "takuji31ai"`
2. 秘密鍵を 1Password 等に保存し、各マシンの `~/.ssh/id_ed25519_ai` に配置
3. GitHub (takuji31ai でログイン) に公開鍵を **Authentication key と Signing key の両方**として登録
4. AI に触らせる private リポジトリに takuji31ai を collaborator (write) として追加
5. レビューを強制したいリポジトリで branch protection / ruleset の「Require a pull request before
   merging」+「Require approvals」を有効化

マシンごと:

1. `~/.ssh/id_ed25519_ai` を配置 (パーミッション 600)
2. `GH_CONFIG_DIR=$HOME/.config/gh-ai gh auth login` で takuji31ai として認証し、
   `GH_CONFIG_DIR=$HOME/.config/gh-ai gh config set git_protocol ssh` を設定

## エラー時の挙動 (fail-closed)

- 鍵未配置のマシン: 署名必須 (`commit.gpgsign=true` を継承) のため commit がエラーで止まる
- gh-ai 未ログイン: gh が認証エラーで止まり、login を促される
- いずれも「誤って本人アカウントで実行される」方向には倒れない

## 検証

1. 素の環境変数で: `GIT_CONFIG_GLOBAL=~/.config/git/config-ai git config user.email` → noreply アドレス
2. Claude Code 新セッション / `codex exec` / Cursor エージェントそれぞれで
   `git config user.email` → noreply、`gh api user --jq .login` → `takuji31ai`
3. 手動シェル (通常ターミナル + Cursor 統合ターミナル) で同コマンド → 本人のまま。
   Cursor 統合ターミナルに `CURSOR_AGENT` が漏れていないかを実機確認 (漏れるバージョンなら
   妥協ラインとして報告した上で許容)
4. エージェントにテストコミットを 1 つ作らせ、`git log --show-signature` で AI 鍵の署名を確認、
   GitHub 上で Verified バッジ + takuji31ai アイコンを確認

## 却下した代替案

- **全部シェル検出で統一** (`CLAUDECODE` 等も見る): Claude Code の Bash ツールや Codex はユーザー
  シェルの rc を経由せずコマンドを実行することがあり、取りこぼしが出る
- **全部ネイティブ注入**: Cursor IDE は `terminal.integrated.env` になり手動の統合ターミナルまで
  AI アカウント化する。cursor-agent CLI には env 注入設定が無く PATH シムが必要になり
  「コマンドそのまま」の要件から外れる
- **エージェントのシェルを zsh に固定して zsh だけに注入**: Cursor のエージェントシェル選択は
  バージョン・OS で挙動が揺れており (defaultProfile 無視・bash 強制などの報告あり)、固定が
  壊れた場合に「本人アカウントで AI がコミットする」事故側に倒れるため不採用
- **マシンごとに専用鍵を生成**: GitHub への鍵登録と allowed_signers 追記がマシン台数分必要になる。
  ユーザーの希望により 1 本共有を採用
