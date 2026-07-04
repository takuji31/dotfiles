# Cursor エージェントのシェルでは git/gh を takuji31ai アカウントに切り替える。
# Claude Code / Codex は各ツールの設定でネイティブに注入しているためここでは扱わない。
if test -n "$CURSOR_AGENT"
    set -gx GIT_CONFIG_GLOBAL $HOME/.config/git/config-ai
    set -gx GH_CONFIG_DIR $HOME/.config/gh-ai
end
