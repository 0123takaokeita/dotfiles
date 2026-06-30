#!/bin/sh
# Claude Code の設定を dotfiles で管理するためのシンボリックリンクを張る。
# wezterm / tmux などと同じ方式: dotfiles 側を実体とし、~/.claude へ ln する。
#
# 使い方:
#   sh ~/dotfiles/claude/setup.sh

set -eu

DOTDIR="$HOME/dotfiles/claude"
CLAUDE="$HOME/.claude"

mkdir -p "$CLAUDE"

# link <src> <dst>
#   既存の実体（ファイル/ディレクトリ）があれば *.bak に退避してからリンクする。
#   既にリンク済みなら張り直すだけ。
link() {
  src="$1"
  dst="$2"
  if [ -L "$dst" ]; then
    rm -f "$dst"
  elif [ -e "$dst" ]; then
    echo "backup: $dst -> $dst.bak"
    rm -rf "$dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -s "$src" "$dst"
  echo "linked: $dst -> $src"
}

# 単体ファイル
link "$DOTDIR/settings.json" "$CLAUDE/settings.json"
link "$DOTDIR/CLAUDE.md"     "$CLAUDE/CLAUDE.md"
link "$DOTDIR/statusline.py" "$CLAUDE/statusline.py"

# ディレクトリ単位
link "$DOTDIR/hooks"    "$CLAUDE/hooks"
link "$DOTDIR/scripts"  "$CLAUDE/scripts"
link "$DOTDIR/commands" "$CLAUDE/commands"

echo "done."
