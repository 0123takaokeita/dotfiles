local wezterm = require 'wezterm';

return {
  font = wezterm.font_with_fallback {
    'Cica',
    'HackGen35 Console',
    'HackGen35',
    'JetBrains Mono',
    'Ricty Diminished Discord',
    'Monaco',
  },
  window_padding = { left = 0, right = 0, top = 0, bottom = 0, },
  use_ime = true,
  font_size = 24,
  -- color_scheme = "AyuMirage (Gogh)",
  color_scheme = "TokyoNight (Gogh)",
  djust_window_size_when_changing_font_size = false,
  enable_tab_bar = true,
  use_fancy_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  window_decorations = "TITLE | RESIZE",
  window_background_opacity = 1.0,

  -- leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 },
  keys = {
    { key = 'x',          mods = 'CTRL|SHIFT', action = wezterm.action.ActivateCopyMode,                                 },
    { key = 'd',          mods = 'CMD',        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
    { key = 'd',          mods = 'CMD|SHIFT',  action = wezterm.action.SplitVertical   { domain = 'CurrentPaneDomain' }, },
    { key = '[',          mods = 'CMD',        action = wezterm.action.ActivatePaneDirection "Prev",                     },
    { key = ']',          mods = 'CMD',        action = wezterm.action.ActivatePaneDirection 'Next',                     },
    { key = 'LeftArrow',  mods = 'CMD',        action = wezterm.action.ActivatePaneDirection "Left",                     },
    { key = 'RightArrow', mods = 'CMD',        action = wezterm.action.ActivatePaneDirection 'Right',                    },
    { key = 'UpArrow',    mods = 'CMD',        action = wezterm.action.ActivatePaneDirection 'Up',                       },
    { key = 'DownArrow',  mods = 'CMD',        action = wezterm.action.ActivatePaneDirection 'Down',                     },
  }
}
