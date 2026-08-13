if command -q claude
    abbr -a opusplan 'claude --model opusplan --permission-mode plan'
    abbr -a sonnet 'claude --model sonnet --settings \'{"advisorModel":"opus"}\''
end
