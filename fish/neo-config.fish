if status is-interactive
    # Commands to run in interactive sessions can go here
end

# rbrenv path
set -x  PATH $HOME/.rbenb/bin $PATH
status --is-interactive; and source (rbenv init -|psub)

# neovim 設定
set -x XDG_CONFIG_HOME $HOME/.config

# rmコマンドのalias登録
alias rm='trash'

# nvimのエイリアス
alias vi='nvim'
alias vim='vim'

# python3をデフォルトにする
alias python='python3'

# lsコマンドのオプション指定
alias ls='ls -FA'

# 環境変数を改行区切りで表示
alias pathls='echo $PATH | tr " " "\n" | nl'
alias pathfish='echo $fish_user_paths | tr " " "\n" | nl'

alias lg='lazygit'
alias dl='docui'
alias neo='nvim'
alias vim='nvim'
alias vi='vim'
alias s-fish='source ~/.config/fish/config.fish'

alias touch='sh $HOME/dotfiles/fish/mkdir_touch.sh'

# cd directory
alias dot='cd ~/dotfiles; neo nvim/init.vim'
alias bys='cd ~/vm_share/byYourSide; neo'

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
