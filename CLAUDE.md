# CLAUDE.md

このファイルは、Claude Code (claude.ai/code) がこのリポジトリのコードを扱う際のガイダンスを提供します。

## 概要

これはtakuji31の開発環境用の個人dotfilesリポジトリで、[chezmoi](https://www.chezmoi.io/)で管理されています。chezmoiはテンプレート機能とクロスプラットフォーム対応をサポートするdotfile管理ツールです。このリポジトリにはシェル設定、ターミナルマルチプレクサ設定、各種開発ツールの設定が含まれています。

## 主要なコマンド

### chezmoiの操作

```bash
# すべてのdotfilesをホームディレクトリに適用
chezmoi apply

# 適用せずに変更内容をプレビュー
chezmoi diff

# dotfileを編集（設定されたエディタで自動的に開く）
chezmoi edit ~/.zshrc

# 新しいファイルをchezmoi管理下に追加
chezmoi add ~/.newconfig

# リポジトリからdotfilesを更新
chezmoi update

# 現在の状態を検証
chezmoi verify
```

### 変更のテスト

このリポジトリは設定ファイルを含むため、従来的なビルド/テストコマンドはありません。変更をテストするには：

1. `chezmoi diff`で適用前に変更内容をプレビュー
2. `chezmoi apply`で変更を適用
3. 関連するシェル/アプリケーションを再起動して設定をテスト

## リポジトリ構造

### chezmoiのファイル命名規則

chezmoiは特殊なプレフィックスを使ってファイルの処理方法を決定します：

- `dot_`プレフィックス: `.`に変換（例: `dot_zshrc` → `~/.zshrc`）
- `.tmpl`サフィックス: Goテンプレートで処理されるテンプレートファイル
- `executable_`プレフィックス: 適用後に実行可能にされるファイル
- ディレクトリ名も同じルールに従う（例: `dot_config/` → `~/.config/`）

### 主要な設定エリア

**シェル設定:**
- `dot_zshrc`: 履歴、キーバインド、補完を含むメインのzsh設定
- `dot_zsh/`: 機能別に分割されたモジュラーなzsh設定（01_alias.zsh、02_function.zsh、03_prompt.zsh）
- `dot_config/fish/config.fish`: PATHセットアップと環境変数を含むfishシェル設定
- `dot_config/fish/functions/`: カスタムfishシェル関数

**ターミナルマルチプレクサ:**
- `dot_tmux.conf`: screen風のキーバインドを持つtmux設定（プレフィックス: Ctrl-Z）
- `dot_tmuxinator/`: tmuxセッション設定

**Git設定:**
- `dot_gitconfig.tmpl`: プラットフォーム固有のGPG署名を含むテンプレート化されたgit設定
  - macOSとWSLで1PasswordによるSSH署名を使用
  - DarwinとWSLで異なる`op-ssh-sign`パス

**ターミナルエミュレータ:**
- `dot_config/wezterm/`: WeZTermターミナルエミュレータ設定

**その他のツール:**
- `dot_peco/`: peco（インタラクティブフィルタリングツール）設定
- `.chezmoiignore`: chezmoi管理から除外するファイル

### プラットフォーム固有の処理

`dot_gitconfig.tmpl`はプラットフォーム検出の例を示しています：
- macOS固有の設定に`{{ if eq .chezmoi.os "darwin" }}`を使用
- Linux/WSL設定にWSL検出付きの`{{ if eq .chezmoi.os "linux" }}`を使用
- GPG署名は1Passwordの`op-ssh-sign`で設定され、プラットフォームごとに異なるパス

## アーキテクチャに関する注意事項

### シェル環境のセットアップ

このリポジトリは異なる哲学を持つ複数のシェルをサポートしています：

**zshセットアップ:**
- `~/.zsh/*.zsh`ファイルから読み込まれるモジュラー設定
- `~/.zshrc_local`によるローカルオーバーライド（追跡されない）
- tmux互換性のためのSSHエージェントソケット管理
- Volta（JavaScriptツールマネージャ）統合

**fishセットアップ:**
- PATH管理のための`add_path`関数の多用
- 利用可能なツール（nodenv、plenv、go等）に基づく条件付き環境セットアップ
- `~/.fishconfig_local.fish`によるローカルオーバーライド（追跡されない）
- Starshipプロンプト統合

### 開発ツール統合

設定には以下の自動セットアップが含まれています：
- Node.js: Voltaとレガシーなnodenvサポート
- Ruby: plenv、システムruby、Homebrewのruby
- Go: GOROOT/GOPATH設定
- Android SDK: パスと環境変数のセットアップ
- VS Code: デフォルトエディタおよびdiffツールとして設定

### ローカルカスタマイズパターン

両シェルともリポジトリで追跡されないローカルカスタマイズファイルをサポートしています：
- zsh用の`~/.zshrc_local`
- fish用の`~/.fishconfig_local.fish`
- git用の`~/.gitconfig.local`

ユーザー固有の変更や機密データを含む変更を行う場合は、追跡される設定ではなく、これらのローカルファイルに追加してください。
