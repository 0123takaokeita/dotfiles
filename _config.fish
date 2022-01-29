if status is-interactive
    # Commands to run in interactive sessions can go here
end
fish_add_path /usr/local/opt/mysql/bi :n

fish_add_path $HOME/.composer/vendor/bin
# fish_add_path /usr/local/opt/php@7.4/bin
# fish_add_path /usr/local/opt/php@7.4/sbin
fish_add_path $HOME/.nodebrew/current/bin
status --is-interactive; and source (rbenv init -|psub)
 
fish_add_path /usr/local/opt/php@8.0/bin
fish_add_path /usr/local/opt/php@8.0/sbin


# rmコマンドのalias登録
alias rm='trash'

# nvimのエイリアス
alias vi='nvim'
alias vim='nvim'

# python3をデフォルトにする
alias python='python3'

