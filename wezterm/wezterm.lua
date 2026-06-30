-- =============================================================
-- 基本のセットアップ
-- =============================================================
-- wezterm: WezTerm 本体の API モジュール。ここから全機能を呼び出す。
-- ac:      action の短縮エイリアス。キーバインドで使う各種アクション群。
-- config:  設定オブジェクトのビルダー。最新スキーマで補完・検証してくれる。
local wezterm = require("wezterm")
local ac = wezterm.action
local config = wezterm.config_builder()

-- =============================================================
-- イベント: 透明度トグル（Cmd+G で発火）
-- =============================================================
-- ウィンドウの「不透明 ⇔ 透明」を切り替える。
-- get_config_overrides() で実行中だけの上書き設定を取得し、
-- opacity が未設定なら 1（不透明）をセット、設定済みなら nil に戻して
-- ベース設定（config.window_background_opacity）へ復帰する仕組み。
wezterm.on("toggle-opacity", function(window, _)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 1
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

-- =============================================================
-- イベント: タブのタイトル表示をカスタマイズ
-- =============================================================
-- 各タブに「カレントディレクトリ名 · 実行中プロセス名」を表示する。
-- 表示は " 1: dir · process " のような形式になる。
wezterm.on("format-tab-title", function(tab, _, _, _, _, max_width)
	local pane = tab.active_pane
	local title = pane.title

	-- foreground_process_name（例: /usr/bin/fish）から末尾のプロセス名だけ取り出す
	local process = pane.foreground_process_name
	if process and #process > 0 then
		title = string.gsub(process, "(.*[/\\])(.*)", "%2")
	end

	-- カレントディレクトリがあれば、その末尾ディレクトリ名を頭に併記する
	local cwd = pane.current_working_dir
	if cwd then
		local path = cwd.file_path or tostring(cwd)
		local dir = string.gsub(path, "(.*[/\\])(.*[/\\]?)", "%2")
		dir = string.gsub(dir, "/$", "")
		if dir and #dir > 0 then
			title = string.format("%s · %s", dir, title)
		end
	end

	-- 先頭にタブ番号（1始まり）を付ける
	local index = tab.tab_index + 1
	title = string.format(" %d: %s ", index, title)

	-- タブ幅の上限を超える場合は末尾を省略して "…" を付ける
	if #title > max_width then
		title = wezterm.truncate_right(title, max_width - 1) .. "…"
	end
	return title
end)

-- =============================================================
-- フォント設定
-- =============================================================
-- font_with_fallback: 上から順に試し、グリフが無ければ次のフォントへフォールバック。
-- 1番目が見つからない/該当グリフが無い場合に日本語フォント等で補完する。
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
-- フォントサイズ変更時にウィンドウサイズも追従させる
config.adjust_window_size_when_changing_font_size = true

-- =============================================================
-- カラーテーマ / 配色
-- =============================================================
-- color_scheme: ベースの配色テーマ（背景・文字・ANSI 16色など）。
-- colors:       テーマの一部を個別に上書き。ここではタブバーまわりを調整。
config.color_scheme = "nightfox"
config.colors = {
	split = "#FFA500", -- pane 分割線の色（オレンジ）
	tab_bar = {
		inactive_tab_edge = "#0f0f3d", -- 非アクティブタブの境界線
		active_tab = { -- 現在アクティブなタブ
			bg_color = "#FFA500",
			fg_color = "#0f0f3d",
		},
	},
}

-- =============================================================
-- 描画バックエンド / パフォーマンス
-- =============================================================
-- WebGpu: Apple Silicon では描画が滑らかで省電力。
-- HighPerformance: 統合GPUより高性能GPUを優先（該当機のみ）。
-- max_fps: 描画の上限フレームレート。
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
config.max_fps = 120

-- =============================================================
-- pane（分割画面）の見た目
-- =============================================================
-- 非アクティブな pane を彩度・明度を下げて暗くし、
-- 今どの pane を操作中かを視覚的に分かりやすくする。
config.inactive_pane_hsb = {
	saturation = 0.9,
	brightness = 0.7,
}

-- =============================================================
-- ウィンドウ / タブバーの挙動
-- =============================================================
config.tab_max_width = 60 -- タブ1枚の最大幅
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 } -- 余白なし
config.use_ime = true -- IME（日本語入力）を有効化
config.initial_cols = 140 -- 起動時の桁数（横）
config.initial_rows = 40 -- 起動時の行数（縦）
config.window_close_confirmation = "NeverPrompt" -- 閉じる時に確認ダイアログを出さない
config.enable_tab_bar = true -- タブバーを表示
config.use_fancy_tab_bar = false -- レトロ（軽量）スタイルのタブバーを使用
config.hide_tab_bar_if_only_one_tab = true -- タブが1枚だけならタブバーを隠す
config.window_decorations = "TITLE | RESIZE" -- タイトルバーとリサイズ枠を表示
config.window_background_opacity = 1 -- ウィンドウ背景の不透明度（1=不透明）
config.text_background_opacity = 1 -- 文字背景の不透明度

-- =============================================================
-- スクロールバック
-- =============================================================
-- 保持する過去出力の行数。多いほど遡れるがメモリを使う。
config.scrollback_lines = 10000

-- =============================================================
-- ハイパーリンク
-- =============================================================
-- 標準ルールを使い、URL を Cmd+クリックで開けるようにする。
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- =============================================================
-- キーバインド（デフォルトの上書き・追加）
-- =============================================================
-- leader = { ... } を使えばプレフィックスキー方式も可能（今は未使用）。
config.keys = {
	-- pane 分割
	{ key = "d", mods = "CMD", action = ac.SplitHorizontal({ domain = "CurrentPaneDomain" }) }, -- 左右分割
	{ key = "d", mods = "CMD|SHIFT", action = ac.SplitVertical({ domain = "CurrentPaneDomain" }) }, -- 上下分割
	-- モード切替
	{ key = "X", mods = "CMD", action = ac.ActivateCopyMode }, -- コピーモード
	{ key = "G", mods = "CMD", action = ac.EmitEvent("toggle-opacity") }, -- 透明度トグル（上のイベントを発火）
	-- pane 間のフォーカス移動（[ ] と矢印キーの両対応）
	{ key = "[", mods = "CMD", action = ac.ActivatePaneDirection("Prev") },
	{ key = "]", mods = "CMD", action = ac.ActivatePaneDirection("Next") },
	{ key = "LeftArrow", mods = "CMD", action = ac.ActivatePaneDirection("Left") },
	{ key = "RightArrow", mods = "CMD", action = ac.ActivatePaneDirection("Right") },
	{ key = "UpArrow", mods = "CMD", action = ac.ActivatePaneDirection("Up") },
	{ key = "DownArrow", mods = "CMD", action = ac.ActivatePaneDirection("Down") },
	-- pane の配置を回転
	{ key = "j", mods = "CMD", action = ac.RotatePanes("Clockwise") },
	{ key = "k", mods = "CMD", action = ac.RotatePanes("CounterClockwise") },
}

-- 構築した設定を WezTerm に返す（必須）
return config
