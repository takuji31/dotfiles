if (which moor | is-not-empty) {
  $env.PAGER = "moor"
} else if (which less | is-not-empty) {
  $env.PAGER = "less"
}

if (which nvim | is-not-empty) {
  $env.EDITOR = "nvim"
  $env.config.buffer_editor = "nvim"
} else if (which code | is-not-empty) {
  $env.EDITOR = "code -w"
  $env.config.buffer_editor = ["code", "-w"]
}

if (which gh | is-not-empty) {
  let github_token_result = (gh auth token | complete)
  let github_token = ($github_token_result.stdout | str trim)
  if $github_token_result.exit_code == 0 and ($github_token | is-not-empty) {
    $env.GITHUB_TOKEN = $github_token
  }
}
