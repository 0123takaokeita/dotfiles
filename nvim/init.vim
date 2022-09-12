"===========================
" plugins
"===========================
set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim
call dein#begin('$HOME/.cache/dein')
call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')

call dein#add('vim-jp/vimdoc-ja')                                     " ヘルプ日本語化
call dein#add('tpope/vim-commentary')                                 " comment out
call dein#add('cormacrelf/vim-colors-github')                         " colortheme github
call dein#add('bronson/vim-trailing-whitespace')                      " 末尾の全角半角空白文字を赤くハイライト cmd: FixWhitespace 末尾のスペース全削除
call dein#add('pmsorhaindo/syntastic-local-eslint.vim')               " プロジェクトに入ってるESLintを読み込む
call dein#add('tpope/vim-endwise')                                    " end 自動挿入
call dein#add('mattn/emmet-vim')                                      " emmet記法有効化
call dein#add('preservim/nerdtree')                                   " エクスプローラーの追加
call dein#add('tpope/vim-surround')                                   " クォーテーションの切り替え
call dein#add('vim-scripts/vim-auto-save')                            " Auto Save
call dein#add('itchyny/lightline.vim')                                " ライトラインのビジュアル変更
call dein#add('delphinus/lightline-delphinus')                        " ライトラインプラグイン
call dein#add('airblade/vim-gitgutter')                               " gitの差分を表示
call dein#add('junegunn/vim-easy-align')                              " align regex コード整形
call dein#add('mattn/vim-maketable')                                  " table 整形 cmd: MakeTable
call dein#add('wakatime/vim-wakatime')                                " トラッキング
call dein#add('nathanaelkane/vim-indent-guides')                      " indent
call dein#add('prabirshrestha/vim-lsp')                               " lsp server
call dein#add('mattn/vim-lsp-settings')                               " lsp settings
call dein#add('dense-analysis/ale')                                   " 静的解析
call dein#add('junegunn/fzf', {'merged': 0})                          " File 検索
call dein#add('junegunn/fzf.vim', {'depends': 'fzf'})                 " File 検索
call dein#add('lambdalisue/fern.vim')                                 " File Tree
call dein#add('lambdalisue/nerdfont.vim')                             " File Tree icon
call dein#add('lambdalisue/fern-renderer-nerdfont.vim')               " File Tree icon, NOTE: コンソールのフォントをNerdにしてください。
call dein#add('lambdalisue/glyph-palette.vim')                        " File Tree Palette
call dein#add('lambdalisue/fern-git-status.vim')                      " Git Status view
call dein#add('lambdalisue/fern-bookmark.vim')                        " File Tree Bookmark
" call dein#add('skanehira/denops-silicon.vim')                         " code 画像生成 :Silicon 出力されない
" call dein#add('segeljakt/vim-silicon')                                " code 画像生成 :Silicon 出力されない
call dein#add('tpope/vim-fugitive')                                   " stutas bar git view
call dein#add('kdheepak/lazygit.nvim')                                " lazygit
call dein#add('ayu-theme/ayu-vim')                                    " theme ayu
call dein#add('morhetz/gruvbox')                                      " theme gruvbox
call dein#add('machakann/vim-highlightedyank')                        " yank highlight
call dein#add('simeji/winresizer')                                    " window changer
call dein#add('zefei/vim-wintabs')                                    " tab view
call dein#add('zefei/vim-wintabs-powerline')                          " tab view powerline
call dein#add('neoclide/coc.nvim', { 'merged': 0, 'rev': 'release' }) " dependence: node >= 14.14
call dein#add('kassio/neoterm') " term

"===========================
" 自動補完 ddc setting
"===========================
" call dein#add('Shougo/ddc.vim')
" call dein#add('vim-denops/denops.vim')
" call dein#add('Shougo/ddc-around')
" call dein#add('Shougo/ddc-matcher_head')

" call ddc#custom#patch_global('sources', ['around'])
" call ddc#custom#patch_global('sourceOptions', {
"     \ '_': {
"     \     'matchers': ['matcher_head'],
"     \ }})
" call ddc#enable()

if dein#check_install()
  call dein#install()
endif

call dein#end()

" 未使用のプラグインを削除
function! DeinClean() abort
  let s:removed_plugins = dein#check_clean()
  if len(s:removed_plugins) > 0
    echom s:removed_plugins
    call map(s:removed_plugins, "delete(v:val, 'rf')")
    call dein#recache_runtimepath()
  endif
endfunction

command! CleanPlugins call DeinClean()

