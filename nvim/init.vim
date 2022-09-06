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
call dein#add('tiagofumo/vim-nerdtree-syntax-highlight') " NERTDTree syntax
call dein#add('ryanoasis/vim-devicons')                  " icon install
call dein#add('preservim/nerdtree')                      " エクスプローラーの追加
call dein#add('tpope/vim-surround')                      " クォーテーションの切り替え
call dein#add('vim-scripts/vim-auto-save')               " ファイルのオートセーブ
call dein#add("ctrlpvim/ctrlp.vim")                      " file 検索をCtrl + pで行える。
call dein#add('itchyny/lightline.vim')                   " ライトラインのビジュアル変更
call dein#add('delphinus/lightline-delphinus')           " ライトラインプラグイン
call dein#add('airblade/vim-gitgutter')                  " gitの差分を表示
call dein#add('junegunn/vim-easy-align')                 " align regex
call dein#add('mattn/vim-maketable')                     " table 整形 cmd: MakeTable
call dein#add('wakatime/vim-wakatime')                   " トラッキング
call dein#add('nathanaelkane/vim-indent-guides')         " indent
call dein#add('prabirshrestha/vim-lsp')                  " lsp server
call dein#add('mattn/vim-lsp-settings')                  " lsp settings
call dein#add('dense-analysis/ale')                      " 静的解析

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
let g:webdevicons_enable_nerdtree          = 1         " icon enable
let g:WebDevIconsNerdTreeAfterGlyphPadding = '   '     " icon after space
let g:NERDTreeDirArrows                    = 1
let g:NERDTreeShowHidden                   = 1         " 隠しファイルの常時表示
let g:auto_save                            = 1         " 起動時に自動保存の有効化 OFF :AutoSaveToggle
let g:ctrlp_show_hidden                    = 1         " 隠しファイルも表示する。
let g:gitgutter_highlight_lines            = 1         " ハイライトの有効化
let g:github_colors_soft                   = 1
let g:github_colors_block_diffmark         = 1
let g:indent_guides_enable_on_vim_startup  = 1
let g:indent_guides_auto_colors            = 1
let g:ale_linters_explicit                 = 1
let g:ale_linters = {'ruby': ['rubocop']}
let g:lightline = { 'colorscheme': 'github'}           " lightlineのテーマ指定 wombat or github
let g:airline_theme = "github"

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
map     <C-e>      :NERDTreeToggle<CR>
noremap <Leader>r  :FixWhitespace<CR>
noremap <Leader>m  :MakeTable!<CR>
xmap    ga         <Plug>(EasyAlign)
nmap    ff         <Plug>Csurround"'       " ダブルをシングルに変換
nmap    tt         <Plug>Csurround'"       " シングルをダブルに変換
