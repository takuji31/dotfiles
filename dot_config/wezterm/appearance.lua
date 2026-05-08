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

return module
