local wezterm = require 'wezterm'
local config = wezterm.config_builder()
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

return config