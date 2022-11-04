"===========================
" Plugins
"===========================
set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim
call dein#begin('$HOME/.cache/dein')
call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')

call dein#add('vim-jp/vimdoc-ja')                                     " ヘルプ日本語化
call dein#add('cormacrelf/vim-colors-github')                         " colortheme github
call dein#add('bronson/vim-trailing-whitespace')                      " 末尾の全角半角空白文字を赤くハイライト cmd: FixWhitespace 末尾のスペース全削除
call dein#add('pmsorhaindo/syntastic-local-eslint.vim')               " プロジェクトに入ってるESLintを読み込む
call dein#add('tpope/vim-endwise')                                    " end 自動挿入
call dein#add('mattn/emmet-vim')                                      " emmet記法有効化
call dein#add('preservim/nerdtree')                                   " エクスプローラーの追加
call dein#add('tpope/vim-commentary')                                 " comment out
call dein#add('tpope/vim-surround')                                   " text object を囲う
call dein#add('tpope/vim-repeat')                                     " surround を . で repeat
call dein#add('machakann/vim-sandwich')                               " テキストオブジェクトの囲いを編集
call dein#add('machakann/vim-highlightedyank')                        " yank highlight
call dein#add('tpope/vim-fugitive')                                   " stutas bar git view
call dein#add('vim-scripts/vim-auto-save')                            " Auto Save
call dein#add('itchyny/lightline.vim')                                " ライトラインのビジュアル変更
call dein#add('delphinus/lightline-delphinus')                        " ライトラインプラグイン
call dein#add('airblade/vim-gitgutter')                               " gitの差分を表示
call dein#add('junegunn/vim-easy-align')                              " align regex コード整形
call dein#add('mattn/vim-maketable')                                  " table 整形 cmd: MakeTable
call dein#add('wakatime/vim-wakatime')                                " トラッキング
call dein#add('nathanaelkane/vim-indent-guides')                      " indent
call dein#add('dense-analysis/ale')                                   " 静的解析
call dein#add('junegunn/fzf', {'merged': 0})                          " File 検索
call dein#add('junegunn/fzf.vim', {'depends': 'fzf'})                 " File 検索
call dein#add('lambdalisue/fern.vim')                                 " File Tree
call dein#add('lambdalisue/nerdfont.vim')                             " File Tree icon
call dein#add('lambdalisue/fern-renderer-nerdfont.vim')               " File Tree icon, NOTE: コンソールのフォントをNerdにしてください。
call dein#add('lambdalisue/glyph-palette.vim')                        " File Tree Palette
call dein#add('lambdalisue/fern-git-status.vim')                      " Git Status view
call dein#add('lambdalisue/fern-bookmark.vim')                        " File Tree Bookmark
call dein#add('kdheepak/lazygit.nvim')                                " lazygit
call dein#add('ayu-theme/ayu-vim')                                    " theme ayu
call dein#add('morhetz/gruvbox')                                      " theme gruvbox
call dein#add('folke/tokyonight.nvim', { 'branch': 'main' })          " theme tokyonight
call dein#add('sainnhe/everforest')                                   " theme everforest
call dein#add('AhmedAbdulrahman/aylin.vim')                           " theme aylin
call dein#add('neoclide/coc.nvim', { 'merged': 0, 'rev': 'release' }) " dependence: node >= 14.14, setting-check: :checkhealth
call dein#add('ryanoasis/vim-devicons')                               " add icon
call dein#add('yuezk/vim-js')                                         " js syntax
call dein#add('maxmellon/vim-jsx-pretty')                             " React syntax
call dein#add('vim-denops/denops.vim')                                " deno
call dein#add('skanehira/denops-silicon.vim')                         " dependence: denops.vim Deno v12.5.0
call dein#add('cespare/vim-toml')                                     " toml syntax highlight
call dein#add('KabbAmine/vCoolor.vim')                                " color picker
call dein#add('luochen1990/rainbow')                                  " bracket rainbow
call dein#add('monaqa/smooth-scroll.vim')                             " scroll smooth
"===========================
" 自動補完 ddc setting
"===========================
" call dein#add('prabirshrestha/vim-lsp')                               " lsp server
" call dein#add('mattn/vim-lsp-settings')                               " lsp settings
" call dein#add('Shougo/ddc.vim')
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
" Colorscheme Setting
"===========================
syntax   on
filetype on                     " ファイルタイプを検出
filetype plugin indent on       " ファイル対応ごとにインデントをロード
set      termguicolors
set      t_Co=256               " 使用色を追加

