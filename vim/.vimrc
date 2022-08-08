"#####################################
"           dein Script
"#####################################

" Required: deinのリポジトリパスを設定
set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim
call dein#begin('$HOME/.cache/dein')
call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')

call dein#add('tiagofumo/vim-nerdtree-syntax-highlight') " NERTDTree syntax
call dein#add('ryanoasis/vim-devicons')                  " icon install
  let g:webdevicons_enable_nerdtree = 1                  " icon enable
  let g:WebDevIconsNerdTreeAfterGlyphPadding = '   '     " icon after space

call dein#add('preservim/nerdtree')                      " エクスプローラーの追加
  let NERDTreeShowHidden = 1                             " 隠しファイルの常時表示
  let g:NERDTreeDirArrows = 1
  map <C-e> :NERDTreeToggle<CR>                          " Ctrl + e エクスプローラー起動

call dein#add('tpope/vim-surround')                      " クォーテーションの切り替え
  nmap ff <Plug>Csurround"'                              " ダブルをシングルに変換
  nmap tt <Plug>Csurround'"                              " シングルをダブルに変換

call dein#add('vim-scripts/vim-auto-save')               " ファイルのオートセーブ
  let g:auto_save = 1                                    " 起動時に自動保存の有効化 OFF :AutoSaveToggle

call dein#add("ctrlpvim/ctrlp.vim")                      " file 検索をCtrl + pで行える。
  let g:ctrlp_show_hidden = 1                            " 隠しファイルも表示する。

call dein#add('itchyny/lightline.vim')                   " ライトラインのビジュアル変更
  let g:lightline = { 'colorscheme': 'wombat'}

call dein#add('nathanaelkane/vim-indent-guides')         " indent guide
  let g:indent_guides_enable_on_vim_startup = 1          " 起動時にindent guideを有効

call dein#add('airblade/vim-gitgutter')                  " gitの差分を表示
  let g:gitgutter_highlight_lines = 1                    " ハイライトの有効化

call dein#add('junegunn/vim-easy-align')                 " align regex
  xmap ga <Plug>(EasyAlign)                              " visual modeでga
  nmap ga <Plug>(EasyAlign)                              " normal modeでga

call dein#add('marcus/rsense')                           " コード補完

call dein#add('thinca/vim-ref')                          " show documents. example :Ref refe Array push.
call dein#add('yuku-t/vim-ref-ri')                       " ドキュメント参照

call dein#add('szw/vim-tags')                            " メソッド定義元へのジャンプ
call dein#add('vim-scripts/ruby-matchit')                "

call dein#add('w0rp/ale')                                " 構文チェック rubocop

call dein#add('ayu-theme/ayu-vim')                       " colortheme ayu
call dein#add('bronson/vim-trailing-whitespace')         " 末尾の全角半角空白文字を赤くハイライト
call dein#add('tomtom/tcomment_vim')                     " コメントアウト コマンド有効化 gcc
call dein#add('pmsorhaindo/syntastic-local-eslint.vim')  " プロジェクトに入ってるESLintを読み込む
call dein#add('vim-jp/vimdoc-ja')                        " ヘルプ日本語化
call dein#add('Shougo/neocomplcache')                    " コード補完
call dein#add('tpope/vim-endwise')                       " end 自動挿入
call dein#add('mattn/emmet-vim')                         " emmet記法有効化

"  未インストールのプラグインをインストール
if dein#check_install()
  call dein#install()
endif

call dein#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""
" Rsense
"""""""""""""""""""""""""""""""""""""""""""""""""""
let g:rsenseHome = '$HOME/.rbenv/shims/rsense'
let g:rsenseUseOmniFunc = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""
" neocomplete.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.ruby = '[^.*\t]\.\w*\|\h\w*::'

"""""""""""""""""""""""""""""""""""""""""""""""""""
" neocomplete.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""
" syntastic_mode_mapをactiveにするとバッファ保存時にsyntasticが走る
" active_filetypesに、保存時にsyntasticを走らせるファイルタイプを指定する
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': ['ruby'] }
let g:syntastic_ruby_checkers = ['rubocop']


""""""""""""""""""""""""""""""
" colorscheme setting
""""""""""""""""""""""""""""""
set t_Co=256                   " 使用色を追加
set termguicolors
filetype on                    " ファイルタイプを検出
filetype indent on             " ファイル対応ごとにインデントをロード
syntax on
colorscheme ayu
  " let ayucolor="light"
  " let ayucolor="mirage"
  let ayucolor="dark"

"""""""""""""""""""""""
" 環境設定
"""""""""""""""""""""""
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

"""""""""""""""""""""""
" 表示関係
"""""""""""""""""""""""
set number                     " 数字の表示
set ruler                      " 現在の行と列を表示する。
set laststatus=2               " ステータスラインを常に表示
set showcmd                    " 入力中のコマンドをステータスに表示する
set title                      " window title の表示

""""""""""""""""""""""
" 編集系
"""""""""""""""""""""""
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

"""""""""""""""""""""""
" 検索系
"""""""""""""""""""""""
set wrapscan                   " 検索時にファイルの最後まで行ったら最初に戻る
set incsearch                  " インクリメンタルサーチ
set hlsearch                   " 検索文字の強調表示
set ignorecase                 " 大文字小文字を区別なく検索する
set smartcase                  " 大文字がある場合は識別する。
set showmatch                  " 正規表現入力時にマッチにジャンプ

