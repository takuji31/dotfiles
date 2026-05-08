# Zellij 設定ガイド (takuji31 dotfiles版)

> 対象ファイル
> - `~/.config/zellij/config.kdl` — メイン設定 + キーバインド
> - `~/.config/zellij/layouts/default.kdl` — 起動時レイアウト
> - `~/.config/zellij/layouts/android.kdl` / `web.kdl` — プロジェクト用テンプレート
> - `.chezmoitemplates/zellij-tab-template` — 共通タブ枠 (zjstatus 入り)
> - `~/.config/fish/conf.d/50-zellij.fish` — fish シェルの便利関数

## まずは Zellij の超基礎

Zellij は「**ターミナルマルチプレクサ**」で、画面分割・タブ・セッション保存などを提供します。tmux の親戚と思ってください。

操作は**モード切り替え式**。`vim` と同じく現在のモードによってキーの意味が変わります。

| モード | 役割 |
|---|---|
| `locked` 🔒 | 何もせずキーを下のシェル/アプリにそのまま流す。**この dotfile では起動時はこのモード** |
| `normal` | 各操作モードへ入る玄関口 |
| `pane` | ペイン (画面分割) 操作 |
| `tab` | タブ操作 |
| `resize` | ペインのサイズ変更 |
| `move` | ペインの位置入れ替え |
| `scroll` / `search` / `entersearch` | 履歴スクロールと検索 |
| `session` | セッション/プラグイン関係 |
| `renametab` / `renamepane` | リネーム入力中 |

> 💡 ステータスバー (zjstatus) の左端に**現在のモード**が常時表示されます (`LOCKED` / `NORMAL` / `PANE` …)。迷ったらまず左下を見る。

---

## グローバル設定 (`config.kdl` の末尾)

| 設定 | 値 | 解説 |
|---|---|---|
| `theme` | `catppuccin-latte` | 起動時のテーマ。CSI 2031 非対応端末 (現状の WezTerm 等) ではこの値で固定起動 |
| `theme_dark` | `catppuccin-macchiato` | `ToggleTheme` / OS Dark 通知 (CSI 2031) で適用 |
| `theme_light` | `catppuccin-latte` | `ToggleTheme` / OS Light 通知 (CSI 2031) で適用 |
| `default_mode` | `locked` | **起動直後はキーをスルー**。ターミナルとして普通に使える状態 |
| `default_shell` | `fish` | 新規ペインで起動するシェル |
| `default_layout` | `default` | 起動時に読まれるレイアウト名 |
| `scroll_buffer_size` | `50000` | 各ペインで遡れる行数 (デフォルト 10000 を増量) |
| `serialize_pane_viewport` | `true` | セッション復元時に画面の見た目も保存 |
| `scrollback_lines_to_serialize` | `10000` | 復元用に残すスクロールバック行数 |
| `web_client.font` | `monospace` | Web クライアント用のフォント指定 |
| `keybinds clear-defaults` | `true` | **デフォルトキーバインドを全て破棄してこのファイルだけが効く** |

コメントアウトされている主要オプション (使うときの参考):
- `mouse_mode` (デフォルト true) — マウス操作の有効化
- `pane_frames` (true) — ペイン枠の表示
- `copy_command` — `pbcopy` / `wl-copy` / `xclip` 等にパイプ
- `auto_layout` (true) — ペインを自動レイアウト
- `session_serialization` (true) — セッションの永続化
- `web_server` / `web_sharing` — ブラウザでセッションを共有する機能
- `stacked_resize` (true) — リサイズ時にペインを積む

---

## プラグイン定義 (`plugins { ... }`)

| エイリアス | 実体 | 用途 |
|---|---|---|
| `about` | `zellij:about` | バージョン情報 |
| `compact-bar` | `zellij:compact-bar` | コンパクトなタブバー |
| `configuration` | `zellij:configuration` | 設定 GUI |
| `filepicker` | `zellij:strider` (`cwd "/"`) | ファイル選択を `/` ルートから |
| `plugin-manager` | `zellij:plugin-manager` | プラグイン一覧 |
| `session-manager` | `zellij:session-manager` | セッション管理 |
| `status-bar` | `zellij:status-bar` | 標準ステータスバー |
| `strider` | `zellij:strider` | ファイラ |
| `tab-bar` | `zellij:tab-bar` | タブバー |
| `welcome-screen` | `zellij:session-manager` (`welcome_screen true`) | 起動時ようこそ画面 |

