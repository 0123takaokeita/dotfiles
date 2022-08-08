if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Mysqlパス
set -x PATH  /usr/local/opt/mysql/bin $PATH

# rbrenv path
set -x  PATH $HOME/.rbenb/bin $PATH
status --is-interactive; and source (rbenv init -|psub)

# pyenv path
set -x PATH $HOME/.pyenv/shims $PATH

set -x PAHT /usr/local/opt/openssl@3/bin $PATH

# phpbrew
source ~/.phpbrew/phpbrew.fish

# Laravel compos
set -x PATH  $HOME/.composer/vendor/bin $PATH

# nodebrew パス
set -x PATH  $HOME/.nodebrew/current/bin $PATH

# PHP パス
# set -x PATH  /usr/local/opt/php@8.0/bin $PATH
# set -x  PATH /usr/local/opt/php@8.0/sbin $PATH


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

# よく使用するディレクトリ
alias paiza='cd /Users/keita_takao/learning/paiza'



