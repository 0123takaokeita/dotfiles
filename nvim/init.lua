-- alias to vim's objects
g   = vim.g
o   = vim.o
opt = vim.opt
cmd = vim.cmd
fn  = vim.fn
api = vim.api
key = vim.keymap

-- keymap
g.mapleader = " "
key.set('n', '<Leader>w', 'ZZ')
key.set('n', '<Leader>e', '<cmd>e ~/.config/nvim/init.lua<cr>')
key.set('n', '<Leader><Leader>', '<cmd>source  ~/.config/nvim/init.lua<cr> <cmd>lua print("Reloaded init.lua")<cr>')
key.set('n', '*','*N')
key.set('n', '<Leader>zf', '<cmd>set foldmethod=indent<cr>')
key.set('n', '<Leader>m', '<cmd>Mason<cr>')

-- Open LazyGit
key.set('n', 'gl', ':LazyGit<CR>')

-- vim-gitgutter
key.set('n', 'gh', '<cmd>GitGutterLineHighlightsToggle<cr>')
key.set('n', 'gp', '<cmd>GitGutterPreviewHunk<cr>')

-- telescope
key.set('n', '<C-p>', '<cmd>Telescope find_files hidden=true<CR>')
key.set('n', '<C-g>', '<cmd>Telescope live_grep hidden=true<CR>')

-- Split window
key.set('n', 'ss', ':split<CR>eturn><C-w>w')
key.set('n', 'sv', ':vsplit<CR>eturn><C-w>w')

-- Move window
key.set('n','<C-w>', '<C-w>w')
key.set('', 'sh', '<C-w>h')
key.set('', 'sk', '<C-w>k')
key.set('', 'sj', '<C-w>j')
key.set('', 'sl', '<C-w>l')

-- Exec Fern
key.set('n', '<C-e>', ':Fern . -reveal=% -drawer -toggle -width=33<CR>')

-- Exec EasyAlign
key.set('x', 'ga', '<Plug>(EasyAlign)')

-- Increment/decrement
key.set('n', '+', '<C-a>')
key.set('n', '-', '<C-x>')

-- Select all
key.set('n', '<C-a>', 'gg<S-v>G')

-- Surround
key.set('n', 'ff', '<plug>Csurround"\'')
key.set('n', 'tt', '<plug>Csurround\'"')

o.cmdheight = 4 -- コマンド表示領域

-- クリップボード共有
opt.clipboard:append({ fn.has('mac') == 4 and 'unnamed' or 'unnamedplus' })

opt.number        = true  -- 行数表示
opt.title         = true
opt.shell         = 'fish'
opt.expandtab     = true
opt.tabstop       = 4     -- tag入力の変更
opt.shiftwidth    = 2
opt.cursorline    = true
opt.swapfile      = false -- swapfileを作らない
opt.wrap          = false -- 折返し無効
opt.termguicolors = true  -- カラースキームのために
opt.helplang      = 'ja'  -- help 日本語化
opt.splitright    = true  -- split時に右側に表示する
opt.splitbelow    = true  -- split時に下側に表示する
opt.autoread      = true
opt.ignorecase    = true  -- 検索時に大文字小文字を区別しない
opt.winblend      = 6


cmd.packadd 'packer.nvim'
cmd([[
  colorscheme tokyonight-night
]])

