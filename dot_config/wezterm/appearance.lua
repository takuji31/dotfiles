local wezterm = require 'wezterm'
local module = {}

local dark_config = { color_scheme = 'Catppuccin Mocha' }
local light_config = { color_scheme = 'Catppuccin Latte' }

function module.scheme_for(appearance)
  if appearance and appearance:find('Dark') then
    return dark_config
  end
  return light_config
end

function module.current()
  if wezterm.gui then
    return module.scheme_for(wezterm.gui.get_appearance())
  end
  return dark_config
end

function module.is_dark()
  if wezterm.gui then
    return wezterm.gui.get_appearance():find('Dark') ~= nil
  end
  return true
end

local function build_zellij_command(is_dark)
  local action = is_dark and 'set-dark-theme' or 'set-light-theme'
  local script = string.format(
    'command -v zellij >/dev/null 2>&1 || exit 0; '
      .. 'zellij list-sessions -sn 2>/dev/null | '
      .. 'while IFS= read -r s; do '
      .. 'zellij --session "$s" action %s >/dev/null 2>&1 || true; '
      .. 'done',
    action
  )
  if wezterm.target_triple:find('windows') then
    return { 'wsl.exe', 'bash', '-lc', script }
  end
  return { 'sh', '-lc', script }
end

function module.notify_zellij(is_dark)
  local cmd = build_zellij_command(is_dark)
  if type(wezterm.background_child_process) == 'function' then
    pcall(wezterm.background_child_process, cmd)
  else
    pcall(wezterm.run_child_process, cmd)
  end
end

return module
