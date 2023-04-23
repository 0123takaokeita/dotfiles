if [ ! -e ~/.config/nvim/lua ]; then
  # nvim のバックアップしておく。
  mv ~/.config/nvim ~/.config/nvim.bak
  mv ~/.local/share/nvim ~/.local/share/nvim.bak
  mv ~/.local/state/nvim ~/.local/state/nvim.bak
  mv ~/.cache/nvim ~/.cache/nvim.bak

  # astor インストール
  git clone --depth 1 https://github.com/AstroNvim/AstroNvim ~/.config/nvim

  # astro の user config のシンボリックリンク
  ln -fs $HOME/dotfiles/.config/nvim/astro/user $HOME/.config/nvim/lua/user
fi
