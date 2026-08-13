if command -v claude >/dev/null 2>&1 && (( $+functions[abbr] )); then
    # -S: session scope (ストアファイルに書かない) / -f: 再 source 時のエラー回避 / -q: 静か
    abbr -S -q -f cw='CLAUDE_CONFIG_DIR=$HOME/.claude-work claude'
    abbr -S -q -f opusplan='claude --model opusplan --permission-mode plan'
    abbr -S -q -f sonnet="claude --model sonnet --settings '{\"advisorModel\":\"opus\"}'"
fi
