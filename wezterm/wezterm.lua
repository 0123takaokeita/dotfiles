local wezterm = require("wezterm")
local ac = wezterm.action
local config = wezterm.config_builder()

-- 透明度トグル（テーブルの外でイベント登録する）
wezterm.on("toggle-opacity", function(window, _)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 1
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

-- タブにカレントディレクトリ名 or 実行中プロセス名を表示する
wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
	local pane = tab.active_pane
	local title = pane.title

	-- foreground_process_name からプロセス名を取り出す
	local process = pane.foreground_process_name
	if process and #process > 0 then
		title = string.gsub(process, "(.*[/\\])(.*)", "%2")
	end

	-- カレントディレクトリ名があれば併記する
	local cwd = pane.current_working_dir
	if cwd then
		local path = cwd.file_path or tostring(cwd)
		local dir = string.gsub(path, "(.*[/\\])(.*[/\\]?)", "%2")
		dir = string.gsub(dir, "/$", "")
		if dir and #dir > 0 then
			title = string.format("%s · %s", dir, title)
		end
	end

	local index = tab.tab_index + 1
	title = string.format(" %d: %s ", index, title)

	-- max_width を超えないよう末尾を省略する
	if #title > max_width then
		title = wezterm.truncate_right(title, max_width - 1) .. "…"
	end
	return title
end)

-- フォントの設定
config.font = wezterm.font_with_fallback({
	"JetBrains Mono",
	"UDEV Gothic 35NF",
	"Monaco",
	"Cica",
	"HackGen35Nerd Console",
	"Guguru Sans Code Console 35NF",
	"HackGen35",
	"Fira Mono for Powerline",
})
config.font_size = 16
config.adjust_window_size_when_changing_font_size = true

-- テーマ設定
config.color_scheme = "nightfox"
config.colors = {
	split = "#FFA500",
	tab_bar = {
		background = "#0b0022",
		inactive_tab_edge = "#575757",
		active_tab = {
			bg_color = "#FFA500",
			fg_color = "#0f0f3d",
		},
		new_tab = {
			bg_color = "#1b1032",
			fg_color = "#808080",
		},
	},
}

-- 描画バックエンド（Apple Silicon では WebGpu が滑らか・省電力）
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.max_fps = 120

-- 非アクティブ pane を少し暗くしてフォーカスを分かりやすくする
config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.7,
}

-- ウィンドウ・タブまわり
config.tab_max_width = 60
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }
config.use_ime = true
config.initial_cols = 140
config.initial_rows = 40
config.window_close_confirmation = "NeverPrompt"
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "TITLE | RESIZE"
config.window_background_opacity = 1
config.text_background_opacity = 1

-- スクロールバックを増量する
config.scrollback_lines = 10000

-- URL を Cmd+クリックで開けるようにする（標準ルール＋追記）
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- keymapのoverride
-- leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 },
config.keys = {
	{ key = "d", mods = "CMD", action = ac.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "d", mods = "CMD|SHIFT", action = ac.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "X", mods = "CMD", action = ac.ActivateCopyMode },
	{ key = "G", mods = "CMD", action = ac.EmitEvent("toggle-opacity") },
	{ key = "[", mods = "CMD", action = ac.ActivatePaneDirection("Prev") },
	{ key = "]", mods = "CMD", action = ac.ActivatePaneDirection("Next") },
	{ key = "LeftArrow", mods = "CMD", action = ac.ActivatePaneDirection("Left") },
	{ key = "RightArrow", mods = "CMD", action = ac.ActivatePaneDirection("Right") },
	{ key = "UpArrow", mods = "CMD", action = ac.ActivatePaneDirection("Up") },
	{ key = "DownArrow", mods = "CMD", action = ac.ActivatePaneDirection("Down") },
	{ key = "j", mods = "CMD", action = ac.RotatePanes("Clockwise") },
	{ key = "k", mods = "CMD", action = ac.RotatePanes("CounterClockwise") },
}

return config
