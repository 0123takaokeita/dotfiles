if status is-interactive
    # Commands to run in interactive sessions can go here
end

set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8

# rbrenv config
set -x  PATH $HOME/.rbenb/bin $PATH
status --is-interactive; and source (rbenv init -|psub)

# neovim config
set -x XDG_CONFIG_HOME $HOME/.config
set -x MYVIMRC $HOME/.config/nvim/init.vim


# go 設定
set -x GOPATH $HOME/go
set -x PATH $GOPATH/bin $PATH

# volta 設定
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

# cmd alias
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

# 起動エイリアス
alias lg='lazygit'
alias ld='lazydocker'
alias neo='nvim'
alias vim='nvim'
alias vi='vim'
alias sfish='source ~/.config/fish/config.fish'
alias osaka='curl wttr.in/Osaka'
alias tenki='curl wttr.in/'

# cd directory
alias dot='cd ~/dotfiles; neo nvim/init.vim'
alias bys='cd ~/vm_share/byYourSide; neo'
alias ...='cd ../..'
alias ....='cd ../../..'

# directory 追加のtouch
alias dirch='sh $HOME/dotfiles/fish/mkdir_touch.sh'

# git  alias
alias g='git'
alias ga='git add'
alias gd='git diff'
alias gs='git status'
alias gp='git push'
alias gb='git branch'
alias gbl='git branch -a'
alias gf='git fetch'
alias gc='git commit'
alias gst='git stash'
alias gco='git checkout'
alias gl='git log --oneline'
alias glg="git log --graph --date=short --decorate=short --pretty=format:'%Cgreen%h %Creset%cd %Cblue%cn %Cred%d %Creset%s'"

starship init fish | source
