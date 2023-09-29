local utils   = require "astronvim.utils"
local keymap  = vim.keymap
local opt     = vim.opt

-- スペースを可視化する
opt.list      = true
opt.listchars = "tab:▸-,trail:·,nbsp:·,space:·"

return {
  colorscheme = "tokyonight-storm",
  plugins = {
    {
      "goolord/alpha-nvim",
      opts = function(_, opts)      -- override the options using lazy.nvim
        opts.section.header.val = { -- change the header section value
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
        }
      end,
    },
    {
      'Wansmer/sibling-swap.nvim',
      dependencies = { 'nvim-treesitter' },
      config = function()
        require('sibling-swap').setup {
          -- your config comes here
        }
      end,
    },
    {
      "barrett-ruth/live-server.nvim",
      cmd = "LiveServerStart",
      build = "yarn global add live-server",
      config = function()
        require("live-server").setup()
      end,
    },
    {
      "folke/twilight.nvim",
      as = 'twilight',
      event = "User AstroFile",
      config = function()
        require("twilight").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end
    },
    {
      'previm/previm',
      as = 'previm',
      event = "User AstroFile",
    },
    {
      'tyru/open-browser.vim',
      as = 'open-browser',
      event = "User AstroFile",
    },
    {
      "catppuccin/nvim",
      as = "catppuccin",
      config = function()
        require("catppuccin").setup {}
      end,
    },
    {
      "folke/todo-comments.nvim",
      dependencies = "nvim-lua/plenary.nvim",
      event = 'VeryLazy',
      config = function()
        require("todo-comments").setup {
          -- your configuration comes here
          -- or leave it empty to use the default settings
          -- refer to the configuration section below
        }
      end
    },
    {
      'folke/tokyonight.nvim',
      as = "tokyonight",
      config = function()
        require("tokyonight").setup {}
      end,
    },
    {
      'wakatime/vim-wakatime',
      event = 'VeryLazy',
    },
    {
      'kylechui/nvim-surround',
      version = '*', -- Use for stability; omit to use `main` branch for the latest features
      event   = 'VeryLazy',
      config  = function()
        require('nvim-surround').setup({
          -- Configuration here, or leave empty to use defaults
        })
      end
    },
    {
      'Vonr/align.nvim',
      event  = "BufRead",
      config = function()
        local NS = { noremap = true, silent = true }

        keymap.set('x', 'aa', function() require 'align'.align_to_char(1, true) end, NS)             -- Aligns to 1 character, looking left
        keymap.set('x', 'as', function() require 'align'.align_to_char(2, true, true) end, NS)       -- Aligns to 2 characters, looking left and with previews
        keymap.set('x', 'aw', function() require 'align'.align_to_string(false, true, true) end, NS) -- Aligns to a string, looking left and with previews
        keymap.set('x', 'ar', function() require 'align'.align_to_string(true, true, true) end, NS)  -- Aligns to a Lua pattern, looking left and with previews

        -- Example gawip to align a paragraph to a string, looking left and with previews
        keymap.set('n', 'gaw',
          function()
            local a = require 'align'
            a.operator(a.align_to_string, { is_pattern = false, reverse = true, preview = true })
          end,
          NS
        )

        -- Example gaaip to aling a paragraph to 1 character, looking left
        keymap.set('n', 'gaa',
          function()
            local a = require 'align'
            a.operator(a.align_to_char, { length = 1, reverse = true })
          end,
          NS
        )
      end,
    },
    {
      'vim-scripts/vim-auto-save',
      event = "BufRead",
      config = function()
        vim.g.auto_save = true
      end,
    },
    {
      'RRethy/nvim-treesitter-endwise',
      config = function()
        require('nvim-treesitter.configs').setup { endwise = { enable = true, } }
      end,
    },
    {
      "zbirenbaum/copilot.lua",
      cmd = "Copilot",
      event = "User AstroFile",
      opts = { suggestion = { auto_trigger = true, debounce = 150 } },
    },
    {
      "hrsh7th/nvim-cmp",
      dependencies = { "zbirenbaum/copilot.lua" },
      opts = function(_, opts)
        local cmp, copilot = require "cmp", require "copilot.suggestion"
        local snip_status_ok, luasnip = pcall(require, "luasnip")
        if not snip_status_ok then return end
        local function has_words_before()
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
        end
        if not opts.mapping then opts.mapping = {} end
        opts.mapping["<Tab>"] = cmp.mapping(function(fallback)
          if copilot.is_visible() then
            copilot.accept()
          elseif cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" })

        opts.mapping["<C-x>"] = cmp.mapping(function()
          if copilot.is_visible() then copilot.next() end
        end)

        opts.mapping["<C-z>"] = cmp.mapping(function()
          if copilot.is_visible() then copilot.prev() end
        end)

        return opts
      end,
    },
  },
  lsp = {
    formatting = {
      format_on_save = false, -- enable or disable automatic formatting on save
      timeout_ms = 3200,      -- adjust the timeout_ms variable for formatting
    },
  },
  mappings = {
    -- first key is the mode
    -- desc setting is stored by vim.keymap.set() as a part of opts table in vim lua module
    n = {
      ['B'] = { '0', desc = "move line head" },
      ['E'] = { '$', desc = "move line tail" },
      ['<Leader>fT'] = { '<cmd>TodoTelescope<cr>', desc = "Search Anotation" },
      ['<Leader>pp'] = { '<cmd>PrevimOpen<cr>', desc = "Previm Open" },
      ['<Leader>pls'] = { '<cmd>LiveServerStart<cr>', desc = "Live Server Start" },
      ['<Leader>pld'] = { '<cmd>LiveServerStop<cr>', desc = "Live Server Down" },

      -- second key is the lefthand side of the map
      -- Tab Mappings
      ["<leader>Tn"] = { "<cmd>tabnew<cr>", desc = "New tab" },
      ["<leader>Tc"] = { "<cmd>tabclose<cr>", desc = "Close tab" },
      -- a table with the `name` key will register with which-key if it's available
      -- this an easy way to add menu titles in which-key
      ["<leader>T"] = { name = "Tab" },
      -- quick save
      ["<C-s>"] = { ":w!<cr>", desc = "Save File" }, -- change description but the same command

      ["<leader>tr"] = { function() utils.toggle_term_cmd "irb" end, desc = "ToggleTerm irb" },
      ["<leader>tg"] = { function() utils.toggle_term_cmd "gore" end, desc = "ToggleTerm gore" },
      ["<leader>gg"] = { function() utils.toggle_term_cmd "lazygit" end, desc = "ToggleTerm lazygit" },
      ["<leader>td"] = { function() utils.toggle_term_cmd "lazydocker" end, desc = "ToggleTerm lazydocker" },
    },
    t = {
      -- setting a mapping to false will disable it
      ["<esc>"] = false,
    },
  },
}
