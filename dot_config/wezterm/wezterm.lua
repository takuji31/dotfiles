local wezterm = require 'wezterm'
local config = wezterm.config_builder()

local appearance = require 'appearance'
if appearance.is_dark() then
  config.color_scheme = 'Tokyo Night'
else
  config.color_scheme = 'Tokyo Night Day'
end

config.default_prog = { '/opt/homebrew/bin/fish', '-l' }
wezterm.log_info("hello world! my name is " .. wezterm.hostname())

return config