-- nvim-cmp
local nvim_cmp_config = function()
  local cmp = require('cmp')
  cmp.setup({
    window = {
      -- completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    preselect = cmp.PreselectMode.None,
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ["<C-p>"] = cmp.mapping.select_prev_item(),
      ["<C-n>"] = cmp.mapping.select_next_item(),
      ['<Tab>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
    sources = {
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
      { name = 'buffer', option = {
        get_bufnrs = function()
          local bufs = {}
          for _, win in ipairs(api.nvim_list_wins()) do
            bufs[api.nvim_win_get_buf(win)] = true
          end
          return vim.tbl_keys(bufs)
        end
      } },
      { name = 'path' },
    },
    snippet = {
      expand = function(args)
        fn['vsnip#anonymous'](args.body)
      end
    },
  })
end

return require('packer').startup(function()
  use 'wbthomason/packer.nvim'                 -- plugin manager
  use 'tpope/vim-surround'                     -- ex: text object operation. key: <>S([
  use 'tpope/vim-commentary'                   -- comment out key:gcc
  use 'lambdalisue/fern.vim'                  -- filer
  use 'lambdalisue/nerdfont.vim'            -- filer icon
    g['fern#renderer'] = 'nerdfont'
    g['fern#default_hidden'] = true

  use 'lambdalisue/fern-renderer-nerdfont.vim'
  use 'lambdalisue/fern-git-status.vim'

  use 'machakann/vim-highlightedyank'          -- yank highlight
    g.highlightedyank_highlight_duration = 100 -- duration time

  use 'junegunn/vim-easy-align'                -- text align
  use 'vim-jp/vimdoc-ja'                       -- help ja
  use 'airblade/vim-gitgutter'                 -- git status view

  use 'vim-scripts/vim-auto-save'              -- auto save
    g.auto_save       = true

  use 'kdheepak/lazygit.nvim' 
    g.lazygit_floating_window_scaling_factor = 1  -- window size
    g.lazygit_floating_window_winblend       = 0 -- window transparency


  use {
   'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = {
        'nvim-lua/plenary.nvim',
        'kyazdani42/nvim-web-devicons',
    }
  }

  use 'folke/tokyonight.nvim'
  use {
   "folke/todo-comments.nvim",
   requires = "nvim-lua/plenary.nvim",
   config = function()
     require("todo-comments").setup {
       -- your configuration comes here
       -- or leave it empty to use the default settings
       -- refer to the configuration section below
     }
   end
  }
 
  use({"folke/noice.nvim",
	config = function()
	  require("noice").setup({
		  -- add any options here
        })
      end,
    presets = {
      bottom_search         = true,  -- use a classic bottom cmdline for search
      command_palette       = true,  -- position the cmdline and popupmenu together
      long_message_to_split = true,  -- long messages will be sent to a split
      inc_rename            = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border        = false, -- add a border to hover docs and signature help
    },
    requires = {
     -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
     "MunifTanjim/nui.nvim",
	 -- OPTIONAL:
	 --   `nvim-notify` is only needed, if you want to use the notification view.
	 --   If not available, we use `mini` as the fallback
	 "rcarriga/nvim-notify",
     }
  })

  use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
  use { "williamboman/mason.nvim" }
  require("mason").setup({
   ui = {
       icons = {
           package_installed   = "✓",
           package_pending     = "➜",
           package_uninstalled = "✗"
       }
     }
  })

  use 'williamboman/mason-lspconfig.nvim'
  require("mason-lspconfig").setup({
    ensure_installed = { 'sumneko_lua', 'rust_analyzer', 'ruby_ls' },
    automatic_installation = true,
  })

  -- TODO: Progress
  --
  -- complete
  use {
    'hrsh7th/nvim-cmp',
    module = { "cmp" },
    requires = {
      { 'hrsh7th/cmp-nvim-lsp', event = { 'InsertEnter' } },
      { 'hrsh7th/cmp-buffer', event = { 'InsertEnter' } },
      { 'hrsh7th/cmp-path', event = { 'InsertEnter' } },
      { 'hrsh7th/cmp-vsnip', event = { 'InsertEnter' } },
      { 'hrsh7th/vim-vsnip', event = { 'InsertEnter' } },
      { 'hrsh7th/cmp-cmdline', event = { 'CmdlineEnter' } },
    },
    config = nvim_cmp_config,
  }

  require'lspconfig'.solargraph.setup{}
  local nvim_lsp = require('lspconfig')
  local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    --Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gD',        '<Cmd>lua vim.lsp.buf.declaration()<CR>',                                opts)
    buf_set_keymap('n', 'gd',        '<Cmd>lua vim.lsp.buf.definition()<CR>',                                 opts)
    buf_set_keymap('n', 'K',         '<Cmd>lua vim.lsp.buf.hover()<CR>',                                      opts)
    buf_set_keymap('n', 'gi',        '<cmd>lua vim.lsp.buf.implementation()<CR>',                             opts)
    buf_set_keymap('n', '<C-k>',     '<cmd>lua vim.lsp.buf.signature_help()<CR>',                             opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>',                       opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>',                    opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D',  '<cmd>lua vim.lsp.buf.type_definition()<CR>',                            opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>',                                     opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>',                                opts)
    buf_set_keymap('n', 'gr',        '<cmd>lua vim.lsp.buf.references()<CR>',                                 opts)
    buf_set_keymap('n', '<space>e',  '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',               opts)
    buf_set_keymap('n', '[d',        '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',                           opts)
    buf_set_keymap('n', ']d',        '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>',                           opts)
    buf_set_keymap('n', '<space>q',  '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>',                         opts)
    buf_set_keymap("n", "<space>f",  "<cmd>lua vim.lsp.buf.formatting()<CR>",                                 opts)
  end
  -- Use a loop to conveniently call 'setup' on multiple servers and
  -- map buffer local keybindings when the language server attaches
  local servers = { "solargraph" }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
      flags = {
        debounce_text_changes = 150,
      }
    }
  end

  -- END
end)
