# https://natsukium.github.io/fish-docs-jp/tutorial.html

set -x XDG_CONFIG_HOME $HOME/.config
set -x MYVIMRC $HOME/.config/nvim/init.vim
set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8
set -x GITHUB_UNAME 0123takaokeita
set -x PYENV_ROOT $HOME/.pyenv
set -x ANDROID_HOME $HOME/Library/Android/sdk
set -x CalcSvcClass CalcSvcTakao

set -x LESS -i -M -R -W -z-4 -x4 # less コマンドデフォルトオプション -S は折り返しを無効にする
# set -x LESSOPEN "| src-hilite-lesspipe.sh %s"

set GHQ_SELECTOR peco # C-g でghq list peco
set GHQ_SELECTOR_OPTS --layout=bottom-up --prompt='GHQ >'
set fish_plugins theme peco
function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)' # C-r command history peco
end


# Android config
fish_add_path $ANDROID_HOME/emulator
fish_add_path $ANDROID_HOME/platform-tools

fish_add_path $HOME/go/bin # go 設定
fish_add_path $HOME/.volta/bin # volta 設定

# cmd abbr
abbr lsis 'gh issue list -a $GITHUB_UNAME'
abbr python 'python3'
abbr rm 'trash'
abbr ls 'exa'
abbr la 'exa -la'
abbr ll 'exa -larbghHs name --icons --git'
abbr cat 'bat'
abbr find 'fd'
abbr ps 'procs'
abbr du 'dust'
abbr df 'duf'
abbr top 'btm'
abbr grep 'rg'

# 環境変数を改行区切りで表示
abbr pathls 'echo $PATH | tr " " "\n" | nl'
abbr pathfish 'echo $fish_user_paths | tr " " "\n" | nl'
abbr env 'env | sort'

# 起動エイリアス
abbr lg 'lazygit'
abbr ld 'lazydocker'
abbr vim 'nvim'
abbr vi 'vim'
abbr sfish 'source ~/.config/fish/config.fish'
abbr osaka 'curl wttr.in/Osaka'
abbr go 'richgo'

# cd directory
abbr dot 'cd ~/dotfiles; nvim fish/neo-config.fish'
abbr bys 'cd ~/vm_share/byYourSide; nvim'
abbr rel 'cd ~/vm_share/relief-map/; nvim'
abbr calc 'cd ~/dev/github.com/lobin-z0x50/NeoCalc/CalcLibCore/Takao; nvim'

abbr . 'cd'
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .... 'cd ../../..'

# directory 追加のtouch
abbr dirch 'sh $HOME/dotfiles/fish/mkdir_touch.sh'

# ghqで設定したRootにあるディレクトリをpecoで選択してcd
abbr dev 'cd $(ghq root)/$(ghq list | peco)'

# pecoで選択したHostに接続
abbr sshl 'grep -w Host ~/.ssh/config | peco | awk \'{print $2}\' | xargs -o -n 1 ssh'

# rakel 引数指定なしだったらこれでOK
abbr rakel 'rake -T | peco | awk \'{ print $2 }\' | xargs rake'

# rbrenv config
fish_add_path $HOME/.rbenv/shims
status --is-interactive; and source (rbenv init -|psub)

starship init fish | source

# tea --magic=fish | source  #docs.tea.xyz/magic
