
"""""""""""""""""""""""
" 環境設定
"""""""""""""""""""""""
scriptencoding cutf-8

"文字コードをUFT-8に設定
set fenc=utf-8

" スワップファイルを作らない
set noswapfile

" クリップボードを共有
set clipboard+=unnamed

" 編集結果非保存のバッファから、新しいバッファを開くときに警告を出さない
set hidden

" ヒストリの保存数指定
set history=50


"""""""""""""""""""""""
" 表示関係
"""""""""""""""""""""""
"  数字の表示
set number

" シンタックスハイライトの有効化
syntax enable

" ステータスラインを常に表示
set laststatus=2

" 括弧入力時の対応する括弧を表示
set showmatch

" 入力中のコマンドをステータスに表示する
set showcmd

" 現在の行を強調表示
set cursorline

" インデントはスマートインデント
set smartindent

" 不可視文字を可視化(タブが「▸-」と表示される)
set list listchars=tab:\▸\-

" Tab文字を半角スペースにする
set expandtab

" 行頭以外のTab文字の表示幅（スペースいくつ分）
set tabstop=2

" 行頭でのTab文字の表示幅
set shiftwidth=2

" 使用配色追加
set t_CO=256

"""""""""""""""""""""""
" 編集系
"""""""""""""""""""""""
" コマンドラインの補完
set wildmode=list:longest

" 行末の1文字先までカーソルを移動できるように
set virtualedit=onemore

" バッファが編集中でもその他のファイルを開けるように
set hidden

" 日本語の行の連結時に空白を入力しない。
set formatoptions+=mM


"""""""""""""""""""""""
" 検索系
"""""""""""""""""""""""
" 検索時にファイルの最後まで行ったら最初に戻る
set wrapscan

" インクリメンタルサーチ
set incsearch

" 検索文字の強調表示
set hlsearch

" 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase

set incsearch
" 検索時に最後まで行ったら最初に戻る

" 検索語をハイライト表示
set hlsearch


"""""""""""""""""""""""""""
" 入力補完"
"""""""""""""""""""""""""""
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>

""""""""""""""""""""""""""""""""""""""""""""
" dein script
""""""""""""""""""""""""""""""""""""""""""""

"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin('$HOME/.cache/dein')

" Let dein manage dein
" Required:
call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')

" Add or remove your plugins here like this:
"call dein#add('Shougo/neosnippet.vim')
"call dein#add('Shougo/neosnippet-snippets')

" カラースキーム変更
call dein#add('morhetz/gruvbox')

" エクスプローラーの追加
call dein#add('preservim/nerdtree')
autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
map <C-e> :NERDTreeToggle<CR>

" クォーテーションの切り替え
call dein#add('tpope/vim-surround')
" ダブルコーテーション→シングルコーテーション
nmap ff <Plug>Csurround"'
" シングルコーテーション→ダブルコーテーション
nmap tt <Plug>Csurround'"

" インデントの視覚化
call dein#add('nathanaelkane/vim-indent-guides')

" Required:
call dein#end()



" 未インストールのプラグインをインストール
if dein#check_install()
    call dein#install()
endif


" Required:
filetype plugin indent on
syntax enable


" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------



