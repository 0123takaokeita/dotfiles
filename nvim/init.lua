-- alias to vim's objects
g      = vim.g
o      = vim.o
opt    = vim.opt
cmd    = vim.cmd
fn     = vim.fn
api    = vim.api
keymap = vim.keymap.set

cmd.packadd 'packer.nvim'
vim.cmd [[
  highlight IndentBlanklineIndent1 guibg=#1f1f1f gui=nocombine
  highlight IndentBlanklineIndent2 guibg=#1a1a1a gui=nocombine
  colorscheme tokyonight-storm
  colorscheme nightfox
  colorscheme tokyonight-night
  colorscheme carbonfox
  colorscheme iceberg
  colorscheme duskfox
  colorscheme ayu-dark
  colorscheme ayu-mirage
]]

-- LSPに追加する内容
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  local opts = { noremap = true, silent = true } -- Mappings.

  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
end

-- Diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
vim.diagnostic.config {
  virtual_text = { prefix = '●' },
  update_in_insert = true,
  float = { source = "always", }, -- Or "if_many"
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- luasnip setup
local luasnip = require('luasnip')

-- LSP Manager
local mason_config = function()
  require("mason").setup({
    ui = {
      icons = {
        package_installed   = "✓",
        package_pending     = "➜",
        package_uninstalled = "✗"
      }
    }
  })
end

-- mason lsp manager ex
-- server auto install
local mason_lsp_config = function()
  require("mason-lspconfig").setup({
    ensure_installed = { 'sumneko_lua', 'rust_analyzer', 'solargraph', 'csharp_ls', 'phpactor' },
    automatic_installation = true,
  })
end

-- setting complete
local nvim_cmp_config = function()
  local cmp = require 'cmp'
  cmp.setup {
    formatting = {
      format = require('lspkind').cmp_format({ with_text = true, maxwidth = 50 })
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-u>'] = cmp.mapping.scroll_docs(-4), -- Up
      ['<C-d>'] = cmp.mapping.scroll_docs(4), -- Down
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'vsnip' },
      { name = 'path' },
      { name = 'buffer', option = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(api.nvim_list_wins()) do
            bufs[api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end
      }
      },
    },
  }
end

-- server list
-- Mason でインストールしたサーバーをここで配列に追加してください。
local servers = {
  'solargraph',
  'csharp_ls',
  'clangd',
  'rust_analyzer',
  'tsserver',
  'pyright',
  'sumneko_lua',
  'phpactor'
}

-- -- Set up completion using nvim_cmp with LSP source
local lspconfig = require('lspconfig')
-- local capabilities = require("cmp_nvim_lsp").default_capabilities() -- Add additional capabilities supported by nvim-cmp
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- capabilities = capabilities,
    on_attach = on_attach,
    flags = { debounce_text_changes = 150, },
  }
end

local lspsage_config = function()
  require('lspsaga').setup {
    ui = {
      winblend = 10,
      border = 'rounded',
      colors = {
        normal_bg = '#002b36'
      }
    }
  }
end

