return {
  -- colorscheme = "catppuccin",
  colorscheme = "tokyonight-storm",

  plugins = {
    {
      "goolord/alpha-nvim",
      opts = function(_, opts) -- override the options using lazy.nvim
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
      "catppuccin/nvim",
      as = "catppuccin",
      config = function()
        require("catppuccin").setup {}
      end,
    },
    {
      'folke/tokyonight.nvim',
      as = "tokyonight",
      config = function()
        require("tokyonight").setup {}
      end,
    },
    {
      'kylechui/nvim-surround',
      event = "BufRead",
      config = function()
        require("nvim-surround").setup {}
      end,
    },
    {
      'junegunn/vim-easy-align',
      event = "BufRead",
      config = function()
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
        require('nvim-treesitter.configs').setup { endwise = { enable = true, }}
      end,
    },
    -- {
    --   'github/copilot.vim',
    --   event = "BufRead",
    --   config = function()
    --   end,
    -- },
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
    -- options = {
    --   g = {
    --     copilot_no_tab_map = true,
    --     copilot_assume_mapped = true,
    --     copilot_tab_fallback = "",
    --   },
    -- },
    -- maupings = {
    --   i = {
    --     ["<C-cr>"] = { "copilot#Accept(<Tab>)", silent = true, expr = true, script = true },
    --   }
    -- },
  lsp = {
    formatting = {
      format_on_save = false, -- enable or disable automatic formatting on save
      timeout_ms = 3200, -- adjust the timeout_ms variable for formatting
    },
  },
}