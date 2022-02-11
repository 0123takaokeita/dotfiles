if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Mysqlパス
set -x PATH /usr/local/opt/mysql/bin $PATH

# Laravel composer パス
set -x PATH $HOME/.composer/vendor/bin $PATH

# nodebrew パス
set -x PATH $HOME/.nodebrew/current/bin $PATH

# PHP パス
set -x PATH /usr/local/opt/php@8.0/bin $PATH
set -x PATH /usr/local/opt/php@8.0/sbin $PATH


# rmコマンドのalias登録
alias rm='trash'

# nvimのエイリアス
alias vi='nvim'
alias vim='nvim'

# python3をデフォルトにする
alias python='python3'

# lsコマンドのオプション指定
alias ls='ls -FA'