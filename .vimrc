"""""""""""""""""""""
" 環境設定
"""""""""""""""""""""""
scriptencoding cutf-8          "文字コードをUFT-8に設定
set fenc=utf-8                 "文字コードをUTF-８で保存
set noswapfile                 " スワップファイルを作らない
set clipboard+=unnamed         " クリップボードを共有
set hidden                     " 編集結果非保存のバッファから、新しいバッファを開くときに警告を出さない
set history=50                 " ヒストリの保存数指定
set helplang=ja,en             " ヘルプ日本語化


"""""""""""""""""""""""
" 表示関係
"""""""""""""""""""""""
set number                     " 数字の表示
syntax enable                  " シンタックスハイライトの有効化
set laststatus=2               " ステータスラインを常に表示
set showcmd                    " 入力中のコマンドをステータスに表示する
set cursorline                 " 現在の行を強調表示
set smartindent                " インデントはスマートインデント
set list listchars=tab:\▸\-    " 不可視文字を可視化(タブが「▸-」と表示される)
set expandtab                  " Tab文字を半角スペースにする
set tabstop=2                  " 行頭以外のTab文字の表示幅（スペースいくつ分）
set shiftwidth=2               " 行頭でのTab文字の表示幅
set t_CO=256                   " 使用配色追加

"""""""""""""""""""""""
" 編集系
"""""""""""""""""""""""
set wildmode=list:longest      " コマンドラインの補完
set virtualedit=onemore        " 行末の1文字先までカーソルを移動できるように
set hidden                     " バッファが編集中でもその他のファイルを開けるように
set formatoptions+=mM          " 日本語の行の連結時に空白を入力しない。
set backspace=indent,eol,start " バックスペースで削除されるように矯正

"""""""""""""""""""""""
" 検索系
"""""""""""""""""""""""
set wrapscan                   " 検索時にファイルの最後まで行ったら最初に戻る
set incsearch                  " インクリメンタルサーチ
set hlsearch                   " 検索文字の強調表示
set ignorecase                 " 検索文字列が小文字の場合は大文字小文字を区別なく検索する
set incsearch                  " 検索時に最後まで行ったら最初に戻る
set hlsearch                   " 検索語をハイライト表示

"""""""""""""""""""""""""""
" 入力補完"
"""""""""""""""""""""""""""
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap ' ''<LEFT>

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


call dein#add('preservim/nerdtree')                     " エクスプローラーの追加
  map <C-e> :NERDTreeToggle<CR>                         " Ctrl + e エクスプローラー起動
  let NERDTreeShowHidden = 1                            " 隠しファイルの常時表示

call dein#add('tpope/vim-surround')                     " クォーテーションの切り替え
  nmap ff <Plug>Csurround"'
  nmap tt <Plug>Csurround'"

call dein#add('ryanoasis/vim-devicons')                 " icon install
  let g:webdevicons_enable_nerdtree = 1                 " icon 有効化

call dein#add('vim-scripts/vim-auto-save')              " ファイルのオートセーブ
  let g:auto_save = 1                                   " 起動時に自動保存の有効化 OFF :AutoSaveToggle

call dein#add("ctrlpvim/ctrlp.vim")                     " file 検索をCtrl + pで行える。
    let g:ctrlp_show_hidden = 1                         " 隠しファイルも表示する。

call dein#add("cocopon/iceberg.vim")                    " icebergのカラースキーム
call dein#add('morhetz/gruvbox')                        " カラースキーム変更
call dein#add('nathanaelkane/vim-indent-guides')        " インデントの視覚化
call dein#add('bronson/vim-trailing-whitespace')        " 末尾の全角半角空白文字を赤くハイライト
call dein#add('tomtom/tcomment_vim')                    " コメントアウト コマンド有効化 gcc
call dein#add('pmsorhaindo/syntastic-local-eslint.vim') " プロジェクトに入ってるESLintを読み込む
call dein#add('vim-jp/vimdoc-ja')                       " ヘルプ日本語化
call dein#add('Shougo/neocomplcache')                   " コード補完
call dein#add('tpope/vim-endwise')                      " end 自動挿入
call dein#add('scrooloose/syntastic.git')               " Ruby 構文チェック
call dein#add('itchyny/lightline.vim')                  " ライトラインのビジュアル変更
let g:lightline = {
      \ 'colorscheme': 'wombat'
      \ }

" Required:
call dein#end()

" 未インストールのプラグインをインストール
if dein#check_install()
    call dein#install()
endif


" Required:
filetype plugin indent on

"End dein Scripts-------------------------
