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
set fish_plugins theme peco
function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)' # C-r command history peco
end


# Android config
fish_add_path $ANDROID_HOME/emulator
fish_add_path $ANDROID_HOME/platform-tools

fish_add_path $HOME/go/bin # go 設定
fish_add_path $HOME/.volta/bin # volta 設定

# cmd alias
alias lsis='gh issue list -a $GITHUB_UNAME'
alias python='python3'
alias rm='trash'
alias ls='exa'
alias la='exa -la'
alias ll='exa -larbghHs name --icons --git'
alias cat='bat'
alias find='fd'
alias ps='procs'
alias du='dust'
alias df='duf'
alias top='btm'
alias grep='rg'

# 環境変数を改行区切りで表示
alias pathls='echo $PATH | tr " " "\n" | nl'
alias pathfish='echo $fish_user_paths | tr " " "\n" | nl'
alias env='env | sort'

# 起動エイリアス
alias lg='lazygit'
alias ld='lazydocker'
alias neo='nvim'
alias vim='nvim'
alias vi='vim'
alias sfish='source ~/.config/fish/config.fish'
alias osaka='curl wttr.in/Osaka'
alias go='richgo'

# cd directory
alias dot='cd ~/dotfiles; vim fish/neo-config.fish'
alias bys='cd ~/vm_share/byYourSide; vim'
alias rel='cd ~/vm_share/relief-map/; vim'
alias calc='cd ~/dev/github.com/lobin-z0x50/NeoCalc/CalcLibCore/Takao; neo'

alias .='cd'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# directory 追加のtouch
alias dirch='sh $HOME/dotfiles/fish/mkdir_touch.sh'

# ghqで設定したRootにあるディレクトリをpecoで選択してcd
alias dev='cd $(ghq root)/$(ghq list | peco)'

# pecoで選択したHostに接続
alias sshl='grep -w Host ~/.ssh/config | peco | awk \'{print $2}\' | xargs -o -n 1 ssh'

# rbrenv config
fish_add_path $HOME/.rbenv/shims
status --is-interactive; and source (rbenv init -|psub)

starship init fish | source

# tea --magic=fish | source  #docs.tea.xyz/magic
