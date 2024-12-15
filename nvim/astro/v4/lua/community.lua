-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
	"AstroNvim/astrocommunity",
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
	{ import = "astrocommunity.editing-support.copilotchat-nvim" },
	{ import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },
	{ import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },
}
