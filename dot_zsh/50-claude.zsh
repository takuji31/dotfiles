if command -v claude >/dev/null 2>&1; then
    alias opusplan='claude --model opusplan --permission-mode plan'
    alias sonnet='claude --model sonnet --settings '"'"'{"advisorModel":"opus"}'"'"''
    (( $+functions[_claude] )) && compdef _claude opusplan sonnet 2>/dev/null
fi
