" dein dir set variables
let g:rc_dir        = expand('~/.vim')
let s:dein_dir      = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" dein install check
if !isdirectory(s:dein_repo_dir)
  execute '!git clone <https://github.com/Shougo/dein.vim>' s:dein_repo_dir
endif
execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')


" toml に書いたプラグインをロード
if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

" プラグインが install 済みでなければ install する。
if has('vim_starting') && dein#check_install()
  call dein#install()
endif
