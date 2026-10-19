-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
	"AstroNvim/astrocommunity",
	-- AstroNvim v5 のデフォルト補完エンジンは blink.cmp に変更されたが、
	-- 既存の LuaSnip 連携・キーマップをそのまま維持するため nvim-cmp を明示指定
	{ import = "astrocommunity.completion.nvim-cmp" },
	{ import = "astrocommunity.pack.lua" },
	{ import = "astrocommunity.completion.copilot-lua" },
	{ import = "astrocommunity.completion.copilot-lua-cmp" },
	{ import = "astrocommunity.completion.cmp-calc" },
	{ import = "astrocommunity.completion.cmp-spell" },
	{ import = "astrocommunity.completion.cmp-nerdfont" },
	{ import = "astrocommunity.completion.cmp-git" },
	{ import = "astrocommunity.completion.cmp-emoji" },
	{ import = "astrocommunity.pack.markdown" },
	{ import = "astrocommunity.pack.go" },
	{ import = "astrocommunity.editing-support.auto-save-nvim" },
	{ import = "astrocommunity.workflow.bad-practices-nvim" },
	{ import = "astrocommunity.syntax.vim-sandwich" },
	{ import = "astrocommunity.color.headlines-nvim" },
	-- { import = "astrocommunity.editing-support.copilotchat-nvim" },
	{ import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },
	{ import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },

	-- 言語パック(Swift/PHP は既存プロジェクト向け、TypeScript/Svelte は Hono を含む TS 開発向け。
	-- Hono 専用パックは存在せず TypeScript パック(vtsls)でカバーされる)
	{ import = "astrocommunity.pack.swift" },
	{ import = "astrocommunity.pack.php" },
	{ import = "astrocommunity.pack.typescript" },
	{ import = "astrocommunity.pack.svelte" },

	-- 汎用おすすめプラグイン
	{ import = "astrocommunity.motion.flash-nvim" },
	{ import = "astrocommunity.git.diffview-nvim" },
	{ import = "astrocommunity.editing-support.todo-comments-nvim" },
	{ import = "astrocommunity.editing-support.treesj" },
	{ import = "astrocommunity.color.nvim-highlight-colors" },
}
