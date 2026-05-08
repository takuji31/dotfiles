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