let ayucolor                = 'dark' " light or mirage or dark
let g:gruvbox_contrast_dark = 'hard' " soft or hard
" github or ayu or gruvbox or tokyonight-storm or tokyonight-night or everforest or aylin
colorscheme tokyonight-night

" set      pumblend=10 " pop-up の透明度設定 5 ~ 30 くらいが標準
" hi CocMenuSel ctermbg=237 guibg=#13354A
hi CocFloating ctermbg=237 guibg=#13354A

"===========================
" Plugin Settings
"===========================
let g:auto_save                           = 1 " 自動保存の有効化 OFF :AutoSaveToggle
let g:highlightedyank_highlight_duration  = 150
let g:indent_guides_enable_on_vim_startup = 1
let g:jsx_ext_required                    = 0
let g:airline#extensions#ale#enabled      = 1
let g:rainbow_active                      = 1 "set to 0 if you want to enable it later via :RainbowToggle

" ###########
" emmet
" ###########
let g:user_emmet_leader_key='<C-K>'

" ###########
" gitgutter
" ###########
let g:github_colors_soft                       = 1
let g:github_colors_block_diffmark             = 1 " 差分マークのハイライト表示

" ###########
" lazygit
" ###########
let g:lazygit_floating_window_scaling_factor   = 1 " scaling factor for floating window
let g:lazygit_floating_window_winblend = 0 " transparency of floating window
let g:lazygit_floating_window_corner_chars = ['╭', '╮', '╰', '╯'] " customize lazygit popup window corner characters

" ###########
" ale
" ###########
" dependence: solargraph, rbenv を使用している場合 version ごとに install
let g:ale_linters_explicit           = 1
let g:ale_lint_on_text_changed       = 1
let g:ale_fixe_on_save               = 1
let g:ale_sign_error                 = '☒'
let g:ale_sign_warning               = '⚠'
let g:ale_completion_autoimport      = 1
" let g:ale_ruby_rubocop_executable    = 'bundle'

let g:ale_linters = {
      \'ruby': ['rubocop'],
      \'typescript': ['eslint', 'tsserver']
      \}
      " \'javascript': ['eslint', 'tsserver'],

" coc
" ###########
let g:loaded_perl_provider                     = 0
let g:loaded_python3_provider                  = 0
let g:loaded_ruby_provider                     = 0

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" ###########
" light line
" ###########
" wonbat | PaperColor | github | one | gruvbox | ayu | tokyonight
let g:lightline = {
      \ 'colorscheme': 'tokyonight',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component': {
      \    'lineinfo': '%3l:%-2v%<',
      \    'charvaluehex': '0x%B'
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
      \ }

" ###########
" Fern
" ###########
let g:fern#default_hidden = 1 " 隠しファイル表示
let g:fern#renderer       = 'nerdfont'

function! s:init_fern() abort
  nmap <buffer> d <Plug>(fern-action-remove)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
augroup END

augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern call glyph_palette#apply()
  autocmd FileType nerdtree,startify call glyph_palette#apply()
augroup END

" ###########
"  fzf.vim
" ###########
fun! FzfOmniFiles()
  let is_git = system('git status')
  if v:shell_error
    :Files
  else
    " :GFiles とりあえずどちらもFiles
    :Files
  endif
endfun

" Files 検索 で隠しファイル表示
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'source': 'ag --hidden --ignore .git -g ""'}), <bang>0)

" <S-?>でプレビューを表示/非表示する
command! -bang -nargs=* Rg
\ call fzf#vim#grep(
\ 'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
\ <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 3..'}, 'up:60%')
\ : fzf#vim#with_preview({'options': '--exact --delimiter : --nth 3..'}, 'right:50%', '?'),
\ <bang>0)


