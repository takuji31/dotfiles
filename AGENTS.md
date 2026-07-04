# AGENTS.md

このファイルは、コーディングエージェントがこのリポジトリのコードを扱う際のガイダンスを提供します。

## 概要

これは takuji31 の開発環境用の個人 dotfiles リポジトリで、[chezmoi](https://www.chezmoi.io/) で管理されています。chezmoi はテンプレート機能とクロスプラットフォーム対応をサポートする dotfile 管理ツールです。macOS / Linux / WSL / Windows を対象に、シェル (zsh / fish / bash / nushell) 設定、ターミナルマルチプレクサ設定、エディタ・ターミナルエミュレータ設定、各種 CLI ツール設定をまとめて管理しています。

## 主要なコマンド

### chezmoi の操作

```bash
# すべての dotfiles をホームディレクトリに適用
chezmoi apply

# 適用せずに変更内容をプレビュー
chezmoi diff

# dotfile を編集（設定されたエディタで自動的に開く）
chezmoi edit ~/.zshrc

# 新しいファイルを chezmoi 管理下に追加
chezmoi add ~/.newconfig

# ホーム側で変更されたファイルをリポジトリに取り込む
chezmoi re-add ~/.zshrc

# リポジトリから dotfiles を更新
chezmoi update

# 現在の状態を検証
chezmoi verify
```

### 変更のテスト

このリポジトリは設定ファイル中心なので、従来的なビルド/テストコマンドはありません。変更をテストする手順:

1. `chezmoi diff` で適用前に変更内容をプレビュー
2. `chezmoi apply` で変更を適用
3. 関連するシェル/アプリケーションを再起動して設定をテスト

## リポジトリ構造

### chezmoi のファイル命名規則

chezmoi は特殊なプレフィックス/サフィックスでファイルの処理方法を決定します:

- `dot_` プレフィックス: `.` に変換（例: `dot_zshrc` → `~/.zshrc`）
- `private_` プレフィックス: パーミッションを 0600 系に絞る（例: `private_dot_claude/`）
- `readonly_` プレフィックス: 書き込み権限を落とす
- `executable_` プレフィックス: 適用後に実行可能にする
- `symlink_` プレフィックス: ファイル内容をターゲットとするシンボリックリンクを作成
- `.tmpl` サフィックス: Go テンプレートで処理されるテンプレートファイル
- ディレクトリ名も同じルールに従う（例: `dot_config/` → `~/.config/`）

### 主要な設定エリア

**シェル設定 (zsh):**
- `dot_zshenv`: PATH/ロケール/Homebrew shellenv などログインシェル全体に効かせたい環境変数
- `dot_zshrc.tmpl`: 履歴・キーバインド・補完など対話シェルの基本設定。末尾で `$HOME/.zsh/*.zsh` を順次読み込む
- `dot_zsh/`: 番号プレフィックス + 機能名でモジュール化された zsh 断片
  - `00-mise.zsh`: mise 有効化
  - `01-path.zsh.tmpl`: プラットフォーム固有の PATH 追加
  - `05-env.zsh`: EDITOR / PAGER の自動選択
  - `10-go.zsh`: GOPATH 等
  - `20-alias.zsh`: 共通エイリアス
  - `30-modern-cli.zsh`: eza / bat / duf / dust / procs / btop / lazygit などモダン CLI のラッパー（未導入時は元コマンドにフォールバック）
  - `40-helpers.zsh`: 補助関数
  - `50-*.zsh`: 個別ツール統合 (bat / fzf / git-spice / navi / ripgrep / zellij / zoxide)
  - `90-atuin.zsh`: atuin 履歴
  - `95-prompt.zsh`: starship プロンプト

**シェル設定 (fish):**
- `dot_config/fish/config.fish.tmpl`: ロケール・EDITOR・PAGER・starship 初期化・ローカル設定読み込み
- `dot_config/fish/conf.d/`: 番号プレフィックス + 機能名でモジュール化された fish 断片 (zsh と対になる構成)
- `dot_config/fish/functions/`: カスタム関数 (ls / la / ll / lt / cat などモダン CLI ラッパー、`wt.fish.tmpl`、`cleanup-branches.fish`、`claude-work.fish` など)
- `dot_config/fish/completions/`: 静的補完スクリプト (`git-spice.fish` など、後述の落とし穴対策)

**シェル設定 (bash):**
- `dot_bash_profile.tmpl`: ログイン用。Homebrew / mise / PATH / EDITOR / PAGER などを設定し、最後に `.bashrc` を読み込む
- `dot_bashrc.tmpl`: 対話シェル用

**ターミナルマルチプレクサ:**
- `dot_tmux.conf`: screen 風のキーバインドを持つ tmux 設定（プレフィックス: Ctrl-Z）
- `dot_tmuxinator/`: tmuxinator セッション定義 (`circle-manager.yml` など)
- `.chezmoiexternal.toml`: tmux プラグイン (`tpm`, `tmux-powerkit`) を `~/.tmux/plugins/` 配下に shallow clone で取得

**Git 設定:**
- `dot_gitconfig.tmpl`: テンプレート化された git 設定
  - SSH 鍵 (`~/.ssh/id_ed25519.pub`) による署名 (`gpg.format = ssh`, `commit.gpgsign = true`)
  - `~/.config/git/allowed_signers` で署名検証
  - Windows では `ssh-keygen.exe` を `gpg.ssh.program` に指定
  - WSL は Linux 分岐で個別に署名鍵を設定
  - `delta` をページャ・差分表示に利用、`~/.gitconfig.local` を最後に include
- `dot_config/git/allowed_signers`: SSH 署名の許可リスト

**ターミナルエミュレータ / GUI:**
- `dot_config/wezterm/`: WezTerm 設定
- `dot_config/ghostty/`: Ghostty 設定
- `dot_config/raycast/`: Raycast 設定

**エディタ / ツール:**
- `dot_config/nvim/`: Neovim 設定
- `dot_config/mise/config.toml`: mise によるツールバージョン管理
- `dot_config/sheldon/plugins.toml`: zsh プラグインマネージャ sheldon の設定
- `dot_config/zellij/`, `dot_config/yazi/`, `dot_config/nushell/`: それぞれのツール設定
- `dot_config/worktrunk/config.toml`: worktrunk (`wt`) の設定
- `dot_config/ccstatusline/`: Claude Code 用ステータスライン設定

**AI コーディングツール:**
- `private_dot_claude/skills/`: Claude Code の skill 群 (`wt-worktrees` など)
- `private_dot_claude/modify_private_settings.json`: `~/.claude/settings.json` への modify テンプレート (AI アカウント用環境変数を注入)
- `.claude/settings.json`: このリポジトリ向けの Claude Code プロジェクト設定
- `private_dot_codex/modify_config.toml`, `private_dot_codex/pets/`: Codex CLI 設定とペット定義

**その他のツール:**
- `dot_peco/`: peco (インタラクティブフィルタリングツール) 設定
- `dot_ripgreprc`: ripgrep デフォルトオプション
- `.chezmoiignore`: chezmoi 管理から除外するファイル (`*.md` や非 Windows での `AppData/` `OneDrive/` など)

### プラットフォーム固有の処理

テンプレート (`.tmpl`) で `.chezmoi.os` を分岐し、同じ実体ファイルからプラットフォーム別の出力を生成しています:

- `{{ if eq .chezmoi.os "darwin" }}`: macOS 固有（Homebrew on `/opt/homebrew`、Android SDK、google-cloud-sdk など）
- `{{ if eq .chezmoi.os "linux" }}` + `.chezmoi.kernel.osrelease` の `microsoft` 判定: WSL 固有
- `{{ if eq .chezmoi.os "windows" }}`: Windows 固有（`git-wt`、`AppData/Local/Microsoft/WinGet/Links` PATH、ssh-keygen.exe など）

## 作業ルール

- 設定ファイルを変更したら自動で `chezmoi apply` を実行する（毎回確認不要）
- `chezmoi apply` で競合が発生した場合、`--force` で上書きしない。まず `chezmoi diff` で差分を確認し、ホーム側が正しければ `chezmoi re-add <ファイル>` で取り込む
- OS ごとに設定ファイルのパスだけが違い、内容は同一でよい場合は、同じ内容のファイルをコピーして複数管理しない。共通の実体ファイルを 1 つ置き、OS 固有のパス側は `symlink_` で管理する
- zsh / fish に同じツール統合を追加するときは、`dot_zsh/50-*.zsh` と `dot_config/fish/conf.d/50-*.fish` の両方に対になる断片を置く

## 既知の落とし穴

### fish conf.d の subprocess が stdin を食う問題

tmuxinator から起動した fish に対して tmux `send-keys` で送られたコマンドが実行されない事象が起きた場合、**fish の起動中に走る subprocess が pty の stdin に溜まっていた入力を吸い込んでいる**ことを疑う。

- 典型例: `git-spice shell completion fish | source`
  - git-spice は起動時に OSC 11 (背景色クエリ) / DA1 (Device Attributes) を書き込み、端末からの応答を stdin から読もうとする
  - tmuxinator が事前に `send-keys` で pty に流し込んだ `claude\n` 等を応答と誤認して消費する
  - 結果: fish のプロンプトは出るがコマンドが実行されない
- fish 4.x の挙動・tmux 3.6 の挙動・mise のインストールチェックはいずれも無罪 (検証済み)
- **対策**: 動的生成していた完了スクリプトを `dot_config/fish/completions/` に静的ファイルとして置き、conf.d からは `alias` 定義のみ残す (`git-spice` は実際この方針で対応済み)
- **予防**: `cmd | source` 系を conf.d に追加する際は `cmd < /dev/null | source` にして subprocess の stdin を切断する。これで将来どんなツールが入ってきても同種の事故を防げる
  - zsh 側も同様で、`dot_zsh/50-git-spice.zsh` では `eval "$(git-spice shell completion zsh </dev/null)"` のように stdin を切っている
- 検証方法: pty に pre-load したバイト列を subprocess が吸い込むかを Python `pty.fork()` で再現できる

## アーキテクチャに関する注意事項

### シェル環境のセットアップ

複数シェルを並行サポートしていますが、ツール統合の方針は揃えています:

**共通方針:**
- 言語/ツールのバージョン管理は **mise** に統一 (Volta / nodenv / plenv 等は使っていない)
- プロンプトは **starship**
- 履歴は **atuin**
- モダン CLI (eza / bat / duf / dust / procs / btop / lazygit など) は「インストール済みなら使う、未導入なら元コマンドにフォールバック」のラッパーを zsh/fish 双方で定義
- PATH は各シェルで `$HOME/.local/bin`, `$HOME/local/bin`, `$HOME/bin`, Homebrew shellenv を共通で先頭に追加

**zsh セットアップ:**
- `dot_zshenv` がログイン全体に効く基本環境を設定し、`dot_zshrc.tmpl` が対話シェル設定を行う
- `~/.zsh/*.zsh` を順番に読み込むモジュラー構成 (番号順)
- tmux 互換のための SSH エージェントソケット管理を `dot_zshrc.tmpl` 内で実施
- worktrunk (`wt`) のシェル初期化を末尾で読み込み

**fish セットアップ:**
- PATH は `fish_add_path` で管理、ツール毎の有効化は `conf.d/` 配下に分割
- `command -q` で各ツールの存在チェックを行い、条件付きで有効化

**bash セットアップ:**
- 主にスクリプト互換と非対話シェル用途。`dot_bash_profile.tmpl` で mise / Homebrew / PATH / EDITOR / PAGER をまとめて設定

### AI エージェント用 GitHub アカウント分離

AI コーディングエージェント (Claude Code / Codex / Cursor) 配下の git / gh 操作は、専用アカウント
`takuji31ai` で実行される。仕組みは環境変数 2 つだけ:

- `GIT_CONFIG_GLOBAL=~/.config/git/config-ai`: `~/.gitconfig` を include しつつ user /
  署名鍵 (`~/.ssh/id_ed25519_ai`) / sshCommand を上書きする AI 用 git 設定
- `GH_CONFIG_DIR=~/.config/gh-ai`: gh の認証を takuji31ai に分離

注入点: Claude Code は `~/.claude/settings.json` の `env` (`private_dot_claude/modify_private_settings.json`)、
Codex は `shell_environment_policy.set` (`private_dot_codex/modify_config.toml`)、Cursor は `CURSOR_AGENT`
環境変数をシェル起動時に検出する断片 (`dot_zsh/50-ai-agent.zsh` / `conf.d/50-ai-agent.fish` /
`dot_bashrc.tmpl`)。ユーザー自身のシェルにはこの環境変数が無いため、手動の git / gh は従来通り
takuji31 で動く。

新しいマシンのセットアップ: `~/.ssh/id_ed25519_ai` を配置 (1Password から) し、
`GH_CONFIG_DIR=$HOME/.config/gh-ai gh auth login` を実行する。設計の詳細は
`docs/superpowers/specs/2026-07-04-ai-agent-git-account-design.md` を参照。

### ローカルカスタマイズパターン

シェル/git ともリポジトリで追跡されないローカルカスタマイズファイルをサポートしています:

- zsh 環境変数: `~/.zshenv_local`
- zsh 対話設定: `~/.zshrc_local`
- fish: `~/.fishconfig_local.fish`
- git: `~/.gitconfig.local`

ユーザー固有の変更や機密データを含む変更は、追跡される設定ではなくこれらのローカルファイルに追加してください。
