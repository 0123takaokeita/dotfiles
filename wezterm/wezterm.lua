local wezterm = require 'wezterm';
local ac = wezterm.action

return {
  -- フォントの設定
  font = wezterm.font_with_fallback({
      'JetBrains Mono',
      'Fira Mono for Powerline',
      'Cica',
      'UDEV Gothic 35NF',
      'Monaco',
      'UDEV Gothic NF',
    },
    -- 文字の太さ
    { weight = 'Bold' }
  ),
  --  テーマ設定
  color_scheme = 'nightfox',
  colors = {
    split = '#FFA500', -- pain split line color
    tab_bar = {
      background = '#0b0022',
      inactive_tab_edge = '#575757',
      active_tab = {
        bg_color = '#FFA500',
        fg_color = '#0f0f3d',
        intensity = 'Bold',   -- Half or Bold or Normal
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
  -- 透明度の設定
  wezterm.on('toggle-opacity', function(window, pane)
    local overrides = window:get_config_overrides() or {}
    if not overrides.window_background_opacity then
      overrides.window_background_opacity = 1
    else
      overrides.window_background_opacity = nil
    end
    window:set_config_overrides(overrides)
  end),

  tab_max_width = 20,
  window_padding = { left = 5, right = 5, top = 5, bottom = 5, },
  use_ime = true,
  initial_cols = 120,
  initial_rows = 80,
  window_close_confirmation = "NeverPrompt",
  font_size = 20,
  adjust_window_size_when_changing_font_size = true,
  enable_tab_bar = true,
  use_fancy_tab_bar = true,
  hide_tab_bar_if_only_one_tab = true,
  window_decorations = "TITLE | RESIZE",
  window_background_opacity = 0.90,
  text_background_opacity = 0.90,
  -- keymapのoverride
  -- leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 },
  keys = {
    { key = 'd',          mods = 'CMD',       action = ac.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
    { key = 'd',          mods = 'CMD|SHIFT', action = ac.SplitVertical { domain = 'CurrentPaneDomain' }, },
    { key = 'X',          mods = 'CMD',       action = ac.ActivateCopyMode, },
    { key = 'G',          mods = 'CMD',       action = ac.EmitEvent 'toggle-opacity', },
    { key = '[',          mods = 'CMD',       action = ac.ActivatePaneDirection "Prev", },
    { key = ']',          mods = 'CMD',       action = ac.ActivatePaneDirection 'Next', },
    { key = 'LeftArrow',  mods = 'CMD',       action = ac.ActivatePaneDirection "Left", },
    { key = 'RightArrow', mods = 'CMD',       action = ac.ActivatePaneDirection 'Right', },
    { key = 'UpArrow',    mods = 'CMD',       action = ac.ActivatePaneDirection 'Up', },
    { key = 'DownArrow',  mods = 'CMD',       action = ac.ActivatePaneDirection 'Down', },
    { key = 'j',          mods = 'CMD',       action = ac.RotatePanes 'Clockwise' },
    { key = 'k',          mods = 'CMD',       action = ac.RotatePanes 'CounterClockwise', },
  }
}
