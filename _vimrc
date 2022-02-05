



"""""""""""""""""""""""
" 環境設定
"""""""""""""""""""""""
scriptencoding cut-8

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




"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/takaokeita/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin('/Users/takaokeita/.cache/dein')

" Let dein manage dein
" Required:
call dein#add('/Users/takaokeita/.cache/dein/repos/github.com/Shougo/dein.vim')

" Add or remove your plugins here like this:
"call dein#add('Shougo/neosnippet.vim')
"call dein#add('Shougo/neosnippet-snippets')
call dein#add('preservim/nerdtree')


" Required:
call dein#end()

" Required:
filetype plugin indent on



" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------



