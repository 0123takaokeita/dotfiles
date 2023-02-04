local wezterm = require 'wezterm';

return {
  font = wezterm.font_with_fallback {
    'UDEV Gothic 35NF',
    'UDEV Gothic NF',
    'Cica',
    'HackGen',
    'HackGen Console',
    'HackGenNerd Console',
    'HackGen Console NF ',
    'HackGenNerd',
    'Ricty Diminished Discord',
    'Monaco',
  },

  color_scheme = 'nightfox',
  colors = {
    tab_bar = {
      background = '#0b0022',
      inactive_tab_edge = '#575757',
      active_tab = {
         bg_color = '#ffcc66',
         fg_color = '#0f0f3d',
         intensity = 'Bold', -- Half or Bold or Normal
         underline = 'Double', -- None or Single or Double
         italic = true,
         strikethrough = true,
      },
      new_tab = {
        bg_color = '#1b1032',
        fg_color = '#808080',
      },
    },
  },

  wezterm.on('toggle-opacity', function(window, pane)
    local overrides = window:get_config_overrides() or {}
    if not overrides.window_background_opacity then
      overrides.window_background_opacity = 1
    else
      overrides.window_background_opacity = nil
    end
    window:set_config_overrides(overrides)
  end),

  tab_max_width = 16,
  window_padding = { left = 0, right = 0, top = 0, bottom = 0, },
  use_ime = true,
  initial_rows = 40,
  initial_cols = 90,
  font_size = 21,
  adjust_window_size_when_changing_font_size = true,
  enable_tab_bar = true,
  use_fancy_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  window_decorations = "TITLE | RESIZE",
  window_background_opacity = 0.95,
  text_background_opacity = 0.90,

  -- leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 },
  keys = {
    { key = 'd',          mods = 'CMD',        action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
    { key = 'd',          mods = 'CMD|SHIFT',  action = wezterm.action.SplitVertical   { domain = 'CurrentPaneDomain' }, },
    { key = 'X',          mods = 'CMD', action = wezterm.action.ActivateCopyMode,     },
    { key = 'G',          mods = 'CMD', action = wezterm.action.EmitEvent             'toggle-opacity',   },
    { key = '[',          mods = 'CMD', action = wezterm.action.ActivatePaneDirection "Prev",             },
    { key = ']',          mods = 'CMD', action = wezterm.action.ActivatePaneDirection 'Next',             },
    { key = 'LeftArrow',  mods = 'CMD', action = wezterm.action.ActivatePaneDirection "Left",             },
    { key = 'RightArrow', mods = 'CMD', action = wezterm.action.ActivatePaneDirection 'Right',            },
    { key = 'UpArrow',    mods = 'CMD', action = wezterm.action.ActivatePaneDirection 'Up',               },
    { key = 'DownArrow',  mods = 'CMD', action = wezterm.action.ActivatePaneDirection 'Down',             },
    { key = 'j',          mods = 'CMD', action = wezterm.action.RotatePanes           'Clockwise'         },
    { key = 'k',          mods = 'CMD', action = wezterm.action.RotatePanes           'CounterClockwise', },
  }
}
