# https://natsukium.github.io/fish-docs-jp/tutorial.html

set -x XDG_CONFIG_HOME $HOME/.config
set -x MYVIMRC $HOME/.config/nvim/init.vim
set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8
set -x GITHUB_UNAME 0123takaokeita
set -x PYENV_ROOT $HOME/.pyenv
set -x ANDROID_HOME $HOME/Library/Android/sdk
set -x CalcSvcClass CalcSvcTakao
set -x FZF_DEFAULT_COMMAND 'fd --type f'
set -x BITWARDENCLI_APPDATA_DIR $HOME/.bw
set -Ux VOLTA_HOME $HOME/.volta
set -x LESS -i -M -R -W -z-4 -x4 # less コマンドデフォルトオプション -S は折り返しを無効にする
set -x GHQ_ROOT $HOME/dev
set -x SSH_KEY_PATH $HOME/.ssh/id_rsa
set GHQ_SELECTOR peco # C-g でghq list fzf
set GHQ_SELECTOR_OPTS --layout=bottom-up --prompt='GHQ >'
set -gx PATH /usr/local/opt/mysql@8.0/bin $PATH
set -gx PATH /opt/homebrew/bin $PATH

# C-r command history peco
function fish_user_key_bindings
  bind \cr 'peco_select_history (commandline -b)'
end

function sail
    if test -f ./sail
        bash ./sail $argv
    else
        bash ./vendor/bin/sail $argv
    end
end

function bedrock
    env \
        ANTHROPIC_MODEL=arn:aws:bedrock:ap-northeast-1:026818612579:application-inference-profile/2taz2zrclqsy \
        AWS_REGION=ap-northeast-1 \
        AWS_PROFILE=flyle-bedrock \
        CLAUDE_CODE_ENABLE_AUTO_MODE=1 \
        CLAUDE_CODE_USE_BEDROCK=1 \
        claude $argv
end

function nexus_status
  bash /private/tmp/claude-501/-Volumes-EXSSD-dev-github-com-flyle-io-flyle-nexus/e28809b1-00eb-4eee-a18f-82650dfa930e/scratchpad/dev-status.sh
end

# herdr workspace に main + 複数 worktree tab を冪等にセットアップする
# 使い方: herdr-setup-worktrees [--repo <path>] [--base <branch>] [--label <workspace-label>] <wt-name> ...
# --repo 省略時は $HOME/dev/github.com/flyle-io/flyle-nexus を対象にする
function herdr-setup-worktrees --description 'herdr で main + worktree tab を冪等に一括作成する'
    set -l default_repo $HOME/dev/github.com/flyle-io/flyle-nexus
    argparse 'repo=' 'base=' 'label=' -- $argv
    or return 1

    if test (count $argv) -lt 1
        echo "usage: herdr-setup-worktrees [--repo <path>] [--base <branch>] [--label <workspace-label>] <wt-name> ..." >&2
        return 1
    end

    set -l repo_arg $_flag_repo
    if test -z "$repo_arg"
        set repo_arg $default_repo
    end

    if not test -d $repo_arg
        echo "error: directory not found: $repo_arg" >&2
        return 1
    end

    set -l repo_path (realpath $repo_arg)
    set -l wt_names $argv

    if not git -C $repo_path rev-parse --is-inside-work-tree >/dev/null 2>&1
        echo "error: not a git repository: $repo_path" >&2
        return 1
    end

    set -l ws_label $_flag_label
    if test -z "$ws_label"
        set ws_label (basename $repo_path)
    end

    set -l ws_id (herdr workspace list | jq -r --arg label "$ws_label" '.result.workspaces[] | select(.label == $label) | .workspace_id')
    set -l main_tab_id

    if test -z "$ws_id"
        echo "workspace '$ws_label' が見つからないため新規作成します"
        set -l create_result (herdr workspace create --cwd $repo_path --label $ws_label)
        set ws_id (echo $create_result | jq -r '.result.workspace.workspace_id')
        set main_tab_id (echo $create_result | jq -r '.result.tab.tab_id')
        herdr tab rename $main_tab_id main >/dev/null
    else
        set main_tab_id (herdr tab list --workspace $ws_id | jq -r '.result.tabs[] | select(.label == "main") | .tab_id')
        if test -z "$main_tab_id"
            echo "main タブが見つからないため作成します"
            set -l create_result (herdr tab create --workspace $ws_id --cwd $repo_path --label main --no-focus)
            set main_tab_id (echo $create_result | jq -r '.result.tab.tab_id')
        end
    end

    _herdr_split_if_needed $ws_id $main_tab_id

    for wt_name in $wt_names
        set -l tab_id (herdr tab list --workspace $ws_id | jq -r --arg label "$wt_name" '.result.tabs[] | select(.label == $label) | .tab_id')
        if test -n "$tab_id"
            _herdr_split_if_needed $ws_id $tab_id
            continue
        end

        set -l wt_path $repo_path/.claude/worktrees/$wt_name

        if not git -C $repo_path worktree list --porcelain | grep -qxF "worktree $wt_path"
            set -l base_ref $_flag_base
            if test -z "$base_ref"
                set base_ref HEAD
            end
            echo "git worktree '$wt_name' が見つからないため作成します (base: $base_ref)"
            git -C $repo_path worktree add $wt_path -b $wt_name $base_ref
            or return 1
        end

        echo "tab '$wt_name' を作成します"
        set -l create_result (herdr tab create --workspace $ws_id --cwd $wt_path --label $wt_name --no-focus)
        set -l new_tab_id (echo $create_result | jq -r '.result.tab.tab_id')
        _herdr_split_if_needed $ws_id $new_tab_id
    end
