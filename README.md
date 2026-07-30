# dotfiles
dotfiles for takuji31

## setup

### Windows

```powershell
irm https://gist.githubusercontent.com/takuji31/2316b55050f0f0d72313b8e2d7af873d/raw/setup-windows.ps1 | iex
```

### macOS / Linux

see https://www.chezmoi.io/

### AI エージェント設定 (private)

`~/.claude` `~/.codex` `~/.cursor` の設定は private リポジトリに分離してある。本体を apply した後に clone する:

```bash
git clone git@github.com:takuji31/agents-config.git ~/.local/share/agents-config
chezmoi --source ~/.local/share/agents-config apply
```

シェルを開き直すと、以降は `chezmoi-agents` (fish / zsh の関数) が `--source` を補うので `chezmoi-agents apply` / `chezmoi-agents add ~/.claude/settings.json` で扱える。
