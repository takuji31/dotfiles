# Cursor エージェントのシェルでは git/gh を takuji31ai アカウントに切り替える。
# Claude Code / Codex は各ツールの設定でネイティブに注入しているためここでは扱わない。
if [[ -n "$CURSOR_AGENT" ]]; then
    export GIT_CONFIG_GLOBAL="$HOME/.config/git/config-ai"
    export GH_CONFIG_DIR="$HOME/.config/gh-ai"
fi
