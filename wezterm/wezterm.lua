local wezterm = require 'wezterm';

return {
  font = wezterm.font("HackGen35Nerd Console"),
  window_padding = { left = 0, right = 0, top = 0, bottom = 0, },
  use_ime = true, -- wezは日本人じゃないのでこれがないとIME動かない
  font_size = 20.0,
  color_scheme = "nord", -- 自分の好きなhなテーマ探す https://wezfurlong.org/wezterm/colorschemes/index.html
  adjust_window_size_when_changing_font_size = false,
  -- default_cursor_style = "BlinkingBar",
  -- cursor_blink_rate = 400,
  enable_tab_bar = true,
  use_fancy_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  window_decorations = "TITLE | RESIZE",
  ative_macos_fullscreen_mode = false,
  window_background_opacity = 1.0,
  colors = {
    foreground = 'silver',
    -- background = 'black',
    -- cursor_bg = '#52ad70',
    -- cursor_fg = 'black',
    -- cursor_border = '#52ad70',
  },

  -- leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 },
  keys = {
    {
      key = 'v',
      mods = 'SHIFT',
      action = wezterm.action.ActivateCopyMode,
    },
    {
      key = 'd',
      mods = 'CMD',
      action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
      key = 'd',
      mods = 'CMD|SHIFT',
      action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    {
      key = '[',
      mods = 'CMD',
      action = wezterm.action.ActivatePaneDirection "Prev",
    },
    {
      key = ']',
      mods = 'CMD',
      action = wezterm.action.ActivatePaneDirection 'Next',
    },
    {
      key = 'LeftArrow',
      mods = 'CMD',
      action = wezterm.action.ActivatePaneDirection "Left",
    },
    {
      key = 'RightArrow',
      mods = 'CMD',
      action = wezterm.action.ActivatePaneDirection 'Right',
    },
    {
      key = 'UpArrow',
      mods = 'CMD',
      action = wezterm.action.ActivatePaneDirection 'Up',
    },
    {
      key = 'DownArrow',
      mods = 'CMD',
      action = wezterm.action.ActivatePaneDirection 'Down',
    },
  }
}
