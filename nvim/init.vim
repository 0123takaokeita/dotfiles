"===========================
" plugins
"===========================
set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim
call dein#begin('$HOME/.cache/dein')
call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')

call dein#add('vim-jp/vimdoc-ja')                        " ヘルプ日本語化
call dein#add('tpope/vim-commentary')                    " comment out
call dein#add('cormacrelf/vim-colors-github')            " colortheme github
call dein#add('bronson/vim-trailing-whitespace')         " 末尾の全角半角空白文字を赤くハイライト cmd: FixWhitespace 末尾のスペース全削除
call dein#add('pmsorhaindo/syntastic-local-eslint.vim')  " プロジェクトに入ってるESLintを読み込む
call dein#add('tpope/vim-endwise')                       " end 自動挿入
call dein#add('mattn/emmet-vim')                         " emmet記法有効化
call dein#add('preservim/nerdtree')                      " エクスプローラーの追加
call dein#add('tpope/vim-surround')                      " クォーテーションの切り替え
call dein#add('vim-scripts/vim-auto-save')               " ファイルのオートセーブ
call dein#add('itchyny/lightline.vim')                   " ライトラインのビジュアル変更
call dein#add('delphinus/lightline-delphinus')           " ライトラインプラグイン
call dein#add('airblade/vim-gitgutter')                  " gitの差分を表示
call dein#add('junegunn/vim-easy-align')                 " align regex コード整形
call dein#add('mattn/vim-maketable')                     " table 整形 cmd: MakeTable
call dein#add('wakatime/vim-wakatime')                   " トラッキング
call dein#add('nathanaelkane/vim-indent-guides')         " indent
call dein#add('prabirshrestha/vim-lsp')                  " lsp server
call dein#add('mattn/vim-lsp-settings')                  " lsp settings
call dein#add('dense-analysis/ale')                      " 静的解析
call dein#add('junegunn/fzf', {'merged': 0})             " File 検索
call dein#add('junegunn/fzf.vim', {'depends': 'fzf'})    " File 検索
call dein#add('lambdalisue/fern.vim')                    " File Tree
call dein#add('lambdalisue/nerdfont.vim')                " File Tree icon
call dein#add('lambdalisue/fern-renderer-nerdfont.vim')  " File Tree icon, NOTE: コンソールのフォントをNerdにしてください。
call dein#add('lambdalisue/glyph-palette.vim')           " File Tree Palette
call dein#add('lambdalisue/fern-git-status.vim')         " Git Status view
call dein#add('lambdalisue/fern-bookmark.vim')           " File Tree Bookmark
call dein#add('skanehira/denops-silicon.vim')            " code 画像生成 :Silicon
call dein#add('tpope/vim-fugitive')                      " stutas bar git view

"===========================
" 自動補完 ddc setting
"===========================
call dein#add('Shougo/ddc.vim')
call dein#add('vim-denops/denops.vim')
call dein#add('Shougo/ddc-around')
call dein#add('Shougo/ddc-matcher_head')

call ddc#custom#patch_global('sources', ['around'])
call ddc#custom#patch_global('sourceOptions', {
    \ '_': {
    \     'matchers': ['matcher_head'],
    \ }})
call ddc#enable()

if dein#check_install()
  call dein#install()
endif

call dein#end()

"===========================
" plugin settings
"===========================
let g:auto_save                           = 1 " 起動時に自動保存の有効化 OFF :AutoSaveToggle
let g:gitgutter_highlight_lines           = 1 " 差分ハイライト有効化
let g:github_colors_soft                  = 1
let g:github_colors_block_diffmark        = 1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors           = 1
let g:ale_linters_explicit                = 1
let g:fern#default_hidden                 = 1 " 隠しファイル表示
let g:fern#renderer = 'nerdfont'
let g:ale_linters = {'ruby': ['rubocop']}
let g:airline_theme = "github"


" wonbat | PaperColor | github | one
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
\ : fzf#vim#with_preview({'options': '--exact --delimiter : --nth 3..'}, 'right:50%:hidden', '?'),
\ <bang>0)

"===========================
" system setting
"===========================
set clipboard+=unnamed         " クリップボードを共有
set number                     " view number
set expandtab                  " Tabを半角スペースにする
set tabstop=2                  " 行頭以外のTab文字の表示幅
set shiftwidth=2               " 行頭でのTab文字の表示幅
set list listchars=tab:\▸\-    " 不可視文字を可視化(タブが「▸-」と表示される)
set smartindent                " インデントはスマートインデント
set helplang=ja

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
let g:mapleader = "\<Space>" " Leaderキーをスペースに設定
nnoremap <C-e>     :Fern . -reveal=% -drawer -toggle -width=40<CR>
nnoremap <C-p>     :call FzfOmniFiles()<CR>
nnoremap <C-g>     :Rg<CR>
nnoremap <Leader>f vawy:Rg <C-R>"<CR>
xnoremap <Leader>f y:Rg <C-R>"<CR>
noremap  <Leader>r :FixWhitespace<CR>
noremap  <Leader>m :MakeTable!<CR>
noremap  <Leader>o :Silicon silicon.png<CR>
xmap     ga        <Plug>(EasyAlign)
nmap     ff        <Plug>Csurround"'       " ダブルをシングルに変換
nmap     tt        <Plug>Csurround'"       " シングルをダブルに変換