" ###########
" Silicon
" ###########
let g:silicon_options = {
      \  'font': 'HackGen35Nerd',
      \  'theme': 'Solarized (dark)',
      \  'no_line_number': v:false,
      \  'no_round_corner': v:false,
      \  'no_window_controls': v:false,
      \  'background_color': '#434C5E',
      \  'line_offset': 1,
      \  'line_pad': 2,
      \  'pad_horiz': 80,
      \  'pad_vert': 100,
      \  'shadow_blur_radius': 0,
      \  'shadow_color': '#555555',
      \  'shadow_offset_x': 0,
      \  'shadow_offset_y': 0,
      \  'tab_width': 4,
      \ }

"===========================
" System Setting
"===========================
set clipboard+=unnamed      " クリップボードを共有
set number                  " view number
set expandtab               " Tabを半角スペースにする
set list listchars=tab:\▸\- " 不可視文字を可視化(タブが「▸-」と表示される)
set helplang=ja             " help 日本語
set cursorline              " 横のカーソルラインをハイライト
set splitright              " 分割時に右に分割
set splitbelow              " 分割時に下に分割
set nowrap                  " 折返無効化
set autoread                " 自動読込
set virtualedit=onemore     " 行末の1文字先までカーソルを移動できるように
set ignorecase              " 大文字小文字を区別なく検索する
" set ambiwidth=double

set tabstop=4
set shiftwidth=4
set autoindent
set smartindent

augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.rb   setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.vim  setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.js   setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.jsx  setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.ts   setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.tsx  setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.html setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.json setlocal tabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.lua  setlocal tabstop=2 shiftwidth=2
augroup END


"===========================
" Keymap
"===========================
let g:mapleader = "\<Space>"

" File Tree
nnoremap <C-e>          :Fern . -reveal=% -drawer -toggle -width=30<CR>

"Sercher
nnoremap <C-p>          :call FzfOmniFiles()<CR>
nnoremap <C-g>          :Rg<CR>
nnoremap fr             vawy:Rg <C-R>"<CR>
xnoremap fr             y:Rg <C-R>"<CR>
nnoremap fb             :Buffers<CR>
nnoremap fp             :Buffers<CR><CR>
nnoremap fl             :BLines<CR>
nnoremap fm             :Marks<CR>
nnoremap fh             :History<CR>
nnoremap fc             :Commits<CR>

" Code Alignment
noremap  <Leader>r      :FixWhitespace<CR>
noremap  <Leader>m      :MakeTable!<CR>
xmap     ga             <Plug>(EasyAlign)
nmap     ff             <Plug>Csurround"'
nmap     tt             <Plug>Csurround'"

" Silicon Copy clip board
noremap  <Leader>o      :Silicon<CR>

" Git
nnoremap gl             :LazyGit<CR>

nnoremap g[             :GitGutterPrevHunk<CR>
nnoremap g]             :GitGutterNextHunk<CR>
nnoremap gh             :GitGutterLineHighlightsToggle<CR>
nnoremap gp             :GitGutterPreviewHunk<CR>

" Spell Converter
nnoremap <Leader>cc      viw:s/\v_(.)/\u\1/g<CR>
nnoremap <Leader>cs      viw:s/\%V\([A-Z]\)/_\l\1/g<CR>
xnoremap <Leader>cc      :s/\%V\(_\\|-\)\(.\)/\u\2/g<CR>
xnoremap <Leader>cs      :s/\%V\([A-Z]\)/_\l\1/g<CR>

" Util
noremap *               *N
noremap <Leader>w       ZZ
noremap <Leader>q       :q!<CR>
noremap <Leader>s       :vsplit<CR>

" Source
noremap <silent> <Leader><Leader> :source $MYVIMRC<CR>
noremap <silent> <Leader>e :e $MYVIMRC<CR>

" VCooler
noremap <Leader>p :VCoolor<CR>

" coc
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
nnoremap <silent> K  :call ShowDocumentation()<CR>
