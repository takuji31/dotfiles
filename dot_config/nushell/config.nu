if (which moor | is-not-empty) {
  $env.PAGER = "moor"
} else if (which less | is-not-empty) {
  $env.PAGER = "less"
}

# EDITOR / VISUAL: CUI editors only. Prefer the edit-in-pane wrapper, which
# splits the pane inside zellij / tmux / cmux and falls back to direct exec
# outside any multiplexer. MY_CUI_EDITOR overrides the wrapper's editor choice.
if (which edit-in-pane | is-not-empty) {
  $env.EDITOR = "edit-in-pane"
  $env.config.buffer_editor = "edit-in-pane"
} else if (which nvim | is-not-empty) {
  $env.EDITOR = "nvim"
  $env.config.buffer_editor = "nvim"
} else if (which hx | is-not-empty) {
  $env.EDITOR = "hx"
  $env.config.buffer_editor = "hx"
} else if (which vim | is-not-empty) {
  $env.EDITOR = "vim"
  $env.config.buffer_editor = "vim"
}

if ($env.EDITOR? | is-not-empty) {
  $env.VISUAL = $env.EDITOR
}

if (which gh | is-not-empty) {
  let github_token_result = (gh auth token | complete)
  let github_token = ($github_token_result.stdout | str trim)
  if $github_token_result.exit_code == 0 and ($github_token | is-not-empty) {
    $env.GITHUB_TOKEN = $github_token
  }
}
