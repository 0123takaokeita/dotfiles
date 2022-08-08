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

