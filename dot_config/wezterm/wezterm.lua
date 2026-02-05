local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Font settings
config.font = wezterm.font_with_fallback({
  'Firge35Nerd Console',
  'Menlo',    -- macOS fallback
  'Consolas', -- Windows fallback
})
config.font_size = 18
config.line_height = 1.1

-- Tab bar font
config.window_frame = {
  font = wezterm.font_with_fallback({
    'Firge35Nerd Console',
    'Menlo',
    'Consolas',
  }),
  font_size = 14,
}

config.check_for_updates = true
config.check_for_updates_interval_seconds = 86400
config.scrollback_lines = 10000
config.exit_behavior = 'CloseOnCleanExit'


local appearance = require 'appearance'
if appearance.is_dark() then
  config.color_scheme = 'Tokyo Night'
else
  config.color_scheme = 'Tokyo Night Day'
end

config.default_prog = { '/opt/homebrew/bin/fish', '-l' }
wezterm.log_info("hello world! my name is " .. wezterm.hostname())
config.audible_bell = "Disabled"
config.use_fancy_tab_bar = true

-- for windows
if wezterm.target_triple:find('windows') then
  config.default_domain = 'WSL:Ubuntu'
end

-- for Mac
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

config.bypass_mouse_reporting_modifiers = 'SHIFT'

local quick_launch_items = {
  { id = 'claude', label = 'c  Claude Code' },
  { id = 'claude-atrain', label = 'a  Claude Code (a-train-manager)' },
  { id = 'lazygit', label = 'g  Lazygit' },
}

local quick_launch_actions = {
  claude = wezterm.action.SpawnCommandInNewTab { args = { 'claude' } },
  ['claude-atrain'] = wezterm.action.SpawnCommandInNewTab {
    args = { 'claude' },
    cwd = '/home/takuji/projects/github.com/takuji31/a-train-manager',
  },
  lazygit = wezterm.action.SpawnCommandInNewTab { args = { 'lazygit' } },
}

config.keys = {
  {
    key = 'l',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.InputSelector {
      title = '🚀 Quick Launch',
      choices = quick_launch_items,
      fuzzy = true,
      action = wezterm.action_callback(function(window, pane, id, label)
        if id and quick_launch_actions[id] then
          window:perform_action(quick_launch_actions[id], pane)
        end
      end),
    },
  },
  { key = 'c', mods = 'CTRL|SHIFT|ALT', action = quick_launch_actions.claude },
  { key = 'a', mods = 'CTRL|SHIFT|ALT', action = quick_launch_actions['claude-atrain'] },
  { key = 'g', mods = 'CTRL|SHIFT|ALT', action = quick_launch_actions.lazygit },
}

config.launch_menu = {
  { label = '🤖 Claude Code', args = { 'claude' } },
  {
    label = '🚂 Claude Code (a-train-manager)',
    args = { 'claude' },
    cwd = '/home/takuji/projects/github.com/takuji31/a-train-manager',
  },
  { label = '📦 Lazygit', args = { 'lazygit' } },
}

config.enable_kitty_graphics = true

return config
