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

-- Open LazyGit
key.set('n', 'gl', ':LazyGit<CR>')

-- vim-gitgutter
key.set('n', 'gh', '<cmd>GitGutterLineHighlightsToggle<cr>')
key.set('n', 'gp', '<cmd>GitGutterPreviewHunk<cr>')

-- telescope
key.set('n', '<C-p>', '<cmd>Telescope find_files<CR>')
key.set('n', '<C-g>', '<cmd>Telescope live_grep<CR>')

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

--No search highlight 
key.set('n', '<esc><esc>', '<cmd>noh<cr>')

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
opt.swapfile      = false
opt.wrap          = false -- 折返し無効
opt.termguicolors = true  -- カラースキームのために
opt.helplang      = 'ja' -- help 日本語化
opt.splitright    = true -- split時に右側に表示する
opt.splitbelow    = true -- split時に下側に表示する
opt.autoread      = true
opt.ignorecase    = true -- 検索時に大文字小文字を区別しない
opt.winblend      = 6


cmd.packadd 'packer.nvim'
cmd([[
  colorscheme tokyonight-night
]])

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'                 -- plugin manager
  use 'tpope/vim-surround'                     -- ex: text object operation. key: <>S([
  use 'tpope/vim-commentary'                   -- comment out key:gcc
  use 'lukas-reineke/indent-blankline.nvim'    -- indent guide
  use {'lambdalisue/fern.vim'}                 -- filer
  use {'lambdalisue/nerdfont.vim',}            -- filer icon
    g['fern#renderer'] = 'nerdfont'
    g['fern#default_hidden'] = true

  use 'lambdalisue/fern-renderer-nerdfont.vim'
  use 'lambdalisue/fern-git-status.vim'
  use 'lambdalisue/glyph-palette.vim'
  use 'lambdalisue/fern-bookmark.vim'

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
    requires = { {'nvim-lua/plenary.nvim'} }
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
end)