"===========================
" plugin settings
"===========================
let g:auto_save                              = 1 " 自動保存の有効化 OFF :AutoSaveToggle
let g:github_colors_soft                     = 1
let g:github_colors_block_diffmark           = 1 " 差分マークのハイライト表示
let g:indent_guides_enable_on_vim_startup    = 1
let g:ale_linters_explicit                   = 1
let g:fern#default_hidden                    = 1 " 隠しファイル表示
let g:fern#renderer                          = 'nerdfont'
let g:ale_linters                            = {'ruby': ['rubocop']}
let g:airline_theme                          = "github"
let g:lazygit_floating_window_winblend       = 0                    " transparency of floating window
let g:lazygit_floating_window_scaling_factor = 0.9                  " scaling factor for floating window
let g:lazygit_floating_window_corner_chars   = ['╭', '╮', '╰', '╯'] " customize lazygit popup window corner characters
let g:lazygit_floating_window_use_plenary    = 0                    " use plenary.nvim to manage floating window if available
let g:lazygit_use_neovim_remote              = 1                    " fallback to 0 if neovim-remote is not installed
let g:loaded_perl_provider                   = 0
let g:loaded_python3_provider                = 0
let g:highlightedyank_highlight_duration     = 150
let g:winresizer_start_key                   = '<C-w><C-w>'

let g:neoterm_autoinsert = 1
let g:neoterm_autoscroll = 1

" wonbat | PaperColor | github | one | gruvbox | ayu
let g:lightline = {
      \ 'colorscheme': 'PaperColor',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

highlight GitGutterAdd ctermfg=green
highlight GitGutterChange ctermfg=blue
highlight GitGutterDelete ctermfg=red

" Files 検索 で隠しファイル表示
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'source': 'ag --hidden --ignore .git -g ""'}), <bang>0)

"" icon color setting
augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END

"" fzf.vim
fun! FzfOmniFiles()
  let is_git = system('git status')
  if v:shell_error
    :Files
  else
    :GFiles
  endif
endfun

" <S-?>でプレビューを表示/非表示する
command! -bang -nargs=* Rg
\ call fzf#vim#grep(
\ 'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
\ <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 3..'}, 'up:60%')
\ : fzf#vim#with_preview({'options': '--exact --delimiter : --nth 3..'}, 'right:50%', '?'),
\ <bang>0)

"===========================
" system setting
"===========================
set clipboard+=unnamed       " クリップボードを共有
set number                   " view number
set expandtab                " Tabを半角スペースにする
set tabstop=2                " 行頭以外のTab文字の表示幅
set shiftwidth=2             " 行頭でのTab文字の表示幅
set list listchars=tab:\▸\-  " 不可視文字を可視化(タブが「▸-」と表示される)
set smartindent              " インデントはスマートインデント
set helplang=ja
set cursorline
set splitright               " 分割時に右に分割
set splitbelow               " 分割時に下に分割

"===========================
" colorscheme setting
"===========================
filetype on        " ファイルタイプを検出
filetype indent on " ファイル対応ごとにインデントをロード
syntax on
set termguicolors
set t_Co=256       " 使用色を追加
colorscheme github

"===========================
" keymap
"===========================
let g:mapleader = "\<Space>"

" File Tree
nnoremap <C-e>     :Fern . -reveal=% -drawer -toggle -width=40<CR>

"Sercher
nnoremap <C-p>     :call FzfOmniFiles()<CR>
nnoremap <C-g>     :Rg<CR>
nnoremap fr        vawy:Rg <C-R>"<CR>
xnoremap fr        y:Rg <C-R>"<CR>
nnoremap fb        :Buffers<CR>
nnoremap fp        :Buffers<CR><CR>
nnoremap fl        :BLines<CR>
nnoremap fm        :Marks<CR>
nnoremap fh        :History<CR>
nnoremap fc        :Commits<CR>

" code alignment
noremap  <Leader>r :FixWhitespace<CR>
noremap  <Leader>m :MakeTable!<CR>
xmap     ga        <Plug>(EasyAlign)
nmap     ff        <Plug>Csurround"'
nmap     tt        <Plug>Csurround'"

" code image
noremap  <Leader>o :Silicon silicon.png<CR>

" git
nnoremap gl         :LazyGit<CR>
nnoremap g[         :GitGutterPrevHunk<CR>
nnoremap g]         :GitGutterNextHunk<CR>
nnoremap gh         :GitGutterLineHighlightsToggle<CR>
nnoremap gp         :GitGutterPreviewHunk<CR>

" spell_converter
nnoremap <Leader>c  viw:s/\v_(.)/\u\1/g<CR>
nnoremap <Leader>s  viw:s/\%V\([A-Z]\)/_\l\1/g<CR>
xnoremap <Leader>c  :s/\%V\(_\\|-\)\(.\)/\u\2/g<CR>
xnoremap <Leader>s  :s/\%V\([A-Z]\)/_\l\1/g<CR>
