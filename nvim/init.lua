-- alias to vim's objects
g   = vim.g
opt = vim.opt
cmd = vim.cmd
fn  = vim.fn
api = vim.api
key = vim.keymap


-- keymap
g.mapleader = " "
key.set('n', '<Leader>w', ':wq<CR>')

-- g.filetype plugin on -- 標準ファイラ
g.netrw_liststyle  = 1 -- " ファイルツリーの表示形式、1にするとls -laのような表示になります
g.netrw_banner     = 0 -- " ヘッダを非表示にする
g.netrw_sizestyle  = "H" -- " サイズを(K,M,G)で表示する
g.netrw_timefmt    = "%Y/%m/%d(%a) %H:%M:%S" -- " 日付フォーマットを yyyy/mm/dd(曜日) hh:mm:ss で表示する
g.netrw_preview    = 1 -- " プレビューウィンドウを垂直分割で表示する

-- config
opt.cmdheight      = 1
opt.showcmd        = 1
opt.tabstop        = 4
opt.shiftwidth     = 4
opt.number         = 1
opt.clipboard      = 'unnamedplus'
opt.expandtab      = 1
opt.list listchars = tab:\▸\- -- 不可視文字を可視化(タブが「▸-」と表示される)
opt.cursorline                -- 横のカーソルラインをハイライト
opt.splitright                -- 分割時に右に分割
opt.splitbelow                -- 分割時に下に分割
opt.nowrap
opt.autoread
opt.ignorecase
opt.noswapfile
opt.autoindent
opt.smartindent

-- 透過設定がしたければ
-- vim.opt.winblend = 20
-- vim.opt.pumblend = 20
-- vim.opt.termguicolors=true
