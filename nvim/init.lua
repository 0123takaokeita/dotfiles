-- alias to vim's objects
g      = vim.g
o      = vim.o
opt    = vim.opt
cmd    = vim.cmd
fn     = vim.fn
api    = vim.api
keymap = vim.keymap.set
diag   = vim.diagnostic

local status, packer = pcall(require, "packer")
if (not status) then
  print("Packer is not installed")
  return
end

cmd.packadd('packer.nvim')
vim.cmd [[
  colorscheme tokyonight-storm
  colorscheme nightfox
  colorscheme tokyonight-night
  colorscheme carbonfox
  colorscheme iceberg
  colorscheme duskfox
  colorscheme ayu-dark
  colorscheme ayu-mirage

  " indent のカラーはカラースキーム読み込みのあとに上書きしないと反映しない
  highlight IndentBlanklineIndent1 guibg=#3b3b3b gui=nocombine
  highlight IndentBlanklineIndent2 guibg=#1f1f1f gui=nocombine
]]

-- LSPに追加する内容
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) api.nvim_buf_set_keymap(bufnr, ...) end

  -- local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  local opts = { noremap = true, silent = true } -- Mappings.
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.format()<CR>", opts)
end

-- Diagnostic symbols in the sign column
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
diag.config {
  virtual_text = { prefix = '●' },
  update_in_insert = true,
  float = { source = "always", }, -- Or "if_many"
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

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
    ensure_installed = { 'sumneko_lua', 'rust_analyzer', 'solargraph', 'csharp_ls', 'sqlls' },
    automatic_installation = true,
  })
end

-- setting complete
local nvim_cmp_config = function()
  local cmp = require 'cmp'
  cmp.setup {
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      max_height = 24,
      max_width = 106,
      winhighlight = "FloatBorder:NormalFloat"
    },
    formatting = {
      format = require('lspkind').cmp_format({ with_text = true, maxwidth = 50 })
    },
    window = {
      documentation = cmp.config.window.bordered()
    },
    preselect = cmp.PreselectMode.None,
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.abort(),
      -- ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ["<CR>"] = cmp.mapping(function(callback)
        if cmp.visible() then
          cmp.confirm({ select = true })
        elseif fn["skkeleton#mode"]() ~= "" then
          fn["skkeleton#handle"]("handleKey", { key = "<CR>", ["function"] = "newline" })
        else
          callback()
        end
      end, { "i" }),
    }),
    sources = {
      { name = 'skkeleton' },
      { name = 'nvim_lsp' },
      -- { name = 'vsnip' },
      { name = 'path' },
      { name = 'luasnip' }, -- For luasnip users.
      { name = 'buffer', option = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(api.nvim_list_wins()) do
            bufs[api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end
      } },
    },
    snippet = {
      expand = function(args)
        -- fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      end
    },
    -- view = {
    --   entries = 'native'
    -- }
  }

  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = "path" },
    },
  })
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
  'intelephense',
  'cssls',
  'denols',
  'gopls',
  'html',
  'r_language_server',
  'sqlls',
  'tailwindcss',
  'volar',
}
-- Set up lspconfig.
local lspconfig = require('lspconfig')
-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- capabilities = capabilities,
    on_attach = on_attach,
    flags = { debounce_text_changes = 150, },
  }
end

-- TypeScript
-- lspconfig.tsserver.setup {
--   on_attach = on_attach,
--   filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
--   cmd = { "typescript-language-server", "--stdio" }
-- }


