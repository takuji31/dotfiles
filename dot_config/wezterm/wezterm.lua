local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local act = wezterm.action
local is_windows = wezterm.target_triple:find('windows') ~= nil
local mod_key = is_windows and 'CTRL|SHIFT' or 'CMD'

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
if is_windows then
  config.default_prog = { 'pwsh.exe', '-NoLogo' }
end

-- for Mac
if not is_windows then
  config.default_prog = { '/opt/homebrew/bin/fish', '-l' }
  config.send_composed_key_when_left_alt_is_pressed = false
  config.send_composed_key_when_right_alt_is_pressed = false
end

config.bypass_mouse_reporting_modifiers = 'SHIFT'

config.keys = {
  {
    key = 'u',
    mods = mod_key,
    action = act.QuickSelectArgs {
      label = 'open url',
      patterns = { 'https?://[\\w\\d\\-._~:/?#\\[\\]@!$&\'()*+,;=%]+' },
      action = wezterm.action_callback(function(window, pane)
        local url = window:get_selection_text_for_pane(pane)
        wezterm.open_with(url)
      end),
    },
  },
  {
    key = 'l',
    mods = 'CTRL|SHIFT|ALT',
    action = act.ShowLauncherArgs { flags = 'FUZZY|LAUNCH_MENU_ITEMS|DOMAINS' },
  },
}

if is_windows then
  table.insert(config.keys, {
    key = 'w',
    mods = 'CTRL|ALT|SHIFT',
    action = act.SpawnCommandInNewTab {
      domain = { DomainName = 'WSL:Ubuntu' },
    },
  })
end

config.enable_kitty_graphics = true
config.mux_enable_ssh_agent = false

return config
