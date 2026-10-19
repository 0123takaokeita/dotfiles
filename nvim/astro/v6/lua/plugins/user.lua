-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {

	-- == Examples of Adding Plugins ==
	-- == Examples of Overriding Plugins ==
	-- customize dashboard header (v5: alpha-nvim -> snacks.nvim に統合)
	{
		-- "folke/snacks.nvim",
		-- opts = {
		-- 	dashboard = {
		-- 		preset = {
		-- 			header = table.concat({
		-- 				" ████████ █████  ██  ██  █████   ██████",
		-- 				"    ██    ██   ██ ████   ██   ██ ██    ██",
		-- 				"    ██    ███████ ██     ███████ ██    ██",
		-- 				"    ██    ██   ██ ████   ██   ██ ██    ██",
		-- 				"   ██    ██   ██ ██  ██ ██   ██  ██████",
		-- 				" ",
		-- 				"    ███    ██ ██    ██   ██   ███    ███",
		-- 				"    ████   ██ ██    ██   ██   ████  ████",
		-- 				"    ██ ██  ██ ██    ██   ██   ██ ████ ██",
		-- 				"    ██  ██ ██  ██  ██    ██   ██  ██  ██",
		-- 				"    ██   ████   ████     ██   ██      ██",
		-- 			}, "\n"),
		-- 		},
		-- 	},
		-- },
	},

	-- You can disable default plugins as follows:
	{ "max397574/better-escape.nvim", enabled = false },

	-- nvim 0.12 で削除された iter_matches({all=false}) を v2.7.0 が使っておりクラッシュする。
	-- 修正 (f93dcee) が未リリースのため master 追従にする。2.7.0 より新しいリリースが出たら削除してよい。
	{ "stevearc/aerial.nvim", version = false },

	-- You can also easily customize additional setup of plugins that is outside of the plugin's setup call
	{
		"L3MON4D3/LuaSnip",
		config = function(plugin, opts)
			require("astronvim.plugins.configs.luasnip")(plugin, opts) -- include the default astronvim config that calls the setup call
			-- add more custom luasnip configuration such as filetype extend or custom snippets
			local luasnip = require("luasnip")
			luasnip.filetype_extend("javascript", { "javascriptreact" })
		end,
	},

	-- v6: nvim-treesitter が master -> main ブランチへ移行し、v4/v5で必要だった
	-- query_predicates.lua 互換shim(set-lang-from-info-string!のTSNode[]配列
	-- アンラップ回避)は main ブランチ側でバグ自体が解消されているため不要。

	{
		"windwp/nvim-autopairs",
		config = function(plugin, opts)
			require("astronvim.plugins.configs.nvim-autopairs")(plugin, opts) -- include the default astronvim config that calls the setup call
			-- add more custom autopairs configuration such as custom rules
			local npairs = require("nvim-autopairs")
			local Rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")
			npairs.add_rules(
				{
					Rule("$", "$", { "tex", "latex" })
						-- don't add a pair if the next character is %
						:with_pair(cond.not_after_regex("%%"))
						-- don't add a pair if  the previous character is xxx
						:with_pair(
							cond.not_before_regex("xxx", 3)
						)
						-- don't move right when repeat character
						:with_move(cond.none())
						-- don't delete if the next character is xx
						:with_del(cond.not_after_regex("xx"))
						-- disable adding a newline when you press <cr>
						:with_cr(cond.none()),
				},
				-- disable for .vim files, but it work for another filetypes
				Rule("a", "a", "-vim")
			)
		end,
	},
}
