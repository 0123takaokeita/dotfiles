-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- Here are some examples:

---@type LazySpec
return {

	-- == Examples of Adding Plugins ==
	-- == Examples of Overriding Plugins ==
	-- customize dashboard header (v5: alpha-nvim -> snacks.nvim に統合)
	{
		"folke/snacks.nvim",
		opts = {
			dashboard = {
				preset = {
					header = table.concat({
						" ████████  █████  ██  ██  █████   ██████",
						"    ██    ██   ██ ████   ██   ██ ██    ██",
						"    ██    ███████ ██     ███████ ██    ██",
						"    ██    ██   ██ ████   ██   ██ ██    ██",
						"    ██    ██   ██ ██  ██ ██   ██  ██████",
						" ",
						"    ███    ██ ██    ██   ██   ███    ███",
						"    ████   ██ ██    ██   ██   ████  ████",
						"    ██ ██  ██ ██    ██   ██   ██ ████ ██",
						"    ██  ██ ██  ██  ██    ██   ██  ██  ██",
						"    ██   ████   ████     ██   ██      ██",
					}, "\n"),
				},
			},
		},
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

	-- nvim-treesitter の master ブランチは Neovim 0.12 と非互換(メンテナー確認済み、
	-- https://github.com/nvim-treesitter/nvim-treesitter/issues/8618)。v5 でも
	-- nvim-treesitter はまだ main ブランチへ移行していない(移行は v6 から)ため、
	-- v4 と同じ shim が引き続き必要。
	-- 0.12 で `add_directive`/`add_predicate` の `all` オプションが削除され、
	-- キャプチャが常に TSNode[] で渡されるようになったが、master 側の
	-- query_predicates.lua は単一 TSNode を前提にしたままで、markdown の
	-- フェンスコードブロック言語検出(set-lang-from-info-string!)が
	-- `node:range()` で毎回クラッシュする。該当ディレクティブだけ配列アンラップ
	-- 対応版で force 再登録して被害を抑える。
	{
		"nvim-treesitter/nvim-treesitter",
		config = function(plugin, opts)
			require("astronvim.plugins.configs.nvim-treesitter")(plugin, opts)

			local query = require("vim.treesitter.query")

			-- query_predicates.lua の非公開テーブル/関数を複製(該当箇所のみ)
			local non_filetype_match_injection_language_aliases = {
				ex = "elixir",
				pl = "perl",
				sh = "bash",
				uxn = "uxntal",
				ts = "typescript",
			}
			local function get_parser_from_markdown_info_string(injection_alias)
				local match = vim.filetype.match({ filename = "a." .. injection_alias })
				return match or non_filetype_match_injection_language_aliases[injection_alias] or injection_alias
			end

			query.add_directive("set-lang-from-info-string!", function(match, _, bufnr, pred, metadata)
				local capture_id = pred[2]
				local node = match[capture_id]
				if type(node) == "table" then
					node = node[1] -- nvim 0.12: captures are always TSNode[]
				end
				if not node then
					return
				end
				local injection_alias = vim.treesitter.get_node_text(node, bufnr):lower()
				metadata["injection.language"] = get_parser_from_markdown_info_string(injection_alias)
			end, { force = true })
		end,
	},

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