`load_plugins {}` は空 (起動時自動ロードのプラグインなし)。

---

## キーバインド一覧

> 表記
> - 「**🔒 に戻る**」= 操作後に自動で `locked` モードへ戻る (=入力がそのままシェルに流れる安全状態に復帰)
> - キーが大文字 (例: `H`) は Shift つき

### A. どのモードでも (locked 含む) 効くショートカット

`shared_among "normal" "locked"` で定義。**普段使いの主役**。

| キー | 動作 |
|---|---|
| `Alt ←` / `→` | フォーカスを左/右に移動 (端まで行ったら隣のタブへ) |
| `Alt ↑` / `↓` | フォーカスを上/下のペインへ |
| `Alt h` / `Alt i` | `Alt ←` / `→` と同じ (vim 風) |
| `Alt e` / `Alt n` | `Alt ↑` / `↓` と同じ |
| `Alt +` / `Alt =` | ペイン拡大 |
| `Alt -` | ペイン縮小 |
| `Alt ,` / `Alt .` | タブを左/右に移動 |
| `Alt 1`〜`Alt 9` | 指定番号のタブへジャンプ → 🔒 に戻る |
| `Alt a` | 新しいペインを作成 |
| `Alt f` | フローティングペイン表示切替 |
| `Alt m` | **monocle プラグイン**起動 (キオスクモード)。1ペイン全画面風 |
| `Alt p` | 現在ペインをグループに追加/解除 |
| `Alt Shift p` | グループマーキングのトグル |

### B. 「ロック⇄通常」のトグル

| キー | 動作 |
|---|---|
| `Ctrl d` | locked⇄normal の往復切替 (locked 時は normal に、それ以外は locked に戻る) |
| `Ctrl q` | Zellij を終了 |
| `Esc` | ほぼ全モードから locked へ戻る |
| `Enter` | 入力系を除き locked に戻る |

> ⚠️ `Ctrl g` (本家の標準キー) は **unbind されている**ので効きません。

### C. モード入口 (normal 等から)

| キー | 入るモード |
|---|---|
| `p` | pane モード |
| `t` | tab モード |
| `r` | resize モード |
| `s` | scroll モード |
| `m` | move モード |
| `o` | session モード |

### D. PANE モード (`p` で入る)

| キー | 動作 |
|---|---|
| `←` / `↓` / `↑` / `→` | フォーカス移動 |
| `h` `n` `e` `i` | フォーカス移動 (vim 風: 左/下/上/右) |
| `Tab` | 次のペインへフォーカス |
| `a` | 新規ペイン → 🔒 |
| `d` | 下に新規ペイン → 🔒 |
| `r` | 右に新規ペイン → 🔒 |
| `s` | スタック (積み重ね) で新規ペイン → 🔒 |
| `b` | ペインをフロート⇄通常切替 → 🔒 |
| `f` | 全画面切替 → 🔒 |
| `g` | フロートペインのピン留め → 🔒 |
| `w` | フロートペイン全体の表示切替 → 🔒 |
| `x` | 現在ペインを閉じる → 🔒 |
| `z` | ペイン枠の表示切替 → 🔒 |
| `c` | ペインのリネーム入力へ |
| `p` | normal に戻る |

### E. TAB モード (`t` で入る)

| キー | 動作 |
|---|---|
| `←` / `↑` `h` `e` | 前のタブ |
| `→` / `↓` `i` `n` | 次のタブ |
| `1`〜`9` | 番号タブへジャンプ → 🔒 |
| `a` | 新規タブ → 🔒 |
| `b` | 現在ペインを切り出して別タブに → 🔒 |
| `[` / `]` | ペインを左/右の隣タブへ移動 → 🔒 |
| `r` | タブのリネーム入力へ |
| `s` | タブ全体の同期入力 ON/OFF → 🔒 |
| `x` | タブを閉じる → 🔒 |
| `Tab` | 直前のタブと往復 |
| `t` | normal に戻る |

