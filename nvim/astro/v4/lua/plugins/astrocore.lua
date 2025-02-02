-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
	"AstroNvim/astrocore",
	---@type AstroCoreOpts
	opts = {
		-- Configure core features of AstroNvim
		features = {
			large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
			autopairs = true, -- enable autopairs at start
			cmp = true, -- enable completion at start
			diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
			highlighturl = true, -- highlight URLs at start
			notifications = true, -- enable notifications at start
		},
		-- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
		diagnostics = {
			virtual_text = true,
			underline = false,
		},
		-- vim options can be configured here
		options = {
			opt = { -- vim.opt.<key>
				relativenumber = false, -- sets vim.opt.relativenumber
				number = true, -- sets vim.opt.number
				spell = false, -- sets vim.opt.spell
				signcolumn = "yes", -- sets vim.opt.signcolumn to yes
				wrap = false, -- sets vim.opt.wrap
				list = true, -- スペースを可視化する
				listchars = "tab:▸-,trail:·,nbsp:·,space:·",
			},
			g = { -- vim.g.<key>
				-- configure global vim variables (vim.g)
				-- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
				-- This can be found in the `lua/lazy_setup.lua` file
			},
		},
		-- NOTE: mappingを設定するならここに追加してください
		-- descを設定するとwhich-keyで表示されるます。
		-- できるだけ設定することをお勧めします
		-- example: ["<leader>a"] = { function() print("Hello, World!") end, desc = "Hello, World!" } }
		mappings = {
			-- first key is the mode
			n = {
				-- second key is the lefthand side of the map
				-- navigate buffer tabs
				["]b"] = {
					function()
						require("astrocore.buffer").nav(vim.v.count1)
					end,
					desc = "Next buffer",
				},
				["[b"] = {
					function()
						require("astrocore.buffer").nav(-vim.v.count1)
					end,
					desc = "Previous buffer",
				},

				-- mappings seen under group name "Buffer"
				["<Leader>bd"] = {
					function()
						require("astroui.status.heirline").buffer_picker(function(bufnr)
							require("astrocore.buffer").close(bufnr)
						end)
					end,
					desc = "Close buffer from tabline",
				},
				["<leader>tr"] = {
					function()
						require("astrocore").toggle_term_cmd("irb")
					end,
					desc = "ToggleTerm irb",
				},
				["<leader>tg"] = {
					function()
						require("astrocore").toggle_term_cmd("gore -autoimport")
					end,
					desc = "ToggleTerm gore",
				},
				["<leader>td"] = {
					function()
						require("astrocore").toggle_term_cmd("lazydocker")
					end,
					desc = "ToggleTerm lazydocker",
				},
				-- ["<Leader>pp"] = { "<cmd>PrevimOpen<cr>", desc = "Previm Open" },
				["<Leader>pt"] = { "<cmd>LiveServerStart<cr>", desc = "Live Server Start" },
				["<Leader>pd"] = { "<cmd>LiveServerStop<cr>", desc = "Live Server Down" },
			},
		},
	},
}
