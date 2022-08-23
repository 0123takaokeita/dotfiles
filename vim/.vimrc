"          __
"  __  __ /\_\    ___ ___   _ __   ___
" /\ \/\ \\/\ \ /' __` __`\/\`'__\/'___\
" \ \ \_/ |\ \ \/\ \/\ \/\ \ \ \//\ \__/
"  \ \___/  \ \_\ \_\ \_\ \_\ \_\\ \____\
"   \/__/    \/_/\/_/\/_/\/_/\/_/ \/____/


"===========================
" plugins
"===========================
set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim
call dein#begin('$HOME/.cache/dein')
call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')

call dein#add('vim-jp/vimdoc-ja')                        " ヘルプ日本語化
call dein#add('tomtom/tcomment_vim')                     " コメントアウト コマンド有効化 gcc
call dein#add('cormacrelf/vim-colors-github')            " colortheme github
call dein#add('bronson/vim-trailing-whitespace')         " 末尾の全角半角空白文字を赤くハイライト
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
call dein#add('nathanaelkane/vim-indent-guides')         " indent guide
call dein#add('airblade/vim-gitgutter')                  " gitの差分を表示
call dein#add('junegunn/vim-easy-align')                 " align regex
call dein#add('prabirshrestha/vim-lsp')                  " lsp server
call dein#add('mattn/vim-lsp-settings')                  " lsp settings
call dein#add('mattn/vim-maketable')                     " table 整形
call dein#add('wakatime/vim-wakatime')                   " トラッキング
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

"  未インストールのプラグインをインストール
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
let g:mapleader = "\<Space>" " Leaderキーをスペースに設定
let g:NERDTreeDirArrows                    = 1
let g:webdevicons_enable_nerdtree          = 1         " icon enable
let g:NERDTreeShowHidden                   = 1         " 隠しファイルの常時表示
let g:auto_save                            = 1         " 起動時に自動保存の有効化 OFF :AutoSaveToggle
let g:ctrlp_show_hidden                    = 1         " 隠しファイルも表示する。
let g:indent_guides_enable_on_vim_startup  = 1         " 起動時にindent guideを有効
let g:gitgutter_highlight_lines            = 1         " ハイライトの有効化
let g:github_colors_soft                   = 1
let g:github_colors_block_diffmark         = 1
let g:ale_linters_explicit                 = 1
let g:ale_linters = {'ruby': ['rubocop']}
let g:lightline = { 'colorscheme': 'wombat'}           " lightlineのテーマ指定 wombat or github
let g:airline_theme = "github"
let g:WebDevIconsNerdTreeAfterGlyphPadding = '   '     " icon after space

"===========================
" colorscheme setting
"===========================
filetype on                    " ファイルタイプを検出
filetype indent on             " ファイル対応ごとにインデントをロード
syntax on
colorscheme github

"===========================
" config
"===========================
scriptencoding cutf-8          " 文字コードをUFT-8に設定
set fenc=utf-8                 " 文字コードをUTF-８で保存
set noswapfile                 " スワップファイルを作らない
set clipboard+=unnamed         " クリップボードを共有
set hidden                     " 編集結果非保存のバッファから、新しいバッファを開くときに警告を出さない
set history=50                 " ヒストリの保存数指定
set helplang=ja,en             " ヘルプ日本語化
set nobackup                   " バックアップファイルを作らない
set visualbell t_vb=           " エラーのピープ音/フラッシュをオフ
set novisualbell               " 視覚的なベルをオフ
set syntax=markdown
set termguicolors
set t_Co=256                   " 使用色を追加

"===========================
" view
"===========================
set number                     " 数字の表示
set ruler                      " 現在の行と列を表示する。
set laststatus=2               " ステータスラインを常に表示
set showcmd                    " 入力中のコマンドをステータスに表示する
set title                      " window title の表示

"===========================
" edit
"===========================
set wildmode=list:longest      " コマンドラインの補完
set virtualedit=onemore        " 行末の1文字先までカーソルを移動できるように
set hidden                     " バッファが編集中でもその他のファイルを開けるように
set formatoptions+=mM          " 日本語の行の連結時に空白を入力しない。
set backspace=indent,eol,start " バックスペースの削除を調整
set autoindent                 " 自動インデント設定
set autoindent                 " 改行時にindentをキープ
set smartindent                " インデントはスマートインデント
set list listchars=tab:\▸\-    " 不可視文字を可視化(タブが「▸-」と表示される)
set expandtab                  " Tab文字を半角スペースにする
set tabstop=2                  " 行頭以外のTab文字の表示幅（スペースいくつ分）
set shiftwidth=2               " 行頭でのTab文字の表示幅
set imdisable                  " IME自動OFF

"===========================
" search
"===========================
set wrapscan                   " 検索時にファイルの最後まで行ったら最初に戻る
set incsearch                  " インクリメンタルサーチ
set hlsearch                   " 検索文字の強調表示
set ignorecase                 " 大文字小文字を区別なく検索する
set smartcase                  " 大文字がある場合は識別する。
set showmatch                  " 正規表現入力時にマッチにジャンプ

"===========================
" keymap
"===========================
map <C-e> :NERDTreeToggle<CR>
nmap ff <Plug>Csurround"'       " ダブルをシングルに変換
nmap tt <Plug>Csurround'"       " シングルをダブルに変換
xmap ga <Plug>(EasyAlign)       " visual modeでga
nmap ga <Plug>(EasyAlign)       " normal modeでga