-- git 変更表示
local gitsigns_config = function()
  require('gitsigns').setup {
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then return ']c' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      map('n', '[c', function()
        if vim.wo.diff then return '[c' end
        vim.schedule(function() gs.prev_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      -- Actions
      map({ 'n', 'v' }, '<leader>hs', ':Gitsigns stage_hunk<CR>')
      map({ 'n', 'v' }, '<leader>hr', ':Gitsigns reset_hunk<CR>')
      map('n', '<leader>hS', gs.stage_buffer)
      map('n', '<leader>hp', gs.preview_hunk)
      map('n', '<leader>hb', function() gs.blame_line { full = true } end)
      map('n', '<leader>hd', gs.diffthis)
    end
  }
end

-- コメントアウト
local comment_config = function()
  require('Comment').setup()
end

-- ステータスライン
local lualine_config = function()
  require('lualine').setup({})
end

-- surround
local surround_config = function()
  require('nvim-surround').setup({})
end

-- indent highlight
local indent_line_config = function()
  require('indent_blankline').setup {
    char = '',
    char_highlight_list = {
      'IndentBlanklineIndent1',
      'IndentBlanklineIndent2',
    },
    space_char_highlight_list = {
      'IndentBlanklineIndent1',
      'IndentBlanklineIndent2',
    },
    show_trailing_blankline_indent = false,
  }
end

-- lsp icons
local status, lspkind = pcall(require, 'lspkind')
if (not status) then return end
require('lspkind').init({
  mode = 'symbol_text',
  preset = 'codicons',
  symbol_map = {
    Text          = '',
    Method        = '',
    Function      = '',
    Constructor   = '',
    Field         = 'ﰠ',
    Variable      = '',
    Class         = 'ﴯ',
    Interface     = '',
    Module        = '',
    Property      = 'ﰠ',
    Unit          = '塞',
    Value         = '',
    Enum          = '',
    Keyword       = '',
    Snippet       = '',
    Color         = '',
    File          = '',
    Reference     = '',
    Folder        = '',
    EnumMember    = '',
    Constant      = '',
    Struct        = 'פּ',
    Event         = '',
    Operator      = '',
    TypeParameter = ''
  },
})

-- Filer
local fern_config = function()
  g['fern#renderer']                  = 'nerdfont'
  g['fern#window_selector_use_popup'] = true
  g['fern#default_hidden']            = true
end

-- telescope searcher
local telescope_config = function()
  require('telescope').load_extension('fzy_native')
end

-- yank highlight
local highlightyank_config = function()
  g.highlightedyank_highlight_duration = 100
end

-- todo comment
local todo_comment_config = function()
  require("todo-comments").setup {}
end

-- lazygit wrapper
local lazygit_config = function()
  g.lazygit_floating_window_scaling_factor = 1 -- window size
  g.lazygit_floating_window_winblend       = 0 -- window transparency
end

-- auto save
local auto_save_config = function()
  g.auto_save = true
end

-- syntax highlight
local treesitter_config = function()
  require('nvim-treesitter.configs').setup {
    endwise = { enable = true, },
    ensure_installed = {
      'lua', 'typescript', 'tsx',
      'go', 'gomod', 'sql', 'toml', 'yaml',
      'html', 'javascript', 'graphql',
      'markdown', 'markdown_inline', 'help',
      'ruby', 'php'
    },
    highlight = {
      enable = true,
      disable = {}
    },
    indent = {
      enable = true,
    },
    run = ':TSUpdate',
    auto_install = true,
  }
end

local noice_config = function()
  require("noice").setup {
    messages = {
      -- NOTE: If you enable messages, then the cmdline is enabled automatically.
      -- This is a current Neovim limitation.
      enabled = true, -- enables the Noice messages UI
      view = "mini", -- default view for messages
      view_error = "notify", -- view for errors
      view_warn = "notify", -- view for warnings
      view_history = "messages", -- view for :messages
      view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
    },
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
  }
end

local which_key_config = function()
  vim.o.timeout = true
  vim.o.timeoutlen = 300
  require("which-key").setup {
  }
end


local bufferline_config = function()
  require("bufferline").setup {}
end

local octo_config = function()
  require "octo".setup()
end

local silicon_config = function()
  keymap('n', '<Leader>o', '<Plug>(silicon-generate)')
  keymap('x', '<Leader>o', '<Plug>(silicon-generate)')
end

-- keymap
g.mapleader = ' '
keymap('n', '*', '*N')
keymap('n', '<Leader>w', 'ZZ')
keymap('n', '<Leader>e', '<cmd>e ~/.config/nvim/init.lua<cr>')
keymap('n', '<Leader><Leader>', '<cmd>source  ~/.config/nvim/init.lua<cr> <cmd>lua print("Reloaded init.lua")<cr>')
keymap('n', '<Leader>m', '<cmd>Mason<cr>')
keymap('n', '<Leader>n', '<cmd>noh<cr>')
keymap('n', '<Leader>h', '<cmd>checkhealth<cr>')
keymap('n', '<Leader>p', '<cmd>PrevimOpen<cr>')
keymap('n', '<Leader>s', '<cmd>PackerSync<cr>')
keymap('n', '<Leader>u', '<cmd>PackerUpdate<cr>')
keymap('n', '<Leader>i', '<cmd>PackerInstall<cr>')
keymap('n', 'ss', ':split<CR>enurn><C-w>w')
keymap('n', 'sv', ':vsplit<CR>eturn><C-w>w')
keymap('n', '<C-w>', '<C-w>w')
keymap('', 'sh', '<C-w>h')
keymap('', 'sk', '<C-w>k')
keymap('', 'sj', '<C-w>j')
keymap('', 'sl', '<C-w>l')
keymap('n', '<C-e>', '<cmd>Fern . -reveal=% -drawer -toggle -width=33<cr>')
keymap('n', '+', '<C-a>')
keymap('n', '-', '<C-x>')
keymap('n', '<C-a>', 'gg<S-v>G')
keymap('n', 'gl', ':LazyGit<CR>')
keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")
keymap("n", "gr", "<cmd>Lspsaga rename<CR>")
keymap('x', 'ga', '<Plug>(EasyAlign)')
keymap('n', '<C-p>', '<cmd>Telescope find_files hidden=true<CR>')
keymap('n', '<C-g>', '<cmd>Telescope live_grep<CR>')
keymap('n', '<C-l>', '<cmd>TodoTelescope<CR>')
keymap('n', '<c-o>', '<cmd>Telescope oldfiles theme=get_dropdown hidden=true<CR>')
keymap('n', '<c-;>', '<cmd>Telescope commands hidden=true<CR>')
keymap('n', '<c-k>', '<cmd>Telescope keymaps hidden=true<CR>')
keymap('n', '<c-n>', '<cmd>Octo issue list<CR>')
keymap('n', '<c-m>', '<cmd>Octo pr list<CR>')

opt.clipboard:append({ fn.has('mac') == 4 and 'unnamed' or 'unnamedplus' }) -- クリップボード共有
opt.number        = true -- 行数表示
opt.title         = true
opt.shell         = 'fish'
opt.icon          = true
opt.expandtab     = true
opt.tabstop       = 4 -- tag入力の変更
opt.shiftwidth    = 2
opt.cursorline    = true
opt.helpheight    = 1000
opt.swapfile      = false -- swapfileを作らない
opt.wrap          = false -- 折返し無効
opt.helplang      = 'ja' -- help 日本語化
opt.splitright    = true -- split時に右側に表示する
opt.splitbelow    = true -- split時に下側に表示する
opt.autoread      = true -- vim以外での変更を自動読み込み
opt.ignorecase    = true -- 検索時に大文字小文字を区別しない
opt.list          = true -- 不可視文字可視化
opt.termguicolors = true
opt.listchars:append 'space:⋅' -- spaceを・に変更

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'Shatur/neovim-ayu'
  use 'monaqa/smooth-scroll.vim'
  use 'junegunn/vim-easy-align'
  use 'vim-jp/vimdoc-ja'
  use 'folke/tokyonight.nvim'
  use 'RRethy/vim-illuminate'
  use 'neovim/nvim-lspconfig'
  use 'onsails/lspkind.nvim'
  use 'cocopon/iceberg.vim'
  use 'EdenEast/nightfox.nvim'
  use 'L3MON4D3/LuaSnip' -- Snippets plugin
  use 'saadparwaiz1/cmp_luasnip'
  use { 'numToStr/Comment.nvim', config = comment_config }
  use { 'williamboman/mason-lspconfig.nvim', config = mason_lsp_config }
  use { 'lukas-reineke/indent-blankline.nvim', config = indent_line_config }
  use { 'RRethy/nvim-treesitter-endwise', config = treesitter_config }
  use { 'williamboman/mason.nvim', config = mason_config, }
  use { 'machakann/vim-highlightedyank', config = highlightyank_config }
  use { 'lewis6991/gitsigns.nvim', config = gitsigns_config }
  use { 'vim-scripts/vim-auto-save', config = auto_save_config }
  use { 'folke/which-key.nvim', config = which_key_config }
  use { 'nvim-lualine/lualine.nvim', config = lualine_config }
  use { 'kylechui/nvim-surround', config = surround_config, tag = "*" }
  use { 'kdheepak/lazygit.nvim', config = lazygit_config, requires = 'kyazdani42/nvim-web-devicons' }
  use { 'folke/todo-comments.nvim', config = todo_comment_config, requires = 'nvim-lua/plenary.nvim' }
  use { "glepnir/lspsaga.nvim", config = lspsage_config, branch = "main" }
  use { 'akinsho/bufferline.nvim', config = bufferline_config, tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons' }
  use { 'vim-denops/denops.vim' }
  use { 'skanehira/denops-silicon.vim', config = silicon_config }

  use {
    'pwntester/octo.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'kyazdani42/nvim-web-devicons',
    },
    config = octo_config,
  }

  use {
    'lambdalisue/fern.vim',
    config = fern_config,
    requires = {
      'lambdalisue/nerdfont.vim',
      'lambdalisue/fern-renderer-nerdfont.vim',
      'lambdalisue/fern-git-status.vim',
    },
  }

  use {
    'hrsh7th/nvim-cmp',
    config = nvim_cmp_config,
    module = { "cmp" },
    requires = {
      { 'hrsh7th/cmp-nvim-lsp', event = { 'InsertEnter' } },
      { 'hrsh7th/cmp-buffer', event = { 'InsertEnter' } },
      { 'hrsh7th/cmp-path', event = { 'InsertEnter' } },
      { 'hrsh7th/cmp-vsnip', event = { 'InsertEnter' } },
      { 'hrsh7th/vim-vsnip', event = { 'InsertEnter' } },
      { 'hrsh7th/cmp-cmdline', event = { 'CmdlineEnter' } },
    },
  }

  use { "folke/noice.nvim",
    config = noice_config,
    presets = {
      bottom_search         = true, -- use a classic bottom cmdline for search
      command_palette       = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename            = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border        = false, -- add a border to hover docs and signature help
    },
    requires = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify", }
  }

  use {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.0',
    config = telescope_config,
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'nvim-treesitter/nvim-treesitter',
      'nvim-telescope/telescope-fzy-native.nvim',
    },
    extensions = {
      fzy_native = {
        override_generic_sorter = false,
        override_file_sorter = true,
      }
    },
  }
  use {
    "jackMort/ChatGPT.nvim",
    config = function()
      require("chatgpt").setup({
        -- optional configuration
      })
    end
  }
end)