### F. RESIZE モード (`r` で入る)

| キー | 動作 |
|---|---|
| `+` / `=` | 全方向に拡大 |
| `-` | 全方向に縮小 |
| `←` `↓` `↑` `→` | 各方向に拡大 |
| `h` `n` `e` `i` | 各方向に拡大 (vim 風: 左/下/上/右) |
| `H` `N` `E` `I` | 各方向に縮小 (Shift つき) |
| `r` | normal に戻る |

### G. MOVE モード (`m` で入る) — ペインの位置入れ替え

| キー | 動作 |
|---|---|
| `←` `↓` `↑` `→` | 各方向にペインを動かす |
| `h` `n` `e` `i` | 同上 (vim 風) |
| `Tab` | 次のペイン位置へローテーション |
| `p` | 逆方向にローテーション |
| `m` | normal に戻る |

### H. SCROLL モード (`s` で入る) — 履歴を見る

| キー | 動作 |
|---|---|
| `↑` / `↓` `e` / `n` | 1 行ずつスクロール |
| `←` / `→` `h` / `i` | 1 ページずつ |
| `PageUp` / `PageDown` | 1 ページ |
| `Ctrl b` / `Ctrl f` | 1 ページ |
| `u` / `d` | 半ページ |
| `Ctrl c` | 末尾(現在)に戻る → 🔒 |
| `v` | スクロールバックをエディタで開く → 🔒 |
| `f` | 検索入力へ (entersearch) |
| `Alt h/i` | フォーカスを左/右タブに移動 → 🔒 |
| `Alt e/n` | フォーカスを上/下ペインに → 🔒 |
| `s` | normal に戻る |

### I. SEARCH / ENTERSEARCH モード

`entersearch`: 検索文字列を入力する状態
- `Enter` で検索確定 → search モード
- `Ctrl c` / `Esc` で scroll に戻る

`search`: 検索結果を移動するモード
- `e` 上へ次の一致 / `n` 下へ次の一致
- `c` 大文字小文字区別の切替
- `o` 単語単位の切替
- `w` 折返し検索の切替
- (scroll と同じスクロール系キーも使える)

### J. SESSION モード (`o` で入る)

| キー | 動作 |
|---|---|
| `a` | About プラグインをフロート表示 → 🔒 |
| `c` | configuration プラグインをフロート表示 → 🔒 |
| `d` | セッションから**デタッチ** (再接続用に裏で残る) |
| `p` | plugin-manager を表示 → 🔒 |
| `s` | zellij:share プラグインを表示 → 🔒 |
| `w` | session-manager を表示 → 🔒 |
| `o` | normal に戻る |

### K. リネーム入力中

- `renametab` / `renamepane`: `Esc` で取り消して元のモードへ戻る、`Ctrl c` で 🔒 に戻る

---

## レイアウト (タブのテンプレート)

### `default.kdl.tmpl`
chezmoi が共通テンプレート (`zellij-tab-template`) を展開し、その後ろに **タブ 1 つ**を置く最小構成。実体としてはこんな感じになります:

```kdl
layout {
    default_tab_template {
        pane size=1 borderless=true { plugin location="tab-bar" }
        children
        pane size=1 borderless=true { plugin location="<zjstatus>.wasm" { ... } }
        pane size=1 borderless=true { plugin location="status-bar" }
    }
    tab
}
```

つまり**全タブに共通して**:
1. 上端に **タブバー** (1 行)
2. 真ん中に実際の作業領域 (`children` の位置)
3. 下に **zjstatus** カスタムステータスバー (1 行)
4. さらに下に標準 **status-bar** (1 行)

### zjstatus の中身 (`.chezmoitemplates/zellij-tab-template`)