end

# tab が単一 pane のままなら上下 split する（herdr-setup-worktrees の内部ヘルパー）
function _herdr_split_if_needed
    set -l ws_id $argv[1]
    set -l tab_id $argv[2]

    set -l pane_count (herdr tab list --workspace $ws_id | jq -r --arg tid "$tab_id" '.result.tabs[] | select(.tab_id == $tid) | .pane_count')
    if test "$pane_count" = "1"
        set -l pane_id (herdr pane list --workspace $ws_id | jq -r --arg tid "$tab_id" '.result.panes[] | select(.tab_id == $tid) | .pane_id')
        herdr pane split $pane_id --direction down --no-focus >/dev/null
    end
end


# Android config
fish_add_path $ANDROID_HOME/emulator
fish_add_path $ANDROID_HOME/platform-tools
fish_add_path $ANDROID_HOME/tools
fish_add_path $ANDROID_HOME/tools/bin

# volta 設定
fish_add_path $HOME/.volta/bin

# go 設定
fish_add_path $HOME/go/bin

# rbrenv config
fish_add_path $HOME/.rbenv/shims
status --is-interactive; and source (rbenv init -|psub)

# cmd abbr
abbr lsis 'gh issue list -a $GITHUB_UNAME'
abbr g 'git'
abbr python 'python3'
abbr rm 'trash' # 削除防止
abbr ls 'lsd' # rich ls command
abbr la 'lsd -la'
abbr ll 'lsd -latg'
abbr cat 'bat' # rich cat command
abbr find 'fd' # rich find command
abbr ps 'procs'
abbr du 'dust' # rich du command
abbr df 'duf' # rich df command
abbr top 'btm'
abbr grep 'rg'
abbr bw 'volta run --node 19 bw'
abbr man 'tldr'

# 環境変数を改行区切りで表示
abbr pathls 'echo $PATH | tr " " "\n" | nl'
abbr pathfish 'echo $fish_user_paths | tr " " "\n" | nl'
abbr env 'env | sort'

# 起動エイリアス
abbr lg 'lazygit'
abbr ld 'lazydocker'
abbr lq 'lazysql'
abbr vim 'nvim'
abbr vi 'vim'
abbr sfish 'source ~/.config/fish/config.fish'
abbr osaka 'curl wttr.in/Osaka'
abbr ghsum '~/dotfiles/claude/scripts/gh-summary.sh'
abbr go 'richgo'
abbr vmsc 'VBoxManage startvm CentOS --type headless'
abbr vmsu 'VBoxManage startvm Ubuntu --type headless'
abbr vmdc 'VBoxManage controlvm CentOS shutdown --force'
abbr vmdu 'VBoxManage controlvm CentOS shutdown --force'
abbr neorok 'ssh -R28083:192.168.56.2:8085 neorok'
abbr neorok2 'ssh -R28083:192.168.56.6:8085 neorok'

# cd directory
abbr config 'cd ~/dotfiles; nvim fish/neo-config.fish'
abbr dic 'cd ~/google-dict; nvim'
abbr calc 'cd ~/dev/github.com/lobin-z0x50/NeoCalc/CalcLibCore/Takao; nvim'
abbr ssh_config 'nvim ~/.ssh/config'
abbr aws_config 'nvim ~/.aws/credentials'

abbr . 'cd'
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .... 'cd ../../..'

# directory 追加のtouch
abbr dirch 'sh $HOME/dotfiles/fish/mkdir_touch.sh'

# ghqで設定したRootにあるディレクトリをfzfで選択してcd
abbr dev 'cd $(ghq root)/$(ghq list | fzf)'
abbr devr 'cd $(ghq root)/$(ghq list | fzf --layout=reverse)'
abbr cr 'coderabbit'
alias cr coderabbit # claude用

# pecoで選択したHostに接続
abbr sshl 'grep -w Host ~/.ssh/config | fzf --layout=reverse| awk \'{print $2}\' | xargs -o -n 1 ssh -A'

# rakel 引数指定なしだったらこれでOK
abbr rakel 'rake -T | fzf | awk \'{ print $2 }\' | xargs rake'

abbr taskl 'task -l | fzf | awk \'{ print $2 }\' | sed \'s/.$//\' | xargs task'

abbr saill './vendor/bin/sail artisan list --raw | fzf | awk '\''{ print $1 }'\'' | xargs -r -I {} ./vendor/bin/sail artisan {}'

abbr npml 'pnpm run | awk \'/^[[:space:]]+[a-zA-Z0-9:_-]+$/ {print $1}\' | fzf | xargs pnpm run'

# branch 移動
abbr col 'git br | fzf | xargs  git co'

# font一覧を検索する
abbr fonts 'lsd ~/Library/Fonts | fzf '

# dev2 のPGログイン
function dev2_pg
    PGPASSWORD=$(AWS_PROFILE=flyle-nexus-staging aws ssm get-parameter --region ap-northeast-1 --name /dev2/nexus/NEXUS_DATABASE_PASSWORD --with-decryption --query Parameter.Value --output text) psql -h localhost -p 15432 -U dev2_nexus -d dev2_nexus
end

starship init fish | source

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

# ~/.local/bin/mise activate fish | source # added by https://mise.run/fish

# pnpm
set -gx PNPM_HOME "/Users/takaokeita/Library/pnpm"
if not string match -q -- $PNPM_HOME $PATH
  set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
