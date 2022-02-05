if status is-interactive
    # Commands to run in interactive sessions can go here
end

""""""""""""""""""""""""""""""
" DB用
""""""""""""""""""""""""""""""
# Mysqlへのパス
set PATH /usr/local/opt/mysql/bin $PATH

""""""""""""""""""""""""""""""
" Laravel 開発用
""""""""""""""""""""""""""""""
# composerへのパス 
set PATH $HOME/.composer/vendor/bin $PATH

set PATH  $HOME/.nodebrew/current/bin $PATH
set PATH  /usr/local/opt/php@8.0/bin $PATH
set PATH  /usr/local/opt/php@8.0/sbin $PATH





"""""""""""""""""""""""""""""
" alias 
"""""""""""""""""""""""""""""
# rmコマンドはゴミ箱に入る用に変更
alias rm='trash'

# git 関係
alias gs='git status'
alias gc='git commit -m'
alias ga='git add'
alias gp='git push'
alisa gp='git pull'

# nvimのエイリアス
alias vi='vim'
alias vim='vim'

# python3をデフォルトにする
alias python='python3'