- 左: 現在のモード + セッション名 (青字 太字)
- 右: Git ブランチ + 日時
- モード別の色分け
  - `NORMAL` 緑 / `LOCKED` 赤 / `PANE` `TAB` 青 / `RESIZE` `MOVE` `RENAME` 黄 / `SCROLL` `SESSION` `SEARCH` マゼンタ
- Git ブランチ: `git rev-parse --abbrev-ref HEAD` を 10 秒間隔で取得
- 日時: `%Y-%m-%d %H:%M` を **Asia/Tokyo** で表示

### プロジェクト用テンプレート

#### `android.kdl` — Android 開発用
| タブ | 起動コマンド |
|---|---|
| `logcat` (フォーカス) | `adb logcat` |
| `git` | `lazygit` |
| `claude` | `claude` (CLI) |
| `edit` / `gradle` / `shell` | 空ペイン |

#### `web.kdl` — Web フロント開発用
| タブ | 起動コマンド |
|---|---|
| `dev` (フォーカス) | `pnpm run dev` |
| `git` | `lazygit` |
| `claude` | `claude` |
| `edit` / `shell` | 空ペイン |

`_template.kdl.tmpl` は単に共通タブテンプレートを呼ぶだけ (プロジェクトレイアウトと組み合わせるための基盤)。

---

## fish シェル統合 (`50-zellij.fish`)

`zellij` がインストールされていれば自動で読み込まれます。

### エイリアス

| エイリアス | 展開先 |
|---|---|
| `zj` | `zellij` |
| `za` | `zellij attach` (既存セッションに再接続) |
| `zl` | `zellij list-sessions` |
| `zk` | `zellij kill-session` |

### テーマトグル

`zellij` の `bind` は `ToggleTheme` をまだ受け付けない (zellij 0.44.2 時点、CLI と KDL でパース経路が分離していて KDL 側に未登録) ため、fish 側で代替している。

| 経路 | 内容 |
|---|---|
| 関数 | `theme-toggle` — `ZELLIJ_SESSION_NAME` があれば現セッションへ `zellij action toggle-theme` を送る (zellij 外では何もしない) |
| キーバインド | fish の `fish_user_key_bindings` に `bind \et theme-toggle` (Alt+T)。zellij が `locked` モードの時のみ fish にキーが届く点に注意 |

### `zp` — プロジェクト固有レイアウトのランチャー

カレントディレクトリ直下の `.zellij.kdl` を使って Zellij を起動するためのヘルパ。

| サブコマンド | 動作 |
|---|---|
| `zp` (引数なし) | `.zellij.kdl` を `_template.kdl` で包み、`layout { ... }` として一時ファイルに合成 → そのレイアウトで Zellij を起動 |
| `zp new` | `~/.config/zellij/layouts/` 内のテンプレ (`_*` と `default.kdl` 以外) を **fzf** で選び、`.zellij.kdl` としてコピー |
| `zp edit` | `$EDITOR` (なければ `vim`) で `.zellij.kdl` を開く |
| その他 | `Usage: zp [new|edit]` を表示 |

> 使い方の例 (Web プロジェクトの場合):
> 1. プロジェクトディレクトリで `zp new` → `web.kdl` を選択
> 2. 必要なら `zp edit` で微調整
> 3. `zp` で起動 → `dev` `git` `claude` `edit` `shell` タブが自動で立ち上がる

---

## ざっくり「最低限これだけ覚えればOK」

1. 起動直後は **🔒 LOCKED**。普通のターミナルと同じ。
2. `Alt ←/→/↑/↓` (or `Alt h/n/e/i`) で **ペイン/タブ移動**。
3. `Alt a` で **ペイン追加**、`Alt f` で **フロート**、`Alt 1`〜`9` で **タブ切替**。
4. ガッツリ操作したくなったら **`Ctrl d`** で normal モードへ → `p` (ペイン) / `t` (タブ) / `r` (リサイズ) / `s` (スクロール) / `o` (セッション)。
5. **`Esc` で常に LOCKED に戻る**。迷子になったら Esc。
6. **`Ctrl q`** で Zellij ごと終了、**`o → d`** で**デタッチ** (再接続できる)。

これだけで日常運用は十分回ります。