local lspsaga_config = function()
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
        keymap(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']g', function()
        if vim.wo.diff then return ']g' end
        vim.schedule(function() gs.next_hunk() end)
        return '<Ignore>'
      end, { expr = true })

      map('n', '[g', function()
        if vim.wo.diff then return '[g' end
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
  require('lualine').setup({
    options = {
      section_separators = { left = '', right = '' },
      component_separators = { left = '', right = '' }
    }
  })
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
require('lspkind').init({
  mode = 'symbol_text', -- text, text_symbol, symbol
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
  g.lazygit_floating_window_use_plenary    = 1 -- use plenary.nvim to manage floating window if available
  g.lazygit_use_neovim_remote              = 1 -- fallback to 0 if neovim-remote is not installed
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
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
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

local fidget_config = function()
  require "fidget".setup {}
end

local skkelton_config = function()
  fn['skkeleton#config'] {
    globalJisyo = '~/.skk/SKK-JISYO.L',
    userJisyo = '~/.skk/SKK-JISYO.L',
    markerHenkan = '<>',
    markerHenkanSelect = '>>',
    eggLikeNewline = true,
    registerConvertResult = true,
  }
  -- fn['skkeleton#config']({
  --   -- eggLikeNewline = true,
  --   globalJisyo = '~/.skk/SKK-JISYO.L',
  --   markerHenkan = '▹',
  --   markerHenkanSelect = '▸',
  --   -- dvorak = true,
  -- })
end

local easy_align_config = function()
  g.easy_align_ignore_groups = { 'String' }
end

local live_server_config = function()
  require('live-server').setup {
    build = 'yarn global add live-server',
    config = true,
    args = { '--port=7777' }
  }
end

local emmet_config = function()
  g.user_emmet_leader_key = '<c-,>'
  g.user_emmet_settings = {
    variables = { lang = 'ja' }
  }
end

local autotag_config = function()
  require 'nvim-treesitter.configs'.setup {
    autotag = {
      enable = true,
    }
  }
end

local autopairs_config = function()
  require 'nvim-autopairs'.setup {
    disable_filetype = { 'TelescopePrompt', 'vim' }
  }
end

local colorizer_config = function()
  require 'colorizer'.setup({
    '*';
  })
end

require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'
  use 'Shatur/neovim-ayu'
  use 'monaqa/smooth-scroll.vim'
  use 'vim-jp/vimdoc-ja'
  use 'folke/tokyonight.nvim'
  use 'RRethy/vim-illuminate'
  use 'neovim/nvim-lspconfig'
  use 'onsails/lspkind.nvim'
  use 'cocopon/iceberg.vim'
  use 'EdenEast/nightfox.nvim'
  use 'previm/previm'
  use 'tyru/open-browser.vim'
  use { 'junegunn/vim-easy-align', confing = easy_align_config }
  use { 'numToStr/Comment.nvim', config = comment_config }
  use { 'williamboman/mason-lspconfig.nvim', config = mason_lsp_config }
  use { 'lukas-reineke/indent-blankline.nvim', config = indent_line_config }
  use { 'RRethy/nvim-treesitter-endwise', config = treesitter_config }
  use { 'williamboman/mason.nvim', config = mason_config, }
  use { 'machakann/vim-highlightedyank', config = highlightyank_config }
  use { 'lewis6991/gitsigns.nvim', config = gitsigns_config }
  use { 'vim-scripts/vim-auto-save', config = auto_save_config }
  -- use { 'folke/which-key.nvim', config = which_key_config }
  use { 'nvim-lualine/lualine.nvim', config = lualine_config }
  use { 'kylechui/nvim-surround', config = surround_config, tag = "*" }
  use { 'kdheepak/lazygit.nvim', config = lazygit_config, requires = 'kyazdani42/nvim-web-devicons' }
  use { 'folke/todo-comments.nvim', config = todo_comment_config, requires = 'nvim-lua/plenary.nvim' }
  use { "glepnir/lspsaga.nvim", config = lspsaga_config, branch = "main" }
  use { 'akinsho/bufferline.nvim', config = bufferline_config, tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons' }
  use { 'vim-denops/denops.vim' }
  use { 'skanehira/denops-silicon.vim', config = silicon_config }
  use { 'j-hui/fidget.nvim', config = fidget_config }

  use { 'vim-skk/skkeleton',
    requires = { 'vim-denops/denops.vim', 'uga-rosa/cmp-skkeleton' },
    config = skkelton_config,
  }

  use { 'delphinus/skkeleton_indicator.nvim',
    config = function()
      require 'skkeleton_indicator'.setup {}
    end
  }

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
      { 'L3MON4D3/LuaSnip' },
      { 'saadparwaiz1/cmp_luasnip' },
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

  -- ChatGPT wrapper
  -- use {
  --   "jackMort/ChatGPT.nvim",
  --   config = function()
  --     require("chatgpt").setup({
  --       -- optional configuration
  --     })
  --   end
  -- }

  -- autosave と組み合わせると毎回送信されてしまう。
  -- use { 'skanehira/denops-openai.vim', config = openai_config }
  use { 'mattn/vim-chatgpt' }

  -- browser の textarea で neovim がつかえる。
  -- 別途拡張機能も Install が必要
  use { 'glacambre/firenvim', run = function() fn['firenvim#install'](0) end }

  -- live server <Leader>v
  use { 'barrett-ruth/live-server.nvim', config = live_server_config }

  -- emmet 記法対応プラグイン trigger <c-,>, ex: html:5 <c-,>,
  use { 'mattn/emmet-vim', config = emmet_config }

  -- TSをつかってタグを閉じる
  use { 'windwp/nvim-ts-autotag', config = autotag_config }
  use { 'windwp/nvim-autopairs', config = autopairs_config }

  -- color code に色を表示
  use { 'norcalli/nvim-colorizer.lua', config = colorizer_config }

end)

opt.clipboard:append({ fn.has('mac') == 4 and 'unnamed' or 'unnamedplus' }) -- クリップボード共有
opt.number        = true -- 行数表示
opt.numberwidth   = 6
-- opt.relativenumber = true -- 相対的行数表示
opt.title         = true
opt.shell         = 'fish'
opt.icon          = true
opt.expandtab     = true
opt.tabstop       = 4 -- tag入力の変更
opt.shiftwidth    = 2 -- shift size 2
opt.cursorline    = true -- cursorline highlight
opt.helpheight    = 1000 -- help wndow size
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

-- keymap
g.mapleader = ' '
keymap('n', '*', '*N') -- orverride *
keymap('n', '<S-e>', '$') -- orverride *
keymap('n', '<S-b>', '0') -- orverride *
keymap('n', '<Leader>w', 'ZZ') -- save & close
keymap('n', '<Leader>e', '<cmd>e ~/.config/nvim/init.lua<cr>') -- open init.lua
keymap('n', '<Leader><Leader>', '<cmd>source  ~/.config/nvim/init.lua<cr> <cmd>lua print("Reloaded init.lua")<cr>') -- reload init.lua
keymap('n', '<Leader>m', '<cmd>Mason<cr>') -- open Mason
keymap('n', '<Leader>n', '<cmd>noh<cr>') -- nohighlight
keymap('n', '<Leader>h', '<cmd>checkhealth<cr>') -- checkhelth
keymap('n', '<Leader>s', '<cmd>PackerSync<cr>') -- PackerSync
keymap('n', '<Leader>i', '<cmd>PackerInstall<cr>') -- PackerInstall
keymap('n', '<Leader>p', '<cmd>PrevimOpen<cr>') -- PrevimPreview
keymap('n', 'ss', ':split<CR>enurn><C-w>w') -- split window under
keymap('n', 'sv', ':vsplit<CR>eturn><C-w>w') -- split window left
keymap('n', '<C-w>', '<C-w>w') -- window change focus
keymap('', 'sh', '<C-w>h') -- change focus left
keymap('', 'sk', '<C-w>k') -- change focus top
keymap('', 'sj', '<C-w>j') -- change focus under
keymap('', 'sl', '<C-w>l') -- change focus right
keymap('n', '+', '<C-a>') -- increment
keymap('n', '-', '<C-x>') -- decrement
keymap('n', '<C-a>', 'gg<S-v>G') -- select all
keymap('n', 'gl', ':LazyGit<CR>') -- Open LazyGit
keymap('x', 'ga', '<Plug>(EasyAlign)') -- open EasyAlign
keymap('n', '<C-p>', '<cmd>Telescope find_files hidden=true<CR>') -- grep file
keymap('n', '<C-g>', '<cmd>Telescope live_grep<CR>') -- grep text
keymap('n', '<C-l>', '<cmd>TodoTelescope<CR>') -- grep todo
keymap('n', '<c-o>', '<cmd>Telescope oldfiles theme=get_dropdown hidden=true<CR>') -- grep history
keymap('n', '<c-;>', '<cmd>Telescope commands hidden=true<CR>') -- grep command
keymap('n', '<c-k>', '<cmd>Telescope keymaps hidden=true<CR>') -- grep keymaps
-- keymap('n', '<c-i>', '<cmd>Octo issue list<CR>') -- grep github issue
-- keymap('n', '<c-m>', '<cmd>Octo pr list<CR>') -- grep github pull request
keymap('n', '<c-e>', '<cmd>Fern . -reveal=% -drawer -toggle -width=33<cr>') -- Open or Close Fern
-- keymap('i', '<c-r>', '<Plug>(skkeleton-toggle)')

keymap('n', 'gh', '<cmd>Lspsaga lsp_finder<CR>') -- lsp grep
keymap('n', 'K', '<cmd>Lspsaga hover_doc<CR>') -- lsp doc
keymap('n', 'gk', '<cmd>Lspsaga peek_definition<CR>') -- jump definition
keymap('n', 'gd', '<cmd>Lspsaga goto_definition<CR>') -- jump definition
-- keymap('n', 'ga', '<cmd>Lspsaga code_action<CR>') -- ?
keymap('n', 'gn', '<cmd>Lspsaga rename<CR>') -- rename
keymap('n', 'ge', '<cmd>Lspsaga show_line_diagnostics<CR>') -- show lsp error
keymap('n', '[d', '<cmd>Lspsaga diagnostic_jump_next<CR>') -- jump lsp error
keymap('n', ']d', '<cmd>Lspsaga diagnostic_jump_prev<CR>') -- jump lsp error
